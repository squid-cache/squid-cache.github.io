# Feature: Log Modules for Squid

  - **Goal**: Logging plugin interface for Squid

  - **Status**: seeking additional daemon helpers to bundle with Squid.

  - **Version**: 2.7, 3.2

  - **Developer**:
    [AdrianChadd](/AdrianChadd)
    (Squid-2),
    [AmosJeffries](/AmosJeffries)
    (Squid-3 port)

## Plug-in Modules

Logging modules are API built into Squid which pass logging information
out to helpers in several different formats.

General [access_log](http://www.squid-cache.org/Doc/config/access_log)
format:

    access_log module:parameters [logformat] [acls]

  - **module**: One of the plugin modules Squid can use to record the
    log data.

  - **parameters**: Parameters to configure the plugin module. Content
    and format is specific to each logging module.

  - **logformat**: The access.log format to be used. See
    [logformat](http://www.squid-cache.org/Doc/config/logformat) for
    more details.

  - **acls**: A list of ACL names, if all the named ACLs match a request
    it will be logged to this log.

### Module: Standard I/O

This is a module uses the traditional I/O method of Squid writing its
logs directly to the file system.

Configuration **module:parameters** to be used by
[access_log](http://www.squid-cache.org/Doc/config/access_log):

    stdio:/var/log/squid/access.log

  - :information_source:
    Used for backwards compatibility with old squid.conf. It is
    recommended that you upgrade to the **daemon** module with the basic
    file helper for better performance.

### Module: Daemon

This is a module runs a helper daemon to offload the log storage
processing from Squid.

The helper daemon program is configured with the
[logfile_daemon](http://www.squid-cache.org/Doc/config/logfile_daemon)
directive.

    logfile_daemon /path/to/helper.binary

Configuration **module:parameters** to be used by
[access_log](http://www.squid-cache.org/Doc/config/access_log):

    daemon:/var/log/squid/access.log

#### Daemon Helpers Available

  - **log_file_daemon** : Log directly to the local file system.

  - **log_db_daemon** : Log directly to an SQL database. MySQL backend
    default.
    [](http://www.mail-archive.com/squid-users@squid-cache.org/msg53342.html)
    or [](http://sourceforge.net/projects/logmysqldaemon/)

  - **blooper** :
    
      - *blooper* is a ruby logfile_daemon which can log to any SQL
        database (Postgres being the main target for it).
    
      - Sources are available on github at
        [](https://github.com/paranormal/blooper)

### [Daemon Message Protocol](/Features/AddonHelpers)

Squid sends a number of commands to the log daemon. These are sent in
the first byte of each input line:

  - 
    
    |              |                                            |
    | ------------ | ------------------------------------------ |
    | L\<data\>\\n | logfile data                               |
    | R\\n         | rotate file                                |
    | T\\n         | truncate file                              |
    | O\\n         | re-open file                               |
    | F\\n         | flush file                                 |
    | r\<n\>\\n    | set rotate count to \<n\>                  |
    | b\<n\>\\n    | 1 = buffer output, 0 = don't buffer output |
    

No response is expected. Any response that may be desired should occur
on stderr to be viewed through cache.log.

### Module: System Log

This is a module using the syslog() API to send log data to any system
logging daemons which accept records in that binary format.

Configuration **module:parameters** to be used by
[access_log](http://www.squid-cache.org/Doc/config/access_log):

    syslog:facility.priority

  - *facility* and *priority* fields are intentionally formatted the
    same as syslog.conf entries. See your syslog configuration
    documentation for possible values.

  - :information_source:
    syslog uses UDP which may drop packets when the network is under
    load or congested.

### Module: UDP Receiver

This is a module using UDP protocol to send log lines to an external
daemon or central logging server.

Configuration **module:parameters** to be used by
[access_log](http://www.squid-cache.org/Doc/config/access_log):

    udp://host:port

  - :information_source:
    being UDP this module may drop packets when the network is under
    load or congested.

### Module: TCP Receiver

This is a module using TCP protocol to send log lines to an external
daemon or central logging server.

Configuration **module:parameters** to be used by
[access_log](http://www.squid-cache.org/Doc/config/access_log):

    tcp://host:port

  - :information_source:
    Available from
    [Squid-3.2](/Releases/Squid-3.2)

  - :information_source:
    [Syslog-ng](http://www.balabit.com/network-security/syslog-ng) can
    receive these logs directly.

[CategoryFeature](/CategoryFeature)
