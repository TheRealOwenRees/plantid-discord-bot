defmodule PlantIdDiscordBot.MetricsTest do
  use ExUnit.Case
  doctest PlantIdDiscordBot.Metrics

  alias PlantIdDiscordBot.Metrics

  test "put multiple entries into state" do
    Metrics.Requests.reset()
    Metrics.increase_request_count(123, "Test Guild 1")
    Metrics.increase_request_count(321, "Test Guild 2")

    keys =
      Metrics.requests()
      |> Map.keys()

    assert length(keys) == 2

    %Metrics.Requests{
      guild_id: guild_id1,
      guild_name: guild_name1,
      first_request_at: first_request_at1,
      last_request_at: last_request_at1,
      total_requests: total_requests1
    } =
      Metrics.requests(123)

    assert guild_id1 == 123
    assert guild_name1 == "Test Guild 1"
    assert %DateTime{} = first_request_at1
    assert %DateTime{} = last_request_at1
    assert total_requests1 == 1

    %Metrics.Requests{
      guild_id: guild_id2,
      guild_name: guild_name2,
      first_request_at: first_request_at2,
      last_request_at: last_request_at2,
      total_requests: total_requests2
    } =
      Metrics.requests(321)

    assert guild_id2 == 321
    assert guild_name2 == "Test Guild 2"
    assert %DateTime{} = first_request_at2
    assert %DateTime{} = last_request_at2
    assert total_requests2 == 1
  end

  test "update requests for a guild" do
    Metrics.Requests.reset()
    Metrics.increase_request_count(123, "Test Guild 1")
    Metrics.increase_request_count(123, "Test Guild 1")

    %Metrics.Requests{
      guild_id: guild_id,
      guild_name: guild_name,
      first_request_at: first_request_at,
      last_request_at: last_request_at,
      total_requests: total_requests
    } =
      Metrics.requests(123)

    assert guild_id == 123
    assert guild_name == "Test Guild 1"
    assert %DateTime{} = first_request_at
    assert %DateTime{} = last_request_at
    assert total_requests == 2
  end
end
