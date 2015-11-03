module EDST
  module Document
    class Stats
      attr_accessor :known_children
      attr_accessor :found_first
      attr_accessor :errors
      attr_accessor :children_stats

      def initialize(parent)
        @parent = parent
        @known_children = []
        @found_first = false
        @errors = []
        @children_stats = []
      end

      private def indent_str(level, str)
        ("  " * level) + str.to_s
      end

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

      def display_errors(indent = 0)
        make_errors(indent).each do |line|
          puts line
        end
      end
    end
  end
end
