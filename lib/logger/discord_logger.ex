defmodule PlantIdDiscordBot.DiscordLogger do
  require Logger
  use Tesla

  plug(Tesla.Middleware.JSON)

  @behaviour :gen_event

  def init({__MODULE__, name}) do
    {:ok, configure(name, [])}
  end

  def handle_call({:configure, opts}, %{name: name} = state) do
    {:ok, :ok, configure(name, opts, state)}
  end

  def handle_event({_level, gl, {Logger, _, _, _}}, state) when node(gl) != node() do
    {:ok, state}
  end

  def handle_event({level, _gl, {Logger, msg, ts, md}}, %{} = state) do
    if is_level_okay(level, state.level) do
      log_to_discord(state.webhook_url, level, msg, ts, md)
    end

    {:ok, state}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  defp is_level_okay(lvl, min_level) do
    is_nil(min_level) or Logger.compare_levels(lvl, min_level) != :lt
  end

  def log_to_discord(webhook_url, level, msg, ts, md) do
    formatted_msg = format_message(level, msg, ts, md)
    body = %{content: formatted_msg}

    post(webhook_url, body)
    |> case do
      {:ok, %{status: status}} when status in 200..299 -> :ok
      {:error, reason} -> Logger.error("Error sending log to Discord: #{inspect(reason)}")
      _any -> Logger.error("Error sending log to Discord")
    end
  end

  def format_message(level, msg, _ts, md) do
    timestamp = DateTime.utc_now()
    source = md[:application]
    msg = IO.iodata_to_binary(msg) |> String.slice(0..1900)

    "[#{timestamp}] [#{source}] [#{level}] `#{msg}`"
  end

  defp configure(name, opts) do
    state = %{name: name, format: nil, level: nil, metadata: nil, metadata_filter: nil}
    configure(name, opts, state)
  end

  defp configure(name, opts, state) do
    env = Application.get_env(:logger, name, [])
    opts = Keyword.merge(env, opts)
    Application.put_env(:logger, name, opts)

    new_state = %{
      webhook_url: Keyword.get(opts, :webhook_url, nil),
      level: Keyword.get(opts, :level)
    }

    Map.merge(state, new_state)
  end
end
