defmodule PlantIdDiscordBot.FileServer.File do
  @moduledoc """
  File utilities
  """
  alias PlantIdDiscordBot.FileServer.ImageConverter

  @image_path Application.compile_env(:plantid_discord_bot, :image_path)

  @doc """
  Downloads a file from the given URL. Throws an error if unsuccessful.
  """
  @spec download_file!(String.t()) :: binary
  def download_file!(url) do
    HTTPoison.get!(url)
    |> Map.get(:body)
  end

  @spec save_file!(binary) :: :ok
  def save_file!(binary) do
    File.mkdir_p!(@image_path)

    jpg_binary = ImageConverter.to_jpg!(binary)

    generate_unique_filename("jpg")
    |> File.write!(binary)
  end

  @doc """
  Generates a unique filename with the given file extension.
  """
  @spec generate_unique_filename(String.t()) :: String.t()
  def generate_unique_filename(file_extension) do
    filename = :crypto.strong_rand_bytes(8) |> Base.encode16()
    Path.join(@image_path, "#{filename}.#{file_extension}")
  end
end
