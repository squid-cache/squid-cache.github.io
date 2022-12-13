# MacOS build farm setup

1. download xcode from [the Apple site](https://developer.apple.com/xcode/) and install it
    (requires registration)
1. download [HomeBrew](https://brew.sh/) and install it
1. in a terminal:
      ```
      brew update && brew upgrade
      brew install autoconf automake ccache cppunit gawk gdbm git gnu-sed gnutls grep libtool m4 make nettle openldap openssl
      ```
