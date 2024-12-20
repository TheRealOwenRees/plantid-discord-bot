defmodule PlantIdDiscordBot.Application do
  use Application

  @port Application.compile_env(:plantid_discord_bot, :port)

  @impl true
  def start(_type, _args) do
    children = [
      PlantIdDiscordBot.Consumer,
      PlantIdDiscordBot.RateLimiter,
      PlantIdDiscordBot.Scheduler,
      {Plug.Cowboy, scheme: :http, plug: PlantIdDiscordBot.FileServer, options: [port: @port]}
    ]

    opts = [strategy: :one_for_one, name: PlantIdDiscordBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
