import Config

config :plantid_discord_bot,
  api: Nostrum.Api,
  guild: PlantIdDiscordBot.Guild,
  port: 4000

config :plantid_discord_bot, :environment, :prod

config :logger,
  backends: [{LoggerWebhookBackend, :webhook_logger}]

config :logger, :webhook_logger, level: :error
