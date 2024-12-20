defmodule PlantIdDiscordBot.Cog.PlantNet do
  require Logger
  use Nostrum.Consumer
  alias PlantIdDiscordBot.RateLimiter
  alias PlantIdDiscordBot.PlantNet.Parser
  alias PlantIdDiscordBot.FileServer.File
  alias Nostrum.Api

  @api Application.compile_env(:plantid_discord_bot, :api)
  @plantnet_api_base_url Application.compile_env(:plantid_discord_bot, :plantnet_api_base_url)
  @plantnet_api_key Application.compile_env(:plantid_discord_bot, :plantnet_api_key)
  @max_results Application.compile_env(:plantid_discord_bot, :max_results)
  @fileserver_url Application.compile_env(:plantid_discord_bot, :fileserver_url)

  @doc """
  Process /id application command.
  """
  def id(interaction) do
    case RateLimiter.check_limit(interaction.guild_id) do
      {:limit_exceeded, _} ->
        @api.create_interaction_response(interaction, %{
          type: 4,
          data: %{
            content:
              "This server has exceeded its allowed requests in 24 hours. Please try again tomorrow."
          }
        })

      {:ok, _} ->
        do_identification(interaction)
    end
  end

  defp do_identification(interaction) do
    @api.create_interaction_response(interaction, %{
      type: 5,
      data: %{
        content: "Processing..."
      }
    })

    try do
      attachment_urls = get_attachment_urls(interaction)
      original_images = get_original_images(attachment_urls)

      saved_images = File.download_and_save_files!(attachment_urls)

      prepare_images(saved_images)
      |> build_query_uri()
      |> get_response(interaction, original_images)

      cleanup_saved_images(saved_images)
    rescue
      e ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))

        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "An error occurred. This error has been logged."
        })
    end
  end

  defp get_attachment_urls(interaction) do
    interaction.data.resolved.attachments
    |> Map.values()
    |> Enum.map(& &1.url)
  end

  @spec get_original_images([String.t()]) :: String.t()
  defp get_original_images(attachment_urls), do: Enum.join(attachment_urls, "\n")

  defp prepare_images(saved_images) do
    if Mix.env() in [:test, :dev] do
      PlantIdDiscordBotTest.Mocks.PlantNet.Images.images()
    else
      Enum.map(saved_images, fn {:ok, filename} -> "#{@fileserver_url}/#{filename}" end)
    end
  end

  @spec build_query_uri([String.t()]) :: String.t()
  defp build_query_uri(image_filenames) do
    URI.parse("#{@plantnet_api_base_url}/identify/all?api-key=#{@plantnet_api_key}")
    |> URI.append_query("images=#{Enum.join(image_filenames, "&images=")}")
    |> URI.append_query("nb-results=#{@max_results}")
    |> URI.append_query("type=kt")
    |> URI.to_string()
  end

  @spec get_response(String.t(), Nostrum.Interaction.t(), String.t()) :: :ok
  defp get_response(query_uri, interaction, original_images) do
    case HTTPoison.get(query_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response_message = Parser.parse(body)
        RateLimiter.increase_counter(interaction.guild_id)

        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: response_message <> "\n#{original_images}"
        })

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        Logger.error("""
        Malformed request sent to the PlantNet Api from PlantIdDiscordBot.Cog.PlantNet.do_identification
          Query URI: #{query_uri}
          Status Code: 400
          Response Body: #{String.slice(body, 0..500)}... (truncated)
        """)

        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "Bad Request. This error has been logged."
        })

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        RateLimiter.increase_counter(interaction.guild_id)

        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "Species Not Found"
        })

      {:ok, %HTTPoison.Response{status_code: 429}} ->
        Logger.warning("Request limit exceeded for the PlantNet API")

        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "Too Many Requests"
        })

      {_, _} ->
        Logger.error("Internal server error when contacting the PlantNet API")

        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "Internal Server Error"
        })
    end
  end

  defp cleanup_saved_images(saved_images) do
    Enum.map(saved_images, fn {:ok, filename} -> filename end)
    |> File.delete_files!()
  end
end
