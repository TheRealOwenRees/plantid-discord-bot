defmodule PlantIdDiscordBot.ErrorHandlingTest do
  use ExUnit.Case

  test "do_identification/1 returns nil when an error occurs" do
    message = PlantNetFixtures.Message.message()
    PlantIdDiscordBot.Cog.PlantNetMessage.do_identification(message)
  end
end
