defmodule PlantIdDiscordBot.Cog.PlantNetMessage do
  @moduledoc """
  Functions for sending and receiving data from PLantNet
  """
  require Logger

  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.{Guild, RateLimiter, Metrics}
  alias PlantIdDiscordBot.PlantNet.Parser
  alias PlantIdDiscordBot.FileServer.File

  # mock modules
  @api Application.compile_env(:plantid_discord_bot, :api)
  @guild Application.compile_env(:plantid_discord_bot, :guild)

  # env vars
  @plantnet_api_base_url Application.compile_env(:plantid_discord_bot, :plantnet_api_base_url)
  @max_results Application.compile_env(:plantid_discord_bot, :max_results)

  def id(message, identification_type \\ "all") do
    case RateLimiter.check_limit(message.guild_id) do
      {:limit_exceeded, _requests_used, _requests_limit} ->
        send_message(
          "This server has exceeded its allowed requests in 24 hours. Please try again tomorrow.",
          message.channel_id,
          message.id
        )

      {:ok, _requests_used, _requests_limit} ->
        do_identification(message, identification_type)
    end
  end

  def do_identification(message, identification_type) do
    saved_images =
      try do
        Enum.take(message.attachments, 5)
        |> Enum.map(fn attachment -> attachment.url end)
        |> File.download_and_save_files!()
      rescue
        e ->
          Logger.error(Exception.format(:error, e, __STACKTRACE__),
            guild_id: message.guild_id,
            guild_name: @guild.get_guild_name!(message.guild_id)
          )

          @api.create_message(message.channel_id,
            content: "An error has occured. Please try again later."
          )

          # send_message("An error has occured. Please try again later.", message.channel_id)

          nil
      end

    if saved_images do
      try do
        prepare_images(saved_images)
        |> build_query_uri(identification_type)
        |> get_response(message)
      rescue
        e ->
          Logger.error(Exception.format(:error, e, __STACKTRACE__),
            guild_id: message.guild_id,
            guild_name: Guild.get_guild_name!(message.guild_id)
          )

          Api.create_message(
            message.channel_id,
            "The image(s) could not be used. Please make sure that the plant's organs are in focus, and that the image is at least 800x800 pixels."
          )
      after
        cleanup_saved_images(saved_images)
      end
    end
  end

  defp prepare_images(saved_images) do
    case Application.get_env(:plantid_discord_bot, :environment) do
      env when env in [:test, :dev] ->
        PlantIdDiscordBotTest.Mocks.PlantNet.Images.images()

      _ ->
        Enum.map(saved_images, fn {:ok, filename} ->
          "#{Application.get_env(:plantid_discord_bot, :fileserver_url)}/#{filename}"
        end)
    end
  end

  defp get_response(query_uri, message, interaction_type \\ nil) do
    guild_id = message.guild_id
    guild_name = Guild.get_guild_name!(guild_id)

    case HTTPoison.get(query_uri) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        response_message =
          case interaction_type do
            "diseases" -> Parser.parse_disease_response(body)
            _ -> Parser.parse(body)
          end

        RateLimiter.increase_counter(guild_id)
        Metrics.increase_request_count(guild_id, guild_name)

        send_message(response_message, message.channel_id, message.id)

      {:ok, %HTTPoison.Response{status_code: 401, body: body}} ->
        Logger.critical("Unauthorized request to PlantNet API: #{body}",
          guild_id: guild_id,
          guild_name: guild_name
        )

        send_message("Unauthorized requesnt to PlantNet API", message.channel_id, message.id)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        RateLimiter.increase_counter(guild_id)
        Metrics.increase_request_count(guild_id, guild_name)

        send_message("Species Not Found", message.channel_id, message.id)

      {:ok, %HTTPoison.Response{status_code: 429}} ->
        Logger.warning("Request limit exceeded for the PlantNet API")

        send_message("Too Many Requests", message.channel_id, message.id)

      {_, _} ->
        Logger.error("Internal server error when contacting the PlantNet API",
          guild_id: guild_id,
          guild_name: guild_name
        )

        send_message("Internal Server Error", message.channel_id, message.id)
    end
  end

  @spec build_query_uri([String.t()], String.t()) :: String.t()
  def build_query_uri(image_filenames, identification_type) do
    create_base_uri(identification_type)
    |> add_required_query_params(image_filenames)
  end

  defp create_base_uri("all"), do: "#{@plantnet_api_base_url}/identify/all"
  defp create_base_uri("diseases"), do: "#{@plantnet_api_base_url}/diseases/identify"

  defp create_base_uri(%{name: "projects", id: id}),
    do: "#{@plantnet_api_base_url}/identify/#{id}"

  defp create_base_uri(_), do: "#{@plantnet_api_base_url}/identify/all"

  defp add_required_query_params(base_uri, image_filenames) do
    URI.parse(base_uri)
    |> URI.append_query("api-key=#{Application.get_env(:plantid_discord_bot, :plantnet_api_key)}")
    |> URI.append_query("images=#{Enum.join(image_filenames, "&images=")}")
    |> URI.append_query("nb-results=#{@max_results}")
    |> URI.append_query("type=kt")
    |> URI.to_string()
  end

  defp cleanup_saved_images(saved_images) do
    Enum.map(saved_images, fn {:ok, filename} -> filename end)
    |> File.delete_files!()
  end

  # Nostrum.Api.create_message/2 is deprecated but the new function is not available in v0.10 of the library
  # Nostrum.Api.message/2 will be the new function
  # look at @api.create_message and move to this if needed
  defp send_message(content, channel_id, message_id \\ nil) do
    case message_id do
      nil ->
        Api.create_message(channel_id, content: content)

      _ ->
        Api.create_message(channel_id,
          content: content,
          message_reference: %{message_id: message_id}
        )
    end
  end
end
