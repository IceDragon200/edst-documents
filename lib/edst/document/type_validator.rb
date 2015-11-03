require 'edst/document/base_validator'
require 'edst/document/validation_error'

module EDST
  module Document
    class TypeValidator < BaseValidator
      def initialize(type)
        @type = type
      end

      def validate(node, stats = nil)
        check_node node
        unless node.value.is_a?(@type)
          handle_error stats, ValidationError.new("expected #{node.debug_string} value to be a #{@type}")
        end
      end

      register 'string', new(String)
    end
  end
end
