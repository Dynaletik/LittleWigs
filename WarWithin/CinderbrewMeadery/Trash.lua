--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("Cinderbrew Meadery Trash", 2661)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	218671, -- Venture Co. Pyromaniac
	214668, -- Venture Co. Patron
	210269, -- Hired Muscle
	214920, -- Tasting Room Attendant
	214697, -- Chef Chewie
	219415, -- Cooking Pot
	219667, -- Flamethrower
	214673, -- Flavor Scientist
	222964, -- Flavor Scientist
	223423, -- Careless Hopgoblin
	223562, -- Brew Drop
	220060, -- Taste Tester
	210264, -- Bee Wrangler
	220946, -- Venture Co. Honey Harvester
	220141, -- Royal Jelly Purveyor
	219588 -- Yes Man / Assent Bloke / Agree Gentleman / Concur Sir
)

--------------------------------------------------------------------------------
-- Locals
--

local thirstyMobs = {}

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.venture_co_pyromaniac = "Venture Co. Pyromaniac"
	L.venture_co_patron = "Venture Co. Patron"
	L.hired_muscle = "Hired Muscle"
	L.tasting_room_attendant = "Tasting Room Attendant"
	L.chef_chewie = "Chef Chewie"
	L.cooking_pot = "Cooking Pot"
	L.flamethrower = "Flamethrower"
	L.flavor_scientist = "Flavor Scientist"
	L.careless_hopgoblin = "Careless Hopgoblin"
	L.brew_drop = "Brew Drop"
	L.taste_tester = "Taste Tester"
	L.bee_wrangler = "Bee Wrangler"
	L.venture_co_honey_harvester = "Venture Co. Honey Harvester"
	L.royal_jelly_purveyor = "Royal Jelly Purveyor"
	L.yes_man = "Yes Man"

	L.custom_on_cooking_autotalk = CL.autotalk
	L.custom_on_cooking_autotalk_desc = "|cFFFF0000Requires 25 skill in Khaz Algar Alchemy or Cooking.|r Automatically select the NPC dialog option that grants you 'Sticky Honey' which you can use by clicking your extra action button.\n\n|T451169:16|tSticky Honey\n{438997}"
	L.custom_on_cooking_autotalk_icon = mod:GetMenuIcon("SAY")
	L.custom_on_flamethrower_autotalk = CL.autotalk
	L.custom_on_flamethrower_autotalk_desc = "|cFFFF0000Requires Gnome, Goblin, Mechagnome, or 25 skill in Khaz Algar Engineering.|r Automatically select the NPC dialog option that grants you 'Flame On' which you can use by clicking your extra action button.\n\n|T135789:16|tFlame On\n{439616}"
	L.custom_on_flamethrower_autotalk_icon = mod:GetMenuIcon("SAY")
end

--------------------------------------------------------------------------------
-- Initialization
--

local failedBatchMarker = mod:AddMarkerOption(true, "npc", 7, 441501, 7) -- Failed Batch
function mod:GetOptions()
	return {
		-- Autotalk
		"custom_on_cooking_autotalk",
		"custom_on_flamethrower_autotalk",
		-- Venture Co. Pyromaniac
		{437721, "NAMEPLATE"}, -- Boiling Flames
		{437956, "NAMEPLATE"}, -- Erupting Inferno
		-- Venture Co. Patron
		{434773, "NAMEPLATE", "ME_ONLY", "OFF"}, -- Mean Mug
		-- Hired Musle
		{463218, "HEALER", "NAMEPLATE"}, -- Volatile Keg
		{434756, "ME_ONLY", "NAMEPLATE"}, -- Throw Chair
		{441408, "DISPEL"}, -- Thirsty
		-- Tasting Room Attendant
		{434706, "NAMEPLATE"}, -- Cinderbrew Toss
		-- Chef Chewie
		{463206, "NAMEPLATE"}, -- Tenderize
		{434998, "NAMEPLATE"}, -- High Steaks
		-- Flavor Scientist
		{441627, "NAMEPLATE"}, -- Rejuvenating Honey
		{441434, "NAMEPLATE"}, -- Failed Batch
		failedBatchMarker,
		-- Careless Hopgoblin
		{448619, "SAY", "NAMEPLATE"}, -- Reckless Delivery
		-- Brew Drop
		441179, -- Oozing Honey
		-- Taste Tester
		{441214, "DISPEL", "NAMEPLATE"}, -- Spill Drink
		{441242, "NAMEPLATE", "OFF"}, -- Free Samples?
		-- Bee Wrangler
		{441119, "SAY", "NAMEPLATE"}, -- Bee-Zooka
		{441351, "NAMEPLATE"}, -- Bee-stial Wrath
		-- Venture Co. Honey Harvester
		{442589, "NAMEPLATE"}, -- Beeswax
		{442995, "NAMEPLATE"}, -- Swarming Surprise
		-- Royal Jelly Purveyor
		{440687, "NAMEPLATE"}, -- Honey Volley
		{440876, "NAMEPLATE"}, -- Rain of Honey
		-- Yes Man
		{439467, "NAMEPLATE"}, -- Downward Trend
	}, {
		[437721] = L.venture_co_pyromaniac,
		[463218] = L.hired_muscle,
		[434706] = L.tasting_room_attendant,
		[463206] = L.chef_chewie,
		[441627] = L.flavor_scientist,
		[448619] = L.careless_hopgoblin,
		[441179] = L.brew_drop,
		[441214] = L.taste_tester,
		[441119] = L.bee_wrangler,
		[442589] = L.venture_co_honey_harvester,
		[440687] = L.royal_jelly_purveyor,
		[439467] = L.yes_man,
	}, {
		["custom_on_cooking_autotalk"] = L.cooking_pot,
		["custom_on_flamethrower_autotalk"] = L.flamethrower,
	}
