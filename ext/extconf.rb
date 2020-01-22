# Check that Taglib >= 1.7.2 is installed. The easiest way to find the
# version of the installed TagLib (if present) is through `taglib-config`
require 'mkmf'

def error(msg)
  message msg + "\n"
  abort
end

taglib_bin = find_executable 'taglib-config'
taglib_version = `#{taglib_bin} --version`.chomp if taglib_bin

if taglib_bin.nil? ||
   Gem::Version.new(taglib_version) < Gem::Version.new('1.7.2')
  error <<-DESC

\e[31mYou must have TagLib >= 1.7.2 installed in order to use taglib-ruby.\e[0m

Please download and compile the source from http://taglib.github.io.
Alternatively, you can install TagLib on OS X by running:

  \e[35mbrew install taglib\e[0m

Or you can install TagLib on Ubuntu 12 or higher by running:

  \e[35msudo add-apt-repository -y ppa:kubuntu-ppa/backports\e[0m
  \e[35msudo apt-get update\e[0m
  \e[35msudo apt-get -y install libtag1-dev\e[0m

The add-apt-repository is required given that the default Ubuntu repositories
provide version 1.7.1 of TagLib, which does not fully support MP4 and M4A files
(see http://git.io/aureUA).

DESC
end

create_makefile('id3_tags')