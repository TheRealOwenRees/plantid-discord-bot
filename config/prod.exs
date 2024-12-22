import Config

config :plantid_discord_bot,
  api: Nostrum.Api,
  port: 4000

config :plantid_discord_bot, :environment, :prod

config :logger,
  backends: [{PlantIdDiscordBot.DiscordLogger, :discord_logger}]

config :logger, :discord_logger, level: :error
