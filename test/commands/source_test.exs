defmodule PlantIdDiscordBotTest.Cog.Source do
  use ExUnit.Case

  @source Application.compile_env(:plantid_discord_bot, :source)

  test "source" do
    interaction = %{data: %{name: "source"}}

    expected_response = %{
      type: 4,
      data: %{content: @source}
    }

    assert PlantIdDiscordBot.Cog.Info.source(interaction) == {:ok, expected_response}
  end
end
