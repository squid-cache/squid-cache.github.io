# Feature: Adaptation Chains

  - **Goal**: Support multiple ICAP and eCAP services applied to a
    single master transaction, at a single vectoring point

  - **Status**: completed

  - **Version**: 3.1

  - **Priority**: 1

  - **Developer**:
    [AlexRousskov](/AlexRousskov#)

# Overview

This project adds support for static and dynamic chaining of adaptation
services. Static chaining is configured in *squid.conf*. The services in
the statically configured chain are always applied unless there is a
serious change in the master transaction status.

Dynamic chaining allows a "managing" ICAP service to determine the chain
of other adaptation services by specifying service names in the ICAP
response headers. Squid builds the service chain dynamically, based on
the first ICAP response.

# Availability

The feature has been added to Squid-3.1 from release 3.1.0.11.

[CategoryFeature](/CategoryFeature#)
