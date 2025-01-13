defmodule PlantIdDiscordBot.Metrics.Requests do
  use Agent
  alias PlantIdDiscordBot.Metrics.Requests
  alias PlantIdDiscordBot.ProcessRegistry

  @file_path "priv/metrics"

  defstruct [
    :guild_id,
    :guild_name,
    :first_request_at,
    :last_request_at,
    :total_requests
  ]

  def start_link(_opts) do
    initial_state =
      case File.exists?(Path.join(@file_path, "requests")) do
        true -> read()
        false -> %{}
      end

    Agent.start_link(fn -> initial_state end, name: via_tuple(:requests))
  end

  defp via_tuple(key) do
    ProcessRegistry.via_tuple({__MODULE__, key})
  end

  defp get_pid do
    [{pid, _value}] = Registry.lookup(ProcessRegistry, {__MODULE__, :requests})
    pid
  end

  def get(key) do
    get_pid()
    |> Agent.get(&Map.get(&1, key))
  end

  def get_all() do
    get_pid()
    |> Agent.get(& &1)
  end

  def put(guild_id, guild_name) do
    get_pid()
    |> Agent.update(fn state ->
      case Map.get(state, guild_id) do
        nil ->
          request_time = DateTime.utc_now()

          Map.put(state, guild_id, %Requests{
            guild_id: guild_id,
            guild_name: guild_name,
            first_request_at: request_time,
            last_request_at: request_time,
            total_requests: 1
          })

        existing ->
          Map.put(state, guild_id, %Requests{
            existing
            | last_request_at: DateTime.utc_now(),
              total_requests: existing.total_requests + 1
          })
      end
    end)
  end

  @doc """
  Reset metrics state and remove the saved file from disk.
  """
  def reset() do
    get_pid()
    |> Agent.update(fn _ -> %{} end)

    file = Path.join(@file_path, "requests")

    if File.exists?(file) do
      File.rm!(Path.join(@file_path, "requests"))
    end
  end

  @doc """
  Write the current state to disk. To be consumed by a CRON job.
  """
  def write() do
    File.mkdir_p!("priv/metrics")

    data =
      get_all()
      |> :erlang.term_to_binary()

    File.write!(Path.join(@file_path, "requests"), data)
  end

  @doc """
  Read the state from disk. To be loaded into state on process start.
  """
  def read() do
    File.read!(Path.join(@file_path, "requests"))
    |> :erlang.binary_to_term()
  end
end
