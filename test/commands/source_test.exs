defmodule PlantIdDiscordBotTest.Cog.Source do
  use ExUnit.Case

  @source Application.compile_env(:plantid_discord_bot, :source)

  test "/source" do
    {:ok, response} = PlantIdDiscordBot.Cog.Info.source(%{data: %{name: "source"}})

    expected_response = %{
      type: 4,
      data: %{content: @source}
    }

    assert response == expected_response
  end
end
