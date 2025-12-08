defmodule PlantIdDiscordBot.Consumer.Commands do
  @moduledoc """
  Application commands.
  """
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
      },
      %{
        name: "diseases",
        description: "Identify diseases from photos",
        options: []
      },
      %{
        name: "projects",
        description: "Plants grouped by region  or type, for identification",
        options: [
          %{
            # STRING
            type: 3,
            name: "project",
            description: "Search for a project",
            required: true,
            autocomplete: true
          }
        ]
      }
    ]
  end
end
