defmodule PlantIdDiscordBot.PlantNet.Projects do
  @moduledoc """
  Functions related to PlantNet's projecs
  """
  require Logger
  alias HTTPoison.Response

  @plantnet_api_base_url Application.compile_env(:plantid_discord_bot, :plantnet_api_base_url)

  def fetch_projects do
    try do
      build_query_uri()
      |> get_response()
      |> parse_response()
      |> save_projects()
    rescue
      e ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
    end
  end

  defp build_query_uri do
    URI.parse("#{@plantnet_api_base_url}/projects")
    |> URI.append_query("lang=en")
    |> URI.append_query("type=kt")
    |> URI.append_query("api-key=#{Application.get_env(:plantid_discord_bot, :plantnet_api_key)}")
    |> URI.to_string()
  end

  defp get_response(query_uri), do: HTTPoison.get!(query_uri)

  defp parse_response(%Response{status_code: 200, body: body}), do: Jason.decode!(body)

  defp parse_response(%Response{status_code: 401, body: body}) do
    Logger.critical("Unauthorized request to PlantNet API: #{body}")
  end

  defp save_projects(projects), do: :persistent_term.put(:projects, projects)

  def retrieve_projects, do: :persistent_term.get(:projects)

  def find_project_by_description(description) do
    retrieve_projects()
    |> Enum.find(&(&1["description"] == description))
  end
end
