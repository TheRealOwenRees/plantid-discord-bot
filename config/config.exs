import Config

config :plantid_discord_bot,
  start_time: DateTime.utc_now(),
  image_folder: "priv/static"

import_config "#{config_env()}.exs"
