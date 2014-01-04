require_relative 'base'
require_relative '../builders/api'

module Straptible
  module Rails
    module Generators
      class Api < Base
        protected

        # rubocop:disable AccessorMethodName
        def get_builder_class
          Straptible::Rails::Builders::Api
        end
        # rubocop:enable AccessorMethodName
      end
    end
  end
end
