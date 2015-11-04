require 'edst/document/core_ext'
require 'edst/document/validation_error'
require 'edst/document/stats'
require 'edst/document/base_validator'

module EDST
  module Document
    class AstValidator < BaseValidator
      attr_reader :kind
      attr_reader :data
      attr_reader :type
      attr_reader :key
      attr_reader :allow_multiple
      attr_reader :allow_variants

      # @param [Symbol] kind
      def initialize(kind, **options)
        @kind = kind
        @data = options
        @type = @data.fetch(:type)
        @key = @data.fetch(:key)
        @optional = @data.fetch(:optional)
        @allow_multiple = @data.fetch(:allow_multiple)
        @allow_variants = @data.fetch(:allow_variants)
        @enum = @data.fetch(:enum)
        @key_pattern = /\A#{@key}\b/
      end

      # @return [String]
      def to_s
        "#{kind}:#{key} : #{type}"
      end

      # @yieldparam [BaseValidator] field
      # @return [Enumerator] if no block was given
      def each_child
        return to_enum :each_child unless block_given?

        if children = @data[:children]
          children.each { |child| yield child }
        end
      end

      private def check_variant_or_multiple(stats, node)
        if stats.found_first
          unless @allow_multiple
            if @key == node.key
              handle_error stats, ValidationError.new("Multiple nodes of (#{child.ast_string}) are not allowed (offender: #{node.debug_string})")
            end
          end

          unless @allow_variants
            # we are guaranteed that the provided node will be a variant of the given
            # but if variants are not allowed, and the keys do not match, then that is considered an
            # error
            if @key != child.key
              handle_error stats, ValidationError.new("Variant nodes of (#{child.ast_string}) are not allowed (offender: #{node.debug_string})")
            end
          end
        end
      end

      private def check_node_type(stats, node)
        if @type != '*'
          validator = Schemas.instance.get(@type)
          validator.validate(node, stats)
        end
      end

      private def check_node_enum(stats, node)
        return unless @enum
        unless @enum.include?(node.value)
          handle_error stats, ValidationError.new("Node #{node.debug_string} must have a value of [#{@enum.choice_join}]")
        end
      end

      # Determines if the node can be validated by this SchemaField
      #
      # @param [EDST::AST] node
      # @return [Boolean] the node is valid
      def is_valid_node?(node)
        return false unless node.kind == @kind
        return false unless node.key =~ @key_pattern
        true
      end

      # Validates the given root node against the schema field
      #
      # @param [EDST::AST] root
      # @param [Stats] givenstats
      # @return [Stats]
      def validate(root, givenstats = nil)
        check_node root

        stats = givenstats || Stats.new(self)
        root.each_child do |node|
          next unless is_valid_node?(node)

          check_variant_or_multiple(stats, node)
          check_node_type(stats, node)
          check_node_enum(stats, node)

          stats.found_first |= true
          stats.known_children << node

          each_child do |sub_schema|
            stats.children_stats << sub_schema.validate(node)
          end
        end
        unless @optional || stats.found_first
          handle_error stats, ValidationError.new("No node of kind=#{@kind} and key=#{@key} found")
        end
        stats
      end
    end
  end
end
