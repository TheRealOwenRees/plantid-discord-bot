# Plant ID Discord Bot

## A plant identification bot for your Discord server.

Plant ID Bot identifies plants from photos of their organs, passing to the [Plantnet API] for identification. This bot was written for [Sustainable Living Hub](https://discord.com/invite/gQU5yWg)

If you wish to invite this bot to your server, use [this link.](https://discord.com/oauth2/authorize?client_id=948227126094598204) However, your server will be limited to a maximum of 10 identifications every 24h. It is strongly preferred that you host a version of this bot yourself and register for your own PlantNet API key. Details for this are later in this readme file.

### Features

- Takes the message picture attachments and attempts to identify them
- Returns a suggested plant name and up to 2 alternatives, with a percentage confidence rating
- Plant names are given in latin with a list of possible common names
- Provides links to [GBIF], [PFAF], and [POWO] for the identified plant

### Dependencies

This application has been built and tested with Elixir 1.16 / OTP 26.

```elixir
# mix.exs

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
```

### Environment Variables

Below are the environment variables that you need to set for the program to function:

```
PLANTID_DISCORD_BOT_TOKEN=           client secret from the bot's application
PLANTID_LOGS_DISCORD_WEBHOOK_URL=    webhook url for the log channel
PLANTNET_API_KEY=                    API key for the PlantNet service
PLANTID_FILESERVER_URL               URL and port(if needed) for the http file server
```

### Installation

#### Prerequisites

- Have a VPS ready to host this application on
- Visit [PlantNet Api] and create your own API key
- Visit [Discord Developer Portal](https://discord.com/developers/) and create a new application as a bot. Give it permissions to read and send messages, use application commands, and to create embeds. Enable `Message Content Intent`. Keep note of the `Bot Token`.

#### then...

- Clone this GitHub repository locally
- Add the above environment variables to you GitHub actions secrets, as well as SSH keys for your VPS, username, host, and port
- Change the target OS version if required.
- Force the GitHub action to run, allowing it to deploy on your server
- Start the application on your VPS with `your_folder_name/current_release/bin/plantid_discord_bot daemon`

## Development

Want to contribute? Simply fork, edit and then create a pull request. Details of how to do this can be found [here](https://www.digitalocean.com/community/tutorials/how-to-create-a-pull-request-on-github).

## License

MIT

[//]: # "These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax"
[git-repo-url]: https://github.com/TheRealOwenRees/plantid-discord-bot
[Plantnet API]: https://my.plantnet.org/
[GBIF]: https://pypi.org/project/python-dotenv/
[PFAF]: https://pfaf.org
[POWO]: https://powo.science.kew.org/
