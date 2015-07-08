require_relative 'base'

module Straptible
  module Rails
    module Builders
      class Api < Base
        def gemfile
          copy_file 'Gemfile.api', 'Gemfile'
        end

        def database_yml
          # No-op (handled by :config step)
        end

        def config
          directory 'config.api', 'config'
        end

        def lib
          directory 'lib.api', 'lib'
        end

        def public_directory
          directory 'public.api', 'public'
        end

        def leftovers
          travis_yml
          package_json
          restructure_app
          super
        end

        def travis_yml
          copy_file 'travis.yml.api', '.travis.yml'
        end

        def package_json
          copy_file 'package.json'
        end

        def restructure_app
          remove_dir 'app/assets'
          remove_dir 'app/controllers/concerns'
          remove_dir 'app/helpers'
          remove_dir 'app/mailers'
          remove_dir 'app/models/concerns'
          remove_dir 'app/views/layouts'

          empty_directory 'app/decorators'
        end
      end
    end
  end
end
