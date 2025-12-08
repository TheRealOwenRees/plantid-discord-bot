defmodule PlantIdDiscordBot.Cog.Diseases do
  @moduledoc """
  Functions for using the /diseases application command.
  """

  alias PlantIdDiscordBot.PlantNet.Projects
  @api Application.compile_env(:plantid_discord_bot, :api)

  @doc """
  Sends an invite link for this bot.
  """
  def diseases(interaction) do
    message = "Diseases coming soon."
    @api.create_interaction_response(interaction, %{type: 4, data: %{content: message}})
  end
end
