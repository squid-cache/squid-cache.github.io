# Client Streams

## Introduction

A clientStream is a uni-directional loosely coupled pipe. Each node
consists of four methods - read, callback, detach, and status, along
with the stream housekeeping variables (a dlink node and pointer to the
head of the list), context data for the node, and read request
parameters - readbuf, readlen and readoff (in the body). clientStream is
the basic unit for scheduling, and the clientStreamRead and
clientStreamCallback calls allow for deferred scheduled activity if
desired. Theory on stream operation:

  - Something creates a pipeline. At a minimum it needs a head with a
    status method and a read method, and a tail with a callback method
    and a valid initial read request.

  - Other nodes may be added into the pipeline.

  - The tail-1th node's read method is called.

  - for each node going up the pipeline, the node either:

  - satisfies the read request, or

  - inserts a new node above it and calls clientStreamRead, or

  - calls clientStreamRead

There is no requirement for the Read parameters from different nodes to
have any correspondence, as long as the callbacks provided are correct.

  - The first node that satisfies the read request MUST generate an
    httpReply to be passed down the pipeline. Body data MAY be provided.

  - On the first callback a node MAY insert further downstream nodes in
    the pipeline, but MAY NOT do so thereafter.

  - the callbacks progress down the pipeline until a node makes further
    reads instead of satisfying the callback (go to 4) or the end of the
    pipe line is reached, where a new read sequence may be scheduled.

## Implementation notes

ClientStreams have been implemented for the client side reply logic,
starting with either a client socket (tail of the list is
clientSocketRecipient) or a custom handler for in-squid requests, and
with the pipeline HEAD being clientGetMoreData, which uses
clientSendMoreData to send data down the pipeline. client POST bodies do
not use a pipeline currently, they use the previous code to send the
data. This is a TODO when time permits.

## Whats in a node

Each node must have:

  - read method - to allow loose coupling in the pipeline. (The reader
    may therefore change if the pipeline is altered, even mid-flow).

  - callback method - likewise.

  - status method - likewise.

  - detach method - used to ensure all resources are cleaned up
    properly.

  - dlink head pointer - to allow list inserts and deletes from within a
    node.

  - context data - to allow the called back nodes to maintain their
    private information.

  - read request parameters - For two reasons:
    
      - To allow a node to determine the requested data offset, length
        and target buffer dynamically. Again, this is to promote loose
        coupling.
    
      - Because of the callback nature of squid, every node would have
        to keep these parameters in their context anyway, so this
        reduces programmer overhead.

## Method details

The first parameter is always the 'this' reference for the client stream
- a clientStreamNode \*.

### Read

Parameters:

  - clientHttpRequest \* - superset of request data, being winnowed down
    over time. MUST NOT be NULL.

  - offset, length, buffer - what, how much and where.

Side effects: Triggers a read of data that satisfies the
httpClientRequest metainformation and (if appropriate) the offset,length
and buffer parameters.

### Callback

Parameters:

  - clientHttpRequest \* - superset of request data, being winnowed down
    over time. MUST NOT be NULL.

  - httpReply \* - not NULL on the first call back only. Ownership is
    passed down the pipeline. Each node may alter the reply if
    appropriate.

  - buffer, length - where and how much.

Side effects: Return data to the next node in the stream. The data may
be returned immediately, or may be delayed for a later scheduling cycle.

### Detach

Parameters:

  - clienthttpRequest \* - MUST NOT be NULL.

Side effects:

  - Removes this node from a clientStream. The stream infrastructure
    handles the removal. This node MUST have cleaned up all context
    data, UNLESS scheduled callbacks will take care of that.

  - Informs the prev node in the list of this nodes detachment.

### Status

Parameters:

  - clienthttpRequest \* - MUST NOT be NULL.

Side effects: Allows nodes to query the upstream nodes for :

  - stream ABORTS - request cancelled for some reason. upstream will not
    accept further reads().

  - stream COMPLETION - upstream has completed and will not accept
    further reads().

  - stream UNPLANNED COMPLETION - upstream has completed, but not at a
    pre-planned location (used for keepalive checking), and will not
    accept further reads().

  - stream NONE - no special status, further reads permitted.

### Abort

Parameters:

  - clienthttpRequest \* - MUST NOT be NULL.

Side effects: Detachs the tail of the stream. CURRENTLY DOES NOT clean
up the tail node data - this must be done separately. Thus Abort may
ONLY be called by the tail node.

## More information

The
[transcript](/ClientStreams)
of the Squid IRC chat with Robert Collins (aka *lifeless*) discusses how
to use ClientStreams for content analysis.
