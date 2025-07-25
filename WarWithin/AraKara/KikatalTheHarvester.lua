--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Ki'katal the Harvester", 2660, 2585)
if not mod then return end
mod:RegisterEnableMob(215407) -- Ki'katal the Harvester
mod:SetEncounterID(2901)
mod:SetRespawnTime(30)

--------------------------------------------------------------------------------
-- Locals
--

local nextPoisonCast = 0

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		432117, -- Cosmic Singularity
		{432031, "ME_ONLY"}, -- Grasping Blood
		432130, -- Erupting Webs
		-- Normal / Heroic
		432227, -- Venom Volley
		-- Mythic
		{461487, "DISPEL"}, -- Cultivated Poisons
	}, {
		[432227] = CL.normal.." / "..CL.heroic,
		[461487] = CL.mythic,
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_START", "CosmicSingularity", 432117)
	self:Log("SPELL_AURA_APPLIED", "GraspingBloodApplied", 432031)
	self:Log("SPELL_CAST_START", "EruptingWebs", 432130)

	-- Normal / Heroic
	self:Log("SPELL_CAST_START", "VenomVolley", 432227)

	-- Mythic
	self:Log("SPELL_CAST_START", "CultivatedPoisons", 461487)
	self:Log("SPELL_AURA_APPLIED", "CultivatedPoisonsApplied", 461487)
end

function mod:OnEngage()
	nextPoisonCast = GetTime() + 12.0
	self:CDBar(432130, 6.1) -- Erupting Webs
	if self:Mythic() then
		self:CDBar(461487, 12.0) -- Cultivated Poisons
	else -- Normal, Heroic
		self:CDBar(432227, 12.0) -- Venom Volley
	end
	self:CDBar(432117, 27.9) -- Cosmic Singularity
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:CosmicSingularity(args)
	local t = GetTime()
	self:Message(args.spellId, "cyan")
	if self:Mythic() then
		-- 13.3s minimum to next Cultivated Poisons
		if nextPoisonCast - t < 13.3 then
			nextPoisonCast = t + 13.3
			self:CDBar(461487, {13.3, 21.8}) -- Cultivated Poisons
		end
	else
		-- 7.3s minimum to next Venom Volley
		if nextPoisonCast - t < 7.3 then
			nextPoisonCast = t + 7.3
			self:CDBar(432227, {7.3, 23.0}) -- Venom Volley
		end
	end
	-- 7.3s minimum to next Erupting Webs
	self:CDBar(432130, {7.3, 18.2}) -- Erupting Webs
	self:CDBar(args.spellId, 46.1)
	self:PlaySound(args.spellId, "long")
end

function mod:GraspingBloodApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "info", nil, args.destName)
end

function mod:EruptingWebs(args)
	self:Message(args.spellId, "orange")
	self:CDBar(args.spellId, 18.2)
	self:PlaySound(args.spellId, "alarm")
end

-- Normal / Heroic

function mod:VenomVolley(args)
	nextPoisonCast = GetTime() + 23.0
	self:Message(args.spellId, "red")
	self:CDBar(args.spellId, 23.0)
	self:PlaySound(args.spellId, "alert")
end

-- Mythic

do
	local playerList = {}

	function mod:CultivatedPoisons(args)
		nextPoisonCast = GetTime() + 21.8
		playerList = {}
		self:Message(args.spellId, "red")
		self:CDBar(args.spellId, 21.8)
		self:PlaySound(args.spellId, "alarm")
	end

	function mod:CultivatedPoisonsApplied(args)
		if self:Me(args.destGUID) or self:Dispeller("poison", nil, args.spellId) then
			playerList[#playerList + 1] = args.destName
			self:TargetsMessage(args.spellId, "yellow", playerList, 3)
			self:PlaySound(args.spellId, "info", nil, playerList)
		end
	end
end
