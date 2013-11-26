require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

require_relative '../builders/base'

module Straptible
  module Rails
    module Generators
      class Base < ::Rails::Generators::AppGenerator
        # Override default Rails generator options
        # REVIEW: Is there a less monkey-patchy way to do this?
        class_option :database,         type: :string,
                                        aliases: '-d',
                                        default: 'postgresql'

        class_option :skip_test_unit,   type: :boolean,
                                        aliases: '-T',
                                        default: true

        class_option :skip_javascript,  type: :boolean,
                                        aliases: '-J',
                                        default: true

        def self.start
          tmpl_path = File.join('..', 'templates')
          tmpl_root = File.expand_path(tmpl_path, File.dirname(__FILE__))
          source_root tmpl_root
          source_paths << tmpl_root
          source_paths << ::Rails::Generators::AppGenerator.source_root

          super
        end

        def git_init
          git init:   '.',
              add:    '.',
              commit: "-m 'Initial commit (Straptible #{Straptible::VERSION})'"
        end

        protected

        def get_builder_class
          Straptible::Rails::Builders::Base
        end
      end
    end
  end
end
