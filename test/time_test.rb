require 'helper'

# TODO: Move this an the implementation to Vault::Tools
class TimeTest < Vault::TestCase
  def test_next_month
    # works on simple case
    assert_equal(Time.utc(2000,2),
                 Time.utc(2000,1).next_month)
    # preserves day
    assert_equal(Time.utc(2000,2,5),
                 Time.utc(2000,1,5).next_month)
    # year boundary
    assert_equal(Time.utc(2011,1),
                 Time.utc(2010,12).next_month)
  end

  def test_last_month
    # works on simple case
    assert_equal(Time.utc(2000,1),
                 Time.utc(2000,2).last_month)
    # preserves day
    assert_equal(Time.utc(2000,1,5),
                 Time.utc(2000,2,5).last_month)
    # year boundary
    assert_equal(Time.utc(2010,12),
                 Time.utc(2011,1).last_month)
  end

  def test_month_chaining
    start = Time.utc(2000)
    assert_equal(start, start.next_month.last_month)
    assert_equal(start, start.last_month.next_month)
    assert_equal(start,
                 Time.utc(2000,3).last_month.last_month)
    assert_equal(start,
                 Time.utc(1999,11).next_month.next_month)

  end

  def test_tomorrow
    # works on simple case
    assert_equal(Time.utc(2000,1,2),
                 Time.utc(2000,1,1).tomorrow)
    # preserves hour
    assert_equal(Time.utc(2000,1,6,11),
                 Time.utc(2000,1,5,11).tomorrow)
    # month/year boundary
    assert_equal(Time.utc(2011,1),
                 Time.utc(2010,12,31).tomorrow)
  end

  def test_yesterday
    # works on simple case
    assert_equal(Time.utc(2000,1,2),
                 Time.utc(2000,1,1).tomorrow)
    # preserves hour
    assert_equal(Time.utc(2000,1,6,11),
                 Time.utc(2000,1,5,11).tomorrow)
    # month boundary
    assert_equal(Time.utc(2011,1),
                 Time.utc(2010,12,31).tomorrow)
  end

  def test_yesterday_tomorrow_chaining
    start = Time.utc(2000)
    assert_equal(start, start.tomorrow.yesterday)
    assert_equal(start, start.yesterday.tomorrow)
    assert_equal(start, Time.utc(1999,12,30).tomorrow.tomorrow)
    assert_equal(start, Time.utc(2000,1,3).yesterday.yesterday)
  end

  def test_macbeth
    assert_equal(Time.utc(2000,1,4),
                 Time.utc(2000,1,1).tomorrow.tomorrow.tomorrow)
  end

  def test_days
    assert_equal(24*60*60,1.days)
    assert_equal(24*60*60,1.day)
    assert_equal(Time.utc(2000,1,1) + 1.days,
                 Time.utc(2000,1,1).tomorrow)
    assert_equal(Time.utc(2000,1,1) + 1.day,
                 Time.utc(2000,1,1).tomorrow)
  end

  def test_weeks
    assert_equal(7*24*60*60*2,2.weeks)
    assert_equal(7*24*60*60,1.week)
    assert_equal(Time.utc(2000,1,8),
                 Time.utc(2000,1,1) + 1.week)
    assert_equal(Time.utc(2000,1,15),
                 Time.utc(2000,1,1) + 2.weeks)
  end

end
