##master-page:FeatureTemplate
#format wiki
#language en


= Feature: C++ code formatting =

 * '''Goal''': Minimize patch conflicts, reduce commit noise, and improve code readability.
 * '''Status''': Not started
 * '''Version''': Squid 3.1
 * '''Developer''': AlexRousskov
 * '''ETA''': 45 days

Will automate basic formatting or styling of C++ code. Will test fresh versions of [http://astyle.sourceforge.net/ astyle] and other C++ formatters, if any. If none work, will write one. Last time I tested astyle it was so broken it could not be used, but there have been new releases since then.

----
CategoryFeature
