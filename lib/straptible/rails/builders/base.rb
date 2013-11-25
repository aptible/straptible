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
          icons
        end

        def rspec
          create_file '.rspec', '--color --format documentation'
          copy_file 'spec_helper.rb', 'spec/spec_helper.rb'
        end

        def icons
          remove_file 'public/favicon.ico'
          copy_file 'favicon.ico', 'public/favicon.ico'
          copy_file 'icon-72.png', 'public/icon-72.png'
        end
      end
    end
  end
end
