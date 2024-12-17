import Config

config :plantid_discord_bot,
  image_path: "priv/static",
  plantnet_api_base_url: "https://my-api.plantnet.org/v2",
  score_threshold: 0.3,
  max_results: 5

config :plantid_discord_bot, PlantIdDiscordBot.Scheduler,
  jobs: [
    {"@daily", {PlantIdDiscordBot.RateLimiter, :reset_counters, []}}
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  level: :info

import_config "#{config_env()}.exs"
