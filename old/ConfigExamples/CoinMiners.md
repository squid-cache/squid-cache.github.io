---
categories: [ConfigExample, ReviewMe]
published: false
---
*by
[YuriVoinov](/YuriVoinov)*

# Coin Miners Filtering

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

Malware coin-mining scripts is modern trend to use foreign CPU/memory
resources without explicit user's permission. This is actual problem,
which can be suppressed by browser's plugin. However, it is requires to
install add-ons manually, and impossible in some cases.

## Usage

To protect users from coin miners it is enough to set-up gateway to
block communications between malware JS and mining pools. This will
disable coin miners on client-side.

## More

In any case, to achieve this goal, you should set up SSL Bump-aware
Squid. Since over 80% of HTTP traffic, the proxy does not make sense
without the inspection of encrypted traffic. Do not forget about
security - such a proxy should not reduce security and its cache should
be protected from unauthorized access, as well as logs.

The most convenient way to implement protection against miners is using
[ufdbguard](https://urlfilterdb.com). But if, by any reason, you don't
want to use redirector, you can simple use squid's acl (dstdomain, for
example).

## Squid Configuration File

Paste the configuration file like this:

    # ufdbGuard rewriter
    url_rewrite_program /usr/local/ufdbguard/bin/ufdbgclient -m 4
    url_rewrite_children 64 startup=8 idle=4 concurrency=4
    url_rewrite_extras "%>a/%>A %un %>rm bump_mode=%ssl::bump_mode sni=\"%ssl::>sni\" referer=\"%{Referer}>h\""
    url_rewrite_access allow all
    url_rewrite_bypass off

You can find updateable coin miners list
[here](https://raw.githubusercontent.com/Marfjeh/coinhive-block/master/domains).

To automate updates with cron, you can use [this
script](/ConfigExamples/CoinMiners?action=AttachFile&do=get&target=update_miners.sh):

    #
    # Convert the miners server listing
    # into an ufdbGuard domains.
    # Modified by Y.Voinov (c) 2014,2018
    
    # Variables
    dst_dir="/usr/local/ufdbguard/blacklists/miners"
    work_dir="/tmp"
    filteruser="ufdb"
    filtergroup="ufdb"
    
    # OS commands
    AWK=`which awk`
    CHOWN=`which chown`
    ECHO=`which echo`
    GREP=`which grep`
    MV=`which mv`
    PRINTF=`which printf`
    TOUCH=`which touch`
    WGET=`which wget`
    
    $ECHO "List downloading..."
    $WGET -O $work_dir/miners "https://raw.githubusercontent.com/Marfjeh/coinhive-block/master/domains" && \
    $ECHO "Move to blacklists directory..."
    $MV $work_dir/miners $dst_dir/domains
    
    # Change permission
    $PRINTF "Set permissions..."
    $CHOWN $filteruser:$filtergroup $dst_dir/domains
    $ECHO "Done."
    
    # Update date'n-time
    $PRINTF "Update date and time to current..."
    $TOUCH $dst_dir/*
    $ECHO "Done."
    #

## ufdbguard configuration

Add category to ufdbguard.conf:

    category miners {
            domainlist "miners/domains"
            redirect "http://your_proxy_FQDN:8080/cgi-bin/URLblocked.cgi?clientgroup=%s&clientaddr=%a&category=%t&url=%u"
    }

Then add **\!miners** to ufdbguard ACL(s). Don't forget to compile
miners database and restart ufdbguardd.

Also, don't forget to configure ufdbguard to work with bump-enabled
Squid:

    redirect-bumped-https "https://your_proxy_FQDN:4443/cgi-bin/URLblocked.cgi?clientgroup=%s&clientaddr=%a&category=%t&url=%u"

and make sure you redirection web-server has configured SSL.

## Testing your setup

Just visit [this site](https://mineblock.org/). You should see [this
picture](/ConfigExamples/CoinMiners?action=AttachFile&do=get&target=C89L68e.png).

[CategoryConfigExample](/CategoryConfigExample)
