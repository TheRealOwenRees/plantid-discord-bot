defmodule PlantIdDiscordBotTest.Mocks.Guild do
  @moduledoc """
  Mocks the Guild module.
  """
  def get_guild_name!(guild_id),
    do: %{guild_id: 1_002_507_312_159_797_318, guild_name: "Test Guild"}
end
