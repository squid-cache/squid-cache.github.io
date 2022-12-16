A list of things which a properly transparent web proxy/cache should do.

 * (add WCCPv2 interception wishlist here)
 * Deal with broken/filtered window scaling options - the quick hack under linux is to manually run '''ip route add $THEIR_IP/32 via $MY_GATEWAY window 65535''' but this could probably be automatically detected and automated somehow
 * Deal with broken ECN implementations - find a broken connection and retry it with ECN disabled. This may require modifications to the OS to enable/disable ECN for that connection.
