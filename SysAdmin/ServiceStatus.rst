
'''BUGS TO FIX:'''

squidadm script bin/mk-static.sh displays numerous permission errors when building static.squid'cache.org.
Example:
{{{
rsync: failed to set times on "/srv/www/static.squid-cache.org/public_html/content/Versions/v3/3.HEAD/changesets/squid-3-13555.patch.merged": Operation not permitted (1)
}}}
