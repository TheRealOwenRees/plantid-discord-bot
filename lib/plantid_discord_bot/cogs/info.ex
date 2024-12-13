defmodule PlantIdDiscordBot.Cog.Info do
  use Nostrum.Consumer
  import Nostrum.Struct.Embed
  alias PlantIdDiscordBot.Utils

  @api Application.compile_env(:plantid_discord_bot, :api)
  @source Application.compile_env(:plantid_discord_bot, :source)
  @invite Application.compile_env(:plantid_discord_bot, :invite)

  @doc """
  Sends a link to the source code for this bot.
  """
  def source(interaction) do
    @api.create_interaction_response(interaction, %{type: 4, data: %{content: @source}})
  end

  @doc """
  Sends an invite link for this bot.
  """
  def invite(interaction) do
    message = "Invite the bot to your server:\n\n[Click Here](#{@invite})"
    @api.create_interaction_response(interaction, %{type: 4, data: %{content: message}})
  end

  @doc """
  Help menu for the bot.
  """
  def help(interaction) do
    embed =
      %Nostrum.Struct.Embed{}
      |> put_title("Let's break this down a bit")
      |> put_description("Use the `/id` command and add up to 5 photos\n\n")
      |> put_author(
        "Plant ID Bot",
        "https://discordapp.com",
        "https://cdn.discordapp.com/embed/avatars/0.png"
      )
      |> put_footer(
        "Powered by Pl@ntNet API",
        "https://www.iona.edu/sites/default/files/2021-04/ancillary-images/green-flower.jpg"
      )
      |> put_field(
        "For best results:",
        "- all photos should be of the same plant\n- take photos of organs, not the whole plant\n- best results will be achieved by using a mixture of organs\n- use images at least 600x600px\n\n",
        true
      )
      |> put_field("/info", "for more commands")

    response = %{type: 4, data: %{embeds: [embed]}}
    @api.create_interaction_response(interaction, response)
  end

  @doc """
  Information about the bot.
  """
  def info(interaction) do
    {:ok, app_info} = @api.get_application_information()

    embed =
      %Nostrum.Struct.Embed{}
      |> put_title(app_info.name)
      |> put_description("Stats etc.")
      |> put_color(0x1AAAE5)
      |> put_field("Server Count", app_info.approximate_guild_count, true)
      |> put_field("Uptime", Utils.get_uptime(), true)
      |> put_field("Latency", Utils.get_shard_latency(), true)
      |> put_footer("Made by #{app_info.owner.username}")

    response = %{type: 4, data: %{embeds: [embed]}}
    @api.create_interaction_response(interaction, response)
  end
end
