--------------------------------------------------------------------------------
-- Module Declaration
--

local mod, CL = BigWigs:NewBoss("The Rookery Trash", 2648)
if not mod then return end
mod.displayName = CL.trash
mod:RegisterEnableMob(
	209801, -- Quartermaster Koratite
	212786, -- Cursed Stormrider / Voidrider
	207199, -- Cursed Rooktender
	207186, -- Unruly Stormrook
	214419, -- Corrupted Rookguard / Void Cursed Crusher
	214439, -- Corrupted Oracle
	214421, -- Corrupted Thunderer / Coalescing Void Diffuser
	219066, -- Inflicted Civilian
	212793, -- Void Ascendant
	212739, -- Radiating Voidstone
	207202 -- Void Fragment
)

--------------------------------------------------------------------------------
-- Localization
--

local L = mod:GetLocale()
if L then
	L.quartermaster_koratite = "Quartermaster Koratite"
	L.cursed_stormrider = "Cursed Stormrider"
	L.cursed_rooktender = "Cursed Rooktender"
	L.unruly_stormrook = "Unruly Stormrook"
	L.corrupted_rookguard = "Corrupted Rookguard"
	L.corrupted_oracle = "Corrupted Oracle"
	L.corrupted_thunderer = "Corrupted Thunderer"
	L.inflicted_civilian = "Inflicted Civilian"
	L.void_ascendant = "Void Ascendant"
	L.radiating_voidstone = "Radiating Voidstone"
	L.void_fragment = "Void Fragment"
end

--------------------------------------------------------------------------------
-- Initialization
--

function mod:GetOptions()
	return {
		-- Quartermaster Koratite
		{426893, "NAMEPLATE"}, -- Bounding Void
		{450628, "NAMEPLATE"}, -- Entropy Shield
		-- Cursed Stormrider
		{427323, "NAMEPLATE"}, -- Charged Bombardment
		{427404, "NAMEPLATE"}, -- Localized Storm
		-- Cursed Rooktender
		{427260, "NAMEPLATE"}, -- Enrage Rook
		-- Unruly Stormrook
		{430013, "NAMEPLATE"}, -- Thunderstrike
		{427616, "NAMEPLATE"}, -- Energized Barrage
		-- Corrupted Rookguard
		{423979, "NAMEPLATE"}, -- Implosion
		-- Corrupted Oracle
		{430754, "NAMEPLATE"}, -- Void Shell
		{430179, "NAMEPLATE"}, -- Seeping Corruption
		-- Corrupted Thunderer
		{430812, "NAMEPLATE"}, -- Attracting Shadows
		-- Inflicted Civilian
		443854, -- Instability
		-- Void Ascendant
		{432959, "NAMEPLATE"}, -- Void Volley
		{432638, "NAMEPLATE"}, -- Command Void
		-- Radiating Voidstone
		{432781, "NAMEPLATE"}, -- Embrace the Void
		-- Void Fragment
		430288, -- Crushing Darkness
	}, {
		[426893] = L.quartermaster_koratite,
		[427323] = L.cursed_stormrider,
		[427260] = L.cursed_rooktender,
		[430013] = L.unruly_stormrook,
		[423979] = L.corrupted_rookguard,
		[430754] = L.corrupted_oracle,
		[430812] = L.corrupted_thunderer,
		[443854] = L.inflicted_civilian,
		[432959] = L.void_ascendant,
		[432781] = L.radiating_voidstone,
		[430288] = L.void_fragment,
	}
end

