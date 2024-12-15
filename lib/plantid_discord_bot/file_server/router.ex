defmodule PlantIdDiscordBot.FileServer.Router do
  use Plug.Router

  plug(:match)
  plug(:dispatch)

  def init(options), do: options

  get "/health" do
    conn
    |> send_resp(200, "OK")
  end

  match(_, do: conn |> send_resp(404, "Not Found"))
end
