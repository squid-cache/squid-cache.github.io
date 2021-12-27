#!/bin/bash 
git ls-files | grep '\.db$' | while read file
do
    path="${file%\.db}"

    echo "$path"
    pandoc -f docbook -t gfm --strip-empty-paragraphs -o "$path.md" "$file"
done
