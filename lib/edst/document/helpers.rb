require 'edst/ast'

module EDST
  module Document
    # Creates a :list node, from the given strings
    #
    # @param [Array<String>] args
    # @return [AST]
    def self.new_list(*args)
      root = AST.new(:list)
      args.each do |obj|
        root.add_child AST.new(:ln, value: obj)
      end
      root
    end
  end
end
