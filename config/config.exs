import Config

config :plantid_discord_bot,
  max_results: 5,
  score_threshold: 0.3,
  guild_request_limit_per_day: 20,
  image_path: "priv/static",
  plantnet_api_base_url: "https://my-api.plantnet.org/v2",
  source: "https://github.com/TheRealOwenRees/plantid-discord-bot",
  invite:
    "https://discord.com/api/oauth2/authorize?client_id=948227126094598204&permissions=19520&scope=bot"

config :nostrum,
  ffmpeg: nil

config :plantid_discord_bot, PlantIdDiscordBot.Scheduler,
  jobs: [
    {"@daily", {PlantIdDiscordBot.RateLimiter, :reset_counters, []}},
    {"@hourly", {PlantIdDiscordBot.Metrics, :write, []}}
  ]

import_config "#{config_env()}.exs"
