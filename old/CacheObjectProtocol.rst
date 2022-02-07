The '''Cache Object Protocol''' is a pseudo-protocol used to access [[CacheManagerObject|Cache Manager Objects]]. It works on a very simple fashion. The client establishes a connection with a [[CacheManager|Cache Manager]] server and asks for an object, optionally supplying a password. The server processes its request, maybe performing some management action, and writes the result down to the client, closing the connection so far.

Sounds weird, but no communication will happen directly between the client and the service being accessed, making the protocol be called as pseudo. The [[CacheManager|Cache Manager]] is just a subsystem of the Squid server. A set of C functions available at runtime. An abstraction is made here so that service is virtually behind our proxy. This mean that all existing protocols used to talk through the HTTP proxy are almost sufficient, missing only some way to specify the target object and in what Cache Manager server it resides. The ''' [[CacheObjectScheme|cache_object scheme]]''' is the way for doing that.

== See also ==

 * CacheManager
 * CacheManagerObject
 * CacheObjectScheme
 * CacheManagerCgi
