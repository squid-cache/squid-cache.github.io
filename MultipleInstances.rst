= Running multiple instances of Squid on a system =

Running multiple instances of Squid on a system is not hard, but it requires the administrator to make sure they don't stomp on each other's feet, and know how to recognize each other to avoid forwarding loops (or misdetected forwarding loops).

== Relevant ''squid.conf'' directives ==
 * {{{visible_hostname}}}
  you may want to keep this unique for troubleshooting purposes
 * {{{http_port}}}
  either the various squids run on different ports, or on different IP addresses. In the latter case the syntax to be used is {{{1.2.3.4:3128}}} and {{{1.2.3.5:3128}}}
 * {{{icp_port}}}, {{{snmp_port}}}
  same as with http_port. If you don need ICP and SNMP, just disable them by setting them to 0.
 * {{{cache_access_log}}}, {{{cache_log}}}
  you want to have different logfiles for you different squid instances. Squid '''might''' even work when all log to the same files, but the result would probably be a garbled mess
 * {{{pid_filename}}}
  this file '''must''' be changed. It is used by squid to detect a running instance and to send various internal messages (i.e. {{{squid -k reconfigure}}})
 * {{{cache_dir}}}
  make sure that no overlapping cache_dirs exist. Squids do not coordinate when accessing them, and shuffling stuff around each others' playground is a '''bad thing ^TM^'''
