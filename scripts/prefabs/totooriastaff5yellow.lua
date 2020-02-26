local assets = {
  Asset("ANIM", "anim/totooriastaff5yellow.zip"),
  Asset("ANIM", "anim/swap_totooriastaff5yellow.zip"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff5yellow.xml")
}

local prefabs = {}

local function turnon(inst)
  inst.Light:Enable(true)
  if not inst.SoundEmitter:PlayingSound("torch") then
    inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_LP", "torch")
  end
  inst.SoundEmitter:PlaySound("dontstarve/wilson/torch_swing")
  TUNING.lightabc = 1
end

local function turnoff(inst)
  inst.Light:Enable(false)
  inst.SoundEmitter:KillSound("torch")
  inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
  TUNING.lightabc = 0
end

local function OnDropped(inst)
  if TUNING.lightabc == 1 then
    inst.Light:Enable(true)
  else
    inst.Light:Enable(false)
  end
end

local function OnPutInInventory(inst)
  if TUNING.lightabc == 1 then
    inst.Light:Enable(true)
  else
    inst.Light:Enable(false)
  end
end

local function onequip(inst, owner)
  owner.AnimState:OverrideSymbol("swap_object", "swap_totooriastaff5yellow", "swap_totooriastaff5yellow")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
  owner.AnimState:Hide("ARM_carry")
  owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target)
  if target.prefab == "twister" then
  end

  --加入冰杖效果
  inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/obsidian_wetsizzles")

  if not target:IsValid() then
    return
  end

  if target.components.sleeper and target.components.sleeper:IsAsleep() then
    target.components.sleeper:WakeUp()
  end
  if target.components.burnable then
    if target.components.burnable:IsBurning() then
      target.components.burnable:Extinguish()
    elseif target.components.burnable:IsSmoldering() then
      target.components.burnable:SmotherSmolder()
    end
  end

  if target.sg ~= nil and not target.sg:HasStateTag("frozen") then
    target:PushEvent("attacked", {attacker = attacker, damage = 0})
  end

  if target.components.combat then
    if math.random(0, 100) > 92 then
      -- target:PushEvent("attacked", { attacker = attacker, damage = 300 })
      target.components.combat:GetAttacked(attacker, 60 * 9, inst)
      attacker.components.talker:Say("触发 9 倍暴击！！！")
    end
  end

  if target.components.freezable then
    target.components.freezable:AddColdness(1)
    target.components.freezable:SpawnShatterFX()
  end
end

local function fn()
  TUNING.lightabc = 1
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  local anim = inst.entity:AddAnimState()
  MakeInventoryPhysics(inst)

  if IsDLCEnabled(CAPY_DLC) then
    MakeInventoryFloatable(inst, "idle_water", "idle")
  end

  anim:SetBank("totooriastaff5yellow")
  anim:SetBuild("totooriastaff5yellow")
  anim:PlayAnimation("idle")
  --多用工具
  inst:AddComponent("tool")
  inst.components.tool:SetAction(ACTIONS.CHOP, 2.5)
  inst.components.tool:SetAction(ACTIONS.MINE, 2)
  if TUNING.canhammer == 1 then
    inst.components.tool:SetAction(ACTIONS.HAMMER, 15)
  end
  if TUNING.canhack == 1 then
    inst.components.tool:SetAction(ACTIONS.HACK, 2)
  end
  if TUNING.candig == 1 then
    inst.components.tool:SetAction(ACTIONS.DIG, 2)
  end

  inst:AddTag("irreplaceable")
  --加入冰杖攻击音效
  inst:AddTag("icestaff")
  inst:AddTag("extinguisher")

  inst:AddComponent("weapon")
  inst.components.weapon:SetDamage(60)
  inst.components.weapon:SetRange(12, 14)
  --加入冰杖攻击音效2
  inst.components.weapon:SetProjectile("ice_projectile")
  inst.components.weapon:SetOnAttack(onattack)

  inst:AddComponent("inspectable")

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff5yellow.xml"

  -- 让物品不需要装备就能发光，丢地上也能发光
  local light = inst.entity:AddLight()
  light:SetFalloff(0.7)
  light:SetIntensity(.5)
  light:SetRadius(8)
  light:SetColour(255 / 255, 255 / 255, 235 / 255)
  --十胜石工具的光色
  light:Enable(true)
  inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
  inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
  inst.components.inventoryitem:SetOnPutInInventoryFn(OnPutInInventory)

  inst:AddComponent("equippable")
  inst.components.equippable:SetOnEquip(onequip)
  inst.components.equippable:SetOnUnequip(onunequip)

  inst.components.equippable.togglable = true
  inst.components.equippable.toggledonfn = turnon
  inst.components.equippable.toggledofffn = turnoff

  --加速
  inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT * 1.25
  inst.components.equippable.dapperness = TUNING.CRAZINESS_MED / 4 * 3

  return inst
end

return Prefab("common/inventory/totooriastaff5yellow", fn, assets, prefabs)
