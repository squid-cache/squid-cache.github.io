##master-page:DiscussionTemplate
#format wiki
#language en

See [[../|Discussed Page]]

## Please begin your contribution with "----" and an anchor for C# (incrementing the number for each comment) and end it with "-- AlexRousskov <<DateTime(2009-04-08T22:11:39-0700)>>"
## this will help for references. Append to discussion at the bottom of the page.
## You can quote using
## {{{
## text
## }}}

----
<<Anchor(C1)>>
Thank you for setting up this page, Amos. Lots of good thoughts here.

One conceptual change I would recommend is to separate parsing from configuration. If you look through your notes, a lot of them have to do with how things are parsed and who is parsing them. This may be important, but is not (should not be) related to hot reconfiguration.

We need a set of dumb configuration-holding objects created by parsers. Those objects should have nothing to do with the runtime state of Squid. During reconfiguration, the newly created configuration objects are fed to their modules. The modules decide how to handle the reconfiguration, but they should not deal with parsing problems while making that decision. They should operate on and with configuration objects.

In pseudo C++, and simplifying a bit:
{{{
    // lifecycle
    void Module::init();
    void Module::configure(const Module::Config &cfg);
    void Module::reconfigure(const Module::Config &newCfg);
    void Module::shutdown();

    // parsing; probably static to avoid module creation  
    Module::Config *Module::Parse(const SquidDotConfTokenizer &text);
}}}

-- AlexRousskov <<DateTime(2009-04-08T22:11:39-0700)>>
