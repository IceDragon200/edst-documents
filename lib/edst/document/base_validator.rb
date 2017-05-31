require_relative 'schemas'
require_relative 'edst_ext/ast'
require 'edst/ast'

module EDST
  module Document
    class BaseValidator
      # If the given stats is nil, then the err is raised, else its
      # added to the stats #errors
      #
      # @param [Stats, nil] stats
      # @param [Exception] err
      protected def handle_error(stats, err)
        if stats
          stats.errors << err
        else
          raise err
        end
      end

      # Ensures that the given node is an +EDST::AST+
      #
      # @param [Object] node
      protected def check_node(node)
        unless node.is_a?(EDST::AST)
          raise TypeError,
            "wrong argument type #{node.class} (expected #{EDST::AST})"
        end
      end

      # alias for validate
      def call(*args, &block)
        validate(*args, &block)
      end

      # Registers the validator as a Schema, since it only needs to respond
      # to #validate
      # @param [String] name
      # @param [BaseValidator] obj
      def self.register(name, obj)
        Schemas.register(name, obj)
      end
    end
  end
end
