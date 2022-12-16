# Feature: ACL namespaces

  - **Goal**: Add namespaces (for example icap and http) for ACL types.

  - **Status**: In progress

  - **ETA**: unknown

  - **Version**:

  - **Developer**:
    [AlexeyVeselovsky](https://wiki.squid-cache.org/Features/AclNamespaces/AlexeyVeselovsky#)

  - **More**:

# Details

Squid has many ACL types. Many of those types apply to HTTP request or
response properties. Since ICAP transactions are using the same request
and response classes, many ACLs would work for them *as is*.

However, if we stuff ICAP headers into ACL objects and apply existing
ACL code to those ICAP headers, then the user will not be able to write
ACLs that look at HTTP headers inside the ICAP transaction. If we do the
opposite and stuff HTTP headers into ACL objects, then the user will not
be able to make decisions based on ICAP headers.

We should not duplicate the existing acltype support, of course. The
code should somehow provide the ACL with the right headers, depending on
the scope.

Non-ICAP options would have HTTP scope as the default. ICAP options may
require an explicit scope to avoid confusions.

Ideally, the design should allow for addition of other namespaces in the
future, but this is not critical.

# Configuration

Lets assume that the ACL object can store both ICAP and HTTP messages at
the same time. The user can specify which message the ACL should apply
to using a namespace or scope technique. For example, given a generic
rep\_status\_code ACL type (currently called http\_status), the user
should be able to say:

``` 
  acl bad_icap_response icap::rep_status_code 202
  acl bad_http_response http::rep_status_code 555
  icap_retry allow bad_icap_response
  icap_retry allow bad_http_response
  icap_retry deny all
```

# Troubleshooting

No currently known issues.

[CategoryFeature](https://wiki.squid-cache.org/Features/AclNamespaces/CategoryFeature#)
