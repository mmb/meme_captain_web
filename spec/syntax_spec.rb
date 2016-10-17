require 'rails_helper'

describe 'json files' do
  `git ls-files *.json`.each_line do |json_file|
    json_file.chomp!
    describe(json_file) do
      it 'is valid json' do
        File.open(json_file) do |f|
          JSON.parse(f.read)
        end
      end
    end
  end
end

describe 'yaml files' do
  `git ls-files *.yml`.each_line do |yaml_file|
    yaml_file.chomp!
    describe(yaml_file) do
      it 'is valid yaml' do
        YAML.load_file(yaml_file)
      end
    end
  end
end
