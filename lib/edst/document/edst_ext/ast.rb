require 'edst/ast'
require 'edst/document/node_helpers'

module EDST
  class AST
    include EDST::Document::NodeHelpers

    # Returns a String defining the AST
    #
    # @return [String]
    def ast_string
      "#{kind}:#{key}"
    end

    # Returns a String defining the AST and its debug line
    #
    # @return [String]
    def debug_string
      "#{ast_string} line=#{line}"
    end
  end
end
