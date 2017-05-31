require_relative 'schema_types'

module EDST
  module Document
    class SchemaBuilder
      include SchemaTypes

      def initialize(&block)
        instance_exec(&block)
      end
    end
  end
end
