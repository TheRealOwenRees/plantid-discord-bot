defmodule PlantIdDiscordBot.Application do
  use Application

  @port Application.compile_env(:plantid_discord_bot, :port)

  @impl true
  def start(_type, _args) do
    # Set the start time for the application
    start_time = DateTime.utc_now()
    Application.put_env(:plantid_discord_bot, :start_time, start_time)

    children = [
      PlantIdDiscordBot.Consumer,
      PlantIdDiscordBot.RateLimiter,
      {Plug.Cowboy, scheme: :http, plug: PlantIdDiscordBot.FileServer, options: [port: @port]}
    ]

    opts = [strategy: :one_for_one, name: PlantIdDiscordBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
