import Config

config :plantid_discord_bot,
  max_results: 5,
  score_threshold: 0.3,
  plantnet_api_key: System.get_env("PLANTNET_API_KEY"),
  plantnet_api_base_url: "https://my-api.plantnet.org/v2",
  port: 4321,
  guild_request_limit_per_day: 20,
  image_path: "priv/static",
  fileserver_url: "http://localhost:4321",
  source: "https://github.com/TheRealOwenRees/plantid-discord-bot",
  invite:
    "https://discord.com/api/oauth2/authorize?client_id=948227126094598204&permissions=19520&scope=bot"

import_config "#{config_env()}.exs"
