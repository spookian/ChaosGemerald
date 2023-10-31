local chaos_EmeraldPowerFunctions = {}

function chaos_GoHyper(player)
	if (player.powers[pw_super] == 0) then
		player.powers[pw_super] = 1	
	end
	player.chaos.hyper = true
	-- idk put some kind of transformation trigger here
end

function chaos_JumpSpin(player)
	-- check for hyper
	local can_super = true
	if (player.rings >= 100 and !player.hyper and can_super) then
		chaos_GoHyper(player)
		return true
	else if (player.powers[pw_super] != 0) then -- cancel super
		chaos_CancelSuper(player)
		return true
	end
	return false;
end

function chaos_PlayerCmd(player, cmd)
	if player.chaos.disable_inputs then
		return true
	end
	-- custom 1 will execute current function pointer
	return false
end

function chaos_InitObject()
	local chaos = {}

	chaos.hyper = false
	chaos.disable_inputs = false
	chaos.aura_mobjs = {} 

	return chaos	
end

function chaos_ClearObject(chaos)
	chaos.hyper = false
	chaos.disable_inputs = false

	for i,v in ipairs(chaos.aura_mobjs) do
		chaos.aura_mobjs[i] = nil -- i'm sure srb2 clears all mobjs whenever this needs to be cleared	
	end
end

function chaos_BurstEmeraldPower(chaos)
end

function chaos_UpdateAfterimageSprite(mobj, player)
	mobj.skin = player.mo.skin
	mobj.sprite = player.mo.sprite
	mobj.frame = player.mo.frame
	mobj.tics = player.mo.tics

	mobj.x = player.mo.x
	mobj.y = player.mo.y
	mobj.z = player.mo.z
end

function chaos_SuperSonic2Aura(player) -- red flickering outline and lightning
-- this function uses two out of who knows how many mobjs in the table
	local mobj_table = player.chaos.aura_mobjs
	
	if (mobj_table[1] == nil) then
		local aura_obj = P_SpawnMobj(player_mobj.x, player_mobj.y, player.mobj.z, MT_GHOST)
		--chaos_UpdateAfterimageSprite(aura_obj, player)
		aura_obj.color = 
		mobj_table[1] = aura_obj

	end

	if (mobj_table[2] == nil) then
		local aura_obj = P_SpawnMobj(player_mobj.x, player_mobj.y, player.mobj.z, MT_GHOST)
		chaos_UpdateAfterimageSprite(aura_obj, player)
		mobj_table[2] = aura_obj
	end

	-- both mobjs take the current 
	chaos_UpdateAfterimageSprite(mobj_table[1], player)
	chaos_UpdateAfterimageSprite(mobj_table[2], player)
end

function chaos_HyperSonicAura(player) -- lots of sparkles and holy glitter stuff. maybe flowers pop up?
end

function chaos_HyperTailsAura(player) -- super flickies circling around player. purely cosmetic.
end

function chaos_ClearAura(chaos) -- ONLY USE THIS IN NORMAL PLAY
	for i,v in ipairs(chaos.aura_mobjs) do
		P_RemoveMobj(chaos.aura_mobjs[i])
		chaos.aura_mobjs[i] = nil
	end
end

function chaos_PlayerThink(player)
	-- aura functions
end


-- hook section
addHook("PlayerThink", chaos_PlayerThink)
addHook("JumpSpinSpecial", chaos_JumpSpin)