An informal meeting was held over IRC on Jan 17th, 2009 in the
\#squiddev freenode channel. The main topic was
[StringNg](/Features/BetterStringBuffer/StringNg),
its implementation architecture and strategy for eventual merge into
Squid.

Participants:

  - rousskov is
    [AlexRousskov](/AlexRousskov)

  - kinkie is
    [FrancescoChemolli](/FrancescoChemolli)

  - amosjeffries is
    [AmosJeffries](/AmosJeffries)

  - adri is
    [AdrianChadd](/AdrianChadd)

  - lifeless is Robert Collins

  - Holocaine is Benno Rice

  - hno is
    [Henrik\_Nordström](/Henrik_Nordstr%C3%B6m)

Here's the discussion log.

``` irc
19:47 < rousskov> kinkie, do we need < and >? Have you found a use for them already?
19:47 < kinkie> Might be useful for STL container types.
19:47 < kinkie> sorted lists etc
20:11 < rousskov> kinkie, what is matchPrefix?
20:12 < kinkie> strncmp()
20:12 < kinkie> length is determined by the length of the argument.
20:13 < kinkie> (bounds checking is supposed to be an integral guarrantee to every call, so I'm not going to mention it from now on
20:37 < rousskov> kinkie, do you know whether we still need _SQUID_INLINE_ ?
20:40 < kinkie> I found it in live code, so I suppose we do
20:41 < kinkie> it may be debateable which calls to inline and which not
21:11 < rousskov> I hope we can remove the #define. Need to find somebody who knows which environment needed it. Perhaps it is in the commit logs.
21:11 < kinkie> which one? The _SQUID_INLINE_?
21:12  * rousskov nods.
21:12 < rousskov> Not specific to String, of course.
21:13 < kinkie> I understand it's an essential part of the .cci files.
21:13 < kinkie> The most knowledgeable person about it is robert
21:24 < rousskov> AFAICT, it just tells Squid whether to say "inline" or not. I have never seen an environment where "inline" did not work. I am sure they exist[ed], but I wonder if they are still relevant.
21:33 < kinkie> As far as I know that's not for portability.
21:33 < kinkie> Inlining can make debugging difficult. --disable-inline conifigure option will allow that.
21:34 < kinkie> It may also be helpful in small footprint environments, to save program memory
21:41 < rousskov> Popular compilers already have parameters to disable inlining.
21:42 < kinkie> you're right.. you may want to drop an RFC to -dev, there may be other reasons I don't know
21:45 < rousskov> Yeah.
22:18 < rousskov> Hm... The way you implemented SBuf, you do not really need StringNg.
22:19 < kinkie> It depends on where you want to draw the line.
22:19 < rousskov> I am trying to understand whether we should just merge the two classes or change SBuf so that StringNg is needed.
22:20 < kinkie> Well StringNg was implemented to address your concerns..
22:20 < rousskov> I know.
22:20 < kinkie> (in other words, my bias is clear)
22:21 < kinkie> I started by taking an OO-ized libC approach, as the API is well known and understood. This has obvious pros and cons.
22:21 < rousskov> Yes, you tried to address my concerns by adding a class named String, but you left the essential bits in SBuf, making String mostly useless
22:22 < kinkie> the only significant bits it has are those which are encoding-aware.
22:22 < kinkie> We could debate whether the Tokenizer should be buf- or string- oriente
22:23 < kinkie> oriented
22:24 < kinkie> But my ideal approach would be "buf is 8-bit-encoded, string is complex-encoded (via ucs-2)
22:24 < rousskov> and since we do not really support multiple encodings, String looks rather weird. That is, what it represents is invisible.
22:25 < kinkie> we do not really support multiple encodings YET
22:27 < rousskov> And, I suspect, we are not really designing well to support them either. My focus was different. Making eventual support for encodings easier was just a side-effect of what I was trying to achieve by the Buffer/String split.
22:28 < rousskov> With the current implementation, it is not clear to me (yet), whether the split is worth it. I need to think about it.
22:29 < kinkie> nod
22:29 < kinkie> Merging the two is rather trivial. Splitting differently is doable. I'll support either way.
22:29 < rousskov> I wanted a dumb Buffer and a smart String slicing and dicing that dumb Buffer. What you have implemented is smart Buffer and smart String.
22:30 < kinkie> well, slicing and dicing is a buffer thing
22:30 < rousskov> kinkie, in your implementation, yes.
22:34 < kinkie> at least now the reasons for discussions we've had in the past should be clearer..
22:35 < amosjeffries> so whats changed?
22:36 < kinkie> Alex was finally able to dig into the StringNg review
22:41 < amosjeffries> ah. no more code changes then?
22:41 < kinkie> No, not lately.
22:44 < kinkie> but the design is a bit different from what Alex thought it'd be.. there's more smarts in the SBuf than he'd think there'd be
22:44 < kinkie> (I'll let him elaborate further)
22:47 < rousskov> I found many secondary bugs. They are ready to be emailed, but I want to decide what to do with this first-level issue first.
22:52 < kinkie> nod
22:56 < rousskov> kinkie, how do you explain that both Buffer and String have a search method?
22:57 < kinkie> String proxies most Buffer methods. It should proxy almost all of them really.. It's virtually a heir class.
22:58 < rousskov> but why do we have search in both classes?
22:58 < kinkie> I'd like to be able to search both blobs and strings. For different purposes, but it makes sense.
22:58 < kinkie> E.g. 
22:59 < kinkie> You get a network buffer as a blob. You search for a delimiter, and decide that up to the delimiter you found it was a string.
22:59 < kinkie> (think HTTP request parsing..)
23:01 < kinkie> But then it doesn't make sense to have a String having less methods than the buffer you started with, does it?
23:01 < amosjeffries> sometimes it does kinkie.
23:01 < kinkie> sometimes yes.. but this time?
23:02 < amosjeffries> well see about this time during the rollout.
23:03 < kinkie> amosjeffries: nod
23:04 < rousskov> why not use String to search in an I/O buffer for an HTTP delimiter?!
23:04 < amosjeffries> We end up with SBuf being the widely used class and StringNg being the special case converted to only when its unusual functions are needed.
23:04 < amosjeffries> that sort of use a heir class makes more sense.
23:05 < amosjeffries> alex: String search should be limited to valid string chars no? binary has more available.
23:06 < amosjeffries> oop.  s/We end up with/We MAY end up with/
23:07 < kinkie> amosjeffries: re the wiki: there's an XMLRPC interface available, but I've never really investigated it.
23:07 < adri> yo
23:07 < adri> gah, etc.
23:07 < kinkie> hi adri
23:08 < amosjeffries> hi adri
23:08 < adri> still no hno?
23:09 < rousskov> I do not think we need String if I understand your intentions correctly
23:09 < adri> Hm, nope
23:09 < adri> Hm
23:10 < kinkie> rousskov: that was the original plan, yes
23:12 < rousskov> there were many original plans, but that is not important
23:12 < kinkie> yes
23:13 < rousskov> So I need to decide whether to recommend removing one of the classes or recommend moving to the plan where both make sense
23:14 < kinkie> yes
23:14 < kinkie> basically right now String is a marker.. its main meaning is just being there, to allow the caller to declare 'this is a string' or 'this is a blob'
23:16 < adri> hm
23:17 < rousskov> with virtually no visible difference between the two
23:17 < adri> Where's the current code being reviewed hiding?
23:17 < kinkie> lp:~kinkie/squid/stringng
23:18 < rousskov> adri, you wanted I/O (comm and such) code to create buffers as/when needed, right?
23:18 < adri> I'd like IO to be able to do scatter/gather IO on buffer references where needed
23:18 < adri> There'll end up havin gto be some vector type of region references
23:18 < kinkie> that would require the next step: SBufList
23:18 < adri> There's perfectly good vector types already in the STL iirc
23:19 < kinkie> yes
23:19 < adri> I don't think you need to create a new type just for a generic vector
23:19 < kinkie> adri: it may very well end up being a typedef in fact
23:19 < adri> Gods, where acn I browse the code already
23:19 < adri> ok, there
23:19 < rousskov> adri, and if you look at lp URL above, ignore the lower-level bugs like wrong parameter types, names, unneeded methods, etc. I already have a list of those. Concentrating on String/Buffer role split for now.
23:20 < adri> I'm just going to brush over it
23:20 < rousskov> adri, ignore scatter/gather I/O. Who is creating the I/O buffer? The caller or the I/O code?
23:20 < adri> I'm knee-deep in src/http.c
23:20 < adri> rousskov: who knows
23:21 < adri> rousskov: its not always that clear
23:21 < adri> rousskov: it depends really on how system-specific you want to get.
23:21 < rousskov> I thought you were proposing something rather specific.
23:21 < rousskov> Long time ago
23:22 < adri> rousskov: if you want to handle things like mmap() backed io for things like disk/sockets, then the IO code has to give you buffers
23:22 < rousskov> That's what you were probably talking about.
23:22 < adri> yeah.
23:22 < adri> As I said, its not always that clear.
23:22 < adri> Then if it -is- mmap() backing of things like say, just straight file contents
23:23 < adri> The IO code has to not only give you buffers, but there has to be some reasonably thorough tracking of whats where, so the IO code doesn't unmmap() active regions
23:23 < adri> In other cases, say its POSIX AIO, you give the IO system buffers
23:23 < adri> and it will fill them for you, and return
23:24 < adri> or even just our aio implementation, extended perhaps to include iovec read/write
23:25 < adri> for now, I'd not worry abut it too much, not for the majority of what this stuff is planned for
23:25 < adri> eventually it will matter for the memory store
23:25 < adri> well, the memory and disk store
23:25 < adri> but the amount of code you can tidy up by just allocating buffers from RAM normally, ignoring potential IO mappings, will be huge
23:25 < adri> and will make the next task - more optimal IO buffers - a lot easier
23:26 < adri> Almost all of the stuff you will want to tidy up - the network oriented stuff - will benefit from this just dodging malloc and copy overheads
23:27 < adri> (and the modifications to the codebase to handle that kind of async socket IO in particular is going to be uhm, scary.)
23:27 < rousskov> One thing that would make the String/Buffer split decision easier is to understand whether "an area of a Buffer" is still a Buffer or only a String. This boils down to, I think,  whether the I/O code would need to consume() the head of an I/O buffer.
23:28 < adri> doing consume at a level which makes sense to low level IO gets a bit silly, really
23:28 < adri> At the end of the day, the last thing you want to do is keep growing the tail of the buffer as you append
23:28 < adri> And you absolutely don't want to keep memcpy()'ing data to the head as you consume
23:28 < rousskov> If I/O code always deals with "complete" buffers and does not consume(), then Buffer does not need "offset", only "size"
23:29 < adri> Instead what I did, was have buffer's and buffer references different
23:29 < adri> so a buffer is just {buf, size, capacity, refcnt}
23:29 < adri> a bufregion is {buffer, offset, length}
23:29 < adri> and a string is a {bufregion, encoding, NULL terminated?}
23:30 < adri> an IO layer may actually only consume part of a buffer at a time
23:30 < adri> if you issue a nonblocking write, it may write part of the buffer
23:30 < adri> you could just not care and mark the whole region as taken until its completely written
23:30 < kinkie> rousskov: current implementation 'an area of a buffer' is a SBuf, which maps 1-1 to a String. consume() is realized by appending to a buffer tail and copying the unconsumed head when it can't grow anymore. The count of the copies is kept around to leave more and more headroom as the SBuf is used this way
23:31 < adri> but from teh point of view of the rest of the code, I made the three distinctions above specifically so I didn't use String except where things were actually to be treated as such, rather than an opaque region of memory
23:31 < adri> for example
23:32 < adri> If I have a buffer in src/http.c as the incoming reply buffer
23:32 < adri> I'll read into it, and possibly read/append some more
23:32 < adri> when I get a complete header set, I'll create strings off that
23:32 < adri> but I'll pass a bufregion containing "reply status + headers" to the store layer
23:32 < adri> and a second bufregion containing "reply body" to the store layer seperately
23:32 < adri> that will be from teh same buffer, but they mean seperate things
23:33 < adri> (then I have to worry about how to readv() into the end of a partially full buffer, and into the beginning of the next buffer, but that is chapter 2.)
23:34  * adri is still stuck in src/http.c hell :(
23:35 < kinkie> adri: what I did is more or less the same - except for the 
23:35 < kinkie> \0 at the end of strings
23:35 < adri> kinkie: the is_null is optional
23:35 < adri> kinkie: a "transition" thing
23:35 < kinkie> readv() and writev() require a vector buffer, which may be masked behind an interface...
23:36 < kinkie> nod
23:36 < adri> kinkie: \0'ed strings can be duped, but they can't be created by merely referencing another region
23:36 < kinkie> yes
23:36 < adri> kinkie: this is btw why I already have working code. :)
23:36 < kinkie> so the sbuf interface may very well use a vector backing store, possibly lazily reassembled. but that's chapter 4 :)
23:37 < adri> Nah
23:37 < adri> Don't extend it to do that
23:37 < adri> If you want that, extend string to do that
23:37 < adri> Don't extend sbuf to do that. :)
23:37 < adri> sbuf should just be "a reference counted region of memory with some way of filling it with gunk, and accessing it with bounds checking"
23:37 < adri> if you want to be able to build on top of that, do so. :)
23:39 < kinkie> adri: sbuf is the refcounter, not the refcountee.. sbufstore is the refcountee.
23:40 < rousskov> adri, the scheme you described above is what I expected from Buffer/String split.
23:40 < kinkie> maybe the problem is that the names are misleading..
23:40 < adri> kinkie: maybe
23:40 < kinkie> and sbufstore must be called buffer, and sbuf string.
23:40 < rousskov> adri, but currently it is just one Buffer (essentially), used for everything. An area of a Buffer is Buffer.
23:40 < adri> yup
23:40 < adri> alex: I had that too
23:41 < adri> alex: it quickly made things painful
23:41 < adri> alex: things like string and stmem suddenly had to track their own {buf, offset, length} with the same freaking semantics as each other.
23:42 < rousskov> Well, in the current code, String just lets Buffer track everything
23:42 < adri> maybe they do need to be re-named.
23:43 < rousskov> Well, with the current design, I am struggling to find enough reasons to keep String at all.
23:45 < rousskov> Kinkie has implemented the Buffer that, apparently, he always wanted. Then he pulled or copied a few methods, creating String to satisfy my demands for separation of the two.
23:45 < adri> brb
23:46 < kinkie> rousskov: yes.. as I had understood that there were two reasons you wanted String for.. to be able to define something as 'this is a String' (think size_t and similar types), and to keep the methods which are encoding-aware
23:47 < rousskov> kinkie, I am not sure we interpret the first reason the same way. I agree with the second reason, but currently Buffer has methods which are encoding-aware.
23:48 < kinkie> hmm such as? search() takes either a char or a SBuf.. what else may there be?
23:48 < kinkie> (and searching for a byte or for a blob within a blob doesn't seem much encoding-aware to me)
23:50 < rousskov> but it is
23:50 < rousskov> because you assume that values are the same if they are encoded the same way
23:51 < rousskov> There is also ==, <, and >
23:52 < rousskov> And scanf!
23:52 < kinkie> ok, you found them. <, > and cmp _ARE_ encoding-depedent. == isn't imo.. it's basic blob matching. under some encodings it may be that things represented in different ways are the same, but that's for UcsString (or whatever) to handle
23:53 < rousskov> many things might be equal even if their encoding differs
23:53 < kinkie> nod
23:53 < rousskov> so == is encoding aware
23:53 < rousskov> or buggy
23:54 < amosjeffries> why are <> on blob codeing aware then? they should be working on eth same domain as ==. ie (offset or length are ><)
23:54 < lifeless> kinkie: it is surprising for < to be coding aware and == not to be
23:54 < lifeless> kinkie: it will trip up programmers
23:54 < kinkie> lifeless: why? It checks that two regions of memory have the same exact contents
23:54 < rousskov> amosjeffries, they all are in the same category
23:55 < rousskov> kinkie, the meaning of "the same" depends on the encoding
23:55 < amosjeffries> aye, for blob they should act on offset/length nothing more. for string they go into bytes-level
23:55 < lifeless> kinkie: its about consistency
23:55 < rousskov> You can, of course, claim that Buffer handles one encoding, namely "raw bytes" or something like that.
23:56 < rousskov> But that makes Buffer, content encoding-aware
23:56 < kinkie> Well, I'd claim that it's C-like. But 'raw bytes' sounds reasonable
23:56 < lifeless> kinkie: I can guarantee that if you have a single interface where one operator is defined 'same bytes' and other is defined 'same characters', that users of the API will get it horribly wrong
23:57 < rousskov> kinkie, right. So we have Buffer for C-like content and String for ASCII content.
23:57 < rousskov> Actually, not even that
23:57 < kinkie> now, no.
23:57 < lifeless> kinkie: either don't define < on the byte level interface, or define < and == in a single spacec
23:58 < rousskov> We have Buffer for C-like content and String for ... C-like content.
23:58 < rousskov> Now.
23:58 < kinkie> lifeless: yes
23:58 < kinkie> my ideal split would be 'buffer for c-like content,string for unicode'. but here opinions vary ;)
23:58 < amosjeffries> what we all seem to be edging around to slowly is a model of a buffer with offset/length and a heirarchy layer of children that look deeper as needed.
23:59 < rousskov> amosjeffries, if that is the model, we do not need either String or Buffer. They are the same.
23:59 < rousskov> I should relax that a bit. They could be the same.
00:00 < rousskov> I am not sure there is much value in having two nearly identical, complex classes just to mark one of them for future extension.
00:00 < amosjeffries> yes, they could be. kinkie where did you put that auto-docs again?
00:00 < rousskov> Especially if we have very poor understanding of what that extension would look like.
00:01 < kinkie> amosjeffries: it may be out of date.. let me see
00:01 < amosjeffries> I just want to look at the collaboration graph
00:02 < rousskov> The alternative design is Buffer that is only a monolithic opaque blob and String is everything on top of that.
00:02 < rousskov> That is what I expected and that is what, I think, Adrian said he ended up after trying the first approach (FWIW).
00:03 < kinkie> rebuilding the autodocs
00:03 < adri> alex: i had a middle thing, a buffer reference
00:03 < adri> alex: which -just- handled the {buf,offset,length} and accesor
00:03 < adri> alex: other than that, yeah
00:04 < rousskov> OK. So Adrian had four layers BufferStore-Buffer-BufferReference-String
00:04 < adri> I dodn't have bufferstore
00:04 < adri> I just had buffer -> bufferreference -> string
00:05 < adri> sorry, difering terminology
00:05 < adri> {thing which refcounted a block of memory } -> { thing which wrapped offset/length inside a thing which refcounted a region of memory } -> { thing which acted as a squid "String" with a referenced region of memory }
00:05 < rousskov> And most of the code used what for raw I/O? buffer? or bufferreference?
00:06 < rousskov> adrian, and what was the class for block of memory?
00:06 < kinkie> amosjeffries: autodox at http://www.kinkie.it/~kinkie/dox/
00:06 < adri> I had only started doing the network side of things, and buf_t's backing store was allocated via malloc()
00:06 < adri> Ah
00:06 < adri> Yes, that bit
00:06 < adri> rousskov: I was in progress of converting things over to use buffer-reference
00:06 < rousskov> BufferStore = block of memory
00:07 < rousskov> Buffer = refcounting
00:07 < adri> but what I found alex, was almost everything was either copied
00:07 < adri> sorry, reference copied
00:07 < rousskov> String = search, case, etc.
00:07 < adri> or there was the original creator, doing the appending
00:07 < adri> almost nothing really modified the middle of a string after it was allocated
00:07 < adri> at least, in the existing codebase
00:08 < adri> so when things like substr's were creatd, I started modifying the code to use my buffer region thing when copying
00:08 < adri> sorry, when creating references to subregions
00:09 < adri> alex: again, bufferstore may or may not be useful, because in order to allocate it you may need to know what it is you're allocating it from
00:09 < adri> alex: it isn't clear to me right now how to do that without breaking layering
00:09 < adri> alex: I'm sure its doable, VM systems do it all the time
00:09 < rousskov> Well, this all makes sense. My concern is not with harmless append() or substr() but with consume().
00:10 < adri> right.
00:10 < adri> i'd toss consume() to be honest
00:10 < rousskov> If we make String the only thing that is area-aware, then consume() will be expensive.
00:10 < rousskov> I mean, Buffer::consume() will be expensive.
00:10 < adri> Yeah
00:11 < adri> as I said, I'd toss that. :)
00:11 < rousskov> Most of the current code uses I/O buffers in a consume/append loop, does it not?
00:11 < adri> If you want to implement a producer consumer model, I don't think doing it at this low level is the correct place to
00:11 < adri> alex: no idea in -3
00:11 < adri> alex: in -2, explicit producer/consumer happens in one place
00:12 < adri> alex: (client-side.c's read-side socket buffer)
00:12 < rousskov> I do not know what producer/consumer means :-).
00:12 < adri> alex: everything else is "sort of" producer/consumer
00:12 < adri> alex: append/consume. :)
00:12 < adri> alex: I'll use "append/consume", i think I understnad your specific use
00:13 < rousskov> I believe Squid3 client, server, and ICAP sides all append into the buffer and then consume the beginning of it.
00:13 < adri> right
00:13 < adri> the trouble with that
00:13 < adri> is the copying required
00:13 < amosjeffries> IMO, comsume should normally be a simple offset++ type operation.
00:13 < kinkie> The way I chose to address this is:
00:13 < adri> amos: it should be
00:13 < kinkie> - consume is offset++
00:13 < rousskov> amos, yes, which means you need offset.
00:13 < adri> amos: "give me that buffer, now go away its my problem to use it"
00:13 < kinkie> - buffer is allocated bigger than needed to make room for appending.
00:14 < rousskov> appending is not the problem
00:14 < adri> amos: doing it based on region is fine too; the last thing to release its reference frees it
00:14 < kinkie> - when appending is not possible because there's not room, copying occurs of the non-consumed part.
00:14 < adri> amos: but you don't want to keep reallocating when the thing grows, nor do youw ant to keep copying() data to the front
00:14 < kinkie> -heuristics are used to try and be smart, but they must be tuned
00:15 < adri> kinkie: this is one of my "the code is wrong in the first place, rewrite it rather than trying to keep it happy" argument points
00:15 < adri> kinkie: like a few of the string methods, I think that particular behaviour inside squid isn't one you want to try and support.
00:16 < kinkie> that problem will go away together with the scatter-gather issue
00:16 < adri> it won't
00:16 < rousskov> My problem is that if I have a big I/O buffer that is being appended/consumed, then that buffer is going to get realloced all the time because of all the Strings pointing to that Buffer and forcing cow.
00:16 < rousskov> forcing cow on consume().
00:16 < adri> if -code- uses the API kinkie, it'll be chewing CPU
00:16 < lifeless> append consume shouldn't require a single contiguous region
00:16 < adri> it depends what the consumer wants
00:16 < lifeless> it may want to offer byte by byte consumption, but it should be backed by multiple fixed size regions
00:17 < adri> if the consumer wants a linear, contiguous region
00:17 < adri> like the current string implementation does
00:17 < lifeless> well, 'backable by'
00:17 < adri> then you have to provide itthat
00:17 < kinkie> lifeless: currently Buffers are contiguous.
00:17 < adri> if you go "Well, we can create a vector type to handle multiple non-contig non-linear regions which some magic buffer type will turn into a contig region"
00:17 < adri> then you suddenly may end up with lots of shitty perfoming code which relies on that
00:18  * Holocaine sells adri some Contiguation Fairies.
00:18 < adri> and translating that into copies later sucks even more, thanks to post-1995 computer architecture
00:18 < rousskov> If we move away from the current model to a model where each I/O uses a separate buffer (to be vectorized later), then there is not consume() to worry about.
00:18 < adri> alex: I am doing it in two steps
00:18 < adri> alex: first step is exactly that
00:18 < adri> alex: second step is being able to vector-fill a short list
00:18 < adri> alex: if you have a buffer thats part-filled, and you're reading data into it
00:18 < rousskov> Right, that is what I meant by "later"
00:19 < adri> alex: the next append operation
00:19 < adri> alex: its cheap to keep a buffer around to read into
00:19 < adri> alex: the VM won't back the page until something touches it
00:19 < adri> alex: so if you have a half-sized 4k page, and you allocate a second 4k page
00:19 < adri> alex: do a readv() into both regions
00:19 < adri> alex: if you don't read into the second region, the VM won't allocate it
00:20 < adri> alex: if it does, then great, you've got a full and a partially full next page, you pass references to the newly filled regions up to the consumer
00:20 < adri> alex: then you don't end up wasting stupid amounts of partially filled PAGE_SIZE buffers
00:21 < adri> alex: its a real issue in live data, because most socket read()'s over anything not a LAN end up giving you partially filled buffers, like maybe 1 or 2k
00:21 < rousskov> The question is: Should we design Buffer/String to optimize the current code or the code we may want to write next?
00:21 < adri> alex: its one of the silly downsides to event driven, efficient, entwork iO. You end up handling IO so quickly sometimes your IO transactions don't fill PAGE_SIZE buffers. :)
00:22 < adri> ok, so this is a kind of interesting question
00:22 < adri> If you limit yourselves to -just- replacing the socket read buffers on the client/server side
00:22 < adri> and then creating strings from that
00:22 < adri> but still copy in and out of the store, like happens in 2.7 / 3.x
00:23 < adri> then you end up saving big on the allocator, it'll make tidying up various bits of the code much more doable
00:23 < adri> Trying to use that design in the actual store, wikthout the vector append operations, becomes a bit nightmarish for memory use
00:23 < adri> the thing is
00:23 < adri> that will provide enough of a useful API to allow people to go through the current code and properly fix all the stupid little memcpy/strdup/etc things that happen when doing string related crap
00:24 < adri> And -that- i think is going to be more important in the long run
00:24 < rousskov> I think we can commit to support vector operations in Rock Store for 3.2, if that is the primary stumbling block here.
00:24 < adri> See, this is whY i was telling you in prive, its more complicated than you think
00:24 < adri> I wouldn't rush into it like that
00:25 < adri> as in, there's a lot to tidy up -before- you think about vector opreations
00:25 < adri> I'm doing this as an experiment in cacheboy_head right now, so I can -do- the above
00:25 < adri> and tidying up client side and http.c enough to do this
00:25 < adri> is 3 months of adrian time
00:25 < adri> _just_ unwinding the crack
00:25 < adri> far, far before you think about any of the benefits this may have for the store
00:25 < rousskov> Well, here I lost you.
00:26 < adri> alex, in order to be able to efficient copy data in and out of th store
00:26 < adri> alex, you first have to change the src/http.c{c} code to not be stupid in how it shuffles data -into- the store
00:26 < rousskov> Accepting new Buffer/String is not a big deal. Rock Store is not a big deal. It is all doable for 3.2.
00:26 < adri> unless its changed dramatically in the last 3 months, src/http.cc still looks as bad as the squid-2 one
00:26 < adri> If by "3.2" you mean "+18 months", sure
00:27 < rousskov> Not really.
00:27 < adri> or "+9 months with three full time people dedicated to unwinding the junk code", sure
00:27 < adri> Hey, I'm just talking based on having done it twice. :)
00:27 < rousskov> I do not understand why all the junk code needs to be cleaned up.
00:27 < adri> alex: because otherwise whatever magic you can dream up for rock store will give almost 0% benefit to teh rest of the code
00:28 < rousskov> I only need to optimize the common path.
00:28 < adri> hah
00:28 < adri> Your idea of the "common path" is probably wrong. :)
00:28 < adri> there are lots of "common apaths" depending upon what the user is doing
00:28 < adri> is it a proxy? 
00:28 < adri> if its a proxy, with a 30% ish byte hit rate
00:28 < adri> then there's a lot of data still coming in from the network and coming into the store
00:29 < adri> if its a reverse proxy? then that 90% byte hit rate is not tickling http.cc so much; its mostly store -> store client -> client_side
00:29 < adri> eliminating that store client copy will probably boost squid-3's performance by about 5%, like it did to squid-2.HEAD
00:30 < rousskov> Common path is network-disk-network, essentially. If we do that, 3.2 becomes a lot faster than 3.1 and that is sufficient.
00:30 < adri> oh, and if you fix the mstmem access to not be a freaking tree lookup each time
00:30 < adri> alex
00:30 < adri> let me re-iterate
00:30 < adri> network -> disk -> network
00:30 < adri> is about 30,000 lines of shit code
00:30 < adri> when I say shit, I actually mean, i've sat down and looked at it, even recently in -3
00:31 < adri> (sorry, DSL router just croaked)
00:31 < adri> there's a lot of shit code
00:31 < rousskov> Well, I also work with the code and I disagree that I need to rewrite 30K lines to get serious improvements in 3.2 compared to 3.1, but it is a matter of opinion. We are not going to convince each other regarding that.
00:32 < adri> The place to start, as I keep saying, is to stick a proper profiler on whatever load you current thing is "normal"
00:32 < adri> and map out "common paths" that way
00:32 < adri> then we can continue this discussion
00:32 < adri> without any conjecture :)
00:32 < rousskov> The question is, currently, about String/Buffer versus Buffer alone. :-)
00:32 < adri> The biggest places you're going to hurt is the copies into store, the copy out from store, maybe you've got some more parsing I haven't checked
00:33 < adri> changing the memory cache won't fix that
00:33 < adri> then its ACL regex lookups. :)
00:33 < adri> then last time I checked, its 70% of sub-1% CPU time calls. :)
00:33 < adri> with the memory allocators way, way up there
00:34 < rousskov> We need to tell kinkie to commit the current design or to change it (secondary-level bugs aside).
00:34 < rousskov> Kinkie is not doing any performance work, so the above does not matter to him. He does, however, need an answer.
00:34 < adri> I'm still way, way  not comfortable enough with that design
00:34 < adri> I think that right now, all those APIs are way overloaded
00:34 < adri> sorry
00:35 < adri> the API is way overloaded
00:35 < rousskov> Well, let's limit ourselves to one question for now.
00:35 < adri> Ok
00:35 < rousskov> Should Buffer contain all string-manipulation functions (and, hence, offset)?
00:35 < adri> no
00:35 < adri> Wait
00:36 < adri> define "buffer" :)
00:36 < rousskov> The thing that does cow.
00:36 < adri> Are you talking about "thing which references a refcounted backing store" ?
00:36 < adri> For now
00:36 < adri> For this initial pass
00:36 < adri> I'd tidy up the lot of places where String is being used poorly
00:36 < rousskov> thing that references raw memory buffer and refcounts it.
00:36 < adri> and I'd imlement just, -just- a refcounted buffer thing with an append, get, set operation
00:37 < adri> and then add in the relevant functionality into SquidString to do all of what his current SBuf code is trying to do
00:37 < adri> Beacuse
00:37 < rousskov> OK.
00:37 < lifeless> adri: the stmem thing being a tree is fine IMO - but the tree implementation is pathological at the moment, because its ill suited to the insertion/lookup behaviour
00:37 < adri> Until people do the _really_ hard task
00:37 < adri> of tidying up all the places where buffers from Strings are used, and poorly
00:37 < lifeless> an rb tree with cached front node and tail node would be much better
00:37 < adri> The actual -benefit- from that code is completely missed
00:38 < adri> lifeless: I think the idea is fine. I think stmem has morphed poorly from being an in-transit object data pipeline into a cache
00:38 < lifeless> adri: agreed
00:38 < adri> lifeless: I believe it should just be an in-transit object data pipeline _ONLY_, and the memory cache is seperate
00:38 < rousskov> adri, yes, we know you want the cleanup first. Let's focus on the answer for Kinkie though.
00:38 < adri> lifeless: which would mean backing out everything which treats it otherwise
00:39 < adri> alex: the answer is for kinkie
00:39 < kinkie> adri: if this goes in, I'll have something to work with for the cleanup. We already agreed on the attack vector
00:39 < rousskov> adri, do you think the limited Buffer you were talking about should have offset? Or just size?
00:40 < adri> rousskov: I think it should have offset, if its referencing a refcounted memory backing store
00:40 < lifeless> adri: well, I can deal with it being just one or both; though the in-transit thing has multiple readers fairly often, or did when I looked at this - for things like adobe acrobat a single browser can generate multiple concurrent overlapping range requests
00:40 < rousskov> kinkie, sure, but let's not argue about cleanup. We will do it later. Let's focus on the design points we can focus on.
00:40 < adri> lifeless: agreed, but it was rushed
00:40 < kinkie> And I don't think a Buffer should have no manipulators. If it doesn't what I'd end doing is manipulate somewhere else and then copy in. And then copy out to export
00:40 < rousskov> adri, if Buffer has offset, then it has consume(), right?
00:41 < adri> rousskov: no
00:41 < kinkie> Because exporting the raw pointer like current SquidString does is dangerous at best
00:41 < adri> rousskov: Buffer has an offset so when you ask for Buffer[0], it starts at the right offset
00:41 < rousskov> adri, what operation will increase Buffer::offset?
00:41 < adri> rousskov: It should be assignment-only
00:41 < adri> rousskov: what I'ms aying is, the -consume- operation shouldn't exist.
00:41 < adri> rousskov: any situation where consume exists at that layer is flawed.
00:42 < rousskov> Ah, I see. Let's assume that memory backing store is a char* pointer, for now
00:42 < rousskov> Will Buffer have an offset then?
00:43 < adri> yes
00:43 < adri> beacuse if you have multiple Buffer's referencing the same char * pointer
00:43 < adri> and assume the BufferStore is just { char *ptr, int size, int capacity, int refcnt }
00:43 < rousskov> Yes
00:43 < adri> Then there needs to be some abstracted way of referencing -just- a region of that
00:43 < adri> because it'll be done in multiple places
00:43 < adri> not just String
00:44 < adri> Since all a Buffer is
00:44 < adri> is just { BufferStore *, int offset, int length }
00:44 < rousskov> Then we come to the same question. What Buffer operation will increase offset?
00:44 < adri> Why would you want to increase the offset of a Buffer?
00:44 < amosjeffries> BUT, shoudl regions have floating windows? ie clientStreams 'Im up to here' 
00:44 < rousskov> If iffset is always zero, we do not need it
00:44 < adri> offset won't always be zero
00:44 < adri> what I'm saying is
00:45 < rousskov> What will increase it?
00:45 < adri> its simply initialised at creation
00:45 < rousskov> Initialized to non-zero?
00:45 < adri> if you want to destroy and reinit the buffer to point at another region, then fine
00:45 < adri> I'm assuming "increase" implies "it started at value X, now change its value to be something > X"
00:46 < rousskov> OK. I understand initialize to non-zero.
00:46 < adri> amosjeffries:  this is why I'm avoiding using it for now in situations like communicating any actual buffers around
00:46 < rousskov> adri, what classes other than String will use Buffer with an offset?
00:46 < adri> amosjeffries: because the only way to do that efficiently is via large buffers that get filled full first, or by communcicating vectors
00:47 < adri> rousskov: the memory store
00:47 < adri> rousskov: anything writing stuff to disk, for example
00:47 < rousskov> What will those classes do after writing the first N bytes?
00:47 < adri> rousskov: they'll track whatever they've written out of that buffer, until its completely done, then they'll free their Buffer
00:48 < amosjeffries> adri: yet that is one of teh two basic purposes of the buffer, for passed entire or partial headersets around
00:48 < adri> rousskov: I understand that you want to push tracking that down into Buffer
00:48 < rousskov> adri, how will they track?
00:48 < adri> rousskov: if you want to consume that wya, for that purpose, then fine
00:48 < adri> rousskov: as long as its used like -that-, ie, tracking how much is left that they care about
00:49 < adri> rousskov: not to be combined with an append() operator throwing more data into the same Buffer elsewhere
00:49 < adri> rousskov: -that- use of append/consume is what will lead to silliness
00:49 < rousskov> Hm
00:50 < adri> rousskov: the only places I like the idea of append/grow is where you -require- for now, contiguous data, for things like creating Strings for headers
00:50 < amosjeffries> adri: _that_ use of append/consume wil lead to one COW which allocates more than it needs to for later append madness
00:50 < adri> rousskov: things get silly later on when you're doing content scanning, for example
00:50 < adri> amosjeffries: wait a sec
00:50 < adri> rousskov: because at the moment, parts of the code may just treat the reply body as a stream of octets with no specific boundaries, but various content scanning bits may want to try and read "byte patterns" (eg binary blobs, strings, image fingerprints, etc0
00:51 < adri> rousskov: and they may not get their entire "blob" in one read
00:51 < adri> rousskov: I haven't looked into eCAP to see how its solved in that API yet
00:51 < rousskov> What if we have Buffer and Area. Buffer does not have an offset. Area does. String does too.
00:51 < kinkie> amosjeffries: that's it. See http://www.kinkie.it/~kinkie/dox/classSBuf.html#fd6e2e48dd380a94ac40b312b8f8d9f1
00:52 < adri> rousskov: I think that "offset" is being used slightly differently here
00:52 < rousskov> Area and String point to Buffer and add offset (and other stuff).
00:52 < adri> amosjeffries: what I've proposed (and coded up) works fine for header sets in particular
00:53 < adri> amosjeffries: the append operation grows the buffer until the reply headers have been completely read in
00:53 < adri> amosjeffries: after that, for now, new buffers are created for each socket read, but the right way is to do vector reads into particlaly filled and new buffers
00:54 < adri> amosjeffries: for HTTP requests, the only copying that has to happen atm is for left-over data from the next pipelined request, and I only did the copy-into-new-buffer so things were clean. You don't -have- to.
00:54 < adri> amosjeffries: that works fine. The inefficiencies in the current code stem from the assumption that everything is a 4k page, and all the random IO transaction sizes from the network get copied into contiguous 4k blocks
00:55 < adri> amosjeffries: but for throwing around reference counted request/reply/header sets, it works just fine
00:55 < amosjeffries> I wa reading earlier when you said all that. question is not about low-level SbufStore, but next level up.
00:56 < adri> amosjeffries: I didn't need a sliding window when I used it
00:56 < adri> amosjeffries: I think i understand what alex is getting at, and thats fine
00:56 < amosjeffries> when Buffer starts a COW on an effecive read-only BuferStore, offset becomes 0 and append+consume can play merilly away
00:56 < amosjeffries> on anow read-write buffer
00:57 < adri> amosjeffries: but the offsets from any and all of the htp header stringsincrease from 0, I don't get what the problem is. :)
00:57 < rousskov> amosjeffries, it is not about whether it will work correctly or not.
00:57 < adri> amosjeffries: the COW only happens when you need to write, at which point the "offset" would yes become 0, into the newly created copy of -that- region
00:58 < rousskov> adri, so your current code does not have consume(), right?
00:58 < adri> nope
00:58 < adri> I hadn't hit a point where I needed to slide the offset of any of the strings or buffer references
00:59 < adri> I can see that you may want to if you wanted to push tracking what you had written, for example, back into Buffer
00:59 < adri> but then, I treated the "track what you wrote" something completely not related to strings or buffers
00:59 < kinkie> re consume: I think I used that as a convenience in the Tokenizer
00:59 < kinkie> which is essentially a consume-until-delimiter engine
00:59 < rousskov> adri, I understand. You had an Area or something like that. It had an offset and a pointer to Buffer, right?
00:59 < adri> well, I wrote a hand-unrolled parser. :)
01:00 < adri> kinkie: i can see why you'd do that
01:00 < rousskov> kinkie, we are not talking about an specific method in your code. It is a general concept.
01:00 < kinkie> nod
01:00 < adri> rousskov: the buffer region (whichi s Buffer here, I guess) has a buf_t * pointer to the backing buffer, an offset, and a len
01:01 < rousskov> Does userland code share "buffer regions" or "backing buffers"?
01:01 < adri> rousskov: buffer regions are private
01:02 < adri> rousskov: backing buffers are shared only
01:02 < adri> rousskov: the backing buffer itself is refcounted
01:03 < adri> rousskov: in code, backing buffers are always pointers, and buffer regions are always declared as a variable or part of a struct, not a pointer
01:10 < amosjeffries> kinkie: anything new in what Adrian is saying?
01:10 < kinkie> the design is the same, names change.
01:11 < kinkie> Backing Buffers = Alex' Buffer = SBufStore class.
01:12 < kinkie> Alex' Buffer = adri's buffer region = my SBuf
01:12 < amosjeffries> so no changes yet. thats good,
01:12 < amosjeffries> only some API to see if it can be dead-coded.
01:13 < kinkie> Re backing buffers I'm more radical than what I've seen so far: they're a private data class of Buffer regions: noone can access them except for Buffer Regions and their friend classes (not even heirs).
01:14 < kinkie> Buffer Stores are intelligent in that they have methods. They're dumb in that they're not self-sustaining. They are managed by Buffer (SBuf's).
01:14 < kinkie> Think of them as 'structs with utilities'.
01:16 < adri> hm
01:16 < adri> kinkie, are you running the irc logging bot still?
01:16 < kinkie> yes
01:16 < kinkie> it's named kot_
01:16 < adri> could you please make sure that this discussion makes it up on the wiki somewhere afterwards?
01:16 < kinkie> (probably some split)
01:16 < kinkie> If all participants agree.
01:16 < adri> We should probably have a section somewhere which links to interesting discussions
01:16 < adri> Becuase a lot of this is replacing what used to go on in the distant past on squid-dev. :)
01:18 < amosjeffries> this can go on the meet-ups  think. it was a specific StringNG audit meet-up with alex,adri,kinkie + extras doing FUD.
01:18  * rousskov sighs network problems.
01:18 < kinkie> Regarding consume. I agree no consume on Buffer Stores (SBufStore). But Buffer Regions imo need to have manipulation functions. The minimal interface I can think of on top of my head is set, append, slice/substr, import, export.
01:18 < rousskov> adri, I can attack my question from the other side: Do you think String without any data members other than Buffer pointer makes sense?
01:19 < rousskov> In other words, is it worth creating a String class just to move all encoding/meaning-aware methods there?
01:19 < amosjeffries> we're planning sticking the irc log into wiki alex? okay with that?
01:19 < rousskov> sure
01:19 < kinkie> Then of course there's = and setAt and []. 
01:19 < rousskov> I missed everything after :: (05:00:55 PM) adri: rousskov: the buffer region (whichi s Buffer here, I guess) has a buf_t * pointer to the backing buffer, an offset, and a len
01:19 < adri> rousskov: yes
01:20 < adri> rousskov: hm, wait
01:20 < kinkie> Back to manipulators. given that set, everything else (head, tail, consume etc) are only utility aliases
01:20 < kinkie> GAH
01:20 < adri> rousskov: I think String having explicitly different len and size, seperate from capacity, makes sense
01:20 < kinkie> Hang on Alex
01:20 < adri> rousskov: and encoding for later, yes
01:20 < adri> rousskov: I caon't think of anything data-oriented besides a Buffer (which encodes the backing buffer, an offset and a length inside of that buffer)
01:21 < kinkie> adri: I'm giving Alex access to the bot logs
01:21 < rousskov> adri, the current design String stores offset and length in Buffer. So it does not have any members of its own, other than the Buffer pointer
01:22 < rousskov> adri, its only reason for existence is to accumulate meaning-specific methods.
01:22 < rousskov> I am wondering if that reason is enough.
01:22 < adri> rousskov: I think it is
01:22 < adri> rousskov: later on, the meaning of encoding alone may be worth it
01:22 < adri> rousskov: along with the comparison operators, for example
01:22 < rousskov> I was hoping you would be certain that Buffer does not need an offset, then the answer would be clear because String would need it...
01:22 < adri> Heh.
01:23 < adri> ok, I'm goinng afk for a bit
01:23 < amosjeffries> afk?
01:23 < adri> Yeah
01:23 < adri> as in, I'm going to do the exercise I should've done about 4 hours ago
01:24 < amosjeffries> but what are the acronym words?
01:24 < adri> away from keyboard
01:24 < amosjeffries> lol, I was thinking "away for (WTF?)"
01:25 < kinkie> next question: String as bridge or heir to Buffer Region?
01:27 < amosjeffries> IMO heir. since members are needed and SBufStore is not directly available to it. the enciding-alternate members should be virtual with the class name giving meaning context. (== on buffer = offset/len comparison, on string  = byte-wise)
01:27 < kinkie> amosjeffries: so:
01:28 < kinkie> SBuf foo("foo"), bar("foo"), foo!=bar
01:28 < kinkie> String foo("foo"), bar("foo"), foo==bar
01:28 < kinkie> ?
01:29 < kinkie> (last atom is a true equality check)
01:29 < kinkie> and also:
01:29 < rousskov> Virtual methods?!
01:30 < rousskov> I doubt it is a good idea to add significant overhead for what we might need later.
01:31 < rousskov> Let's assume we do not know how to support different encodings the right way.
01:31 < kinkie> rousskov: I think that the current implementation is about as expensive as a virtual method...
01:31 < rousskov> We might isolate encoding-specific stuff to String, but let's not make it more heavy than it needs to be for known use.
01:32 < rousskov> kinkie, I do not want to argue about which methods are virtual. We can always add that keyword later.
01:32 < rousskov> Besides, I want to store String instances.
01:32 < kinkie> then String should disappear, and we remain with a Buffer Store and a Buffer Region which assumes a C ASCII encoding and handles that
01:33 < rousskov> You cannot store String instances if String does not really exist and you have to store AsciiString or UtfString
01:33 < kinkie> (I'm using Buffer Store and Buffer Region as names as they seem the less ambiguous so far)
01:33 < kinkie> rousskov: yes
01:33 < rousskov> If there is no String class, we still should not add virtual. For the same reasons.
01:34 < kinkie> no String = no virtual for sure.
01:34 < kinkie> In fact, no String is about as efficient as it gets.
01:34 < rousskov> Again, let's ignore the question of how we will support encoding a year from now. I do not know the answer, and I dare to bet that nobody else here knows it either.
01:35 < kinkie> The client-side marking can be achieved as a typedef.
01:35 < kinkie> (but that's quite abuseable)
01:35 < rousskov> and cannot be pre-declared.
01:36 < rousskov> amos, do you think it is worth having String just to accumulate meaning-specific methods?
01:38 < rousskov> kinkie, your answer is "no, it is not worth it", right?
01:38 < kinkie> correct. with the addition of "but if the consensus is that it's worth it, I'll code it up"
01:39 < rousskov> well, sure
01:52 < rousskov> kinkie, I emailed you the review results. I am not going to do more until the class split decision is made.
01:52 < kinkie> Ok.
01:52 < rousskov> And you probably do not want to change much until then either...
01:53 < kinkie> I'll go to sleep now, it's 2AM and I'm pretty tired. If you wish, please continue the discussion. I'll read about it on the bot logs tomorrow, or mail me any news.
01:53 < kinkie> Ta
01:53 < kinkie> Thanks and goodnight
01:54 < rousskov> Ciao
01:55 < amosjeffries> sorry, got dragged away to a client.
01:55  * amosjeffries reading up
01:58 < rousskov> I think you only missed the last question: Do you think it is worth having String just to accumulate meaning-specific methods? 
02:05 < amosjeffries> long-term, yes. short-term, tricky. but for an 18mth short term its probably worth not, for simplicity if anything.
02:07 < rousskov> Does not look like there is any consensus regarding this, then.
02:09 < rousskov> In the absence of new information or opinions, simplicity wins and kinkie should get rid of StringNg class.
02:41 < amosjeffries> well, I cant see any reason for keeping StringNg separate it in the current state of things.
03:21 < rousskov> The only reason would be to avoid going through code and changing Buffer to String or SomeSpecificString where needed, when we start supporting encodings and such.
```

