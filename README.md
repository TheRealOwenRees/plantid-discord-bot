# Plant ID Discord Bot

## A plant identification bot for your Discord server.

Plant ID Bot identifies plants from photos of their organs, passing to the [Plantnet API] for identification. This bot was written for [Sustainable Living Hub](https://discord.com/invite/gQU5yWg)

If you wish to invite this bot to your server, use [this link.](https://discord.com/api/oauth2/authorize?client_id=948227126094598204&permissions=19520&scope=bot) However, your server will be limited to a maximum of 20 idendifications every 24h. It is strongly preferred that you host a version of this bot yourself and register for your own PlantNet API key. Details for this are later in this readme file.

## Features

- Takes the message picture attachments and attempts to identify them
- Returns a suggested plant name and up to 2 alternatives, with a percentage confidence rating
- Plant names are given in latin with a list of possible common names
- Provides links to [GBIF] and [PFAF] for the identified plant

## Prerequisites

List here
