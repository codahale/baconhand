module Baconhand
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