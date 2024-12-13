defmodule PlantIdDiscordBotTest.Cog.Invite do
  use ExUnit.Case

  @invite Application.compile_env(:plantid_discord_bot, :invite)

  test "/invite" do
    {:ok, response} = PlantIdDiscordBot.Cog.Info.invite(%{data: %{name: "invite"}})
    message = "Invite the bot to your server:\n\n[Click Here](#{@invite})"

    expected_response = %{
      type: 4,
      data: %{content: message}
    }

    assert response == expected_response
  end
end
