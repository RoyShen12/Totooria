local MakePlayerCharacter = require "prefabs/player_common"
local ttrstrs = STRINGS.TTRSTRINGS

local assets = {
  Asset("ANIM", "anim/player_basic.zip"),
  Asset("ANIM", "anim/player_idles_shiver.zip"),
  Asset("ANIM", "anim/player_actions.zip"),
  Asset("ANIM", "anim/player_actions_axe.zip"),
  Asset("ANIM", "anim/player_actions_pickaxe.zip"),
  Asset("ANIM", "anim/player_actions_shovel.zip"),
  Asset("ANIM", "anim/player_actions_blowdart.zip"),
  Asset("ANIM", "anim/player_actions_eat.zip"),
  Asset("ANIM", "anim/player_actions_item.zip"),
  Asset("ANIM", "anim/player_actions_uniqueitem.zip"),
  Asset("ANIM", "anim/player_actions_bugnet.zip"),
  Asset("ANIM", "anim/player_actions_fishing.zip"),
  Asset("ANIM", "anim/player_actions_boomerang.zip"),
  Asset("ANIM", "anim/player_bush_hat.zip"),
  Asset("ANIM", "anim/player_attacks.zip"),
  Asset("ANIM", "anim/player_idles.zip"),
  Asset("ANIM", "anim/player_rebirth.zip"),
  Asset("ANIM", "anim/player_jump.zip"),
  Asset("ANIM", "anim/player_amulet_resurrect.zip"),
  Asset("ANIM", "anim/player_teleport.zip"),
  Asset("ANIM", "anim/wilson_fx.zip"),
  Asset("ANIM", "anim/player_one_man_band.zip"),
  Asset("ANIM", "anim/shadow_hands.zip"),
  Asset("SOUND", "sound/sfx.fsb"),
  Asset("SOUND", "sound/wilson.fsb"),
  Asset("ANIM", "anim/beard.zip"),
  Asset("ANIM", "anim/totooria.zip")
}
local prefabs = {
  "totooriastaff1"
}

-- Custom starting items
local start_inv = {
  "totooriastaff1",
  "goldnugget",
  "goldnugget",
  "goldnugget",
  "goldnugget",
  "goldnugget",
  "goldnugget"
}

local function GainOnLvup(inst) --升级自动加的属性
  local max_jiacheng = 20
  local jiacheng = math.min(inst.dengji, max_jiacheng)
  local sanity_percent = inst.components.sanity:GetPercent()
  inst.components.sanity.max = math.ceil(200 + jiacheng * 10) --400
  -- 恢复 50% 精神
  inst.components.sanity:SetPercent(math.min(1, sanity_percent + 0.5))
  inst.components.sanity.dapperness = GLOBAL.TUNING.DAPPERNESS_HUGE / 18 * jiacheng
  -- 恢复 25% 生命
  inst.components.health:SetPercent(math.min(1, inst.components.health:GetPercent() + 0.25))
  -- 恢复 5% 饥饿
  inst.components.hunger:SetPercent(math.min(1, inst.components.hunger:GetPercent() + 0.05))
end

local MaxLevel = 2000

local function LevelUp(inst)
  if inst.dengji < MaxLevel then
    inst.dengji = inst.dengji + 1
    inst.jinengdian = inst.jinengdian + 3
    GainOnLvup(inst)
    inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")

    if inst.dengji == 5 then
      inst:AddTag("teji_youshan")
      inst:RemoveTag("scarytoprey")
      inst.components.talker:Say(
        ttrstrs[1] .. "\n" .. ttrstrs[2] .. "\n" .. ttrstrs[6] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
      )
    elseif inst.dengji == 10 then
      inst:AddTag("teji_dachu")
      inst.components.talker:Say(
        ttrstrs[1] .. "\n" .. ttrstrs[3] .. "\n" .. ttrstrs[6] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
      )
    elseif inst.dengji == 15 then
      inst:AddTag("teji_qiaoshou")
      inst.components.talker:Say(
        ttrstrs[1] .. "\n" .. ttrstrs[4] .. "\n" .. ttrstrs[6] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
      )
    elseif inst.dengji == 20 then
      inst:AddTag("teji_xuezhe")
      inst.components.talker:Say(
        ttrstrs[1] .. "\n" .. ttrstrs[5] .. "\n" .. ttrstrs[6] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
      )
    else
      inst.components.talker:Say(
        ttrstrs[1] .. "\n" .. ttrstrs[6] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
      )
    end
  end

  if inst:HasTag("teji_xuezhe") then
    inst.components.builder.science_bonus = 3
    inst.components.builder.magic_bonus = 3
    inst.components.builder.ancient_bonus = 4
    inst.components.builder.obsidian_bonus = 2
  else
    inst.components.builder.science_bonus = 0
    inst.components.builder.magic_bonus = 0
    inst.components.builder.ancient_bonus = 0
    inst.components.builder.obsidian_bonus = 0
  end
