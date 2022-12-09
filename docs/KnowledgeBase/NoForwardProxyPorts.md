---
categories: ReviewMe
published: false
---
# No forward-proxy ports

## Synopsis

Squid has been configuered without any port capable of receiving
forward-proxy traffic.

## Symptoms

  - ERROR: No forward-proxy ports configured.

## Explanation

Squid occasionally needs to generate URLs for clients to fetch
supplementary content. Images in error pages or FTP and Gopher indexes,
cache digests, NetDB, cache manager API, etc.

In order to produce a valid URL Squid requires a port configured to
receive normal forward-proxy traffic. The standard well-known port
assigned for this is **port 3128**.

This error occurs when port 3128 has been incorrectly altered into a
interception port.

**Solution**

Configure multiple port lines with at least one being capable of
receiving forward-proxy traffic.


