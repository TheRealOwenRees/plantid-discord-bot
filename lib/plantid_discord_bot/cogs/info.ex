defmodule PlantIdDiscordBot.Cog.Info do
  use Nostrum.Consumer

  @api Application.compile_env(:plantid_discord_bot, :api)
  @source Application.compile_env(:plantid_discord_bot, :source)

  @doc """
  Sends a link to the source code for this bot.
  """
  def source(interaction) do
    @api.create_interaction_response(interaction, %{type: 4, data: %{content: @source}})
  end
end
