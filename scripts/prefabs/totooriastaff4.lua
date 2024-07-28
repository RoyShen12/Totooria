local assets = {
  Asset("ANIM", "anim/totooriastaff.zip"),
  Asset("ANIM", "anim/swap_totooriastaff.zip"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff4.xml")
}

local prefabs = {}

local function onequip(inst, owner)
  owner.AnimState:OverrideSymbol("swap_object", "swap_totooriastaff", "swap_totooriastaff")
  owner.AnimState:Show("ARM_carry")
  owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)
  owner.AnimState:Hide("ARM_carry")
  owner.AnimState:Show("ARM_normal")
end

local function onattack(inst, attacker, target)
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
    target:PushEvent("attacked", { attacker = attacker, damage = 0 })
  end

  -- 实际暴击率 = 5% + 幸运百分数/500。50%幸运=15%暴击；400%幸运=85%暴击; >475%幸运=满暴击；满暴击后击中恢复溢出暴击等值生命
  local critChance = 20 * attacker.xingyun + 5
  if critChance > 100 then
    attacker.components.health:DoDelta(critChance - 100)
    attacker.components.sanity:DoDelta(1)
  end
  if target.components.combat then
    if math.random(0, 100) > (100 - critChance) then
      -- target:PushEvent("attacked", { attacker = attacker, damage = 300 })
      target.components.combat:GetAttacked(attacker, 51 * 6, inst)
      attacker.components.talker:Say("触发 6 倍暴击！！")
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

  anim:SetBank("totooriastaff")
  anim:SetBuild("totooriastaff")
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
  inst.components.weapon:SetDamage(51)
  inst.components.weapon:SetRange(8, 10)
  inst.components.weapon:SetProjectile("ice_projectile")
  inst.components.weapon:SetOnAttack(onattack)

  inst:AddComponent("inspectable")

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff4.xml"

  inst:AddComponent("equippable")
  inst.components.equippable:SetOnEquip(onequip)
  inst.components.equippable:SetOnUnequip(onunequip)
  --加速
  inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT * 1.1
  inst.components.equippable.dapperness = TUNING.CRAZINESS_MED / 2

  return inst
end

return Prefab("common/inventory/totooriastaff4", fn, assets, prefabs)
