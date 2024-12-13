defmodule PlantIdDiscordBotTest.Mocks.Nostrum.Api do
  @moduledoc """
  Mocks the Nostrum.Api module.
  """

  def create_interaction_response(_interaction, response), do: {:ok, response}
  def get_application_info(), do: {:ok, %{name: "Test Bot", owner: %{username: "Test User"}}}
end
