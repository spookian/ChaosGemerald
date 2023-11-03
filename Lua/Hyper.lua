-- consider completely reimplementing super form and disabling for all character that support this mode

local function gemerald_UpdateAfterimageSprite(mobj, player)
	mobj.skin = player.mo.skin
	mobj.sprite = player.mo.sprite
	mobj.sprite2 = player.mo.sprite2
	mobj.frame = player.mo.frame
	mobj.tics = player.mo.tics
	mobj.angle = player.drawangle
	
	P_MoveOrigin(mobj, player.mo.x, player.mo.y, player.mo.z)
end

local function gemerald_SS2AuraCreate(player)
	local mobj_table = player.gemerald.aura_mobjs
	local player_mobj = player.mo

	-- create all parts
	for i=1,2 do
		local x = P_SpawnMobj(player_mobj.x, player_mobj.y, player_mobj.z, MT_BUSH)
		x.flags = MF_NOGRAVITY | MF_NOCLIP | MF_NOTHINK
		gemerald_UpdateAfterimageSprite(x, player)
		
		if (i > 2) then 
			x.sprite = SPR_THOK
			x.frame = $ | FF_TRANS90
			x.color = player_mobj.color
			x.colorized = true
			x.blendmode = AST_ADD
		end
		
		x.dispoffset = -i
		mobj_table[i] = x
	end

	-- create outer aura
	local aura_obj = mobj_table[1]
	aura_obj.color = SKINCOLOR_GEMRED
	
	local size = (FRACUNIT * 33) / 30
	aura_obj.spritexscale = size
	aura_obj.spriteyscale = size
 	aura_obj.spriteyoffset = (-FRACUNIT * 3) / 2

	-- create inner aura
	local outer_obj = mobj_table[2]
	outer_obj.color = SKINCOLOR_GEMRED
	
	size = (FRACUNIT * 21) / 20
	outer_obj.spritexscale = size
	outer_obj.spriteyscale = size
 	outer_obj.spriteyoffset = (-FRACUNIT * 3) / 2
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
	player.powers[pw_super] = 0
	gemerald_ClearAura(player.gemerald)
	player.gemerald.hyper = true
	gemerald_SS2AuraCreate(player) -- generic aura creation function

	-- idk put some kind of transformation trigger here
end

local function gemerald_HyperCheck(player)
	-- check for hyper
	local can_super = player.powers[pw_super]
	if (player.rings >= 100 and player.gemerald.hyper == false and can_super) then
		gemerald_GoHyper(player)
		return true
	end
	return false;
end

local function gemerald_SS2AuraUpdate(player) -- red flickering outline and lightning
	local mobj_table = player.gemerald.aura_mobjs
	-- both mobjs take the current 
	gemerald_UpdateAfterimageSprite(mobj_table[1], player)
	mobj_table[1].frame = $ | FF_TRANS60
	
	gemerald_UpdateAfterimageSprite(mobj_table[2], player)
	mobj_table[2].frame = $ | FF_TRANS30
	
	-- red tiny sparkles
end

local function gemerald_HyperSonicAura(player) -- lots of sparkles and holy glitter stuff. maybe flowers pop up?
end

local function gemerald_HyperTailsAura(player) -- super flickies circling around player. purely cosmetic.
	
end

local function gemerald_SS2Palette(player)
	player.mo.color = SKINCOLOR_GEMDUPER1 + abs(((leveltime >> 1) % 9) - 4) -- i took this from the source code
end

local function gemerald_HyperUpdate()
	-- aura local functions
	for player in players.iterate do
		if (player.gemerald) then
			if (player.gemerald.hyper == true) then
				if player.mo.skin == "sonic" then 
					player.mo.eflags = $ | MFE_FORCESUPER 
					player.mo.frame = $ | FF_FULLBRIGHT
				end
				gemerald_SS2AuraUpdate(player)  -- replace with function to process aura
				gemerald_SS2Palette(player)
				
				player.gemerald.hyper_counter = $ + 1
				if (player.gemerald.hyper_counter == 17 + player.gemerald.half_frame) then
					player.rings = $ - 1
					player.gemerald.hyper_counter = 0
					player.gemerald.half_frame = $ ^^ 1 -- boolean flip
				end
				
				if (player.rings == 0 or player.exiting) then 
					player.gemerald.hyper = false
					player.gemerald.hyper_counter = 0
					gemerald_ClearAura(player.gemerald)
					player.mo.color = player.skincolor
					player.mo.eflags = $ & ~MFE_FORCESUPER 
					player.mo.frame = $ & ~FF_FULLBRIGHT
				end
			else
				player.gemerald.hyper_counter = 0
			end
		end
	end
end

-- hook section
addHook("ThinkFrame", gemerald_HyperUpdate)
addHook("JumpSpinSpecial", gemerald_HyperCheck)