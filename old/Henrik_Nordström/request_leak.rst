request_t leak trace

<<TableOfContents(2)>>


= Notes =

= Backtrace =

== 01 requestLink clientTryParseRequest src/client_side.c:4292 conn=0x7ffff5a10f10 ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000445251 in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4292
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff5467a20
	msg = {
  buf = 0x7ffff546ac40 "POST http://localhost:5555/ HTTP/1.0\nContent-Length: 100\n\n", size = 58, h_start = 37, h_end = 56, h_len = 19, req_start = 0, 
  req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, u_start = 5, 
  u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, v_maj = 1, 
  v_min = 0}
#2  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 1
	F = (fde *) 0x7ffff5b71cc0
	len = 4038
	ret = 0
#3  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#4  0x000000000044df58 in do_comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#5  0x000000000044d9d2 in comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.0951991
	last_timeout = 1234777391.5402601
#6  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 462

}}}

== 02 requestLink clientTryParseRequest src/client_side.c:4293 conn=0x7ffff5a10f10 ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000445265 in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4293
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff5467a20
	msg = {
  buf = 0x7ffff546ac40 "POST http://localhost:5555/ HTTP/1.0\nContent-Length: 100\n\n", size = 58, h_start = 37, h_end = 56, h_len = 19, req_start = 0, 
  req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, u_start = 5, 
  u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, v_maj = 1, 
  v_min = 0}
#2  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 1
	F = (fde *) 0x7ffff5b71cc0
	len = 4038
	ret = 0
#3  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#4  0x000000000044df58 in do_comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#5  0x000000000044d9d2 in comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.0951991
	last_timeout = 1234777391.5402601
#6  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 462

}}}

== 03 requestLink aclChecklistCreate acl.c:2433 checklist=0x7ffff5496340 ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x7ffff5c1fb60, 
    request=0x7ffff5467a20, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 50
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x7ffff5c1fb60, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x7fffffffdfc0
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x00000000004409da in clientMaxRequestBodySize (request=0x7ffff5467a20, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2788
	bs = (body_size *) 0x7ffff5c1fae0
	checklist = (aclCheck_t *) 0x10f0043ce67
#4  0x0000000000440a98 in clientRequestBodyTooLarge (http=0x7ffff5a111d0, 
    request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2807
No locals.
#5  0x0000000000445320 in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4303
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff5467a20
	msg = {
  buf = 0x7ffff546ac40 "POST http://localhost:5555/ HTTP/1.0\nContent-Length: 100\n\n", size = 58, h_start = 37, h_end = 56, h_len = 19, req_start = 0, 
  req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, u_start = 5, 
  u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, v_maj = 1, 
  v_min = 0}
#6  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 1
	F = (fde *) 0x7ffff5b71cc0
	len = 4038
	ret = 0
#7  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#8  0x000000000044df58 in do_comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#9  0x000000000044d9d2 in comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.0951991
	last_timeout = 1234777391.5402601
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 462

}}}

== 04 requestUnlink aclChecklistFree acl.c:2274 checklist=0x7ffff5496340 ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x0000000000440a5a in clientMaxRequestBodySize (request=0x7ffff5467a20, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2798
	bs = (body_size *) 0x0
	checklist = (aclCheck_t *) 0x7ffff5496340
#3  0x0000000000440a98 in clientRequestBodyTooLarge (http=0x7ffff5a111d0, 
    request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2807
No locals.
#4  0x0000000000445320 in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4303
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff5467a20
	msg = {
  buf = 0x7ffff546ac40 "POST http://localhost:5555/ HTTP/1.0\nContent-Length: 100\n\n", size = 58, h_start = 37, h_end = 56, h_len = 19, req_start = 0, 
  req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, u_start = 5, 
  u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, v_maj = 1, 
  v_min = 0}
#5  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 1
	F = (fde *) 0x7ffff5b71cc0
	len = 4038
	ret = 0
#6  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#7  0x000000000044df58 in do_comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#8  0x000000000044d9d2 in comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.0951991
	last_timeout = 1234777391.5402601
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 462

}}}

== 05 requestLink aclChecklistCreate acl.c:2433 checklist=0x7ffff5496340 ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x8e92e0, 
    request=0x7ffff5467a20, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 0
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x8e92e0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x0
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x0000000000439350 in clientAccessCheck (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:359
	http = (clientHttpRequest *) 0x7ffff5a111d0
#4  0x000000000043932a in clientCheckFollowXForwardedFor (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:352
	http = (clientHttpRequest *) 0x7ffff5a111d0
#5  0x000000000044549b in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4324
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff5467a20
	msg = {
  buf = 0x7ffff546ac40 "POST http://localhost:5555/ HTTP/1.0\nContent-Length: 100\n\n", size = 58, h_start = 37, h_end = 56, h_len = 19, req_start = 0, 
  req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, u_start = 5, 
  u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, v_maj = 1, 
  v_min = 0}
#6  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 1
	F = (fde *) 0x7ffff5b71cc0
	len = 4038
	ret = 0
#7  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#8  0x000000000044df58 in do_comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#9  0x000000000044d9d2 in comm_select (msec=445)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.0951991
	last_timeout = 1234777391.5402601
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 462

}}}

== 06 requestLink aclChecklistCreate acl.c:2433 checklist=0x7ffff5497da0 ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x7ffff5c1fcc0, 
    request=0x7ffff5467a20, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 0
	checklist = (aclCheck_t *) 0x7ffff5497da0
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x7ffff5c1fcc0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x7ffff5497cc0
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x00000000004408e9 in clientMaxRequestBodyDelayForwardSize (
    request=0x7ffff5467a20, http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2760
	bs = (body_size *) 0x7ffff5c1fc40
	checklist = (aclCheck_t *) 0x7ffff5497cc0
#4  0x0000000000443201 in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3759
	r = (request_t *) 0x7ffff5467a20
	bytes_read = 0
	bytes_left = 100
	bytes_to_delay = 32767
#5  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	err = (ErrorState *) 0x0
#6  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	rep = (HttpReply *) 0x0
#7  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#8  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#9  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#10 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#11 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#12 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#13 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff5467a20
	urlgroup = 0x0
#14 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#15 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#16 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#17 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#18 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#19 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#20 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#21 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#22 0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#23 0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#24 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 07 requestUnlink aclChecklistFree acl.c:2274 checklist=0x7ffff5497da0 ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5497da0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x0000000000440969 in clientMaxRequestBodyDelayForwardSize (
    request=0x7ffff5467a20, http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2770
	bs = (body_size *) 0x0
	checklist = (aclCheck_t *) 0x7ffff5497da0
#3  0x0000000000443201 in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3759
	r = (request_t *) 0x7ffff5467a20
	bytes_read = 0
	bytes_left = 100
	bytes_to_delay = 32767
#4  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	err = (ErrorState *) 0x0
#5  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	rep = (HttpReply *) 0x0
#6  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#8  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#9  0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#10 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#11 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#12 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff5467a20
	urlgroup = 0x0
#13 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#14 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#15 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#16 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#17 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#18 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#19 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#20 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#21 0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#22 0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#23 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 08 requestLink fwdStart forward.c:937 fwdState=0x41ee57 ??? ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000045fe05 in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:937
	fwdState = (FwdState *) 0x41ee57
	answer = 1
	err = (ErrorState *) 0x0
#2  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff5467a20
#3  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff5467a20
	bytes_read = 0
	bytes_left = 100
	bytes_to_delay = 0
#4  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	err = (ErrorState *) 0x0
#5  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	rep = (HttpReply *) 0x0
#6  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#8  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#9  0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#10 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#11 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#12 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff5467a20
	urlgroup = 0x0
#13 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#14 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#15 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#16 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#17 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#18 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#19 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#20 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#21 0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#22 0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#23 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 09 requestLink fwdStart forward.c:967 fwdState=0x7ffff5497f00 ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000045fecd in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:967
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#2  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff5467a20
#3  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff5467a20
	bytes_read = 0
	bytes_left = 100
	bytes_to_delay = 0
#4  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	err = (ErrorState *) 0x0
#5  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	rep = (HttpReply *) 0x0
#6  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#8  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#9  0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#10 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#11 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#12 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff5467a20
	urlgroup = 0x0
#13 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#14 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#15 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#16 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#17 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#18 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#19 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#20 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#21 0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#22 0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#23 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 10 requestLink peerSelect peer_select.c:144 psstate=0x7ffff5497fb0 ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000049e5b2 in peerSelect (request=0x7ffff5467a20, 
    entry=0x7ffff5497a00, callback=0x45f4e6 <fwdStartComplete>, 
    callback_data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:144
	psstate = (ps_state *) 0x7ffff5497fb0
#2  0x000000000045ff5d in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:983
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#3  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff5467a20
#4  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff5467a20
	bytes_read = 0
	bytes_left = 100
	bytes_to_delay = 0
#5  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	err = (ErrorState *) 0x0
#6  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	rep = (HttpReply *) 0x0
#7  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#8  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#9  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#10 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#11 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#12 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#13 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff5467a20
	urlgroup = 0x0
#14 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#15 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#16 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#17 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#18 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#19 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#20 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#21 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#22 0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#23 0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#24 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 11 requestLink aclChecklistCreate acl.c:2433 checklist=0x7ffff5497da0 ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x918390, 
    request=0x7ffff5467a20, ident=0x0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 32767
	checklist = (aclCheck_t *) 0x7ffff5497da0
#2  0x000000000049ebd0 in peerSelectFoo (ps=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:245
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff5467a20
#3  0x000000000049e641 in peerSelect (request=0x7ffff5467a20, 
    entry=0x7ffff5497a00, callback=0x45f4e6 <fwdStartComplete>, 
    callback_data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:155
	psstate = (ps_state *) 0x7ffff5497fb0
#4  0x000000000045ff5d in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:983
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#5  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff5467a20
#6  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff5467a20
	bytes_read = 0
	bytes_left = 100
	bytes_to_delay = 0
#7  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	err = (ErrorState *) 0x0
#8  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	rep = (HttpReply *) 0x0
#9  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#10 0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#11 0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#12 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#13 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#14 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#15 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff5467a20
	urlgroup = 0x0
#16 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#17 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#18 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#19 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#20 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#21 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#22 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#23 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#24 0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#25 0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#26 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 12 requestUnlink peerSelectStateFree peer_select.c:103 psstate=0x7ffff5497fb0 ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000049e355 in peerSelectStateFree (psstate=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:103
No locals.
#2  0x000000000049e976 in peerSelectCallback (psstate=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:203
	entry = (StoreEntry *) 0x7ffff5497a00
	fs = (FwdServer *) 0x7ffff54980c0
	data = (void *) 0x7ffff5497f00
#3  0x000000000049ee29 in peerSelectFoo (ps=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:307
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff5467a20
#4  0x000000000049e73b in peerCheckAlwaysDirectDone (answer=0, 
    data=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:175
	psstate = (ps_state *) 0x7ffff5497fb0
#5  0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5497da0, 
    answer=ACCESS_DENIED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#6  0x000000000041ed92 in aclCheck (checklist=0x7ffff5497da0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2267
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x0
	match = 0
	ia = (ipcache_addrs *) 0x7fffffffdb10
#7  0x000000000041f305 in aclNBCheck (checklist=0x7ffff5497da0, 
    callback=0x49e6c0 <peerCheckAlwaysDirectDone>, 
    callback_data=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2451
No locals.
#8  0x000000000049ebf7 in peerSelectFoo (ps=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:249
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff5467a20
#9  0x000000000049e641 in peerSelect (request=0x7ffff5467a20, 
    entry=0x7ffff5497a00, callback=0x45f4e6 <fwdStartComplete>, 
    callback_data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:155
	psstate = (ps_state *) 0x7ffff5497fb0
#10 0x000000000045ff5d in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:983
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#11 0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff5467a20
#12 0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff5467a20
	bytes_read = 0
	bytes_left = 100
	bytes_to_delay = 0
#13 0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	err = (ErrorState *) 0x0
#14 0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	rep = (HttpReply *) 0x0
#15 0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#16 0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#17 0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#18 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#19 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#20 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#21 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff5467a20
	urlgroup = 0x0
#22 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#23 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#24 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#25 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#26 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#27 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#28 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#29 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#30 0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#31 0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#32 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 13 requestUnlink aclChecklistFree acl.c:2274 checklist=0x7ffff5497da0 ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5497da0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x000000000041ef19 in aclCheckCallback (checklist=0x7ffff5497da0, 
    answer=ACCESS_DENIED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2302
No locals.
#3  0x000000000041ed92 in aclCheck (checklist=0x7ffff5497da0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2267
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x0
	match = 0
	ia = (ipcache_addrs *) 0x7fffffffdb10
#4  0x000000000041f305 in aclNBCheck (checklist=0x7ffff5497da0, 
    callback=0x49e6c0 <peerCheckAlwaysDirectDone>, 
    callback_data=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2451
No locals.
#5  0x000000000049ebf7 in peerSelectFoo (ps=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:249
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff5467a20
#6  0x000000000049e641 in peerSelect (request=0x7ffff5467a20, 
    entry=0x7ffff5497a00, callback=0x45f4e6 <fwdStartComplete>, 
    callback_data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:155
	psstate = (ps_state *) 0x7ffff5497fb0
#7  0x000000000045ff5d in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:983
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#8  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff5467a20
#9  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff5467a20
	bytes_read = 0
	bytes_left = 100
	bytes_to_delay = 0
#10 0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	err = (ErrorState *) 0x0
#11 0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff5467a20
	rep = (HttpReply *) 0x0
#12 0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#13 0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#14 0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#15 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#16 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#17 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#18 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff5467a20
	urlgroup = 0x0
#19 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#20 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#21 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#22 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#23 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#24 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#25 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#26 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#27 0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#28 0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#29 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 14 requestUnlink aclChecklistFree acl.c:2274 checklist=0x7ffff5496340 ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x000000000041ef19 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2302
No locals.
#3  0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#4  0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#5  0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff54965a0
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777392"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:43:12 CET 2009"
	log = 0x7ffff5a80669 "time=1234777392"
	entry = (external_acl_entry *) 0x7ffff54907a0
#6  0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#7  0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#8  0x000000000044df58 in do_comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#9  0x000000000044d9d2 in comm_select (msec=131)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.4083519
	last_timeout = 1234777391.5402601
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 148

}}}

