if RAILS_ENV == "development" || RAILS_ENV == "test"
  require "baconhand"
  require "baconhand/active_record_integration"
  require "baconhand/action_view_integration"
end