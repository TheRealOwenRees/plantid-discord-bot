defmodule PlantIdDiscordBot.Cog.Info do
  use Nostrum.Consumer
  import Nostrum.Struct.Embed
  alias PlantIdDiscordBot.Utils

  require Logger

  # reference to Nostrum.Api in non-test environments, reference to mock in test
  @api Application.compile_env(:plantid_discord_bot, :api)

  # urls
  @source Application.compile_env(:plantid_discord_bot, :source)
  @invite Application.compile_env(:plantid_discord_bot, :invite)
  @plantnet_api_base_url Application.compile_env(:plantid_discord_bot, :plantnet_api_base_url)

  @doc """
  Sends a link to the source code for this bot.
  """
  def source(interaction) do
    @api.create_interaction_response(interaction, %{type: 4, data: %{content: @source}})
  end

  @doc """
  Sends an invite link for this bot.
  """
  def invite(interaction) do
    message = "Invite the bot to your server:\n\n[Click Here](#{@invite})"
    @api.create_interaction_response(interaction, %{type: 4, data: %{content: message}})
  end

  @doc """
  Help menu for the bot.
  """
  def help(interaction) do
    embed =
      %Nostrum.Struct.Embed{}
      |> put_title("Let's break this down a bit")
      |> put_description("Upload up to 5 photos into the channel where the bot lives.\n\n")
      |> put_author(
        "Plant ID Bot",
        "https://my.plantnet.org/",
        "https://www.iona.edu/sites/default/files/2021-04/ancillary-images/green-flower.jpg"
      )
      |> put_footer(
        "Powered by Pl@ntNet API",
        "https://www.iona.edu/sites/default/files/2021-04/ancillary-images/green-flower.jpg"
      )
      |> put_field(
        "For best results:",
        "- all photos should be of the same plant\n- take photos of organs, not the whole plant\n- best results will be achieved by using a mixture of organs\n- use images at least 600x600px\n\n",
        true
      )
      |> put_field("/info", "for more commands")

    response = %{type: 4, data: %{embeds: [embed]}}
    @api.create_interaction_response(interaction, response)
  end

  @doc """
  Information about the bot.
  """
  def info(interaction) do
    {:ok, app_info} = @api.get_application_information()

    embed =
      %Nostrum.Struct.Embed{}
      |> put_title(app_info.name)
      |> put_description("This bot is designed to help you identify plants")
      |> put_color(0x41C03F)
      |> put_field("/info", "Show this message", true)
      |> put_field("/help", "Gives detailed help on the plant ID bot", true)
      |> put_field("/stats", "Bot stats", true)
      |> put_field("/invite", "Invite the bot to your server", true)
      |> put_field("/source", "Link to the source code", true)
      |> put_footer("Made by #{app_info.owner.username}")

    @api.create_interaction_response(interaction, %{type: 4, data: %{embeds: [embed]}})
  end

  @doc """
  Check the status of all relevant APIs.
  """
  def status(interaction) do
    message =
      case HTTPoison.get("#{@plantnet_api_base_url}/_status") do
        {:ok, %{status_code: 200}} ->
          "PlantNet API is up and running"

        _ ->
          "PlantNet API is down"
      end

    @api.create_interaction_response(interaction, %{type: 4, data: %{content: message}})
  end

  @doc """
  Bot stats.
  """
  def stats(interaction) do
    {:ok, app_info} = @api.get_application_information()

    embed =
      %Nostrum.Struct.Embed{}
      |> put_title(app_info.name)
      |> put_description("Stats etc.")
      |> put_color(0x1AAAE5)
      |> put_field("Server Count", app_info.approximate_guild_count, true)
      |> put_field("Uptime", Utils.get_uptime(), true)
      |> put_field("Latency", Utils.get_shard_latency(), true)
      |> put_footer("Made by #{app_info.owner.username}")

    @api.create_interaction_response(interaction, %{type: 4, data: %{embeds: [embed]}})
  end

  @doc """
  List all servers the bot is connected to.
  """
  def servers(interaction) do
    {:ok, %{owner: owner}} = @api.get_application_information()

    guilds = PlantIdDiscordBot.Utils.get_guilds_names()
    guilds_string = Enum.join(guilds, "\n")

    embed =
      %Nostrum.Struct.Embed{}
      |> put_title("Connected on #{length(guilds)} server(s):")
      |> put_description(guilds_string)
      |> put_color(0x1AAAE5)
      |> put_footer("Made by #{owner.username}")

    @api.create_interaction_response(interaction, %{type: 4, data: %{embeds: [embed]}})
  end
end
