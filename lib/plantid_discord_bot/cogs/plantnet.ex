defmodule PlantIdDiscordBot.Cog.PlantNet do
  use Nostrum.Consumer
  alias PlantIdDiscordBot.RateLimiter
  alias PlantIdDiscordBot.PlantNet.Parser
  alias PlantIdDiscordBot.FileServer.File
  alias Nostrum.Api

  @api Application.compile_env(:plantid_discord_bot, :api)
  @plantnet_api_base_url Application.compile_env(:plantid_discord_bot, :plantnet_api_base_url)
  @plantnet_api_key Application.compile_env(:plantid_discord_bot, :plantnet_api_key)
  @max_results Application.compile_env(:plantid_discord_bot, :max_results)

  @doc """
  Process /id application command.
  """
  def id(interaction) do
    case RateLimiter.check_limit(interaction.guild_id) do
      {:limit_exceeded, value} ->
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

    attachment_urls = get_attachment_urls(interaction)
    original_images = get_original_images(attachment_urls)

    saved_images =
      try do
        File.download_and_save_files!(attachment_urls)
      rescue
        e ->
          Api.create_followup_message(interaction.application_id, interaction.token, %{
            content: e.message
          })
      end

    IO.inspect(saved_images)

    # TODO use actual image data
    image1 =
      "https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg"

    image2 =
      "https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg"

    images = [image1, image2]

    query_uri = build_query_uri(images)

    case HTTPoison.get(query_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response_message = Parser.parse(body)
        RateLimiter.increase_counter(interaction.guild_id)

        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: response_message <> "\n#{original_images}"
        })

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        # TODO add logger
        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "Bad Request"
        })

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        # TODO add logger
        RateLimiter.increase_counter(interaction.guild_id)

        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "Species Not Found"
        })

      {:ok, %HTTPoison.Response{status_code: 429}} ->
        # TODO add logger
        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "Too Many Requests"
        })

      {_, _} ->
        # TODO add logger
        Api.create_followup_message(interaction.application_id, interaction.token, %{
          content: "Internal Server Error"
        })
    end

    # TODO make into a task for async deletion, deal with errors
    Enum.map(saved_images, fn {:ok, filename} -> filename end)
    |> File.delete_files!()
  end

  defp get_attachment_urls(interaction) do
    interaction.data.resolved.attachments
    |> Map.values()
    |> Enum.map(& &1.url)
  end

  @spec get_original_images([String.t()]) :: String.t()
  defp get_original_images(attachment_urls), do: Enum.join(attachment_urls, "\n")

  @spec build_query_uri([String.t()]) :: String.t()
  defp build_query_uri(image_filenames) do
    identify_api_url = "#{@plantnet_api_base_url}/identify/all?api-key=#{@plantnet_api_key}"

    URI.append_query(
      URI.parse(identify_api_url),
      "images=#{Enum.join(image_filenames, "&images=")}"
    )
    |> URI.append_query("nb-results=#{@max_results}")
    |> URI.append_query("type=kt")
    |> URI.to_string()
  end
end
