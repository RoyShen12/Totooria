local assets = {
  Asset("ANIM", "anim/totooriastaff.zip"),
  Asset("ANIM", "anim/swap_totooriastaff.zip"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff1.xml")
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

  inst:AddTag("irreplaceable")

  inst:AddComponent("weapon")
  inst.components.weapon:SetDamage(27)
  -- inst.components.weapon:SetOnAttack(onattack)

  inst:AddComponent("inspectable")

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff1.xml"

  inst:AddComponent("equippable")
  inst.components.equippable:SetOnEquip(onequip)
  inst.components.equippable:SetOnUnequip(onunequip)

  return inst
end

return Prefab("common/inventory/totooriastaff1", fn, assets, prefabs)
