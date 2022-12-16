= vm_objects Report =
VM Objects are the objects which are in Virtual Memory. These are objects which are currently being retrieved and those which were kept in memory for fast access (accelerator mode).

This may also include objects which are stored in the RAM cache (SquidConf:cache_mem) with no disk copy.

 <!> This is usually much smaller report than the full [[Features/CacheManager/Objects|objects]] report. But can still be very, very large.

== Example Report ==
{{{
KEY 8647602FCCBC865DC15C3DF4C5F2C115
	STORE_PENDING NOT_IN_MEMORY SWAPOUT_NONE PING_NONE   
	DELAY_SENDING,RELEASE_REQUEST,PRIVATE,VALIDATED
	LV:-1        LU:1328058169 LM:-1        EX:1328058169
	3 locks, 1 clients, 1 refs
	Swap Dir -1, File 0XFFFFFFFF
	GET cache_object://localhost/vm_objects
	inmem_lo: 0
	inmem_hi: 213
	swapout: 0 bytes queued
	Client #0, (nil)
		copy_offset: 0
		copy_size: 4096
		flags:

KEY FDB69EC852645CFA0524B0E287481733
	STORE_OK      IN_MEMORY     SWAPOUT_NONE PING_DONE   
	CACHABLE,DISPATCHED,VALIDATED
	LV:1328057880 LU:1328057882 LM:1297271595 EX:-1       
	0 locks, 0 clients, 1 refs
	Swap Dir -1, File 0XFFFFFFFF
	GET http://www.iana.org/domains/example/
	vary_headers: accept-encoding
	inmem_lo: 0
	inmem_hi: 3209
	swapout: 0 bytes queued
}}}
