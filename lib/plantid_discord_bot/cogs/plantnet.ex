defmodule PlantIdDiscordBot.Cog.PlantNet do
  use Nostrum.Consumer
  # alias PlantIdDiscordBot.Cog.PlantNet
  alias PlantIdDiscordBot.RateLimiter
  alias PlantIdDiscordBot.PlantNet.Parser

  @api Application.compile_env(:plantid_discord_bot, :api)

  # TEMP: Mock data
  @plantnet_raw_response "{\"query\":{\"project\":\"all\",\"images\":[\"https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg\",\"https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg\"],\"organs\":[\"auto\",\"auto\"],\"includeRelatedImages\":false,\"noReject\":false},\"language\":\"en\",\"preferedReferential\":\"k-world-flora\",\"bestMatch\":\"Prunus cerasifera Ehrh.\",\"results\":[{\"score\":0.87871,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus cerasifera\",\"scientificNameAuthorship\":\"Ehrh.\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Cherry plum, myrobalan\",\"Cherry Plum\",\"Purple-leaf Plum\"],\"scientificName\":\"Prunus cerasifera Ehrh.\"},\"gbif\":{\"id\":\"3021730\"},\"powo\":{\"id\":\"729568-1\"},\"iucn\":{\"id\":\"172162\",\"category\":\"DD\"}},{\"score\":0.31668,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus × cistena\",\"scientificNameAuthorship\":\"N.E.Hansen ex Koehne\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Dwarf red-leaf plum\",\"Purple-leaf sand cherry\",\"Purple-leaved sand cherry\"],\"scientificName\":\"Prunus × cistena N.E.Hansen ex Koehne\"},\"gbif\":{\"id\":\"3022465\"},\"powo\":{\"id\":\"2959315-4\"}},{\"score\":0.01801,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus sargentii\",\"scientificNameAuthorship\":\"Rehder\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Sargent's cherry\",\"Northern Japanese hill cherry\",\"Sargent’s cherry\"],\"scientificName\":\"Prunus sargentii Rehder\"},\"gbif\":{\"id\":\"3020955\"},\"powo\":{\"id\":\"730239-1\"},\"iucn\":{\"id\":\"64127603\",\"category\":\"LC\"}},{\"score\":0.00896,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus × yedoensis\",\"scientificNameAuthorship\":\"Matsum.\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Yoshino cherry\",\"Hybrid cherry\",\"Korean flowering cherry\"],\"scientificName\":\"Prunus × yedoensis Matsum.\"},\"gbif\":{\"id\":\"3021335\"},\"powo\":{\"id\":\"30119904-2\"}},{\"score\":0.00518,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus serrulata\",\"scientificNameAuthorship\":\"Lindl.\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Japanese flowering cherry\",\"Japanese flowering cherry Kwanzan\",\"Tibetan Cherry\"],\"scientificName\":\"Prunus serrulata Lindl.\"},\"gbif\":{\"id\":\"3022609\"},\"powo\":{\"id\":\"730268-1\"},\"iucn\":{\"id\":\"217170511\",\"category\":\"LC\"}}],\"version\":\"2024-11-19 (7.3)\",\"remainingIdentificationRequests\":488}"

  @doc """
  ID a plant from up to 5 images of organs.
  """
  def id(interaction) do
    case RateLimiter.check_limit(interaction.guild_id) do
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

    # temp data
    response_message = Parser.parse(@plantnet_raw_response)

    @api.create_interaction_response(interaction, %{
      type: 4,
      data: %{content: response_message <> "\n#{original_images}"}
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
