--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Glubtok", {36, 2849}, 89)
if not mod then return end
mod:RegisterEnableMob(47162) -- Glubtok
mod:SetEncounterID(mod:Classic() and 1064 or {2976, 2981}) -- Classic, Retail Normal, Retail Heroic
mod:SetRespawnTime(30)
mod:SetStage(1)

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Stage One: Fists of Flame and Frost
		87859, -- Fists of Flame
		87861, -- Fists of Frost
		-- Stage Two: Arcane Power!
		88009, -- Arcane Power
	}, {
		[87859] = -2010, -- Stage One: Fists of Flame and Frost
		[88009] = -2014, -- Stage Two: Arcane Power!
	}
end

function mod:OnBossEnable()
	if self:Retail() then
		if self:Difficulty() == 232 then -- Dastardly Duos
			-- no encounter events in Dastardly Duos
			self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
			self:Death("Win", 47162) -- Glubtok
		else
			-- no ENCOUNTER_END on a win in Retail since 11.0.5
			self:Death("Win", 47162) -- Glubtok
		end
	end

	-- Stage One: Fists of Flame and Frost
	self:Log("SPELL_CAST_START", "FistsOfFlame", 87859)
	self:Log("SPELL_CAST_START", "FistsOfFrost", 87861)

	-- Stage Two: Arcane Power!
	self:Log("SPELL_CAST_SUCCESS", "ArcanePower", 88009)
end

function mod:OnEngage()
	self:SetStage(1)
	self:CDBar(87859, 6.0) -- Fists of Flame
	self:CDBar(87861, 19.4) -- Fists of Frost
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Stage One: Fists of Flame and Frost

function mod:FistsOfFlame(args)
	self:Message(args.spellId, "red")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 26.7)
end

function mod:FistsOfFrost(args)
	self:Message(args.spellId, "yellow")
	self:PlaySound(args.spellId, "alert")
	self:CDBar(args.spellId, 26.7)
end

-- Stage Two: Arcane Power!

function mod:ArcanePower(args)
	self:StopBar(87859) -- Fists of Flame
	self:StopBar(87861) -- Fists of Frost
	self:SetStage(2)
	self:Message(args.spellId, "cyan", CL.percent:format(50, args.spellName))
	self:PlaySound(args.spellId, "long")
end
