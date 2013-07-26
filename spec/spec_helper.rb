# Calculate code coverage
require 'coveralls'
Coveralls.wear!

# Provide helper functions
require 'tmpdir'

def with_duplicate_file_of(original)
  duplicate = File.join Dir.tmpdir, File.basename(original)
  begin
    FileUtils.cp original, duplicate
    yield(duplicate)
  ensure
    FileUtils.rm duplicate
  end
end

def asset_file(filename)
  File.join File.dirname(__FILE__), 'assets', filename
end

def read_and_write_tags_for(original)
  with_duplicate_file_of original do |duplicate|
    Id3Tags.write_tags_to duplicate, Id3Tags.read_tags_from(original)
    yield(duplicate)
  end
end