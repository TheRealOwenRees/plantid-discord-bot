import Config

config :plantid_discord_bot,
  api: PlantIdDiscordBotTest.Mocks.Nostrum.Api,
  guild: PlantIdDiscordBotTest.Mocks.Guild,
  port: 4321

config :plantid_discord_bot, :environment, :test

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:guild_id, :guild_name],
  level: :debug
