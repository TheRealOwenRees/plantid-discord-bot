defmodule PlantIdDiscordBotTest.PlantNet.Parser do
  alias PlantIdDiscordBot.PlantNet.Parser
  use ExUnit.Case

  doctest PlantIdDiscordBot.PlantNet.Parser

  test "parse" do
    result =
      PlantNetFixtures.raw_response()
      |> Parser.parse()

    assert result == PlantNetFixtures.parsed_response()
  end

  test "filter by score" do
    result =
      PlantNetFixtures.parsed_response() |> Parser.filter_by_score()

    assert result == PlantNetFixtures.parsed_response_filtered_by_score()
  end

  test "add_external_urls" do
    result =
      PlantNetFixtures.parsed_response_filtered_by_score()
      |> Parser.add_external_urls()

    assert result == PlantNetFixtures.parsed_response_with_urls()
  end
end
