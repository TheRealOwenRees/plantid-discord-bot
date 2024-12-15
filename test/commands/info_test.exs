defmodule PlantIdDiscordBotTest.Cog.Info do
  use ExUnit.Case

  test "/info" do
    {:ok, response} = PlantIdDiscordBot.Cog.Info.info(%{data: %{name: "info"}})
    [embed] = response[:data][:embeds]
    assert match?(%Nostrum.Struct.Embed{}, embed)
  end
end
