# Feature: Adaptation logging

  - **Goal**: Log ICAP and eCAP transaction details

  - **Status**: complete

  - **Version**: 3.1

  - **Developer**:
    [AlexRousskov](/AlexRousskov#),
    Christos Tsantilas

  - **More**: [v3.0
    branch](https://code.launchpad.net/~rousskov/squid/3p0-plus)

# Details

HTTP transactions have access.log. ICAP and eCAP transactions need their
own log. Also, HTTP transactions affected by adaptations may need to log
adaptation-related details in access.log.

ICAP log uses *logformat* codes that make sense for an ICAP transaction.
Header-related codes are applied to the HTTP header embedded in an ICAP
server response, with the following caveats: For REQMOD, there is no
HTTP response header unless the ICAP server performed request
satisfaction. For RESPMOD, the HTTP request header is the header sent to
the ICAP server. For OPTIONS, there are no HTTP headers.

In addition to old *logformat* codes, the following format codes are
also available for ICAP logs:

``` 
        <icap_A         ICAP server IP address. Similar to <A.

        <icap_service_name      ICAP service name from the icap_service
                        option in Squid configuration file.

        icap_ru         ICAP Request-URI. Similar to ru.

        icap_rm         ICAP request method (REQMOD, RESPMOD, or 
                        OPTIONS). Similar to existing rm.

        >icap_size      Bytes sent to the ICAP server (TCP payload
                        only; i.e., what Squid writes to the socket).

        <icap_size      Bytes received from the ICAP server (TCP
                        payload only; i.e., what Squid reads from
                        the socket).

        icap_tr         Transaction response time (in
                        milliseconds).  The timer starts when
                        the ICAP transaction is created and
                        stops when the transaction is completed.
                        Similar to tr.

        icap_tio        Transaction I/O time (in milliseconds). The
                        timer starts when the first ICAP request
                        byte is scheduled for sending. The timers
                        stops when the last byte of the ICAP response
                        is received.

        icap_to         Transaction outcome: ICAP_ERR* for all
                        transaction errors, ICAP_OPT for OPTION
                        transactions, ICAP_ECHO for 204
                        responses, ICAP_MOD for message
                        modification, and ICAP_SAT for request
                        satisfaction. Similar to Ss.

        icap_Hs         ICAP response status code. Similar to Hs.

        >icap_h         ICAP request header(s). Similar to >h.

        <icap_h         ICAP response header(s). Similar to <h.Adaptation log fields include:
```

If ICAP is enabled, the following two codes become available for
access.log:

``` 
        icap_total_time Total ICAP processing time for the HTTP
                        transaction. The timer ticks when ICAP
                        ACLs are checked and when ICAP
                        transaction is in progress.

        <icap_last_h    The header of the last ICAP response
                        related to the HTTP transaction. Like
                        <h, accepts an optional header name
                        argument.  Will not change semantics
                        when multiple ICAP transactions per HTTP
                        transaction are supported.

        adaptation_xact_times  A comma-separated list of individual
                        related adaptation transactions response times,
                        in milliseconds. The order is to be defined
                        during implementation.
```

Please see *squid.conf.documented* for more details.

# Availability

Most of the features described here are unofficially available for Squid
v3.0 as a Launchpad
[branch](https://code.launchpad.net/~rousskov/squid/3p0-plus).
Adaptation logging features are committed to Squid and scheduled for
v3.1.0.11 release.

[CategoryFeature](/CategoryFeature#)
