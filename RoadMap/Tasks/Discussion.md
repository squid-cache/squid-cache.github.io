See [Discussed
Page](https://wiki.squid-cache.org/RoadMap/Tasks/Discussion/RoadMap/Tasks#)

``` 
 Pick a system .h listed in compat/types.h and drop all other places its #include by src/* and includes/* 
```

This seems to be out-of-date and not needed anymore, as per
[Features/SourceLayout](https://wiki.squid-cache.org/RoadMap/Tasks/Discussion/Features/SourceLayout#).

``` 
    1. remove all uses of LOCAL_ARRAY() macro 
```

Many of those are good targets for post-
[Features/BetterStringBuffer](https://wiki.squid-cache.org/RoadMap/Tasks/Discussion/Features/BetterStringBuffer#)
integration. I propose to block until StringNg lands in tunk

\--
[FrancescoChemolli](https://wiki.squid-cache.org/RoadMap/Tasks/Discussion/FrancescoChemolli#)
