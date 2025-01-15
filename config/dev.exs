import Config

config :plantid_discord_bot,
  api: Nostrum.Api,
  guild: PlantIdDiscordBot.Guild,
  port: 4321

config :plantid_discord_bot, :environment, :dev

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:guild_id, :guild_name],
  level: :debug