== 15 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000477af2 in httpStart (fwd=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1587
	fd = 26
	httpState = (HttpStateData *) 0x7ffff5498610
	proxy_req = (request_t *) 0x1a00000000
	orig_req = (request_t *) 0x7ffff5467a20
#2  0x000000000045f876 in fwdDispatch (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:795
	p = (peer *) 0x0
	request = (request_t *) 0x7ffff5467a20
	entry = (StoreEntry *) 0x7ffff5497a00
	err = (ErrorState *) 0x7ffff5b7298d
	server_fd = 26
	fs = (FwdServer *) 0x7ffff54980c0
#3  0x000000000045e6aa in fwdConnectDone (server_fd=26, status=0, 
    data=0x7ffff5497f00) at /home/henrik/SRC/squid/commit-2/src/forward.c:366
	fwdState = (FwdState *) 0x7ffff5497f00
	fs = (FwdServer *) 0x7ffff54980c0
	err = (ErrorState *) 0x7ffff5498310
	request = (request_t *) 0x7ffff5467a20
#4  0x0000000000449d8f in commConnectCallback (cs=0x7ffff5498290, status=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:386
	callback = (CNCB *) 0x45e44b <fwdConnectDone>
	data = (void *) 0x7ffff5497f00
	fd = 26
#5  0x000000000044a2da in commConnectHandle (fd=26, data=0x7ffff5498290)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:505
	cs = (ConnectStateData *) 0x7ffff5498290
#6  0x000000000044d6e4 in comm_call_handlers (fd=26, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44a1f7 <commConnectHandle>
	hdl_data = (void *) 0x7ffff5498290
	do_write = 4
	F = (fde *) 0x7ffff5b72980
	do_incoming = 0
#7  0x000000000044df58 in do_comm_select (msec=0)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 115
#8  0x000000000044d9d2 in comm_select (msec=0)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.8147581
	last_timeout = 1234777392.8147581
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 0

}}}

== 16 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000477b06 in httpStart (fwd=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1588
	fd = 26
	httpState = (HttpStateData *) 0x7ffff5498610
	proxy_req = (request_t *) 0x1a00000000
	orig_req = (request_t *) 0x7ffff5467a20
#2  0x000000000045f876 in fwdDispatch (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:795
	p = (peer *) 0x0
	request = (request_t *) 0x7ffff5467a20
	entry = (StoreEntry *) 0x7ffff5497a00
	err = (ErrorState *) 0x7ffff5b7298d
	server_fd = 26
	fs = (FwdServer *) 0x7ffff54980c0
#3  0x000000000045e6aa in fwdConnectDone (server_fd=26, status=0, 
    data=0x7ffff5497f00) at /home/henrik/SRC/squid/commit-2/src/forward.c:366
	fwdState = (FwdState *) 0x7ffff5497f00
	fs = (FwdServer *) 0x7ffff54980c0
	err = (ErrorState *) 0x7ffff5498310
	request = (request_t *) 0x7ffff5467a20
#4  0x0000000000449d8f in commConnectCallback (cs=0x7ffff5498290, status=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:386
	callback = (CNCB *) 0x45e44b <fwdConnectDone>
	data = (void *) 0x7ffff5497f00
	fd = 26
#5  0x000000000044a2da in commConnectHandle (fd=26, data=0x7ffff5498290)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:505
	cs = (ConnectStateData *) 0x7ffff5498290
#6  0x000000000044d6e4 in comm_call_handlers (fd=26, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44a1f7 <commConnectHandle>
	hdl_data = (void *) 0x7ffff5498290
	do_write = 4
	F = (fde *) 0x7ffff5b72980
	do_incoming = 0
#7  0x000000000044df58 in do_comm_select (msec=0)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 115
#8  0x000000000044d9d2 in comm_select (msec=0)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.8147581
	last_timeout = 1234777392.8147581
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 0

}}}

== 17 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000445cc5 in clientReadBody (request=0x7ffff5467a20, 
    buf=0x7ffff5499c30 "", size=8192, 
    callback=0x477cf0 <httpRequestBodyHandler>, cbdata=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4493
	conn = (ConnStateData *) 0x7ffff5a10f10
#2  0x00000000004833c2 in requestReadBody (request=0x7ffff5467a20, 
    buf=0x7ffff5499c30 "", size=8192, 
    callback=0x477cf0 <httpRequestBodyHandler>, cbdata=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:200
No locals.
#3  0x0000000000477fdc in httpSendRequestEntry (fd=26, bufnotused=0x0, 
    size=200, errflag=0, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1693
	httpState = (HttpStateData *) 0x7ffff5498610
	entry = (StoreEntry *) 0x7ffff5497a00
#4  0x000000000044934c in CommWriteStateCallbackAndFree (fd=26, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b72a90
	callback = (CWCB *) 0x477e92 <httpSendRequestEntry>
	data = (void *) 0x7ffff5498610
#5  0x000000000044c609 in commHandleWrite (fd=26, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 200
	nleft = 200
	writesz = 200
	state = (CommWriteStateData *) 0x7ffff5b72a90
#6  0x000000000044d6e4 in comm_call_handlers (fd=26, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b72980
	do_incoming = 0
#7  0x000000000044df58 in do_comm_select (msec=0)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#8  0x000000000044d9d2 in comm_select (msec=0)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777392.8787429
	last_timeout = 1234777392.8147581
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 0

}}}