end

function mod:OnBossEnable()
	-- Autotalk
	self:RegisterEvent("GOSSIP_SHOW")

	-- Venture Co. Pyromaniac
	self:RegisterEngageMob("VentureCoPyromaniacEngaged", 218671)
	self:Log("SPELL_CAST_SUCCESS", "BoilingFlames", 437721)
	self:Log("SPELL_CAST_SUCCESS", "EruptingInferno", 437956)
	self:Log("SPELL_AURA_APPLIED", "EruptingInfernoApplied", 437956)
	self:Death("VentureCoPyromaniacDeath", 218671)

	-- Venture Co. Patron
	self:RegisterEngageMob("VentureCoPatronEngaged", 214668)
	self:Log("SPELL_CAST_START", "MeanMug", 434773)
	self:Log("SPELL_CAST_SUCCESS", "MeanMugSuccess", 434773)
	self:Log("SPELL_AURA_APPLIED_DOSE", "MeanMugApplied", 434773)
	self:Death("VentureCoPatronDeath", 214668)

	-- Hired Muscle
	self:RegisterEngageMob("HiredMuscleEngaged", 210269)
	self:Log("SPELL_CAST_START", "VolatileKeg", 463218)
	self:Log("SPELL_CAST_START", "ThrowChair", 434756)
	self:Log("SPELL_AURA_APPLIED", "ThirstyApplied", 441408)
	self:Log("SPELL_AURA_REMOVED", "ThirstyRemoved", 441408)
	self:Death("HiredMuscleDeath", 210269)

	-- Tasting Room Attendant
	self:RegisterEngageMob("TastingRoomAttendantEngaged", 214920)
	self:Log("SPELL_CAST_SUCCESS", "CinderbrewToss", 434706)
	self:Death("TastingRoomAttendantDeath", 214920)

	-- Chef Chewie
	self:RegisterEngageMob("ChefChewieEngaged", 214697)
	self:Log("SPELL_CAST_START", "Tenderize", 463206)
	self:Log("SPELL_CAST_START", "HighSteaks", 434998)
	self:Death("ChefChewieDeath", 214697)

	-- Flavor Scientist
	self:RegisterEngageMob("FlavorScientistEngaged", 214673, 222964)
	self:Log("SPELL_CAST_START", "RejuvenatingHoney", 441627)
	self:Log("SPELL_INTERRUPT", "RejuvenatingHoneyInterrupt", 441627)
	self:Log("SPELL_CAST_SUCCESS", "RejuvenatingHoneySuccess", 441627)
	self:Log("SPELL_CAST_SUCCESS", "FailedBatch", 441434)
	self:Log("SPELL_SUMMON", "FailedBatchSummon", 441501)
	self:Death("FlavorScientistDeath", 214673, 222964)

	-- Careless Hopgoblin
	self:RegisterEngageMob("CarelessHopgoblinEngaged", 223423)
	self:Log("SPELL_CAST_START", "RecklessDelivery", 448619)
	self:Death("CarelessHopgoblinDeath", 223423)

	-- Brew Drop
	self:Log("SPELL_PERIODIC_DAMAGE", "OozingHoneyDamage", 441179) -- no alert on APPLIED, doesn't damage for 1.5s
	self:Log("SPELL_PERIODIC_MISSED", "OozingHoneyDamage", 441179)

	-- Taste Tester
	self:RegisterEngageMob("TasteTesterEngaged", 220060)
	self:Log("SPELL_CAST_SUCCESS", "SpillDrink", 441214)
	self:Log("SPELL_AURA_APPLIED", "SpillDrinkApplied", 441214)
	self:Log("SPELL_CAST_START", "FreeSamples", 441242)
	self:Log("SPELL_INTERRUPT", "FreeSamplesInterrupt", 441242)
	self:Log("SPELL_CAST_SUCCESS", "FreeSamplesSuccess", 441242)
	self:Death("TasteTesterDeath", 220060)

	-- Bee Wrangler
	self:RegisterEngageMob("BeeWranglerEngaged", 210264)
	self:Log("SPELL_CAST_START", "BeeZooka", 441119)
	self:Log("SPELL_CAST_SUCCESS", "BeeZookaSuccess", 441119)
	self:Log("SPELL_CAST_START", "BeestialWrath", 441351)
	self:Log("SPELL_INTERRUPT", "BeestialWrathInterrupt", 441351)
	self:Log("SPELL_CAST_SUCCESS", "BeestialWrathSuccess", 441351)
	self:Death("BeeWranglerDeath", 210264)

	-- Venture Co. Honey Harvester
	self:RegisterEngageMob("VentureCoHoneyHarvesterEngaged", 220946)
	self:Log("SPELL_CAST_START", "Beeswax", 442589)
	self:Log("SPELL_CAST_START", "SwarmingSurprise", 442995)
	self:Death("VentureCoHoneyHarvesterDeath", 220946)

	-- Royal Jelly Purveyor
	self:RegisterEngageMob("RoyalJellyPurveyorEngaged", 220141)
	self:Log("SPELL_CAST_START", "HoneyVolley", 440687)
	self:Log("SPELL_INTERRUPT", "HoneyVolleyInterrupt", 440687)
	self:Log("SPELL_CAST_SUCCESS", "HoneyVolleySuccess", 440687)
	self:Log("SPELL_CAST_SUCCESS", "RainOfHoney", 440876)
	self:Death("RoyalJellyPurveyorDeath", 220141)

	-- Yes Man / Assent Bloke / Agree Gentleman / Concur Sir
	self:RegisterEngageMob("YesManEngaged", 219588)
	self:Log("SPELL_CAST_START", "DownwardTrend", 439467)
	self:Death("YesManDeath", 219588)
