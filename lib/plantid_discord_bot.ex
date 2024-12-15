defmodule PlantIdDiscordBot do
  @moduledoc """
  A Discord bot that identifies plants from photos of their organs.
  """

  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.Cog

  IO.inspect("Starting PlantIdDiscordBot")

  @global_application_commands [
    {"source", "Link to the source code for this bot, []"},
    {"invite", "Invite link for this bot, []"},
    {"help", "Help information for this bot, []"},
    {"info", "Information about this bot, []"},
    {"stats", "Statistics about this bot, []"},
    {"status", "API Status, []"},
    {"servers", "All servers that this bot belongs to, []"},
    {"id", "ID a plant from up to 5 images, []"}
  ]

  # Starts the bot
  def handle_event({:READY}) do
    # mock function depending on the environment
    Api.create_global_application_command(@global_application_commands)
    # TODO fix, not working
    Api.update_status(:online, "Guess the Plant|/help")
    # TODO remove in prod
    Api.create_guild_application_command(1_002_507_312_159_797_318, @global_application_commands)
  end

  # Handle /source command
  def handle_event({:INTERACTION_CREATE, %{data: %{name: "source"}} = interaction, _ws_state}) do
    Cog.Info.source(interaction)
  end

  # Handle /invite command
  def handle_event({:INTERACTION_CREATE, %{data: %{name: "invite"}} = interaction, _ws_state}) do
    Cog.Info.invite(interaction)
  end

  # Handle /help command
  def handle_event({:INTERACTION_CREATE, %{data: %{name: "help"}} = interaction, _ws_state}) do
    Cog.Info.help(interaction)
  end

  # Handle /info command
  def handle_event({:INTERACTION_CREATE, %{data: %{name: "info"}} = interaction, _ws_state}) do
    Cog.Info.info(interaction)
  end

  # def handle_event({:INTERACTION_CREATE, %{data: %{name: "stats"}} = interaction, _ws_state}) do
  #   Cog.Info.info(interaction)
  # end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: "status"}} = interaction, _ws_state}) do
    Cog.Info.status(interaction)
  end

  # def handle_event({:INTERACTION_CREATE, %{data: %{name: "servers"}} = interaction, _ws_state}) do
  #   Cog.Info.info(interaction)
  # end

  # def handle_event({:INTERACTION_CREATE, %{data: %{name: "id"}} = interaction, _ws_state}) do
  #   Cog.Info.info(interaction)
  # end
end
