require_relative 'base_validator'
require_relative 'type_validator'

module EDST
  module Document
    class ListValidator < BaseValidator
      def initialize(child_validator)
        @child_validator = child_validator
      end

      def validate(node, stats = nil)
        check_node node

        node.each_child do |child|
          case child.kind
          when :comment
            next
          when :ln
            @child_validator.validate(child, stats)
          when :list
            validate(child, stats)
          else
            handle_error stats, ValidationError.new("expected #{node.debug_string} to be a :ln node")
          end
        end
      end

      def self.register(name, type)
        super name, new(type)
      end

      register 'list:string', Schemas.get('string')
    end
  end
end
