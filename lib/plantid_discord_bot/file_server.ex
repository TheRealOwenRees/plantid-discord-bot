defmodule PlantIdDiscordBot.FileServer do
  use Plug.Builder

  plug(Plug.Logger)

  plug(Plug.Static,
    at: "/public",
    from: "/priv/static"
  )

  plug(PlantIdDiscordBot.FileServer.Router)
end
