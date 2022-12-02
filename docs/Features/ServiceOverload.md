---
categories: ReviewMe
published: false
---
# Feature: Service Overload Handling (ICAP Max-Connections and more)

  - **Goal**: Make Squid behaviour during \[adaptation\] service
    overload configurable

  - **Status**: *In progress*; only Phase1 work is scheduled for now

  - **ETA**: May 2011

  - **Version**: Squid 3.2

  - **Developer**:
    [AlexRousskov](/AlexRousskov)
    [ChristosTsantilas](/ChristosTsantilas)

  - **More**:
    [bug 2055](http://bugs.squid-cache.org/show_bug.cgi?id=2055)

# Overview

Squid should support ICAP Max-Connections feature because it allows
Squid to bypass or wait for overloaded ICAP servers instead of crashing
those servers with more traffic. Similar overload handling features
would be useful for some slow eCAP services, especially optional ones.

Correct handling of Max-Connections is difficult both because the
interface is poorly specified (Does the maximum describe the server, the
service, or the client/server pair limit? Do pipelined requests count?),
because the best action is service-dependent, and because the number of
available connection slots may be a shared resource from SMP Squid point
of view. The first attempt to provide reliable Max-Connections support
has stalled due, in part, to some of the above complexities. This
project revives and extends that original effort.

The project is split in several phases to speed up feature availability
and track progress

# Phase 1: ICAP basics

Implement ICAP Max-Connections feature to limit the number of connection
opened by Squid to the ICAP service. If the service indicated the
Max-Connections threshold in its earlier OPTIONS response and the
threshold has been reached, Squid can be configured to do one of the
following:

  - Block: send and HTTP error response to the subscriber

  - Bypass: ignore the "over-connected" ICAP service

  - Wait: wait (in a FIFO queue) for an ICAP connection slot

  - Force: proceed, ignoring the Max-Connections limit

The configuration is done using
[icap_service](http://www.squid-cache.org/Doc/config/icap_service)
on-overload=block|bypass|wait|force parameter.

Currently, Squid ignores the Max-Connections limit, essentially
implementing the Force behaviour. The Wait option becomes the new
default behaviour for essential services and Bypass option becomes the
new behaviour for optional services.

Squid warns the first time a service becomes overloaded, indicating the
chosen Squid behaviour.

SMP Squid assumes that all workers share the same adaptation services
and will divide service-supplied Max-Connections value by the number of
workers to arrive at per-worker limit.

Developer notes: Use general adaptation service classes where possible
because similar support will be added to eCAP later. Be extra careful
with passing connection descriptors from the ICAP
[ServiceRep](/ServiceRep)
class to the waiting ICAP transaction because the transaction job may
terminate while the message with the descriptor is pending. We probably
need a custom Dialer that would return the descriptor to the
[ServiceRep](/ServiceRep)
object if the transaction is gone (or close it if both the service and
the transaction are gone).

# Phase 2: ICAP extras

Add support for max-conn service option to specify the Max-Connections
limit regardless of whether the service responds with its own idea what
the limit is.

Share the current number of service connections among the SMP workers.

Squid warns when a service becomes overloaded using some intelligent
algorithm to prevent too-frequent notifications (TBD).

# Phase 3: eCAP

Support eCAP Max-Connections meta header as well as max-conn and
on-overload
[ecap_service](http://www.squid-cache.org/Doc/config/ecap_service)
parameters, counting each concurrent eCAP transaction as "connection".

# Phase 4: Load balancing

Account for service being in an
[adaptation_service_set](http://www.squid-cache.org/Doc/config/adaptation_service_set)
when making bypass-related decisions for essential services. When the
first service in a set is overloaded, we should probably use the second
service instead of blocking the message or bypassing the services. In
other words, overload should be treated as a recoverable transaction
error, *provided* there are more services in the
[adaptation_service_set](http://www.squid-cache.org/Doc/config/adaptation_service_set)
to try. This approach would be useful for other adaptation errors as
well.

We could also add an
[adaptation_service_set](http://www.squid-cache.org/Doc/config/adaptation_service_set)
parameter to indicate whether all services in the set should be used in
a round-robin, least-loaded, next-on-failure, or reshuffle-on-failure
fashion.

[CategoryFeature](/CategoryFeature)
