defmodule PlantIdDiscordBotTest.Cog.Help do
  use ExUnit.Case

  test "/help" do
    {:ok, response} = PlantIdDiscordBot.Cog.Info.help(%{data: %{name: "help"}})
    [embed] = response[:data][:embeds]
    assert match?(%Nostrum.Struct.Embed{}, embed)
  end
end
