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
    end
  end
end
