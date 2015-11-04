require 'edst/document/ast_validator'
require 'edst/document/schema_validator'

module EDST
  module Document
    module SchemaTypes
      def schema_fields
        @schema_fields ||= []
      end

      private def patch_options(**options)
        {
          # allow the node to be optional
          optional: options.fetch(:optional, false),
          # allows a document to contain the same tag, or div multiple times
          allow_multiple: options.fetch(:multiple, false)
        }
      end

      # Defines a new Schema node, if a block is provided, then the contents
      # of the block are treated as children of the node.
      #
      # @param [Symbol] kind  kind of node, see EDST::AST for details
      # @param [String, Symbol] name   will be converted to a String
      # @param [Hash<Symbol, Object>] options
      # @option options [String] :type  default: '*'
      #   Type name, '*' means any type
      # @option options [Array<Object>] :enum  default: nil
      # @option options [Boolean] :optional  default: false
      #   Is this node optional?
      # @option options [Boolean] :allow_multiple  default: false
      #   Should the node allow mulitple definitions of the same key?
      #     EG.
      #       %%overlay
      #       %%overlay
      #
      # @option options [Boolean] :allow_variants  default: false
      #   Should this node allow variants of its key?
      #     EG.
      #       %note
      #       %note.description
      #       %note.motto
      #
      #       Are all considered variants of note
      def node(kind, name, **options, &block)
        data = patch_options(options).merge(
          enum: options[:enum],
          # '*' means any type
          type: options.fetch(:type, '*'),
          key: name.to_s,
          # variants are tags, or div names, which take the form:
          #   key.class
          allow_variants: options.fetch(:variant, false)
        )

        if block_given?
          data[:children] = SchemaBuilder.new(&block).schema_fields
        end

        schema_fields << AstValidator.new(kind, data)
      end

      # Defines a div node, see {#node} for details on +options+
      #
      # @param [Symbol, String] name
      # @param [Hash<Symbol, Object>] options
      def div(name, **options, &block)
        node(:div, name, options, &block)
      end

      # Defines a new tag node, see {#node} for details on +options+
      #
      # @param [Symbol, String] name
      def tag(name, **options)
        node(:tag, name, options)
      end

      def schema(name, **options)
        schema_fields << SchemaValidator.new(name, patch_options(options))
      end
    end
  end
end
