local cooking = require("cooking")

local Stewer =
  Class(
  function(self, inst)
    self.inst = inst
    self.cooking = false
    self.done = false

    self.product = nil
    self.product_spoilage = nil
    self.recipes = nil
    self.default_recipe = nil
    self.spoiledproduct = "spoiledfood"
    self.maketastyfood = nil

    self.min_num_for_cook = 4
    self.max_num_for_cook = 4

    self.cookername = nil

    -- stuff to make warly's special recipes possible
    self.specialcookername = nil -- a special cookername to check first before falling back to cookername default
    self.productcooker = nil -- hold on to the cookername that is cooking the current product

    self.inst:AddTag("stewer")
  end
)

local function dospoil(inst)
  if inst.components.stewer and inst.components.stewer.onspoil then
    inst.components.stewer.onspoil(inst)
  end

  if inst.components.stewer.spoiltask then
    inst.components.stewer.spoiltask:Cancel()
    inst.components.stewer.spoiltask = nil
    inst.components.stewer.spoiltargettime = nil
  end
end

local function dostew(inst)
  local stewercmp = inst.components.stewer
  stewercmp.task = nil

  if stewercmp.ondonecooking then
    stewercmp.ondonecooking(inst)
  end

  if stewercmp.product ~= nil then
    local cooker = stewercmp.productcooker or (stewercmp.cookername or stewercmp.inst.prefab)
    local prep_perishtime =
      (cooking.recipes and cooking.recipes[cooker] and cooking.recipes[cooker][stewercmp.product] and
      cooking.recipes[cooker][stewercmp.product].perishtime) and
      cooking.recipes[cooker][stewercmp.product].perishtime or
      GLOBAL.TUNING.PERISH_SUPERFAST
    local prod_spoil = stewercmp.product_spoilage or 1
    stewercmp.spoiltime = prep_perishtime * prod_spoil
    stewercmp.spoiltargettime = GetTime() + stewercmp.spoiltime
    stewercmp.spoiltask =
      stewercmp.inst:DoTaskInTime(
      stewercmp.spoiltime,
      function(inst)
        if inst.components.stewer and inst.components.stewer.onspoil then
          inst.components.stewer.onspoil(inst)
        end
      end
    )
  end

  stewercmp.done = true
  stewercmp.cooking = nil
end

function Stewer:SetCookerName(_name)
  self.cookername = _name
end

function Stewer:GetTimeToCook()
  if self.cooking then
    return self.targettime - GetTime()
  end
  return 0
end

function Stewer:CanCook()
  local num = 0
  for k, v in pairs(self.inst.components.container.slots) do
    num = num + 1
  end
  return num >= self.min_num_for_cook and num <= self.max_num_for_cook
end

function Stewer:StartCooking()
  if not self.done and not self.cooking then
    if self.inst.components.container then
      self.done = nil
      self.cooking = true

      if self.onstartcooking then
        self.onstartcooking(self.inst)
      end

      local spoilage_total = 0
      local spoilage_n = 0
      local ings = {}
      for k, v in pairs(self.inst.components.container.slots) do
        table.insert(ings, v.prefab)
        if v.components.perishable then
          spoilage_n = spoilage_n + 1
          spoilage_total = spoilage_total + v.components.perishable:GetPercent()
        end
      end
      self.product_spoilage = 1
      if spoilage_total > 0 then
        self.product_spoilage = spoilage_total / spoilage_n
        self.product_spoilage = 1 - (1 - self.product_spoilage) * .5
      end

      local foundthespecial = false
      local cooktime = 1
      if self.specialcookername then
        -- check special first
        if cooking.ValidRecipe(self.specialcookername, ings) then
          self.product, cooktime = cooking.CalculateRecipe(self.specialcookername, ings)
          self.productcooker = self.specialcookername
          foundthespecial = true
        end
      end

      if not foundthespecial then
        -- fallback to regular cooking
        local cooker = self.cookername or self.inst.prefab
        self.product, cooktime = cooking.CalculateRecipe(cooker, ings)
        self.productcooker = cooker
      end

      local grow_time = GLOBAL.TUNING.BASE_COOK_TIME * cooktime
      self.targettime = GetTime() + grow_time
      self.task = self.inst:DoTaskInTime(grow_time, dostew, "stew")

      self.inst.components.container:Close()
      self.inst.components.container:DestroyContents()
      self.inst.components.container.canbeopened = false
    end
  end
end

function Stewer:OnSave()
  local time = GetTime()
  if self.cooking then
    local data = {}
    data.cooking = true
    data.product = self.product
    data.productcooker = self.productcooker
    data.product_spoilage = self.product_spoilage
    if self.targettime and self.targettime > time then
      data.time = self.targettime - time
    end
    return data
  elseif self.done then
    local data = {}
    data.product = self.product
    data.productcooker = self.productcooker
    data.product_spoilage = self.product_spoilage
    if self.spoiltargettime and self.spoiltargettime > time then
      data.spoiltime = self.spoiltargettime - time
    end
    data.timesincefinish = -(GetTime() - (self.targettime or 0))
    data.done = true
    return data
  end
end

