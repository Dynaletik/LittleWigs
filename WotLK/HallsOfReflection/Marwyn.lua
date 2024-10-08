-------------------------------------------------------------------------------
--  Module Declaration

local mod, CL = BigWigs:NewBoss("Marwyn", 668, 602)
if not mod then return end
mod:RegisterEnableMob(38113)
-- Sometimes he resets and then respawns few seconds after instead of
-- respawning immediately, when that happens he doesn't fire ENCOUNTER_END
-- mod:SetEncounterID(mod:Classic() and 839 or 1993)
-- mod:SetRespawnTime(30) -- you have to actually walk towards the altar, nothing will respawn on its own

-------------------------------------------------------------------------------
--  Initialization

function mod:GetOptions()
	return {
		"warmup",
		72363, -- Corrupted Flesh
		{72368, "ICON"}, -- Shared Suffering
		72383, -- Corrupted Touch
	}
end

function mod:OnBossEnable()
	self:Log("SPELL_CAST_SUCCESS", "CorruptedFlesh", 72363)
	self:Log("SPELL_AURA_APPLIED", "SharedSuffering", 72368)
	self:Log("SPELL_AURA_REMOVED", "SharedSufferingRemoved", 72368)
	self:Log("SPELL_AURA_APPLIED", "CorruptedTouch", 72383)
	self:Log("SPELL_AURA_REMOVED", "CorruptedTouchRemoved", 72383)

	if self:Classic() then
		self:CheckForEngage()
	else
		self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")
	end
	self:Death("Win", 38113)
end

function mod:OnEngage()
	if self:Classic() then
		self:CheckForWipe()
	end
end

-------------------------------------------------------------------------------
--  Event Handlers

function mod:Warmup()
	-- There's a 60s break before the 6th wave spawns,
	-- this function is supposed to be called from Falric's OnWin().
	self:Bar("warmup", 59, CL.adds, "achievement_dungeon_icecrown_hallsofreflection")
end

function mod:CorruptedFlesh(args)
	self:Message(args.spellId, "red")
end

function mod:SharedSuffering(args)
	self:PrimaryIcon(args.spellId, args.destName)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	self:TargetBar(args.spellId, 12, args.destName)
end

function mod:SharedSufferingRemoved(args)
	self:StopBar(args.spellName, args.destName)
	self:PrimaryIcon(args.spellId)
end

function mod:CorruptedTouch(args)
	if self:Me(args.destGUID) or self:Dispeller("curse") then
		self:TargetMessage(args.spellId, "orange", args.destName)
		self:TargetBar(args.spellId, 20, args.destName)
	end
end

function mod:CorruptedTouchRemoved(args)
	self:StopBar(args.spellName, args.destName)
end
