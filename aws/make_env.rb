#!/usr/bin/env ruby

require 'yaml'

env = YAML.load_file('env.yml')

if File.exist?('env_private.yml')
  private = YAML.load_file('env_private.yml')
else
  private = {}
end

env.merge!(private) { |key,oldval,newval| oldval.merge(newval) }

base = env.delete('base')

env.each do |name,data|
  filename = "env/#{name}.env"
  File.open(filename, 'w') do |f|
    base.merge(data).sort.each do |k,v|
      f.write("#{k.upcase}=#{v}\n")
    end
    puts "wrote #{filename}"
  end
end
