# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'id3_tags/version'

Gem::Specification.new do |spec|
  spec.name          = "id3_tags"
  spec.version       = Id3Tags::VERSION
  spec.authors       = ["Claudio Baccigalupo"]
  spec.email         = ["claudio@topspinmedia.com"]
  spec.description   = %q{Read and write ID3 metadata from/to MP3 files}
  spec.summary       = %q{Id3Tags provides two methods:
    * read_tags_from, which reads an MP3 file and returns a Hash of metadata
    * write_tags_to, which writes a Hash of metadata into an MP3 file}
  spec.homepage      = 'https://github.com/topspin/id3_tags'
  spec.license       = 'MIT'

  spec.files         = Dir['{bin,lib}/**/*'] + ['MIT-LICENSE', 'README.md']

  spec.requirements  = ['taglib >= 1.7.2 (libtag1-dev in Debian/Ubuntu, taglib-devel in Fedora/RHEL)']
  spec.extensions    = ['ext/extconf.rb']

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9.0'

  spec.add_dependency 'taglib-ruby'
  spec.add_dependency 'activesupport', ('~> 3.0' if RUBY_VERSION < '1.9.3')
  spec.add_dependency 'mimemagic'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'coveralls'
end