== 18 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x8e8860, 
    request=0x7ffff5467a20, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 32767
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x8e8860, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x416b30
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x000000000044064d in clientMaxBodySize (request=0x7ffff5467a20, 
    http=0x7ffff5a111d0, reply=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2670
	bs = (body_size *) 0x8e87e0
	checklist = (aclCheck_t *) 0x7ffff54acd20
#4  0x0000000000440ed7 in clientSendHeaders (data=0x7ffff5a111d0, 
    rep=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2930
	delayid = 32767
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	conn = (ConnStateData *) 0x7ffff5a10f10
	fd = 18
#5  0x00000000004c4b42 in storeClientCopyHeadersCB (data=0x7ffff5497cc0, nr=
      {node = 0x0, offset = -1}, size=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:755
	sc = (store_client *) 0x7ffff5497cc0
#6  0x00000000004c3029 in storeClientCallback (sc=0x7ffff5497cc0, sz=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:153
	new_callback = (STNCB *) 0x4c4a80 <storeClientCopyHeadersCB>
	cbdata = (void *) 0x7ffff5497cc0
	nr = {node = 0x7ffff54abc60, offset = 0}
#7  0x00000000004c36ab in storeClientCopy3 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:327
	mem = (MemObject *) 0x7ffff5497a70
	sz = 100
#8  0x00000000004c33b6 in storeClientCopy2 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:255
No locals.
#9  0x00000000004c461e in InvokeHandlers (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:664
	i = 0
	mem = (MemObject *) 0x7ffff5497a70
	sc = (store_client *) 0x7ffff5497cc0
	nx = (dlink_node *) 0x0
	node = (dlink_node *) 0x7ffff5497d28
#10 0x00000000004bff94 in storeComplete (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1433
No locals.
#11 0x0000000000460538 in fwdComplete (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:1141
	e = (StoreEntry *) 0x7ffff5497a00
#12 0x0000000000475848 in httpAppendBody (httpState=0x7ffff5498610, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:898
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff5467a20
	orig_request = (const request_t *) 0x7ffff5467a20
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#13 0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff5498610
	buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
#14 0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff5498610
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#15 0x000000000044df58 in do_comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#16 0x000000000044d9d2 in comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777394.8992441
	last_timeout = 1234777394.8142641
#17 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 916

}}}

== 19 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x00000000004406d8 in clientMaxBodySize (request=0x7ffff5467a20, 
    http=0x7ffff5a111d0, reply=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2681
	bs = (body_size *) 0x0
	checklist = (aclCheck_t *) 0x7ffff5496340
#3  0x0000000000440ed7 in clientSendHeaders (data=0x7ffff5a111d0, 
    rep=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2930
	delayid = 32767
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	conn = (ConnStateData *) 0x7ffff5a10f10
	fd = 18
#4  0x00000000004c4b42 in storeClientCopyHeadersCB (data=0x7ffff5497cc0, nr=
      {node = 0x0, offset = -1}, size=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:755
	sc = (store_client *) 0x7ffff5497cc0
#5  0x00000000004c3029 in storeClientCallback (sc=0x7ffff5497cc0, sz=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:153
	new_callback = (STNCB *) 0x4c4a80 <storeClientCopyHeadersCB>
	cbdata = (void *) 0x7ffff5497cc0
	nr = {node = 0x7ffff54abc60, offset = 0}
#6  0x00000000004c36ab in storeClientCopy3 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:327
	mem = (MemObject *) 0x7ffff5497a70
	sz = 100
#7  0x00000000004c33b6 in storeClientCopy2 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:255
No locals.
#8  0x00000000004c461e in InvokeHandlers (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:664
	i = 0
	mem = (MemObject *) 0x7ffff5497a70
	sc = (store_client *) 0x7ffff5497cc0
	nx = (dlink_node *) 0x0
	node = (dlink_node *) 0x7ffff5497d28
#9  0x00000000004bff94 in storeComplete (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1433
No locals.
#10 0x0000000000460538 in fwdComplete (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:1141
	e = (StoreEntry *) 0x7ffff5497a00
#11 0x0000000000475848 in httpAppendBody (httpState=0x7ffff5498610, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:898
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff5467a20
	orig_request = (const request_t *) 0x7ffff5467a20
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#12 0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff5498610
	buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
#13 0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff5498610
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#14 0x000000000044df58 in do_comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#15 0x000000000044d9d2 in comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777394.8992441
	last_timeout = 1234777394.8142641
#16 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 916

}}}

== 20 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x7ffff5bdc5f0, 
    request=0x7ffff5467a20, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 0
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x7ffff5bdc5f0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x1f500000000
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x00000000004412cf in clientHttpReplyAccessCheck (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3040
	ch = (aclCheck_t *) 0x0
#4  0x0000000000441282 in clientHttpLocationRewriteDone (data=0x7ffff5a111d0, 
    reply=0x0) at /home/henrik/SRC/squid/commit-2/src/client_side.c:3032
	http = (clientHttpRequest *) 0x7ffff5a111d0
	rep = (HttpReply *) 0x7ffff54acd20
	conn = (ConnStateData *) 0x7ffff5a10f10
#5  0x000000000044109c in clientHttpLocationRewriteCheck (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2979
	rep = (HttpReply *) 0x7ffff54acd20
	ch = (aclCheck_t *) 0x7ffff5a111d0
#6  0x000000000044104f in clientSendHeaders (data=0x7ffff5a111d0, 
    rep=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2970
	delayid = 0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	conn = (ConnStateData *) 0x7ffff5a10f10
	fd = 18
#7  0x00000000004c4b42 in storeClientCopyHeadersCB (data=0x7ffff5497cc0, nr=
      {node = 0x0, offset = -1}, size=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:755
	sc = (store_client *) 0x7ffff5497cc0
#8  0x00000000004c3029 in storeClientCallback (sc=0x7ffff5497cc0, sz=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:153
	new_callback = (STNCB *) 0x4c4a80 <storeClientCopyHeadersCB>
	cbdata = (void *) 0x7ffff5497cc0
	nr = {node = 0x7ffff54abc60, offset = 0}
#9  0x00000000004c36ab in storeClientCopy3 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:327
	mem = (MemObject *) 0x7ffff5497a70
	sz = 100
#10 0x00000000004c33b6 in storeClientCopy2 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:255
No locals.
#11 0x00000000004c461e in InvokeHandlers (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:664
	i = 0
	mem = (MemObject *) 0x7ffff5497a70
	sc = (store_client *) 0x7ffff5497cc0
	nx = (dlink_node *) 0x0
	node = (dlink_node *) 0x7ffff5497d28
#12 0x00000000004bff94 in storeComplete (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1433
No locals.
#13 0x0000000000460538 in fwdComplete (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:1141
	e = (StoreEntry *) 0x7ffff5497a00
#14 0x0000000000475848 in httpAppendBody (httpState=0x7ffff5498610, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:898
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff5467a20
	orig_request = (const request_t *) 0x7ffff5467a20
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#15 0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff5498610
	buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
#16 0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff5498610
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#17 0x000000000044df58 in do_comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#18 0x000000000044d9d2 in comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777394.8992441
	last_timeout = 1234777394.8142641
#19 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 916

}}}

== 21 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x000000000041ef19 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2302
No locals.
#3  0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bdc5f0
	match = 1
	ia = (ipcache_addrs *) 0x2900000000
#4  0x000000000041f305 in aclNBCheck (checklist=0x7ffff5496340, 
    callback=0x441307 <clientHttpReplyAccessCheckDone>, 
    callback_data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2451
No locals.
#5  0x00000000004412f5 in clientHttpReplyAccessCheck (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3042
	ch = (aclCheck_t *) 0x7ffff5496340
#6  0x0000000000441282 in clientHttpLocationRewriteDone (data=0x7ffff5a111d0, 
    reply=0x0) at /home/henrik/SRC/squid/commit-2/src/client_side.c:3032
	http = (clientHttpRequest *) 0x7ffff5a111d0
	rep = (HttpReply *) 0x7ffff54acd20
	conn = (ConnStateData *) 0x7ffff5a10f10
#7  0x000000000044109c in clientHttpLocationRewriteCheck (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2979
	rep = (HttpReply *) 0x7ffff54acd20
	ch = (aclCheck_t *) 0x7ffff5a111d0
#8  0x000000000044104f in clientSendHeaders (data=0x7ffff5a111d0, 
    rep=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2970
	delayid = 0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	conn = (ConnStateData *) 0x7ffff5a10f10
	fd = 18
#9  0x00000000004c4b42 in storeClientCopyHeadersCB (data=0x7ffff5497cc0, nr=
      {node = 0x0, offset = -1}, size=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:755
	sc = (store_client *) 0x7ffff5497cc0
#10 0x00000000004c3029 in storeClientCallback (sc=0x7ffff5497cc0, sz=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:153
	new_callback = (STNCB *) 0x4c4a80 <storeClientCopyHeadersCB>
	cbdata = (void *) 0x7ffff5497cc0
	nr = {node = 0x7ffff54abc60, offset = 0}
#11 0x00000000004c36ab in storeClientCopy3 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:327
	mem = (MemObject *) 0x7ffff5497a70
	sz = 100
#12 0x00000000004c33b6 in storeClientCopy2 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:255
No locals.
#13 0x00000000004c461e in InvokeHandlers (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:664
	i = 0
	mem = (MemObject *) 0x7ffff5497a70
	sc = (store_client *) 0x7ffff5497cc0
	nx = (dlink_node *) 0x0
	node = (dlink_node *) 0x7ffff5497d28
#14 0x00000000004bff94 in storeComplete (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1433
No locals.
#15 0x0000000000460538 in fwdComplete (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:1141
	e = (StoreEntry *) 0x7ffff5497a00
#16 0x0000000000475848 in httpAppendBody (httpState=0x7ffff5498610, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:898
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff5467a20
	orig_request = (const request_t *) 0x7ffff5467a20
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#17 0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff5498610
	buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
#18 0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff5498610
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#19 0x000000000044df58 in do_comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#20 0x000000000044d9d2 in comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777394.8992441
	last_timeout = 1234777394.8142641
#21 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 916

}}}

== 22 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000047318b in httpStateFree (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:103
	httpState = (HttpStateData *) 0x7ffff5498610
#2  0x000000000044aa3a in commCallCloseHandlers (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b72980
	ch = (close_handler *) 0x7ffff5498310
#3  0x000000000044ad76 in comm_close (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b72980
#4  0x0000000000475850 in httpAppendBody (httpState=0x7ffff5498610, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:899
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff5467a20
	orig_request = (const request_t *) 0x7ffff5467a20
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#5  0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff5498610
	buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
#6  0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff5498610
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#7  0x000000000044df58 in do_comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#8  0x000000000044d9d2 in comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777394.8992441
	last_timeout = 1234777394.8142641
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 916

}}}

== 23 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x0000000000473198 in httpStateFree (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:104
	httpState = (HttpStateData *) 0x7ffff5498610
#2  0x000000000044aa3a in commCallCloseHandlers (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b72980
	ch = (close_handler *) 0x7ffff5498310
#3  0x000000000044ad76 in comm_close (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b72980
#4  0x0000000000475850 in httpAppendBody (httpState=0x7ffff5498610, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:899
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff5467a20
	orig_request = (const request_t *) 0x7ffff5467a20
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#5  0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff5498610
	buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
#6  0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff5498610
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#7  0x000000000044df58 in do_comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#8  0x000000000044d9d2 in comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777394.8992441
	last_timeout = 1234777394.8142641
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 916

}}}

