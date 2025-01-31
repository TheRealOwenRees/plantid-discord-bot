import Config

config :plantid_discord_bot,
  max_results: 5,
  score_threshold: 0.3,
  guild_request_limit_per_day: 10,
  image_path: "priv/static",
  plantnet_api_base_url: "https://my-api.plantnet.org/v2",
  source: "https://github.com/TheRealOwenRees/plantid-discord-bot",
  invite: "https://discord.com/oauth2/authorize?client_id=948227126094598204"

config :nostrum,
  ffmpeg: nil,
  gateway_intents: [:guilds, :guild_messages, :message_content],
  token: System.get_env("PLANTID_DISCORD_BOT_TOKEN")

config :plantid_discord_bot, PlantIdDiscordBot.Scheduler,
  jobs: [
    {"@daily", {PlantIdDiscordBot.RateLimiter, :reset_counters, []}},
    {"@hourly", {PlantIdDiscordBot.Metrics, :backup, []}},
    {"0 8 * * *", {PlantIdDiscordBot.Metrics.Message, :send, []}}
  ]

import_config "#{config_env()}.exs"
