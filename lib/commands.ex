defmodule PlantIdDiscordBot.Consumer.Commands do
  def global_application_commands() do
    [
      {"source", "Link to the source code for this bot", []},
      {"invite", "Invite link for this bot", []},
      {"help", "Help information for this bot", []},
      {"info", "Information about this bot", []},
      {"stats", "Statistics about this bot", []},
      {"status", "API Status", []},
      {"servers", "All servers that this bot belongs to", []},
      {"id", "ID a plant from up to 5 images",
       [
         %{
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
       ]}
    ]
  end
end
