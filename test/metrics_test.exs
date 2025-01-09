defmodule PlantIdDiscordBot.MetricsTest do
  use ExUnit.Case
  doctest PlantIdDiscordBot.Metrics

  test "put multiple entries into state" do
    PlantIdDiscordBot.Metrics.reset()
    PlantIdDiscordBot.Metrics.put(123, "Test Guild 1")
    PlantIdDiscordBot.Metrics.put(321, "Test Guild 2")

    keys =
      PlantIdDiscordBot.Metrics.get_all()
      |> Map.keys()

    assert length(keys) == 2

    assert %PlantIdDiscordBot.Metrics{
             guild_id: 123,
             guild_name: "Test Guild 1",
             total_requests: 1
           } ==
             PlantIdDiscordBot.Metrics.get(123)

    assert %PlantIdDiscordBot.Metrics{
             guild_id: 321,
             guild_name: "Test Guild 2",
             total_requests: 1
           } ==
             PlantIdDiscordBot.Metrics.get(321)
  end

  test "update requests for a guild" do
    PlantIdDiscordBot.Metrics.reset()
    PlantIdDiscordBot.Metrics.put(123, "Test Guild 1")
    PlantIdDiscordBot.Metrics.put(123, "Test Guild 1")

    assert %PlantIdDiscordBot.Metrics{
             guild_id: 123,
             guild_name: "Test Guild 1",
             total_requests: 2
           } ==
             PlantIdDiscordBot.Metrics.get(123)
  end
end
