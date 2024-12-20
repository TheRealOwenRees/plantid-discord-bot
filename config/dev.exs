import Config

config :plantid_discord_bot,
  api: Nostrum.Api

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :debug
