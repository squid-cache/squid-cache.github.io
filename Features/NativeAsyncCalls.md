# Feature: Native support for asynchronous calls

  - **Goal**: Simplify code, improve debugging, improve ICAP
    performance, and prevent crashes from single transaction errors.

  - **Version**: 3.1

  - **Status**: complete

  - **Developer**:
    [AlexRousskov](https://wiki.squid-cache.org/Features/NativeAsyncCalls/AlexRousskov#)

  - **More**:
    [bug1912](https://bugs.squid-cache.org/show_bug.cgi?id=1912#),
    [bug2093](https://bugs.squid-cache.org/show_bug.cgi?id=2093#), and
    item 1 in
    [email109](http://www.squid-cache.org/mail-archive/squid-dev/200707/0109.html)

## Design sketch

This section summarizes design ideas for the asynchronous call
interface. Only a small fraction of what is discussed here has been
implemented so many changes are expected.

### The main loop

**High-level**: The main loop will continuously fire all asynchronous
calls until there are no calls left. Then, it will get the maximum wait
time from the time-based event queue and let "select" probe file
descriptors. The code sketch below outlines a single Main Loop
iteration:

    timeout = TheEvents.checkpoint();
    TheCalls.fireAllCalls();
    TheSelect.scan(timeout);

**More realistic:** In addition to the above, the event queue must be
re-checked if async calls were fired because the call(s) may take long
enough for a new event to become ready. Again, the code fragment below
is a single Main Loop iteration.

    do {
        timeout = TheEvents.checkpoint();
        something_has_changed = not TheCalls.empty();
        TheCalls.fire();
    } while (something_has_changed);
    
    TheSelect.scan(timeout);

### Firing a single call

Before firing an async call, Squid prepares to catch call exceptions. If
the call itself fails to fire (e.g., an event callback data became
invalid), Squid stops working with the call. If an exception is caught,
the call exception handler is called:

``` 
    try {
        if (!call->fire())
            return;
    }
    catch (const exception &e) {
        call->handleException(e);
    }
    call->end();
```

All async calls are fired in the same way. Individual call types provide
call-specific debugging information (in a similar format), call the
required code with stored parameters, and customize exception handling.

The actual code may also catch other exceptions with a *catch(...)*
clause.

### Callbacks

A Callback is information necessary to make a future call. Callbacks are
often used in Squid to register with a job or module to receive future
updates or other asynchronous notifications about important events.

It can be viewed as a half-baked Call: The call destination address and
possibly some parameters are known but the time of the call and possibly
some other parameters are not known and must be determined by the
caller.

The initial implementation will not optimize Callback representation and
just use Calls (with some parameters left unset) for Callbacks.

### Types of calls

Call destination kind determines call type. Supported destinations
include: an AsyncJob object method, other object method, and a global
static function.

Here is how AsyncJob call might implement its public methods:

    bool JobCall::fire() {
        AsyncJob *job = dynamic_cast<AsyncJob*>(theObject);
        if (job pointer is not valid) {
            debugs(section, level, "NOT Calling " << className << "::"
                << methodName << " method ...");
            return false;
        }
    
        debugs(section, level, "Entering " << className << "::" <<
            methodName << " method [" >> job->status () >> "]");
        (job->*)(theMethod)(...)
        return true;
    
    }
    
    void JobCall::end()
    {
    
        if (job->done()) {
            debug("Ending job [" >> job->status () >> "]");
            job->swanSing();
            delete job;
            debug("The " << className << "::" << methodName
                << " method  ended the job [" >> (void*)job >> "]");
            return;
        }
        debug("Exited " << className << "::" << methodName <<
            " method [" >> job->status () >> "]");
    }

The actual JobCall code will use more debugging and probably use more
ObjectCall (i.e., its parent) facilities):

Comm module will probably provide its own convenience classes to handle
"note your file descriptor is ready" type of calls.

## What creates asynchronous calls?

Any code can queue an asynchronous call at any time after TheCalls queue
is initialized. For example, any of the following calls may result in
new async call creations:

    TheEvents.checkpoint();  // when the event(s) time has come
    TheCalls.fireAll();      // when a call handler needs to call
    TheSelect.scan(timeout); // when descriptors are ready

## Challenges

There will be templates, macros, and/or code-generated classes that
handle arbitrary call destination addresses and calls with one, two, or
three parameters (at least). Designing a simple and efficient set of
wrappers without using a template-based library like
[Boost](http://www.boost.org/) will be tricky.

[CategoryFeature](https://wiki.squid-cache.org/Features/NativeAsyncCalls/CategoryFeature#)
