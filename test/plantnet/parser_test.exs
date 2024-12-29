defmodule PlantIdDiscordBotTest.PlantNet.Parser do
  alias PlantIdDiscordBot.PlantNet.Parser
  use ExUnit.Case

  doctest PlantIdDiscordBot.PlantNet.Parser

  test "to_map" do
    result =
      PlantNetFixtures.raw_response()
      |> Parser.to_map!()

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

  test "no iucn data prevents 'Threat Status' from being show in response message" do
    message =
      PlantNetFixtures.parsed_response_with_urls_no_iucn()
      |> Parser.generate_response_message()

    refute String.contains?(message, "Threat status: ")
  end
end
