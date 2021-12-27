#!/bin/bash 
git ls-files | grep '\.rst$' | while read file
do
    path="${file%\.rst}"
    urlpath="${path// /%20}"

    sleep 5 # do not trigger rate limiting
    echo "$path"
    curl -sS "https://wiki.squid-cache.org/$urlpath?action=show&mimetype=text%2Fdocbook" >"$path.db" 2>"$path.db.err"
done