== 24 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000045dbd9 in fwdStateFree (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:114
	e = (StoreEntry *) 0x7ffff5497a00
	sfd = 0
	p = (peer *) 0x0
#2  0x000000000045e05b in fwdServerClosed (fd=26, data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:217
	fwdState = (FwdState *) 0x7ffff5497f00
#3  0x000000000044aa3a in commCallCloseHandlers (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b72980
	ch = (close_handler *) 0x7ffff5498220
#4  0x000000000044ad76 in comm_close (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b72980
#5  0x0000000000475850 in httpAppendBody (httpState=0x7ffff5498610, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:899
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff5467a20
	orig_request = (const request_t *) 0x7ffff5467a20
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#6  0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff5498610)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff5498610
	buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "\r\nMethod \"POST\" not implemented\r\n"
#7  0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff5498610
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#8  0x000000000044df58 in do_comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#9  0x000000000044d9d2 in comm_select (msec=915)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777394.8992441
	last_timeout = 1234777394.8142641
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 916

}}}

== 25 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x8e92e0, 
    request=0x7ffff5467a20, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 32767
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x8e92e0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x1fffede90
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x000000000043c049 in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1236
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x100007fffffffff
	request = (request_t *) 0x7ffff5467a20
	mem = (MemObject *) 0x7ffff5497a70
#4  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#5  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#6  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#7  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#8  0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54abca5 "Method \"POST\" not implemented\r\n", size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#9  0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#10 0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#11 0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#12 0x000000000044df58 in do_comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#13 0x000000000044d9d2 in comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777395.2503259
	last_timeout = 1234777394.8142641
#14 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 565

}}}

== 26 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x000000000043c112 in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1246
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x100007fffffffff
	request = (request_t *) 0x7ffff5467a20
	mem = (MemObject *) 0x7ffff5497a70
#3  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#4  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#5  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#6  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#7  0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54abca5 "Method \"POST\" not implemented\r\n", size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#8  0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#9  0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#10 0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#11 0x000000000044df58 in do_comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#12 0x000000000044d9d2 in comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777395.2503259
	last_timeout = 1234777394.8142641
#13 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 565

}}}

== 27 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x00000000004bc140 in destroy_MemObject (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:196
	mem = (MemObject *) 0x7ffff5497a70
	ctx = 0
#2  0x00000000004bc25d in destroy_StoreEntry (data=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:212
	e = (StoreEntry *) 0x7ffff5497a00
#3  0x00000000004c078e in storeRelease (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1623
No locals.
#4  0x00000000004bc758 in storeUnlockObjectDebug (e=0x7ffff5497a00, 
    file=0x515b58 "/home/henrik/SRC/squid/commit-2/src/client_side.c", 
    line=1265) at /home/henrik/SRC/squid/commit-2/src/store.c:331
No locals.
#5  0x000000000043c35e in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1265
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff5467a20
	mem = (MemObject *) 0x7ffff5497a70
#6  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#8  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#9  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#10 0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54abca5 'ð' <repeats 200 times>..., size=31, errflag=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#11 0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#12 0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#13 0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#14 0x000000000044df58 in do_comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#15 0x000000000044d9d2 in comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777395.2503259
	last_timeout = 1234777394.8142641
#16 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 565

}}}

== 28 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000043c3c4 in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1275
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x0
	request = (request_t *) 0x7ffff5467a20
	mem = (MemObject *) 0x7ffff5497a70
#2  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#3  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#4  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#5  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#6  0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54abca5 'ð' <repeats 200 times>..., size=31, errflag=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#8  0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#9  0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#10 0x000000000044df58 in do_comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#11 0x000000000044d9d2 in comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777395.2503259
	last_timeout = 1234777394.8142641
#12 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 565

}}}

== 29 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff5467a20)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000043c3dd in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1277
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x0
	request = (request_t *) 0x7ffff5467a20
	mem = (MemObject *) 0x7ffff5497a70
#2  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#3  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#4  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#5  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#6  0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54abca5 'ð' <repeats 200 times>..., size=31, errflag=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#8  0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#9  0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#10 0x000000000044df58 in do_comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#11 0x000000000044d9d2 in comm_select (msec=563)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777395.2503259
	last_timeout = 1234777394.8142641
#12 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 565


}}}

== 30 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000445251 in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4292
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff54af3e0
	msg = {
  buf = 0x7ffff546ac40 "hello\nttp://localhost:5555/ HTTP/1.0\nContent-Length: 1000\n\nhello\n", size = 65, h_start = 37, h_end = 57, h_len = 20, 
  req_start = 0, req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, 
  u_start = 5, u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, 
  v_maj = 1, v_min = 0}
#2  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 65
	F = (fde *) 0x7ffff5b71cc0
	len = 4095
	ret = 0
#3  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#4  0x000000000044df58 in do_comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#5  0x000000000044d9d2 in comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.1123919
	last_timeout = 1234777442.99927
#6  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 833

}}}

== 31 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000445265 in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4293
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff54af3e0
	msg = {
  buf = 0x7ffff546ac40 "hello\nttp://localhost:5555/ HTTP/1.0\nContent-Length: 1000\n\nhello\n", size = 65, h_start = 37, h_end = 57, h_len = 20, 
  req_start = 0, req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, 
  u_start = 5, u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, 
  v_maj = 1, v_min = 0}
#2  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 65
	F = (fde *) 0x7ffff5b71cc0
	len = 4095
	ret = 0
#3  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#4  0x000000000044df58 in do_comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#5  0x000000000044d9d2 in comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.1123919
	last_timeout = 1234777442.99927
#6  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 833

}}}

== 32 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x7ffff5c1fb60, 
    request=0x7ffff54af3e0, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 50
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x7ffff5c1fb60, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x7fffffffdfc0
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x00000000004409da in clientMaxRequestBodySize (request=0x7ffff54af3e0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2788
	bs = (body_size *) 0x7ffff5c1fae0
	checklist = (aclCheck_t *) 0x10f0043ce67
#4  0x0000000000440a98 in clientRequestBodyTooLarge (http=0x7ffff5a111d0, 
    request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2807
No locals.
#5  0x0000000000445320 in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4303
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff54af3e0
	msg = {
  buf = 0x7ffff546ac40 "hello\nttp://localhost:5555/ HTTP/1.0\nContent-Length: 1000\n\nhello\n", size = 65, h_start = 37, h_end = 57, h_len = 20, 
  req_start = 0, req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, 
  u_start = 5, u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, 
  v_maj = 1, v_min = 0}
#6  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 65
	F = (fde *) 0x7ffff5b71cc0
	len = 4095
	ret = 0
#7  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#8  0x000000000044df58 in do_comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#9  0x000000000044d9d2 in comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.1123919
	last_timeout = 1234777442.99927
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 833

}}}

== 33 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x0000000000440a5a in clientMaxRequestBodySize (request=0x7ffff54af3e0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2798
	bs = (body_size *) 0x0
	checklist = (aclCheck_t *) 0x7ffff5496340
#3  0x0000000000440a98 in clientRequestBodyTooLarge (http=0x7ffff5a111d0, 
    request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2807
No locals.
#4  0x0000000000445320 in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4303
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff54af3e0
	msg = {
  buf = 0x7ffff546ac40 "hello\nttp://localhost:5555/ HTTP/1.0\nContent-Length: 1000\n\nhello\n", size = 65, h_start = 37, h_end = 57, h_len = 20, 
  req_start = 0, req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, 
  u_start = 5, u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, 
  v_maj = 1, v_min = 0}
#5  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 65
	F = (fde *) 0x7ffff5b71cc0
	len = 4095
	ret = 0
#6  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#7  0x000000000044df58 in do_comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#8  0x000000000044d9d2 in comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.1123919
	last_timeout = 1234777442.99927
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 833

}}}

== 34 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x8e92e0, 
    request=0x7ffff54af3e0, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 0
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x8e92e0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x0
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x0000000000439350 in clientAccessCheck (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:359
	http = (clientHttpRequest *) 0x7ffff5a111d0
#4  0x000000000043932a in clientCheckFollowXForwardedFor (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:352
	http = (clientHttpRequest *) 0x7ffff5a111d0
#5  0x000000000044549b in clientTryParseRequest (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4324
	fd = 18
	nrequests = 0
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	method = (method_t *) 0x762b40
	err = (ErrorState *) 0x0
	parser_return_code = 1
	request = (request_t *) 0x7ffff54af3e0
	msg = {
  buf = 0x7ffff546ac40 "hello\nttp://localhost:5555/ HTTP/1.0\nContent-Length: 1000\n\nhello\n", size = 65, h_start = 37, h_end = 57, h_len = 20, 
  req_start = 0, req_end = 36, r_len = 37, m_start = 0, m_end = 3, m_len = 4, 
  u_start = 5, u_end = 26, u_len = 22, v_start = 28, v_end = 36, v_len = 9, 
  v_maj = 1, v_min = 0}
#6  0x0000000000445a79 in clientReadRequest (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4448
	conn = (ConnStateData *) 0x7ffff5a10f10
	size = 65
	F = (fde *) 0x7ffff5b71cc0
	len = 4095
	ret = 0
#7  0x000000000044d5ec in comm_call_handlers (fd=18, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x44565c <clientReadRequest>
	hdl_data = (void *) 0x7ffff5a10f10
	do_read = 1
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 1
#8  0x000000000044df58 in do_comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 11
#9  0x000000000044d9d2 in comm_select (msec=833)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.1123919
	last_timeout = 1234777442.99927
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 833

}}}

