defmodule PlantIdDiscordBot.Consumer do
  @moduledoc """
  A Discord bot that identifies plants from photos of their organs.
  """
  use Nostrum.Consumer
  alias Nostrum.Api
  alias PlantIdDiscordBot.{Cog, Consumer}
  alias PlantIdDiscordBot.PlantNet.Projects

  @global_application_commands Consumer.Commands.global_application_commands()

  def handle_event({:READY, _data, _ws_state}) do
    Projects.fetch_projects()
    guild_id = Application.get_env(:plantid_discord_bot, :dev_guild_id)

    # Register commands instantly in your test server
    Enum.each(@global_application_commands, fn cmd ->
      Api.create_guild_application_command(guild_id, cmd)
    end)

    if Mix.env() == :prod do
      # Api.create_global_application_command(@global_application_commands)
      Api.bulk_overwrite_global_application_commands(@global_application_commands)
    end

    Api.update_status(:online, "Guess the Plant | /help")
  end

  def handle_event({:INTERACTION_CREATE, %{type: 4} = interaction, _ws_state}) do
    PlantIdDiscordBot.Cog.Projects.autocomplete(interaction)
  end

  def handle_event({:INTERACTION_CREATE, %{data: %{name: command}} = interaction, _ws_state}) do
    handle_interaction(command, interaction)
  end

  def handle_event({:MESSAGE_CREATE, %{attachments: attachments} = message, _ws_state}) do
    if !Enum.empty?(attachments) do
      Api.start_typing!(message.channel_id)
      Cog.PlantNetMessage.id(message)
    end
  end

  defp handle_interaction("source", interaction), do: Cog.Info.source(interaction)
  defp handle_interaction("invite", interaction), do: Cog.Info.invite(interaction)
  defp handle_interaction("help", interaction), do: Cog.Info.help(interaction)
  defp handle_interaction("info", interaction), do: Cog.Info.info(interaction)
  defp handle_interaction("stats", interaction), do: Cog.Info.stats(interaction)
  defp handle_interaction("status", interaction), do: Cog.Info.status(interaction)
  defp handle_interaction("servers", interaction), do: Cog.Info.servers(interaction)
  defp handle_interaction("diseases", interaction), do: Cog.Diseases.diseases(interaction)
  defp handle_interaction("projects", interaction), do: Cog.Projects.projects(interaction)
end
