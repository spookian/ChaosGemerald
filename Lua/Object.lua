local gemerald_EmeraldPowerFunctions = {}

local function gemerald_InitObject(player)
	local gemerald = {}

	gemerald.hyper = false
	gemerald.hyper_counter = 0
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

local function gemerald_FrameUpdate()
	for player in players.iterate do
		if (player.gemerald == nil) then
			player.gemerald = gemerald_InitObject()
		end
	end
end

addHook("PreThinkFrame", gemerald_FrameUpdate)
