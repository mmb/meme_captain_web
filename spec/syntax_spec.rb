require 'rails_helper'

describe 'json files' do
  Dir.glob("#{Rails.root}/**/*.json") do |json_file|
    relative_path = Pathname.new(json_file).relative_path_from(Rails.root)
    describe(relative_path) do
      it 'is valid json' do
        File.open(json_file) do |f|
          JSON.parse(f.read)
        end
      end
    end
  end
end

describe 'yaml files' do
  Dir.glob("#{Rails.root}/**/*.yml") do |yaml_file|
    relative_path = Pathname.new(yaml_file).relative_path_from(Rails.root)
    describe(relative_path) do
      it 'is valid yaml' do
        YAML.load_file(yaml_file)
      end
    end
  end
end
