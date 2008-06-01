module Baconhand
  def self.wrap(klass, method)
    return unless klass.instance_methods.include?(method.to_s)
    
    RAILS_DEFAULT_LOGGER.debug "baconhanding #{klass}##{method}"
    
    klass.class_eval <<-end_eval
      def #{method}_with_baconhand(*args, &block)
        already_disabling = ActiveRecord::Base.disable_database_access
        ActiveRecord::Base.disable_database_access = true unless already_disabling
        self.#{method}_without_baconhand(*args, &block)
      ensure
        ActiveRecord::Base.disable_database_access = false unless already_disabling
      end
      
      alias_method_chain :#{method}, :baconhand
    end_eval
  end
  
  class GentleReminder < StandardError
    def initialize(sql)
      super(format_message(sql))
    end
    
  private
    
    def format_message(sql)
      indented_sql = sql.split("\n").map { |s| ">  #{s}" }.join("\n")
      return [
        "**** BACONHAND! ****",
        "You tried for this:\n\n#{indented_sql}\n",
        "But all you got was baconhand. But we have faith in you. Persevere."
      ].join("\n")
    end
    
  end
end