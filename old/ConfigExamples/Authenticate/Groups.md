# Configure Squid for Group-Based access controls

Warning: Any example presented here is provided "as-is" with no support
or guarantee of suitability. If you have any further questions about
these examples please email the squid-users mailing list.

## Outline

To perform group-based access controls you need to already have
authentication configured and working on a per-user basis.

Details on how to do that are covered in:

  - [ConfigExamples/Authenticate/Ntlm](/ConfigExamples/Authenticate/Ntlm#)
    for NTLM (only)

  - [ConfigExamples/Authenticate/WindowsActiveDirectory](/ConfigExamples/Authenticate/WindowsActiveDirectory#)
    for Negotiate (NTLM and/or Kerberos)

The example below uses winbind for group lookps. There are several other
helpers bundled with Squid that perform group lookups.

Look for **group** check type in the **Access Control** section of the
[helpers index](http://www.squid-cache.org/Doc/man/).

## Squid Configuration File

Create and ACL for checking the group access:

    external_acl_type testForGroup %LOGIN /usr/local/squid/libexec/ext_wbinfo_group_acl.pl
    
    acl inGroupX external testForGroup someGroupNameX

and to use the ACL as you would any other authentication ACL

    http_access allow inGroupX
