defmodule PlantIdDiscordBot.Cog.Projects do
  @moduledoc """
  Functions for using the /projects application command.
  """

  alias PlantIdDiscordBot.PlantNet.Projects
  @api Application.compile_env(:plantid_discord_bot, :api)

  # ---------------------------------------------------------
  # 1. AUTOCOMPLETE HANDLER
  # ---------------------------------------------------------
  def autocomplete(interaction) do
    # Extract what the user is typing (may be nil)
    [%{value: user_input}] = interaction.data.options
    user_input = user_input || ""

    # Fetch your project list
    projects = Projects.retrieve_projects()

    # Filter based on description
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

    # Respond with autocomplete choices
    @api.create_interaction_response(interaction, %{
      type: 8,
      data: %{choices: suggestions}
    })
  end

  # ---------------------------------------------------------
  # 2. FINAL COMMAND EXECUTION
  # ---------------------------------------------------------
  def projects(interaction) do
    # Extract selected project ID
    project_id =
      interaction.data.options
      |> Enum.find(&(&1.name == "project"))
      |> then(&(&1 && &1.value))

    @api.create_interaction_response(interaction, %{
      type: 4,
      data: %{
        content:
          case project_id do
            nil ->
              "Please choose a project using autocomplete."

            id ->
              # "You selected project: **#{id}**"
              "Identification by project coming soon."
          end
      }
    })
  end
end
