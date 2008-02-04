##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Config Includes =

 * '''Goal''': squid.conf should be able to include other configuration files to allow more efficient maintenance.

 * '''Status''': completed

 * '''ETA''': Done.

 * '''Version''': 3.1, 2.7

 * '''Developer''': AdrianChadd (2.7), AmosJeffries (3.1)

 * '''More''': 


## Details
##
## Any other details you can document? This section is optional.
## If you have multiple sections and ToC, please place them here,
## leaving the above summary information in the page "header".

= Details =

Other popular software, most notably apache, have long had the capability of breaking their large or complex configurations into smaller more managable files which are included into the main configuration.

This feature adds similar properties to the squid.conf file.

= Future Developments =

With this feature available it permits the development of a library of configuration snippets to be easily shared between the squid user community.

----
CategoryFeature
