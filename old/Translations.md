# Internationalization of Squid Project

  - **Goal**: To make Squid available in many languages.

  - **Status**: Translations needed.

  - **Version**: 2.5+ (langpacks), 3.1+ (auto-negotiate, CSS)

  - **Download**: [](http://www.squid-cache.org/Versions/langpack/)

  - **Coordinator**:
    [AmosJeffries](/AmosJeffries).
    Anyone can contribute translations.

## Volunteer Translation Moderators

Several people have volunteered their time to check and confirm
translations to keep their language(s) updated.

|                     |                               |                                                                                                                                                                                                                                            |
| ------------------- | ----------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **Language**        | **Translations verified by:** |                                                                                                                                                                                                                                            |
| Afrikaans           | af                            | Friedel Wolff                                                                                                                                                                                                                              |
| Bulgarian           | bg                            | Evgeni Gechev                                                                                                                                                                                                                              |
| German              | de                            | Constantin Rack and Robert Förster                                                                                                                                                                                                         |
| English             | en                            | [AmosJeffries](/AmosJeffries) (Squid Project)                                                                                                                                        |
| Persian             | fa                            | Mohsen Saeedi (Fedora Project)                                                                                                                                                                                                             |
| French              | fr                            | Bernard Charrier                                                                                                                                                                                                                           |
| Armenian            | hy                            | Arthur Tumanyan                                                                                                                                                                                                                            |
| Hungarian           | hu                            | Gergely Kiss                                                                                                                                                                                                                               |
| Italian             | it                            | [FrancescoChemolli](/FrancescoChemolli) (Squid Project)                                                                                                                              |
| Dutch (Nederland)   | nl                            | Rene Wijninga                                                                                                                                                                                                                              |
| Malay               | ms                            | *tepung*                                                                                                                                                                                                                                   |
| Portuguese (Brazil) | pt-br                         | Aecio F. Neto                                                                                                                                                                                                                              |
| Romanian            | ro                            | Arthur Titeica                                                                                                                                                                                                                             |
| Russian             | ru                            | Yuri Voinov                                                                                                                                                                                                                                |
| Slovak              | sk                            | *Helix*                                                                                                                                                                                                                                    |
| Slovenian           | sl                            | Aleksa Šušulić                                                                                                                                                                                                                             |
| Serbian (Latin)     | sr-latn                       | *batailic*                                                                                                                                                                                                                                 |
| Spanish             | es , es-mx                    | Javier Pacheco                                                                                                                                                                                                                             |
| Swedish             | sv                            | [HenrikNordstrom](/HenrikNordstrom) (Squid Project)                                                                                                                                  |
| Others              |                               | **Unverified**, If you are familiar with any of these or other languages, please volunteer. It is a short spare-time activity taking only a few minutes in the occasional week. Without a moderator we cannot fix any bad language errors. |

## How can I contribute?

### Donate Live server statistics

The following configuration will cause Squid to log the languages
passing through your proxy. In an anonymous way such that it is safe to
be shared without breaking anyones privacy.

    logformat languagelog %{Accept-Language}>h
    access_log /var/log/squid/languages.log languagelog

The file generated is quite huge with a lot of duplicated information.
Sorting and compacting it before sending it in can save you and us a lot
of bandwidth. Also, over time this information will reduce down to the
finite set of actual users languages.

What I do is a weekly run of this:

    sort -u languages.log.* >temp.log
    rm languages.log.*
    mv temp.log languages.log.compacted

The relatively small **languages.log.compacted** file can then be sent
at any time to the Squid project to help us identify what code aliases
we need to supply for each language.

  - ℹ️
    reverse-proxy operators may also find this info useful for
    identifying the languages their users would prefer the website texts
    to be shown in.

### Suggest a translation fix

  - How we do translations and how you can join in is detailed at
    [Translations/Basics](/Translations/Basics)

  - What you need to know to make useful translations is at
    [Translations/Guidelines](/Translations/Guidelines)

### Become a language moderator

We really need people familiar enough with each language listed above to
verify and approve/reject the general suggestions. Please contact
[AmosJeffries](/AmosJeffries)
directly about becoming a moderator.

## How does this affect my installed Squid?

Any Squid is able to use the pre-translated
[langpack](http://www.squid-cache.org/Versions/langpack/) tarballs, but
the auto-negotiate and CSS features are not planned for back-porting.

Any existing Squid which have been configured with
[error\_directory](http://www.squid-cache.org/Doc/config/error_directory)
in their squid.conf will not be affected. If you have used this method
to provide your own language translations please consider joining the
translation effort by submitting your language as outlined above, and
then upgrading to the langpack or
[Squid-3.1](/Releases/Squid-3.1)
with auto-negotiate.

  - ⚠️
    Squid older than
    [Squid-3.1](/Releases/Squid-3.1)
    without an explicit
    [error\_directory](http://www.squid-cache.org/Doc/config/error_directory)
    entry have a default one. This may need overriding to use the new
    files.

## What has been done?

  - More languages and new page translations

  - HTML 4.01 strict standards compliance

  - Provides error pages matched to visitors own browser language
    settings.

  - Provides direct control of error page display using CSS.

## So how can I do this upgrade?

## Manual Install

[Squid-3.1](/Releases/Squid-3.1)
admin just need to follow these steps:

  - Check that your preferred default language is available for
    auto-translated pages. The ones installed can be seen in your squid
    error directory as a bunch of folders named after their ISO codes:
    (en, en-gb, etc.).

  - Add
    [error\_default\_language](http://www.squid-cache.org/Doc/config/error_default_language)
    option to squid.conf with the code/folder-name for the language.
    This will provide a suitable default language if none can be
    negotiated with the browser.

  - Remove
    [error\_directory](http://www.squid-cache.org/Doc/config/error_directory)
    from squid.conf

  - Optional: download newest translations and languages
    [package](http://www.squid-cache.org/Versions/langpack/)

  - Make any CSS changes you need to /etc/squid/errorpage.css for
    display.

Reconfigure or restart squid.

  - ℹ️
    Languages specified by their full name (ie *English*) are not able
    to be auto-negotiated. They are now deprecated and due for removal
    as soon as ISO coded versions are made available.

### Debian and Ubuntu

The error pages bundle is available as a package **squid-langpack**
starting with Debian Squeeze or Ubuntu Karmic Koala.

Install that package and update your squid.conf settings as above.
Noting that the error page files are now installed under
**/usr/share/squid-langpack**

## Troubleshooting

### WARNING: Error Pages Missing Language:

This just means that your installed Squid does not have the named
language code in its installed error page templates. Check the latest
[language package](http://www.squid-cache.org/Versions/langpack/) to see
if its been made available since your version was released.

If it is not available please consider contributing towards the
translation. Details are at the top of this page.

### Now I keep getting: "Unable to load default error language files. Reset to backups."

The language code you have entered in squid.conf for
[error\_default\_language](http://www.squid-cache.org/Doc/config/error_default_language)
does not match any of the currently installed error page translations.

Check that you spelled it correctly, it must match the ISO codes used
for one of the sub-directory names in your squid errors directory.

  - ℹ️
    This only affects the backup language, the one used if the users
    preferred is not available.

### What about the custom ERR\_MY\_PAGE files I made?

Yes Squid can still present them. Even while presenting localized copies
of the basic error pages.

Create a new directory next to the installed **templates/** and language
coded directories. This is essentially a fake language. Your custom
pages go in there and specify the fake language name of your folder in
the
[error\_default\_language](http://www.squid-cache.org/Doc/config/error_default_language)
directive.

Note: Custom errors need unique names, so as not to clash with the
default pages. If there is a clash the provided translations will
override custom pages for many users.

[CategoryFeature](/CategoryFeature)
