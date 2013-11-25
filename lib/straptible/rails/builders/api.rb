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

        def leftovers
          restructure_app
          remove_error_pages
          super
        end

        def restructure_app
          remove_dir 'app/assets'
          remove_dir 'app/controllers/concerns'
          remove_dir 'app/helpers'
          remove_dir 'app/mailers'
          remove_dir 'app/views/layouts'
          empty_directory 'app/decorators'
        end

        def remove_error_pages
          remove_file 'public/404.html'
          remove_file 'public/422.html'
          remove_file 'public/500.html'
        end
      end
    end
  end
end
