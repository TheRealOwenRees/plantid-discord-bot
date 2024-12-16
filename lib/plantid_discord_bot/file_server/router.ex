defmodule PlantIdDiscordBot.FileServer.Router do
  use Plug.Router
  alias PlantIdDiscordBot.FileServer.File

  plug(:match)
  plug(:dispatch)

  def init(options), do: options

  get "/health" do
    conn
    |> send_resp(200, "OK")
  end

  get "image/:filename" do
    filename = conn.params["filename"]

    case File.get_file(filename) do
      {:ok, binary} ->
        conn
        |> put_resp_content_type("image/jpeg")
        |> send_resp(200, binary)

      {:error, _} ->
        conn
        |> send_resp(404, "Not Found")
    end
  end

  match(_, do: conn |> send_resp(404, "Not Found"))
end
