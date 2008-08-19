#language en


== C source guidelines ==
As per Squid2CodingGuidelines.

== C++ source formatting guidelines ==

format C++ source and header files with:
{{{
  astyle -cs4 -O --break-blocks -l <foo.cc>
}}}
== C++ style guidelines ==

header layout:
{{{
  class Foo{
  public:
    static methods
    member methods
   
    static variables
    member variables
  
  protected:
    static methods
    member methods
   
    static variables
    member variables
  
  private:
    static methods
    member methods
   
    static variables
    member variables
  };
}}}

== Mandatory coding rules ==

  * The Big Three: Every class that has one of (Destructor, copy constructor, assignment operator) must have all three. This includes ABC's, and derived classes.

== Suggested coding rules ==

  * No macros unless they are absolutely necessary
  * words in class names are capitalized, including the first word
  * Global variables, including static data members are capitalized
  * non global variables and methods should be capitalized after the first word.
  * getter and setter methods should be named '''get'''Somehing() and '''set'''Something(), methods testing some object state should be named '''is'''SomeState()

== Example ==

{{{
  class ClassName {
  public:
    static ClassName &Instance();
    void setFoo ( bool newState);
    bool isFoo() const;
  
  private:
    static ClassName TheInstance;
    bool flagForFoo;
  };
}}}

== File naming ==

  * .h files should only declare one class.
  * Any .h file should be parseable as a single translation unit (ie it includes it's dependent headers / forward declares classes as needed).
  * No two file names that differ only in capitalization
