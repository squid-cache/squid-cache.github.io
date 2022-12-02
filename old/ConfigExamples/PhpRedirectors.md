---
categories: [ConfigExample, ReviewMe]
published: false
---
# Using PHP for Redirects

**Warning**: Any example presented here is provided "as-is" with no
support or guarantee of suitability. If you have any further questions
about these examples please email the squid-users mailing list.

## Why PHP?

When looking at the documentation for squid I was relieved to find the
page regarding
[redirecting](/Features/Redirectors)
urls. However, when I finally got there I was disappointed to see that
it was in [perl](http://perl.org). Not knocking perl, I know it is a
more clean language than PHP, but I have little knowledge of the
language, which limited my ability to edit and manipulate the redirect
as I have done here.

## Getting Started

It should be noted that your redirect should be executable.

I will be placing the redirect in my squid configuration directory
(/etc/squid), this is not a requirement, but its easier to find when you
want to go back after a few months and make a few changes.

Don't forget to add the redirect program to your squid configuration.

    url_rewrite_program /etc/squid/redirect.php

Note: PHP directive 'stream_set_timeout' is set to 24 hours here,
otherwise the script would terminate every 60 seconds (php.ini default)
which could cause your proxy service to be inaccessible frequently as
squid re-starts the processes.

### Related config options

  - [url_rewrite_program](http://www.squid-cache.org/Doc/config/url_rewrite_program)

  - [url_rewrite_access](http://www.squid-cache.org/Doc/config/url_rewrite_access)

  - [url_rewrite_bypass](http://www.squid-cache.org/Doc/config/url_rewrite_bypass)

  - [url_rewrite_children](http://www.squid-cache.org/Doc/config/url_rewrite_children)

  - [url_rewrite_concurrency](http://www.squid-cache.org/Doc/config/url_rewrite_concurrency)

  - [url_rewrite_host_header](http://www.squid-cache.org/Doc/config/url_rewrite_host_header)

## PHP Redirect (Simple)

    #!/usr/bin/php
    <?php
    
    $temp = array();
    
    // Extend stream timeout to 24 hours
    stream_set_timeout(STDIN, 86400);
    
    while ( $input = fgets(STDIN) ) {
      // Split the output (space delimited) from squid into an array.
      $temp = split(' ', $input);
    
      // Set the URL from squid to a temporary holder.
      $output = $temp[0] . "\n";
    
      // Check the URL and rewrite it if it matches foo.example.com
      if ( strpos($temp[0], "foo.example.com") !== false ) {
        $output = "302:http://www.example.com/\n";
      }
      echo $output;
    }

As you can probably see this rewrites the URL so that it redirects any
request that contains 'foo.example.com' to the example.com homepage. I
choose the 302 HTTP code so that the URL in the users browser also
reflects the redirect, otherwise it would display example.com's page and
the URL would read foo.example.com.

I am fully aware that this is much more code than the perl example.
Where this comes into play is later when we start looking at the
requesting IP and the time, or day the request was made.

## PHP Redirect (With IP Checking)

    #!/usr/bin/php
    <?php
    
    $temp = array();
    
    // Extend stream timeout to 24 hours
    stream_set_timeout(STDIN, 86400);
    
    while ( $input = fgets(STDIN) ) {
      // Split the output (space delimited) from squid into an array.
      $temp = split(' ', $input);
    
      // Set the URL from squid to a temporary holder.
      $output = $temp[0] . "\n";
    
      // Clean the Requesting IP Address field up.
      $ip = rtrim($temp[1], "/-");
    
      // Check the requesting IP Address.
      if ( $ip == "192.0.2.101" ) {
        // Check the URL and rewrite it if it matches foo.example.com
        if ( strpos($temp[0], "foo.example.com") !== false ) {
          $output = "302:http://www.example.com/\n";
        }
      }
    
      echo $output;
    }

This redirect takes the requesting IP Address into consideration. It
does not take much editing to change the way this works. I'll leave it
to you to figure out how to use this to your advantage. (Hint: '=='
equal, '\!=' not equal)

## PHP Redirect (With day of week and time of day)

    #!/usr/bin/php
    <?php
    
    $temp = array();
    
    // Extend stream timeout to 24 hours
    stream_set_timeout(STDIN, 86400);
    
    while ( $input = fgets(STDIN) ) {
      // Split the output (space delimited) from squid into an array.
      $temp = split(' ', $input);
    
      // Set the URL from squid to a temporary holder.
      $output = $temp[0] . "\n";
    
      // Get the current day of the week and the current hour.
      $hour = date('G');
      $day = date('N');
    
      // If it is Monday - Friday and 8:00 - 17:00 (5:00 PM)
      if ( $hour >= 8 && $hour <= 16 && $day <= 5 ) {
        // Check the URL and rewrite it if it matches foo.example.com
        if ( strpos($temp[0], "foo.example.com") !== false ) {
          $output = "302:http://www.example.com/\n";
        }
      }
    
      echo $output;
    }

This will perform the redirect but only during a work week and during
work hours.

## Putting it all together

    #!/usr/bin/php
    <?php
    
    $temp = array();
    
    // Extend stream timeout to 24 hours
    stream_set_timeout(STDIN, 86400);
    
    while ( $input = fgets(STDIN) ) {
      // Split the output (space delimited) from squid into an array.
      $temp = split(' ', $input);
    
      // Set the URL from squid to a temporary holder.
      $output = $temp[0] . "\n";
    
      // Clean the Requesting IP Address field up.
      $ip = rtrim($temp[1], "/-");
    
      // Get the current day of the week and the current hour.
      $hour = date('G');
      $day = date('N');
    
      if ($hour >= 8 && $hour <= 16 && $day <= 5) {
        if ( strpos($temp[0], "foo.example.com") !== false ) {
          $output = "302:http://www.example.com/\n";
        } elseif ( strpos($temp[0], "bar.example.com") !== false) {
          $output = "302:http://www.example.com/\n";
        }
      }
      if ( strpos($temp[0], "bad.example.com") !== false ) {
        $output = "302:http://www.example.com/\n";
      } elseif ( $ip == "192.0.2.101" && (strpos($temp[0], "example.com") !== false) ) {
        $output = "302:http://example.com/\n";
      }
    
      echo $output;
    }

This is rather interesting, it redirects some sites (foo.example.com,
bar.example.com) but only during work hours. It also redirects
*bad.example.com*, and forces a machine to use example.com instead of
www.example.com

  - [CategoryConfigExample](/CategoryConfigExample)
