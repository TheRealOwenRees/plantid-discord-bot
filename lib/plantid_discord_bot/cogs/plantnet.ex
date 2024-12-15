defmodule PlantIdDiscordBot.Cog.PlantNet do
  use Nostrum.Consumer
  alias PlantIdDiscordBot.RateLimiter

  @api Application.compile_env(:plantid_discord_bot, :api)

  @doc """
  ID a plant from up to 5 images of organs.
  """
  def id(interaction) do
    guild_id = interaction.guild_id

    case RateLimiter.check_limit(guild_id) do
      {:limit_exceeded, value} ->
        @api.create_interaction_response(interaction, %{
          type: 4,
          data: %{
            content:
              "This server has exceeded its allowed requests in 24 hours. Please try again tomorrow."
          }
        })

      {:ok, _} ->
        do_identification(interaction)
    end

    # TODO increase on success (failed id or otherwise)
    # RateLimiter.increase_counter(guild_id)
  end

  defp do_identification(interaction) do
    attachment_urls = get_attachment_urls(interaction)
    original_images = get_original_images(attachment_urls)

    @api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: "This command is not yet implemented." <> "\n#{original_images}"}
    })
  end

  defp get_attachment_urls(interaction) do
    interaction.data.resolved.attachments
    |> Map.values()
    |> Enum.map(& &1.url)
  end

  @spec get_original_images([String.t()]) :: String.t()
  defp get_original_images(attachment_urls), do: Enum.join(attachment_urls, "\n")
end
