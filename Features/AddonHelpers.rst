##master-page:Features/FeatureTemplate
#format wiki
#language en
#faqlisted yes

= Feature: Add-On Helpers for Request Manipulation =

 * '''Goal''': Support simple customization of request handling for local requirements.

 * '''Status''': Completed. 2.5

 * '''Version''': 2.5

## * '''Developer''': unknown

 * '''More''': <<BR>>
  (NTLM) http://squid.sourceforge.net/ntlm/squid_helper_protocol.html <<BR>>
  (Digest auth)  [[KnowledgeBase/LdapBackedDigestAuthentication]] <<BR>>
  (Kerberos auth) [[ConfigExamples/Authenticate/Kerberos]]

<<TableOfContents>>

== Details ==

Every network and installation have their own criteria for operation. The squid developers and community do not have the time or inclination to write code for every minor situation. Instead we provide ways to easily extend various operations with local add-on scripts or programs we call helpers.

Helpers can be written in any language you like. They can be executable programs or interpreted scripts.

The interface with Squid is very simple. The helper is passed a limited amount of information on stdin to perform their expected task. The result is passed back to squid via stdout. With any errors or debugging traces sent back on stderr.

== Squid operations which provide a helper interface ==

Squid-2.6 and later all support:
 * URL manipulation: re-writing and redirection
  * (SquidConf:url_rewrite_program, SquidConf:url_rewrite_access)
  * Specific feature details at [[Features/Redirectors]]
 * ACL logic tests
  * (SquidConf:external_acl_type)
 * Authentication
  * (SquidConf:auth_param)
  * Specific feature details at [[Features/Authentication]] [[Features/NegotiateAuthentication]]

Squid-2.7 (only):
 * HTTP Server redirection replies
  * (SquidConf:location_rewrite_program, SquidConf:location_rewrite_access)
 * Cache object de-duplication
  * (SquidConf:storeurl_rewrite_program, SquidConf:storeurl_rewrite_access)
  * Specific feature details at [[Features/StoreUrlRewrite]]

Squid-2.7 and Squid-3.1+ support:
 * Logging
  * (SquidConf:logfile_daemon)
  * Specific feature details at [[Features/LogModules]]

Squid-3.1 and later also support [[Features/eCAP|eCAP plugins]] and [[Features/ICAP|ICAP services]] which differ from helper scripts in many ways.

== Helper protocols ==

{i} Squid-2.6 and later all support concurrency, however the bundled helpers and many third-party commercial helpers do not. This is changing, the use of concurrency is encouraged to improve performance. The relevant squid.conf concurrency setting must match the helper concurrency support. The [[Features/HelperMultiplexer|helper multiplexer]] wrapper can be used to add concurrency benefits to most non-concurrent helpers.

 /!\ '''WARNING:''' For every line sent by Squid exactly one line is expected back. Some script language such as perl and python need to be careful about the number of newlines in their output.

 /!\ Note that the helper programs other than logging can not use buffered I/O.

=== URL manipulation ===

## start urlhelper protocol
Input line received from Squid:
{{{
[channel-ID] URL ip/fqdn ident method [urlgroup] key-pairs
}}}

 channel-ID::
  This is the concurrency channel number. When concurrency is turned off (set to '''1''') this field and the following space will be completely missing.

 URL::
  The URL received from the client. In Squid with ICAP support, this is the URL after ICAP REQMOD has taken place.

 ip::
  This is the IP address of the client. Followed by a slash ('''/''') as shown above.

 fqdn::
  The FQDN rDNS of the client, if any is known. Squid does not normally perform lookup unless needed by logging or ACLs. Squid does not wait for any results unless ACLs are configured to wait. If none is available '''-''' will be sent to the helper instead.

 ident::
  The IDENT protocol username (if known) of the client machine. Squid will not wait for IDENT username to become known unless there are ACL which depend on it. So at the time re-writers are run the IDENT username may not yet be known. If none is available '''-''' will be sent to the helper instead.

 method::
  The HTTP request method. URL alterations and particularly redirection are only possible on certain methods, and some such as POST and CONNECT require special care.

 urlgroup::
  Squid-2 will send this field with the URL-grouping tag which can be configured on SquidConf:http_port. Squid-3.x will not send this field.

 key-pairs::
  Some of the key=value pairs:
