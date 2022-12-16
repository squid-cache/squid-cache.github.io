This is a list of projects I'd like to work on on Squid, FIFO

1.  Enable compiling with extra warnings (-Wextra)

2.  Refactor code parsing URLs or pieces of URLs needs to use the
    AnyP::Url

3.  remove antipattern if (data) cbdataReferenceDone(data)

4.  Fix
    [ErrorState](https://wiki.squid-cache.org/FrancescoChemolli/SquidProjects/ErrorState#)
    constructors, unifying them

5.  netdb is preprocessor spaghetti, improve that

6.  turn removal interface from function pointers to virtual classes
