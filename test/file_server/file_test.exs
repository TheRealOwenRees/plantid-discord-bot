defmodule PlantIdDiscordBotTest.FileServer.File do
  use ExUnit.Case
  doctest PlantIdDiscordBot.FileServer.File

  @image_path Application.compile_env(:plantid_discord_bot, :image_path)

  test "generate_unique_filename" do
    file_path = PlantIdDiscordBot.FileServer.File.generate_unique_filename("jpg")
    file_name = Path.basename(file_path)
    assert Regex.match?(~r/^[0-9A-F]{16}\.jpg$/, file_name)
    assert file_path == Path.join(@image_path, file_name)
  end
end
