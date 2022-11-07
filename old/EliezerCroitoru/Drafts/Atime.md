Describe EliezerCroitoru/Drafts/Atime here.

In order to understand what “noatime” is good for first we need to
understand: What atime is? The basic knowledge needed to answer this
question is
[FileSystem](/FileSystem#)
internals.

The lower levels of any software relay on the fact that all the
information in the computer is stored in a format that can be recognized
by other software.

You can call it common data structure or in any other name.

For all that to work the
[FileSystem](/FileSystem#)
was designed with a specific way of accessing the data on different
storage devices.

The data is divided into logical containers as Files on a storage system
which is very similar to a bunch of paper files in an archive basement.

There is an archive manager that has a list of all the Files in the
basement and also a list of people that got access to the files archive
and if also fetch a copy of one file or more.

A simple
[FileSystem](/FileSystem#)
will allow the option to store a file in it while maybe also giving the
advanced options to store in the log the time that the file was created
or was last accessed.

In order to store a file as a data structure there is no need for the
creation time of the file or the last time it was modified or accessed.

But for many systems it is crucial to have all this data accessible for
security or administrative reasons.

For example when a file was created and was meant to lay there for 14
years while no one access the file and read it all this time if the last
access time it was accessed was 3 days ago and it was created 5 years
ago there is an option open that someone touched the file while not
knowing it was not permitted.

For a cache the last access time might not be needed.

Since the last access time or last modification time logging makes the
system to access the storage system couple more times then needed it can
be spared in many cases.

The general approach is to just use “noatime” option of the FS on a
linux based system.

The “noatime” helps to prevent the OS writing this Last Access Time of
the specific file.

It's the same has having a basement with someone sitting there while the
only times this nice guard or “archive keeper” adds the current time to
the file is on the creation of the file.

If it's a busy archive basement it can help a lot.

In a secured basement most of the owners would like to know if someone
touched any of the Files in it.

So using “noatime” will benefit while lowering the number of times that
the DISK will be accessed by the OS.

For 2-10 files it while not be that much but when we are talking about 1
Million files update at once we are talking about lots more updates per
sec which costs Disk bandwidth.

In general squid uses it's own way of looking at cached files while not
looking at the Modification time or Access time and there for the
“noatime” is a good choice for a partition which hosts a squid UFS
cache\_dir.

  - atime = access time

  - mtime = modification time

  - ctime = creation time