function Stewer:OnLoad(data)
  --self.produce = data.produce
  if data.cooking then
    self.product = data.product
    self.productcooker = data.productcooker or (self.cookername or self.inst.prefab)
    if self.oncontinuecooking then
      local time = data.time or 1
      self.product_spoilage = data.product_spoilage or 1
      self.oncontinuecooking(self.inst)
      self.cooking = true
      self.targettime = GetTime() + time
      self.task = self.inst:DoTaskInTime(time, dostew, "stew")

      if self.inst.components.container then
        self.inst.components.container.canbeopened = false
      end
    end
  elseif data.done then
    self.product_spoilage = data.product_spoilage or 1
    self.done = true
    self.targettime = data.timesincefinish
    self.product = data.product
    self.productcooker = data.productcooker or (self.cookername or self.inst.prefab)
    if self.oncontinuedone then
      self.oncontinuedone(self.inst)
    end
    self.spoiltargettime = data.spoiltime and GetTime() + data.spoiltime or nil
    if self.spoiltargettime then
      self.spoiltask =
        self.inst:DoTaskInTime(
        data.spoiltime,
        function(inst)
          if inst.components.stewer and inst.components.stewer.onspoil then
            inst.components.stewer.onspoil(inst)
          end
        end
      )
    end
    if self.inst.components.container then
      self.inst.components.container.canbeopened = false
    end
  end
end

function Stewer:GetDebugString()
  local str = nil

  if self.cooking then
    str = "COOKING"
  elseif self.done then
    str = "FULL"
  else
    str = "EMPTY"
  end
  if self.targettime then
    str = str .. " (" .. tostring(self.targettime - GetTime()) .. ")"
  end

  if self.product then
    str = str .. " " .. self.product
  end

  if self.product_spoilage then
    str = str .. "(" .. self.product_spoilage .. ")"
  end

  return str
end

function Stewer:CollectSceneActions(doer, actions, right)
  if not self.inst:HasTag("burnt") then
    if self.done then
      table.insert(actions, ACTIONS.HARVEST)
    elseif right and self:CanCook() then
      table.insert(actions, ACTIONS.COOK)
    end
  end
end

function Stewer:IsDone()
  return self.done
end

function Stewer:StopCooking(reason)
  if self.task then
    self.task:Cancel()
    self.task = nil
  end
  if self.spoiltask then
    self.spoiltask:Cancel()
    self.spoiltask = nil
  end
  if self.product and reason and reason == "fire" then
    local prod = SpawnPrefab(self.product)
    if prod then
      prod.Transform:SetPosition(self.inst.Transform:GetWorldPosition())
      prod:DoTaskInTime(
        0,
        function(prod)
          prod.Physics:Stop()
        end
      )
    end
  end
  self.product = nil
  self.targettime = nil
end

function Stewer:Harvest(harvester)
  if self.done then
    if self.onharvest then
      self.onharvest(self.inst)
    end
    self.done = nil
    if self.product then
      if harvester and harvester.components.inventory then
        local loot = nil
        if self.product ~= "spoiledfood" then
          loot = SpawnPrefab(self.product)

          if loot and loot.components.perishable then
            loot.components.perishable:SetPercent(self.product_spoilage)
            loot.components.perishable:LongUpdate(GetTime() - self.targettime)
            loot.components.perishable:StartPerishing()
          end
        else
          loot = SpawnPrefab("spoiled_food")
        end

        if loot then
          loot.targetMoisture = 0
          loot:DoTaskInTime(
            2 * FRAMES,
            function()
              if loot.components.moisturelistener then
                loot.components.moisturelistener.moisture = loot.targetMoisture
                loot.targetMoisture = nil
                loot.components.moisturelistener:DoUpdate()
              end
            end
          )
          harvester.components.inventory:GiveItem(SpawnPrefab(self.product))
          if GetPlayer().prefab == "totooria" and GetPlayer():HasTag("teji_dachu") then
            harvester.components.inventory:GiveItem(SpawnPrefab(self.product))
          end
        end
      end
      self.product = nil
      self.spoiltargettime = nil

      if self.spoiltask then
        self.spoiltask:Cancel()
        self.spoiltask = nil
      end
    end

    if self.inst.components.container and not self.inst:HasTag("flooded") then
      self.inst.components.container.canbeopened = true
    end

    return true
  end
end

function Stewer:LongUpdate(dt)
  if not self.paused and self.targettime ~= nil then
    if self.task ~= nil then
      self.task:Cancel()
      self.task = nil
    end

    self.targettime = self.targettime - dt

    if self.cooking then
      local time_to_wait = self.targettime - GetTime()
      if time_to_wait < 0 then
        dostew(self.inst)
      else
        self.task = self.inst:DoTaskInTime(time_to_wait, dostew, "stew")
      end
    end
  end

  if self.spoiltask ~= nil then
    self.spoiltask:Cancel()
    self.spoiltask = nil
    self.spoiltargettime = self.spoiltargettime - dt
    local time_to_wait = self.spoiltargettime - GetTime()
    if time_to_wait <= 0 then
      dospoil(self.inst)
    else
      self.spoiltask = self.inst:DoTaskInTime(time_to_wait, dospoil)
    end
  end
end

return Stewer
