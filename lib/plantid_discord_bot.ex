defmodule PlantIdDiscordBot.Consumer do
  @moduledoc """
  A Discord bot that identifies plants from photos of their organs.
  """
  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.{Cog, Consumer}

  @global_application_commands Consumer.Commands.global_application_commands()

  def handle_event({:READY, _data, _ws_state}) do
    Api.create_global_application_command(@global_application_commands)
    Api.update_status(:online, "Guess the Plant | /help")
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
    end
  end

  def handle_event({:MESSAGE_CREATE, %{attachments: attachments} = message, _ws_state}) do
    if length(attachments) > 0 do
      # deprecated -> Nostrum.Api.Channel.start_typing/1 in v1.0
      Api.start_typing!(message.channel_id)
      Cog.PlantNetMessage.id(message)
    end
  end
end
