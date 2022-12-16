##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## [[TableOfContents]]

The Squid project uses the services of [[https://communities.coverity.com/community/scan-%28open-source%29|Coverity Scan]] to run automated test builds, as part of the [[BuildFarm]] activities. Kudos to [[http://www.coverity.com/|Coverity]] for supporting this useful community service.

Trunk will automatically be built (in "maximus" test-suite configuration only") once a week and submitted to Coverity for analysis if the build is successful.

In order to access the results of the analysis you need to register an user by contacting <<MailTo(kinkie@squid-cache.org)>>.
Please include in your mail in your mail your name, surname, desired username, a valid email address and a brief explanation of the motivation for requesting access.
If you are not a regular participant to any of the Squid mailing lists, please also add a brief introduction or a link to some Net resource detailing your background.

You can then access the Squid analysis results page at address http://scan5.coverity.com:8080/

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
