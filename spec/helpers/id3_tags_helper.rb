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
  File.join File.dirname(__FILE__), '..', 'assets', filename
end