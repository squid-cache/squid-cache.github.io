# How the Programming Guide is built

## The data
The main contents are in the https://github.com/squid-cache/programming-guide.github.io github repository,
and are published via github pages, at address https://programming-guide.squid-cache.org/

The pages are automatically refreshed daily from a checkout of the squid sources
by a [github workflow](https://github.com/squid-cache/programming-guide.github.io/blob/main/.github/workflows/gen-docs.yaml).

The doxyfile in the squid sources is not used,
as it is stricly tied to the version of the programming guide which is embedded in the squid main site.
This unfortunately means that the graphic theme doesn't match the squid site.

In order to preserve links and references, apache redirect rules are in place
via mod_rewrite in `master.squid-cache.org.conf` to ensure that there are no
dangling links.

In order to be able to publish the github pages site, the automations need
to rely on the `PUSH_TOKEN` repository secret, which needs to be refreshed
at least once a year.

## Transitional measures
The squid main site still contains the full programming guide, and it's still
refreshed daily from the sources. It is not however served, as it
is masked by the redirect to the github pages.
Once we are fully satisfied that it's no longer needed, we can
remove the generation logic, the copy of the contents, and the
related configuration files in the squid sources.
