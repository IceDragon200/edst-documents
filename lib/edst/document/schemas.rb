module EDST
  module Document
    # Container class for storing Schema defintions
    class Schemas
      def initialize
        @schemas = {}
      end

      # Registers the provided +schema+ object under name, which can be used
      # for :type defintiions.
      #
      # @param [String] name
      # @param [#validate] schema
      # @return [Object] schema object
      def register(name, schema)
        if @schemas.key?(name)
          warn "#{name} was already registered to #{@schemas[name]}"
        end
        @schemas[name] = schema
        schema
      end

      # Retrieves a schema by name
      #
      # @return [String] name
      def get(name)
        @schemas.fetch(name)
      end

      # Returns the main instance of the Schemas container
      #
      # @return [Schemas]
      def self.instance
        @instance ||= new
      end

      # (see #regiser)
      def self.register(name, obj)
        instance.register(name, obj)
      end

      # (see #get)
      def self.get(name)
        instance.get(name)
      end
    end
  end
end
