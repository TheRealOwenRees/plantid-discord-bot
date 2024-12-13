import Config

config :plantid_discord_bot,
  guild_ids: [],
  start_time: DateTime.utc_now(),
  plantnet_api_key: System.get_env("PLANTNET_API_KEY"),
  plantnet_api_base_url: "https://my-api.plantnet.org/v2",
  image_folder: "priv/static",
  fileserver_url: "http://localhost:4321",
  port: 4321,
  source: "https://github.com/TheRealOwenRees/plantID_discordbot",
  invite:
    "https://discord.com/api/oauth2/authorize?client_id=948227126094598204&permissions=19520&scope=bot"
