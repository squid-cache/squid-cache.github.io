##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Embedded content adaptation plugins (eCAP) =

 * '''Goal''':  Improve Squid3 content adaptation performance by 20+%, remove the need for an ICAP server
 * '''Version''': Squid 3.1
 * '''Status''': In progress; part1 submitted for Squid HEAD inclusion
 * '''ETA''': May 31, 2008
 * '''Developer''': AlexRousskov
 * '''More''': [http://wiki.squid-cache.org/SquidFaq/ContentAdaptation#head-b3e83ccdb647537404a70d9c17c87463524a470b context], [http://devel.squid-cache.org/projects.html#eCAP code]


== API sketch ==

The following is a very rough and outdated sketch of the proposed adaptation module API. The code was taken from the Traffic Spicer module API that is known to work in an ICAP server context. We will need to adjust this to better match the proxy context.

Each module would need to link with an eCAP library. Upon loading, the module would create an object, which class was derived from the following !ContentAdapter interface:

{{{

// interface for all content adapters
class ContentAdapter {
    public:
        ContentAdapter();          // registers with Squid
        virtual ~ContentAdapter(); // unregisters

        // throw Texc on failure
        // CfgRecord will probably be a list of strings
        virtual void configure(const CfgRecord &cfg) = 0;
        virtual void reconfigure(const CfgRecord &cfg) = 0;

        // create transaction-specific parameters or context
        virtual Params *makeParams();

        // prepare to handle adapt() calls
        virtual void start();

        // called once each main-loop iteration
        virtual void mainLoopStep(Time &timeout);

        // must set p.state and
        // may adjust p.out and p.messages accordingly
        virtual void adapt(Params *p) = 0;

        // returns the method corresponding to the ICAP request URI
        // XXX: Will change as eCAM does not have ICAP OPTIONS.
        virtual string method(const Uri &requestUri) const = 0;

        // breif adapter "gist" for reporting/logging purposes
        virtual string description() const = 0;

        // short string (e.g., version) used for ISTag formation;
        // may be empty
        virtual string tag() const = 0;

        // number of open FDs that are not using Squid comm APIs
        // XXX: Do we need this? Needed in ICAP for Max-Connections
        virtual int extraFds() const;
};

}}}

== Compatibility with other proxies and ICAP servers ==

An ideal API would let other proxies and ICAP servers to implement the same interface and support the same modules without source code modifications. The module would just need to be recompiled against another proxy or server library, and even that may be optional if the module code does not use non-eCAP features of its host.

We may never reach that ideal because HTTP message representation differs from host to host (and we do not want to re-parse messages), but we may be able to come close.

----
CategoryFeature