Further discussion happened on the topic on Jan 21st, 2009

``` irc
15:38 < kinkie> Hello Henrik, nice to see you again..
15:39 < kinkie> I see you've chimed in on the StringNg debate.. I have a few hiints about the current implementation which may address the points you raise..
15:39 < hno> And sorry for not having done a proper review of your code.
15:40 < kinkie> you don't need to. I only hope that the end results won't be 'start over'. I couldn't do that. But if a relatively small changeset is what's needed, I'll happily do it.
15:40 < hno> I don't really care if there is a String class or not, other than that I think it adds clarity to the implementation.
15:41 < kinkie> Regarding "String/Buffer split & encoding" - that's more or less how it's done now. Some functionalities would need to be moved out of SBuf into StringNg, but it's doable. Folding everything back into one class if it shows no good advantage is doable.
15:43 < kinkie> Regarding "who creates i/o buffers": as long as an I/O buffer is a contiguous chunk of memory, SBuf.importBuf() will happily accept it and memory-manage it. So the caller would have to allocate a char[], fill it in, importBuf(),return the resulting SBuf and forget about it all.
15:44 < hno> That's a side discussion, not really relevant. But it's good if the use case described works.
15:45 < kinkie> Regarding "String consume method": I refer you to the current implementaiton of SBuf::consume(), as it's easier to see it in code than to explain. In short words, consuming does not move data. When appending ends the available tail space, cow() occurs. Heuristics are applied to try and be smart about how much free tail-space to reserve.
15:45 < hno> which is a producer of some kind filling up linear memory, which gets fed to the received as String or Buffer as it gets filled.
15:46 < kinkie> (of course cow() only copies the non-consumed data)
15:46 < kinkie> Nod.
15:47 < hno> That's fine, but more of a corner use case. Normal operations should not trigger that cow.
15:47 < kinkie> Yes. It's all up to finding the right balance between cpu and memory.
15:48 < hno> In this case I'd say it's more of finding the right producer/consumer model and who is responsible for what..
15:48 < kinkie> If we're generous about leaving more unused free tail-space in buffers, less copying will occur. The right balance needs to be found, I've put the code doing the smarts together to be able to more finely tune
15:49 < hno> in the model of "producer allocates" you rarely if ever needs append. But you will need the non-linear container class.
15:49 < kinkie> For the heavy lifting of producer-consumer workloads in a medium-term development timeframe, please see my answer to Alex in "Buffer/String split, take2"
15:50 < kinkie> (in particular the paragraph on vector i/o
15:50 < kinkie> )
15:51 < hno> Ok. I'll read it in detail in an hour or so.
15:52 < kinkie> ok
15:52 < hno> What do you refer to by "D&C approach"?
15:52 < kinkie> That's Alex's Divide & Conquer approach.
15:53 < hno> Saw it now.
15:54 < rousskov> evening
15:54 < kinkie> hi Alex
15:54 < rousskov> hno, feeling better?
16:08 < adri> hai
16:08 < adri> replying to email(s)
16:13 < rousskov> kinkie, if we have one Buffer for all uses and users, your "smart heuristics" are more likely to be harmful than helpful.
16:13 < rousskov> Short string users needs differ from that of I/O buffer users, for example.
16:14 < rousskov> I doubt we can optimize both in the same class.
16:14 < kinkie> (hang on, phone call)
16:14 < rousskov> This is one of the reasons why D&C strategy works.
16:18 < kinkie> rousskov: imo it's more useful to D&C THAT too: if reallocation strategy is the only one difference, then let's just make that modular via a Strategy object or some tuneables
16:18 < rousskov> I doubt allocation is the only difference.
16:19 < kinkie> Downside: it increases sizeof(buffer). Upside: less code duplication.
16:19 < rousskov> I do not see much code duplication in D&C
16:19 < rousskov> D is for divide, not duplicate.
16:20 < kinkie> The D&C you suggest moves the substringing out of Blob and into String*. I don't see that as a big win..
16:21 < rousskov> As for "whose blueprint has also been available for 5 month", I think it is an invalid argument because at least half of the folks reviewing your code from the very start wanted something other than what you kept producing.
16:22 < rousskov> In other words, "you were not listening for 5 months" or "you were ignoring the repeated calls for a change for 5 months"
16:22 < rousskov> Substring can be moved to Buffer if all or most Buffers need sub-areas. See (note).
16:23 < kinkie> I believe I changed lots, and what I didn't change, it's for sure I didn't understand.
16:23 < adri> And that may have been purely a communication issue, with no actual badness on anyones' part
16:23 < rousskov> I am not saying it was
16:24 < rousskov> I am saying it is not a valid argument to tell others that it is too late to argue for a different design.
16:24 < kinkie> Please, don't see me as placing blame on anyone but myself. Still the reasons for me not doing a rewrite-from-scratch stand.
16:24 < rousskov> If that different design has been advocated even _before_ StringNg
16:25 < rousskov> Whether you are going to finish the project or not is a separate issue.
16:25 < adri> You don't have to do a rewrite from scratch
16:25 < adri> the path forward shouldn't be that
16:25 < adri> the path forward should be
16:25 < rousskov> That is true as well.
16:25 < adri> "what have we learnt from this, now what should we pull in and in what order?"
16:25 < adri> "What sized chunks"
16:25 < adri> "What needs to happen elsewhere first before we pull in the next bits"
16:26 < kinkie> adri: that's exactly my point
16:26 < adri> The point of your work kinkie, is not to throw it away, its to add to the "clue" that is the "squid project clue"
16:26 < rousskov> kinkie, the code you have now has the right pieces. If D&C wins, the pieces will need to be rearranged. Not a "from scratch rewrite".
16:26 < adri> And part of clue is not just "use it or toss it"
16:26 < adri> sometimes its "what not to do" as much as "What to do"
16:28 < adri> I've been through this string / buffer crap at least 3 times in various squid-2 branches
16:28 < kinkie> nod
16:28 < adri> Its not something you get right first, and its certainly not something you toss all of your clue away each time
16:28 < adri> You go "Hm, that didn't work, lets try another approach building on what I've done"
16:28 < adri> in my eyes, the bits that we should steal right now is the refcounted backing buffer with minimal sugar, glue it into String, fix the String users right now so its not completely sucky, and then see where to go
16:29 < adri> Others disagree on the path forward, sure
16:29 < adri> but the point is, you can -start- with the bits you've written.
16:29 < adri> heck, the svn branch I linked you to
16:29 < adri> ended up using the buffer code I wrote in my last attempt, verbatim
16:29 < adri> but I did the String stuff differently
16:30 < adri> hence why I managed to get refcounted NUL string sin like two tiny commits. :)
16:30 < adri> Rather than my -last- attempt, which was to fix all the current users of NUL Strings to -not- assume NUL termination
16:30 < adri> That was too much to bite off in one chunk
16:32 < hno> rousskov: Yes thanks.
16:33 < rousskov> Glad to hear that.
16:36 < hno> refcounted backing store, with a slicing & dicing thing ontop is defenitely the first step. Very useful foundation to build Strings, parsers etc ontop.
16:37 < adri> Well, the NUL termination puts an unfortunate halt on slicing/dicint
16:37 < adri> slicing/dicing
16:37 < hno> Does it? See my squid-dev post earlier today.
16:37 < adri> otherwise you may end up slicing up a buffer into a string, and said string may just have a NUL in the middle
16:37 < adri> because some substring of it now has a NUL there
16:37 < adri> And I'm saying, you haven't thought this through enough. :)
16:37 < kinkie> hno: you refer to a very specific corner-case
16:38 < adri> If you slice/dice using NUL and then use the current codeabse but with NUL terminated refcounted buffers
16:38 < hno> Ah, that. Well.. \0 within string data is badness, but not a stopper.
16:38 < rousskov> adri, I agree with hno regarding foundation and I would add cow to that.
16:38 < adri> all your subtsr operations suddenly turn into COW
16:38 < adri> since strictly speaking, you -are- modifying the buffer
16:38 < hno> rousskov: I would not cow at this level.
16:38 < rousskov> adri, no
16:38 < adri> or you don't COW on slice/dice, and risk random overwrites
16:39 < adri> Or, you just go "thats too hard for pass one", and don't implement cheap substrings in the first pass
16:39 < rousskov> adri, we know how to implement cow so that it works and is safe. I do not think we should argue about that.
16:39 < adri> in fact, COW for NUL terminated strings, with copy for new / substring
16:39 < hno> Most strings or buffers should be const imho.
16:39 < adri> is probably the easiest thing
16:39 < hno> except for the one producing it in the first place.
16:39 < adri> hno: sure. But if you're creating strings by referencing some backing buffer which you're parsing
16:39 < hno> and? 
16:40 < adri> hno: suddenly you're breaking the expectation that once you have a reference it won't change
16:40 < adri> hno: because the parser may scribble further NULs inside substrs
16:40 < adri> for example
16:40 < adri> in the current parser
16:40 < adri> and certainly in logging
16:40 < adri> a bunch of stuff works on -lines-, not fields
16:40 < adri> So you create a line
16:40 < adri> you get one str with a \0 at the end
16:40 < adri> then you further parse that buffer into field/value
16:41 < adri> ok, then you end up with two \0 terminated strings in that buffer, but the original line string now has a \0 in the middle
16:41 < rousskov> adri, cow will address all that. The code can then be made more efficient to reduce COW invocations.
16:41 < hno> Yes. But I don't consider that a problem. It's only a problem if there is multiple references before you started adding those \0s..
16:41 < adri> Sure
16:41 < adri> hno: and this is my point
16:41 < adri> hno: that code isn't very sensible
16:41 < adri> hno: it may be sensible right now, but having to add that as a 'catch' in the API is going to trip up people later on
16:42 < rousskov> We need better foundation to make it sensible, IMO.
16:42 < adri> hno: this doesn'te ven begin to touch on the actual issue surrounding trying to pull that move
16:42 < rousskov> You want to make it sensible using old foundation. We will never agree on that.
16:42 < adri> hno: which is 'how do I grestructure the client/http code to actually -give- the parser a buffer it can refcount in the first place"
16:42 < adri> rousskov: except that _I_ have working code you can look at and evaluate right now. :)
16:43 < adri> rousskov: everyone else is just talking. :)
16:43 < hno> Well, there is a clear distinction between immutable strings and writeable strings.
16:43 < rousskov> adri, you are not the only person in the world working with code.
16:43 < adri> rousskov: ok, let me rephrase. I'm the only one with public code right now based on some Squid version, which he's tested, and is sharing with everyone.
16:44 < rousskov> adri, and we cannot copy the code you did, so it is of marginal value.
16:44 < adri> rousskov: this isn't the first time someone's done this to Squid. But I don't see any other public codebases.
16:44 < adri> Of course you can
16:44 < adri> You'd be surprised how much of it you -can- copy
16:44 < adri> Half of the work is actually tidying up the damned users of the code in the first place
16:44 < adri> as I keep saying. :)
16:44 < rousskov> Patches for Squid3 are welcome.
16:45 < hno> adri: Exacly, and that part is very hard for anyone but you to copy.
16:45 < adri> rousskov: I'm not going to head down a path with Squid-3 which is going to make things unstable, until people stop making it unstable.
16:45 < adri> rousskov: I've said this before.
16:45 < rousskov> Right. So let's stop arguing about it. It is a dead end.
16:45 < adri> rousskov: I've offered to help kinkie identify and work on bits of the codebase which use String incorrectly, and if thats the path forward, then I'll go with that
16:46 < hno> That is a path forward, no matter what happens with StringNg.
16:46 < rousskov> And I am not against that "as such" but I am focusing on String issues right now.
16:46 < rousskov> Because kinkie needs an answer.
16:47 < adri> hno: and my concern isn't that its a path forward, it's that I hold that much, much higher than any actual decisions on what a replacement buffer/string backend should look like.
16:47 < rousskov> And I do not want to give him "do something else for 5 month" answer.
16:47 < adri> hno: Is eem to be singular here.
16:47 < adri> rousskov: if he's willing to work with me on tidying up some of the busted things to do with String, then I'm happy to
16:47 < adri> rousskov: he's said before that he doesn't think that working on String is the path forward, so we disagree there
16:48 < rousskov> well, he wants to commit it!
16:48 < rousskov> If he does not, we should not be wasting time rererereviewing that code and arguing about it.
16:48 < kinkie> adri, alex: those are parallel paths
16:48 < kinkie> I'd like to commit StringNg so that *new* code can start using it.
16:48 < adri> no
16:48 < adri> argh!
16:48 < kinkie> Then for adoption there's a multi-stragetegy
16:48 < rousskov> There you go
16:48 < adri> kinkie: look.
16:48 < adri> ok
16:49 < adri> I'm not going to agree with that
16:49 < kinkie> String users need to be sanitized so that they can be converted.
16:49 < adri> I don't thing new code should be using it right now
16:49 < kinkie> Committing will allow more developers to
16:49 < hno> adri: I don't get you. What is the problem you try to highlight?
16:49 < kinkie> - fix what's broken to StringNg rather than tell me how to do it, me misunderstanding and misimplementing
16:49 < adri> hno: there's lots of problems, all to do with the order people are attacking this
16:49 < kinkie> - get to work themselves on comverting what they see as useful
16:49 < rousskov> kinkie, _and_ writing new code using correct APIs
16:50 < rousskov> that do not need to be converted a few months later.
16:50 < adri> hno: _I_ would like to see the refcounted buffer stuff go in, and for the few stupid uses of String to be unstupidified
16:50 < kinkie> rousskov: I already told it, I would _love_ if someone else fixed what I've broken in StringNg.
16:50 < hno> anyone against what adri just said?
16:50 < adri> hno: I'm worried that if new code is added and used, whilst ther'es another two ways of doing String, we're never goign to end up with -one- majority way
16:51 < adri> hno: if we find out that some incorrect assumptions were made, then suddenly you have to try and fix all the new code which uses StringNg
16:51 < rousskov> hno, I agree with the first part: "good API in, bad code polished"
16:51 < kinkie> hno:  I volunteered (and still do) to work with Adri to that end
16:51 < adri> hno: i don't think adding in another String API in its entirety is the way to go
16:51 < adri> hno: I don't think that having new code -use- the new APIs is the way to go
16:52 < rousskov> And those I disagree with.
16:52 < adri> hno: I think that converting over the mess we have, and using it very restrictively, to achieve a small set of goals (tidy up the String users, which need to happen anyway; parsing, which needs to happen aanyway)
16:52 < rousskov> for some definition of "entirety"
16:52 < adri> hno: and then standing back, looking at what was done, and re-evaluating
16:52 < adri> hno: is the way to go.
16:52 < adri> hno: because I've seen ever ysingle time someone tries introducingv some new thing and then use it where -they- see fit
16:53 < hno> A agree with the principle, but see little choice here as a moving directly to the "right" String is faily major and potentially disruptive.
16:53 < adri> hno: its completely stupid
16:53 < adri> hno: and ends up breaking stuff which takes a lot of developer time to fix
16:53 < adri> hno: in ways which the people working on it to start with didn't think about or didn't test, because they were working in -their- areas on stuff -they- saw interesting
16:53 < adri> hno: and didn't see how it broke the bigger picture
16:54 < rousskov> hno, what do you mean by "moving directly to the right String"?
16:55 < hno> rousskov: Getting String fixed in a way that makes it behave like StringNg, eleminating the need of StringNg, all in one go.
16:55 < rousskov> That would be bad.
16:55 < hno> instead of a transition from String to StringNg.
16:55 < rousskov> So let's try to split this into three questions:
16:56 < hno> My vote (once the API discussion settles) is to rename String to ObsoleteString, and merge the new one as String.
16:56 < rousskov> 1) Do we need to polish bad String users? Yes.
16:56 < hno> with a project goal of eleminating ObsoleteStrng.
16:56 < hno> 1. Yes.
16:56 < rousskov> 2) Do we commit new Buffer/String code. TBD.
16:57 < rousskov> 3) Do we immediately replace all old String users with code that uses new String. No.
16:57 < rousskov> So I think the only place where adri and I disagree is #2.
16:57 < adri> 4) Should new code and stuff outside of what uses String use the new API?
16:58 < rousskov> I want to make a decision and commit the new API. He wants #1 to happen first.
16:58 < adri> I disageree on that too
16:58 < rousskov> adri, that is part of #2. If something is committed, it should be used, of course.
16:58 < rousskov> There is no point in committing something we are not going to use.
16:59 < kinkie> rousskov: yes and no.. it could be committed so that everyone has a better chance to fix what's broken in it before using it
16:59  * adri sighs
16:59 < rousskov> kinkie, you do not know what is broken if you are not using it
16:59 < kinkie> Unless you want to work on my branch - which is of course also fine
17:00 < kinkie> misdesign for instance.. things I'm not able to understand
17:00 < rousskov> kinkie, you do not know what is broken if you are not using it
17:00 < rousskov> especially things like inferior design.
17:01 < kinkie> rousskov: there's also misimplementation issues.. I've had quite a few false steps where I misunderstood what you were objecting to, and tried fixing the wrong thing
17:01 < hno> Ok. here is a proposal. There is three tasks, all which need to be done.
17:01 < rousskov> Sure, but just committing code that nobody uses will not find any misimplementation issues.
17:02 < hno> 1. As above.
17:02 < kinkie> s/misimplementation/misdesign/
17:02 < hno> 2. Code needs to start using StringNg. Before merge.
17:03 < hno> 3. these reviews combined with 2 should highlught any possible misdesigns..
17:03 < hno> (well most..)
17:04 < hno> 1 & 2 can both start, and is independent.
17:04 < adri> Great, so whats your escape plan?
17:04 < rousskov> I am not against your proposal, but I think we need to agree on the initial design now, before #2 gets too far.
17:05 < rousskov> Kinkie is already reluctant to redo stuff and will be even more reluctant to redo stuff after converting a lot of code to use StringNg
17:05 < rousskov> understandably so!
17:06 < kinkie> rousskov: I'm reluctant to restart from scratch. If changes need to be applied, I'll gladly apply them.
17:06 < rousskov> It is all relative. Still I think the decision on the initial class hierarchy should happen now.
17:07 < adri> Why do you need to commit -all- of it right now?
17:07 < rousskov> hno plan does not call for commits right now.
17:07 < adri> 16:02 < hno> 2. Code needs to start using StringNg. Before merge.
17:07 < rousskov> See, _before_ merge.
17:07 < rousskov> Meaning that it is done on a branch.
17:08 < rousskov> To stress-test the initial design.
17:08 < adri> What I'm saying is
17:08 < adri> Don't even -do- that
17:08 < adri> Just leave the StringNg stuff alone
17:08 < rousskov> Yes, we know. You have a different plan.
17:08 < adri> Grab just the buffer stuff
17:08 < adri> stuff it into String, where it already assumes a NUL termintaed C buffer, so you're nto actually changing semantics
17:08 < adri> The amount of new code is minimised
17:09 < adri> Do the changes you have to do -anywa- to the main code to tidy things up
17:09 < kinkie> adri: the fact is that if the 'Universal String' approach goes through, there is no 'buffer stuff', everything happens within the Universal String.
17:09 < hno> 1 should be committed, incrementally.
17:09 < kinkie> and the 'buffer stuff' is almost a dumb struct.
17:10 < adri> and I'm saying we can blissfully ignore that right now to get a fraction of your stuff in, right now
17:10 < adri> so it can be used with minimal changes by a lot of the core code, right now
17:10 < adri> without changing semantics of -anything-
17:10 < rousskov> And if D&C gets through, I am not 100% against doing/committing Buffer alone first, although I think that would not be the best option.
17:10 < adri> do the needed changing
17:10 < adri> but limit the use of the new code to -just- String
17:10  * hno has to go. Dinner time.
17:10 < adri> anyway
17:10 < adri> I have to go do paid work
17:11 < adri> And try to eliminat ethe last couple memcpy()'s and *printf()s in the critical path
17:11 < adri> So I know what stuff needs stabbing in the longer term
17:13 < kinkie> In the meantime I'll open a feature-branch to start and work on (1), as it's an independent issue.
19:05 < kinkie> Hi all
19:19 < rousskov> kinkie, IIRC, you were wondering if regular Sunday chats are a good idea. FWIW, I would prefer a weekday chat and may have to miss many weekend chats.
19:20 < kinkie> sure.. the idea is, let's see if we can make up some more-or-less-regular schedule
19:20 < rousskov> A brief weekly chat would be neat.
19:21 < kinkie> fine by me. We need to agree on day and time, hopefully accomodating as many people as possible
19:44  * hno is back.
19:47 < rousskov> Seen recent emails on squid-dev? Can we agree on the step 2 of the plan and the initial class hierarchy?
19:47 < kinkie> welcome
19:48 < kinkie> Let me summarize what I understood of today's discussion and mails, so that I know how to move forward.
19:49 < kinkie> 1. I open a new feature-branch off trunk, dedicated to fixing OldString users. This will get aggressively merged so that stuff can be tested. Adrian will help me out with the nastier spots.
19:49 < hno> jwestfall: Initial reaction is that most likely storeUpdate() probably needs to be throttled allowing the swapout or internal client(when chained) to catch up..
19:50 < hno> kinkie: 1. Yes.
19:50 < kinkie> Some parts of the lower-layers of StringNg are sane under case 'UniversalString' and 'D&C (note)'. I can thus concentrate on those parts, applying some of the remarks Alex already sent me.
19:51 < hno> Yes. And when satisfied send those for review & merge again.
19:51 < kinkie> Ok.
19:51 < kinkie> Re 1: it may require extending the OldString API somewhat, without changing its innards significantly.
19:52  * hno sent a mail with more detailed producer use cases some minutes ago.
19:52  * kinkie checks
19:52 < kinkie> haven't gotten it yet.
19:53 < kinkie> The question: UniversalString or D&C still stands, but this strategy gives everyone more time to decide the best option forward.
19:54 < hno> It's about more than just String..
19:55 < hno> it's also about MemBuf, and lots of places where we still use "char *"...
19:55 < hno> and general way of design..
19:55 < kinkie> Yes.
19:55 < kinkie> In time, I hope most of those will just be converted away.
19:56 < kinkie> That 'more' part is the part I'm the most unfamiliar with, so I'll rely on the Team to define the best way forward. I hope that the discussion won't die off now to return in full force at the next merge request
19:56 < jwestfall> hi hno
19:56 < hno> We need a well defined foundation, and then start the migration onto that..
19:57 < hno> and getting rid of lots of legacy (OldString, MemBuf, strdup() etc..)
19:57 < rousskov> We need to make that decision.
19:58 < hno> rousskov: Which one?
19:58 < hno> moving forward, or staing in the worst position?
19:58 < rousskov> Step 1 is not blocked on it, but we need to decide on the set of "foundation" classes
19:59 < rousskov> And knowing the future foundation would help to avoid wrong changes in step 1 as well.
20:00 < hno> 1 is pretty isolated in it self, and likelyhood for wrong changes is low. But there is a significant risk that many areas touched in 1 then goes away or gets rewritten anyway.
20:00 < rousskov> So, we need to decide between Unified String and D&C (unless there are other design choices offered).
20:00 < hno> but 1 prepares te path.
20:01 < rousskov> Right. A lot of work in #1 may end up being a waste, but I am not against that step, especially if it makes Adrian happier
20:01 < kinkie> I kind of assume that everything touched in #1 will have to be re-touched in #2. But I don't mind that really
20:02 < hno> It makes 2 easier, as there is a more uniform codebase to deal with.
20:02 < kinkie> yes
20:02 < rousskov> My focus is on the classes at the moment. Kinkie and Adrian can handle #1 on their own, but they cannot handle #2.
20:02 < kinkie> AND it requires not to think about too many corner cases.
20:02 < kinkie> rousskov: yes
20:03 < kinkie> (I'm speaking for myself, Adiran is certainly more than able to handle his stuff)
20:05 < hno> My view doesn't really fit either of UniveralBuffer or D&C I think. And I don't quite get the Buffer in D&C..
20:07 < hno> but it's more aligned with D&C than UniversalBuffer I suppose.
20:07 < rousskov> Buffer is your Buffer, region of a memory area. (memory area, offset, size). 
20:07 < hno> rousskov: "works with Blob as a whole: not areas"
20:07 < rousskov> But see (note)
20:08 < rousskov> With (note), the area code is moved to Buffer, and it starts matching your Buffer
20:08 < hno> ok. So D&C is now the "possible variation" version?
20:10 < rousskov> I guess. To make it easier to reach a consensus
20:13 < hno> Then the difference between UniversalBuffer and D&C is how much to subclass Buffer into special-purpose classes for specific tasks, all inheriting Buffer, right?
20:13 < kinkie> as it is now String holds Buffer, doesn't inherit it.
20:14 < rousskov> hno, right
20:14 < rousskov> kinkie, does not matter
20:15 < kinkie> ok
20:17 < hno> On that I am pretty neutral as long as casting to/from Buffer is a cheap operation.
20:18 < hno> so actually I am more in the UniversalBuffer camp I guess. 
20:19 < hno> traceroute from squid-cache.org:  2  12.116.159.125 (12.116.159.125)  170.575 ms  181.820 ms  158.040 ms
20:19 < kinkie> whoa... reminds me of the 56k modem days
20:20 < rousskov> OK. So do we go with UniBuffer?
20:21 < rousskov> hno, how we will write I/O code that needs to read, append, consume? See my email.
20:21 < rousskov> Would not a custom buffer be better for that than one-size-fits-all?
20:22 < rousskov> With UniBuffer, the code itself will have to deal with allocation of new buffers...
20:22 < hno> As long as it's "refcounted Blob" + "Buffer with offset,length" I am happy. Don't care if Buffer is subclassed to special-purpose classes adding additional methods or one large jumo-class with all different operations we may need...
20:28 < jwestfall> hno any ideas on how to throttle the store update?
20:31 < rousskov> OK. Since nobody is pushing hard for D&C, let's do UniBuffer
20:32 < rousskov> nobody but me, I guess
20:36 < kinkie> rousskov: it's not that. for me it's that I don't see the advantage in the added complexity. Changing from one model to the other doesn't seem THAT hard, so the complexity may be added later if the need is there.
20:36 < kinkie> But again, I trust in the Team to choose what's right
20:38 < jwestfall> i imagine we need something like if(state->oldentry->mem_obj->inmem_hi - storeLowestMemReaderOffset(state->oldentry) > Config.readAheadGap) { stop reading } in storeUpdateCopy()
20:39 < rousskov> kinkie, it would be quite hard to split later.
20:39 < rousskov> because the user code will be written to morph meanings together
20:40 < rousskov> but this is not a Huge Deal for me. I can live with One Buffer For All. I might add custom buffers for I/O, but their use would be localized to low-level I/O code.
20:40 < kinkie> that's a possibility.
20:41 < kinkie> OR we may add specialized buffers and handy cast functions.. in the end it's all a (char*,len) or array of (char*,len)...
20:42 < rousskov> I am more worried, currently, about the smart heuristics you mentioned recently. Please keep the code as simple and straight as possible. Correctness comes before optimizations as long as there is room left for the latter.
20:42 < kinkie> just see SBuf::realloc_strategy(). It's all in there
20:43 < kinkie> maybe 20 LOC altogether
20:43 < rousskov> kinkie, that kind of "in the end" thinking is a bad idea for OO
20:44 < rousskov> I will check it out once you merge and apply my StringNg comments.
20:44 < kinkie> So you would object to a UniversalBuffer foo=SpecializedBuffer.convertToUniVersalBuffer()?
20:44 < kinkie> rousskov: ok
20:44 < hno> rousskov: I don't see much difference between UniBuffer and D&C with the note..
20:47 < hno> if you want a preference from me then my preference is specialized classes, and not everything jumbled togeter in a big mess. Blob, Buffer referencing Blob. String being a child of Buffer. Producers sitting somewhere inbetween as explained on squid-dev.
20:49 < rousskov> kinkie, that question lacks context.
20:50 < rousskov> hno, then why are you voting for UniBuffer?
20:50 < rousskov> hno, your vote is the deciding one here. There are less than two votes for D&C and less than two votes for UniBuffer.
20:51 < rousskov> We have to pick one and run with it.
20:52 < kinkie> rousskov: context is "general OOP". If you have a problem with two implementation of a mostly similar interface, one better in some scenarios and the other in others, what do you do? Try to merge them? Make them implementations of a pure-virtual and use static_cast? Or create a factory method in each to be used when appropriate? Just curious
20:56 < rousskov> The question is too general to answer, sorry.
20:56 < hno> Refcounted Blob + Buffer with offset,lenth is my vote. Today I don't care if there is one single Buffer class, or a class hierarchy for special purposes, at this stage I consider that more of an implementation detail that will give itself once things starts to be reasonably implemented. That's pretty easy to swich between as needed.
20:57 < rousskov> I disagree on the switch part.
20:57 < rousskov> hno, since the part of the design you vote for is common to both options, your vote does not help :-)
20:58 < hno> But if subclasses is used, then it should be restricted to adding new methods. Any design needing to venture into virtual methods should be avoided on Buffer.
20:58 < rousskov> I agree with no virtual in Buffer
20:58 < rousskov> Adding data members should be OK though.
21:01 < hno> Yes and no. Means it needs to be dynamically casted (copied), including blob refcount bumps. Not a problem if done right, but also easy to get wrong (in terms of performance, not code sanity).
21:01 < rousskov> kinkie, to sum it up, it looks like you should merge String back into Buffer. 
21:03 < kinkie> Ok. I'll add an edited log from today to the wiki with the contents of Sunday's discussion, and then then work on.
21:03 < rousskov> hno, probably does not matter for now, but I do not think there would be casting complications or performance overheads from adding data members to Buffer kids. Clearly, once such a kid is converted to Buffer, the added functionality would disappear. And that is OK.
21:04 < kinkie> I need to be off for 3 hours or so.. see you later
21:05 < rousskov> Buffer forTheRestOfTheCode; IoBuffer forThisIo; ...; forTheRestOfTheCode = forThisIo; // should work fine
21:05 < rousskov> This is just a sketch, of course.
21:07 < rousskov> Performance cost = one extra refcounted "copy".
21:07 < hno> rousskov: Just afraid there will be frequent for (something) { SpecialBuffer forMe = SomeBufferIFoundSomewhere; operations on forMe.. }
21:08 < rousskov> But even that is pretty cheap.
21:09 < rousskov> And probably better overall than spreading "special state" all over the place while manipulating a generic Buffer
21:09 < rousskov> Let's see how it plays out.
21:10 < hno> First steps is the same anyway, and is imho the hard part.
21:10 < rousskov> Agreed
21:11 < rousskov> hno, how does your schedule look now? Will you be able to resume Rock Store work soon?
21:11 < hno> I prefer deferring the discussion on UniBuffer vs hierarchy until there is something meaningful other than plain String to discuss around.
21:11 < hno> Yes.
21:12 < rousskov> hno, OK regarding deferring.
```

Discuss this page using the "Discussion" link in the main menu
