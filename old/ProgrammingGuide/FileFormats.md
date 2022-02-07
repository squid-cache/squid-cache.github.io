# File Formats

## ''swap.state''

NOTE: this information is current as of version 2.2.STABLE4.

A *swap.state* entry is defined by the *storeSwapLogData* structure, and
has the following elements:

    struct _storeSwapLogData {
        char op;
        int swap_file_number;
        time_t timestamp;
        time_t lastref;
        time_t expires;
        time_t lastmod;
        size_t swap_file_sz;
        u_short refcount;
        u_short flags;
        unsigned char key[MD5_DIGEST_CHARS];
    };

  - op
    
      - Either SWAP\_LOG\_ADD (1) when an object is added to the disk
        storage, or SWAP\_LOG\_DEL (2) when an object is deleted.

  - swap\_file\_number
    
      - The 32-bit file number which maps to a pathname. Only the low
        24-bits are relevant. The high 8-bits are used as an index to an
        array of storage directories, and are set at run time because
        the order of storage directories may change over time.

  - timestamp
    
      - A 32-bit Unix time value that represents the time when the
        origin server generated this response. If the response
        
        has a valid *Date:* header, this timestamp corresponds to that
        time. Otherwise, it is set to the Squid process time when the
        response is read (as soon as the end of headers are found).

  - lastref
    
      - The last time that a client requested this object.
        
        Strictly speaking, this time is set whenver the StoreEntry is
        locked (via *storeLockObject()*).

  - expires
    
      - The value of the response's *Expires:* header, if any. If the
        response does not have an *Expires:* header, this is set to -1.
        If the response has an invalid (unparseable) *Expires:* header,
        it is also set to -1. There are some cases where Squid sets
        *expires* to -2. This happens for the internal netdb*object and
        for FTP URL responses.*
    
      - lastmod
        
          - The value of the response's Last-modified:
            
            header, if any. This is set to -1 if there is no
            
            Last-modified:
            
            *header, or if it is unparseable.*
        
          - swap\_file\_sz
            
              - This is the number of bytes that the object occupies on
                
                disk. It includes the Squid swap file header.
        
          - refcount
            
              - The number of times that this object has been accessed
                (referenced). Since its a 16-bit quantity, it is
                susceptible to overflow if a single object is accessed
                65,536 times before being replaced.
        
          - flags
            
              - A copy of the *StoreEntry* flags field. Used as a sanity
                check when rebuilding the cache at startup. Objects that
                have the KEY\_PRIVATE flag set are not added back to the
                cache.
        
          - key
            
              - The 128-bit MD5 hash for this object.
        
        Note that *storeSwapLogData* entries are written in native
        machine byte order. They are not necessarily portable across
        architectures.

# Store swap metadata Description

*swap meta* refers to a section of meta data stored at the beginning of
an object that is stored on disk. This meta data includes information
such as the object's cache key (MD5), URL, and part of the StoreEntry
structure.

The meta data is stored using a TYPE-LENGTH-VALUE format. That is, each
chunk of meta information consists of a TYPE identifier, a LENGTH field,
and then the VALUE (which is LENGTH octets long).

## Types

As of Squid-2.3, the following TYPES are defined (from *enums.h*):

  - STORE\_META\_VOID
    
      - Just a placeholder for the zeroth value. It is never used on
        disk.

  - STORE\_META\_KEY\_URL
    
      - This represents the case when we use the URL as the cache key,
        as Squid-1.1 does. Currently we don't support using a URL as a
        cache key, so this is not used.

  - STORE\_META\_KEY\_SHA
    
      - For a brief time we considered supporting SHA (secure hash
        algorithm) as a cache key. Nobody liked it, and this type is not
        currently used.

  - STORE\_META\_KEY\_MD5
    
      - This represents the MD5 cache key that Squid currently uses.
        When Squid opens a disk file for reading, it can check that this
        MD5 matches the MD5 of the user's request. If not, then
        something went wrong and this is probably the wrong object.

  - STORE\_META\_URL
    
      - The object's URL. This also may be matched against a user's
        request for cache hits to make sure we got the right object.

  - STORE\_META\_STD
    
      - This is the *standard metadata* for an object. Really its just
        this middle chunk of the StoreEntry structure:
        
        ``` 
                time_t timestamp;
                time_t lastref;
                time_t expires;
                time_t lastmod;
                size_t swap_file_sz;
                u_short refcount;
                u_short flags;
        ```

  - STORE\_META\_HITMETERING
    
      - Reserved for future hit-metering (RFC 2227) stuff.

  - STORE\_META\_VALID
    
      - ?

  - STORE\_META\_END
    
      - Marks the last valid META type.

## Implementation Notes

When writing an object to disk, we must first write the meta data. This
is done with a couple of functions. First, `storeSwapMetaPack()` takes a
*StoreEntry* as a parameter and returns a *tlv* linked list. Second,
`storeSwapMetaPack()` converts the *tlv* list into a character buffer
that we can write.

Note that the *MemObject* has a member called *swap\_hdr\_sz*. This
value is the size of that character buffer; the size of the swap file
meta data. The *StoreEntry* has a member named *swap\_file\_sz* that
represents the size of the disk file. Thus, the size of the object
content*is StoreEntry-\>swap\_file\_sz - MemObject-\>swap\_hdr\_sz;Note
that the swap file content includes the HTTP reply headers and the HTTP
reply body (if any).When reading a swap file, there is a similar process
to extract the swap meta data. First, `storeSwapMetaUnpack()` converts a
character buffer into atlv*linked list. It also tells us the value
for*MemObject-\>swap\_hdr\_sz*.**
