defmodule PlantIdDiscordBotTest.Mocks.Nostrum.Api do
  @moduledoc """
  Mocks the Nostrum.Api module.
  """

  def create_interaction_response(_interaction, response), do: {:ok, response}
end