|| myport=... || Squid receiving port ||
|| myip=... || Squid receiving address ||

## end urlhelper protocol

==== HTTP Redirection ====

## start redirector protocol
Redirection can be performed by helpers on the SquidConf:url_rewrite_program interface. Lines performing either redirect or re-write can be produced by the same helpers on a per-request basis. Redirect is preferred since re-writing URLs introduces a large number of problems into the client HTTP experience.

The input line received from Squid is detailed by the section above.

Redirectors send a slightly different format of line back to Squid. 

Result line sent back to Squid:
{{{
[channel-ID] status:URL
}}}

 channel-ID::
  When a concurrency '''channel-ID''' is received it must be sent back to Squid unchanged as the first entry on the line.

 status::
   The HTTP 301, 302 or 307 status code. Please see section 10.3 of RFC RFC:2616 for an explanation of the HTTP redirect codes and which request methods they may be sent on.

 URL::
  The URL to be used instead of the one sent by the client. This must be an absolute URL. ie starting with http:// or ftp:// etc.

 {i} If no action is required leave status:URL area blank.

 {i} The '''status''' and '''URL''' are separated by a colon (''':''') as shown above instead of whitespace.

## end redirector protocol

==== URL Re-Writing (Mangling) ====

## start urlrewrite protocol
URL re-writing can be performed by helpers on the SquidConf:url_rewrite_program, SquidConf:storeurl_rewrite_program and SquidConf:location_rewrite_program interfaces.

WARNING: when used on the url_rewrite_program interface re-writing URLs introduces a large number of problems into the client HTTP experience. Some of these problems can be mitigated with a paired helper running on the SquidConf:location_rewrite_program interface de-mangling the server redirection URLs.

## start urlrewrite onlyprotocol

Result line sent back to Squid:
{{{
[channel-ID] URL
}}}

 channel-ID::
  When a concurrency '''channel-ID''' is received it must be sent back to Squid unchanged as the first entry on the line.

 URL::
  The URL to be used instead of the one sent by the client. If no action is required leave the URL field blank. The URL sent must be an absolute URL. ie starting with http:// or ftp:// etc.

## end urlrewrite protocol

=== Authenticator ===

==== Basic Scheme ====

## start basicauth protocol
Input line received from Squid:
{{{
[channel-ID] username password
}}}

 channel-ID::
  This is the concurrency channel number. When concurrency is turned off (set to '''1''') this field and the following space will be completely missing.

 username::
  The username field sent by the client in HTTP headers. It may be empty or missing.

 password::
  The password value sent by the client in HTTP headers. May be empty or missing.


Result line sent back to Squid:
{{{
[channel-ID] result
}}}

 channel-ID::
  When a concurrency '''channel-ID''' is received it must be sent back to Squid unchanged as the first entry on the line.

 result::
  One of the result codes: '''OK''' to indicate valid credentials, or '''ERR''' to indicate invalid credentials.

## end basicauth protocol

==== Digest Scheme ====

## start digestauth protocol
Input line received from Squid:
{{{
[channel-ID] "username":"realm"
}}}

 channel-ID::
  This is the concurrency channel number. When concurrency is turned off (set to '''1''') this field and the following space will be completely missing.

 username::
  The username field sent by the client in HTTP headers. Sent as a "double-quoted" string. May be empty. It may be configured to use UTF-8 bytes instead of the ISO-8859-1 received.

 realm::
  The digest auth realm string configured in squid.conf. Sent as a "double-quoted" string.

{i} The '''username''' and '''realm''' strings are both double quoted ('''"''') and separated by a colon (''':''') as shown above.


Result line sent back to Squid:
{{{
[channel-ID] result
}}}

 channel-ID::
  When a concurrency '''channel-ID''' is received it must be sent back to Squid unchanged as the first entry on the line.

 result::
  The result '''ERR''' to indicate invalid credentials.<<BR>>
  On successful authentication '''result''' is the digest HA1 value to be used.

## end digestauth protocol

==== Negotiate and NTLM Scheme ====

## start negotiateauth protocol
 {i} These authenticator schemes do not support concurrency due to the statefulness of NTLM.

