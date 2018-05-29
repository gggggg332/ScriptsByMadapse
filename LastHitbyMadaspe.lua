
local LastHit = {}
LastHit.optionEnable =  Menu.AddOptionBool({"ScriptsByMadaspe", "LastHit"}, "False", false)
LastHit.optionKey = Menu.AddKeyOption({"ScriptsByMadaspe", "LastHit"}, "LastHit Key", Enum.ButtonCode.KEY_O)
local t1 = nil
local t2 = nil
function LastHit.OnUpdate()
	if not Menu.IsEnabled(optionEnable) then return end
	if not Menu.IsKeyDown(key) then return end
	local myHero = Heroes.GetLocal()
	if not myHero then return 	end
	local range = NPC.GetAttackRange(myHero)
	local target
	if t2 and Entity.IsAlive(t2) and not Entity.IsDormant(t2) and NPC.IsEntityInRange(myHero, t2, range) then t1 = t2 end
    if t1 and Entity.IsAlive(t1) and not Entity.IsDormant(t1) and NPC.IsEntityInRange(myHero, t1, range) then t1 = t1 end
	if target then Player.AttackTarget(Players.GetLocal(), myHero, target) end
end
function LastHit.OnDraw()
	if not Menu.IsEnabled(optionEnable) then return end  
	local myHero = Heroes.GetLocal()
	if not myHero then return end
	if not NPC.IsVisible(myHero) then return end
	local radius = 1000
	local creeps = NPC.GetUnitsInRadius(myHero, radius, Enum.TeamType.TEAM_ENEMY)
	for i, npc in ipairs(creeps) do
		local oneHitDamage = LastHit.GetOneHitDamageVersus(myHero, npc)
		if NPC.IsCreep(npc) and Entity.IsAlive(npc) and not Entity.IsDormant(npc) then
			local x, y, visible = Renderer.WorldToScreen(Entity.GetAbsOrigin(npc))
			local size = 10
			if Entity.GetHealth(npc) <= oneHitDamage then
				Renderer.SetDrawColor(255, 0, 0, 150)
				Renderer.DrawFilledRect(x-size, y-size, 2*size, 2*size)
				t1 = npc
			elseif Entity.GetHealth(npc) <= 1.5 * oneHitDamage then
				Renderer.SetDrawColor(255, 255, 0, 150)
				Renderer.DrawFilledRect(x-size, y-size, 2*size, 2*size)
				t1 = npc
			end
		end
	end
end
function LastHit.GetOneHitDamageVersus(myHero, npc)
	if not myHero or not npc then return 0 end
	local damage = NPC.GetTrueDamage(myHero) * NPC.GetArmorDamageMultiplier(npc)
	return damage
end



return LastHit