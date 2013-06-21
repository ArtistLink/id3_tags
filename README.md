What is ID3 Tags
================


A ruby gem to read and write ID3 metadata from/to MP3/M4A files

[![Build Status](https://travis-ci.org/topspin/id3_tags.png)](https://travis-ci.org/topspin/id3_tags)

Why ID3 Tags was born
=====================

At [Topspin](http://topspinmedia.com) we provide [ArtistLink](http://artistlink.com), a platform for musician to upload and share their songs.
Artistlink provides a form to read and edit the songs' metadata and stores this information in the ID3 tags of a song.
For this task, we created the ID3 Tags gem

How to install
==============

Run `gem install id3_tags`.
Alternatively, you can include `id3_tags` in the Gemfile of your bundled project.

How to use from the command line (executable)
=============================================

Type `id3_tags` followed by the path of a local file.
This is will show the ID3 metadata of that file.

How to use from other programs
==============================

* To read metadata from a file, run `Id3Tags.read_from_file(file_path)`
* To write metadata to a file, run `Id3Tags.write_to_file(file_path, metadata)`

For more details about the format of the metadata, check the [specs](http://github.com/topspin/id3_tags/tree/master/spec/lib) or the [documentation at RubyDoc.info](http://rubydoc.info/github/topspin/id3_tags/frames).

How to contribute
=================

Make sure tests pass, then either submit a Pull Request.
Please consider testing against the [versions of Ruby supported](http://github.com/topspin/id3_tags/tree/master/.travis.yml) by ID3 Tags.

A list of [nice TODOs](http://github.com/topspin/id3_tags/tree/master/TODO.md) is provided.
You can also build a new version of the gem and move it to your gem repository.