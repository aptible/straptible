require 'rails/generators'

module Straptible
  module Rails
    module Builders
      class Base < ::Rails::AppBuilder
        def readme
          template 'README.md.tt'
        end

        def rakefile
          template 'Rakefile.tt'
        end

        def vendor
          # No-op (don't create vendor/ directory)
        end

        def db
          empty_directory_with_keep_file 'db'
        end

        def leftovers
          rspec
        end

        def rspec
          create_file '.rspec', '--color --format documentation'
          copy_file 'spec/spec_helper.rb'
        end
      end
    end
  end
end
