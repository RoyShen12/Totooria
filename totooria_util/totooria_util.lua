local GetPlayer = GLOBAL.GetPlayer
local TheInput = GLOBAL.TheInput
local ttrstrs = GLOBAL.STRINGS.TTRSTRINGS

local KEY_J = GLOBAL.KEY_J
local J = function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.jinengdian == 0 then
			player.components.talker:Say(
				ttrstrs[17] ..
					ttrstrs[18] ..
						(player.dengji) ..
							"\n" ..
								ttrstrs[19] ..
									(100 * player.xingyun) ..
										ttrstrs[20] ..
											"\n" ..
												ttrstrs[21] ..
													(5 * player.gongjili) ..
														ttrstrs[20] ..
															"\n" ..
																ttrstrs[22] .. (2.5 * player.sudu) .. ttrstrs[20] .. "\n" .. ttrstrs[23] .. (6.25 * player.xueliang)
			)
		else
			player.components.talker:Say(
				ttrstrs[17] ..
					ttrstrs[18] ..
						(player.dengji) ..
							"\n" ..
								ttrstrs[34] ..
									(player.jinengdian) ..
										"\n" ..
											ttrstrs[19] ..
												(100 * player.xingyun) ..
													ttrstrs[20] ..
														"\n" ..
															ttrstrs[21] ..
																(5 * player.gongjili) ..
																	ttrstrs[20] ..
																		"\n" ..
																			ttrstrs[22] .. (2.5 * player.sudu) .. ttrstrs[20] .. "\n" .. ttrstrs[23] .. (6.25 * player.xueliang)
			)
		end
	end
end

local KEY_UP = GLOBAL.KEY_UP
local UP = function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.jinengdian > 0 then
			player.jinengdian = player.jinengdian - 1
			player.xingyun = player.xingyun + .1
			player.components.talker:Say(ttrstrs[24] .. "\n" .. ttrstrs[25])
		else
			player.components.talker:Say(ttrstrs[26])
		end
	end
end

local KEY_DOWN = GLOBAL.KEY_DOWN
local DOWN = function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.jinengdian > 0 then
			player.jinengdian = player.jinengdian - 1
			player.sudu = player.sudu + 1
			player.components.locomotor.walkspeed = 4 + player.sudu / 20 * 2
			player.components.locomotor.runspeed = 6 + player.sudu / 20 * 3
			player.components.talker:Say(ttrstrs[27] .. "\n" .. ttrstrs[25])
		else
			player.components.talker:Say(ttrstrs[26])
		end
	end
end

local KEY_LEFT = GLOBAL.KEY_LEFT
local LEFT = function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.jinengdian > 0 then
			player.jinengdian = player.jinengdian - 1
			player.gongjili = player.gongjili + 1
			player.components.combat:AddDamageModifier("wendy", .075 * player.gongjili)
			player.components.talker:Say(ttrstrs[28] .. "\n" .. ttrstrs[25])
		else
			player.components.talker:Say(ttrstrs[26])
		end
	end
end

local KEY_RIGHT = GLOBAL.KEY_RIGHT
local RIGHT = function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.jinengdian > 0 then
			player.jinengdian = player.jinengdian - 1
			player.xueliang = player.xueliang + 1
			local health_percent = player.components.health:GetPercent()
			player.components.health.maxhealth = 75 + player.xueliang * 125 / 20
			player.components.health:SetPercent(health_percent)
			player.components.talker:Say(ttrstrs[29] .. "\n" .. ttrstrs[25])
		else
			player.components.talker:Say(ttrstrs[26])
		end
	end
end

local KEY_K = GLOBAL.KEY_K
local K = function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		player.components.talker:Say(
			ttrstrs[6] ..
				(player.jinengdian) ..
					ttrstrs[7] .. "\n" .. ttrstrs[30] .. "\n" .. ttrstrs[31] .. "\n" .. ttrstrs[32] .. "\n" .. ttrstrs[33]
		)
	end
end

local totooria_handlers = {}

AddPlayerPostInit(
	function(inst)
		-- We hack
		inst:DoTaskInTime(
			0,
			function()
				-- We check if the character is ourselves
				-- So if another horo player joins, we don't get the handlers
				if inst == GetPlayer() then
					-- If we are horo
					if inst.prefab == "totooria" then
						-- We create and store the key handlers
						totooria_handlers[0] =
							TheInput:AddKeyDownHandler(
							KEY_J,
							function()
								J(GetPlayer())
							end
						)
						totooria_handlers[1] =
							TheInput:AddKeyDownHandler(
							KEY_UP,
							function()
								UP(GetPlayer())
							end
						)
						totooria_handlers[2] =
							TheInput:AddKeyDownHandler(
							KEY_DOWN,
							function()
								DOWN(GetPlayer())
							end
						)
						totooria_handlers[3] =
							TheInput:AddKeyDownHandler(
							KEY_LEFT,
							function()
								LEFT(GetPlayer())
							end
						)
						totooria_handlers[4] =
							TheInput:AddKeyDownHandler(
							KEY_RIGHT,
							function()
								RIGHT(GetPlayer())
							end
						)
						totooria_handlers[5] =
							TheInput:AddKeyDownHandler(
							KEY_K,
							function()
								K(GetPlayer())
							end
						)
					else
						-- If not, we go to the handlerslist and empty it
						-- This is to avoid having the handlers if we switch characters in wilderness
						-- If it's already empty, nothing changes
						totooria_handlers[0] = nil
						totooria_handlers[1] = nil
						totooria_handlers[2] = nil
						totooria_handlers[3] = nil
						totooria_handlers[4] = nil
						totooria_handlers[5] = nil
					end
				end
			end
		)
	end
)
