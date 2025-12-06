defmodule PlantIdDiscordBotTest.Utils.Duration do
  use ExUnit.Case, async: true

  alias PlantIdDiscordBot.Utils.Duration

  doctest Duration

  describe "sec_to_str/1" do
    test "seconds" do
      assert Duration.sec_to_str(5) == "5s"
      refute Duration.sec_to_str(60) == "60s"
    end

    test "minutes" do
      assert Duration.sec_to_str(60) == "1m"
      assert Duration.sec_to_str(75) == "1m 15s"
      refute Duration.sec_to_str(3600) == "60m"
    end

    test "hours" do
      assert Duration.sec_to_str(3600) == "1h"
      assert Duration.sec_to_str(7205) == "2h 5s"
      assert Duration.sec_to_str(36_300) == "10h 5m"
      assert Duration.sec_to_str(36_315) == "10h 5m 15s"
      refute Duration.sec_to_str(86_400) == "24h"
    end

    test "days" do
      assert Duration.sec_to_str(86_400) == "1d"
      assert Duration.sec_to_str(86_715) == "1d 5m 15s"
      refute Duration.sec_to_str(604_800) == "7d"
    end

    test "weeks" do
      assert Duration.sec_to_str(604_800) == "1w"
      assert Duration.sec_to_str(6_048_000) == "10w"
    end
  end
end
