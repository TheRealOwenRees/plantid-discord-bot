defmodule PlantIdDiscordBotTest do
  use ExUnit.Case
  doctest PlantIdDiscordBot

  test "greets the world" do
    assert PlantIdDiscordBot.hello() == :world
  end
end
