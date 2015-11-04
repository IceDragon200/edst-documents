module EDST
  module Document
    # Validations stats, holds information about a validation
    class Stats
      attr_accessor :known_children
      attr_accessor :found_first
      attr_accessor :errors
      attr_accessor :children_stats

      # @param [Object] parent  - a schema, validator, anything
      def initialize(parent)
        @parent = parent
        @known_children = []
        @found_first = false
        @errors = []
        @children_stats = []
      end

      # Indents a given +str+ by +level+
      #
      # @param [Integer] level  how deep the indentation should be
      # @param [String] str  string to append
      # @return [String]
      private def indent_str(level, str)
        ("  " * level) + str.to_s
      end

      # Creates and populates an array with errors, sub errors will be
      # indented and concatenated to the parent array.
      #
      # @param [Integer] indent  indentation level for error strings
      # @return [Array<String>] errors
      def make_errors(indent = 0)
        result = []

        unless errors.empty?
          errors.each do |error|
            result << indent_str(indent, error)
          end
        end

        children_stats.each do |stat|
          result.concat(stat.make_errors(indent + 1))
        end

        unless result.empty?
          result.unshift indent_str(indent, "Errors: field=#{@parent}")
        end

        result
      end

      # Displays all errors in this Stats, and its children
      #
      # @param [Integer] indent  indentation level for error strings
      def display_errors(indent = 0)
        make_errors(indent).each do |line|
          puts line
        end
      end
    end
  end
end
