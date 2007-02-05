##master-page:CategoryTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

== New Store API for Squid-2 ==

=== Introduction ===

The Storage API in Squid-2 has many serious shortcomings which limits performance and possibilities. The aim of this particular rewrite isn't to make something thats "next generation" but instead is something "better" than what we have. The replacement Store API should enable further development in other areas of the codebase which will then feed into further storage area development.

=== Current API ===

==== Object Lookup / Management ====
 * StoreEntry * new_StoreEntry(int mem_obj_flag, const char *url)
 * void destroy_StoreEntry(void *data)
 * void storeHashInsert(StoreEntry *e, const cache_key *key)
 * void storeLockObject(StoreEntry *e)
 * void storeReleaseRequest(StoreEntry *e)
 * void storeUnlockObject(StoreEntry *e)
 * StoreEntry * storeGet(const cache_key *key)
 * StoreEntry * storeGetPublic(const char *uri, const method_t method)
 * StoreEntry * storeGetPublicByRequestMethod(request_t * req, const method_t method)
 * StoreEntry * storeGetPublicByRequest(request_t * req)
 * void storeSetPrivateKey(StoreEntry * e)
 * void storeAddVary(const char *url, const method_t method, const cache_key * key, const char *etag, const char *vary, const char *vary_headers, const char *accept_encoding)
 * void storeLocateVaryDone(VaryData * data)
 * void storeLocateVary(StoreEntry * e, int offset, const char *vary_data, String accept_encoding, STLVCB * callback, void *cbdata)
 * void storeSetPublicKey(StoreEntry * e)
 * StoreEntry * storeCreateEntry(const char *url, request_flags flags, method_t method)
 * void storeExpireNow(StoreEntry * e)
 * int storeCheckCachable(StoreEntry * e)
 * void storeComplete(StoreEntry * e)
 * void storeAbort(StoreEntry * e)
 * void storeRelease(StoreEntry * e)
 * int storeEntryLocked(const StoreEntry * e)
 * void storeNegativeCache(StoreEntry * e)
 * int storeEntryValidToSend(StoreEntry * e)
 * void storeTimestampsSet(StoreEntry * entry)
 * void storeRegisterAbort(StoreEntry * e, STABH * cb, void *data)
 * void storeClientUnregisterAbort(StoreEntry * e)
 * void storeSetMemStatus(StoreEntry * e, int new_status)
 * const char * storeUrl(const StoreEntry * e)
 * void storeCreateMemObject(StoreEntry * e, const char *url)
 * void storeBuffer(StoreEntry * e)
 * void storeBufferFlush(StoreEntry * e)
 * squid_off_t objectLen(const StoreEntry * e)
 * squid_off_t contentLen(const StoreEntry * e)
 * HttpReply * storeEntryReply(StoreEntry * e)
 * void storeEntryReset(StoreEntry * e)
 * void storeDeferRead(StoreEntry * e, int fd)
 * void storeResumeRead(StoreEntry * e)
 * void storeResetDefer(StoreEntry * e)

==== Client-side ====

 * store_client * storeClientRegister(StoreEntry *e, void *owner)
 * void storeClientUnregster(store_client *sc, StoreEntry *e, void *owner)
 * void storeClientCopy(store_client *sc, StoreEntry *e, squid_off_t seen_offset, squid_off_t copy_offset, size_t *size, char *buf, STCB *callback, void *data)
 * int storeClientCopyPending(store_client * sc, StoreEntry * e, void *data)
 * squid_off_t storeLowestMemReaderOffset(const StoreEntry * entry)
 * void InvokeHandlers(StoreEntry * e)
 * int storePendingNClients(const StoreEntry * e)


 
==== Server-side ====

 * void storeAppend(StoreEntry *e, const char *buf, int len)
 * void storeAppendPrintf(StoreEntry * e, const char *fmt,...)
 * void storeAppendVPrintf(StoreEntry * e, const char *fmt, va_list vargs)
 
