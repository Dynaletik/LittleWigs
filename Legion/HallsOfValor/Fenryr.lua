
--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Fenryr", 1041, 1487)
if not mod then return end
mod:RegisterEnableMob(95674, 99868) -- Phase 1 Fenryr, Phase 2 Fenryr
--mod.engageId = 1807

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		"stages",
		196543, -- Unnerving Howl
		{197556, "SAY", "PROXIMITY"}, -- Ravenous Leap
		196512, -- Claw Frenzy
		{196838, "SAY", "ICON"}, -- Scent of Blood
	}
end

function mod:OnBossEnable()
	self:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT", "CheckBossStatus")

	self:Log("SPELL_AURA_APPLIED", "Stealth", 196567)
	self:Log("SPELL_CAST_START", "UnnervingHowl", 196543)
	self:Log("SPELL_AURA_APPLIED", "RavenousLeap", 197556)
	self:Log("SPELL_AURA_REMOVED", "RavenousLeapRemoved", 197556)
	self:Log("SPELL_CAST_SUCCESS", "ClawFrenzy", 196512)
	self:Log("SPELL_CAST_START", "ScentOfBlood", 196838)
	self:Log("SPELL_AURA_REMOVED", "ScentOfBloodRemoved", 196838)

	self:Death("Win", 99868) -- Phase 2 Fenryr
end

--------------------------------------------------------------------------------
-- Event Handlers
--

function mod:Stealth(args)
	self:Message("stages", "Neutral", nil, CL.stage:format(2), false)
	self:Reboot()
end

function mod:UnnervingHowl(args)
	self:Message(args.spellId, "Urgent", "Alert") -- "pull:4.8, 36.4" p2
end

do
	local list = mod:NewTargetList()
	function mod:RavenousLeap(args)
		--"pull:10.1, 36.0" p2
		list[#list+1] = args.destName
		if #list == 1 then
			self:ScheduleTimer("TargetMessage", 0.3, args.spellId, list, "Attention", "Info", nil, nil, true)
		end
		if self:Me(args.destGUID) then
			self:OpenProximity(args.spellId, 10)
			self:Say(args.spellId)
		end
	end

	function mod:RavenousLeapRemoved(args)
		if self:Me(args.destGUID) then
			self:CloseProximity(args.spellId)
		end
	end
end

function mod:ClawFrenzy(args)
	self:Message(args.spellId, "Important")
end

do
	local function printTarget(self, player, guid)
		if self:Me(guid) then
			self:Say(196838)
		end
		self:PrimaryIcon(196838, player)
		self:TargetMessage(196838, player, "Urgent", "Warning")
	end
	function mod:ScentOfBlood(args)
		self:GetBossTarget(printTarget, 0.4, args.sourceGUID) -- pull:23.0 p2
	end
	function mod:ScentOfBloodRemoved(args)
		self:PrimaryIcon(args.spellId)
	end
end
