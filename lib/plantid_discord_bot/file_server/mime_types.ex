defmodule PlantIdDiscordBot.FileServer.MimeTypes do
  @moduledoc """
  Mime type utilities
  """

  @doc """
  Detect the mime type of a binary
  """
  @spec detect_mime_type(binary) :: String.t()
  def detect_mime_type(<<0x52, 0x49, 0x46, 0x46, _::binary>>), do: "image/webp"
  def detect_mime_type(<<0xFF, 0xD8, 0xFF, _::binary>>), do: "image/jpeg"
  def detect_mime_type(<<0x89, 0x50, 0x4E, 0x47, _::binary>>), do: "image/png"
  def detect_mime_type(<<0x47, 0x49, 0x46, 0x38, _::binary>>), do: "image/gif"
  def detect_mime_type(<<0x42, 0x4D, _::binary>>), do: "image/bmp"
  def detect_mime_type(<<0x49, 0x49, 0x2A, 0x00, _::binary>>), do: "image/tiff"
  def detect_mime_type(_), do: {:error, "Unsupported file type"}
end
