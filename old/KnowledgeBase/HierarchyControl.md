# Hierarchy Control

**Synopsis**

Squid offers various mechanisms to control how requests are forwarded.
The most important are `never_direct`, `always_direct` and
`hierarchy_stoplist`. They interact with each other and with a request's
implicit characteristics to determine how a request will eventually be
satisfied.

**The Steps**

The various directives are evaluated in this order:

1.  `always_direct`
    
      - if it matches as *allow*, go to origin

2.  `never_direct`
    
      - if it matches as *allow*, go to a parent instead of origin in
        the cases below

3.  `hierarchy_stoplist`
    
      - if it matches as *allow*, go to origin

4.  determine if a request is hierarchic
    
      - if it is, check whether siblings or parents have the object via
        cache digests or ICP. In case of hit, ask the fastest among
        those hiting for the object

5.  go to origin

**What makes a request hierarchic**

The purpose of cache hierarchy is to maximize the chance of finding
objects in siblings, so a set of heuristics is applied to try and
determine in advance whether an object is likely to be cacheable. A few
objects are **not** cacheable, and are thus **not** hierarchic. Those
are:

  - reload requests

  - cache validations with non-Squid ICP peers

  - requests for HTTP methods other than `GET`, `HEAD` or `TRACE`

  - authenticated requests

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
