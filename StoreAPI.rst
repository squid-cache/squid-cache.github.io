Draft Store API.

{{{
class StoreSearch : RefCountable
{
    /* callback upon a new StoreEntry being available */
    virtual void next(void (callback)(void *cbdata), void *cbdata) = 0;
    /* return true if a new StoreEntry is immediately available */
    virtual bool next() = 0;
    /* has an error occured ? */
    virtual bool error() const = 0;
    /* are we at the end of the iterator ? */
    virtual bool isDone() const = 0;
    /* retrieve the current store entry */
    virtual StoreEntry *currentItem() = 0;
};

class Store :  RefCountable
{
public:
    RefCount<StoreSearch> search (String const url, HttpRequest * request) = 0;
};
}}}

Current class hierarchy.

{{{
Store ----- StoreController
       +--- StoreHashIndex
       +--- SwapDir
       +--- UFSSwapDir
       +--- CossSwapDir
       +--- NullSwapDir
}}}

The current squid 2.5 capabilities are not yet changed. They are implemented by constructing the following memory structure of class instances

{{{
Store::Root() -- StoreController
                    |
                 StoreHashIndex
                    |
        +-----------+----+------+
        |
     UFSSwapDir   ...   ... .... ...
}}}

= Replacement policies = 
== as decorators ==
 * first a new class

{{{
class StoreLRU : public Store;
}}}
 * And when we build the in memory structure:
{{{
Store::Root() -- StoreController
                    |
                 StoreHashIndex
                    |
        +-----------+-----------+
        |           |
     StoreLru    StoreHeap ....
        |           |
     UFSSwapDir  UfsSwapDir ...
}}}

alternatively
{{{
Store::Root() -- StoreController
                    |
                 StoreLru
                    |
                 StoreHashIndex
                    |
        +-----------+-----------+
        |           |
     UFSSwapDir  UfsSwapDir ...
}}}
