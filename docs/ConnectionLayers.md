# Connection Layers

:warning: This page contains a very rough API sketch. No consensus has been
    established (or has failed to establish) regarding the direction of the
    corresponding APIs.

## Base hierarchy

```C++
// Interface for writing and reading protocol data.
class LowerIoLayer: virtual public AsyncJob
{
public:
    LowerIoLayer();
    virtual ~LowerIoLayer();

    // Chain appending point (i.e., the last LowerIoLayer).
    virtual LowerIoLayer &lastLower();

    // Chain termination point.
    virtual UpperIoLayer &lastUpper();

    // Complete asynchronous closure initiated by the upper layer.
    // This layer: Finish any pending operations and eventually call closeNow(),
    // followed by next->noteClosed().
    virtual void startClosing() = 0;

    // Complete immediate closure initiated by the upper layer.
    // This layer: Close everything immediately and synchronously.
    virtual void closeNow() = 0;

    // Initiate or continue the process of asynchronously filling readBuffer.
    // If input is exhausted, readBuffer.theEof is set.
    // If readBuffer becomes full, reading pauses until the next startReading() call.
    // Any readBuffer update is acknowledged with a call to next->noteReadSome().
    // Upper layer can empty our readBuffer at any time.
    virtual void startReading() = 0;

    // Initiate or continue the process of asynchronously emptying writeBuffer.
    // If we update writeBuffer, we call next->noteWroteSome().
    // If writeBuffer becomes empty, writing pauses until the next startWriting() call.
    // If writeBuffer is exhausted, writing stops.
    // Upper layer can append our writeBuffer at any time.
    virtual void startWriting() = 0;

    RdBuf readBuffer; // filled by us; emptied by the upper layer
    WrBuf writeBuffer; // filled by the upper layer; emptied by us

private:
    AsyncJobPointer<UpperIoLayer> next;
};


// Interface for deciding what protocol data to read and write.
class UpperIoLayer: virtual public AsyncJob
{
public:
    UpperIoLayer();
    virtual ~UpperIoLayer();

    virtual LowerIoLayer &lastLower() { return *prev; }
    virtual UpperIoLayer &lastUpper() { return *this; }

    // Initiate asynchronous closure, propagating it to lower levels as needed.
    // This layer: Finish any pending operations and eventually call closeNow().
    virtual void startClosing() = 0;

    // Initiate immediate closure, propagating it to lower levels as needed.
    // This layer: Close everything immediately and synchronously.
    virtual void closeNow() = 0;

    // The lower layer calls this it is ready for reading and writing.
    virtual void noteEstablished() = 0;

    // The lower layer calls this when new data (or theEof state) is available in its readBuffer.
    virtual void noteReadSome() = 0;

    // The lower layer calls this when some of its writeBuffer data has been written.
    virtual void noteWroteSome() = 0;

    // The lower layer calls this to signal the end of an asynchronous closure.
    virtual void noteClosed() = 0;

private:
    AsyncJobPointer<LowerIoLayer> prev;
};

// Transfer protocol interface:
// Reads lower protocol bytes and translates them into upper layer protocol.
// Translates upper layer protocol and writes the result using the lower layer protocol.
class MiddleIoLayer: public LowerIoLayer, public UpperIoLayer
{
public:
    /* LowerIoLayer and UpperIoLayer APIs */
    ~MiddleIoLayer() override {}
    LowerIoLayer *lastLower() override { return LowerIoLayer::lastLower(); }
    UpperIoLayer *lastUpper() override { return LowerIoLayer::lastUpper(); }
};

// Only the [last] UpperIoLayer may initiate the closing sequences, including
// both synchronous (closeNow()) and asynchronous (startClosing()).
```

## Specific layers

* LowerIoLayer: SocketLayer
* MiddleIoLayer: SocksLayer and SecurityLayer
* UpperIoLayer: HTTP/1, HTTP/2, FTP control, FTP data, etc. clients and server jobs


## Specific chains of layers

An HTTP/1 Client job communicating with a TLS origin server through a secure cache_peer behind a SOCKS proxy:

```
SocketLayer - SocksLayer - SecurityLayer (with origin) - SecurityLayer (with proxy) - HTTP/1 Client job
```

## TODO

* This docs/ConnectionLayers.md page may be misplaced. Move to docs/ProgrammingGuide/? Move to docs/DeveloperResources/? Start a new docs/notes/ directory?
