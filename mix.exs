defmodule PlantidDiscordBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :plantid_discord_bot,
      version: "0.2.0-alpha",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    dev_apps = if Mix.env() == :dev, do: [:observer, :wx], else: []

    [
      extra_applications: [:logger, :runtime_tools] ++ dev_apps,
      mod: {PlantIdDiscordBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:nostrum, "~> 0.10"},
      {:httpoison, "~> 2.2"},
      {:image, "~> 0.55"},
      {:jason, "~> 1.4"},
      {:logger_webhook_backend, "~> 0.0.2"},
      {:plug, "~> 1.12"},
      {:plug_cowboy, "~> 2.7"},
      {:quantum, "~> 3.5"}
    ]
  end
end
