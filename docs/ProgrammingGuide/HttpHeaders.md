---
categories: Internals
---
# HTTP Headers

*Files:*

  - `HttpHeader.c`, `HttpHeaderTools.c`, `HttpHdrCc.c`,
    `HttpHdrContRange.c`, `HttpHdrExtField.c`, `HttpHdrRange.c`

`HttpHeader` class encapsulates methods and data for HTTP header
manipulation. `HttpHeader` can be viewed as a collection of HTTP
header-fields with such common operations as add, delete, and find.
Compared to an ascii "string" representation, `HttpHeader` performs
those operations without rebuilding the underlying structures from
scratch or searching through the entire "string".

## General remarks

`HttpHeader` is a collection (or array) of HTTP header-fields. A header
field is represented by an `HttpHeaderEntry` object. `HttpHeaderEntry`
is an (id, name, value) triplet. Meaningful "Id"s are defined for
"well-known" header-fields like "Connection" or "Content-Length". When
Squid fails to recognize a field, it uses special "id", *HDR_OTHER*.
Ids are formed by capitalizing the corresponding HTTP header-field name
and replacing dashes ('-') with underscores ('_').

Most operations on `HttpHeader` require a "known" id as a parameter. The
rationale behind the later restriction is that Squid programmer should
operate on "known" fields only. If a new field is being added to header
processing, it must be given an id.

## Life cycle

`HttpHeader` follows a common pattern for object initialization and
cleaning:

``` c++
    /* declare */
    HttpHeader hdr;

    /* initialize (as an HTTP Request header) */
    httpHeaderInit(&hdr, hoRequest);

    /* do something */
    ...

    /* cleanup */
    httpHeaderClean(&hdr);
```

Prior to use, an `HttpHeader` must be initialized. A programmer must
specify if a header belongs to a request or reply message. The
"ownership" information is used mostly for statistical purposes.

Once initialized, the `HttpHeader` object **must** be, eventually,
cleaned. Failure to do so will result in a memory leak.

Note that there are no methods for "creating" or "destroying" a
"dynamic" `HttpHeader` object. Looks like headers are always stored as a
part of another object or as a temporary variable. Thus, dynamic
allocation of headers is not needed.

## Header Manipulation

The mostly common operations on HTTP headers are testing for a
particular header-field (`httpHeaderHas()`), extracting field-values
(`httpHeaderGet*()`), and adding new fields (`httpHeaderPut*()`).

`httpHeaderHas(hdr, id)` returns true if at least one header-field
specified by "id" is present in the header. Note that using *HDR_OTHER*
as an id is prohibited. There is usually no reason to know if there are
"other" header-fields in a header.

`httpHeaderGet<Type>(hdr, id)` returns the value of the specified
header-field. The "Type" must match header-field type. If a header is
not present a "null" value is returned. "Null" values depend on
field-type, of course.

Special care must be taken when several header-fields with the same id
are preset in the header. If HTTP protocol allows only one copy of the
specified field per header (e.g. "Content-Length"),
`httpHeaderGet<Type>()` will return one of the field-values (chosen
semi-randomly). If HTTP protocol allows for several values (e.g.
"Accept"), a "String List" will be returned.

It is prohibited to ask for a List of values when only one value is
permitted, and visa-versa. This restriction prevents a programmer from
processing one value of an header-field while ignoring other valid
values.

`httpHeaderPut<Type>(hdr, id, value)` will add an header-field with a
specified field-name (based on "id") and field_value. The location of
the newly added field in the header array is undefined, but it is
guaranteed to be after all fields with the same "id" if any. Note that
old header-fields with the same id (if any) are not altered in any way.

The value being put using one of the `httpHeaderPut()` methods is
converted to and stored as a String object.

Example:

``` 
    /* add our own Age field if none was added before */
    int age = ...
    if (!httpHeaderHas(hdr, HDR_AGE))
        httpHeaderPutInt(hdr, HDR_AGE, age);
```

There are two ways to delete a field from a header. To delete a "known"
field (a field with "id" other than *HDR_OTHER*), use
`httpHeaderDelById()` function. Sometimes, it is convenient to delete
all fields with a given name ("known" or not) using
`httpHeaderDelByName()` method. Both methods will delete *all* fields
specified.

The *httpHeaderGetEntry(hdr, pos)* function can be used for iterating
through all fields in a given header. Iteration is controlled by the
*pos* parameter. Thus, several concurrent iterations over one *hdr* are
possible. It is also safe to delete/add fields from/to *hdr* while
iteration is in progress.
```c++
    /* delete all fields with a given name */
    HttpHeaderPos pos = HttpHeaderInitPos;
    HttpHeaderEntry *e;
    while ((e = httpHeaderGetEntry(hdr, &amp;pos))) {
            if (!strCaseCmp(e->name, name))
                    ... /* delete entry */
    }
```
Note that *httpHeaderGetEntry()* is a low level function and must not be
used if high level alternatives are available. For example, to delete an
entry with a given name, use the *httpHeaderDelByName()* function rather
than the loop above.

## I/O and Headers

To store a header in a file or socket, pack it using
`httpHeaderPackInto()` method and a corresponding "Packer". Note that
`httpHeaderPackInto` will pack only header-fields; request-lines and
status-lines are not prepended, and CRLF is not appended. Remember that
neither of them is a part of HTTP message header as defined by the HTTP
protocol.

## Adding new header-field ids

Adding new ids is simple. First add new HDR_ entry to the
http_hdr_type enumeration in enums.h. Then describe a new header-field
attributes in the HeadersAttrs array located in `HttpHeader.c`. The last
attribute specifies field type. Five types are supported: integer
(*ftInt*), string (*ftStr*), date in RFC 1123 format (*ftDate_1123*),
cache control field (*ftPCc*), range field (*ftPRange*), and content
range field (*ftPContRange*). Squid uses type information to convert
internal binary representation of fields to their string representation
(`httpHeaderPut` functions) and visa-versa (`httpHeaderGet` functions).

Finally, add new id to one of the following arrays: *GeneralHeadersArr*,
*EntityHeadersArr*, *ReplyHeadersArr*, *RequestHeadersArr*. Use HTTP
specs to determine the applicable array. If your header-field is an
"extension-header", its place is in *ReplyHeadersArr* and/or in
*RequestHeadersArr*. You can also use *EntityHeadersArr* for
"extension-header"s that can be used both in replies and requests.
Header fields other than "extension-header"s must go to one and only one
of the arrays mentioned above.

Also, if the new field is a "list" header, add it to the
*ListHeadersArr* array. A "list" field-header is the one that is defined
(or can be defined) using "\&num;" BNF construct described in the HTTP
specs. Essentially, a field that may have more than one valid
field-value in a single header is a "list" field.

In most cases, if you forget to include a new field id in one of the
required arrays, you will get a run-time assertion. For rarely used
fields, however, it may take a long time for an assertion to be
triggered.

There is virtually no limit on the number of fields supported by Squid.
If current mask sizes cannot fit all the ids (you will get an assertion
if that happens), simply enlarge HttpHeaderMask type in `typedefs.h`.

## A Word on Efficiency

`httpHeaderHas()` is a very cheap (fast) operation implemented using a
bit mask lookup.

Adding new fields is somewhat expensive if they require complex
conversions to a string.

Deleting existing fields requires scan of all the entries and comparing
their "id"s (faster) or "names" (slower) with the one specified for
deletion.

Most of the operations are faster than their "ascii string" equivalents.
