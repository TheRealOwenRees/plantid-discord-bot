defmodule PlantIdDiscordBot.RateLimiter do
  use GenServer
  require Logger

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
    case get(guild_id) do
      {:ok, _} ->
        :ets.update_counter(__MODULE__, guild_id, 1)
        Logger.debug("Increased counter for guild #{guild_id}")

      {:error, _} ->
        put(guild_id, 1)
        Logger.debug("Set counter for guild #{guild_id} to 1")
    end
  end

  @doc """
  Reset all guilds counters to 0.
  """
  @spec reset_counters() :: :ok
  def reset_counters() do
    :ets.delete_all_objects(__MODULE__)
    Logger.debug("Reset all guilds counters")
  end

  @spec to_list() :: list()
  def to_list() do
    :ets.tab2list(__MODULE__)
  end
end
