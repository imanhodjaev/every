defmodule EveryTest do
  @moduledoc false
  use ExUnit.Case
  doctest Every

  setup do
    {:ok, datetime: Timex.parse!("2018-10-14T16:48:12.000Z", "{ISO:Extended}")}
  end

  describe "::" do
    test "Every minute works as expected", %{datetime: datetime} do
      assert Every.minute(datetime) == 48_000
    end

    test "Every N minutes works as expected", %{datetime: datetime} do
      # Next time is expected to be at 16:50 because
      # 50 % 5 == 0 etc. for all examples.
      assert Every.minutes(5, datetime) == 108_000

      # Next time at 16:51
      assert Every.minutes(3, datetime) == 168_000

      # Next in 7m:48s
      assert Every.minutes(8, datetime) == 468_000

      # Every 10 minute will align to next to due
      # which divides without remainder thus it will
      # be 16:50 etc.
      assert Every.minutes(10, datetime) == 108_000

      # Next will be at 16:15
      assert Every.minutes(15, datetime) == 708_000
    end

    test "Every N minutes without relative time works as expected" do
      # Test should basicall check if the
      # value is between 0 minutes and 2 minutes
      assert Every.minutes(2) > 0
      assert Every.minutes(2) <= 120_000
    end

    test "Every hour works as expected", %{datetime: datetime} do
      # Next time at 17:00
      assert Every.hour(datetime) == 708_000
    end

    test "Every N hours works as expected", %{datetime: datetime} do
      # Next time at 18:00
      assert Every.hours(2, datetime) == 4308_000

      # Next time at 17:00
      assert Every.hours(1, datetime) == 708_000

      # Next time at 22:00 because of remaining time
      # is about ~4.21 hours.
      assert Every.hours(10, datetime) == 11_508_000

      # 1:12:48 til next time
      assert Every.hours(3, datetime) == 4_308_000
    end

    test "Every N hours without relative time works as expected" do
      # Test should basicall check if the
      # value is between 0 hours and 2 hours
      assert Every.hours(2) / 3_600_000 > 0
      assert Every.hours(2) / 3_600_000 <= 2
    end

    test "Every day works as expected", %{datetime: datetime} do
      # Time remaining 7h 25m 48s
      assert Every.day(datetime) == 25_908_000
    end
  end
end
