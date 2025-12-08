defmodule PlantIdDiscordBot.Consumer do
  @moduledoc """
  A Discord bot that identifies plants from photos of their organs.
  """
  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.{Cog, Consumer}

  @global_application_commands Consumer.Commands.global_application_commands()

  def handle_event({:READY, _data, _ws_state}) do
    Projects.fetch_projects()
    guild_id = Application.get_env(:plantid_discord_bot, :dev_guild_id)

    # Register commands instantly in your test server
    Enum.each(@global_application_commands, fn cmd ->
      Api.create_guild_application_command(guild_id, cmd)
    end)

    # Only register global commands in production
    if Mix.env() == :prod do
      Api.create_global_application_command(@global_application_commands)
    end

    Api.update_status(:online, "Guess the Plant | /help")
  end

  def handle_event({:INTERACTION_CREATE, %{type: 4} = interaction, _ws_state}) do
    PlantIdDiscordBot.Cog.Projects.autocomplete(interaction)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: command}} = interaction, _ws_state}) do
    case command do
      "source" -> Cog.Info.source(interaction)
      "invite" -> Cog.Info.invite(interaction)
      "help" -> Cog.Info.help(interaction)
      "info" -> Cog.Info.info(interaction)
      "stats" -> Cog.Info.stats(interaction)
      "status" -> Cog.Info.status(interaction)
      "servers" -> Cog.Info.servers(interaction)
      "diseases" -> Cog.Diseases.diseases(interaction)
      "projects" -> Cog.Projects.projects(interaction)
    end
  end

  def handle_event({:MESSAGE_CREATE, %{attachments: attachments} = message, _ws_state}) do
    if !Enum.empty?(attachments) do
      Api.start_typing!(message.channel_id)
      Cog.PlantNetMessage.id(message)
    end
  end
end