function mod:OnBossEnable()
	-- Quartermaster Koratite
	self:RegisterEngageMob("QuartermasterKoratiteEngaged", 209801)
	self:Log("SPELL_CAST_START", "BoundingVoid", 426893)
	self:Log("SPELL_CAST_START", "EntropyShield", 450628)
	self:Death("QuartermasterKoratiteDeath", 209801)

	-- Cursed Stormrider
	self:RegisterEngageMob("CursedStormriderEngaged", 212786)
	self:Log("SPELL_CAST_START", "ChargedBombardment", 427323)
	self:Log("SPELL_CAST_START", "LocalizedStorm", 427404)
	self:Death("CursedStormriderDeath", 212786)

	-- Cursed Rooktender
	self:RegisterEngageMob("CursedRooktenderEngaged", 207199)
	self:Log("SPELL_CAST_START", "EnrageRook", 427260)
	self:Log("SPELL_INTERRUPT", "EnrageRookInterrupt", 427260)
	self:Log("SPELL_CAST_SUCCESS", "EnrageRookSuccess", 427260)
	self:Death("CursedRooktenderDeath", 207199)

	-- Unruly Stormrook
	self:RegisterEngageMob("UnrulyStormrookEngaged", 207186)
	self:Log("SPELL_CAST_START", "Thunderstrike", 430013)
	self:Log("SPELL_CAST_START", "EnergizedBarrage", 427616)
	self:Death("UnrulyStormrookDeath", 207186)

	-- Corrupted Rookguard
	self:RegisterEngageMob("CorruptedRookguardEngaged", 214419)
	self:Log("SPELL_CAST_START", "Implosion", 423979)
	self:Death("CorruptedRookguardDeath", 214419)

	-- Corrupted Oracle
	self:RegisterEngageMob("CorruptedOracleEngaged", 214439)
	self:Log("SPELL_CAST_START", "VoidShell", 430754)
	self:Log("SPELL_CAST_SUCCESS", "SeepingCorruption", 430179)
	self:Log("SPELL_AURA_APPLIED", "SeepingCorruptionApplied", 430179)
	self:Death("CorruptedOracleDeath", 214439)

	-- Corrupted Thunderer
	self:RegisterEngageMob("CorruptedThundererEngaged", 214421)
	self:Log("SPELL_CAST_START", "AttractingShadows", 430812)
	self:Death("CorruptedThundererDeath", 214421)

	-- Inflicted Civilian
	self:Log("SPELL_CAST_SUCCESS", "Instability", 443854)

	-- Void Ascendant
	self:RegisterEngageMob("VoidAscendantEngaged", 212793)
	self:Log("SPELL_CAST_START", "VoidVolley", 432959)
	self:Log("SPELL_INTERRUPT", "VoidVolleyInterrupt", 432959)
	self:Log("SPELL_CAST_SUCCESS", "VoidVolleySuccess", 432959)
	self:Log("SPELL_CAST_SUCCESS", "CommandVoid", 432638)
	self:Death("VoidAscendantDeath", 212793)

	-- Radiating Voidstone
	self:RegisterEngageMob("RadiatingVoidstoneEngaged", 212739)
	self:Log("SPELL_CAST_START", "EmbraceTheVoid", 432781)
	self:Log("SPELL_CAST_SUCCESS", "EmbraceTheVoidSuccess", 432781)
	self:Log("SPELL_AURA_REMOVED", "EmbraceTheVoidRemoved", 432781)
	self:Death("RadiatingVoidstoneDeath", 212739)

	-- Void Fragment
	self:Log("SPELL_CAST_START", "CrushingDarkness", 430288)
end

--------------------------------------------------------------------------------
-- Event Handlers
--

-- Quartermaster Koratite

do
	local timer

	function mod:QuartermasterKoratiteEngaged(guid)
		self:CDBar(426893, 5.8) -- Bounding Void
		self:Nameplate(426893, 5.8, guid) -- Bounding Void
		self:CDBar(450628, 9.4) -- Entropy Shield
		self:Nameplate(450628, 9.4, guid) -- Entropy Shield
		timer = self:ScheduleTimer("QuartermasterKoratiteDeath", 30)
	end

	function mod:BoundingVoid(args)
		if timer then
			self:CancelTimer(timer)
		end
		self:Message(args.spellId, "orange")
		self:CDBar(args.spellId, 12.1)
		self:Nameplate(args.spellId, 12.1, args.sourceGUID)
		self:PlaySound(args.spellId, "alarm")
		timer = self:ScheduleTimer("QuartermasterKoratiteDeath", 30)
	end

	function mod:EntropyShield(args)
		if timer then
			self:CancelTimer(timer)
		end
		self:Message(args.spellId, "cyan")
		self:CDBar(args.spellId, 26.7)
		self:Nameplate(args.spellId, 26.7, args.sourceGUID)
		self:PlaySound(args.spellId, "info")
		timer = self:ScheduleTimer("QuartermasterKoratiteDeath", 30)
	end

	function mod:QuartermasterKoratiteDeath(args)
		if timer then
			self:CancelTimer(timer)
			timer = nil
		end
		self:StopBar(426893) -- Bounding Void
		self:StopBar(450628) -- Entropy Shield
		if args then
			self:ClearNameplate(args.destGUID)
		end
	end
end

-- Cursed Stormrider

function mod:CursedStormriderEngaged(guid)
	self:Nameplate(427323, 4.0, guid) -- Charged Bombardment
	self:Nameplate(427404, 10.0, guid) -- Localized Storm
end

function mod:ChargedBombardment(args)
	self:Message(args.spellId, "orange")
	self:Nameplate(args.spellId, 20.6, args.sourceGUID)
	self:PlaySound(args.spellId, "alarm")
end

function mod:LocalizedStorm(args)
	self:Message(args.spellId, "yellow")
	self:Nameplate(args.spellId, 27.9, args.sourceGUID)
	self:PlaySound(args.spellId, "info")
end

function mod:CursedStormriderDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Cursed Rooktender

function mod:CursedRooktenderEngaged(guid)
	self:Nameplate(427260, 5.7, guid) -- Enrage Rook
end

function mod:EnrageRook(args)
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:Nameplate(args.spellId, 0, args.sourceGUID)
	self:PlaySound(args.spellId, "alert")
end

function mod:EnrageRookInterrupt(args)
	self:Nameplate(427260, 10.1, args.destGUID)
end

function mod:EnrageRookSuccess(args)
	self:Nameplate(args.spellId, 10.1, args.sourceGUID)
