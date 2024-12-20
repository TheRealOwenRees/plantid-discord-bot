import Config

config :plantid_discord_bot,
  api: Nostrum.Api

config :plantid_discord_bot, :environment, :dev

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :debug
