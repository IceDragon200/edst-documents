require 'edst/document/base_validator'
require 'edst/document/type_validator'

module EDST
  class Document
    class ListValidator < BaseValidator
      def initialize(child_validator)
        @child_validator = child_validator
      end

      def validate(node, stats)
        node.each_child do |child|
          next if child.kind == :comment
          if child.kind != :ln
            handle_error stats, ValidationError.new("expected #{node.debug_string} to be a :ln node")
          end
          @child_validator.validate(child, stats)
        end
      end

      Schemas.instance.register('list:string', new(Schemas.instance.get('string')))
    end
  end
end
