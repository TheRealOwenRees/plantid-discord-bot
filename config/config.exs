import Config

config :plantid_discord_bot,
  start_time: DateTime.utc_now()

import_config "#{config_env()}.exs"
