defmodule PlantIdDiscordBotTest.Mocks.PlantNet.Images do
  @moduledoc """
  Mocks images passed to the PlantNet API. This means that the response will not be the images you have uploaded, but rather the response from the images below.
  """
  def images() do
    [
      "https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg",
      "https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg"
    ]
  end
end
