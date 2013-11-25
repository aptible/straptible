require_relative 'base'
require_relative '../builders/api'

module Straptible
  module Rails
    module Generators
      class Api < Base
        protected

        def get_builder_class
          Straptible::Rails::Builders::Api
        end
      end
    end
  end
end
