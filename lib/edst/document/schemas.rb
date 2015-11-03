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

      def self.register(name, obj)
        instance.register(name, obj)
      end

      def self.get(name)
        instance.get(name)
      end
    end
  end
end
