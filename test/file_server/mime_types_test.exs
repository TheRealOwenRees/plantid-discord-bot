defmodule PlantIdDiscordBotTest.FileServer.MimeTypes do
  use ExUnit.Case, async: true

  alias PlantIdDiscordBot.FileServer.MimeTypes
  doctest MimeTypes

  describe "detect_mime_type/1" do
    test "detects webp" do
      bin = <<0x52, 0x49, 0x46, 0x46, 0x00>>
      assert MimeTypes.detect_mime_type(bin) == {:ok, "image/webp"}
    end

    test "detects jpeg" do
      bin = <<0xFF, 0xD8, 0xFF, 0x00>>
      assert MimeTypes.detect_mime_type(bin) == {:ok, "image/jpeg"}
    end

    test "detects png" do
      bin = <<0x89, 0x50, 0x4E, 0x47, 0x00>>
      assert MimeTypes.detect_mime_type(bin) == {:ok, "image/png"}
    end

    test "detects gif" do
      bin = <<0x47, 0x49, 0x46, 0x38, 0x00>>
      assert MimeTypes.detect_mime_type(bin) == {:ok, "image/gif"}
    end

    test "detects bmp" do
      bin = <<0x42, 0x4D, 0x00>>
      assert MimeTypes.detect_mime_type(bin) == {:ok, "image/bmp"}
    end

    test "detects tiff" do
      bin = <<0x49, 0x49, 0x2A, 0x00, 0x00>>
      assert MimeTypes.detect_mime_type(bin) == {:ok, "image/tiff"}
    end

    test "returns error for unsupported type" do
      bin = <<0x00, 0x11, 0x22, 0x33>>
      assert MimeTypes.detect_mime_type(bin) == {:error, "Unsupported file type"}
    end
  end
end
