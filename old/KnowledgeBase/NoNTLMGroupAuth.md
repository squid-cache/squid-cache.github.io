# NTLM Group ACLs fail during upgrade from Squid-2.5 to Squid-2.6

**Synopsis**

An upgrade from Squid-2.5 to Squid-2.6 (and possibly an underlying
upgrade of Samba/Winbind in the process) breaks NTLM group
authentication. NTLM user authentication still succeeds normally.

**Symptoms**

  - wbinfo returns valid information; eg "wbinfo -t" and "wbinfo -g"
    return user and group lists respectively;

  - Squid can authenticate users via NTLM fine;

  - cache.log logs messages similar to "Could not convert sid
    S-1-5-21-466765145-1792897056-1845911597-1995 to gid"

**Explanation**

Group ACLs for NTLM are implemented by using the helper
"wbinfo_group.pl" to map users+groups into true or false. Squid then
uses the results of this in the ACL. "wbinfo_group.pl" internally uses
the command line program "wbinfo" to perform the lookups. If "wbinfo"
can't map the user/group sid to a group id (gid) then all lookups will
return failure/false and Squid will deny access.

**Repairing**

At least one report of this issue was solved by deleting a corrupted
"winbindd_idmap.tdb" file in /var/db/samba. The steps taken to resolve
the issue were:

  - Verify kerberos is working fine:
    
      - kinit \<user@DOMAIN\>
    
      - klist; which should show a valid certificate

  - Verify winbind can authenticate to the Active Directory service
    fine:
    
      - wbinfo -t should display "checking the trust secret via RPC
        calls succeeded"
    
      - wbinfo -u should list all users
    
      - wbinfo -g should list all groups

  - Stop Squid, Samba, Winbindd

  - Delete the winbindd_idmap.tdb file

  - Ensure time synchronisation to the Active Directory server is setup
    and running correctly

  - Rejoin the domain via "net ads join -U \<user@DOMAIN\>"

  - Restart Samba/Winbind/Squid

To verify, use:

  - wbinfo -n \<name or group\>; which will attempt to map the given
    user or group name to an SID.

**Thanks**

Thanks to David Whitehead `<dwhitehead AT seacrestvillage DOT org>` for
working with the Squid team to resolve and document this issue.

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