end

function mod:OnBossDisable()
	thirstyMobs = {}
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Autotalk

function mod:GOSSIP_SHOW()
	if self:GetGossipID(121210) then -- Cooking Pot, 1st use
		if self:GetOption("custom_on_cooking_autotalk") then
			-- 121210:<Carefully boil the mead to extract the pure honey from it.>\r\n\r\n[Requires at least 25 skill in  Khaz Algar Alchemy or Cooking.]
			self:SelectGossipID(121210)
		end
	elseif self:GetGossipID(121215) then -- Cooking Pot, 2nd and 3rd use
		if self:GetOption("custom_on_cooking_autotalk") then
			-- 121215:<Carefully boil the mead to extract the pure honey from it.>\r\n\r\n[Requires at least 25 skill in  Khaz Algar Alchemy or Cooking.]
			self:SelectGossipID(121215)
		end
	elseif self:GetGossipID(121318) then -- Flamethrower
		if self:GetOption("custom_on_flamethrower_autotalk") then
			-- 121318:<You immediately understand the intricate mechanics of the flamethrower and how to handle it.>\r\n\r\n[Requires Gnome, Goblin, Mechagnome or at least 25 skill in Khaz Algar Engineering.]
			self:SelectGossipID(121318)
		end
	end
end

-- Venture Co. Pyromaniac

function mod:VentureCoPyromaniacEngaged(guid)
	self:Nameplate(437956, 9.1, guid) -- Erupting Inferno
	self:Nameplate(437721, 15.6, guid) -- Boiling Flames
end