end

local function xidian(inst)
  if inst.dengji < 5 then
    inst.components.talker:Say(ttrstrs[9])
  else
    inst.dengji = inst.dengji - 5
    GainOnLvup(inst)
    inst.jinengdian = inst.dengji
    inst.xingyun = 0
    inst.gongjili = 0
    inst.components.combat:AddDamageModifier("wendy", 0.075 * inst.gongjili)
    inst.xueliang = 0
    local health_percent = inst.components.health:GetPercent()
    inst.components.health.maxhealth = 75 + inst.xueliang * 125 / 20
    inst.components.health:SetPercent(health_percent)
    inst.sudu = 0
    inst.components.locomotor.walkspeed = 4 + inst.sudu / 20 * 2
    inst.components.locomotor.runspeed = 6 + inst.sudu / 20 * 3
    if inst.dengji >= 10 and inst.dengji < 15 then
      inst:RemoveTag("teji_qiaoshou")
      inst.components.talker:Say(
        ttrstrs[10] ..
        "\n" ..
        ttrstrs[11] ..
        "\n" ..
        ttrstrs[15] .. (inst.dengji) .. ttrstrs[16] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
      )
    else
      if inst.dengji >= 5 and inst.dengji < 10 then
        inst:RemoveTag("teji_dachu")
        inst.components.talker:Say(
          ttrstrs[10] ..
          "\n" ..
          ttrstrs[12] ..
          "\n" ..
          ttrstrs[15] .. (inst.dengji) .. ttrstrs[16] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
        )
      else
        if inst.dengji >= 0 and inst.dengji < 5 then
          inst:RemoveTag("teji_youshan")
          inst:AddTag("scarytoprey")
          inst.components.talker:Say(
            ttrstrs[10] ..
            "\n" ..
            ttrstrs[13] ..
            "\n" ..
            ttrstrs[15] .. (inst.dengji) .. ttrstrs[16] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
          )
        else
          if inst.dengji == 15 then
            inst:RemoveTag("teji_xuezhe")
            inst.components.talker:Say(
              ttrstrs[10] ..
              "\n" ..
              ttrstrs[14] ..
              "\n" ..
              ttrstrs[15] ..
              (inst.dengji) .. ttrstrs[16] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
            )
          else
            inst.components.talker:Say(
              ttrstrs[10] ..
              "\n" ..
              ttrstrs[15] .. (inst.dengji) .. ttrstrs[16] .. (inst.jinengdian) .. ttrstrs[7] .. "\n" .. ttrstrs[8]
            )
          end
        end
      end
    end
  end
  if inst:HasTag("teji_xuezhe") then
    inst.components.builder.science_bonus = 3
    inst.components.builder.magic_bonus = 3
    inst.components.builder.ancient_bonus = 4
    inst.components.builder.obsidian_bonus = 2
  else
    inst.components.builder.science_bonus = 0
    inst.components.builder.magic_bonus = 0
    inst.components.builder.ancient_bonus = 0
    inst.components.builder.obsidian_bonus = 0
  end
end

local function onkilledother(inst, data)
  --打怪升级，1级的几率是20%，最小不小于1%
  if math.random() < math.max(0.2 / inst.dengji, 0.01) then
    LevelUp(inst)
  end

  --根据幸运值打怪掉金币
  local victim = data.victim

  if victim.components.lootdropper and (victim.components.freezable or victim:HasTag("monster")) then
    if inst.xingyun >= 1 then
      -- 掉落 1-[幸运] 个金币
      for k = 1, math.random(1, math.floor(inst.xingyun + 0.5)) do
        victim.components.lootdropper:SpawnLootPrefab("dubloon")
      end
    else
      -- 有几率掉落 1 个金币
      if math.random() < inst.xingyun then
        victim.components.lootdropper:SpawnLootPrefab("dubloon")
      end
    end
  end
