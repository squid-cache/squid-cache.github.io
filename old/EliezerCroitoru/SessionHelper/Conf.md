---
categories: ReviewMe
published: false
---
Describe EliezerCroitoru/SessionHelper/Conf here.

    acl splash_page url_regex -i ^http://www1.ngtech.co.il/splash.html
    
    # Set up the session helper in active mode.
    external_acl_type session ipv4 concurrency=100 ttl=3 %SRC /opt/external_acl/session/session_moneta.rb
    
    # Pass the LOGIN command to the session helper with this ACL
    acl session_login external session LOGIN
    
    # Set up the normal session helper.
    external_acl_type session_active_def ipv4 concurrency=100 ttl=3 %SRC /opt/external_acl/session/session_moneta.rb
    
    # Normal session ACL as per simple example
    acl session_is_active external session_active_def
    
    # ACL to match URL
    acl clicked_login_url url_regex -i ^http://www1.ngtech.co.il/splash_accept.html
    
    # First check for the login URL. If present, login session
    http_access allow clicked_login_url session_login
    http_access allow splash_page
    
    # If we get here, URL not present, so renew session or deny request.
    http_access deny !session_is_active
    
    # Deny page to display
    deny_info http://www1.ngtech.co.il/splash.html session_is_active
