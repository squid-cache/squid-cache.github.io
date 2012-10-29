##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

The Squid project uses the services of [[https://communities.coverity.com/community/scan-%28open-source%29|Coverity Scan]] to run automated test builds, as part of the [[BuildFarm]] activities. Kudos to [[http://www.coverity.com/|Coverity]] for supporting this useful community service.

Trunk will automatically be built (in "maximus" test-suite configuration only") once a week and submitted to Coverity for analysis if the build is successful.

In order to access the results of the analysis you need to register an user (ask <<MailTo(kinkie@squid-cache.org)>> to register one, including in your mail your name, surname, desired username and valid email address).

You can then access the Squid analysis results page at address http://scan5.coverity.com:8080/

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