function mod:BoilingFlames(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:Nameplate(args.spellId, 24.2, args.sourceGUID)
	self:PlaySound(args.spellId, "alert")
end

function mod:EruptingInferno(args)
	self:Nameplate(args.spellId, 17.0, args.sourceGUID)
end

function mod:EruptingInfernoApplied(args)
	self:TargetMessage(args.spellId, "yellow", args.destName)
	self:PlaySound(args.spellId, "alarm", nil, args.destName)
end

function mod:VentureCoPyromaniacDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Venture Co. Patron

function mod:VentureCoPatronEngaged(guid)
	self:Nameplate(434773, 8.3, guid) -- Mean Mug
end

function mod:MeanMug(args)
	self:Nameplate(args.spellId, 0, args.sourceGUID)
end

function mod:MeanMugSuccess(args)
	self:Nameplate(args.spellId, 14.8, args.sourceGUID)
end

function mod:MeanMugApplied(args)
	if args.amount > 2 and args.amount % 2 == 1 then -- 3, 5, 7...
		self:StackMessage(args.spellId, "yellow", args.destName, args.amount, 5)
		self:PlaySound(args.spellId, "info", nil, args.destName)
	end
end

function mod:VentureCoPatronDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Hired Muscle

function mod:HiredMuscleEngaged(guid)
	self:Nameplate(463218, 8.0, guid) -- Volatile Keg
	self:Nameplate(434756, 12.0, guid) -- Throw Chair
	-- Thirsty is only applied out of combat, alert on engage if it's still present
	if thirstyMobs[guid] and self:Dispeller("enrage", true, 441408) then
		self:Message(441408, "cyan", CL.on:format(self:SpellName(441408), thirstyMobs[guid]))
		self:PlaySound(441408, "info")
	end
end

function mod:VolatileKeg(args)
	self:Message(args.spellId, "yellow")
	self:Nameplate(args.spellId, 24.2, args.sourceGUID)
	self:PlaySound(args.spellId, "info")
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(434756, "red", name)
		self:PlaySound(434756, "alert", nil, name)
	end

	function mod:ThrowChair(args)
		self:GetUnitTarget(printTarget, 0.2, args.sourceGUID)
		self:Nameplate(args.spellId, 15.7, args.sourceGUID)
	end
end

function mod:ThirstyApplied(args)
	-- this applies to Hired Muscle, Venture Co. Patron, and Venture Co. Pyromaniac when out of combat.
	-- the alert for this is in :HiredMuscleEnaged only, the other mobs are less important to dispel.
	thirstyMobs[args.destGUID] = args.destName
end

function mod:ThirstyRemoved(args)
	thirstyMobs[args.destGUID] = nil
end

function mod:HiredMuscleDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Tasting Room Attendant

function mod:TastingRoomAttendantEngaged(guid)
	self:Nameplate(434706, 13.2, guid) -- Cinderbrew Toss
end

function mod:CinderbrewToss(args)
	self:Message(args.spellId, "orange")
	self:Nameplate(args.spellId, 12.1, args.sourceGUID)
	self:PlaySound(args.spellId, "alarm")
end

function mod:TastingRoomAttendantDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Chef Chewie

do
	local timer

	function mod:ChefChewieEngaged(guid)
		self:CDBar(463206, 8.0) -- Tenderize
		self:Nameplate(463206, 8.0, guid) -- Tenderize
		self:CDBar(434998, 11.9) -- High Steaks
		self:Nameplate(434998, 11.9, guid) -- High Steaks
		timer = self:ScheduleTimer("ChefChewieDeath", 30)
	end

	function mod:Tenderize(args)
		if timer then
			self:CancelTimer(timer)
		end
		self:Message(args.spellId, "yellow")
		self:CDBar(args.spellId, 18.2)
		self:Nameplate(args.spellId, 18.2, args.sourceGUID)
		self:PlaySound(args.spellId, "alert")
		timer = self:ScheduleTimer("ChefChewieDeath", 30)
	end

	function mod:HighSteaks(args)
		if timer then
			self:CancelTimer(timer)
		end
		self:Message(args.spellId, "red")
		self:CDBar(args.spellId, 21.8)
		self:Nameplate(args.spellId, 21.8, args.sourceGUID)
		self:PlaySound(args.spellId, "long")
		timer = self:ScheduleTimer("ChefChewieDeath", 30)
	end

	function mod:ChefChewieDeath(args)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
		self:StopBar(463206) -- Tenderize
		self:StopBar(434998) -- High Steaks
		if args then
			self:ClearNameplate(args.destGUID)
		end
	end
end

-- Flavor Scientist

function mod:FlavorScientistEngaged(guid)
	self:Nameplate(441434, 8.1, guid) -- Failed Batch
	self:Nameplate(441627, 12.1, guid) -- Rejuvenating Honey
end

do
	local prev = 0
	function mod:RejuvenatingHoney(args)
		self:Nameplate(args.spellId, 0, args.sourceGUID)
		if args.time - prev > 1.5 then
			prev = args.time
			self:Message(args.spellId, "red", CL.casting:format(args.spellName))
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:RejuvenatingHoneyInterrupt(args)
	self:Nameplate(441627, 24.4, args.destGUID)
end

function mod:RejuvenatingHoneySuccess(args)
	self:Nameplate(args.spellId, 24.4, args.sourceGUID)
end

do
	local prev = 0
	function mod:FailedBatch(args)
		self:Message(args.spellId, "cyan", CL.spawning:format(args.spellName))
		self:Nameplate(args.spellId, 23.0, args.sourceGUID)
		if args.time - prev > 2 then
			prev = args.time
			self:PlaySound(args.spellId, "info")
		end
	end
end

do
	local failedBatchGUID = nil

	function mod:FailedBatchSummon(args)
		-- register events to auto-mark Failed Batch
		if self:GetOption(failedBatchMarker) then
			failedBatchGUID = args.destGUID
			self:RegisterTargetEvents("MarkFailedBatch")
		end
	end

	function mod:MarkFailedBatch(_, unit, guid)
		if failedBatchGUID == guid then
			failedBatchGUID = nil
			self:CustomIcon(failedBatchMarker, unit, 7)
			self:UnregisterTargetEvents()
		end
	end
end

function mod:FlavorScientistDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Careless Hopgoblin

function mod:CarelessHopgoblinEngaged(guid)
	self:Nameplate(448619, 8.8, guid) -- Reckless Delivery
end

do
	local function printTarget(self, name, guid)
		self:TargetMessage(448619, "orange", name)
		if self:Me(guid) then
			self:Say(448619, nil, nil, "Reckless Delivery")
		end
		self:PlaySound(448619, "alarm", nil, name)
	end

	function mod:RecklessDelivery(args)
		self:GetUnitTarget(printTarget, 0.2, args.sourceGUID)
		self:Nameplate(args.spellId, 30.3, args.sourceGUID)
	end
end

function mod:CarelessHopgoblinDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Brew Drop

do
	local prev = 0
	function mod:OozingHoneyDamage(args)
		if self:MobId(args.sourceGUID) ~= 219301 then -- Brew Drop, boss version
			if self:Me(args.destGUID) and args.time - prev > 2 then
				prev = args.time
				self:PersonalMessage(args.spellId, "underyou")
				self:PlaySound(args.spellId, "underyou")
			end
		end
	end
end

-- Taste Tester

function mod:TasteTesterEngaged(guid)
	self:Nameplate(441242, 9.2, guid) -- Free Samples
	if self:Dispeller("enrage", true, 441214) then
		self:Nameplate(441214, 11.4, guid) -- Spill Drink
	end
end

function mod:SpillDrink(args)
	if self:Dispeller("enrage", true, args.spellId) then
		self:Nameplate(args.spellId, 23.1, args.sourceGUID)
	end
end

do
	local prev = 0
	function mod:SpillDrinkApplied(args)
		if self:Dispeller("enrage", true, args.spellId) and args.time - prev > 3 then
			prev = args.time
			self:Message(args.spellId, "yellow", CL.on:format(args.spellName, args.destName))
			self:PlaySound(args.spellId, "info")
		end
	end
end

do
	local prev = 0
	function mod:FreeSamples(args)
		self:Nameplate(args.spellId, 0, args.sourceGUID)
		if args.time - prev > 1.5 then
			prev = args.time
			self:Message(args.spellId, "red", CL.casting:format(args.spellName))
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:FreeSamplesInterrupt(args)
	self:Nameplate(441242, 16.9, args.destGUID)
end

function mod:FreeSamplesSuccess(args)
	self:Nameplate(args.spellId, 16.9, args.sourceGUID)
end

function mod:TasteTesterDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Bee Wrangler

function mod:BeeWranglerEngaged(guid)
	self:Nameplate(441119, 4.1, guid) -- Bee-Zooka
	self:Nameplate(441351, 9.4, guid) -- Bee-stial Wrath
end

do
	local prev = 0
	local function printTarget(self, name, guid)
		self:TargetMessage(441119, "orange", name)
		local t = GetTime()
		if t - prev > 2.5 then
			prev = t
			if self:Me(guid) then
				self:Say(441119, nil, nil, "Bee-Zooka")
			end
			self:PlaySound(441119, "alarm", nil, name)
		end
	end

	function mod:BeeZooka(args)
		if self:Friendly(args.sourceFlags) then -- these NPCs can be mind-controlled by Priests
			return
		end
		self:GetUnitTarget(printTarget, 0.4, args.sourceGUID)
		self:Nameplate(args.spellId, 0, args.sourceGUID)
	end
end

function mod:BeeZookaSuccess(args)
	self:Nameplate(args.spellId, 15.3, args.sourceGUID)
end

do
	local prev = 0
	function mod:BeestialWrath(args)
		self:Nameplate(args.spellId, 0, args.sourceGUID)
		if args.time - prev > 1.5 then
			prev = args.time
			self:Message(args.spellId, "red", CL.casting:format(args.spellName))
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:BeestialWrathInterrupt(args)
	self:Nameplate(441351, 18.8, args.destGUID)
end

function mod:BeestialWrathSuccess(args)
	self:Nameplate(args.spellId, 18.8, args.sourceGUID)
end

function mod:BeeWranglerDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Venture Co. Honey Harvester

function mod:VentureCoHoneyHarvesterEngaged(guid)
	self:Nameplate(442995, 8.1, guid) -- Swarming Surprise
	self:Nameplate(442589, 16.7, guid) -- Beeswax
end

function mod:Beeswax(args)
	self:Message(args.spellId, "orange")
	self:Nameplate(args.spellId, 25.1, args.sourceGUID)
	self:PlaySound(args.spellId, "alarm")
end

function mod:SwarmingSurprise(args)
	self:Message(args.spellId, "yellow")
	self:Nameplate(args.spellId, 23.1, args.sourceGUID)
	self:PlaySound(args.spellId, "alert")
end

function mod:VentureCoHoneyHarvesterDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Royal Jelly Purveyor

function mod:RoyalJellyPurveyorEngaged(guid)
	self:Nameplate(440687, 8.9, guid) -- Honey Volley
	self:Nameplate(440876, 15.0, guid) -- Rain of Honey
end

do
	local prev = 0
	function mod:HoneyVolley(args)
		if self:Friendly(args.sourceFlags) then -- these NPCs can be mind-controlled by Priests
			return
		end
		self:Nameplate(args.spellId, 0, args.sourceGUID)
		local t = args.time
		if t - prev > 2 then
			prev = t
			self:Message(args.spellId, "red", CL.casting:format(args.spellName))
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:HoneyVolleyInterrupt(args)
	self:Nameplate(440687, 25.0, args.destGUID)
end

function mod:HoneyVolleySuccess(args)
	self:Nameplate(args.spellId, 25.0, args.sourceGUID)
end

do
	local prev = 0
	function mod:RainOfHoney(args)
		if self:Friendly(args.sourceFlags) then -- these NPCs can be mind-controlled by Priests
			return
		end
		self:Nameplate(args.spellId, 17.0, args.sourceGUID)
		if args.time - prev > 2 then
			prev = args.time
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:RoyalJellyPurveyorDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Yes Man / Assent Bloke / Agree Gentleman / Concur Sir

function mod:YesManEngaged(guid)
	self:Nameplate(439467, 6.9, guid) -- Downward Trend
end

do
	local prev = 0
	function mod:DownwardTrend(args)
		self:Nameplate(args.spellId, 13.4, args.sourceGUID)
		local t = args.time
		if t - prev > 2.5 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev, deathCount = 0, 0
	function mod:YesManDeath(args)
		self:ClearNameplate(args.destGUID)
		if args.time - prev > 180 then -- 1
			deathCount = 1
		elseif deathCount < 3 then -- 2 through 3
			deathCount = deathCount + 1
		else -- 4
			deathCount = 0
			local goldieBaronbottomModule = BigWigs:GetBossModule("Goldie Baronbottom", true)
			if goldieBaronbottomModule then
				goldieBaronbottomModule:Enable()
				goldieBaronbottomModule:Warmup()
			end
		end
		prev = args.time
	end
end
