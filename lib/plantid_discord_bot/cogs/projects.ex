defmodule PlantIdDiscordBot.Cog.Projects do
  @moduledoc """
  Functions for using the /projects application command.
  """

  alias PlantIdDiscordBot.PlantNet.Projects
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
    # Extract selected project ID
    project_id =
      interaction.data.options
      |> Enum.find(&(&1.name == "project"))
      |> then(&(&1 && &1.value))

    attachments_map = interaction.data[:resolved][:attachments] || %{}

    images =
      interaction.data.options
      |> Enum.filter(fn opt -> String.starts_with?(opt.name, "image") end)
      |> Enum.map(fn opt -> Map.get(attachments_map, opt.value) end)
      |> Enum.reject(&is_nil/1)

    @api.create_interaction_response(interaction, %{
      type: 4,
      data: %{
        content:
          case project_id do
            nil ->
              "Please choose a project using autocomplete."

            id ->
              image_count = length(images)
              # "You selected project: **#{id}**"
              "Identification by project coming soon."
          end
      }
    })
  end
end
