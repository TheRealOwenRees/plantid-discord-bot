defmodule PlantIdDiscordBot.Utils do
  @start_time Application.compile_env(:plantid_discord_bot, :start_time)

  def get_uptime() do
    DateTime.diff(DateTime.utc_now(), @start_time)
    |> PlantIdDiscordBot.Utils.Duration.sec_to_str()
  end

  def get_shard_latency() do
    Nostrum.Util.get_all_shard_latencies()
    |> Map.get(0)
    |> to_string()
    |> Kernel.<>("ms")
  end
end
