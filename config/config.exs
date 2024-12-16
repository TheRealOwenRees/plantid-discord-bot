import Config

config :plantid_discord_bot,
  image_folder: "priv/static"

import_config "#{config_env()}.exs"
