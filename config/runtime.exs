import Config

config :plantid_discord_bot,
  start_time: DateTime.utc_now(),
  guild_ids: [1_002_507_312_159_797_318],
  plantnet_api_key: System.get_env("PLANTNET_API_KEY"),
  fileserver_url: "http://localhost:4321",
  port: 4321,
  source: "https://github.com/TheRealOwenRees/plantid-discord-bot",
  invite:
    "https://discord.com/api/oauth2/authorize?client_id=948227126094598204&permissions=19520&scope=bot",
  api: Nostrum.Api

config :nostrum,
  token: System.get_env("DISCORD_TOKEN"),
  ffmpeg: nil
