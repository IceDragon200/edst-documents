require 'edst/document/schema_field'

module EDST
  module Document
    module SchemaTypes
      def schema_fields
        @schema_fields ||= []
      end

      def node(kind, name, **options, &block)
        data = {
          # '*' means any type
          type: options.fetch(:type, '*'),
          key: name,
          enum: options[:enum],
          # allow the node to be optional
          optional: options.fetch(:optional, false),
          # allows a document to contain the same tag, or div multiple times
          allow_multiple: options.fetch(:multiple, false),
          # variants are tags, or div names, which take the form:
          #   key.class
          allow_variants: options.fetch(:variant, false),
        }

        if block_given?
          data[:children] = SchemaBuilder.new(&block).schema_fields
        end

        schema_fields << SchemaField.new(kind, data)
      end

      def div(name, **options, &block)
        node(:div, name, options, &block)
      end

      def tag(name, **options)
        node(:tag, name, options)
      end
    end
  end
end
