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

        def public_directory
          directory 'public.api', 'public'
        end

        def leftovers
          restructure_app
          super
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
