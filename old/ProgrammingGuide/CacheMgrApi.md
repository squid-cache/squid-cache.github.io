![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
This page is a work in progress. It reflects the discoveries by
[FrancescoChemolli](/FrancescoChemolli)
as it tries to implement the new cachemgr framework. It may contain
inaccurate informations.

# Cache Manager API

This document details how to implement a multi-cpu cache manager action
for Squid 3.2+, following the API framework implemented by
[AlexRousskov](/AlexRousskov).

# Overview

In order to correctly accumulate information across multi-cpu systems, a
framework is needed to accumulate the information across instances so
that it can be shown in summarized form to the user.

To that purpose, a few key classes need to be used

# Cache Manager Action Data

It is the blob of information that needs to be passed around instances
via IPC mechanisms to accumulate data. Its basic signature is:

    class MyModuleMgrActionData
    {
      MyModuleMgrActionData();
      MyModuleMgrActionData& operator += (const MyModuleMgrActionData&)
    
      type1 datamember1;
      type2 datamember2;
      //.. etc
    };

While this signature is not strictly mandatory - as it will be mostly
used by the couupled CacheManagerAction class, it is however recommended
to use it for consistency.

# Cache Manager Action

It is the module which gets activated when the cache manager framework
receives some action request by the user. Its basic signature is:

    #include "mgr/Action.h"
    class MyModuleMgrAction : public Mgr::Action
    {
    protected:
        MyModuleMgrAction(const Mgr::CommandPointer &cmd);
        virtual void collect();
        virtual void dump(StoreEntry* entry);
    
    public:
        static Pointer Create(const Mgr::CommandPointer &); // factorty method
        virtual void add(const Mgr::Action&);
        virtual void pack(Ipc::TypedMsgHdr&) const;
        virtual void unpack(const Ipc::TypedMsgHdr&);
    
    private:
        MyModuleMgrActionData data;
    };

where `Pointer` is defined in `Mgr::Action` as a refcounted pointer to
an action; `CommandPointer` is, likewise, a refcounted pointer to a
command.

The data member is used to accumulate data across squid instances.
Execution flow is:

1.  one instance gets the cachemgr request; it instantiates a
    MyModuleMgrAction via its static Create function

2.  (without going in too much detail) this Action's `run()` method
    calls each worker's `collect()` method

3.  collect() is supposed to fill in the data member of the
    MyModuleMgrAction with whatever data is relevant

4.  data is marshaled back to the coordinator process via `pack()` and
    `unpack()`

5.  the Coordinator process uses the Action's `add()` method to merge in
    information from all workers. The Action argument is really a
    polymorphic reference to the MyModuleMgrAction, and it can safely be
    dynamic\_cast to the right type

6.  once data is accumulated, the `dump()` method is called to print out
    the information.

`pack()` and `unpack()` can rely on the generic infrastructure available
through the IPC libraries, and so they in general will probably look
like this:

    void
    MyModuleMgrAction::pack(Ipc::TypedMsgHdr& msg) const
    {
        msg.setType(Ipc::mtCacheMgrResponse);
        msg.putPod(data);
    }
    
    void
    MyModuleMgrAction::unpack(const Ipc::TypedMsgHdr& msg)
    {
        msg.checkType(Ipc::mtCacheMgrResponse);
        msg.getPod(data);
    }

# Registration

XXX TODO

Discuss this page using the "Discussion" link in the main menu
