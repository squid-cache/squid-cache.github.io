#language en

<<TableOfContents>>


= Authentication Framework =


Squid's authentication system is responsible for reading
authentication credentials from HTTP requests and deciding
whether or not those credentials are valid.  This functionality
resides in two separate components: Authentication Schemes
and Authentication Modules.


An Authentication Scheme describes how Squid gets the
credentials (i.e. username, password) from user requests.
Squid currently supports two authentication schemes: Basic
and NTLM.  Basic authentication uses the ''WWW-Authenticate''
HTTP header.  The Authentication Scheme code is implemented
inside Squid itself.


An Authentication Module takes the credentials received
from a client's request and tells Squid if they are
are valid.  Authentication Modules are implemented
externally from Squid, as child helper processes.
Authentication Modules interface with various types
authentication databases, such as LDAP, PAM, NCSA-style
password files, and more.

== Authentication Scheme API ==

=== Definition of an Authentication Scheme ===
	
An auth scheme in squid is the collection of functions required to
manage the authentication process for a given HTTP authentication
scheme. Existing auth schemes in squid are Basic and NTLM. Other HTTP
schemes (see for example RFC 2617) have been published and could be
implemented in squid. The term auth scheme and auth module are
interchangeable. An auth module is not to be confused with an
authentication helper, which is a scheme specific external program used
by a specific scheme to perform data manipulation external to squid.
Typically this involves comparing the browser submitted credentials with
those in the organization's user directory.
	
Auth modules SHOULD NOT perform access control functions. Squid has
advanced caching access control functionality already. Future work in
squid will allow a auth scheme helper to return group information for a
user, to allow Squid to more seamlessly implement access control.
	
=== Function typedefs ===

