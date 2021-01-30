name = "[SW]托托莉Totooria"
description =
  [[托托莉.赫尔蒙德  阿兰德的炼金术师
初始智商高，血量低，攻击力低
吃聪明豆升级，吃龙人心洗点
不同的等级能自动学到不同的生存特技
可以读书，可以制造更多的物品
自带托托莉的法杖，可以升级
高级的法杖能有更多的用处
]]
author = "柴柴"
version = "1.9.0"

forumthread = ""

api_version = 6

dont_starve_compatible = true
reign_of_giants_compatible = true
dst_compatible = false
shipwrecked_compatible = true

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options = {
  {
    name = "Language",
    label = "语言Language",
    options = {
      {description = "English", data = false},
      {description = "简体中文", data = true}
    },
    default = true
  },
  {
    name = "Sound",
    label = "托托莉声音Sound",
    options = {
      {description = "Wendy", data = false},
      {description = "Willow", data = true}
    },
    default = true
  },
  {
    name = "TotooriaSpeech",
    label = "托托莉对话Speech",
    options = {
      {description = "Wilson", data = 1},
      {description = "Willow", data = 2},
      {description = "Walani", data = 3},
      {description = "Wigfrid", data = 4},
      {description = "Wickerbottom", data = 5}
    },
    default = 1
  },
  {
    name = "Hack",
    label = "法杖当砍刀Hack",
    options = {
      {description = "Yes", data = true},
      {description = "No", data = false}
    },
    default = false
  },
  {
    name = "Dig",
    label = "法杖当铲子Dig",
    options = {
      {description = "Yes", data = true},
      {description = "No", data = false}
    },
    default = false
  },
  {
    name = "Hammer",
    label = "法杖当锤子Hammer",
    options = {
      {description = "Yes", data = true},
      {description = "No", data = false}
    },
    default = true
  }
}
