defmodule PlantIdDiscordBotTest.Mocks.Nostrum.Api do
  @moduledoc """
  Mocks the Nostrum.Api module.
  """

  def create_interaction_response(_interaction, response), do: {:ok, response}

  def get_application_information() do
    {:ok, %{name: "Test Bot", approximate_guild_count: 1, owner: %{username: "Test User"}}}
  end
end
