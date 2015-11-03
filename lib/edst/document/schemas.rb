module EDST
  module Document
    class Schemas
      def initialize
        @schemas = {}
      end

      def register(name, schema)
        @schemas[name] = schema
      end

      def get(name)
        @schemas.fetch(name)
      end

      def self.instance
        @instance ||= new
      end
    end
  end
end
