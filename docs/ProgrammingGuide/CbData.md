---
---
# Callback Data Allocator

Squid's extensive use of callback functions makes it very susceptible to
memory access errors. To address this all callback functions make use of
a construct called "cbdata". This allows functions doing callbacks to
verify that the caller is still valid before making the callback.

Note: cbdata is intended for callback data and is tailored specifically
to make callbacks less dangerous leaving as few windows of errors as
possible. It is not suitable or intended as a generic referencecounted
memory allocator.

## API

### CBDATA_TYPE

    CBDATA_TYPE(datatype);

Macro that defines a new cbdata datatype. Similar to a variable or
struct definition. Scope is always local to the file/block where it is
defined and all calls to cbdataAlloc for this type must be within the
same scope as the CBDATA_TYPE declaration. Allocated entries may be
referenced or freed anywhere with no restrictions on scope.

### CBDATA_GLOBAL_TYPE

    /* Module header file */
    external CBDATA_GLOBAL_TYPE(datatype);
    
    /* Module main C file */
    CBDATA_GLOBAL_TYPE(datatype);

Defines a global cbdata type that can be referenced anywhere in the
code.

### CBDATA_INIT_TYPE

    CBDATA_INIT_TYPE(datatype);
    /* or */
    CBDATA_INIT_TYPE_FREECB(datatype, FREE *freehandler);

Initializes the cbdatatype. Must be called prior to the first use of
cbdataAlloc() for the type.

The freehandler is called when the last known reference to a allocated
entry goes away.

### cbdataAlloc

    pointer = cbdataAlloc(datatype);

Allocates a new entry of a registered cbdata type.

### cbdataFree

    cbdataFree(pointer);

Frees a entry allocated by cbdataAlloc().

Note: If there are active references to the entry then the entry will be
freed with the last reference is removed. However,
cbdataReferenceValid() will return false for those references.

### cbdataReference

    reference = cbdataReference(pointer);

Creates a new reference to a cbdata entry. Used when you need to store a
reference in another structure. The reference can later be verified for
validity by cbdataReferenceValid().

Note: The reference variable is a pointer to the entry, in all aspects
identical to the original pointer. But semantically it is quite
different. It is best if the reference is thought of and handled as a
"void \*".

### cbdataReferenceDone

    cbdataReferenceDone(reference);

Removes a reference created by cbdataReference().

Note: The reference variable will be automatically cleared to NULL.

### cbdataReferenceValid

    if (cbdataReferenceValid(reference)) {
        ...
    }

cbdataReferenceValid() returns false if a reference is stale (refers to
a entry freed by cbdataFree).

### cbdataReferenceValidDone

    void *pointer;
    bool cbdataReferenceValidDone(reference, &amp;pointer);

Removes a reference created by cbdataReference() and checks it for
validity. A temporary pointer to the referenced data (if valid) is
returned in the \&pointer argument.

Meant to be used on the last dereference, usually to make a callback.

    void *cbdata;
    ...
    if (cbdataReferenceValidDone(reference, &amp;cbdata)) != NULL)
        callback(..., cbdata);

Note: The reference variable will be automatically cleared to NULL.

## Examples

Here you can find some examples on how to use cbdata, and why

### Asynchronous operation without cbdata, showing why cbdata is needed

For a asyncronous operation with callback functions, the normal sequence
of events in programs NOT using cbdata is as follows:
```c++
    /* initialization */
    type_of_data our_data;
    ...
    our_data = malloc(...);
    ...
    /* Initiate a asyncronous operation, with our_data as callback_data */
    fooOperationStart(bar, callback_func, our_data);
    ...
    /* The asyncronous operation completes and makes the callback */
    callback_func(callback_data, ....);
    /* Some time later we clean up our data */
    free(our_data);
```
However, things become more interesting if we want or need to free the
callback_data, or otherwise cancel the callback, before the operation
completes. In constructs like this you can quite easily end up with
having the memory referenced pointed to by callback_data freed before
the callback is invoked causing a program failure or memory corruption:
```c++
    /* initialization */
    type_of_data our_data;
    ...
    our_data = malloc(...);
    ...
    /* Initiate a asyncronous operation, with our_data as callback_data */
    fooOperationStart(bar, callback_func, our_data);
    ...
    /* ouch, something bad happened elsewhere.. try to cleanup
     * but the programmer forgot there is a callback pending from
     * fooOperationsStart() (an easy thing to forget when writing code
     * to deal with errors, especially if there may be many different
     * pending operation)
     */
    free(our_data);
    ...
    /* The asyncronous operation completes and makes the callback */
    callback_func(callback_data, ....);
    /* CRASH, the memory pointer to by callback_data is no longer valid
     * at the time of the callback
     */
```
### Asyncronous operation with cbdata

