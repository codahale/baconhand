module Baconhand
  class <<self
    def reminder
      @reminder ||= :exception
    end
    
    def reminder=(reminder)
      @reminder = reminder
    end
    
    def wrap(klass, method)
      return unless klass.instance_methods.include?(method.to_s)
      
      klass.class_eval <<-end_eval
        def #{method}_with_baconhand(*args, &block)
          Baconhand { self.#{method}_without_baconhand(*args, &block) }
        end
        
        alias_method_chain :#{method}, :baconhand
      end_eval
    end
    
    def enable
      @enabled = true
    end
    
    def enabled?
      @enabled
    end
    
    def disable
      @enabled = false
    end
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

def Baconhand
  already_enabled = Baconhand.enabled?
  begin
    Baconhand.enable
    yield
  ensure
    Baconhand.disable unless already_enabled
  end
end