end

function mod:CursedRooktenderDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Unruly Stormrook

function mod:UnrulyStormrookEngaged(guid)
	self:Nameplate(430013, 5.7, guid) -- Thunderstrike
	self:Nameplate(427616, 10.5, guid) -- Energized Barrage
end

do
	local prev = 0
	function mod:Thunderstrike(args)
		self:Nameplate(args.spellId, 18.2, args.sourceGUID)
		local t = args.time
		if t - prev > 2 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

do
	local prev = 0
	function mod:EnergizedBarrage(args)
		self:Nameplate(args.spellId, 23.0, args.sourceGUID)
		local t = args.time
		if t - prev > 2 then
			prev = t
			self:Message(args.spellId, "purple")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

function mod:UnrulyStormrookDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Corrupted Rookguard

function mod:CorruptedRookguardEngaged(guid)
	self:Nameplate(423979, 5.2, guid) -- Implosion
end

function mod:Implosion(args)
	self:Message(args.spellId, "orange")
	self:Nameplate(args.spellId, 17.0, args.sourceGUID)
	self:PlaySound(args.spellId, "alarm")
end

function mod:CorruptedRookguardDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Corrupted Oracle

function mod:CorruptedOracleEngaged(guid)
	self:Nameplate(430179, 9.1, guid) -- Seeping Corruption
	self:Nameplate(430754, 14.9, guid) -- Void Shell
end

function mod:VoidShell(args)
	self:Message(args.spellId, "red")
	-- unlike most other abilities, this goes on cooldown on cast start
	self:Nameplate(args.spellId, 20.7, args.sourceGUID)
	self:PlaySound(args.spellId, "alert")
end

function mod:SeepingCorruption(args)
	self:Nameplate(args.spellId, 26.7, args.sourceGUID)
end

function mod:SeepingCorruptionApplied(args)
	self:TargetMessage(args.spellId, "orange", args.destName)
	self:PlaySound(args.spellId, "alert", nil, args.destName)
end

function mod:CorruptedOracleDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Corrupted Thunderer

function mod:CorruptedThundererEngaged(guid)
	self:Nameplate(430812, 8.3, guid) -- Attracting Shadows
end

function mod:AttractingShadows(args)
	self:Message(args.spellId, "yellow")
	self:Nameplate(args.spellId, 21.8, args.sourceGUID)
	self:PlaySound(args.spellId, "info")
end

function mod:CorruptedThundererDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Inflicted Civilian

do
	local prev = 0
	function mod:Instability(args)
		local t = args.time
		if t - prev > 2 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end

-- Void Ascendant

function mod:VoidAscendantEngaged(guid)
	self:Nameplate(432638, 6.6, guid) -- Command Void
	self:Nameplate(432959, 9.5, guid) -- Void Volley
end

function mod:VoidVolley(args)
	if self:Friendly(args.sourceFlags) then -- these NPCs can be mind-controlled by Priests
		return
	end
	self:Message(args.spellId, "red", CL.casting:format(args.spellName))
	self:Nameplate(args.spellId, 0, args.sourceGUID)
	self:PlaySound(args.spellId, "alert")
end

function mod:VoidVolleyInterrupt(args)
	self:Nameplate(432959, 15.0, args.destGUID)
end

function mod:VoidVolleySuccess(args)
	self:Nameplate(args.spellId, 15.0, args.sourceGUID)
end

function mod:CommandVoid(args)
	-- the alert for this is covered by :CrushingDarkness
	self:Nameplate(args.spellId, 6.1, args.sourceGUID)
end

function mod:VoidAscendantDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Radiating Voidstone

function mod:RadiatingVoidstoneEngaged(guid)
	self:Nameplate(432781, 8.0, guid) -- Embrace the Void
end

do
	local prev = 0
	function mod:EmbraceTheVoid(args)
		self:Nameplate(args.spellId, 0, args.sourceGUID)
		local t = args.time
		if t - prev > 2 then
			prev = t
			self:Message(args.spellId, "yellow")
			self:PlaySound(args.spellId, "alert")
		end
	end
end

function mod:EmbraceTheVoidSuccess(args)
	self:Nameplate(args.spellId, 25.1, args.sourceGUID)
end

do
	local prev = 0
	function mod:EmbraceTheVoidRemoved(args)
		local t = args.time
		if t - prev > 2 then
			prev = t
			self:Message(args.spellId, "green", CL.removed:format(args.spellName))
			self:PlaySound(args.spellId, "info")
		end
	end
end

function mod:RadiatingVoidstoneDeath(args)
	self:ClearNameplate(args.destGUID)
end

-- Void Fragment

do
	local prev = 0
	function mod:CrushingDarkness(args)
		-- Void Fragments cast this if a nearby Void Ascendant casts Command Void (432638)
		local t = args.time
		if t - prev > 2 then
			prev = t
			self:Message(args.spellId, "orange")
			self:PlaySound(args.spellId, "alarm")
		end
	end
end
