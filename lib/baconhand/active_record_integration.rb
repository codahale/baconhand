require "baconhand"

# TODO: make thread-safe when AR doesn't explode on its own when threaded
module ActiveRecord
  class Base
    @@disable_database_access = false
    def self.disable_database_access
      return @@disable_database_access
    end
    
    def self.disable_database_access=(new_value)
      @@disable_database_access = new_value
    end
    
    class << self
      def find_by_sql_with_baconhand(sql)
        if disable_database_access
          
          # Jump through these hoops because I hate it when my stacktraces are
          # unfocused.
          begin
            raise Baconhand::GentleReminder, sql
          rescue Baconhand::GentleReminder => error
            error.send(:backtrace).reject! { |line| File.expand_path(line).starts_with?(__FILE__) }
            raise
          end
          
        end
        return find_by_sql_without_baconhand(sql)
      end
      alias_method_chain :find_by_sql, :baconhand
    end
    self.disable_database_access = false
  end
end