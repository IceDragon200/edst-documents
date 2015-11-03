require 'edst/document/core_ext'
require 'edst/document/validation_error'
require 'edst/document/stats'

module EDST
  module Document
    class SchemaField
      attr_reader :kind
      attr_reader :data
      attr_reader :type
      attr_reader :key
      attr_reader :allow_multiple
      attr_reader :allow_variants

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

      def to_s
        "#{kind}:#{key} : #{type}"
      end

      def create_error(stats, err)
        stats.errors << err
      end

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
              create_error stats, ValidationError.new("Multiple nodes of (#{child.ast_string}) are not allowed (offender: #{node.debug_string})")
            end
          end

          unless @allow_variants
            # we are guaranteed that the provided node will be a variant of the given
            # but if variants are not allowed, and the keys do not match, then that is considered an
            # error
            if @key != child.key
              create_error stats, ValidationError.new("Variant nodes of (#{child.ast_string}) are not allowed (offender: #{node.debug_string})")
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
        unless @enum.any? { |v| node.value == v }
          create_error stats, ValidationError.new("Node #{node.debug_string} must have a value of [#{@enum.choice_join}]")
        end
      end

      def validate(root, givenstats = nil)
        stats = givenstats || Stats.new(self)
        root.each_child do |node|
          next unless node.kind == @kind
          next unless node.key =~ @key_pattern

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
          create_error stats, ValidationError.new("No node of kind=#{@kind} and key=#{@key} found")
        end
        stats
      end
    end
  end
end
