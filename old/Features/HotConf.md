# Feature: Hot Configuration

  - **Goal**: To remove the many issues squid currently displays due to
    reconfigure via a full component shutdown/restart cycle.

  - **Status**: underway;

  - **ETA**: unknown

  - **Version**:

  - **Developer**:
    [AmosJeffries](https://wiki.squid-cache.org/Features/HotConf/AmosJeffries#)

# Details

Squid currently performs reconfigure by way of a simulated shutdown,
re-loading the config files, and restarting.

This causes many issues which are visible:

  - ports fully closed for a duration

  - memory leaks for SSL contexts, and other in-use objects

  - loss of information on in-transit requests

  - INVALID URL errors when protocol info disappears.

  - request denials when ACLs being checked disappear.

Related Bug reports:

  - [219](https://bugs.squid-cache.org/show_bug.cgi?id=219#)

  - [513](https://bugs.squid-cache.org/show_bug.cgi?id=513#)

  - [537](https://bugs.squid-cache.org/show_bug.cgi?id=537#)

  - [1545](https://bugs.squid-cache.org/show_bug.cgi?id=1545#)

  - [1946](https://bugs.squid-cache.org/show_bug.cgi?id=1946#)

  - [2110](https://bugs.squid-cache.org/show_bug.cgi?id=2110#)

  - [2460](https://bugs.squid-cache.org/show_bug.cgi?id=2460#)

  - [2570](https://bugs.squid-cache.org/show_bug.cgi?id=2570#)
    
      - A workaround is in use for memory-only caches, but this keeps
        resurfacing. Lately rock type dirs with SMP diskers is causing
        it again.
    
      - We need to obsolete
        [wccp2\_rebuild\_wait](http://www.squid-cache.org/Doc/config/wccp2_rebuild_wait#).

  - [2626](https://bugs.squid-cache.org/show_bug.cgi?id=2626#)

## State up to Squid-3.1

The plan begun during early 3.0 cycle was to re-work the existing
squid.conf parser to pass the syntax parsing into each component which
had better knowledge of the requirements.

The above plan halted for currently unknown reasons and was left
incomplete. It appears to split the parsing down a bit too deeply into
components for easy understanding. It also leads to code duplication as
minor parsing functions (undocumented\!) are missed by followup
developers and re-implemented at the per-component level. This is not a
good state and needs to be simplified in the redesign.

The old Squid-2 parser has a much clearer design, but suffers major
issues with component inter-dependencies. So needs to be split at least
partway down the track of the 3.0 design.

Also, neither of the current config parser designs can completely
resolve the set of issues so a new design is needed to replace both.
Integrating the simple option handling of the Squid-2 parser and the
per-component split of the initial Squid-3 parser.

## New Design for Squid-3.1+

The current work begun already in Squid-3.1 and building in with
[Features/SourceLayout](https://wiki.squid-cache.org/Features/HotConf/Features/SourceLayout#)
takes the Squid-3.0 parser idea of modular component config (each
sub-library has its own XX::Config object which holds only that
components configuration settings.

But also leaves the legacy parser per-type parsing function. Which
causes two layers to emerge:

  - the underlayer of legacy parser which handles file actions

  - the component layer of squid.conf option handlers

these are linked together at present by defining the legacy parser
handlers interface as wrapper functions/macro to the XX::Config object
methods.

The plan is to build on that modular design and create two master
objects:

### A XX::Config template or parent object

This object to provide virtual functions that register a handler for
each squid.conf option the component can parse (both current,
deprecated, and obsolete options).

The option handlers:

  - parse the squid.conf line for that option

  - produce clear and understandable error messages when a line is bad

  - produce clear warnings when an option is being deprecated

  - provide for migrating obsolete squid.conf options, a built-in
    [Features/ConfigUpdater](https://wiki.squid-cache.org/Features/HotConf/Features/ConfigUpdater#)

It also must provide an API for the startup, shutdown, reload, and
reconfigure processes. The reconfigure is in need of the most work.

As I see it the important part of reconfigure, is that a pre-reconfigure
and post-reconfigure call is made to each component so it can perform
any actions needed to prepare itself for parsing. And to cleanup/restart
if needed after parsing.

Major components may need to process their parsing results into a shadow
config during the reconfigure and perform a hot-swap that allows
existing requests to continue with the old config details and new ones
to use the updated config.

Some objects will need to be made ref-counted to prevent disappearance
when an updated config is hot-swapped into place:

  - http\_port definitions

  - SSL context settings

  - ACL lists

  - helper settings

  - auth settings

  - delay pools

  - store settings

  - (any others known please add)

The config object for each component needs to have a component
enable/disable flag or setting. This will allow run-time enabling and
disabling of components and additionally allow the shutdown/restart
logics to be improved and extended with async paths.

### A registry-style parser / component manager

A manager object to receive handler registrations and process the
low-level file reads needed to process squid.conf.

May also control the core startup/shutdown/restart/reconfigure/reload
actions currently done at global level by main.cc

## Results

When this is completed;

  - Components can be created semi-autonomously and 'dropped in' to the
    code base.

  - Each will manage its own set of squid.conf lines.

  - The startup procedure will take less than a second

  - reload will be a zero-downtime event

  - restart will be a zero-downtime event

  - shutdown will be a fast event

  - components such as auth and helpers will be reconfigurable

## Discussion

![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png) To
answer, use the "Discussion" link in the main menu

See [Discussed
Page](https://wiki.squid-cache.org/Features/HotConf/Features/HotConf#)

Thank you for setting up this page, Amos. Lots of good thoughts here.

One conceptual change I would recommend is to separate parsing from
configuration. If you look through your notes, a lot of them have to do
with how things are parsed and who is parsing them. This may be
important, but is not (should not be) related to hot reconfiguration.

We need a set of dumb configuration-holding objects created by parsers.
Those objects should have nothing to do with the runtime state of Squid.
During reconfiguration, the newly created configuration objects are fed
to their modules. The modules decide how to handle the reconfiguration,
but they should not deal with parsing problems while making that
decision. They should operate on and with configuration objects.

In pseudo C++, and simplifying a bit:

    // lifecycle
    void Module::init();
    void Module::configure(const Module::Config &cfg);
    void Module::reconfigure(const Module::Config &newCfg);
    void Module::shutdown();
    
    // parsing; probably static to avoid module creation  
    Module::Config *Module::Parse(const SquidDotConfTokenizer &text);

\--
[AlexRousskov](https://wiki.squid-cache.org/Features/HotConf/AlexRousskov#)

Good point, I can see the switchover case would need that separation of
data vs handlers. However I dislike the need to pass config objects to
them. manager will be the one doing the calls and we don't want the
manager to handle individual Config objects, only the current state of
processing and the current squid.conf line string.

NP: I envision startup to be just a special case of reconfigure. where
defaults are built into the ::Config constructors and used for first X
seconds until local config

My model is one where the object with API methods is either inherited or
templated from a master/shared object which provides the basic
tokenizing methods. Similar to Robs earlier attempt at a parser, but
without the call nesting going outside the currently parsing object.
(yes, I must make exception for ACL list already since they are tacked
on the end of many things, but after much browsing of the config I see
no others)

The parser is tightly wound with hot-conf since hot-conf is a desirable
and planned effect of the parsing design. Not the other way around. This
is needed to RefCount the objects shared between old conf and new conf.
Parser controls and uses both current and future dumb::Config to
determine what goes into future (a RefCounted clone of the current or a
new allocation). Indeed Parser controls whether there is a future object
or if its editing current on the spot (think err directory locations,
size limits, and other state-agnostic settings).

\--
[AmosJeffries](https://wiki.squid-cache.org/Features/HotConf/AmosJeffries#)

I am worried about several ideas expressed here but I may be just
misinterpreting what you are saying. I will provide specific sketches in
hope to make this discussion less vague and more structured.

I disagree that it is a good idea to keep parser tightly coupled with
configuration. There is certainly a way around it (see my sketch). We
would be significantly increasing the complexity of the overall design
if modules keep parsing and configuring at the same time. Also, if you
want to write module-specific test cases, the ability to create and
\[re\]configure a module without parsing is very valuable.

Refcounting has nothing to do with this issue, IMO. Refcounting is just
a low-level memory-saving mechanism, and we are discussing a high-level
API (which should work with or without refcounting).

The Parser should \_not\_ be editing "on the spot". It should always
create and fill brand new dumb configuration objects. It will spend a
little bit more memory compared to the current "stuff everything into
one global" design, but the spending is relatively small, temporary, and
results in several significant advantages, including the ability to
write clear reconfiguration code that can compare old and new
configuration objects, identify the differences, and decide whether hot
reconfiguration is possible.

I do not think it is a good idea to start running with defaults and then
reconfigure to the actual configuration values. It buys you nothing but
complexity because you still have to write initial configuration code
(the one that applies the defaults) and then perform possibly complex
reconfiguration.

Having initial configuration code also allows you to avoid implementing
true hot reconfiguration when necessary:

    // a sketch of a possible default implementation for modules
    void Module::reconfigure(const Config &newCfg) {
        shutdown();
        init();
        configure(newCfg);
    }

This approach allows for steady migration from the code that does not
support hot reconfiguration to the code that does. The minimum
requirement is to implement init/shutdown/configure, which is something
we need anyway.

Finally, I am not sure how the top-level \[re\]configuration manager
should look like, but I do not understand the problem of "handling
individual module configs" that your are referring to. Something like
this sketch might work:

    int main() {
        addModule(new Module1); // calls init() and registers
        addModule(new Module2); // calls init() and registers
        addModule(new Module3); // calls init() and registers
        addModule(new Module4); // calls init() and registers
        ...
    
        SquidConfig *cfg = parse();
        configure(*cfg);
    
        mainLoop();
    
        while (registered module container is not empty) {
            delete popModule(); // calls shutdown() and deregisters popped m
        }
    }
    
    // note how parsing is unaware of individual module and configuration
    // types
    SquidConfig *parse() {
        // I do not like the Tokenizer name here; the class does more than
        // just tokenizing because it allows to search for relevant lines
        SquidDotConfTokenizer tokenizer(...);
    
        SquidConfig *cfg = new SquidConfig; // collection of Module cfgs
        for each registered module m {
            // the module will find lines that belong to it by searching
            // for module-specific option names
            Config *moduleCfg = m->parse(tokenizer);
            cfg->add(moduleCfg);
        }
    
        if (tokenizer.unusedLines())
            throw "unclaimed config options";
    
        return cfg;
    }
    
    void configure(const SquidConfig &cfg) {
        for each registered module m {
            // find module configuration; hide this inside m->configure()?
            Config *mcfg = cfg.find(m);
    
            // configure the module
            m->configure(*mcfg);
        }
    }
    
    void reconfigure() {
        SquidConfig *newCfg = parse(...);
    
        for each registered module m {
            // find module configuration; hide this inside m->reconfigure()?
            Config *mcfg = newCfg->find(m);
    
            // reconfigure the module
            m->reconfigure(*mcfg);
        }
    
        delete newCfg; // or replace the old global refcounted pointer
    }

\--
[AlexRousskov](https://wiki.squid-cache.org/Features/HotConf/AlexRousskov#)

Aw, heck no. That leaves the configure startup/shutdown process outside
the main loop and inaccessible to async operations.

Have adjusted your example to be more what I mean:

    int main() {
        addModule(new Module1);
            // calls init() and registers "no_cache" as Store::??::parse_cache_acl(...) etc.
        addModule(new Module2);
            // calls init() and registers "adaptation_enable" as Adaptation::??::parse_enable(...) etc.
        ...
    
        SquidConfig::startConfigure();
        scheduleAsync(..., SquidConfig::parse(), ...); // as next job with zero time delay
        scheduleAsync(..., SquidConfig::doneConfigure(), ...); // as next job with zero time delay after parse...
    
        mainLoop();
    
    // I like this loop, however for code simplicity I think it should be its own async event 'shutdown'
        while (registered module container is not empty) {
            delete popModule(); // calls shutdown() and deregisters popped m
        }
    }
    
    // note how parsing is unaware of individual module and configuration
    // types AND even of individual line content tokens!!
    void parse() {
        SquidDotConfTokenizer tokenizer(...);
    
        for each tag = SquidDotConfTokenizer.nextLine() {
           // find handler for that named config option...
           if ( opt = find(tag)) 
               opt->parseHandler(tokenizer);
           else
               handleUnclaimedLine(tag, tokenizer)
        }
    
        if (tokenizer.unusedLines())
            throw "unclaimed config options";
    }
    
    // only used to prep-state during a true reconfigure
    void startConfigure() {
        for each registered module m {
            // find module configuration; maybe even hide this inside parse()
            cfg.startingConfigure();
        }
    }
    
    // used after any config changes from any source...
    void doneConfigure() {
        for each registered module m {
            // find module configuration; maybe even hide this inside parse()
            cfg.reconfigureCompleted();
        }
    }

    using namespace Module; // ...
    
    Module::Config *current;
    Module::Config *future;
    
    // NP: legacy code here might call its own shutdown() instead of the hot-conf clone().
    startConfigure()
    {
       future = current->clone();
        // maybe followup with any removals needed to reset the future config to 'unused state'
    }
    
    parse(tokeniser)
    {
        // parse tokeniser line into *future ...
    }
    
    // NP: _this_ is the entirety of hot-swap.
    // legacy code which did shutdown earlier will be doing its own restart() stuff here instead of hot-swap.
    reconfigureComplete()
    {
       if (!changed) {
          delete future;
          return;
       }
    
       // anything else needed to finish up with ...
       Module::Config *tmp = current;
       current = future;
       delete tmp;
    }

both layers are essentially the same in call meaning
Squid::startConfigure calls Module::startConfigure etc. BUT the
difference is that the scope of each method reduces from file to line
and increases in the amount of tokenizer interaction between these
layers.

The parsing tokenizer needs to be looked at separately as you pointed
out. But that is not relevant to the reconfigure scope of this feature.

\--
[AmosJeffries](https://wiki.squid-cache.org/Features/HotConf/AmosJeffries#)

Making configuration asynchronous is worth trying.

You have added "AND even of individual line content tokens" comment.
That was true in my sketch as well.

I do not think it is a good idea to limit module configuration API to
"one option at a time" and add an "module option registration"
interface. In my sketch the module knows its options and handles them
however it wants. There may be a common/shared code that a module can
reuse to handle one option at a time, of course, but I would not expose
that detail to the upper layer or force it on lower layers.

It is possible that two modules will need access to the same option, for
example. We also do not know the order in which the options should be
handled by the module (and that order can be dynamic so always using the
registration order is not good enough). Overall, it just adds complexity
and makes the interface more rigid than necessary.

The last bit in your sketch is about a possible way to implement
reconfiguration, I think. Again, I would not force that way on all
modules. I would just give them the new or "future" Module::Config
object and let them figure out how to handle the transition. The
arguments are very similar to the "one registered line at a time only"
objections above.

I feel it is critical to separate parsing from \[re\]configuration. We
should not even attempt to \[re\]configure Squid if parsing fails.
Parsing produces Module::Config objects, that have no effect other than
memory use. Most common errors are detected at this stage. If everything
is OK, all modules are asked to \[re\]configure themselves using these
Config objects. We can even go further and have three reconfiguration
steps:

1.  **Parsing** -- Module::parse(tokenizer) is called for all modules,
    producing Module::Config objects. Abort reconfiguration on errors.
    No changes to the current config.

2.  **Validation** -- Module::canReconfigure(cfg) is called for all
    modules, producing success/errors. Abort reconfiguration on errors.
    No changes to the current config.

3.  **Application** -- Module::reconfigure(cfg) is called for all
    modules. Should not fail. Changes current config.

One of the biggest challenges here is handling dependencies between
modules, but having Module::Config objects free of side-effects will
help with that.

\--
[AlexRousskov](https://wiki.squid-cache.org/Features/HotConf/AlexRousskov#)

This bit confused me terribly...

    It is possible that two modules will need access to the same option, for example.

Do you mean 'access' by the dictionary meaning or do you actually mean
access to \_set\_ during reconfigure?

Name one instance where it's a good idea to load two components
simultaneously which use the same configuration line tag with different
option formats please?

If you mean two modules sharing the exact same options, then they need
to be created such that loading both at the same time does not clash and
their state is kept in-sync. This is not a problem for the Squid config
or parser should deal with.

Or should the shared line like `  asl bar src all ` be parsed separately
and stored separately for each component that needs to reference it?

``` 
 We also do not know the order in which the options should be handled by the module (and that order can be dynamic so always using the registration order is not good enough). Overall, it just adds complexity and makes the interface more rigid than necessary.
```

Huh? I make no such assumptions\! registration order is only relevant to
ensure that each squid.conf option/tag has a known object to receive it.

Hmm, yes we are facing different world aspects in this discussion. For
example some of your statements make me think you define 'option' as
something other that the 'acl' in "acl foo ... bar".

For the rest of it I think I'm seeing a little bit of what you mean, but
you appear to be not seeing the transition requirements. Lets lay out
the assumption/guarantees I'm making here and where they come from...

    I do not think it is a good idea to limit module configuration API to "one option at a time" and add an "module option registration" interface. In my sketch the module knows its options and handles them however it wants. There may be a common/shared code that a module can reuse to handle one option at a time, of course, but I would not expose that detail to the upper layer or force it on lower layers.

'one option at a time' is needed during the transition to prevent
breakage of the very many components which require things like this to
work:

``` 
 http_access allow foo
 acl bar src all
 http_access deny bar
```

When the transition is completed, that limit may be removed. In fact
with the model I'm proposing the 3-step process of
pre-config/config/post-config allows an easy way to make the above async
and/or parallel if so desired. Without forcing us to consider the
details of such usage right now.

We know that the squid.conf is order-specific. Some components make use
of that guarantee, some do not care. This is a detail of the upper layer
parse implementation. The lower design does (and only) needs to
guarantee that lines are passed to the component in the order they were
configured and component is notified when configuration is complete. see
above about sync/async again. The added bonus in this case is the
pre-config call to allow such things as shadow TheConfig to be created
and setup. Which does not yet exist at all in Squid.

What I'm reading you're saying: that we should code squid to handle
every possible option and disallow plugin components from doing their
own parse? to be handed a pre-filled object (which squid should not even
know the field format of\!) when reconfigure is needed.

I'm saying:

  - leave the parse details to the upper layer where the option details
    are known. Lower level only needs to pass the right option text
    buffer to the right component processor unit then move on to the
    next line.

  - configure is a process of three function calls pre/configure/post to
    warn the component whats about to happen. What gets done is not
    relevant to the lower layer.

I also took a look at breaking the line down into generic tokens and
passing the option handler a list. A both you and kinkie suggested. We
hit one major problem their. The exact nature of tokens to split on will
need to be hard-coded into squid. for now we use whitespace, but even
now there are exceptions to that. Some lines parse with or without
quoting, some do not. Others split on '=' as well as whitespace but only
for special portions of a line. Things like the ACL IP lists split on
'-' and '/' as well, again only in one part of the line. We simply
cannot make any assumptions as to what a component may need in a token.

    The last bit in your sketch is about a possible way to implement reconfiguration, I think. Again, I would not force that way on all modules. I would just give them the new or "future" Module::Config object and let them figure out how to handle the transition. The arguments are very similar to the "one registered line at a time only" objections above.

... so we instead force squid to know in advance of loading any
third-party module exactly what format its TheConfig class/structure
has? create a new one, Parse into it, and pass it back to the component?
in order to \_save\_ complexity? I don't believe I have to mention any
of the problems associated with that to you.

IMO thats \_way\_ more complexity and trouble than simply passing
squid.conf buffers to the component. You could I suppose go the way of
having pre-configure method/function return a void\* that gets passed
back.

BUT. since we can only be doing reconfigure or not doing reconfigure.
IMO again we should leave the TheConfig handling and details to the
component if it even needs them.

Consider the third-party black-box component Widget dynamically loaded
last configure time. In order to parse the widget\_magic lines which
part of the upper layer (squid) and lower-layer (component library)
whats the minimum transfer of information and call complexity we can do?

``` 
  squid:  'about to reconfigure'
  widget: '(void)
  squid:  'reconfigure your widget_magic with this line from squid.conf ...'
  squid:  'reconfigure your widget_magic2 with this line from squid.conf ...'
  widget:  'okay / error / abort'
  squid:  'done configuring.'
  widget:  'okay / error / abort'
```

    I feel it is critical to separate parsing from [re]configuration. We should not even attempt to [re]configure Squid if parsing fails. Parsing produces Module::Config objects, that have no effect other than memory use. Most common errors are detected at this stage. If everything is OK, all modules are asked to [re]configure themselves using these Config objects. We can even go further and have three reconfiguration steps:

at east we agree on that much. As you re-state my model with an
additional validation step, but no pre-setup for the component to create
its 'empty' TheConfig for us
![:)](https://wiki.squid-cache.org/wiki/squidtheme/img/smile.png)

Validation IMO should happen at the point of parsing. It's either a
valid parse or not, and the state produced should be expected to work.
If you like a separate meta-validate after everything is parsed into the
new TheConfig set to check dependencies etc, fine. I think it will turn
out to be very small, but it may be useful.

\--
[AmosJeffries](https://wiki.squid-cache.org/Features/HotConf/AmosJeffries#)

I am sorry, but do not follow most of your comments because I think you
are attacking a model that I am not proposing while discussing low-level
details that seem irrelevant to me. I suspect there is just basic
disconnect between our terminology and expressions that prevents us from
understanding each other and making progress. We need to step back, I
think.

We should either make smaller steps or discuss this online. I will try
the former first.

In my model, there are two most important design decisions:

1.  Each module has its own Config class (i.e., Module::Config),
    inherited from some common base ModuleConfig class. Only module M
    users know the details of M::Config. Others just know it is an
    instance of the base ModuleConfig class, with a few common methods
    for reporting and such. Configs from all modules are collected into
    one SquidConfig class, but that is not important in most cases. The
    exact shape of that SquidConfig class is not important for now.

2.  A module Config object has no runtime effect on Squid except when it
    is used as the "current" config for the module. For each module,
    many, possibly conflicting, Config objects might exist at the same
    time, but there is only one current config for each module and for
    Squid as a whole.

And there are three most important configuration and reconfiguration
steps:

1.  During the first step, each Module creates its Config object by
    parsing whatever squid.conf options are needed to be parsed for that
    module. Let's ignore how that parsing is done for now. Let's ignore
    how the module decides which parts of squid.conf are relevant to
    that module. Let's ignore how squid.conf is presented to the module.
    Created Config objects are assembled into a Squid Config object.
    Let's ignore how that is done and by whom. That Squid Config object,
    with no runtime effect, is the ultimate result of step1. If a module
    fails to produce a valid Config object, step1 aborts.

2.  During the second step, each module validates its Config object in
    the context of other Config objects where necessary. This step can
    be merged with step1, but it is better to keep it separate for
    several reasons. One reason is to allow for inter-module checks such
    as "My config option Foo requires option Bar in module M2. Is
    M2::Bar specified?". You cannot do such checks during parsing
    because module M2 may be creating its Config after we created ours.
    Also note that if some module decides to merge step1 and step2, it
    is free to do so. Such module will just always say "yes, this config
    is valid" for step2.

3.  During the third step, each module applies its Config object (i.e.,
    makes the supplied Config object "current"). This step must be
    separate and last because we do not want to leave Squid in a
    partially configured state. If squid.conf became invalid,
    reconfiguration should be a no-op (except error messages and such).

Ignoring all other details, do you see any serious problems with the
above?

\--
[AlexRousskov](https://wiki.squid-cache.org/Features/HotConf/AlexRousskov#)

Yes I think we are definitely talking to different things. I will try
harder to catch you on IRC about the fine details of the processing.

For now I will concentrate on your design for the config objects and
point out where I disagree instead of comparing:

``` 
 a. Each module has its own Config class (i.e., Module::Config), inherited from some common base ModuleConfig class. Only module M users know the details of M::Config. Others just know it is an instance of the base ModuleConfig class, with a few common methods for reporting and such. Configs from all modules are collected into one SquidConfig class, but that is not important in most cases. The exact shape of that SquidConfig class is not important for now.
```

You make 3 design choices above.

  - *Module::Config existence*. I agree and am coding with you in
    Features/SourceLayout for this.

  - *Module::Config inheriting from a base class*. May be useful if the
    API methods are to be virtual. The only use I see for this is the
    cachemgr config 'dump' display. I could go either way here.

  - *Module::Config being integrated into a Squid::Config*. This worries
    me. A \_lot\_ of the current dependency loops in Squid are directly
    caused by the existence of struct SquidConfig. I was under the
    impression that the cleanup work was dropping such dependency. We
    need to clarify this further.

<!-- end list -->

``` 
 b. A module Config object has no runtime effect on Squid except when it is used as the "current" config for the module. For each module, many, possibly conflicting, Config objects might exist at the same time, but there is only one current config for each module and for Squid as a whole.
```

I disagree with *For each module, many, possibly conflicting, Config
objects might exist at the same time*. I see no cause for more than 2 to
exist at the same time for any given module. One active config. One
shadow config being altered.

More than 2 config objects and we enter realms of state maintenance and
merge complexity which I strongly believe are unnecessary to even
consider allowing inside Squid.

I think we begin to differ wildly on the reconfiguring process.

I break step (1) down to show how/why we differ in view here and seek to
understand what you are talking about...

*1. During the first step, each Module creates its Config object by
parsing whatever squid.conf options are needed to be parsed for that
module.*

  - Agreed. So far we are mostly in-sync, only the meaning of *creates*
    vs *fills* could be confusion or difference.

<!-- end list -->

1.  *Let's ignore how that parsing is done for now.*
    
      - I get worried. But okay.
    
    b. *Let's ignore how the module decides which parts of squid.conf
    are relevant to that module.*
    
      - Here we hit a vital assumption. I don't think we \_can\_ ignore
        it.
    
      - How this happens defines critically whether we are doing **fill
        Module::Config** or **create Module::Config** (with strict state
        of existence meanings to those words).
    
      - How this happens defines large parts of the parser (okay we
        ignoring that).
    
      - How these decisions are made defines how many little
        Module::Config are left floating around inside Squid and how we
        reference to them.
    
      - How many ModuleX::Config instances we have defines how we handle
        correlating them back together.
    
    c. *Let's ignore how squid.conf is presented to the module.*
    
      - Another vital assumption. I don't think we can ignore this one
        either.
    
      - How this is presented defines what configuration states which
        can exist.
    
      - Backward compatibility adds a lot of constraints.
    
      - How the constraints are handled by the Module::Config states
        defines how relevant squid.conf parts are detected. (see the
        loop?)
    
    d. *Created Config objects are assembled into a Squid Config object.
    Let's ignore how that is done and by whom.*
    
      - Another vital assumption we can't just ignore.
    
      - IMO unnecessary as stated.
    
      - The only use I see here is to allow calling of the
        Module::Config API methods.
    
      - We need to clarify what you are trying to achieve with this.
    
      - This one defines whether or not we \_can\_ handle more than one
        Module::Config object at all.
    
      - Also defines the central core step of what is termed hot-config,
        which I thought we were aiming at a design for.
    
    e.*That Squid Config object, with no runtime effect, is the ultimate
    result of step1. If a module fails to produce a valid Config object,
    step1 aborts.*
    
      - IMO the super-object does not need to even exist as a data
        construct.
    
      - It can exist perfectly well as an information state.
    
      - Fatal error at any point up or down the configure system is a
        fatal error, not just the data currently held at sub-system
        terminus.

The other steps (2) and (3) only make sense under the basic assumptions
you are making for the above step. Until we agree on step (1) design I
think we should skip them.

\--
[AmosJeffries](https://wiki.squid-cache.org/Features/HotConf/AmosJeffries#)

Your first two worries are non-issues, I think:

    "Module::Config being integrated into a Squid::Config" worries me. A _lot_ of the current dependency loops in Squid are directly caused by the existence of struct SquidConfig. I was under the impression that the cleanup work was dropping such dependency. We need to clarify this further.

Integration does not mean we are going to have a struct comprising of
individual module configuration members. We may have a searchable
collection of ModuleConfig pointers (one for each module) or something
of that kind. The resulting SquidConfig class will not know about
individual modules. We most likely need a "single config" class so that
we can pass global configuration around to code that needs it.

For example, during validation step, some code may need access to
Module::Config objects from various modules and that code cannot just
ask modules themselves because those Module::Config objects have not
been applied/stored yet.

    I disagree with ''For each module, many, possibly conflicting, Config objects might exist at the same time''. I see no cause for more than 2 to exist at the same time for any given module. One active config. One shadow config being altered.

I agree that we probably do not need more than two Config objects per
module in the Squid executable. Some future configuration-related tools
might deal with more (e.g., some kind of a config upgrade tool with user
input capability and an undo or history operation).

From the design point of view, 2 or 22 should make no significant
difference at this stage though. I said "many" to emphasize that the
Config objects are not assumed to be well-known global singulars, tied
to their module state like we have them now (at best). They will be
"regular" objects that one could multiply as needed.

So these are settled, I think. Let's call that progress\!

\--
[AlexRousskov](https://wiki.squid-cache.org/Features/HotConf/AlexRousskov#)

I believe we have rough agreement on the high-level definition for the
first configuration step, despite that you think you cannot ignore some
of the details. As long as you agree that my high-level statements
\_may\_ be correct (if we do the details right), we are in agreement.

I think we can ignore most of what you are worried about until the
high-level steps are agreed upon. One can always ignore things until
there is nothing to argue about (with a risk that some high-level
decisions would have to be redone when details are considered)\!
However, let's try to nail at least two of these concerns now:

1\. I do not really understand the "creation versus fill" problem. I
think we will create \_and\_ fill. Clearly, the module will create its
own Config object: The module knows the actual Module::Config type. The
Configurator (i.e., Squid code performing the high-level configuration
steps) does not use and should not know that specific type. The created
object will then be filled with specific values based on the actual
configuration file. We cannot immediately create a filled object so this
"filling" process seems to be reasonable and necessary. Whether the
module code will fill Config or Config will fill itself is not important
for now.

2\. Existence of a "cumulative config" class called SquidConfig or
similar. Again, I doubt we can or should avoid it. C9 above gives one
motivation: cross-module config validation. We cannot check whether
future module M1 config is consistent with future module M2 config if we
do not have access to both future configs from the same place. Thus, we
need to store all future configs somewhere before we can validate and
apply them. That storage is SquidConfig. Other uses include reporting
and persistent storage: neither should know the list of all modules (by
name) and, hence, both would need some kind of "config container". I
hope the fact that I am not proposing a monolithic structure with
"Module1::Config c1; Module2::Config c2; ..." as members addresses your
corresponding concerns.

If the above is satisfactory, let's try to move on to step2 discussion
and come back to the lower-level details as needed.

\--
[AlexRousskov](https://wiki.squid-cache.org/Features/HotConf/AlexRousskov#)

[CategoryFeature](https://wiki.squid-cache.org/Features/HotConf/CategoryFeature#)