== 35 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x7ffff5c1fcc0, 
    request=0x7ffff54af3e0, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 0
	checklist = (aclCheck_t *) 0x7ffff5497da0
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x7ffff5c1fcc0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x7ffff5497cc0
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x00000000004408e9 in clientMaxRequestBodyDelayForwardSize (
    request=0x7ffff54af3e0, http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2760
	bs = (body_size *) 0x7ffff5c1fc40
	checklist = (aclCheck_t *) 0x7ffff5497cc0
#4  0x0000000000443201 in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3759
	r = (request_t *) 0x7ffff54af3e0
	bytes_read = 6
	bytes_left = 994
	bytes_to_delay = 32767
#5  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	err = (ErrorState *) 0x0
#6  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	rep = (HttpReply *) 0x0
#7  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#8  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#9  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#10 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#11 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#12 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#13 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff54af3e0
	urlgroup = 0x0
#14 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#15 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#16 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#17 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#18 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#19 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#20 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#21 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#22 0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#23 0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#24 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 36 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5497da0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x0000000000440969 in clientMaxRequestBodyDelayForwardSize (
    request=0x7ffff54af3e0, http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2770
	bs = (body_size *) 0x0
	checklist = (aclCheck_t *) 0x7ffff5497da0
#3  0x0000000000443201 in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3759
	r = (request_t *) 0x7ffff54af3e0
	bytes_read = 6
	bytes_left = 994
	bytes_to_delay = 32767
#4  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	err = (ErrorState *) 0x0
#5  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	rep = (HttpReply *) 0x0
#6  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#8  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#9  0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#10 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#11 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#12 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff54af3e0
	urlgroup = 0x0
#13 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#14 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#15 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#16 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#17 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#18 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#19 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#20 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#21 0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#22 0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#23 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 37 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000045fe05 in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:937
	fwdState = (FwdState *) 0x41ee57
	answer = 1
	err = (ErrorState *) 0x0
#2  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff54af3e0
#3  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff54af3e0
	bytes_read = 6
	bytes_left = 994
	bytes_to_delay = 0
#4  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	err = (ErrorState *) 0x0
#5  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	rep = (HttpReply *) 0x0
#6  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#8  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#9  0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#10 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#11 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#12 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff54af3e0
	urlgroup = 0x0
#13 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#14 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#15 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#16 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#17 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#18 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#19 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#20 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#21 0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#22 0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#23 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 38 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000045fecd in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:967
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#2  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff54af3e0
#3  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff54af3e0
	bytes_read = 6
	bytes_left = 994
	bytes_to_delay = 0
#4  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	err = (ErrorState *) 0x0
#5  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	rep = (HttpReply *) 0x0
#6  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#8  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#9  0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#10 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#11 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#12 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff54af3e0
	urlgroup = 0x0
#13 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#14 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#15 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#16 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#17 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#18 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#19 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#20 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#21 0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#22 0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#23 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 39 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000049e5b2 in peerSelect (request=0x7ffff54af3e0, 
    entry=0x7ffff5497a00, callback=0x45f4e6 <fwdStartComplete>, 
    callback_data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:144
	psstate = (ps_state *) 0x7ffff5497fb0
#2  0x000000000045ff5d in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:983
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#3  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff54af3e0
#4  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff54af3e0
	bytes_read = 6
	bytes_left = 994
	bytes_to_delay = 0
#5  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	err = (ErrorState *) 0x0
#6  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	rep = (HttpReply *) 0x0
#7  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#8  0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#9  0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#10 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#11 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#12 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#13 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff54af3e0
	urlgroup = 0x0
#14 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#15 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#16 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#17 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#18 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#19 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#20 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#21 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#22 0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#23 0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#24 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 40 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x918390, 
    request=0x7ffff54af3e0, ident=0x0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 32767
	checklist = (aclCheck_t *) 0x7ffff5497da0
#2  0x000000000049ebd0 in peerSelectFoo (ps=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:245
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff54af3e0
#3  0x000000000049e641 in peerSelect (request=0x7ffff54af3e0, 
    entry=0x7ffff5497a00, callback=0x45f4e6 <fwdStartComplete>, 
    callback_data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:155
	psstate = (ps_state *) 0x7ffff5497fb0
#4  0x000000000045ff5d in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:983
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#5  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff54af3e0
#6  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff54af3e0
	bytes_read = 6
	bytes_left = 994
	bytes_to_delay = 0
#7  0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	err = (ErrorState *) 0x0
#8  0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	rep = (HttpReply *) 0x0
#9  0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#10 0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#11 0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#12 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#13 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#14 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#15 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff54af3e0
	urlgroup = 0x0
#16 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#17 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#18 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#19 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#20 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#21 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#22 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#23 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#24 0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#25 0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#26 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 41 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000049e355 in peerSelectStateFree (psstate=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:103
No locals.
#2  0x000000000049e976 in peerSelectCallback (psstate=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:203
	entry = (StoreEntry *) 0x7ffff5497a00
	fs = (FwdServer *) 0x7ffff54980c0
	data = (void *) 0x7ffff5497f00
#3  0x000000000049ee29 in peerSelectFoo (ps=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:307
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff54af3e0
#4  0x000000000049e73b in peerCheckAlwaysDirectDone (answer=0, 
    data=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:175
	psstate = (ps_state *) 0x7ffff5497fb0
#5  0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5497da0, 
    answer=ACCESS_DENIED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#6  0x000000000041ed92 in aclCheck (checklist=0x7ffff5497da0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2267
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x0
	match = 0
	ia = (ipcache_addrs *) 0x7fffffffdb10
#7  0x000000000041f305 in aclNBCheck (checklist=0x7ffff5497da0, 
    callback=0x49e6c0 <peerCheckAlwaysDirectDone>, 
    callback_data=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2451
No locals.
#8  0x000000000049ebf7 in peerSelectFoo (ps=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:249
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff54af3e0
#9  0x000000000049e641 in peerSelect (request=0x7ffff54af3e0, 
    entry=0x7ffff5497a00, callback=0x45f4e6 <fwdStartComplete>, 
    callback_data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:155
	psstate = (ps_state *) 0x7ffff5497fb0
#10 0x000000000045ff5d in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:983
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#11 0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff54af3e0
#12 0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff54af3e0
	bytes_read = 6
	bytes_left = 994
	bytes_to_delay = 0
#13 0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	err = (ErrorState *) 0x0
#14 0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	rep = (HttpReply *) 0x0
#15 0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#16 0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#17 0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#18 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#19 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#20 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#21 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff54af3e0
	urlgroup = 0x0
#22 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#23 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#24 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#25 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#26 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#27 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#28 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#29 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#30 0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#31 0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#32 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 42 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5497da0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x000000000041ef19 in aclCheckCallback (checklist=0x7ffff5497da0, 
    answer=ACCESS_DENIED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2302
No locals.
#3  0x000000000041ed92 in aclCheck (checklist=0x7ffff5497da0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2267
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x0
	match = 0
	ia = (ipcache_addrs *) 0x7fffffffdb10
#4  0x000000000041f305 in aclNBCheck (checklist=0x7ffff5497da0, 
    callback=0x49e6c0 <peerCheckAlwaysDirectDone>, 
    callback_data=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2451
No locals.
#5  0x000000000049ebf7 in peerSelectFoo (ps=0x7ffff5497fb0)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:249
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff54af3e0
#6  0x000000000049e641 in peerSelect (request=0x7ffff54af3e0, 
    entry=0x7ffff5497a00, callback=0x45f4e6 <fwdStartComplete>, 
    callback_data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/peer_select.c:155
	psstate = (ps_state *) 0x7ffff5497fb0
#7  0x000000000045ff5d in fwdStart (fd=18, e=0x7ffff5497a00, r=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:983
	fwdState = (FwdState *) 0x7ffff5497f00
	answer = 1
	err = (ErrorState *) 0x0
#8  0x000000000044310b in clientBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3728
	r = (request_t *) 0x7ffff54af3e0
#9  0x000000000044324c in clientCheckBeginForwarding (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3770
	r = (request_t *) 0x7ffff54af3e0
	bytes_read = 6
	bytes_left = 994
	bytes_to_delay = 0
#10 0x0000000000443824 in clientProcessMiss (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3865
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	err = (ErrorState *) 0x0
#11 0x0000000000443079 in clientProcessRequest (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3716
	url = 0x7ffff54979e0 "http://localhost:5555/"
	r = (request_t *) 0x7ffff54af3e0
	rep = (HttpReply *) 0x0
#12 0x0000000000439d7f in clientCheckNoCacheDone (answer=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:571
	http = (clientHttpRequest *) 0x7ffff5a111d0
#13 0x0000000000439d26 in clientCheckNoCache (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:561
No locals.
#14 0x00000000004393e9 in clientAccessCheck2 (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:371
	http = (clientHttpRequest *) 0x7ffff5a111d0
#15 0x0000000000439582 in clientFinishRewriteStuff (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:423
No locals.
#16 0x0000000000448fad in clientStoreURLRewriteDone (data=0x7ffff5a111d0, 
    result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:87
	http = (clientHttpRequest *) 0x7ffff5a111d0
#17 0x0000000000448e8b in clientStoreURLRewriteStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_storeurl_rewrite.c:57
No locals.
#18 0x0000000000448b41 in clientRedirectDone (data=0x7ffff5a111d0, result=0x0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:176
	http = (clientHttpRequest *) 0x7ffff5a111d0
	new_request = (request_t *) 0x0
	old_request = (request_t *) 0x7ffff54af3e0
	urlgroup = 0x0
#19 0x00000000004485c8 in clientRedirectStart (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side_rewrite.c:82
No locals.
#20 0x0000000000439705 in clientAccessCheckDone (answer=1, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:446
	http = (clientHttpRequest *) 0x7ffff5a111d0
	page_id = 4122947376
	status = 1
	err = (ErrorState *) 0x0
	proxy_auth_msg = 0x0
#21 0x000000000041eee2 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2298
No locals.
#22 0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#23 0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#24 0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#25 0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#26 0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#27 0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#28 0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#29 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 43 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x000000000041ef19 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2302
No locals.
#3  0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bf0ef0
	match = 1
	ia = (ipcache_addrs *) 0x7ffff5496300
#4  0x000000000041f194 in aclLookupExternalDone (data=0x7ffff5496340, 
    result=0x7ffff54907a0) at /home/henrik/SRC/squid/commit-2/src/acl.c:2391
	checklist = (aclCheck_t *) 0x7ffff5496340
