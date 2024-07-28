PrefabFiles = {
  "totooria",
  "totooriastaff1",
  "totooriastaff2",
  "totooriastaff3",
  "totooriastaff4",
  "totooriastaff5green",
  "totooriastaff5orange",
  "totooriastaff5yellow"
}

Assets = {
  Asset("IMAGE", "images/saveslot_portraits/totooria.tex"),
  Asset("ATLAS", "images/saveslot_portraits/totooria.xml"),
  Asset("IMAGE", "images/selectscreen_portraits/totooria.tex"),
  Asset("ATLAS", "images/selectscreen_portraits/totooria.xml"),
  Asset("IMAGE", "images/selectscreen_portraits/totooria_silho.tex"),
  Asset("ATLAS", "images/selectscreen_portraits/totooria_silho.xml"),
  Asset("IMAGE", "bigportraits/totooria.tex"),
  Asset("ATLAS", "bigportraits/totooria.xml"),
  Asset("IMAGE", "images/map_icons/totooria.tex"),
  Asset("ATLAS", "images/map_icons/totooria.xml"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff1.xml"),
  Asset("IMAGE", "images/inventoryimages/totooriastaff1.tex"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff2.xml"),
  Asset("IMAGE", "images/inventoryimages/totooriastaff2.tex"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff3.xml"),
  Asset("IMAGE", "images/inventoryimages/totooriastaff3.tex"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff4.xml"),
  Asset("IMAGE", "images/inventoryimages/totooriastaff4.tex"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff5green.xml"),
  Asset("IMAGE", "images/inventoryimages/totooriastaff5green.tex"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff5orange.xml"),
  Asset("IMAGE", "images/inventoryimages/totooriastaff5orange.tex"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff5yellow.xml"),
  Asset("IMAGE", "images/inventoryimages/totooriastaff5yellow.tex")
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local GetPlayer = GLOBAL.GetPlayer

local LAN_ = GetModConfigData("Language")

GLOBAL.TUNING.TOTOORIA = {}
if LAN_ then
  require "strings_ttr_c"
else
  require "strings_ttr_e"
end

local function totooriastab(inst)
  inst:AddComponent("reader")

  local ttrstab = { str = "ttrstab", sort = 999, icon = "tab_book.tex" }
  inst.components.builder:AddRecipeTab(ttrstab)

  local totooriastaff1 =
      Recipe(
        "totooriastaff1",
        { Ingredient("twigs", 4), Ingredient("goldnugget", 2), Ingredient("redgem", 1) },
        ttrstab,
        { SCIENCE = 0 }
      )
  totooriastaff1.atlas = "images/inventoryimages/totooriastaff1.xml"

  local totooriastaff2 =
      Recipe(
        "totooriastaff2",
        {
          Ingredient("totooriastaff1", 1, "images/inventoryimages/totooriastaff1.xml"),
          Ingredient("goldnugget", 6),
          Ingredient("flint", 6)
        },
        ttrstab,
        { SCIENCE = 0 }
      )
  totooriastaff2.atlas = "images/inventoryimages/totooriastaff2.xml"

  local totooriastaff3 =
      Recipe(
        "totooriastaff3",
        {
          Ingredient("totooriastaff2", 1, "images/inventoryimages/totooriastaff2.xml"),
          Ingredient("goldnugget", 4),
          Ingredient("cane", 1)
        },
        ttrstab,
        { SCIENCE = 0 }
      )
  totooriastaff3.atlas = "images/inventoryimages/totooriastaff3.xml"

  local totooriastaff4 =
      Recipe(
        "totooriastaff4",
        {
          Ingredient("totooriastaff3", 1, "images/inventoryimages/totooriastaff3.xml"),
          Ingredient("goldnugget", 6),
          Ingredient("icestaff", 1)
        },
        ttrstab,
        { SCIENCE = 0 }
      )
  totooriastaff4.atlas = "images/inventoryimages/totooriastaff4.xml"

  local totooriastaff5green =
      Recipe(
        "totooriastaff5green",
        {
          Ingredient("totooriastaff4", 1, "images/inventoryimages/totooriastaff4.xml"),
          Ingredient("greenstaff", 1),
          Ingredient("coral_brain", 1)
        },
        ttrstab,
        { SCIENCE = 0 }
      )
  totooriastaff5green.atlas = "images/inventoryimages/totooriastaff5green.xml"

  local totooriastaff5orange =
      Recipe(
        "totooriastaff5orange",
        {
          Ingredient("totooriastaff4", 1, "images/inventoryimages/totooriastaff4.xml"),
          Ingredient("orangestaff", 1),
          Ingredient("sail_stick", 1)
        },
        ttrstab,
        { SCIENCE = 0 }
      )
  totooriastaff5orange.atlas = "images/inventoryimages/totooriastaff5orange.xml"

  local totooriastaff5yellow =
      Recipe(
        "totooriastaff5yellow",
        {
          Ingredient("totooriastaff4", 1, "images/inventoryimages/totooriastaff4.xml"),
          Ingredient("yellowstaff", 1),
          Ingredient("dragoonheart", 1)
        },
        ttrstab,
        { SCIENCE = 0 }
      )
  totooriastaff5yellow.atlas = "images/inventoryimages/totooriastaff5yellow.xml"

  Recipe(
    "book_birds",
    { Ingredient("papyrus", 2), Ingredient("bird_egg", 2) },
    ttrstab,
    { SCIENCE = 0, MAGIC = 0, ANCIENT = 0 }
  )
  Recipe(
    "book_gardening",
    { Ingredient("papyrus", 2), Ingredient("seeds", 1), Ingredient("poop", 1) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe("book_sleep", { Ingredient("papyrus", 2), Ingredient("nightmarefuel", 2) }, ttrstab, { MAGIC = 0 })
  Recipe("book_brimstone", { Ingredient("papyrus", 2), Ingredient("redgem", 1) }, ttrstab, { MAGIC = 0 })
  if GLOBAL.IsDLCEnabled(GLOBAL.CAPY_DLC) then
    Recipe("book_meteor", { Ingredient("papyrus", 2), Ingredient("obsidian", 2) }, ttrstab, { MAGIC = 0 })
  else
    Recipe("book_tentacles", { Ingredient("papyrus", 2), Ingredient("tentaclespots", 1) }, ttrstab, { MAGIC = 0 })
  end

  Recipe("dubloon", { Ingredient("rocks", 2) }, ttrstab, { SCIENCE = 0 })
  Recipe("spoiled_food", { Ingredient("sand", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe("rottenegg", { Ingredient("bird_egg", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe("beardhair", { Ingredient("silk", 4) }, ttrstab, { SCIENCE = 0 })
  Recipe("petals_evil", { Ingredient("petals", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe("cutreeds", { Ingredient("cutgrass", 1), Ingredient("palmleaf", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe("bioluminescence", { Ingredient("ice", 1), Ingredient("sand", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe("houndstooth", { Ingredient("boneshard", 2) }, ttrstab, { SCIENCE = 0 })
  Recipe("hail_ice", { Ingredient("sand", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe("snakeskin", { Ingredient("vine", 2), Ingredient("fabric", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe("pigskin", { Ingredient("razor", 1), Ingredient("meat", 2) }, ttrstab, { SCIENCE = 0 })
  Recipe("venomgland", { Ingredient("spidergland", 3) }, ttrstab, { SCIENCE = 0 })
  Recipe("tentaclespots", { Ingredient("silk", 4), Ingredient("fabric", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe("livinglog", { Ingredient("log", 2), Ingredient("wetgoop", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe(
    "mandrake",
    { Ingredient("sweet_potato", 1), Ingredient("wetgoop", 1), Ingredient("palmleaf", 5) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe("lureplantbulb", { Ingredient("papyrus", 4), Ingredient("plantmeat", 1) }, ttrstab, { SCIENCE = 0 })
  Recipe(
    "spidereggsack",
    { Ingredient("silk", 12), Ingredient("spidergland", 8), Ingredient("papyrus", 2) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "gears",
    { Ingredient("flint", 4), Ingredient("limestone", 4), Ingredient("goldnugget", 4) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "redgem",
    { Ingredient("feather_robin", 4), Ingredient("ice", 4), Ingredient("goldnugget", 4) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "bluegem",
    { Ingredient("feather_robin_winter", 4), Ingredient("ice", 4), Ingredient("goldnugget", 4) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe("obsidian", { Ingredient("nitre", 1), Ingredient("goldnugget", 2) }, ttrstab, { SCIENCE = 0 })
  Recipe(
    "cane",
    { Ingredient("goldnugget", 2), Ingredient("twigs", 1), Ingredient("magic_seal", 1) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "trident",
    { Ingredient("pitchfork", 1), Ingredient("goldnugget", 4), Ingredient("magic_seal", 1) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "greenamulet",
    { Ingredient("goldnugget", 4), Ingredient("obsidian", 4), Ingredient("seaweed", 8) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "orangeamulet",
    { Ingredient("goldnugget", 4), Ingredient("obsidian", 4), Ingredient("seashell", 8) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "yellowamulet",
    { Ingredient("goldnugget", 4), Ingredient("obsidian", 4), Ingredient("nightmarefuel", 8) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "greenstaff",
    { Ingredient("livinglog", 2), Ingredient("obsidian", 4), Ingredient("seaweed", 8) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "orangestaff",
    { Ingredient("livinglog", 2), Ingredient("obsidian", 4), Ingredient("seashell", 8) },
    ttrstab,
    { SCIENCE = 0 }
  )
  Recipe(
    "yellowstaff",
    { Ingredient("livinglog", 2), Ingredient("obsidian", 4), Ingredient("nightmarefuel", 8) },
    ttrstab,
    { SCIENCE = 0 }
  )
end
--让角色可以带书但其他角色无效
local books = { "book_birds", "book_gardening", "book_sleep", "book_brimstone", "book_tentacles", "book_meteor" }
for k, v in pairs(books) do
  AddPrefabPostInit(
    v,
    function(inst)
      if inst.components.characterspecific and GetPlayer() and GetPlayer().prefab == "totooria" then
        inst.components.characterspecific:SetOwner("totooria")
      end
    end
  )
end

local function RecheckForThreat(inst) --让蝴蝶、鸟等不会逃离
  local busy = inst.sg:HasStateTag("sleeping") or inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("flying")
  if not busy then
    local threat =
        GLOBAL.FindEntity(inst, 5, nil, nil, { "notarget", "teji_youshan" }, { "player", "monster", "scarytoprey" })
    return threat ~= nil
  end
end

AddStategraphPostInit(
  "bird",
  function(sg) --让蝴蝶、鸟等不会逃离2
    local old = sg.events.flyaway.fn
    sg.events.flyaway.fn = function(inst)
      if RecheckForThreat(inst) then
        old(inst)
      end
    end
  end
)

if GetModConfigData("Sound") == true then
  GLOBAL.TUNING.ttrsound = "willow"
end
if GetModConfigData("Sound") == false then
  GLOBAL.TUNING.ttrsound = "wendy"
end

if GetModConfigData("TotooriaSpeech") == 1 then
  STRINGS.CHARACTERS.TOTOORIA = require "speech_wilson"
end
if GetModConfigData("TotooriaSpeech") == 2 then
  STRINGS.CHARACTERS.TOTOORIA = require "speech_willow"
end
if GetModConfigData("TotooriaSpeech") == 3 then
  STRINGS.CHARACTERS.TOTOORIA = require "speech_walani"
end
if GetModConfigData("TotooriaSpeech") == 4 then
  STRINGS.CHARACTERS.TOTOORIA = require "speech_wathgrithr"
end
if GetModConfigData("TotooriaSpeech") == 5 then
  STRINGS.CHARACTERS.TOTOORIA = require "speech_wickerbottom"
end

if GetModConfigData("Hack") == true then
  GLOBAL.TUNING.canhack = 1
end
if GetModConfigData("Dig") == true then
  GLOBAL.TUNING.candig = 1
end
if GetModConfigData("Hammer") == true then
  GLOBAL.TUNING.canhammer = 1
end

-- Custom speech strings
--STRINGS.CHARACTERS.TOTOORIA = require "speech_walani"

-- Let the game know character is male, female, or robot
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "totooria")

AddMinimapAtlas("images/map_icons/totooria.xml")
AddModCharacter("totooria")

AddPrefabPostInit("totooria", totooriastab)

modimport("totooria_util/totooria_util.lua")
