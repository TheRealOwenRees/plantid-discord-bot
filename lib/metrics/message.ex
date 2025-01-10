defmodule PlantIdDiscordBot.Metrics.Message do
  @webhook_url Application.compile_env(:plantid_discord_bot, :metrics_webhook_url)

  def start() do
    PlantIdDiscordBot.Metrics.get_all()
    |> format_message()
    |> send_message()
  end

  def format_message(data) do
    embeds =
      Enum.map(data, fn {guild_id, metrics} ->
        first_request_at =
          DateTime.truncate(metrics.first_request_at, :second)
          |> DateTime.to_string()

        last_request_at =
          DateTime.truncate(metrics.last_request_at, :second)
          |> DateTime.to_string()

        %{
          title: metrics.guild_name,
          fields: [
            %{name: "Guild ID", value: guild_id, inline: true},
            %{name: "First Request At", value: first_request_at, inline: true},
            %{name: "Last Request At", value: last_request_at, inline: true},
            %{name: "Total Requests", value: metrics.total_requests, inline: true}
          ]
        }
      end)

    %{embeds: embeds}
  end

  def send_message(data) do
    body = Jason.encode!(data)

    headers = [
      {"Content-Type", "application/json"}
    ]

    HTTPoison.post!(@webhook_url, body, headers)
  end
end
