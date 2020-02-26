local assets = {
  Asset("ANIM", "anim/totooriastaff5orange.zip"),
  Asset("ANIM", "anim/swap_totooriastaff5orange.zip"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff5orange.xml")
}

local prefabs = {}

local function onequip(inst, owner)
  owner.AnimState:OverrideSymbol("swap_object", "swap_totooriastaff5orange", "swap_totooriastaff5orange")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")

  --装备上后顺风
  if GetWorld().components.worldwind then
    owner.ramp_fn = function()
      inst.SoundEmitter:PlaySound("dontstarve_DLC002/common/sail_stick")
    end
    owner:ListenForEvent("wind_rampup", owner.ramp_fn, GetWorld())
    owner.sail_stick_update =
      owner:DoPeriodicTask(
      FRAMES,
      function()
        GetWorld().components.worldwind:SetOverrideAngle(GetPlayer().Transform:GetRotation())
      end
    )
  end
end

local function onunequip(inst, owner)
  owner.AnimState:Hide("ARM_carry")
  owner.AnimState:Show("ARM_normal")

  --卸下后取消顺风
  if GetWorld().components.worldwind then
    if owner.ramp_fn then
      owner:RemoveEventCallback("wind_rampup", owner.ramp_fn, GetWorld())
      owner.ramp_fn = nil
    end
    GetWorld().components.worldwind:SetOverrideAngle(nil)
    owner.sail_stick_update:Cancel()
    owner.sail_stick_update = nil
  end
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
      target.components.combat:GetAttacked(attacker, 60 * 8, inst)
      attacker.components.talker:Say("触发 8 倍暴击！！！")
    end
  end

  if target.components.freezable then
    target.components.freezable:AddColdness(1)
    target.components.freezable:SpawnShatterFX()
  end
end

local function fn()
  local inst = CreateEntity()
  local trans = inst.entity:AddTransform()
  local anim = inst.entity:AddAnimState()
  MakeInventoryPhysics(inst)

  if IsDLCEnabled(CAPY_DLC) then
    MakeInventoryFloatable(inst, "idle_water", "idle")
  end

  anim:SetBank("totooriastaff5orange")
  anim:SetBuild("totooriastaff5orange")
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
  inst.components.weapon:SetProjectile("ice_projectile")
  inst.components.weapon:SetOnAttack(onattack)

  inst:AddComponent("inspectable")

  inst:AddComponent("blinkstaff")
  --瞬移杖效果

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff5orange.xml"

  inst:AddComponent("equippable")
  inst.components.equippable:SetOnEquip(onequip)
  inst.components.equippable:SetOnUnequip(onunequip)
  --加速
  inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT * 1.25
  inst.components.equippable.dapperness = TUNING.CRAZINESS_MED / 4 * 3

  return inst
end

return Prefab("common/inventory/totooriastaff5orange", fn, assets, prefabs)