#5  0x000000000045bf1d in externalAclHandleReply (data=0x7ffff54965e0, 
    reply=0x7ffff5a80632 "OK")
    at /home/henrik/SRC/squid/commit-2/src/external_acl.c:985
	state = (externalAclState *) 0x7ffff54965e0
	next = (externalAclState *) 0x7ffff5497d60
	result = 1
	status = 0x7ffff5a80632 "OK"
	token = 0x0
	value = 0x7ffff5a80669 "time=1234777443"
	t = 0x7ffff5a8067a ""
	user = 0x0
	passwd = 0x0
	message = 0x7ffff5a8063d "Message mÃ¥n feb 16 10:44:03 CET 2009"
	log = 0x7ffff5a80669 "time=1234777443"
	entry = (external_acl_entry *) 0x7ffff54907a0
#6  0x000000000046e41b in helperHandleRead (fd=10, data=0x7ffff5cd6610)
    at /home/henrik/SRC/squid/commit-2/src/helper.c:769
	r = (helper_request *) 0x7ffff5496e80
	msg = 0x7ffff5a80632 "OK"
	i = 0
	len = 75
	t = 0x7ffff5a8067b ""
	srv = (helper_server *) 0x7ffff5cd6610
	hlp = (helper *) 0x7ffff5cd6520
#7  0x000000000044d5ec in comm_call_handlers (fd=10, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x46dfd5 <helperHandleRead>
	hdl_data = (void *) 0x7ffff5cd6610
	do_read = 1
	F = (fde *) 0x7ffff5b71000
	do_incoming = 1
#8  0x000000000044df58 in do_comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#9  0x000000000044d9d2 in comm_select (msec=723)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.2230821
	last_timeout = 1234777442.99927
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 723

}}}

== 44 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000477af2 in httpStart (fwd=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1587
	fd = 26
	httpState = (HttpStateData *) 0x7ffff54b3410
	proxy_req = (request_t *) 0x1a00000000
	orig_req = (request_t *) 0x7ffff54af3e0
#2  0x000000000045f876 in fwdDispatch (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:795
	p = (peer *) 0x0
	request = (request_t *) 0x7ffff54af3e0
	entry = (StoreEntry *) 0x7ffff5497a00
	err = (ErrorState *) 0x7ffff5b7298d
	server_fd = 26
	fs = (FwdServer *) 0x7ffff54980c0
#3  0x000000000045e6aa in fwdConnectDone (server_fd=26, status=0, 
    data=0x7ffff5497f00) at /home/henrik/SRC/squid/commit-2/src/forward.c:366
	fwdState = (FwdState *) 0x7ffff5497f00
	fs = (FwdServer *) 0x7ffff54980c0
	err = (ErrorState *) 0x7ffff5498310
	request = (request_t *) 0x7ffff54af3e0
#4  0x0000000000449d8f in commConnectCallback (cs=0x7ffff5498290, status=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:386
	callback = (CNCB *) 0x45e44b <fwdConnectDone>
	data = (void *) 0x7ffff5497f00
	fd = 26
#5  0x000000000044a2da in commConnectHandle (fd=26, data=0x7ffff5498290)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:505
	cs = (ConnectStateData *) 0x7ffff5498290
#6  0x000000000044d6e4 in comm_call_handlers (fd=26, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44a1f7 <commConnectHandle>
	hdl_data = (void *) 0x7ffff5498290
	do_write = 4
	F = (fde *) 0x7ffff5b72980
	do_incoming = 0
#7  0x000000000044df58 in do_comm_select (msec=371)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 115
#8  0x000000000044d9d2 in comm_select (msec=371)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.574733
	last_timeout = 1234777442.99927
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 371

}}}

== 45 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000477b06 in httpStart (fwd=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1588
	fd = 26
	httpState = (HttpStateData *) 0x7ffff54b3410
	proxy_req = (request_t *) 0x1a00000000
	orig_req = (request_t *) 0x7ffff54af3e0
#2  0x000000000045f876 in fwdDispatch (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:795
	p = (peer *) 0x0
	request = (request_t *) 0x7ffff54af3e0
	entry = (StoreEntry *) 0x7ffff5497a00
	err = (ErrorState *) 0x7ffff5b7298d
	server_fd = 26
	fs = (FwdServer *) 0x7ffff54980c0
#3  0x000000000045e6aa in fwdConnectDone (server_fd=26, status=0, 
    data=0x7ffff5497f00) at /home/henrik/SRC/squid/commit-2/src/forward.c:366
	fwdState = (FwdState *) 0x7ffff5497f00
	fs = (FwdServer *) 0x7ffff54980c0
	err = (ErrorState *) 0x7ffff5498310
	request = (request_t *) 0x7ffff54af3e0
#4  0x0000000000449d8f in commConnectCallback (cs=0x7ffff5498290, status=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:386
	callback = (CNCB *) 0x45e44b <fwdConnectDone>
	data = (void *) 0x7ffff5497f00
	fd = 26
#5  0x000000000044a2da in commConnectHandle (fd=26, data=0x7ffff5498290)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:505
	cs = (ConnectStateData *) 0x7ffff5498290
#6  0x000000000044d6e4 in comm_call_handlers (fd=26, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44a1f7 <commConnectHandle>
	hdl_data = (void *) 0x7ffff5498290
	do_write = 4
	F = (fde *) 0x7ffff5b72980
	do_incoming = 0
#7  0x000000000044df58 in do_comm_select (msec=371)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 115
#8  0x000000000044d9d2 in comm_select (msec=371)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.574733
	last_timeout = 1234777442.99927
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 371

}}}

== 46 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000445cc5 in clientReadBody (request=0x7ffff54af3e0, 
    buf=0x7ffff5499c30 "", size=8192, 
    callback=0x477cf0 <httpRequestBodyHandler>, cbdata=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4493
	conn = (ConnStateData *) 0x7ffff5a10f10
#2  0x00000000004833c2 in requestReadBody (request=0x7ffff54af3e0, 
    buf=0x7ffff5499c30 "", size=8192, 
    callback=0x477cf0 <httpRequestBodyHandler>, cbdata=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:200
No locals.
#3  0x0000000000477fdc in httpSendRequestEntry (fd=26, bufnotused=0x0, 
    size=201, errflag=0, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1693
	httpState = (HttpStateData *) 0x7ffff54b3410
	entry = (StoreEntry *) 0x7ffff5497a00
#4  0x000000000044934c in CommWriteStateCallbackAndFree (fd=26, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b72a90
	callback = (CWCB *) 0x477e92 <httpSendRequestEntry>
	data = (void *) 0x7ffff54b3410
#5  0x000000000044c609 in commHandleWrite (fd=26, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 201
	nleft = 201
	writesz = 201
	state = (CommWriteStateData *) 0x7ffff5b72a90
#6  0x000000000044d6e4 in comm_call_handlers (fd=26, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b72980
	do_incoming = 0
#7  0x000000000044df58 in do_comm_select (msec=338)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#8  0x000000000044d9d2 in comm_select (msec=338)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.60811
	last_timeout = 1234777442.99927
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 338

}}}

== 47 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000044612d in clientProcessBody (conn=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4593
	valid = 1
	size = 6
	buf = 0x7ffff5499c30 "hello\n"
	cbdata = (void *) 0x7ffff54b3410
	callback = (CBCB *) 0x477cf0 <httpRequestBodyHandler>
	request = (request_t *) 0x7ffff54af3e0
#2  0x0000000000445cd9 in clientReadBody (request=0x7ffff54af3e0, 
    buf=0x7ffff5499c30 "hello\n", size=8192, 
    callback=0x477cf0 <httpRequestBodyHandler>, cbdata=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4494
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x00000000004833c2 in requestReadBody (request=0x7ffff54af3e0, 
    buf=0x7ffff5499c30 "hello\n", size=8192, 
    callback=0x477cf0 <httpRequestBodyHandler>, cbdata=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:200
No locals.
#4  0x0000000000477fdc in httpSendRequestEntry (fd=26, bufnotused=0x0, 
    size=201, errflag=0, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1693
	httpState = (HttpStateData *) 0x7ffff54b3410
	entry = (StoreEntry *) 0x7ffff5497a00
#5  0x000000000044934c in CommWriteStateCallbackAndFree (fd=26, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b72a90
	callback = (CWCB *) 0x477e92 <httpSendRequestEntry>
	data = (void *) 0x7ffff54b3410
#6  0x000000000044c609 in commHandleWrite (fd=26, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 201
	nleft = 201
	writesz = 201
	state = (CommWriteStateData *) 0x7ffff5b72a90
#7  0x000000000044d6e4 in comm_call_handlers (fd=26, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b72980
	do_incoming = 0
#8  0x000000000044df58 in do_comm_select (msec=338)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#9  0x000000000044d9d2 in comm_select (msec=338)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.60811
	last_timeout = 1234777442.99927
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 338

}}}

== 48 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x0000000000445cc5 in clientReadBody (request=0x7ffff54af3e0, 
    buf=0x7ffff5499c30 "", size=8192, 
    callback=0x477cf0 <httpRequestBodyHandler>, cbdata=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:4493
	conn = (ConnStateData *) 0x7ffff5a10f10
#2  0x00000000004833c2 in requestReadBody (request=0x7ffff54af3e0, 
    buf=0x7ffff5499c30 "", size=8192, 
    callback=0x477cf0 <httpRequestBodyHandler>, cbdata=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:200
No locals.
#3  0x0000000000477fdc in httpSendRequestEntry (fd=26, bufnotused=0x0, size=6, 
    errflag=0, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1693
	httpState = (HttpStateData *) 0x7ffff54b3410
	entry = (StoreEntry *) 0x7ffff5497a00
#4  0x000000000044934c in CommWriteStateCallbackAndFree (fd=26, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b72a90
	callback = (CWCB *) 0x477e92 <httpSendRequestEntry>
	data = (void *) 0x7ffff54b3410
#5  0x000000000044c609 in commHandleWrite (fd=26, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 6
	nleft = 6
	writesz = 6
	state = (CommWriteStateData *) 0x7ffff5b72a90
#6  0x000000000044d6e4 in comm_call_handlers (fd=26, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b72980
	do_incoming = 0
#7  0x000000000044df58 in do_comm_select (msec=284)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#8  0x000000000044d9d2 in comm_select (msec=284)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777443.66151
	last_timeout = 1234777442.99927
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 284

}}}

