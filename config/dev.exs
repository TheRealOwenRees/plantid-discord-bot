import Config

config :plantid_discord_bot,
  api: Nostrum.Api,
  guild: PlantIdDiscordBot.Guild,
  port: 4321,
  dev_guild_id: System.get_env("DISCORD_DEV_GUILD_ID")

config :plantid_discord_bot, :environment, :dev

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:guild_id, :guild_name],
  level: :debug