Input line received from Squid:

 YR::
  Squid sends this to a helper when it needs a new challenge token. This is always the first communication between the two processes. It may also occur at any time that Squid needs a new challenge, due to the SquidConf:auth_param max_challenge_lifetime and max_challenge_uses parameters. The helper should respond with a '''TT''' message.

 KK credentials::
  Squid sends this to a helper when it wants to authenticate a user's credentials. The helper responds with either '''AF''', '''NA''', '''BH''', or '''LD'''. The credentials are an encoded blob exactly as received in the HTTP headers.


Result line sent back to Squid:

 TT challenge::
  Helper sends this message back to Squid and includes a challenge token. It is sent in response to a '''YR''' request. The challenge is base64-encoded, as defined by RFC RFC:2045.

 AF username::
  The helper sends this message back to Squid when the user's authentication credentials are valid. The helper sends the '''username''' with this message because Squid doesn't try to decode the HTTP Authorization header. The '''username''' given here is what gets used by Squid for this client request.

 NA reason::
  The helper sends this message back to Squid when the user's credentials are invalid. It also includes a '''reason''' string that Squid can display on an error page.

 BH reason::
  The helper sends this message back to Squid when the validation procedure fails. This might happen, for example, when the helper process is unable to communicate with a Windows NT domain controller. Squid rejects the user's request.

 LD username::
  This helper-to-Squid response is similar to BH, except that Squid allows the user's request. Like '''AF''', it returns the '''username'''. To use this feature, you must compile Squid with the --enable-ntlm-fail-open option.

## end negotiateauth protocol

=== Access Control (ACL) ===

## start externalacl protocol
This interface has a very flexible field layout. The administrator may configure any number or order of details from the relevant HTTP request or reply to be sent to the helper.

Input line received from Squid:
{{{
[channel-ID] format-options [acl-value [acl-value ...]]
}}}

 channel-ID::
  This is the concurrency channel number. When concurrency is turned off ('''concurrency=1''') in SquidConf:external_acl_type this field and the following space will be completely missing.

 format-options::
  This is the flexible series of tokens configured as the '''FORMAT''' area of SquidConf::external_acl_type. The tokens are space-delimited and exactly match the order of '''%''' tokens in the configured '''FORMAT'''. By default in current releases these tokens are also URL-encoded according to RFC RFC:1738 to protect against whitespace and binary data problems.

 acl-value::
  Some ACL tests such as group name comparisons pass their test values to the external helper following the admin configured FORMAT. Depending on the ACL these may be sent one value at a time, as a list of values, or nothing may be sent. By default in current releases these tokens are also URL-encoded according to RFC RFC:1738 to protect against whitespace and binary data problems.


Result line sent back to Squid:
{{{
[channel-ID] result key-pairs
}}}

 channel-ID::
  When a concurrency '''channel-ID''' is received it must be sent back to Squid unchanged as the first entry on the line.

 result::
  One of the result codes '''OK''' or '''ERR''' to indicate a pass/fail result of this ACL test. The configured usage of the external ACL in squid.conf determines what this result means.

 key-pairs::
  Some optional details returned to Squid. These have the format '''key=value'''. see SquidConf:external_acl_type for the full list supported by your Squid.

Some of the key=value pairs:
|| user= || The users name (login) ||
|| password= || The users password (for login= SquidConf:cache_peer option) ||
|| message= || Message describing the reason. Available as %o in error pages ||
|| tag= || Apply a tag to a request (for both '''ERR''' and '''OK''' results). Only sets a tag, does not alter existing tags. ||
|| log= || String to be logged in access.log. Available as '''%ea''' in SquidConf:logformat specifications ||
## end externalacl protocol

=== Logging ===
## start logdaemon protocol
Squid sends a number of commands to the log daemon. These are sent in the first byte of each input line:

 || L<data>\n || logfile data ||
 || R\n || rotate file ||
 || T\n || truncate file ||
 || O\n || re-open file ||
 || F\n || flush file ||
 || r<n>\n || set rotate count to <n> ||
 || b<n>\n || 1 = buffer output, 0 = don't buffer output ||

No response is expected. Any response that may be desired should occur on stderr to be viewed through cache.log.
## end logdaemon protocol

----
CategoryFeature
