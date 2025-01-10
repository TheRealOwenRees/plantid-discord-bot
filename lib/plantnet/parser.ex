defmodule PlantIdDiscordBot.PlantNet.Parser do
  @moduledoc """
  Parses the response from the PlantNet API.

  # Examples
      iex> response = ~S({
      ...>   "results": [
      ...>     {
      ...>       "score": 0.87871,
      ...>       "species": {
      ...>         "scientificNameWithoutAuthor": "Prunus cerasifera",
      ...>         "commonNames": ["Cherry plum", "myrobalan", "Cherry Plum", "Purple-leaf Plum"]
      ...>       },
      ...>       "gbif": {"id": "3021730"},
      ...>       "powo": {"id": "729568-1"},
      ...>       "iucn": {"category": "DD"}
      ...>     }
      ...>   ]
      ...> })
      iex> PlantIdDiscordBot.PlantNet.Parser.parse(response)

      "My best guess is **Prunus cerasifera** with a confidence of **88%**. Common names include **Cherry plum, myrobalan, Cherry Plum, Purple-leaf Plum**.

      [GBIF](<https://www.gbif.org/species/3021730>) | [PFAF](<https://pfaf.org/user/Plant.aspx?LatinName=Prunus+cerasifera>) | [POWO](<https://powo.science.kew.org/taxon/729568-1>)
      Threat status: DD"
  """

  @gbif_base_url "https://www.gbif.org/species"
  @pfaf_base_url "https://pfaf.org/user/Plant.aspx?LatinName="
  @powo_base_url "https://powo.science.kew.org/taxon"
  @score_threshold Application.compile_env(:plantid_discord_bot, :score_threshold)

  @doc """
  Parses the response from the PlantNet API into a map.
  """
  @spec parse(String.t()) :: map()
  def parse(response) do
    response
    |> to_map!()
    |> filter_by_score()
    |> add_external_urls()
    |> generate_response_message()
  end

  @spec to_map!(String.t()) :: map()
  def to_map!(response), do: Jason.decode!(response)

  @doc """
  Filters the data by score. Data is a parsed response from the PlantNet API.
  """
  @spec filter_by_score(map()) :: map()
  def filter_by_score(data) do
    updated_results =
      data["results"]
      |> Enum.filter(&(&1["score"] > @score_threshold))

    Map.put(data, "results", updated_results)
  end

  @doc """
  Adds external URLs to the data. Data is a parsed response from the PlantNet API.
  """
  @spec add_external_urls(map()) :: map()
  def add_external_urls(data) do
    updated_results =
      data["results"]
      |> generate_gbif_url()
      |> generate_pfaf_url()
      |> generate_powo_url()

    Map.put(data, "results", updated_results)
  end

  @doc """
  Generates a response message from the data. Data is a parsed response from the PlantNet API.
  """
  @spec generate_response_message(map()) :: String.t()
  def generate_response_message(data) do
    best_result = hd(data["results"])
    other_results = tl(data["results"])
    best_guess_name = best_result["species"]["scientificNameWithoutAuthor"]
    best_result_iucn_category = best_result["iucn"]["category"]
    score = round(best_result["score"] * 100) |> Integer.to_string()

    "My best guess is **#{best_guess_name}** with a confidence of **#{score}%**. Common names include **#{Enum.join(best_result["species"]["commonNames"], ", ")}**.\n\nSpecies info from plant databases:\n[GBIF](<#{best_result["gbif_url"]}>) | [PFAF](<#{best_result["pfaf_url"]}>) | [POWO](<#{best_result["powo_url"]}>)#{if best_result_iucn_category, do: "\n\nConservation status: #{iucn_parser(best_result_iucn_category)}"}#{get_alternatives(other_results)}"
  end

  @spec generate_gbif_url(map()) :: map()
  defp generate_gbif_url(data) do
    Enum.map(data, fn result ->
      gbif_id = result["gbif"]["id"]
      if gbif_id, do: Map.put(result, "gbif_url", "#{@gbif_base_url}/#{gbif_id}"), else: result
    end)
  end

  @spec generate_pfaf_url(map()) :: map()
  defp generate_pfaf_url(data) do
    Enum.map(data, fn result ->
      pfaf_slug = String.replace(result["species"]["scientificNameWithoutAuthor"], " ", "+")

      if pfaf_slug,
        do: Map.put(result, "pfaf_url", "#{@pfaf_base_url}/#{pfaf_slug}"),
        else: result
    end)
  end

  @spec generate_powo_url(map()) :: map()
  defp generate_powo_url(data) do
    Enum.map(data, fn result ->
      powo_id = result["powo"]["id"]
      if powo_id, do: Map.put(result, "powo_url", "#{@powo_base_url}/#{powo_id}"), else: result
    end)
  end

  @spec get_alternatives(map()) :: String.t()
  defp iucn_parser(abbreviation) do
    case abbreviation do
      "DD" -> "Data Deficient"
      "LC" -> "Least Concern"
      "NT" -> "Near Threatened"
      "VU" -> "Vulnerable"
      "EN" -> "Endangered"
      "CR" -> "Critically Endangered"
      "EW" -> "Extinct in the Wild"
      "EX" -> "Extinct"
      "NE" -> "Not Evaluated"
      _ -> "Unknown"
    end
  end

  defp get_alternatives(data) do
    if length(data) > 0 do
      alternatives =
        Enum.map(data, & &1["species"]["scientificNameWithoutAuthor"])
        |> Enum.join(", ")

      "\n\nAlternatives include **#{alternatives}**."
    end
  end
end
