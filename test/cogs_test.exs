defmodule PlantIdDiscordBotTest.Cog do
  use ExUnit.Case, async: true
  doctest PlantIdDiscordBot.Cog.Info
  doctest PlantIdDiscordBot.Cog.PlantNetMessage

  alias PlantIdDiscordBot.Cog.PlantNetMessage

  @plantnet_api_base_url Application.compile_env(:plantid_discord_bot, :plantnet_api_base_url)
  @plantnet_api_key Application.compile_env(:plantid_discord_bot, :plantnet_api_key)
  @image_filenames ["image1.jpg", "image2.jpg", "image3.jpg"]

  describe "build_query_uri/2" do
    test "all" do
      uri = PlantNetMessage.build_query_uri(@image_filenames, "all")

      test_uri =
        @image_filenames
        |> Enum.reduce(
          URI.parse("#{@plantnet_api_base_url}/identify/all")
          |> URI.append_query("api-key=#{@plantnet_api_key}"),
          fn filename, acc ->
            URI.append_query(acc, "images=#{filename}")
          end
        )
        |> URI.append_query("nb-results=5")
        |> URI.append_query("type=kt")
        |> URI.to_string()

      assert uri == test_uri
    end

    test "diseases" do
      uri = PlantNetMessage.build_query_uri(@image_filenames, "diseases")

      test_uri =
        @image_filenames
        |> Enum.reduce(
          URI.parse("#{@plantnet_api_base_url}/diseases/identify")
          |> URI.append_query("api-key=#{@plantnet_api_key}"),
          fn filename, acc ->
            URI.append_query(acc, "images=#{filename}")
          end
        )
        |> URI.append_query("nb-results=5")
        |> URI.append_query("type=kt")
        |> URI.to_string()

      assert uri == test_uri
    end

    test "projects" do
      uri =
        PlantNetMessage.build_query_uri(@image_filenames, %{name: "projects", id: "project-id"})

      test_uri =
        @image_filenames
        |> Enum.reduce(
          URI.parse("#{@plantnet_api_base_url}/identify/project-id")
          |> URI.append_query("api-key=#{@plantnet_api_key}"),
          fn filename, acc ->
            URI.append_query(acc, "images=#{filename}")
          end
        )
        |> URI.append_query("nb-results=5")
        |> URI.append_query("type=kt")
        |> URI.to_string()

      assert uri == test_uri
    end

    test "default" do
      uri = PlantNetMessage.build_query_uri(@image_filenames, "all")

      test_uri =
        @image_filenames
        |> Enum.reduce(
          URI.parse("#{@plantnet_api_base_url}/identify/all")
          |> URI.append_query("api-key=#{@plantnet_api_key}"),
          fn filename, acc ->
            URI.append_query(acc, "images=#{filename}")
          end
        )
        |> URI.append_query("nb-results=5")
        |> URI.append_query("type=kt")
        |> URI.to_string()

      assert uri == test_uri
    end
  end
end
