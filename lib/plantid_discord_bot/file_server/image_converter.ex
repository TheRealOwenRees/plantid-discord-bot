defmodule PlantIdDiscordBot.FileServer.ImageConverter do
  @moduledoc """
  Image conversion utilities
  """
  alias PlantIdDiscordBot.FileServer.MimeTypes

  def to_jpg!(binary) do
    case MimeTypes.detect_mime_type(binary) do
      {:ok, "image/jpeg"} -> binary
      {:ok, _} -> do_to_jpg(binary)
      {:error, message} -> raise File.Error, message
    end
  end

  defp do_to_jpg(binary) do
    Image.from_binary!(binary)
    |> Image.write!(:memory, suffix: ".jpg")
  end
end
