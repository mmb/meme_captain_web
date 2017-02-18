def fixture_file(name)
  Rails.root + 'spec/fixtures/files' + name
end

def fixture_file_data(name)
  File.open(fixture_file(name), 'rb', &:read)
end
