local gemerald_EmeraldPowerFunctions = {}
freeslot("SKINCOLOR_GEMRED")
skincolors[SKINCOLOR_GEMRED] = {
	name = "you're not supposed to use this",
	ramp = {35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35},
	invcolor = SKINCOLOR_RED,
	accessible = false
}

local function gemerald_SS2AuraCreate(player)
	local mobj_table = player.gemerald.aura_mobjs
	local player_mobj = player.mo

	-- create outer aura
	local aura_obj = P_SpawnMobj(player_mobj.x, player_mobj.y, player_mobj.z, MT_SPIKE)
	aura_obj.color = SKINCOLOR_GEMRED
	aura_obj.colorized = true
	aura_obj.flags = $ | MF_NOGRAVITY
	
	local size = (FRACUNIT * 33) / 30
	aura_obj.spritexscale = size
	aura_obj.spriteyscale = size
 	aura_obj.spriteyoffset = (-FRACUNIT * 3) / 2
	aura_obj.dispoffset = -1
	mobj_table[1] = aura_obj

	-- create inner aura
	local outer_obj = P_SpawnMobj(player_mobj.x, player_mobj.y, player_mobj.z, MT_SPIKE)
	outer_obj.color = SKINCOLOR_GEMRED
	outer_obj.colorized = true
	outer_obj.flags = $ | MF_NOGRAVITY
	
	size = (FRACUNIT * 21) / 20
	outer_obj.spritexscale = size
	outer_obj.spriteyscale = size
 	outer_obj.spriteyoffset = (-FRACUNIT * 3) / 2
	outer_obj.dispoffset = -1
	mobj_table[2] = outer_obj
end

local function gemerald_ClearAura(gemerald) -- ONLY USE THIS IN NORMAL PLAY
	for i,v in ipairs(gemerald.aura_mobjs) do
		if (gemerald.aura_mobjs[i] != nil) then
			P_RemoveMobj(gemerald.aura_mobjs[i])
		end
		gemerald.aura_mobjs[i] = nil
	end
end

local function gemerald_GoHyper(player)
	if (player.powers[pw_super] == 0) then
		player.powers[pw_super] = 1	
	end
	gemerald_ClearAura(player.gemerald)
	player.gemerald.hyper = true
	gemerald_SS2AuraCreate(player) -- generic aura creation function

	-- idk put some kind of transformation trigger here
end

local function gemerald_CancelSuper(player)
	player.powers[pw_super] = 0
end

local function gemerald_JumpSpin(player)
	-- check for hyper
	local can_super = player.powers[pw_super] == 1
	if (player.rings >= 100 and player.gemerald.hyper == false and can_super) then
		gemerald_GoHyper(player)
		return true
	end
	return false;
end

local function gemerald_PlayerCmd(player, cmd)
	if player.gemerald.disable_inputs then
		return true
	end
	-- custom 1 will execute current function pointer
	return false
end

local function gemerald_InitObject()
	local gemerald = {}

	gemerald.hyper = false
	gemerald.hyper_counter = -18
	gemerald.disable_inputs = false
	gemerald.aura_mobjs = {} 

	return gemerald	
end

local function gemerald_ClearObject(gemerald)
	gemerald.hyper = false
	gemerald.disable_inputs = false

	for i,v in ipairs(gemerald.aura_mobjs) do
		gemerald.aura_mobjs[i] = nil -- i'm sure srb2 clears all mobjs whenever this needs to be cleared	
	end
end

local function gemerald_BurstEmeraldPower(gemerald)
end

local function gemerald_UpdateAfterimageSprite(mobj, player)
	mobj.skin = player.mo.skin
	mobj.sprite = player.mo.sprite
	mobj.sprite2 = player.mo.sprite2
	mobj.frame = player.mo.frame
	mobj.tics = player.mo.tics
	mobj.angle = player.drawangle

	P_MoveOrigin(mobj, player.mo.x, player.mo.y, player.mo.z)
end

local function gemerald_SS2AuraUpdate(player) -- red flickering outline and lightning
	local mobj_table = player.gemerald.aura_mobjs
	-- both mobjs take the current 
	gemerald_UpdateAfterimageSprite(mobj_table[1], player)
	mobj_table[1].frame = $ | FF_TRANS60
	gemerald_UpdateAfterimageSprite(mobj_table[2], player)
	mobj_table[2].frame = $ | FF_TRANS30
end

local function gemerald_HyperSonicAura(player) -- lots of sparkles and holy glitter stuff. maybe flowers pop up?
end

local function gemerald_HyperTailsAura(player) -- super flickies circling around player. purely cosmetic.
	
end

local function gemerald_ThinkFrame()
	-- aura local functions
	for player in players.iterate do
		if (player.gemerald == nil) then
			player.gemerald = gemerald_InitObject()
		end
		
		if (player.gemerald.hyper) then
			gemerald_SS2AuraUpdate(player)  -- replace with function to process aura
			player.gemerald.hyper_counter = $ + 1
			if (player.gemerald.hyper_counter == 17) then
				player.gemerald.hyper_counter = -18
				player.rings = $ - 1
			end
			
			if (player.powers[pw_super] == 0) then 
				player.gemerald.hyper = false
				player.gemerald.hyper_counter = -18
				gemerald_ClearAura(player.gemerald)
			end
		end
	end
end
-- hook section
addHook("ThinkFrame", gemerald_ThinkFrame)
addHook("JumpSpinSpecial", gemerald_JumpSpin)
