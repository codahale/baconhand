require "rubygems"
require "active_support"
require "action_pack"
require "action_controller"
require "action_view"
require "active_record"
require "test/unit"
require "baconhand"
require "baconhand/active_record_integration"
require "baconhand/action_view_integration"

class BaconhandTest < Test::Unit::TestCase
  def test_should_have_an_error_class
    error = Baconhand::GentleReminder.new("blah")
    assert_match(/blah/, error.message)
    assert_kind_of(StandardError, error)
  end
end

class ActiveRecordIntegrationTest < Test::Unit::TestCase
  def test_should_have_a_baconhand_flag
    ActiveRecord::Base.disable_database_access = true
    assert_equal(true, ActiveRecord::Base.disable_database_access)
    ActiveRecord::Base.disable_database_access = false
    assert_equal(false, ActiveRecord::Base.disable_database_access)
  ensure
    ActiveRecord::Base.disable_database_access = false
  end
  
  def test_should_raise_gentle_reminder_when_baconhand_is_on
    ActiveRecord::Base.disable_database_access = true
    begin
      ActiveRecord::Base.find_by_sql("SELECT 1 FROM dingo")
    rescue Baconhand::GentleReminder => error
      assert_match(/SELECT 1 FROM dingo/, error.message)
    end
  ensure
    ActiveRecord::Base.disable_database_access = false
  end
end