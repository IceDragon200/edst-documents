require_relative 'schema_types'
require_relative 'schema_builder'

module EDST
  module Document
    class Schema
      include SchemaTypes

      # Initializes a new Schema, if a block is given, it will be evaluated
      # in the Schema instance
      def initialize(&block)
        instance_exec(&block) if block_given?
      end

      # Validates the given AST node against the Schema
      #
      # @param [EDST::AST] node
      # @param [Stats] givenstats
      # @return [Stats]
      def validate(node, givenstats = nil)
        stats = givenstats || Stats.new(self)
        schema_fields.each do |field|
          stats.children_stats.push field.validate(node)
        end
        stats
      end

      # Register the schema under the given +name+
      #
      # @param [String] name
      def register(name)
        Schemas.register(name, self)
      end

      # Reads the file and evals its contents in the Schema
      #
      # @param [String] filename
      # @return [self]
      def load_file(filename)
        instance_eval File.read(filename), filename, 1
        self
      end

      # @param [EDST::AST] node
      # @return [Boolean]
      def is_valid_node?(node)
        schema_fields.any? { |field| field.is_valid_node?(node) }
      end

      # @param [String] filename
      # @return [Schema] a new instance
      def self.load_file(filename)
        new.load_file(filename)
      end
    end
  end
end
