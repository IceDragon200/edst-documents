require 'edst'
require 'edst/ast'
require 'edst/document/schemas'
require 'edst/document/list_validator'

module EDST
  module Document
    # Loads and parses filename as an EDST file
    #
    # @param [String] filename
    # @return [AST]
    def self.load_file(filename)
      EDST.parse(File.read(filename))
    end

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

    # Creates a new Schema
    #
    # @param [String, nil] name
    # @return [Schema] a schema instance
    def self.new_schema(name = nil, &block)
      schema = Schema.new(&block)
      schema.register(name) if name != nil
      schema
    end

    # Creates and registers a schema from the given filename
    # The schema file can register itself, or a name can be given
    #
    # @param [String] filename  - file to load
    # @param [String, nil] name  - name to register schema as
    # @return [Schema] a schema instance
    def self.new_schema_from_file(filename, name = nil)
      new_schema(name) do
        load_file(filename)
      end
    end

    # Validates the given +node+ using a validator named +name+
    #
    # @param [EDST::AST] node  node to validate
    # @param [String] name  name of validator
    # @return [Stats]
    def self.validate(node, name)
      Schemas.get(name).validate(node)
    end

    # Registers a List validator for the given name
    # The list will be called list:<name> where <name> is the +name+ you
    # provided
    #
    # @param [String] name
    def self.register_list(name)
      ListValidator.register("list:#{name}", Schemas.get(name))
    end
  end
end
