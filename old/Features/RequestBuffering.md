# Feature: Request Buffering

  - **Goal**: Add configuration option to have Squid buffer requests
    with bodies, to remove burden of slow clients from back-end servers
    (usually for accelerator deployments).

  - **Status**: Started

  - **ETA**: late October, 2008

  - **Version**: 2.8

  - **Developer**:
    [AdrianChadd](/AdrianChadd)

  - **More**:

## Details

Buffering to memory is easiest, but will require a config option that
controls the max per-request memory used for buffering (e.g.,
request_buffer 8 KB would buffer up to 8K of a request body, then go
forward whether or not the whole body has been received).

Buffering to disk would be more complex to implement, but would probably
be more robust.

[CategoryFeature](/CategoryFeature)
