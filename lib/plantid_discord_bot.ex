defmodule PlantIdDiscordBot.Consumer do
  @moduledoc """
  A Discord bot that identifies plants from photos of their organs.
  """
  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.Cog
  alias PlantIdDiscordBot.Consumer.Commands

  @global_application_commands Commands.global_application_commands()

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
