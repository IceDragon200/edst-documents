require 'edst/document/base_validator'

module EDST
  module Document
    # This validator operates on schemas instead of nodes
    class SchemaValidator < BaseValidator
      # @param [String] name  name of schema to validate with
      # @param [Hash<Symbol, Object>] options
      def initialize(name, **options)
        @name = name
        @data = options
        @optional = @data.fetch(:optional)
        @allow_multiple = @data.fetch(:allow_multiple)
      end

      # Can this validator handle the given node?
      #
      # @return [Boolean]
      def is_valid_node?(node)
        # SchemaFieldValidators can never determine if they can handle
        # a node, since they use a sub validator for work.
        true
      end

      # @param [EDST::AST] node
      # @param [Stats] givenstats
      # @return [Stats]
      def validate(root, givenstats = nil)
        check_node root

        stats = givenstats || Stats.new(self)
        val = Schemas.get(@name)
        root.each_child do |node|
          if val.is_valid_node?(node)
            val.validate(node)
            stats.known_children << node
            stats.found_first |= true
          end
        end
        unless @optional || stats.found_first
          handle_error stats, ValidationError.new("No node matching validator #{val} was found")
        end
        stats
      end
    end
  end
end
