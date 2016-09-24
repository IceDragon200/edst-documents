module EDST
  module Document
    module NodeHelpers
      # Determines if the node is a comment
      #
      # @return [Boolean] true if it is a comment, false otherwise
      def is_comment?
        kind == :comment
      end
    end
  end
end