== 49 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x8e8860, 
    request=0x7ffff54af3e0, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 32767
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x8e8860, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x416b30
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x000000000044064d in clientMaxBodySize (request=0x7ffff54af3e0, 
    http=0x7ffff5a111d0, reply=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2670
	bs = (body_size *) 0x8e87e0
	checklist = (aclCheck_t *) 0x7ffff54acd20
#4  0x0000000000440ed7 in clientSendHeaders (data=0x7ffff5a111d0, 
    rep=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2930
	delayid = 32767
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	conn = (ConnStateData *) 0x7ffff5a10f10
	fd = 18
#5  0x00000000004c4b42 in storeClientCopyHeadersCB (data=0x7ffff5497cc0, nr=
      {node = 0x0, offset = -1}, size=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:755
	sc = (store_client *) 0x7ffff5497cc0
#6  0x00000000004c3029 in storeClientCallback (sc=0x7ffff5497cc0, sz=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:153
	new_callback = (STNCB *) 0x4c4a80 <storeClientCopyHeadersCB>
	cbdata = (void *) 0x7ffff5497cc0
	nr = {node = 0x7ffff54b3610, offset = 0}
#7  0x00000000004c36ab in storeClientCopy3 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:327
	mem = (MemObject *) 0x7ffff5497a70
	sz = 100
#8  0x00000000004c33b6 in storeClientCopy2 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:255
No locals.
#9  0x00000000004c461e in InvokeHandlers (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:664
	i = 0
	mem = (MemObject *) 0x7ffff5497a70
	sc = (store_client *) 0x7ffff5497cc0
	nx = (dlink_node *) 0x0
	node = (dlink_node *) 0x7ffff5497d28
#10 0x00000000004bff94 in storeComplete (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1433
No locals.
#11 0x0000000000460538 in fwdComplete (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:1141
	e = (StoreEntry *) 0x7ffff5497a00
#12 0x0000000000475848 in httpAppendBody (httpState=0x7ffff54b3410, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:898
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff54af3e0
	orig_request = (const request_t *) 0x7ffff54af3e0
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#13 0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff54b3410
	buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
#14 0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff54b3410
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#15 0x000000000044df58 in do_comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#16 0x000000000044d9d2 in comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.011256
	last_timeout = 1234777444.999264
#17 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 998

}}}

== 50 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x00000000004406d8 in clientMaxBodySize (request=0x7ffff54af3e0, 
    http=0x7ffff5a111d0, reply=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2681
	bs = (body_size *) 0x0
	checklist = (aclCheck_t *) 0x7ffff5496340
#3  0x0000000000440ed7 in clientSendHeaders (data=0x7ffff5a111d0, 
    rep=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2930
	delayid = 32767
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	conn = (ConnStateData *) 0x7ffff5a10f10
	fd = 18
#4  0x00000000004c4b42 in storeClientCopyHeadersCB (data=0x7ffff5497cc0, nr=
      {node = 0x0, offset = -1}, size=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:755
	sc = (store_client *) 0x7ffff5497cc0
#5  0x00000000004c3029 in storeClientCallback (sc=0x7ffff5497cc0, sz=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:153
	new_callback = (STNCB *) 0x4c4a80 <storeClientCopyHeadersCB>
	cbdata = (void *) 0x7ffff5497cc0
	nr = {node = 0x7ffff54b3610, offset = 0}
#6  0x00000000004c36ab in storeClientCopy3 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:327
	mem = (MemObject *) 0x7ffff5497a70
	sz = 100
#7  0x00000000004c33b6 in storeClientCopy2 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:255
No locals.
#8  0x00000000004c461e in InvokeHandlers (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:664
	i = 0
	mem = (MemObject *) 0x7ffff5497a70
	sc = (store_client *) 0x7ffff5497cc0
	nx = (dlink_node *) 0x0
	node = (dlink_node *) 0x7ffff5497d28
#9  0x00000000004bff94 in storeComplete (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1433
No locals.
#10 0x0000000000460538 in fwdComplete (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:1141
	e = (StoreEntry *) 0x7ffff5497a00
#11 0x0000000000475848 in httpAppendBody (httpState=0x7ffff54b3410, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:898
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff54af3e0
	orig_request = (const request_t *) 0x7ffff54af3e0
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#12 0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff54b3410
	buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
#13 0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff54b3410
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#14 0x000000000044df58 in do_comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#15 0x000000000044d9d2 in comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.011256
	last_timeout = 1234777444.999264
#16 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 998

}}}

== 51 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x7ffff5bdc5f0, 
    request=0x7ffff54af3e0, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 0
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x7ffff5bdc5f0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x1f500000000
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x00000000004412cf in clientHttpReplyAccessCheck (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3040
	ch = (aclCheck_t *) 0x0
#4  0x0000000000441282 in clientHttpLocationRewriteDone (data=0x7ffff5a111d0, 
    reply=0x0) at /home/henrik/SRC/squid/commit-2/src/client_side.c:3032
	http = (clientHttpRequest *) 0x7ffff5a111d0
	rep = (HttpReply *) 0x7ffff54acd20
	conn = (ConnStateData *) 0x7ffff5a10f10
#5  0x000000000044109c in clientHttpLocationRewriteCheck (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2979
	rep = (HttpReply *) 0x7ffff54acd20
	ch = (aclCheck_t *) 0x7ffff5a111d0
#6  0x000000000044104f in clientSendHeaders (data=0x7ffff5a111d0, 
    rep=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2970
	delayid = 0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	conn = (ConnStateData *) 0x7ffff5a10f10
	fd = 18
#7  0x00000000004c4b42 in storeClientCopyHeadersCB (data=0x7ffff5497cc0, nr=
      {node = 0x0, offset = -1}, size=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:755
	sc = (store_client *) 0x7ffff5497cc0
#8  0x00000000004c3029 in storeClientCallback (sc=0x7ffff5497cc0, sz=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:153
	new_callback = (STNCB *) 0x4c4a80 <storeClientCopyHeadersCB>
	cbdata = (void *) 0x7ffff5497cc0
	nr = {node = 0x7ffff54b3610, offset = 0}
#9  0x00000000004c36ab in storeClientCopy3 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:327
	mem = (MemObject *) 0x7ffff5497a70
	sz = 100
#10 0x00000000004c33b6 in storeClientCopy2 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:255
No locals.
#11 0x00000000004c461e in InvokeHandlers (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:664
	i = 0
	mem = (MemObject *) 0x7ffff5497a70
	sc = (store_client *) 0x7ffff5497cc0
	nx = (dlink_node *) 0x0
	node = (dlink_node *) 0x7ffff5497d28
#12 0x00000000004bff94 in storeComplete (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1433
No locals.
#13 0x0000000000460538 in fwdComplete (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:1141
	e = (StoreEntry *) 0x7ffff5497a00
#14 0x0000000000475848 in httpAppendBody (httpState=0x7ffff54b3410, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:898
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff54af3e0
	orig_request = (const request_t *) 0x7ffff54af3e0
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#15 0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff54b3410
	buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
#16 0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff54b3410
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#17 0x000000000044df58 in do_comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#18 0x000000000044d9d2 in comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.011256
	last_timeout = 1234777444.999264
#19 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 998

}}}

== 52 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x000000000041ef19 in aclCheckCallback (checklist=0x7ffff5496340, 
    answer=ACCESS_ALLOWED) at /home/henrik/SRC/squid/commit-2/src/acl.c:2302
No locals.
#3  0x000000000041ecff in aclCheck (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2255
	allow = ACCESS_ALLOWED
	A = (const acl_access *) 0x7ffff5bdc5f0
	match = 1
	ia = (ipcache_addrs *) 0x2900000000
#4  0x000000000041f305 in aclNBCheck (checklist=0x7ffff5496340, 
    callback=0x441307 <clientHttpReplyAccessCheckDone>, 
    callback_data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2451
No locals.
#5  0x00000000004412f5 in clientHttpReplyAccessCheck (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3042
	ch = (aclCheck_t *) 0x7ffff5496340
#6  0x0000000000441282 in clientHttpLocationRewriteDone (data=0x7ffff5a111d0, 
    reply=0x0) at /home/henrik/SRC/squid/commit-2/src/client_side.c:3032
	http = (clientHttpRequest *) 0x7ffff5a111d0
	rep = (HttpReply *) 0x7ffff54acd20
	conn = (ConnStateData *) 0x7ffff5a10f10
#7  0x000000000044109c in clientHttpLocationRewriteCheck (http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2979
	rep = (HttpReply *) 0x7ffff54acd20
	ch = (aclCheck_t *) 0x7ffff5a111d0
#8  0x000000000044104f in clientSendHeaders (data=0x7ffff5a111d0, 
    rep=0x7ffff54acd20)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:2970
	delayid = 0
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	conn = (ConnStateData *) 0x7ffff5a10f10
	fd = 18
#9  0x00000000004c4b42 in storeClientCopyHeadersCB (data=0x7ffff5497cc0, nr=
      {node = 0x0, offset = -1}, size=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:755
	sc = (store_client *) 0x7ffff5497cc0
#10 0x00000000004c3029 in storeClientCallback (sc=0x7ffff5497cc0, sz=100)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:153
	new_callback = (STNCB *) 0x4c4a80 <storeClientCopyHeadersCB>
	cbdata = (void *) 0x7ffff5497cc0
	nr = {node = 0x7ffff54b3610, offset = 0}
#11 0x00000000004c36ab in storeClientCopy3 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:327
	mem = (MemObject *) 0x7ffff5497a70
	sz = 100
#12 0x00000000004c33b6 in storeClientCopy2 (e=0x7ffff5497a00, 
    sc=0x7ffff5497cc0)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:255
No locals.
#13 0x00000000004c461e in InvokeHandlers (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store_client.c:664
	i = 0
	mem = (MemObject *) 0x7ffff5497a70
	sc = (store_client *) 0x7ffff5497cc0
	nx = (dlink_node *) 0x0
	node = (dlink_node *) 0x7ffff5497d28
#14 0x00000000004bff94 in storeComplete (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1433
No locals.
#15 0x0000000000460538 in fwdComplete (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:1141
	e = (StoreEntry *) 0x7ffff5497a00
#16 0x0000000000475848 in httpAppendBody (httpState=0x7ffff54b3410, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:898
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff54af3e0
	orig_request = (const request_t *) 0x7ffff54af3e0
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#17 0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff54b3410
	buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
#18 0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff54b3410
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#19 0x000000000044df58 in do_comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#20 0x000000000044d9d2 in comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.011256
	last_timeout = 1234777444.999264
#21 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 998

}}}

