defmodule PlantIdDiscordBot.Consumer.Commands do
  def global_application_commands do
    [
      %{
        name: "source",
        description: "Link to the source code for this bot",
        options: []
      },
      %{
        name: "invite",
        description: "Invite link for this bot",
        options: []
      },
      %{
        name: "help",
        description: "Help information for this bot",
        options: []
      },
      %{
        name: "info",
        description: "Information about this bot",
        options: []
      },
      %{
        name: "stats",
        description: "Statistics about this bot",
        options: []
      },
      %{
        name: "status",
        description: "API Status",
        options: []
      },
      %{
        name: "servers",
        description: "All servers that this bot belongs to",
        options: []
      }
    ]
  end
end
