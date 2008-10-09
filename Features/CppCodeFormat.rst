##master-page:FeatureTemplate
#format wiki
#language en


= Feature: C++ code formatting =

 * '''Goal''': Minimize patch conflicts, reduce commit noise, and improve code readability.
 * '''Status''': Waiting Merge
 * '''ETA''': 10 days
 * '''Version''': Squid 3.1
 * '''Developer''': AlexRousskov

Will automate basic formatting or styling of C++ code. Will test [[http://astyle.sourceforge.net/|astyle]], [[http://invisible-island.net/bcpp/|bcpp]], and other C++ formatters, if any. If none work, will write one. Last time I tested astyle it was so broken it could not be used, but there have been new releases since then.

----
CategoryFeature
