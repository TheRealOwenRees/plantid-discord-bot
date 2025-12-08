defmodule PlantIdDiscordBot.Cog.Diseases do
  @moduledoc """
  Functions for using the /diseases application command.
  """

  alias PlantIdDiscordBot.Cog.PlantNetMessage

  @api Application.compile_env(:plantid_discord_bot, :api)

  def diseases(interaction) do
    # 1. Acknowledge immediately so the token doesn't expire
    @api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: "Analyzing plant health from photos..."}
    })

    resolved = Map.get(interaction.data, :resolved)
    attachments_map = (resolved && Map.get(resolved, :attachments)) || %{}
    options = interaction.data.options || []

    images =
      options
      |> Enum.filter(fn opt -> String.starts_with?(opt.name, "image") end)
      |> Enum.map(fn opt -> Map.get(attachments_map, opt.value) end)
      |> Enum.reject(&is_nil/1)

    message = %{
      guild_id: interaction.guild_id,
      channel_id: interaction.channel_id,
      id: nil,
      attachments: images
    }

    PlantNetMessage.id(message, "diseases")
  end
end
