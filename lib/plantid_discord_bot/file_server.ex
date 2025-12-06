defmodule PlantIdDiscordBot.FileServer do
  @moduledoc """
  File server for temporary storage of images until a response is made.
  """
  use Plug.Builder

  plug(Plug.Logger)

  plug(Plug.Static,
    at: "/public",
    from: "/priv/static"
  )

  plug(PlantIdDiscordBot.FileServer.Router)
end
