# Caching AV updates

by
*[YuriVoinov](/YuriVoinov#)*

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Outline

One of most common task is caching AV (antivirus) updates.

## Usage

To do this you can modify refresh\_pattern to your Squid.

## Squid Configuration File

Paste the configuration file like this:

    # AV updates
    refresh_pattern -i \.symantecliveupdate\.com\/.*\.(zip|7z|irn|[m|x][0-9][0-9])          4320    100%    43200   reload-into-ims
    refresh_pattern -i .*dnl.*\.geo\.kaspersky\.(com|ru)\/.*\.(zip|avc|kdc|nhg|klz|d[at|if])        4320    100%    43200   reload-into-ims
    refresh_pattern -i \.kaspersky-labs\.(com|ru)\/.*\.(cab|zip|exe|ms[i|p])        4320    100%    43200   reload-into-ims
    refresh_pattern -i \.kaspersky\.(com|ru)\/.*\.(cab|zip|exe|ms[i|p]|avc) 4320    100%    43200   reload-into-ims
    refresh_pattern -i .update\.geo\.drweb\.com     4320    100%    43200   reload-into-ims
    refresh_pattern -i \.avast.com\/.*\.(vp[u|aa])          4320    100%    43200   reload-into-ims
    refresh_pattern -i \.avg.com\/.*\.(bin)         4320    100%    43200   reload-into-ims

[CategoryConfigExample](/CategoryConfigExample#)
