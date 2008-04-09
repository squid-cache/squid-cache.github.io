##master-page:CategoryTemplate
#format wiki
#language en

## This is a template for helping with new configuration examples. Remove this comment and add some descriptive text. A title is not necessary as the WikiPageName is already added here.

= Using PHP for Redirects =

[[Include(ConfigExamples, , from="^## warning begin", to="^## warning end")]]

[[TableOfContents]]

== Why PHP? ==

When looking at the documentation for squid I was relieved to find the page regarding [http://wiki.squid-cache.org/SquidFaq/SquidRedirectors redirecting] urls. However, when I finally got there I was disappointed to see that it was in [http://perl.org perl]. Not knocking perl, I know it is a more clean language than PHP, but I have little knowledge of the language, which limitted my ability to edit and manipulate the redirect as I have done here.

A friend helped me capture the output from the squid proxy to a file so that I could write a php redirect page, after I finished I figured that I would post the information here so that someone else might benefit from my work.

The information here could also be used to author a redirect in some other language.

== What information is sent to our program? ==

Squid sends the following information (space delimited) to what ever
redirect program you may want to use:

|| 1.) || URL ||
|| 2.) || IP Address Making the Request ||
|| 3.) || ??? ||
|| 4.) || Method (ie. POST, GET) ||
|| 5.) || ??? ||

Direct output from squid to a redirect program:
{{{
http://www.google.com/ 192.168.3.144/- - GET -
http://google.com/ 192.168.3.149/- - GET -
http://img0.gmodules.com/ig/images/skins/planets/saturn/x_blue_highlight.gif 192.168.3.149/- - GET -
}}}

As you can see the first field is the url of the page that was requested, followed by the IP address that requested it. The rest of the fields are not necessary for our redirect program but I included them in case some one else needed them.

== Getting Started ==

It should be noted that your redirect should be executable.

I will be placing the redirect in my squid configuration directory (/etc/squid), this is not a requirement, but its easier to find when you want to go back after a few months and make a few changes.

== A Simple PHP Redirect ==

{{{
#!/usr/bin/php
<?php

$temp = array();

while ( $input = fgets(STDIN) ) {
  // Split the output (space delimited) from squid into an array.
  $temp = split(' ', $input);

  // Set the URL from squid to a temporary holder.
  $output = $temp[0] . "\n";

  // Check the URL and rewrite it if it matches limewire.com
  if ( strpos($temp[0], "limewire.com") ) {
    $output = "302:http://www.google.com/\n";
  }
  echo $output;
}
}}}

As you can probably see this rewrites the URL so that it redirects any request that contains 'limewire.com' to the google homepage. I choose the 302 HTTP code so that the url in the users browser also reflects the redirect, otherwise it would display google's page and the url would read limewire.com.

I am fully aware that this is much more code than the perl example. Where this comes into play is later when we start looking at the requesting IP and the time, or day the request was made.

----
CategoryConfigExample
