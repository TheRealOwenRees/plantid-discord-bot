defmodule PlantIdDiscordBot.Utils do
  def get_uptime() do
    start_time = Application.get_env(:plantid_discord_bot, :start_time)

    DateTime.diff(DateTime.utc_now(), start_time)
    |> PlantIdDiscordBot.Utils.Duration.sec_to_str()
  end

  def get_shard_latency() do
    Nostrum.Util.get_all_shard_latencies()
    |> Map.get(0)
    |> to_string()
    |> Kernel.<>("ms")
  end

  def get_guilds_names() do
    Nostrum.Cache.GuildCache.fold([], fn %{name: name}, acc -> [name | acc] end)
  end
end
