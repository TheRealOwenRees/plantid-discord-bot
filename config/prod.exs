import Config

config :plantid_discord_bot,
  api: Nostrum.Api

config :plantid_discord_bot, :environment, :prod

config :logger,
  backends: [{PlantIdDiscordBot.DiscordLogger, :discord_logger}]

config :logger, :discord_logger,
  webhook_url: System.get_env("LOGS_DISCORD_WEBHOOK_URL"),
  level: :error,
  bot_token: System.get_env("DISCORD_TOKEN")
