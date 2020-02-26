local ttrstrs = STRINGS.TTRSTRINGS

local assets = {
  Asset("ANIM", "anim/totooriastaff5green.zip"),
  Asset("ANIM", "anim/swap_totooriastaff5green.zip"),
  Asset("ATLAS", "images/inventoryimages/totooriastaff5green.xml")
}

local prefabs = {}

local function onequip(inst, owner)
  owner.AnimState:OverrideSymbol("swap_object", "swap_totooriastaff5green", "swap_totooriastaff5green")
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
      target.components.combat:GetAttacked(attacker, 60 * 8, inst)
      attacker.components.talker:Say("触发 8 倍暴击！！！")
    end
  end

  if target.components.freezable then
    target.components.freezable:AddColdness(1)
    target.components.freezable:SpawnShatterFX()
  end
end

local function candestroy(staff, caster, target)
  if not target then
    return false
  end
  return GetRecipe(target.prefab) ~= nil
end

local function destroystructure(staff, target)
  if target.components.inventoryitem then
    local loot1 = SpawnPrefab(target.prefab)
    local pt1 = Point(target.Transform:GetWorldPosition())
    loot1.Transform:SetPosition(pt1.x, pt1.y, pt1.z)
    local angle1 = math.random() * 2 * PI
    loot1.Physics:SetVel(2 * math.cos(angle1), 10, 2 * math.sin(angle1))

    if math.random() < .33 then
      local loot2 = SpawnPrefab(target.prefab)
      local pt2 = Point(target.Transform:GetWorldPosition())
      loot2.Transform:SetPosition(pt2.x, pt2.y, pt2.z)
      local angle2 = (1 - math.random()) * 2 * PI
      loot2.Physics:SetVel(2 * math.cos(angle2), 10, 2 * math.sin(angle2))
    end

    staff.SoundEmitter:PlaySound("dontstarve/common/destroy_tool")

    local caster = staff.components.inventoryitem.owner
    if caster.components.sanity then
      caster.components.sanity:DoDelta(-100)
    end
    if caster.components.health then
      caster.components.health:DoDelta(-40)
    end
    if caster.components.hunger then
      caster.components.hunger:DoDelta(-50)
    end

    staff.SoundEmitter:PlaySound("dontstarve/common/staff_star_dissassemble")

    if target.components.inventory then
      target.components.inventory:DropEverything()
    end

    if target.components.container then
      target.components.container:DropEverything()
    end

    if target.components.stackable then
      --if it's stackable we only want to destroy one of them.
      target = target.components.stackable:Get()
    end

    target:Remove()
  else
    staff.components.inventoryitem.owner.components.talker:Say(ttrstrs[35])
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

  anim:SetBank("totooriastaff5green")
  anim:SetBuild("totooriastaff5green")
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

  inst:AddComponent("spellcaster")
  inst.components.spellcaster.canuseontargets = true
  inst.components.spellcaster.canusefrominventory = false
  inst.components.spellcaster:SetSpellTestFn(candestroy)
  inst.components.spellcaster:SetSpellFn(destroystructure)

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem.atlasname = "images/inventoryimages/totooriastaff5green.xml"

  inst:AddComponent("equippable")
  inst.components.equippable:SetOnEquip(onequip)
  inst.components.equippable:SetOnUnequip(onunequip)
  --加速
  inst.components.equippable.walkspeedmult = TUNING.CANE_SPEED_MULT * 1.25
  inst.components.equippable.dapperness = TUNING.CRAZINESS_MED / 4 * 3

  return inst
end

return Prefab("common/inventory/totooriastaff5green", fn, assets, prefabs)
