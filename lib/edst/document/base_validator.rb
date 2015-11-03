require 'edst/document/schemas'
require 'edst/document/edst_ext/ast'
require 'edst/ast'

module EDST
  module Document
    class BaseValidator
      def handle_error(stats, err)
        if stats
          stats.errors << err
        else
          raise err
        end
      end

      def check_node(node)
        unless node.is_a?(EDST::AST)
          raise TypeError,
            "wrong argument type #{node.class} (expected #{EDST::AST})"
        end
      end

      def call(*args, &block)
        validate(*args, &block)
      end

      def self.register(name, obj)
        Schemas.register(name, obj)
      end
    end
  end
end
