defmodule PlantIdDiscordBot.Consumer do
  @moduledoc """
  A Discord bot that identifies plants from photos of their organs.
  """
  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.Cog

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
  def handle_event({:READY}) do
    # mock function depending on the environment
    # Api.create_global_application_command(@global_application_commands)
    # TODO fix, not working
    Api.update_status(:online, "Guess the Plant|/help")
    # TODO remove in prod
    Api.create_guild_application_command(1_002_507_312_159_797_318, @global_application_commands)
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
      "id" -> Cog.PlantNet.id(interaction)
    end
  end
end
