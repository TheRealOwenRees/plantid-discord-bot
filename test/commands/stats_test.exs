defmodule PlantIdDiscordBotTest.Cog.Stats do
  use ExUnit.Case

  test "/stats" do
    {:ok, response} = PlantIdDiscordBot.Cog.Info.info(%{data: %{name: "stats"}})
    [embed] = response[:data][:embeds]
    assert match?(%Nostrum.Struct.Embed{}, embed)
  end
end
