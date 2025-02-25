ExUnit.start()

defmodule PlantNetFixtures.Message do
  @message %{
    channel_id: 1178600825380155412,
    guild_id: 1_002_507_312_159_797_318,
    attachments: [%{url: "http://invalid-url.com/image.jpg"}],
  }

  def message(), do: @message
end

defmodule PlantNetFixtures do
  @plantnet_raw_response "{\"query\":{\"project\":\"all\",\"images\":[\"https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg\",\"https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg\"],\"organs\":[\"auto\",\"auto\"],\"includeRelatedImages\":false,\"noReject\":false},\"language\":\"en\",\"preferedReferential\":\"k-world-flora\",\"bestMatch\":\"Prunus cerasifera Ehrh.\",\"results\":[{\"score\":0.87871,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus cerasifera\",\"scientificNameAuthorship\":\"Ehrh.\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Cherry plum, myrobalan\",\"Cherry Plum\",\"Purple-leaf Plum\"],\"scientificName\":\"Prunus cerasifera Ehrh.\"},\"gbif\":{\"id\":\"3021730\"},\"powo\":{\"id\":\"729568-1\"},\"iucn\":{\"id\":\"172162\",\"category\":\"DD\"}},{\"score\":0.31668,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus × cistena\",\"scientificNameAuthorship\":\"N.E.Hansen ex Koehne\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Dwarf red-leaf plum\",\"Purple-leaf sand cherry\",\"Purple-leaved sand cherry\"],\"scientificName\":\"Prunus × cistena N.E.Hansen ex Koehne\"},\"gbif\":{\"id\":\"3022465\"},\"powo\":{\"id\":\"2959315-4\"}},{\"score\":0.01801,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus sargentii\",\"scientificNameAuthorship\":\"Rehder\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Sargent's cherry\",\"Northern Japanese hill cherry\",\"Sargent’s cherry\"],\"scientificName\":\"Prunus sargentii Rehder\"},\"gbif\":{\"id\":\"3020955\"},\"powo\":{\"id\":\"730239-1\"},\"iucn\":{\"id\":\"64127603\",\"category\":\"LC\"}},{\"score\":0.00896,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus × yedoensis\",\"scientificNameAuthorship\":\"Matsum.\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Yoshino cherry\",\"Hybrid cherry\",\"Korean flowering cherry\"],\"scientificName\":\"Prunus × yedoensis Matsum.\"},\"gbif\":{\"id\":\"3021335\"},\"powo\":{\"id\":\"30119904-2\"}},{\"score\":0.00518,\"species\":{\"scientificNameWithoutAuthor\":\"Prunus serrulata\",\"scientificNameAuthorship\":\"Lindl.\",\"genus\":{\"scientificNameWithoutAuthor\":\"Prunus\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Prunus\"},\"family\":{\"scientificNameWithoutAuthor\":\"Rosaceae\",\"scientificNameAuthorship\":\"\",\"scientificName\":\"Rosaceae\"},\"commonNames\":[\"Japanese flowering cherry\",\"Japanese flowering cherry Kwanzan\",\"Tibetan Cherry\"],\"scientificName\":\"Prunus serrulata Lindl.\"},\"gbif\":{\"id\":\"3022609\"},\"powo\":{\"id\":\"730268-1\"},\"iucn\":{\"id\":\"217170511\",\"category\":\"LC\"}}],\"version\":\"2024-11-19 (7.3)\",\"remainingIdentificationRequests\":488}"

  @plantnet_parsed_response %{
    "bestMatch" => "Prunus cerasifera Ehrh.",
    "language" => "en",
    "preferedReferential" => "k-world-flora",
    "query" => %{
      "images" => [
        "https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg",
        "https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg"
      ],
      "includeRelatedImages" => false,
      "noReject" => false,
      "organs" => ["auto", "auto"],
      "project" => "all"
    },
    "remainingIdentificationRequests" => 488,
    "results" => [
      %{
        "gbif" => %{"id" => "3021730"},
        "iucn" => %{"category" => "DD", "id" => "172162"},
        "powo" => %{"id" => "729568-1"},
        "score" => 0.87871,
        "species" => %{
          "commonNames" => ["Cherry plum, myrobalan", "Cherry Plum", "Purple-leaf Plum"],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus cerasifera Ehrh.",
          "scientificNameAuthorship" => "Ehrh.",
          "scientificNameWithoutAuthor" => "Prunus cerasifera"
        }
      },
      %{
        "gbif" => %{"id" => "3022465"},
        "powo" => %{"id" => "2959315-4"},
        "score" => 0.31668,
        "species" => %{
          "commonNames" => [
            "Dwarf red-leaf plum",
            "Purple-leaf sand cherry",
            "Purple-leaved sand cherry"
          ],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus × cistena N.E.Hansen ex Koehne",
          "scientificNameAuthorship" => "N.E.Hansen ex Koehne",
          "scientificNameWithoutAuthor" => "Prunus × cistena"
        }
      },
      %{
        "gbif" => %{"id" => "3020955"},
        "iucn" => %{"category" => "LC", "id" => "64127603"},
        "powo" => %{"id" => "730239-1"},
        "score" => 0.01801,
        "species" => %{
          "commonNames" => [
            "Sargent's cherry",
            "Northern Japanese hill cherry",
            "Sargent’s cherry"
          ],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus sargentii Rehder",
          "scientificNameAuthorship" => "Rehder",
          "scientificNameWithoutAuthor" => "Prunus sargentii"
        }
      },
      %{
        "gbif" => %{"id" => "3021335"},
        "powo" => %{"id" => "30119904-2"},
        "score" => 0.00896,
        "species" => %{
          "commonNames" => ["Yoshino cherry", "Hybrid cherry", "Korean flowering cherry"],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus × yedoensis Matsum.",
          "scientificNameAuthorship" => "Matsum.",
          "scientificNameWithoutAuthor" => "Prunus × yedoensis"
        }
      },
      %{
        "gbif" => %{"id" => "3022609"},
        "iucn" => %{"category" => "LC", "id" => "217170511"},
        "powo" => %{"id" => "730268-1"},
        "score" => 0.00518,
        "species" => %{
          "commonNames" => [
            "Japanese flowering cherry",
            "Japanese flowering cherry Kwanzan",
            "Tibetan Cherry"
          ],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus serrulata Lindl.",
          "scientificNameAuthorship" => "Lindl.",
          "scientificNameWithoutAuthor" => "Prunus serrulata"
        }
      }
    ],
    "version" => "2024-11-19 (7.3)"
  }

  @plantnet_parsed_response_filtered_by_score %{
    "bestMatch" => "Prunus cerasifera Ehrh.",
    "language" => "en",
    "preferedReferential" => "k-world-flora",
    "query" => %{
      "images" => [
        "https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg",
        "https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg"
      ],
      "includeRelatedImages" => false,
      "noReject" => false,
      "organs" => ["auto", "auto"],
      "project" => "all"
    },
    "remainingIdentificationRequests" => 488,
    "results" => [
      %{
        "gbif" => %{"id" => "3021730"},
        "iucn" => %{"category" => "DD", "id" => "172162"},
        "powo" => %{"id" => "729568-1"},
        "score" => 0.87871,
        "species" => %{
          "commonNames" => ["Cherry plum, myrobalan", "Cherry Plum", "Purple-leaf Plum"],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus cerasifera Ehrh.",
          "scientificNameAuthorship" => "Ehrh.",
          "scientificNameWithoutAuthor" => "Prunus cerasifera"
        }
      },
      %{
        "gbif" => %{"id" => "3022465"},
        "powo" => %{"id" => "2959315-4"},
        "score" => 0.31668,
        "species" => %{
          "commonNames" => [
            "Dwarf red-leaf plum",
            "Purple-leaf sand cherry",
            "Purple-leaved sand cherry"
          ],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus × cistena N.E.Hansen ex Koehne",
          "scientificNameAuthorship" => "N.E.Hansen ex Koehne",
          "scientificNameWithoutAuthor" => "Prunus × cistena"
        }
      }
    ],
    "version" => "2024-11-19 (7.3)"
  }

  @plantnet_parsed_response_filtered_by_score_no_iucn %{
    "bestMatch" => "Prunus cerasifera Ehrh.",
    "language" => "en",
    "preferedReferential" => "k-world-flora",
    "query" => %{
      "images" => [
        "https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg",
        "https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg"
      ],
      "includeRelatedImages" => false,
      "noReject" => false,
      "organs" => ["auto", "auto"],
      "project" => "all"
    },
    "remainingIdentificationRequests" => 488,
    "results" => [
      %{
        "gbif" => %{"id" => "3021730"},
        "powo" => %{"id" => "729568-1"},
        "score" => 0.87871,
        "species" => %{
          "commonNames" => ["Cherry plum, myrobalan", "Cherry Plum", "Purple-leaf Plum"],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus cerasifera Ehrh.",
          "scientificNameAuthorship" => "Ehrh.",
          "scientificNameWithoutAuthor" => "Prunus cerasifera"
        }
      },
      %{
        "gbif" => %{"id" => "3022465"},
        "powo" => %{"id" => "2959315-4"},
        "score" => 0.31668,
        "species" => %{
          "commonNames" => [
            "Dwarf red-leaf plum",
            "Purple-leaf sand cherry",
            "Purple-leaved sand cherry"
          ],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus × cistena N.E.Hansen ex Koehne",
          "scientificNameAuthorship" => "N.E.Hansen ex Koehne",
          "scientificNameWithoutAuthor" => "Prunus × cistena"
        }
      }
    ],
    "version" => "2024-11-19 (7.3)"
  }

  @plantnet_parsed_response_with_urls %{
    "bestMatch" => "Prunus cerasifera Ehrh.",
    "language" => "en",
    "preferedReferential" => "k-world-flora",
    "query" => %{
      "images" => [
        "https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg",
        "https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg"
      ],
      "includeRelatedImages" => false,
      "noReject" => false,
      "organs" => ["auto", "auto"],
      "project" => "all"
    },
    "remainingIdentificationRequests" => 488,
    "results" => [
      %{
        "gbif" => %{"id" => "3021730"},
        "gbif_url" => "https://www.gbif.org/species/3021730",
        "iucn" => %{"category" => "DD", "id" => "172162"},
        "pfaf_url" => "https://pfaf.org/user/Plant.aspx?LatinName=/Prunus+cerasifera",
        "powo" => %{"id" => "729568-1"},
        "powo_url" => "https://powo.science.kew.org/taxon/729568-1",
        "score" => 0.87871,
        "species" => %{
          "commonNames" => ["Cherry plum, myrobalan", "Cherry Plum", "Purple-leaf Plum"],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus cerasifera Ehrh.",
          "scientificNameAuthorship" => "Ehrh.",
          "scientificNameWithoutAuthor" => "Prunus cerasifera"
        }
      },
      %{
        "gbif" => %{"id" => "3022465"},
        "gbif_url" => "https://www.gbif.org/species/3022465",
        "pfaf_url" => "https://pfaf.org/user/Plant.aspx?LatinName=/Prunus+×+cistena",
        "powo" => %{"id" => "2959315-4"},
        "powo_url" => "https://powo.science.kew.org/taxon/2959315-4",
        "score" => 0.31668,
        "species" => %{
          "commonNames" => [
            "Dwarf red-leaf plum",
            "Purple-leaf sand cherry",
            "Purple-leaved sand cherry"
          ],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus × cistena N.E.Hansen ex Koehne",
          "scientificNameAuthorship" => "N.E.Hansen ex Koehne",
          "scientificNameWithoutAuthor" => "Prunus × cistena"
        }
      }
    ],
    "version" => "2024-11-19 (7.3)"
  }

  @plantnet_parsed_response_with_urls_no_iucn %{
    "bestMatch" => "Prunus cerasifera Ehrh.",
    "language" => "en",
    "preferedReferential" => "k-world-flora",
    "query" => %{
      "images" => [
        "https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg",
        "https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg"
      ],
      "includeRelatedImages" => false,
      "noReject" => false,
      "organs" => ["auto", "auto"],
      "project" => "all"
    },
    "remainingIdentificationRequests" => 488,
    "results" => [
      %{
        "gbif" => %{"id" => "3021730"},
        "gbif_url" => "https://www.gbif.org/species/3021730",
        "pfaf_url" => "https://pfaf.org/user/Plant.aspx?LatinName=/Prunus+cerasifera",
        "powo" => %{"id" => "729568-1"},
        "powo_url" => "https://powo.science.kew.org/taxon/729568-1",
        "score" => 0.87871,
        "species" => %{
          "commonNames" => ["Cherry plum, myrobalan", "Cherry Plum", "Purple-leaf Plum"],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus cerasifera Ehrh.",
          "scientificNameAuthorship" => "Ehrh.",
          "scientificNameWithoutAuthor" => "Prunus cerasifera"
        }
      },
      %{
        "gbif" => %{"id" => "3022465"},
        "gbif_url" => "https://www.gbif.org/species/3022465",
        "pfaf_url" => "https://pfaf.org/user/Plant.aspx?LatinName=/Prunus+×+cistena",
        "powo" => %{"id" => "2959315-4"},
        "powo_url" => "https://powo.science.kew.org/taxon/2959315-4",
        "score" => 0.31668,
        "species" => %{
          "commonNames" => [
            "Dwarf red-leaf plum",
            "Purple-leaf sand cherry",
            "Purple-leaved sand cherry"
          ],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus × cistena N.E.Hansen ex Koehne",
          "scientificNameAuthorship" => "N.E.Hansen ex Koehne",
          "scientificNameWithoutAuthor" => "Prunus × cistena"
        }
      }
    ],
    "version" => "2024-11-19 (7.3)"
  }

  @plantnet_parsed_response_with_urls_no_alternatives %{
    "bestMatch" => "Prunus cerasifera Ehrh.",
    "language" => "en",
    "preferedReferential" => "k-world-flora",
    "query" => %{
      "images" => [
        "https://upload.wikimedia.org/wikipedia/commons/f/ff/Prunus_cerasifera_A.jpg",
        "https://le-jardin-de-pascal.com/2195113-large_default/prunus-cerasifera-atropurpurea-prunier-myrobolan-nigra.jpg"
      ],
      "includeRelatedImages" => false,
      "noReject" => false,
      "organs" => ["auto", "auto"],
      "project" => "all"
    },
    "remainingIdentificationRequests" => 488,
    "results" => [
      %{
        "gbif" => %{"id" => "3021730"},
        "gbif_url" => "https://www.gbif.org/species/3021730",
        "iucn" => %{"category" => "DD", "id" => "172162"},
        "pfaf_url" => "https://pfaf.org/user/Plant.aspx?LatinName=/Prunus+cerasifera",
        "powo" => %{"id" => "729568-1"},
        "powo_url" => "https://powo.science.kew.org/taxon/729568-1",
        "score" => 0.87871,
        "species" => %{
          "commonNames" => [],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus cerasifera Ehrh.",
          "scientificNameAuthorship" => "Ehrh.",
          "scientificNameWithoutAuthor" => "Prunus cerasifera"
        }
      },
      %{
        "gbif" => %{"id" => "3022465"},
        "gbif_url" => "https://www.gbif.org/species/3022465",
        "pfaf_url" => "https://pfaf.org/user/Plant.aspx?LatinName=/Prunus+×+cistena",
        "powo" => %{"id" => "2959315-4"},
        "powo_url" => "https://powo.science.kew.org/taxon/2959315-4",
        "score" => 0.31668,
        "species" => %{
          "commonNames" => [
            "Dwarf red-leaf plum",
            "Purple-leaf sand cherry",
            "Purple-leaved sand cherry"
          ],
          "family" => %{
            "scientificName" => "Rosaceae",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Rosaceae"
          },
          "genus" => %{
            "scientificName" => "Prunus",
            "scientificNameAuthorship" => "",
            "scientificNameWithoutAuthor" => "Prunus"
          },
          "scientificName" => "Prunus × cistena N.E.Hansen ex Koehne",
          "scientificNameAuthorship" => "N.E.Hansen ex Koehne",
          "scientificNameWithoutAuthor" => "Prunus × cistena"
        }
      }
    ],
    "version" => "2024-11-19 (7.3)"
  }

  def raw_response, do: @plantnet_raw_response
  def parsed_response, do: @plantnet_parsed_response
  def parsed_response_filtered_by_score, do: @plantnet_parsed_response_filtered_by_score
  def parsed_response_with_urls, do: @plantnet_parsed_response_with_urls

  def plantnet_parsed_response_filtered_by_score_no_iucn,
    do: @plantnet_parsed_response_filtered_by_score_no_iucn

  def parsed_response_with_urls_no_iucn, do: @plantnet_parsed_response_with_urls_no_iucn

  def parsed_response_with_urls_no_alternatives,
    do: @plantnet_parsed_response_with_urls_no_alternatives
end
