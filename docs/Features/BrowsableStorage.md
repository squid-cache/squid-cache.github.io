---
categories: WantedFeature
---
# Feature: Browsable File Storage?

- **Goal**: To add store so files can be saved at a directory matching
    their URL layout.
- **Status**: Not started.
- **ETA**: What is the estimated time of completion? Use either number
    of calendar days for not started features. Use an absolute date for
    started and completed features. Use *unknown* if unknown.
- **Version**: none yet

## Details

From IRC:
```irc
    14:55:07) derekv: One functionality I would like is (using .pdf as an example) to have all pdfs that are downloaded through the proxy to be stored in an archive that is seperate from the cache, and where they are normal files that can be for example indexed and searched.
    (14:55:47) derekv: (one way this could be organized is to put them in a file structure similar to how wget does it when doing recursive downloads)
    (14:56:33) derekv: Unless there is some way to configure this, the easy way seems to be to use squidsearch with a periodic script to extract the files and move them to the store
    (14:58:00) derekv: But it seems like it would be even more clever if squid could be aware of the separate store, eg, "if the requested file is a .pdf, look in pdf archive", thus the store would act as a cache as well.
    (14:58:30) derekv: I was wondering if this is possible or if there are any plugins like that?
    
    
    (15:04:47) amosjeffries: not at present. Squid does have pluggable FS though. A patch to squid-3 to add it would be welcome.
    (15:05:37) amosjeffries: you would need to consider ACL to limit what files get cached there, and what to do with variants of the same file though.
    
    (15:08:47) derekv: I had already thought of the later.
    (15:09:32) derekv: for the pdf example, always clobber is a viable option
    
    (15:12:32) amosjeffries: Also dynamic pages where the URL may be garbage, and/or the filename is not part of the URL itself (still locatable but not with path info).
```