= Objects Report =

This report is a copy of the cache index. It can range from very large to '''extremely''' large depending on the size of your cache. You should check the '''info''' report to see how many Store''''''Entries (aka stored objects) you have before requesting this report.

|| <!> ||This will download to your browser a list of every URL in the cache and statistics about it. It can be very, very large.  ''Sometimes it will be larger than the amount of available memory in your client!'' You probably don't need this information anyway. ||

== Example Report ==
{{{
KEY D8A2697890F0BC9D18151FDF5ADA6300
	STORE_PENDING NOT_IN_MEMORY SWAPOUT_NONE PING_NONE   
	DELAY_SENDING,RELEASE_REQUEST,PRIVATE,VALIDATED
	LV:-1        LU:1328057884 LM:-1        EX:1328057884
	3 locks, 1 clients, 1 refs
	Swap Dir -1, File 0XFFFFFFFF
	GET cache_object://localhost/objects
	inmem_lo: 0
	inmem_hi: 213
	swapout: 0 bytes queued
	Client #0, (nil)
		copy_offset: 0
		copy_size: 4096
		flags:

KEY 573C7E5A9A9FAE6C8C46BC40252BBC70
	STORE_OK      IN_MEMORY     SWAPOUT_NONE PING_NONE   
	CACHABLE,VALIDATED
	LV:1328057882 LU:1328057882 LM:-1        EX:1328157882
	0 locks, 0 clients, 0 refs
	Swap Dir -1, File 0XFFFFFFFF
	GET http://www.iana.org/domains/example/
	inmem_lo: 0
	inmem_hi: 221
	swapout: 0 bytes queued

KEY A200D3F513067F80AED2F6C227886392
        STORE_OK      NOT_IN_MEMORY SWAPOUT_DONE PING_NONE
        CACHABLE,DISPATCHED,VALIDATED
        LV:1340097533 LU:1340097533 LM:1336584966 EX:-1
        0 locks, 0 clients, 1 refs
        Swap Dir 0, File 0X00D05A

KEY A200B3EDC0B23F6E166D4AEAFE01CE5A
        STORE_OK      NOT_IN_MEMORY SWAPOUT_DONE PING_DONE
        CACHABLE,DISPATCHED,VALIDATED
        LV:1341403589 LU:1341403589 LM:1340537596 EX:1351771589
        0 locks, 0 clients, 1 refs
        Swap Dir 0, File 0X01363C
}}}
