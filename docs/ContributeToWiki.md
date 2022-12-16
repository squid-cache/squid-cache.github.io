---
---
# Contributing to the Squid Wiki

Thanks for considering contributing to the [Squid Web Cache wiki](http://wiki.squid-cache.org).
The easiest way to do so is by submitting a pull request to the 
[squid-cache/squid-cache.github.io](https://github.com/squid-cache/squid-cache.github.io)
repository.

Files are formatted in [Github-flavourd MarkDown](https://github.github.com/gfm/), and rendered
using [Jekyll](https://jekyllrb.com/) and [Liquid](https://github.com/Shopify/liquid/wiki).

We have provided some [Hints on Jekyll](/JekyllHints) to get any contributor up to speed
with the underlying context.

## Self-hosting for development

It is possible to run the full website on a local computer. In order to do so one needs to
have [Jekyll](https://jekyllrb.com/) and a recent version of [Ruby](https://www.ruby-lang.org/en/).
On Linux these are generally provided by your distribution. On \*BSD, they can be
obained from the ports collection, and on MacOS they are available from [homebrew](https://brew.sh/).

Then, from the root of the git checkout, run `./bin/serve` ; this will compile the
site and run it on `http://localhost:4000`, you can test your changes locally
untilk you are satisfied and you wish to push your changes back.

Happy hacking!
