require 'edst/ast'

module EDST
  class AST
    def ast_string
      "#{kind}:#{key}"
    end

    def debug_string
      "#{ast_string} line=#{line}"
    end
  end
end
