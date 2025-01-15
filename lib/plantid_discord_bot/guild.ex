defmodule PlantIdDiscordBot.Guild do
  alias Nostrum.Cache.GuildCache

  def get_guild_name!(guild_id) do
    %{name: guild_name} = GuildCache.get!(guild_id)
    guild_name
  end
end
