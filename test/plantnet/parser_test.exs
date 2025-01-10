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

  test "no iucn data prevents 'Conservation Status' from being shown in response message" do
    message =
      PlantNetFixtures.parsed_response_with_urls_no_iucn()
      |> Parser.generate_response_message()

    refute String.contains?(message, "Conservation status: ")
  end

  describe "message paragraph spacing" do
    test "iucn data plus alternatives" do
      message =
        PlantNetFixtures.parsed_response_with_urls()
        |> Parser.generate_response_message()

      assert message ==
               "My best guess is **Prunus cerasifera** with a confidence of **88%**. Common names include **Cherry plum, myrobalan, Cherry Plum, Purple-leaf Plum**.\n\nSpecies info from plant databases:\n[GBIF](<https://www.gbif.org/species/3021730>) | [PFAF](<https://pfaf.org/user/Plant.aspx?LatinName=/Prunus+cerasifera>) | [POWO](<https://powo.science.kew.org/taxon/729568-1>)\n\nConservation status: Data Deficient\n\nAlternatives include **Prunus × cistena**."
    end

    test "no iucn data" do
      message =
        PlantNetFixtures.parsed_response_with_urls_no_iucn()
        |> Parser.generate_response_message()

      assert message ==
               "My best guess is **Prunus cerasifera** with a confidence of **88%**. Common names include **Cherry plum, myrobalan, Cherry Plum, Purple-leaf Plum**.\n\nSpecies info from plant databases:\n[GBIF](<https://www.gbif.org/species/3021730>) | [PFAF](<https://pfaf.org/user/Plant.aspx?LatinName=/Prunus+cerasifera>) | [POWO](<https://powo.science.kew.org/taxon/729568-1>)\n\nAlternatives include **Prunus × cistena**."
    end
  end
end
