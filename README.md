What is ID3 Tags
================

A ruby gem to read and write ID3 metadata from/to MP3/M4A files

[![Build Status](https://travis-ci.org/topspin/id3_tags.png)](https://travis-ci.org/topspin/id3_tags)

Why ID3 Tags was born
=====================

At [Topspin](http://topspinmedia.com) we provide [ArtistLink](http://artistlink.com), a platform for musician to upload and share their songs.
Artistlink provides a form to read and edit the songs' metadata and stores this information in the ID3 tags of a song.
For this task, we created the ID3 Tags gem

Requirements
============

ID3 Tags depends on the [TagLib library](http://taglib.github.io).
If you don't have TagLib installed, ID3 Tags will ask to install it.

Installing TagLib on OS X
-------------------------

The easiest way is using [homebrew](http://mxcl.github.io/homebrew). Just type:

    brew install taglib

Installing TagLib on Ubuntu
---------------------------

The easiest way is using [apt-get](http://linux.die.net/man/8/apt-get).

**Unfortunately, the official Ubuntu repositories point to an old version of TagLib**.

Therefore, an extra step is required. The full command is:

    sudo add-apt-repository ppa:kubuntu-ppa/backports
    sudo apt-get update
    sudo apt-get install libtag1-dev

If you don't update the repository, you will possibly get TagLib 1.7.1 installed,
which [does not fully support MP4 and M4A files](http://git.io/aureUA).

How to use from the command line
================================

Install by running `gem install id3_tags`.

Type `id3_tags` followed by the path of a local file.
This is will show the ID3 metadata of that file.

How to use from other programs
==============================

* Include `id3_tags` in the Gemfile of your bundled project and `bundle install`
* To read metadata from a file, run `Id3Tags.read_from_file(file_path)`
* To write metadata to a file, run `Id3Tags.write_to_file(file_path, metadata)`

For more details about the format of the metadata, check the [specs](http://github.com/topspin/id3_tags/tree/master/spec/lib) or the [documentation at RubyDoc.info](http://rubydoc.info/github/topspin/id3_tags/frames).


How to contribute
=================

Make sure tests pass, then either submit a Pull Request.
Please consider testing against the [versions of Ruby supported](https://travis-ci.org/topspin/id3_tags) by ID3 Tags.

A list of [nice TODOs](http://github.com/topspin/id3_tags/tree/master/TODO.md) is provided.
You can also build a new version of the gem and move it to your gem repository.