== 53 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000047318b in httpStateFree (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:103
	httpState = (HttpStateData *) 0x7ffff54b3410
#2  0x000000000044aa3a in commCallCloseHandlers (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b72980
	ch = (close_handler *) 0x7ffff5498310
#3  0x000000000044ad76 in comm_close (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b72980
#4  0x0000000000475850 in httpAppendBody (httpState=0x7ffff54b3410, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:899
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff54af3e0
	orig_request = (const request_t *) 0x7ffff54af3e0
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#5  0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff54b3410
	buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
#6  0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff54b3410
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#7  0x000000000044df58 in do_comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#8  0x000000000044d9d2 in comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.011256
	last_timeout = 1234777444.999264
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 998

}}}

== 54 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x0000000000473198 in httpStateFree (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:104
	httpState = (HttpStateData *) 0x7ffff54b3410
#2  0x000000000044aa3a in commCallCloseHandlers (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b72980
	ch = (close_handler *) 0x7ffff5498310
#3  0x000000000044ad76 in comm_close (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b72980
#4  0x0000000000475850 in httpAppendBody (httpState=0x7ffff54b3410, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:899
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff54af3e0
	orig_request = (const request_t *) 0x7ffff54af3e0
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#5  0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff54b3410
	buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
#6  0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff54b3410
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#7  0x000000000044df58 in do_comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#8  0x000000000044d9d2 in comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.011256
	last_timeout = 1234777444.999264
#9  0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 998

}}}

== 55 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000045dbd9 in fwdStateFree (fwdState=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:114
	e = (StoreEntry *) 0x7ffff5497a00
	sfd = 0
	p = (peer *) 0x0
#2  0x000000000045e05b in fwdServerClosed (fd=26, data=0x7ffff5497f00)
    at /home/henrik/SRC/squid/commit-2/src/forward.c:217
	fwdState = (FwdState *) 0x7ffff5497f00
#3  0x000000000044aa3a in commCallCloseHandlers (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b72980
	ch = (close_handler *) 0x7ffff5498220
#4  0x000000000044ad76 in comm_close (fd=26)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b72980
#5  0x0000000000475850 in httpAppendBody (httpState=0x7ffff54b3410, buf=0x0, 
    len=0, buffer_filled=-1) at /home/henrik/SRC/squid/commit-2/src/http.c:899
	entry = (StoreEntry *) 0x7ffff5497a00
	request = (const request_t *) 0x7ffff54af3e0
	orig_request = (const request_t *) 0x7ffff54af3e0
	client_addr = (struct in_addr *) 0x0
	client_port = 0
	fd = 26
	complete = 1
	keep_alive = 0
#6  0x0000000000475d5e in httpReadReply (fd=26, data=0x7ffff54b3410)
    at /home/henrik/SRC/squid/commit-2/src/http.c:1001
	httpState = (HttpStateData *) 0x7ffff54b3410
	buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
	entry = (StoreEntry *) 0x7ffff5497a00
	len = 0
	bin = 0
	clen = 0
	done = 0
	read_sz = 65535
	delay_id = 0
	buffer_filled = 0
	local_buf = 0x7ffff549bc50 "Method \"POST\" not implemented\r\n"
#7  0x000000000044d5ec in comm_call_handlers (fd=26, read_event=1, 
    write_event=0) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:264
	hdl = (PF *) 0x475862 <httpReadReply>
	hdl_data = (void *) 0x7ffff54b3410
	do_read = 1
	F = (fde *) 0x7ffff5b72980
	do_incoming = 1
#8  0x000000000044df58 in do_comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#9  0x000000000044d9d2 in comm_select (msec=988)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.011256
	last_timeout = 1234777444.999264
#10 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 998

}}}

== 56 requestLink ==

{{{
Breakpoint 1, requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
95	    assert(request);
#0  requestLink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:95
No locals.
#1  0x000000000041f256 in aclChecklistCreate (A=0x8e92e0, 
    request=0x7ffff54af3e0, ident=0x7ffff5a10fb4 "")
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2433
	i = 32767
	checklist = (aclCheck_t *) 0x7ffff5496340
#2  0x0000000000438d9a in clientAclChecklistCreate (acl=0x8e92e0, 
    http=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:187
	ch = (aclCheck_t *) 0x1fffede90
	conn = (ConnStateData *) 0x7ffff5a10f10
#3  0x000000000043c049 in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1236
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x100007fffffffff
	request = (request_t *) 0x7ffff54af3e0
	mem = (MemObject *) 0x7ffff5497a70
#4  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#5  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#6  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#7  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#8  0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54b3655 "Method \"POST\" not implemented\r\n", size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#9  0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#10 0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#11 0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#12 0x000000000044df58 in do_comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#13 0x000000000044d9d2 in comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.979351
	last_timeout = 1234777444.999264
#14 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 30

}}}

== 57 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000041edba in aclChecklistFree (checklist=0x7ffff5496340)
    at /home/henrik/SRC/squid/commit-2/src/acl.c:2274
No locals.
#2  0x000000000043c112 in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1246
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x100007fffffffff
	request = (request_t *) 0x7ffff54af3e0
	mem = (MemObject *) 0x7ffff5497a70
#3  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#4  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#5  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#6  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#7  0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54b3655 "Method \"POST\" not implemented\r\n", size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#8  0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#9  0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#10 0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#11 0x000000000044df58 in do_comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#12 0x000000000044d9d2 in comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.979351
	last_timeout = 1234777444.999264
#13 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 30

}}}

== 58 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x00000000004bc140 in destroy_MemObject (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:196
	mem = (MemObject *) 0x7ffff5497a70
	ctx = 0
#2  0x00000000004bc25d in destroy_StoreEntry (data=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:212
	e = (StoreEntry *) 0x7ffff5497a00
#3  0x00000000004c078e in storeRelease (e=0x7ffff5497a00)
    at /home/henrik/SRC/squid/commit-2/src/store.c:1623
No locals.
#4  0x00000000004bc758 in storeUnlockObjectDebug (e=0x7ffff5497a00, 
    file=0x515b58 "/home/henrik/SRC/squid/commit-2/src/client_side.c", 
    line=1265) at /home/henrik/SRC/squid/commit-2/src/store.c:331
No locals.
#5  0x000000000043c35e in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1265
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x7ffff5497a00
	request = (request_t *) 0x7ffff54af3e0
	mem = (MemObject *) 0x7ffff5497a70
#6  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#8  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#9  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#10 0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54b3655 'ð' <repeats 200 times>..., size=31, errflag=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#11 0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#12 0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#13 0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#14 0x000000000044df58 in do_comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#15 0x000000000044d9d2 in comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.979351
	last_timeout = 1234777444.999264
#16 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 30

}}}

== 59 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000043c3c4 in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1275
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x0
	request = (request_t *) 0x7ffff54af3e0
	mem = (MemObject *) 0x7ffff5497a70
#2  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#3  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#4  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#5  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#6  0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54b3655 'ð' <repeats 200 times>..., size=31, errflag=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#8  0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#9  0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#10 0x000000000044df58 in do_comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#11 0x000000000044d9d2 in comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.979351
	last_timeout = 1234777444.999264
#12 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 30

}}}

== 60 requestUnlink ==

{{{
Breakpoint 2, requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
103	    if (!request)
#0  requestUnlink (request=0x7ffff54af3e0)
    at /home/henrik/SRC/squid/commit-2/src/HttpRequest.c:103
No locals.
#1  0x000000000043c3dd in httpRequestFree (data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1277
	http = (clientHttpRequest *) 0x7ffff5a111d0
	conn = (ConnStateData *) 0x7ffff5a10f10
	e = (StoreEntry *) 0x0
	request = (request_t *) 0x7ffff54af3e0
	mem = (MemObject *) 0x7ffff5497a70
#2  0x000000000043c55b in connStateFree (fd=18, data=0x7ffff5a10f10)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:1304
	connState = (ConnStateData *) 0x7ffff5a10f10
	n = (dlink_node *) 0x0
	http = (clientHttpRequest *) 0x7ffff5a111d0
#3  0x000000000044aa3a in commCallCloseHandlers (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:656
	F = (fde *) 0x7ffff5b71cc0
	ch = (close_handler *) 0x7ffff5c293e0
#4  0x000000000044ad76 in comm_close (fd=18)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:811
	F = (fde *) 0x7ffff5b71cc0
#5  0x0000000000442434 in clientWriteComplete (fd=18, bufnotused=0x0, size=31, 
    errflag=0, data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3453
	http = (clientHttpRequest *) 0x7ffff5a111d0
	entry = (StoreEntry *) 0x7ffff5497a00
	done = 1
#6  0x0000000000441ebf in clientWriteBodyComplete (fd=18, 
    buf=0x7ffff54b3655 'ð' <repeats 200 times>..., size=31, errflag=0, 
    data=0x7ffff5a111d0)
    at /home/henrik/SRC/squid/commit-2/src/client_side.c:3325
	http = (clientHttpRequest *) 0x7ffff5a111d0
#7  0x000000000044934c in CommWriteStateCallbackAndFree (fd=18, code=0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:113
	CommWriteState = (CommWriteStateData *) 0x7ffff5b71dd0
	callback = (CWCB *) 0x441e72 <clientWriteBodyComplete>
	data = (void *) 0x7ffff5a111d0
#8  0x000000000044c609 in commHandleWrite (fd=18, data=0x0)
    at /home/henrik/SRC/squid/commit-2/src/comm.c:1390
	len = 31
	nleft = 31
	writesz = 31
	state = (CommWriteStateData *) 0x7ffff5b71dd0
#9  0x000000000044d6e4 in comm_call_handlers (fd=18, read_event=0, 
    write_event=4) at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:300
	hdl = (PF *) 0x44c188 <commHandleWrite>
	hdl_data = (void *) 0x0
	do_write = 4
	F = (fde *) 0x7ffff5b71cc0
	do_incoming = 0
#10 0x000000000044df58 in do_comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_epoll.c:195
	i = 0
	num = 1
	saved_errno = 0
#11 0x000000000044d9d2 in comm_select (msec=19)
    at /home/henrik/SRC/squid/commit-2/src/comm_generic.c:387
	rc = 0
	start = 1234777445.979351
	last_timeout = 1234777444.999264
#12 0x000000000048e48c in main (argc=2, argv=0x7fffffffe318)
    at /home/henrik/SRC/squid/commit-2/src/main.c:862
	errcount = 0
	loop_delay = 30
}}}
