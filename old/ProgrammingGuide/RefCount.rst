#language en

<<TableOfContents>>

= Refcount Data Allocator (C++ Only) =


Manual reference counting such as cbdata uses is error prone,
and time consuming for the programmer. C++'s operator overloading
allows us to create automatic reference counting pointers, that will
free objects when they are no longer needed. With some care these 
objects can be passed to functions needed Callback Data pointers.

==  API ==


There are two classes involved in the automatic refcouting - a
''!RefCountable'' class that provides the mechanics for reference
counting a given derived class. And a '!RefCount' class that is the
smart pointer, and handles const correctness, and tells the !RefCountable
class of references and dereferences.

=== RefCountable ===


The !RefCountable base class defines one abstract function -
{{{deleteSelf()}}}. You must implement deleteSelf for each concrete
class and. deleteSelf() is a workaround for 'operator delete' not
being virtual. delete Self typically looks like:
{{{
void deleteSelf() const {delete this;}
}}}

=== RefCount ===


The !RefCount template class replaces pointers as parameters and 
variables of the class being reference counted. Typically one creates
a typedef to aid users.
{{{
class MyConcrete : public RefCountable {
  public:
    typedef RefCount<MyConcrete> Pointer;
    void deleteSelf() const {delete this;}
};
}}}
Now, one can pass objects of !MyConcrete::Pointer around.

=== 	CBDATA ===


To make a refcounting CBDATA class, you need to overload new and delete,
include a macro in your class definition, and ensure that some everyone
who would call you directly (not as a cbdata callback, but as a normal
use), holds a !RefCount<> smart pointer to you.
{{{
 class MyConcrete : public RefCountable {
   public:
     typedef RefCount<MyConcrete> Pointer;
     void * operator new(size_t);
     void operator delete (void *);
     void deleteSelf() const {delete this;}
   private:
     CBDATA_CLASS(MyConcrete);
 };
   
 ...
 /* In your .cc file */
 CBDATA_CLASS_INIT(MyConcrete);
 
 void *
 MyConcrete::operator new (size_t)
 {
   CBDATA_INIT_TYPE(MyConcrete);
   MyConcrete *result = cbdataAlloc(MyConcrete);
   /* Mark result as being owned - we want the refcounter to do the
    * delete call
    */
   cbdataReference(result);
   return result;
 }
   
 void
 MyConcrete::operator delete (void *address)
 {
   MyConcrete *t = static_cast<MyConcrete *>(address);
   cbdataFree(address);
   /* And allow the memory to be freed */
   cbdataReferenceDone (t);
 }
}}}

When no !RefCount<!MyConcrete> smart pointers exist, the objects
delete method will be called. This will run the object destructor,
freeing any foreign resources it hold. Then cbdataFree
will be called, marking the object as invalid for all the cbdata 
functions that it may have queued. When they all return, the actual
memory will be returned to the pool.

===  Using the Refcounter ===


Allocation and deallocation of refcounted objects (including those of
the !RefCount template class) must be done via new() and delete(). If a
class that will hold an instance of a !RefCount <foo> variable
does not use delete(), you must assign NULL to the variable before
it is freed. Failure to do this will result in memory leaks. You HAVE 
been warned.


Never call delete or deleteSelf on a !RefCountable object. You will
create a large number of dangling references and squid will segfault
eventually.


Always create at least one !RefCount smart pointer, so that the
reference counting mechanism will delete the object when it's not
needed.


Do not pass !RefCount smart pointers outside the squid memory space.
They will invariably segfault when copied.


If, in a method, all other smart pointer holding objects may be deleted
or may set their smart pointers to NULL, then you will be deleted 
partway through the method (and thus crash). To prevent this, assign
a smart pointer to yourself:
{{{
void
MyConcrete::aMethod(){
  /* This holds a reference to us */
  Pointer aPointer(this);
  /* This is a method that may mean we don't need to exist anymore */
  someObject->someMethod();
  /* This prevents aPointer being optimised away before this point,
   * and must be the last line in our method 
   */
  aPointer = NULL;
}
}}}


Calling methods via smart pointers is easy just dereference via ->
{{{
void
SomeObject::someFunction() {
  myConcretePointer->someOtherMethod();
}
}}}


When passing !RefCount smart pointers, always pass them as their 
native type, never as '*' or as '&amp;'. 
