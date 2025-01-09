defmodule PlantIdDiscordBot.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PlantIdDiscordBot.ProcessRegistry,
      PlantIdDiscordBot.Consumer,
      PlantIdDiscordBot.RateLimiter,
      {PlantIdDiscordBot.Metrics, []},
      PlantIdDiscordBot.Scheduler,
      {Plug.Cowboy,
       scheme: :http,
       plug: PlantIdDiscordBot.FileServer,
       options: [port: Application.get_env(:plantid_discord_bot, :port)]}
    ]

    opts = [strategy: :one_for_one, name: PlantIdDiscordBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
