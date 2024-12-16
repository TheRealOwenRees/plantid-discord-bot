defmodule PlantIdDiscordBot.FileServer.File do
  @moduledoc """
  File utilities
  """
  alias PlantIdDiscordBot.FileServer.ImageConverter

  @image_path Application.compile_env(:plantid_discord_bot, :image_path)

  @doc """
  Download and save a file from a URL.
  """
  @spec download_and_save_files!(String.t()) :: {:ok, String.t()}
  def download_and_save_files!(url) do
    tasks =
      Enum.map(url, fn url ->
        Task.async(fn ->
          try do
            download_file!(url)
            |> save_file!()
          rescue
            e -> {:error, e}
          end
        end)
      end)

    results =
      Enum.map(tasks, &Task.await/1)
      |> Enum.filter(fn
        {:ok, _} -> true
        _ -> false
      end)

    if Enum.empty?(results) do
      raise ArgumentError,
            "None of the images that you uploaded are valid for identification. Please ensure that the images are valid."
    end

    results
  end

  @doc """
  Generates a unique filename with the given file extension.
  """
  @spec generate_unique_filename(String.t()) :: String.t()
  def generate_unique_filename(file_extension) do
    filename = :crypto.strong_rand_bytes(8) |> Base.encode16()
    Path.join(@image_path, "#{filename}.#{file_extension}")
  end

  @doc """
  Get a file from the file server.
  """
  @spec get_file(String.t()) :: {:ok, binary} | {:error, String.t()}
  def get_file(filename) do
    Path.join(@image_path, filename)
    |> File.read()
  end

  @spec delete_file!(String.t()) :: :ok
  def delete_file!(filename) do
    File.rm!(Path.join(@image_path, filename))
  end

  @spec download_file!(String.t()) :: binary
  defp download_file!(url) do
    HTTPoison.get!(url)
    |> Map.get(:body)
  end

  @spec save_file!(binary) :: {:ok, String.t()}
  defp save_file!(binary) do
    File.mkdir_p!(@image_path)

    jpg_binary = ImageConverter.to_jpg!(binary)

    filename = generate_unique_filename("jpg")
    File.write!(filename, jpg_binary)

    {:ok, Path.basename(filename)}
  end
end
