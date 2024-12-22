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
      },
      %{
        name: "id",
        description: "ID a plant from up to 5 images",
        options: [
          %{
            # Attachment type
            type: 11,
            name: "image1",
            description: "The image to identify",
            required: true
          },
          %{
            type: 11,
            name: "image2",
            description: "The image to identify",
            required: false
          },
          %{
            type: 11,
            name: "image3",
            description: "The image to identify",
            required: false
          },
          %{
            type: 11,
            name: "image4",
            description: "The image to identify",
            required: false
          },
          %{
            type: 11,
            name: "image5",
            description: "The image to identify",
            required: false
          }
        ]
      }
    ]
  end
end
