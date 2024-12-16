defmodule PlantIdDiscordBot.RateLimiter do
  use GenServer

  @request_limit Application.compile_env(:plantid_discord_bot, :guild_request_limit_per_day)

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    :ets.new(__MODULE__, [:named_table, :public, write_concurrency: true])
    {:ok, nil}
  end

  defp put(key, value) do
    :ets.insert(__MODULE__, {key, value})
  end

  defp get(key) do
    case :ets.lookup(__MODULE__, key) do
      [{^key, value}] -> {:ok, value}
      [] -> {:error, nil}
    end
  end

  @doc """
  Check if the number of requests for a guild exceeds the limit.
  """
  @spec check_limit(String.t()) :: {:ok, integer()} | {:limit_exceeded, integer()}
  def check_limit(guild_id) do
    case get(guild_id) do
      {:ok, value} ->
        if value >= @request_limit do
          {:limit_exceeded, value}
        else
          {:ok, value}
        end

      {:error, _} ->
        put(guild_id, 0)
        {:ok, 0}
    end
  end

  @doc """
  Increase the counter for the number of requests for a guild by one.
  """
  def increase_counter(guild_id) do
    :ets.update_counter(__MODULE__, guild_id, 1)
  end
end