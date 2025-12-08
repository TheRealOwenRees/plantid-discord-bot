defmodule PlantIdDiscordBot.ErrorHandlingTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  @guild Application.compile_env(:plantid_discord_bot, :guild)

  test "do_identification/2 returns invokes logger on error" do
    message = PlantNetFixtures.Message.message()

    log =
      capture_log(fn ->
        PlantIdDiscordBot.Cog.PlantNetMessage.do_identification(message, "all")

        assert_received {:create_message, 123_456,
                         content: "An error has occured. Please try again later."}
      end)

    assert log =~ "guild_id=#{message.guild_id}"
    assert log =~ "guild_name=#{@guild.get_guild_name!(message.guild_id)}"
  end
end
