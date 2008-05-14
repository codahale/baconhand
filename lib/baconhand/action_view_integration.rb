require "baconhand"

module ActionView
  class Base
    # TODO: this is Rails 2.1-specific. (Well, 2.0.991.) Make it not so.
    def execute_with_baconhand(template)
      ActiveRecord::Base.disable_database_access = true
      execute_without_baconhand(template)
    ensure
      ActiveRecord::Base.disable_database_access = false
    end
    alias_method_chain :execute, :baconhand
  end
end