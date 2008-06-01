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
  def setup
    Baconhand.reminder = :exception
  end
  
  def test_should_have_a_baconhand_flag
    Baconhand.enable
    assert_equal(true, Baconhand.enabled?)
    Baconhand.disable
    assert_equal(false, Baconhand.enabled?)
  end
  
  def test_should_raise_gentle_reminder_when_baconhand_is_on
    Baconhand.enable
    begin
      ActiveRecord::Base.find_by_sql("SELECT 1 FROM dingo")
    rescue Baconhand::GentleReminder => error
      assert_match(/SELECT 1 FROM dingo/, error.message)
    end
  end
  
  def test_should_be_able_to_only_warn
    Baconhand.reminder = :warning
    begin
      ActiveRecord::Base.find_by_sql("SELECT 1 FROM dingo")
    rescue Baconhand::GentleReminder => error
      fail("Should not have been baconhanded")
    rescue
      # okay fine, there's no db so this is expected
    end
  end
  
  def teardown
    Baconhand.disable
  end
end