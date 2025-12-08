defmodule PlantIdDiscordBot.Cog.Projects do
  @moduledoc """
  Functions for using the /projects application command.
  """

  alias PlantIdDiscordBot.PlantNet.Projects
  alias PlantIdDiscordBot.Cog.PlantNetMessage

  @api Application.compile_env(:plantid_discord_bot, :api)

  def autocomplete(interaction) do
    options = interaction.data.options || []

    focused_option =
      Enum.find(options, fn opt -> Map.get(opt, :focused) == true end)

    user_input = (focused_option && focused_option.value) || ""

    projects = Projects.retrieve_projects()

    suggestions =
      projects
      |> Enum.filter(fn p ->
        String.contains?(
          String.downcase(p["description"]),
          String.downcase(user_input)
        )
      end)
      |> Enum.take(25)
      |> Enum.map(fn p ->
        %{
          # what the user sees
          name: p["description"],
          # what your command receives
          value: p["id"]
        }
      end)

    @api.create_interaction_response(interaction, %{
      type: 8,
      data: %{choices: suggestions}
    })
  end

  def projects(interaction) do
    project_id =
      interaction.data.options
      |> Enum.find(&(&1.name == "project"))
      |> then(&(&1 && &1.value))

    case project_id do
      nil ->
        @api.create_interaction_response(interaction, %{
          type: 4,
          data: %{content: "Please choose a project using autocomplete."}
        })

      id ->
        @api.create_interaction_response(interaction, %{
          type: 4,
          data: %{content: "Processing images for project **#{id}**..."}
        })

        resolved = Map.get(interaction.data, :resolved)
        attachments_map = (resolved && Map.get(resolved, :attachments)) || %{}

        images =
          interaction.data.options
          |> Enum.filter(fn opt -> String.starts_with?(opt.name, "image") end)
          |> Enum.map(fn opt -> Map.get(attachments_map, opt.value) end)
          |> Enum.reject(&is_nil/1)

        message = %{
          guild_id: interaction.guild_id,
          channel_id: interaction.channel_id,
          id: nil,
          attachments: images
        }

        PlantNetMessage.id(message, %{name: "projects", id: id})
    end
  end
end
