= Web Proxy Auto Detection (WPAD) =

== What is WPAD? ==

WPAD is an Internet Draft standard which attempts to enumerate the discovery of web proxy autoconfiguration scripts. It has two main deployment modes - DNS-based and DHCP-based - which can allow a network administrator to provide proxy configuration scripts to clients without explicit script path configuration in the User Agent (typically a web browser.)

WPAD does not do much more than to allow the User Agent to discover a proxy autoconfiguration file. Building and using a proxy autoconfiguration script will be described in another section (to be written.)

== When is WPAD useful? ==

WPAD has found use in ISP and Enterprise networks to integrate web proxies into the network without resorting to transparent network interception or enforcing configuration through technologies such as Windows Active Directory Group Policy.

== WPAD Articles ==

 * (Placeholder) covers the motivation behind WPAD and how it attempts to solve the issue;
 * (Placeholder) covers how User Agents can detect the existance of the proxy authentication file via DHCP
 * [:Technology/WPAD/DNS:WPAD DNS] covers how User Agents can detect the existance of the proxy autoconfiguration file via DNS
 * (Placeholder) covers some example WPAD configurations

== Other Articles and Information on WPAD ==

 * http://homepages.tesco.net/J.deBoynePollard/FGA/web-browser-auto-proxy-configuration.html
 * http://www.wlug.org.nz/WPAD
 * http://tools.ietf.org/wg/wrec/draft-ietf-wrec-wpad/
 * http://blogs.msdn.com/wndp/articles/IPV6_PAC_Extensions_v0_9.aspx

== WPAD-like functionality in other protocols ==

 * The Azereus Bittorrent client implements a WPAD-like Cache discovery protocol (JPC) to discover JPC-compatible caches. (Links?) 