end

local function oneat(inst, food)
  if food and food.components.edible then
    if food.prefab == "coral_brain" then      -- 吃聪明豆必定升级
      LevelUp(inst)
    elseif food.prefab == "mandrakesoup" then -- 吃曼德拉草汤升5级
      for k = 1, 5 do
        LevelUp(inst)
      end
    elseif food.prefab == "dragoonheart" then                      -- 吃龙人心洗点，惩罚是降低5级
      xidian(inst)
    elseif math.random() < math.max(0.1 / inst.dengji, 0.001) then -- 吃任何东西都有几率升级
      LevelUp(inst)
    end
  end
end

local function onpreload(inst, data)
  if data then
    if data.dengji then
      inst.dengji = data.dengji
    else
      inst.dengji = 0
    end

    if data.jinengdian then
      inst.jinengdian = data.jinengdian
    else
      inst.jinengdian = 0
    end

    if data.xingyun then
      inst.xingyun = data.xingyun
    else
      inst.xingyun = 0
    end

    if data.gongjili then
      inst.gongjili = data.gongjili
    else
      inst.gongjili = 0
    end

    inst.components.combat:AddDamageModifier("wendy", 0.075 * inst.gongjili)

    if data.xueliang then
      inst.xueliang = data.xueliang
    else
      inst.xueliang = 0
    end

    local health_percent = inst.components.health:GetPercent()
    inst.components.health.maxhealth = 75 + inst.xueliang * 125 / 20
    inst.components.health:SetPercent(health_percent)

    if data.sudu then
      inst.sudu = data.sudu
    else
      inst.sudu = 0
    end
    inst.components.locomotor.walkspeed = 4 + inst.sudu / 20 * 2
    inst.components.locomotor.runspeed = 6 + inst.sudu / 20 * 3

    GainOnLvup(inst)

    if inst.dengji == 20 then
      inst:AddTag("teji_xuezhe")
    end
    if inst.dengji >= 15 then
      inst:AddTag("teji_qiaoshou")
    end
    if inst.dengji >= 10 then
      inst:AddTag("teji_dachu")
    end
    if inst.dengji >= 5 then
      inst:AddTag("teji_youshan")
      inst:RemoveTag("scarytoprey")
    end
  end
  if inst:HasTag("teji_xuezhe") then
    inst.components.builder.science_bonus = 3
    inst.components.builder.magic_bonus = 3
    inst.components.builder.ancient_bonus = 4
    inst.components.builder.obsidian_bonus = 2
  else
    inst.components.builder.science_bonus = 0
    inst.components.builder.magic_bonus = 0
    inst.components.builder.ancient_bonus = 0
    inst.components.builder.obsidian_bonus = 0
  end
end

local function onsave(inst, data)
  data.dengji = inst.dengji
  data.jinengdian = inst.jinengdian
  data.xingyun = inst.xingyun
  data.gongjili = inst.gongjili
  data.xueliang = inst.xueliang
  data.sudu = inst.sudu
end

local master_postinit = function(inst)
  inst.soundsname = GLOBAL.TUNING.ttrsound

  inst.MiniMapEntity:SetIcon("totooria.tex")
  inst.dengji = 0
  inst.jinengdian = 0
  inst.xingyun = 0
  inst.gongjili = 0
  inst.xueliang = 0
  inst.sudu = 0

  inst.components.eater:SetOnEatFn(oneat)

  GainOnLvup(inst)
  -- Stats
  inst.components.health:SetMaxHealth(75)
  inst.components.hunger:SetMax(250)
  inst.components.sanity:SetMax(200)

  -- Damage multiplier (optional)
  -- inst.components.combat.damagemultiplier = 0.7
  inst.components.combat:AddDamageModifier("wilson", -0.25)

  -- Hunger rate (optional)
  inst.components.hunger.hungerrate = 1.1 * GLOBAL.TUNING.WILSON_HUNGER_RATE

  -- Movement speed (optional)
  inst.components.locomotor.walkspeed = 4
  inst.components.locomotor.runspeed = 6

  inst:ListenForEvent("killed", onkilledother)
  inst.OnSave = onsave
  inst.OnPreLoad = onpreload
end

return MakePlayerCharacter("totooria", prefabs, assets, master_postinit, start_inv)
