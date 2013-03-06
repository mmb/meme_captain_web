desc 'Monkey patch to fix sprockets issue with fabric.js.'
# See https://github.com/sstephenson/sprockets/issues/416
task :monkey_patch_sprockets do
  module Sprockets

    class Context

      def resolve(path, options = {}, &block)
        pathname = Pathname.new(path)
        attributes = environment.attributes_for(pathname)

        if pathname.absolute?
          pathname

        elsif content_type = options[:content_type]
          content_type = self.content_type if content_type == :self

          #if attributes.format_extension
          #  if content_type != attributes.content_type
          #    raise ContentTypeMismatch, "#{path} is " +
          #        "'#{attributes.content_type}', not '#{content_type}'"
          #  end
          #end

          resolve(path) do |candidate|
            #if self.content_type == environment.content_type_of(candidate)
            return candidate
            #end
          end

          raise FileNotFound, "couldn't find file '#{path}'"
        else
          environment.resolve(path, :base_path => self.pathname.dirname, &block)
        end
      end

    end

  end
end

task :'jasmine:headless' => :monkey_patch_sprockets

task :spec => :'jasmine:headless'
