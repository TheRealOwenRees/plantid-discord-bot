defmodule PlantIdDiscordBot.PlantNet.Parser do
  @moduledoc """
  Parses the response from the PlantNet API.
  """

  @gbif_base_url "https://www.gbif.org/species"
  @pfaf_base_url "https://pfaf.org/user/Plant.aspx?LatinName="
  @powo_base_url "https://powo.science.kew.org/taxon"
  @score_threshold 0.3

  @doc """
  Parses the response from the PlantNet API into a map.
  """
  @spec parse(String.t()) :: map()
  def parse(response), do: Jason.decode!(response)

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
end
