import Config

config :plantid_discord_bot,
  image_path: "priv/static",
  plantnet_api_base_url: "https://my-api.plantnet.org/v2"

import_config "#{config_env()}.exs"
