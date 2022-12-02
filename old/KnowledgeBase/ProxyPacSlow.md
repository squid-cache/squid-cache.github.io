---
categories: ReviewMe
published: false
---
# Browser speed/lockup issues when using a proxy.pac auto configuration file

**Synopsis**

A "proxy.pac" auto configuration file is frequently used to configure
web browsers to use a web proxy under certain conditions. Various issues
can arise which can result in the web browser appearing slow or
unresponsive when attempting to resolve unknown domain names which seems
to only occur whilst using the auto configuration file.

**Symptoms**

  - accessing normal sites is fast; accessing an unknown site causes the
    browser to lockup for longer than a few seconds;

  - removing the proxy auto configuration file from the Browser
    configuration stops the problem; or

  - configuring the proxy directly stops the problem

**Explanation**

A variety of javascript files are available for use in the proxy.pac
file. One frequently used function is `isInNet()` which takes a
hostname, IP, netmask and returns true if the host IP is in the given
network/netmask range.

This requires the browser to perform a DNS lookup to map the given host
to an IP address before it can attempt the match.

Some browsers will do a seperate DNS lookup for each `isInNet()`
function call, resulting in a very long delay before finally completing
the proxy lookup. This can result in slow or non-functional web
browsing. **Workaround**

A javascript function is available to check whether the given host is
resolvable. For example:

    if (! isResolvable(host)) {
        return "PROXY proxy.example.com:3128";
    }

will force non-resolvable names to be forwarded to the proxy
immediately.

  - :warning:
    This should be included before any javascript functions which
    require a DNS lookup to be performed, such as `isInNet()`.

**Thanks**

Thanks to Brian Riffle `<riffle AT klamathcc DOT edu>` for reporting the
issue and successfully applying the suggested fix and David Gameau
`<David.Gameau AT unisa DOT edu DOT au>` for identifying the problem and
suggesting the workaround.

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
