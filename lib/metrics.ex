defmodule PlantIdDiscordBot.Metrics do
  alias PlantIdDiscordBot.Metrics.Requests
  alias PlantIdDiscordBot.RateLimiter

  def backup() do
    Requests.write()
  end

  def increase_request_count(guild_id, guild_name) do
    Requests.put(guild_id, guild_name)
  end

  def requests(guild_id), do: Requests.get(guild_id)
  def requests(), do: Requests.get_all()

  def ratelimiter(guild_id), do: RateLimiter.check_limit(guild_id)
  def ratelimiter(), do: RateLimiter.to_list()
end
