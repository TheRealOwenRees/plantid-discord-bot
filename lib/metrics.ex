defmodule PlantIdDiscordBot.Metrics do
  alias PlantIdDiscordBot.Metrics.Requests

  def backup() do
    Requests.write()
  end

  def increase_request_count(guild_id, guild_name) do
    Requests.put(guild_id, guild_name)
  end

  def requests(guild_id), do: Requests.get(guild_id)
  def requests(), do: Requests.get_all()
end
