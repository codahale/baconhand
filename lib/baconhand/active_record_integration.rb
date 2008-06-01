require "baconhand"

# TODO: make thread-safe when AR doesn't explode on its own when threaded
module ActiveRecord
  class Base
    class << self
      def find_by_sql_with_baconhand(sql)
        if Baconhand.enabled?
          
          # Jump through these hoops because I hate it when my stacktraces are
          # unfocused.
          begin
            raise Baconhand::GentleReminder, sql
          rescue Baconhand::GentleReminder => error
            error.send(:backtrace).reject! { |line| File.expand_path(line).starts_with?(__FILE__) }
            
            case Baconhand.reminder
            when :exception
              raise
            when :warning
              logger.warn error.message
              error.backtrace.first(10).each do |frame|
                logger.warn frame
              end
            end
          end
          
        end
        return find_by_sql_without_baconhand(sql)
      end
      alias_method_chain :find_by_sql, :baconhand
    end
  end
end