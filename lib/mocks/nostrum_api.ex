defmodule PlantIdDiscordBotTest.Mocks.Nostrum.Api do
  @moduledoc """
  Mocks the Nostrum.Api module.
  """

  # def create_message(_channel_id, content), do: {:ok, content}

  def create_message(_channel_id, content) do
    send(self(), {:create_message, 123456, content})
    {:ok, content}
  end

  def create_interaction_response(_interaction, response), do: {:ok, response}

  def get_application_information() do
    {:ok, %{name: "Test Bot", approximate_guild_count: 1, owner: %{username: "Test User"}}}
  end
end