Each function related to the general case of HTTP authentication has
a matching typedef. There are some additional function types used to
register/initialize, deregister/shutdown and provide stats on auth
modules:

 * {{{typedef int   AUTHSACTIVE();}}}
	The Active function is used by squid to determine whether
	the auth module has successfully initialised itself with
	the current configuration.

 * {{{typedef int   AUTHSCONFIGURED();}}}
	The configured function is used to see if the auth module
	has been given valid parameters and is able to handle
	authentication requests if initialised.  If configured
	returns 0 no other module functions except
	Shutdown/Dump/Parse/Free'''''''Config will be called by Squid.

 * {{{typedef void  AUTHSSETUP(authscheme_entry_t *); }}} 
	functions of type AUTHSSETUP are used to register an
	auth module with squid. The registration function MUST be
	named "authSchemeSetup_SCHEME" where SCHEME is the auth_scheme
	as defined by RFC 2617. Only one auth scheme registered in
	squid can provide functionality for a given auth_scheme.
	(I.e. only one auth module can handle Basic, only one can
	handle Digest and so forth). The Setup function is responsible
	for registering the functions in the auth module into the
	passed authscheme_entry_t. The authscheme_entry_t will
	never be NULL. If it is NULL the auth module should log an
	error and do nothing. The other functions can have any
	desired name that does not collide with any statically
	linked function name within Squid. It is recommended to
	use names of the form "authe_SCHEME_FUNCTIONNAME" (for
	example authenticate_NTLM_Active is the Active() function
	for the NTLM auth module.
	
 * {{{typedef void  AUTHSSHUTDOWN(void);}}}
	Functions of type AUTHSSHUTDOWN are responsible for
	freeing any resources used by the auth modules. The shutdown
	function will be called before squid reconfigures, and
	before squid shuts down.
	
 * {{{typedef void  AUTHSINIT(authScheme *);}}}
	Functions of type AUTHSINIT are responsible for allocating
	any needed resources for the authentication module. AUTHSINIT
	functions are called after each configuration takes place
	before any new requests are made.
	
 * {{{typedef void  AUTHSPARSE(authScheme *, int, char *);}}}
	Functions of type AUTHSPARSE are responsible for parsing
	authentication parameters. The function currently needs a
	scheme scope data structure to store the configuration in.
	The passed scheme's scheme_data pointer should point to
	the local data structure. Future development will allow
	all authentication schemes direct access to their configuration
	data without a locally scope structure. The parse function
	is called by Squid's config file parser when a auth_param
	scheme_name entry is encountered.
	
 * {{{typedef void  AUTHSFREECONFIG(authScheme *);}}}
	Functions of type AUTHSFREECONFIG are called by squid
	when freeing configuration data. The auth scheme should
	free any memory allocated that is related to parse data
	structures. The scheme MAY take advantage of this call to
	remove scheme local configuration dependent data. (Ie cached
	user details that are only relevant to a config setting).
	
 * {{{typedef void  AUTHSDUMP(StoreEntry *, const char *, authScheme *);}}}
	Functions of type AUTHSDUMP are responsible for writing
	to the !StoreEntry the configuration parameters that a user
	would put in a config file to recreate the running
	configuration.
	
 * {{{typedef void  AUTHSSTATS(StoreEntry *);}}}
	Functions of type AUTHSSTATS are called by the cachemgr
	to provide statistics on the authmodule. Current modules
	simply provide the statistics from the back end helpers
	(number of requests, state of the helpers), but more detailed
	statistics are possible - for example unique users seen or
	failed authentication requests.  The next set of functions
	work on the data structures used by the authentication
	schemes.
	
 * {{{typedef void  AUTHSREQFREE(auth_user_request_t *);}}}
	The AUTHSREQFREE function is called when a auth_user_request is being
	freed by the authentication framework, and scheme specific data was
	present. The function should free any scheme related data and MUST set
	the scheme_data pointer to NULL. Failure to unlink the scheme data will
	result in squid dying.

 * typedef char *AUTHSUSERNAME(auth_user_t *);
	Squid does not make assumptions about where the username
	is stored.  This function must return a pointer to a NULL
	terminated string to be used in logging the request. Return
	NULL if no username/usercode is known. The string should
	NOT be allocated each time this function is called.

 * typedef int   AUTHSAUTHED(auth_user_request_t *);
	The AUTHED function is used by squid to determine whether
	the auth scheme has successfully authenticated the user
	request. If timeouts on cached credentials have occurred
	or for any reason the credentials are not valid, return
	false.The next set of functions perform the actual
	authentication. The functions are used by squid for both
	WWW- and Proxy- authentication. Therefore they MUST NOT
	assume the authentication will be based on the Proxy-*
	Headers.
	
 * typedef void  AUTHSAUTHUSER(auth_user_request_t *, request_t *, !ConnStateData *, http_hdr_type);
	Functions of type AUTHSAUTHUSER are called when Squid
	has a request that needs authentication. If needed the auth
	scheme can alter the auth_user pointer (usually to point
	to a previous instance of the user whose name is discovered
	late in the auth process. For an example of this see the
	NTLM scheme). These functions are responsible for performing
	any in-squid routines for the authentication of the user.
	The auth_user_request struct that is passed around is only
	persistent for the current request. If the auth module
	requires access to the structure in the future it MUST lock
	it, and implement some method for identifying it in the
	future. For example the NTLM module implements a connection
	based authentication scheme, so the auth_user_request struct
	gets referenced from the !ConnStateData.
	
 * typedef void  AUTHSDECODE(auth_user_request_t *, const char *);
	Functions of type AUTHSDECODE are responsible for decoding the passed
	authentication header, creating or linking to a auth_user struct and 
	for storing any needed details to complete authentication in 
	AUTHSAUTHUSER.
	
 * typedef int   AUTHSDIRECTION(auth_user_request_t *);
	Functions of type AUTHSDIRECTION are used by squid to determine what
	the next step in performing authentication for a given scheme is. The
	following are the return codes:

         - -2 = error in the auth module. Cannot determine request direction.
         - -1 = the auth module needs to send data to an external helper.
           Squid will prepare for a callback on the request and call the
         AUTHSSTART function.
         - 0 = the auth module has all the information it needs to
           perform the authentication and provide a succeed/fail result.
         - 1 = the auth module needs to send a new challenge to the
           request originator. Squid will return the appropriate status code
           (401 or 407) and call the registered !FixError function to allow the
           auth module to insert it's challenge.

	
 * typedef void  AUTHSFIXERR(auth_user_request_t *, !HttpReply *, http_hdr_type, request_t *);
	Functions of type AUTHSFIXERR are used by squid to add scheme
	specific challenges when returning a 401 or 407 error code. On requests
	where no authentication information was provided, all registered auth
	modules will have their AUTHSFIXERR function called. When the client
	makes a request with an authentication header, on subsequent calls only the matching
	AUTHSFIXERR function is called (and then only if the auth module
	indicated it had a new challenge to send the client). If no auth schemes
	match the request, the authentication credentials in the request are
	ignored - and all auth modules are called.

 * typedef void  AUTHSFREE(auth_user_t *);
	These functions are responsible for freeing scheme specific data from
	the passed auth_user_t structure. This should only be called by squid
	when there are no outstanding requests linked to the auth user.
	This includes
	removing the user from any scheme specific memory caches.
	
 * typedef void  AUTHSADDHEADER(auth_user_request_t *, !HttpReply *, int);
 * typedef void  AUTHSADDTRAILER(auth_user_request_t *, !HttpReply *, int);
	
	These functions are responsible for adding any authentication
	specific header(s) or trailer(s) OTHER THAN the WWW-Authenticate and
	Proxy-Authenticate headers to the passed !HttpReply. The int indicates
	whether the request was an accelerated request or a proxied request.
	For example operation see the digest auth scheme. (Digest uses a
	Authentication-Info header.) This function is called whenever a
	auth_user_request exists in a request when the reply is constructed
	after the body is sent on chunked replies respectively.
	
 * typedef void  AUTHSONCLOSEC(!ConnStateData *);
	This function type is called when a auth_user_request is
	linked into a !ConnStateData struct, and the connection is closed.
	If any scheme specific activities related to the request or 
	connection are in
	progress, this function MUST clear them.
	
 * typedef void AUTHSSTART(auth_user_request_t * , RH * , void *);
	This function type is called when squid is ready to put the request
	on hold and wait for a callback from the auth module when the auth
	module has performed it's external activities.


=== Data Structures ===
	
This is used to link auth_users into the username cache.
Because some schemes may link in aliases to a user, the
link is not part of the auth_user structure itself.
	
{{{
struct _auth_user_hash_pointer {
    /* first two items must be same as hash_link */
    char *key;
    auth_user_hash_pointer *next;
    auth_user_t *auth_user;
    dlink_node link; /* other hash entries that point to the same auth_user */
};
}}}
	
This is the main user related structure. It stores user-related data,
        and is persistent across requests. It can even persistent across
        multiple external authentications. One major benefit of preserving this
        structure is the cached ACL match results. This structure, is private to
        the authentication framework.
	
{{{
struct _auth_user_t {
    /* extra fields for proxy_auth */
    /* this determines what scheme owns the user data. */
    auth_type_t auth_type;
    /* the index +1 in the authscheme_list to the authscheme entry */
    int auth_module;
    /* we only have one username associated with a given auth_user struct */
    auth_user_hash_pointer *usernamehash;
    /* we may have many proxy-authenticate strings that decode to the same user*/
    dlink_list proxy_auth_list;
    dlink_list proxy_match_cache;
    struct {
    unsigned int credentials_ok:2; /*0=unchecked,1=ok,2=failed*/
    } flags;
    long expiretime;
    /* IP addr this user authenticated from */
    struct in_addr ipaddr;
    time_t ip_expiretime;
    /* how many references are outstanding to this instance*/
    size_t references;
    /* the auth scheme has it's own private data area */
    void *scheme_data;
    /* the auth_user_request structures that link to this. Yes it could be a splaytree
     * but how many requests will a single username have in parallel? */
    dlink_list requests;
};
}}}
	
This is a short lived structure is the visible aspect of the
        authentication framework.
	
{{{
struct _auth_user_request_t {
    /* this is the object passed around by client_side and acl functions */
    /* it has request specific data, and links to user specific data */
    /* the user */
    auth_user_t *auth_user;
    /* return a message on the 401/407 error pages */
    char *message;
    /* any scheme specific request related data */
    void *scheme_data;
    /* how many 'processes' are working on this data */
    size_t references;
};
}}}


The authscheme_entry struct is used to store the runtime
registered functions that make up an auth scheme. An auth
scheme module MUST implement ALL functions except the
following functions: oncloseconnection, !AddHeader, !AddTrailer..
In the future more optional functions may be added to this
data type.

{{{
struct _authscheme_entry {
    char *typestr;
    AUTHSACTIVE   *Active;
    AUTHSADDHEADER *AddHeader;
    AUTHSADDTRAILER *AddTrailer;
    AUTHSAUTHED   *authenticated;
    AUTHSAUTHUSER *authAuthenticate;
    AUTHSDUMP     *dump;
    AUTHSFIXERR   *authFixHeader;
    AUTHSFREE     *FreeUser;
    AUTHSFREECONFIG *freeconfig;
    AUTHSUSERNAME *authUserUsername;
    AUTHSONCLOSEC *oncloseconnection; /*optional*/
    AUTHSDECODE   *decodeauth;
    AUTHSDIRECTION *getdirection;
    AUTHSPARSE    *parse;
    AUTHSINIT     *init;
    AUTHSREQFREE  *requestFree;
    AUTHSSHUTDOWN *donefunc;
    AUTHSSTART    *authStart;
    AUTHSSTATS    *authStats;
};
}}}

For information on the requirements for each of the
functions, see the details under the typedefs above. For
reference implementations, see the squid source code,
/src/auth/basic for a request based stateless auth module,
and /src/auth/ntlm for a connection based stateful auth
module.

=== How to add a new Authentication Scheme ===
	
Copy the nearest existing auth scheme and modify to receive the
appropriate scheme headers. Now step through the acl.c !MatchAclProxyUser
function's code path and see how the functions call down through
authenticate.c to your scheme. Write a helper to provide you scheme with
any backend existence it needs. Remember any blocking code must go in
AUTHSSTART function(s) and _MUST_ use callbacks.

=== How to ``hook in'' new functions to the API ===

Start of by figuring the code path that will result in
the function being called, and what data it will need. Then
create a typedef for the function, add and entry to the
authscheme_entry struct. Add a wrapper function to
authenticate.c (or if appropriate cf_cache.c) that called
the scheme specific function if it exists. Test it. Test
it again. Now port to all the existing auth schemes, or at
least add a setting of NULL for the function for each
scheme.

== Authentication Module Interface ==

=== Basic Authentication Modules ===


Basic authentication provides a username and password.  These
are written to the authentication module processes on a single
line, separated by a space:
{{{
<USERNAME> <PASSWORD>
}}}

The authentication module process reads username, password pairs
on stdin and returns either ``OK'' or ``ERR'' on stdout for
each input line.


The following simple perl script demonstrates how the
authentication module works.  This script allows any
user named ``Dirk'' (without checking the password)
and allows any user that uses the password ``Sekrit'':

{{{
#!/usr/bin/perl -w
$|=1;		# no buffering, important!
while (<>) {
        chop;
        ($u,$p) = split;
        $ans = &amp;check($u,$p);
        print "$ans\n";
}

sub check {
        local($u,$p) = @_;
        return 'ERR' unless (defined $p &amp;&amp; defined $u);
        return 'OK' if ('Dirk' eq $u);
        return 'OK' if ('Sekrit' eq $p);
        return 'ERR';
}
}}}