The callback data allocator lets us do this in a uniform and safe
manner. The callback data allocator is used to allocate, track and free
memory pool objects used during callback operations. Allocated memory is
locked while the asyncronous operation executes elsewhere, and is freed
when the operation completes. The normal sequence of events is:
```c++
    /* initialization */
    type_of_data our_data;
    ...
    our_data = cbdataAlloc(type_of_data);
    ...
    /* Initiate a asyncronous operation, with our_data as callback_data */
    fooOperationStart(..., callback_func, our_data);
    ...
    /* foo */
    void *local_pointer = cbdataReference(callback_data);
    ....
    /* The asyncronous operation completes and makes the callback */
    void *cbdata;
    if (cbdataReferenceValidDone(local_pointer, &amp;cbdata))
        callback_func(...., cbdata);
    ...
    cbdataFree(our_data);
```
### Asynchronous operation cancelled by cbdata

With this scheme, nothing bad happens if `cbdataFree` gets called before
fooOperantionComplete(...).
```c++
    /* initialization */
    type_of_data our_data;
    ...
    our_data = cbdataAlloc(type_of_data);
    ...
    /* Initiate a asyncronous operation, with our_data as callback_data */
    fooOperationStart(..., callback_func, our_data);
    ...
    /* foo */
    void *local_pointer = cbdataReference(callback_data);
    ....
    /* something bad happened elsewhere.. cleanup */
    cbdataFree(our_data);
    ...
    /* The asyncronous operation completes and tries to make the callback */
    void *cbdata;
    if (cbdataReferenceValidDone(local_pointer, &amp;cbdata))
        /* won't be called, as the data is no longer valid */
        callback_func(...., cbdata);
```
In this case, when `cbdataFree` is called before
`cbdataReferenceValidDone`, the callback_data gets marked as invalid.
When the callback_data is invalid before executing the callback
function, `cbdataReferenceValidDone` will return 0 and callback_func is
never executed.

### Adding a new cbdata registered type

To add new module specific data types to the allocator one uses the
macros CBDATA_TYPE and CBDATA_INIT_TYPE. These creates a local cbdata
definition (file or block scope). Any cbdataAlloc calls must be made
within this scope. However, cbdataFree might be called from anywhere.
```c++
    /* First the cbdata type needs to be defined in the module. This
     * is usually done at file scope, but it can also be local to a
     * function or block..
     */
    CBDATA_TYPE(type_of_data);
    
    /* Then in the code somewhere before the first allocation
     * (can be called multiple times with only a minimal overhead)
     */
    CBDATA_INIT_TYPE(type_of_data);
    /* Or if a free function is associated with the data type. This
     * function is responsible for cleaning up any dependencies etc
     * referenced by the structure and is called on cbdataFree or
     * when the last reference is deleted by cbdataReferenceDone /
     * cbdataReferenceValidDone
     */
    CBDATA_INIT_TYPE_FREECB(type_of_data, free_function);
```
### Adding a new cbdata registered data type globally

To add new global data types that can be allocated from anywhere within
the code one have to add them to the cbdata_type enum in enums.h, and a
corresponding CREATE_CBDATA call in cbdata.c:cbdataInit(). Or
alternatively add a CBDATA_GLOBAL_TYPE definition to globals.h as
shown below and use CBDATA_INIT_TYPE at the appropriate location(s) as
described above.
```c++
    extern CBDATA_GLOBAL_TYPE(type_of_data);        /* CBDATA_UNDEF */
```