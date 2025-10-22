---
---
# ClientStreams API

ClientStreams provides an API to retrieve and manipulate data from
squid, from inside squid. Squid's ClientSide processing uses
ClientStreams to fulfill standard client HTTP requests.

What follows is a very slightly edited transcript (with permission) of
an IRC chat about ClientStreams, it needs to be cleaned up and made more
organised...

```irc
14:48 < nicholas> Hi. I'm working on bug 1160 (analyze HTML to prefetch embedded objects). I can't figure out why, but even though it
                  fetches the pages, it doesn't cache the result! The fetch is initiated with "fwdState(-1, entry, request);".
14:49 < lifeless> I'd use the same mechanism ESI does.
14:49 < nicholas> Ok, that's client streams.
14:49 < lifeless> the fwdState api is on the wrong side of the store
14:49 < nicholas> doh!
14:49 < lifeless> so it doesn't have any of the required logic - cachability, vary handling, updates of existing objects...
14:50 < lifeless> things like store digests just haven't been updated to use client streams yet.
14:50 < nicholas> What, concisely, is a store digest?
14:51 < lifeless> a bitmap that lossilly represents the contents of an entire squid cache, biased to hits.
14:51 < lifeless> uses a thing called a bloom filter
14:52 < lifeless> it lets squid predict that another cache will have a given object, for predictive routing (as opposed to ICP which is
                  reactive)
14:52 < nicholas> That's strange, but ok. I suppose it's necessary for performance when you have a large number of cached objects.
14:52 < lifeless> well its an optional feature.
14:53 < nicholas> Ok, I tried to track a standard request through the code and it runs through http.cc. Http.cc uses the store, but it
                  doesn't actually insert the object into the cache?
14:53 < lifeless> right.
14:54 < lifeless> http.cc just retrieves http objects, like ftp.cc retrieves ftp objects.
14:54 < nicholas> I'm on the wrong side of the fence. Gotcha.
14:54 < nicholas> Honestly, I spent about 5 days trying to understand the client stream API.
14:55 < nicholas> Concisely, what is a client stream? I suggested that they're a chain of observers to the results of a request. Is that
                  accurate?
14:56 < lifeless> http://www.squid-cache.org/Doc/FAQ/FAQ-16.html
14:57 < lifeless> client streams..
14:57 < lifeless> they are a 'chain of responsibility' pattern.
14:58 < lifeless> sortof.
14:58 < lifeless> the clientStream code was started in C in the squid 2.6 timeframe, it needs an overhaul badly, now we can actually
                  write this sort of code more cleanly.
14:59 < nicholas> Right, I noticed that the code is in flux. Might I add that I don't like CBDATA either ... not that I'm offering to do
                  better.
15:00 < nicholas> For a ClientStreamData, I'm supposed to create my own Data class which is derived from, er, Refcountable? Then let the
                  ClientStreamData's internal pointer point to my object, then upcast it when my callbacks are called?
15:01 < nicholas> See, I don't really understand what my callbacks are really supposed to do, since I only want "default" behaviour. As
                  in, whatever squid normally does to cache/handle a request, expect that there's no sender to send it to.
15:02 < lifeless> well you don't want that.
15:02 < lifeless> because you don't want to parse requests.
15:02 < lifeless> ClientSocketContext is likely to be the closest thing to what you want though.
15:03 < lifeless> so your readfunc needs to eat all the data it receives.
15:04 < lifeless> you can throw it away.
15:04 < lifeless> your detach function can just call clientStreamDetach(node, http);
15:04 < nicholas> so do I add my function into ClientSocketContext's read function?
15:04 < lifeless> see clientSocketDetach
15:04 < nicholas> or do I add another node in the clientStream?
15:04 < lifeless> no, you should have all your stuff in its own .cc file.
15:04 < lifeless> you'll construct a new clientStream to service your requests.
15:05 < nicholas> Oh it is, but somebody has to enter my .cc file at some point, right?
15:05 < lifeless> right, you should have that already written though - whatever is doing the parsing should already be a clientStream
15:06 < nicholas> Nope. I just hacked it into http.cc.
15:06 < lifeless> if its not, then don't worry for now, get it working is the first step.
15:06 < nicholas> Not that I can't move it pretty easily.
15:06 < nicholas> Everything works, except that it doesn't cache what it fetches. And now I know why.
15:06 < lifeless> your Status calls should always return prev()->status()
15:07 < lifeless> the callback call is the one that is given the data, it too should throw it away.
15:08 < nicholas> and someone else will cache it?
15:08 < lifeless> yes
15:08 < nicholas> ok, I assume you're talking about just the fetching part?
15:08 < lifeless> I'm talking about the clientStream node you need to implement.
15:09 < nicholas> so when I know a URL that I want to prefetch, I create my clientStream with this one node that you just described.
15:10 < lifeless> ESIInclude.cc shows this well
15:10 < nicholas> I've spent a lot of time reading it, but since I didn't understand clientStreams, I never managed to quite figure it
                  out.
15:11 < lifeless> ok, start with ESIInclude::Start
15:11 < lifeless> this calls clientBeginRequest
15:12 < nicholas> esiBufferRecipient seems to do a lot of work, including checking whether the HTTP stream succeeded or failed, and
                  loading it into the store  (maybe, I'm not clear on the store API either).
15:12 < lifeless> it passes in the clientStream callbacks - esiBufferRecipient, esiBufferDetach, the streamdata (stream.getRaw()), the
                  http headers its synthetic request needs.
15:12 < nicholas> oh right, this code. Yes, I cut'n'pasted this in, but I never got it working for me.
15:12 < lifeless> esiBuffer recipient copies the object back into the ESI master document.
15:12 < lifeless> so it has to do a bunch more work than you'll need to.
15:13 < nicholas> stream.getRaw() is a pointer to the node, yes? I could the code around that confusing.
15:14 < lifeless> stream is a ESIStreamContext which is a clientStream node that pulls data from a clientstream, instances of which are
                  used by both the master esi document and includes
15:14 < lifeless> (different instances, but the logic is shared by composition)
15:14 < lifeless> that is pased into ESIInclude::Start because ESI includes have a primary include and an 'alternate' include.
15:16 < lifeless> so all you need to start the chain is:
15:16 < nicholas> I see. I won't need to worry about any of that.
15:16 < lifeless> HttpHeader tempheaders(hoRequest);
15:17 < lifeless> if (clientBeginRequest(METHOD_GET, url, aBufferRecipient, aBufferDetach, aStreamInstance, &tempheaders,
                  aStreamInstance->buffer->buf, HTTP_REQBUF_SZ))
15:17 < lifeless>   {
15:17 < lifeless>   /* handle failure */
15:17 < lifeless> }
15:17 < lifeless> httpHeaderClean (&tempheaders);
15:18 < lifeless> that will cause callbacks to aBufferRecipient, aBufferDetach to occur
15:19 < lifeless> then in the buffer recipient you throw them away, just check for status codes etc.
15:19 < lifeless> and I've given you the skeleton for detach above.
15:20 < lifeless> aStreamInstance is just a cbdata class that has your context.
15:20 < lifeless> i.e.
15:21 < lifeless> class myStream {
15:21 < lifeless> public
15:21 < lifeless> :
15:21 < lifeless> static void BufferData (clientStreamNode *, ClientHttpRequest *, HttpReply *, StoreIOBuffer);
15:21 < lifeless> static void Detach (clientStreamNode *, ClientHttpRequest *);
15:22 < lifeless> private:
15:22 < lifeless> CBDATA_CLASS2(myStream);
15:22 < lifeless> void buferData (clientStreamNode *, ClientHttpRequest *, HttpReply *, StoreIOBuffer);
15:22 < lifeless> void detach (clientStreamNode *, ClientHttpRequest *);
15:22 < lifeless> }
15:22 < lifeless> ;
15:23 < lifeless> then in your .cc file...
15:23 < lifeless> CBDATA_CLASS_INIT(myStream);
15:23 < nicholas> the cbdata init line, i presume?
15:23 < lifeless> those CBDATA macros setup new and delete to do the right thing.
15:23 < lifeless> then your static functions are just
15:23 < nicholas> i don't need to write my own void *operator new?
15:24 < lifeless> no, you don't.
15:24 < lifeless> void
15:24 < nicholas> phew. :)
15:24 < lifeless> myStream::BufferData (clientStreamNode *node, ClientHttpRequest *, HttpReply *, StoreIOBuffer)
15:24 < lifeless> {
15:24 < lifeless> if (!cbdataReferenceValid(node->data))
15:25 < lifeless>  /* something weird has happened - your data has been freed, but a callback has still been issued. deal here */
15:25 < lifeless> static_cast<myStream *>(node->data)->bufferData(node, ...);
15:25 < lifeless> }
15:25 < lifeless> and likewise for the Detach static method
15:26 < lifeless> is this making sense ?
15:27 < nicholas> yes, but just let me reread a litt.e
15:27 < lifeless> ok, there's one more important thing :)
15:27 < nicholas> "static_cast<myStream *>(node->data)->bufferData(node, ...)" calls myStream::BufferData doesn't it? So why am I calling
                  myself?
15:28 < lifeless> lowercase bufferData :)
15:28 < nicholas> oh man, i thought that was just a typo. now i have to reread all of it!
15:28 < lifeless> the static functions (denoted with the initial Capital) are thunks into the actual instance methods.
15:29 < nicholas> which makes sense. yes.
15:29 < lifeless> http://www.squid-cache.org/~robertc/squid-3-style.txt
15:29 < nicholas> but what does bufferData actually do? let's see if i do understand this ...
15:29 < nicholas> ... it'll receive the contents of the page that I requested from clientBeginRequest, so I just discard them. check?
15:29 < lifeless> bufferData needs to do two things. it needs to check the status of node->next()
15:30 < lifeless> and on everything other than error or end-of-stream, it needs to issue a new read.
15:30 < nicholas> hm, ok.
15:31 < lifeless> if something like a 404 occurs, you'll get that as the HttpReply in the first call to bufferData.
15:31 < nicholas> and it will already be (negatively) entered into the cache for me
15:31 < nicholas> so i just ... don't do anything.
15:31 < lifeless> exactly.
15:31 < lifeless> just swallow the data until node->next()->status() returns an error.
15:32 < nicholas> if it was a successful read, but the connection is still open, i read more.
15:32 < nicholas> ok.
15:32 < nicholas> now let me ask you about the other half: analyzing pages that come in.
15:32 < lifeless> if its not an error, to swallow more data you call ->readfunc()
15:32 < lifeless> you'll need a buffer area in your class instance.
15:32 < lifeless> (although to be tricky you could use a static buffer in your class, as you don't care about the data)
15:33 < nicholas> (ah, nice trick! didn't think of that.)
15:33 < nicholas> I told you earlier that I just hacked my analyzer into http.cc. While this works for me, is there a better place to put
                  it? Especially if I want you devs to accept the patch?
15:34 < lifeless> wbut I wouldn't worry about that - just have a HTTP_REQBUF_SZ char array in your private data.
15:34 < nicholas> I was using SM_PAGE_SIZE.
15:35 < lifeless> ok, where to put the analyzer ? we've got some rework we want to do in the request flow that would make this a lot
                  easier to answer.
15:35 < lifeless> I think that the right place for now, is exactly where esi goes, and after esi in the chain.
15:35 < lifeless> the problem with where you are is that ftp pages won't be analysed. and if its an esi upstream then the urls could be
                  wrong (for instance)
15:35 < nicholas> http requests that come in from clients have a client stream chain?
15:36 < lifeless> yup
15:36 < nicholas> hunh. i didn't even notice.
15:36 < lifeless> client_side_reply.cc line 1927
15:36 < nicholas> who installs ESIs ...
15:36 -!- Irssi: Pasting 11 lines to #squiddev. Press Ctrl-K if you wish to do this or Ctrl-C to cancel.
15:36 < lifeless> #if ESI
15:36 < lifeless>     if (http->flags.accel && rep->sline.status != HTTP_FORBIDDEN &&
15:36 < lifeless>             !alwaysAllowResponse(rep->sline.status) &&
15:36 < lifeless>             esiEnableProcessing(rep)) {
15:36 < lifeless>         debug(88, 2) ("Enabling ESI processing for %s\n", http->uri);
15:36 < lifeless>         clientStreamInsertHead(&http->client_stream, esiStreamRead,
15:36 < lifeless>                                esiProcessStream, esiStreamDetach, esiStreamStatus, NULL);
15:36 < lifeless>     }
15:36 < lifeless> #endif
15:36 < nicholas> yep, i've got the code up here.
15:37 < nicholas> clientStreamInsertHead. awesome.
15:37 < lifeless>  this says - if its an accelerated request that isn't an deny-error page, and its a response that is amenable to
                  processing, and it passes the esi logic checks.. then add a new head.
15:37 < nicholas> Nod. For me, I just need to know whether the mime-type is HTML or not.
15:38 < lifeless> you'll want to add your head before esi, so that you come after esi in the processing.
15:38 < nicholas> So the headers need to be complete and processed before I know whether to add myself.
15:38 < lifeless> so right before that #if ESI line.
15:39 < nicholas> Oh, I see it has the body at this point already?
15:39 < nicholas> Or does it just have a partial body?
15:39 < lifeless> it may have some body, but it definitely has the reply metadata
15:39 < nicholas> Because my code is rigged to work with partial data.
15:39 < nicholas> ok, good.
15:39 < nicholas> Then that's *exactly* right.
15:39 < lifeless> so you can just look in rep-> to get the headers already parsed.
15:39 < nicholas> yep.
15:40 < lifeless> and you'll get called with whatever data is available in your buffer function.
15:40 < nicholas> Perfect.
15:40 < lifeless> your buffer function should analyse, then call node->next()->callback(node->next(), ...)
15:41 < lifeless> when a read is issued, there is one complication :
15:41 < nicholas> So that ESI or whomever can do it.
15:41 < nicholas> s/it/their thing/
15:41 < lifeless> if the client wants a range request, the read issued to you may be for partial data.
15:41 < nicholas> Will there be a flag on those? So I can avoid them?
15:42 < lifeless> so you have a choice. like ESI you can force ranges off for what you request, and filter out what you supply according
                  to what is requested from you.
15:42 < lifeless> alternatively, and for you I think better, just don't add yourself to the chain at all if its a range request.
15:42 < nicholas> Well, what I request will never be ranged. But, what I analyze isn't necessarily what I requested.
15:43 < nicholas> It will normally be the request from the user agent. That's the point.
15:43 < lifeless> in your if block in client_side_reply just check http->request->range
```
