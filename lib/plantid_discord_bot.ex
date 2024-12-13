defmodule PlantIdDiscordBot do
  @moduledoc """
  A Discord bot that identifies plants from photos of their organs.
  """

  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.Cog

  IO.inspect("Starting PlantIdDiscordBot")

  @global_application_commands [
    {"servers", "All servers that this bot belongs to, []"},
    {"invite", "Invite link for this bot, []"},
    {"source", "Link to the source code for this bot, []"},
    {"info", "Information about this bot, []"},
    {"stats", "Statistics about this bot, []"},
    {"help", "Help information for this bot, []"},
    {"status", "API Status, []"},
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
end
