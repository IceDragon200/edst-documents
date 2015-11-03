require 'edst/document/schema_types'

module EDST
  module Document
    class Schema
      extend SchemaTypes

      def self.validate(node, givenstats = nil)
        stats = givenstats || Stats.new(self)
        schema_fields.each do |field|
          stats.children_stats.push field.validate(node)
        end
        stats
      end

      def self.register(name)
        Schemas.register(name, self)
      end
    end
  end
end
