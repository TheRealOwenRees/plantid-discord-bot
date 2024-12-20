import Config

config :plantid_discord_bot,
  api: PlantIdDiscordBotTest.Mocks.Nostrum.Api

config :plantid_discord_bot, :environment, :test

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :debug
