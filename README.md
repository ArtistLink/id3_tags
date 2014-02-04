What is ID3 Tags
================

A ruby gem to read and write ID3 metadata from/to MP3/M4A files

[![Build Status](https://travis-ci.org/topspin/id3_tags.png)](https://travis-ci.org/topspin/id3_tags)
[![Code Climate](https://codeclimate.com/github/topspin/id3_tags.png)](https://codeclimate.com/github/topspin/id3_tags)
[![Coverage Status](https://coveralls.io/repos/topspin/id3_tags/badge.png)](https://coveralls.io/r/topspin/id3_tags)
[![Dependency Status](https://gemnasium.com/topspin/id3_tags.png)](https://gemnasium.com/topspin/id3_tags)

Why ID3 Tags was born
=====================

At [Topspin](http://topspinmedia.com) we provide [ArtistLink](http://artistlink.com), a platform for musician to upload and share their songs.
Artistlink provides a form to read and edit the songs' metadata and stores this information in the ID3 tags of a song.
For this task, we created the ID3 Tags gem

Requirements
============

ID3 Tags depends on the [TagLib library](http://taglib.github.io).
If you don't have TagLib >= 1.7.2 installed, ID3 Tags will ask to install it.

How to use from the command line
================================

Install by running `gem install id3_tags`.

Type `id3_tags` followed by the path of a local file.
This is will show the ID3 metadata of that file.

How to use from other programs
==============================

* Include `id3_tags` in the Gemfile of your bundled project and `bundle install`
* To read metadata from a file, run `Id3Tags.read_tags_from(file_path)`
* To write metadata to a file, run `Id3Tags.write_tags_to(file_path, metadata)`

Here is a small example:

```
#!/usr/bin/env ruby
require 'id3_tags'

file_path = "/tmp/song.mp3"
image_path = "/tmp/cover.jpg"

tags = Id3Tags.read_tags_from(file_path)
tags[:artist] = "ACDC"
tags[:title] = "Hells Bells"
tags[:track][:number] = 1
tags[:track][:count] = 10
tags[:album] = "Back in Black"
tags[:cover_art][:mime_type] = "image/jpeg"
tags[:cover_art][:data] = File.read(image_path)

Id3Tags.write_tags_to(file_path, tags)
```

For more details about the format of the metadata, check the [specs](http://github.com/topspin/id3_tags/tree/master/spec/lib) or the [documentation at RubyDoc.info](http://rubydoc.info/github/topspin/id3_tags/frames).


How to contribute
=================

Make sure tests pass, then either submit a Pull Request.
Please consider testing against the [versions of Ruby supported](https://travis-ci.org/topspin/id3_tags) by ID3 Tags.

A list of [nice TODOs](http://github.com/topspin/id3_tags/tree/master/TODO.md) is provided.
You can also build a new version of the gem and move it to your gem repository.
