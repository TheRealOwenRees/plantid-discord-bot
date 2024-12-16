# Plant ID Discord Bot

## A plant identification bot for your Discord server.

Plant ID Bot identifies plants from photos of their organs, passing to the [Plantnet API] for identification. This bot was written for [Sustainable Living Hub](https://discord.com/invite/gQU5yWg)

If you wish to invite this bot to your server, use [this link.](https://discord.com/api/oauth2/authorize?client_id=948227126094598204&permissions=19520&scope=bot) However, your server will be limited to a maximum of 20 idendifications every 24h. It is strongly preferred that you host a version of this bot yourself and register for your own PlantNet API key. Details for this are later in this readme file.

## Features

- Takes the message picture attachments and attempts to identify them
- Returns a suggested plant name and up to 2 alternatives, with a percentage confidence rating
- Plant names are given in latin with a list of possible common names
- Provides links to [GBIF], [PFAF], and [POWO] for the identified plant

## Prerequisites

      {:nostrum, "~> 0.10"},
      {:httpoison, "~> 2.2"},
      {:image, "~> 0.55"},
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.7"}

## Installation

TODO

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
