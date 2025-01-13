defmodule PlantIdDiscordBot.Cog.PlantNetMessage do
  require Logger

  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.RateLimiter
  alias PlantIdDiscordBot.FileServer.File
  alias PlantIdDiscordBot.PlantNet.Parser
  alias Nostrum.Cache.GuildCache
  alias PlantIdDiscordBot.Metrics

  # @api Application.compile_env(:plantid_discord_bot, :api)
  @plantnet_api_base_url Application.compile_env(:plantid_discord_bot, :plantnet_api_base_url)
  @max_results Application.compile_env(:plantid_discord_bot, :max_results)

  def id(message) do
    IO.inspect(message)

    case RateLimiter.check_limit(message.guild_id) do
      {:limit_exceeded, _requests_used, _requests_limit} ->
        Api.create_message(message.channel_id,
          content:
            "This server has exceeded its allowed requests in 24 hours. Please try again tomorrow.",
          message_reference: %{message_id: message.id}
        )

      {:ok, _requests_used, _requests_limit} ->
        do_identification(message)
    end
  end

  def do_identification(message) do
    saved_images =
      try do
        Enum.take(message.attachments, 5)
        |> Enum.map(fn attachment -> attachment.url end)
        |> File.download_and_save_files!()
      rescue
        e in ArgumentError ->
          Api.create_message(message.channel_id, content: e.message)
          nil
      end

    if saved_images do
      try do
        prepare_images(saved_images)
        |> build_query_uri()
        |> get_response(message)
      rescue
        e ->
          Logger.error(Exception.format(:error, e, __STACKTRACE__))
          Api.create_message(message.channel_id, "An error occurred. This error has been logged.")
      after
        cleanup_saved_images(saved_images)
      end
    end
  end

  defp prepare_images(saved_images) do
    case Application.get_env(:plantid_discord_bot, :environment) do
      :test ->
        PlantIdDiscordBotTest.Mocks.PlantNet.Images.images()

      :dev ->
        PlantIdDiscordBotTest.Mocks.PlantNet.Images.images()

      _ ->
        Enum.map(saved_images, fn {:ok, filename} ->
          "#{Application.get_env(:plantid_discord_bot, :fileserver_url)}/#{filename}"
        end)
    end
  end

  defp get_response(query_uri, message) do
    guild_id = message.guild_id
    {:ok, %{name: guild_name}} = GuildCache.get(guild_id)

    case HTTPoison.get(query_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response_message = Parser.parse(body)

        RateLimiter.increase_counter(guild_id)
        Metrics.increase_request_count(guild_id, guild_name)

        # Nostrum.Api.create_message/2 is deprecated but the new function is not available in v0.10 of the library
        # Nostrum.Api.message/2 will be the new function
        Api.create_message(message.channel_id,
          content: response_message,
          message_reference: %{message_id: message.id}
        )

      {:ok, %HTTPoison.Response{status_code: 401, body: body}} ->
        Logger.critical("Unauthorized request to PlantNet API: #{body}")

        Api.create_message(message.channel_id,
          content: "Unauthorized request to PlantNet API.",
          message_reference: %{message_id: message.id}
        )

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        RateLimiter.increase_counter(guild_id)
        Metrics.increase_request_count(guild_id, guild_name)

        Api.create_message(message.channel_id,
          content: "Species Not Found",
          message_reference: %{message_id: message.id}
        )

      {:ok, %HTTPoison.Response{status_code: 429}} ->
        Logger.warning("Request limit exceeded for the PlantNet API")

        Api.create_message(message.channel_id,
          content: "Too Many Requests",
          message_reference: %{message_id: message.id}
        )

      {_, _} ->
        Logger.error("Internal server error when contacting the PlantNet API")

        Api.create_message(message.channel_id,
          content: "Internal Server Error",
          message_reference: %{message_id: message.id}
        )
    end
  end

  @spec build_query_uri([String.t()]) :: String.t()
  defp build_query_uri(image_filenames) do
    URI.parse(
      "#{@plantnet_api_base_url}/identify/all?api-key=#{Application.get_env(:plantid_discord_bot, :plantnet_api_key)}"
    )
    |> URI.append_query("images=#{Enum.join(image_filenames, "&images=")}")
    |> URI.append_query("nb-results=#{@max_results}")
    |> URI.append_query("type=kt")
    |> URI.to_string()
  end

  defp cleanup_saved_images(saved_images) do
    Enum.map(saved_images, fn {:ok, filename} -> filename end)
    |> File.delete_files!()
  end
end
