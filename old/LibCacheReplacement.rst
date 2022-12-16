based on a discussion at a local postgresql user group last week..

Could we factor out the cache management routines in a sane generic library - for C, and then bind to it from language-Foo. (rather like libevent) ?

There are two major aspects to this - one is the cache replacement policies, the other is storage and indexing of data in the cache. Squids internals are best factored on the replacement policies, so lets start there.

Heres the current API for squids replacement 'library' :

{{{
struct _RemovalPolicy
{
    // string name for the policy style, for dynamic configuration
    const char *_type;
    // opaque policy owned storage
    void *_data;
    // free the policy
    void (*Free) (RemovalPolicy * policy);
    // inform the policy an item has been added.
    void (*Add) (RemovalPolicy * policy, StoreEntry * entry, RemovalPolicyNode * node);
    // or removed
    void (*Remove) (RemovalPolicy * policy, StoreEntry * entry, RemovalPolicyNode * node);
    // someone has referenced an item
    void (*Referenced) (RemovalPolicy * policy, const StoreEntry * entry, RemovalPolicyNode * node);
    // someone has dereferenced an item
    void (*Dereferenced) (RemovalPolicy * policy, const StoreEntry * entry, RemovalPolicyNode * node);
    // someone wants to iterate the cache in policy defined order
    RemovalPolicyWalker *(*WalkInit) (RemovalPolicy * policy);
    // remove purgable items please.
    RemovalPurgeWalker *(*PurgeInit) (RemovalPolicy * policy, int max_scan);
    // output statistics to a stream.
    void (*Stats) (RemovalPolicy * policy, StoreEntry * entry);
};

// syncronous iterator
struct _RemovalPolicyWalker
{   
    RemovalPolicy *_policy;
    void *_data;
    const StoreEntry *(*Next) (RemovalPolicyWalker * walker);
    void (*Done) (RemovalPolicyWalker * walker);
};  
   
// subclassed iterator for the purging code     
struct _RemovalPurgeWalker
{   
    RemovalPolicy *_policy;
    void *_data;
    int scanned, max_scan, locked;
    StoreEntry *(*Next) (RemovalPurgeWalker * walker);
    void (*Done) (RemovalPurgeWalker * walker);
};  

}}}

Now thats obviously not generic enough.

Heres a first cut at a generic one.

{{{

// generic parameterisation stuff
struct _LibraryParameters
{
  void *alloc(size_t bytes);
  void free (void *pointer);
  //... threads etc
  // may want to document a slab allocator interface as well/instead
};

struct _RemovalPolicy
{
    // string name for the policy style, for dynamic configuration
    const char *_type;
    // parameterisation for user functions
    LibraryParameters *systemcalls;
    // opaque policy specific and owned storage
    void *_data;
    // finalise the policy (allows static or on stack policies)
    void (*finalise) (RemovalPolicy * policy);
    // inform the policy an item has been added.
    void (*Add) (RemovalPolicy * policy, void const * entry, RemovalPolicyNode * node);
    // or removed
    void (*Remove) (RemovalPolicy * policy, void const * entry, RemovalPolicyNode * node);
    // someone has referenced an item
    void (*Referenced) (RemovalPolicy * policy, void const  * entry, RemovalPolicyNode * node);
    // someone has dereferenced an item
    void (*Dereferenced) (RemovalPolicy * policy, void const * entry, RemovalPolicyNode * node);
    // someone wants to iterate the cache in policy defined order
    RemovalPolicyWalker *(*WalkInit) (RemovalPolicy * policy);
    // someone wants to iterate to remove purgable items.
    RemovalPurgeWalker *(*PurgeInit) (RemovalPolicy * policy, int max_scan);
    // output statistics & internal details to a stream.
    void (*Stats) (RemovalPolicy * policy, void (*write)(void * closure, char const *string));
};

// factory function for default initialisation
typedef int init_policy (RemovalPolicy *policy, LibraryParameters *systemcalls);

// syncronous iterator
struct _RemovalPolicyWalker
{   
    RemovalPolicy *_policy;
    void *_data;
    void const *(*next) (RemovalPolicyWalker * walker);
    void (*done) (RemovalPolicyWalker * walker);
};  
   
// subclassed iterator for the purging code     
struct _RemovalPurgeWalker
{   
    _RemovalPolicyWalker walker;
    int scanned, max_scan, locked;
};  

}}}
