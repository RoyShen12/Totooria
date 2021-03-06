local assets = {
  Asset("ANIM", "anim/totooriastaff.zip"),
  Asset("ANIM", "anim/swap_totooriastaff.zip"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff3.xml")
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
  -- 实际暴击率 = 5% + 幸运百分数/500。50%幸运=15%暴击；400%幸运=85%暴击; >475%幸运=满暴击；满暴击后击中恢复溢出暴击等值生命
  local critChance = 20 * attacker.xingyun + 5
  if critChance > 100 then
    attacker.components.health:DoDelta(critChance - 100)
    attacker.components.sanity:DoDelta(1)
  end
  if target.components.combat then
    if math.random(0, 100) > (100 - critChance) then
      target.components.combat:GetAttacked(attacker, 42 * 3, inst)
      attacker.components.talker:Say("触发 3 倍暴击！")
    end
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

  inst:AddComponent("weapon")
  inst.components.weapon:SetDamage(42)
  inst.components.weapon:SetRange(5, 6)
  inst.components.weapon:SetOnAttack(onattack)

  inst:AddComponent("inspectable")

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff3.xml"

  inst:AddComponent("equippable")
  inst.components.equippable:SetOnEquip(onequip)
  inst.components.equippable:SetOnUnequip(onunequip)
  --加速
  inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT * 1
  inst.components.equippable.dapperness = TUNING.CRAZINESS_MED / 4

  return inst
end

return Prefab("common/inventory/totooriastaff3", fn, assets, prefabs)
