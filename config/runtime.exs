import Config

config :plantid_discord_bot,
  start_time: DateTime.utc_now(),
  guild_ids: [],
  api: Nostrum.Api,
  plantnet_api_key: System.get_env("PLANTNET_API_KEY"),
  fileserver_url: System.get_env("PLANTID_FILESERVER_URL", "http://localhost:4321")

config :nostrum,
  token: System.get_env("PLANTID_DISCORD_BOT_TOKEN")

config :logger, :webhook_logger,
  webhook_url: System.get_env("PLANTID_LOGS_DISCORD_WEBHOOK_URL"),
  level: :error,
  bot_token: System.get_env("PLANTID_DISCORD_BOT_TOKEN")
