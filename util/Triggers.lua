local TYPE = CA_Criterias.TYPE
local loc = SexyLib:Localization('Anniversary Achievements')

local function trigger(...)
    CA_Criterias:Trigger(...)
end

local function getItemIdFromLink(link)
    return tonumber(link:match("\124Hitem:(%d+):"))
end

local function updateQuests()
    local questsCompleted, total = GetQuestsCompleted(), 0
    for questID, isCompleted in pairs(questsCompleted) do
        if isCompleted then
            trigger(TYPE.COMPLETE_QUEST, {questID}, 1, true)
            total = total + 1
        end
    end
    trigger(TYPE.COMPLETE_QUESTS, nil, total, true)
end

local function updateBankSlots()
    local bankSlots = GetNumBankSlots()
    trigger(TYPE.BANK_SLOTS, nil, bankSlots, true)
end

function CheckDungeonQuests()
	local bossQuestMap = {
		-- Ragefire Chasm
		[5761] = { type = CA_Criterias.TYPE.KILL_NPC, data = {11520} }, -- Jergosh der Herbeirufer

		-- Wailing Caverns
		[6981] = { type = CA_Criterias.TYPE.KILL_NPC, data = {3654} }, -- Mutanus the Devourer

		-- Deadmines
		[166] = { type = CA_Criterias.TYPE.KILL_NPC, data = {639} }, -- Edwin VanCleef

		-- Shadowfang Keep
		[1014] = { type = CA_Criterias.TYPE.KILL_NPC, data = {4275} }, -- Archmage Arugal

		-- Blackfathom Deeps
		[1200] = { type = CA_Criterias.TYPE.KILL_NPC, data = {4832} }, -- Twilight-Lord Kelris
		[6561] = { type = CA_Criterias.TYPE.KILL_NPC, data = {4832} }, -- Twilight-Lord Kelris

		-- Stormwind Stockade
		[391] = { type = CA_Criterias.TYPE.KILL_NPC, data = {1716} }, -- Bazil Thredd

		-- Gnomeregan
		[2929] = { type = CA_Criterias.TYPE.KILL_NPC, data = {7800} }, -- Mekgineer Thermaplugg
		[2841] = { type = CA_Criterias.TYPE.KILL_NPC, data = {7800} }, -- Mekgineer Thermaplugg

		-- Razorfen Kraul
		[1101] = { type = CA_Criterias.TYPE.KILL_NPC, data = {4421} }, -- Charlga Razorflank
		[1102] = { type = CA_Criterias.TYPE.KILL_NPC, data = {4421} }, -- Charlga Razorflank

		-- Razorfen Downs
		[3636] = { type = CA_Criterias.TYPE.KILL_NPC, data = {7358} }, -- Amnennar the Coldbringer
		[3341] = { type = CA_Criterias.TYPE.KILL_NPC, data = {7358} }, -- Amnennar the Coldbringer

		-- Scarlet Monastery
		[1053] = { type = CA_Criterias.TYPE.KILL_NPC, data = {4543} }, -- Alle fünf Bosse für Horde
		[1053] = { type = CA_Criterias.TYPE.KILL_NPC, data = {6487} },
		[1053] = { type = CA_Criterias.TYPE.KILL_NPC, data = {3975} },
		[1053] = { type = CA_Criterias.TYPE.KILL_NPC, data = {3976} },
		[1053] = { type = CA_Criterias.TYPE.KILL_NPC, data = {3977} },
		[1048] = { type = CA_Criterias.TYPE.KILL_NPC, data = {4543} }, -- Alle fünf Bosse für Allianz
		[1048] = { type = CA_Criterias.TYPE.KILL_NPC, data = {6487} },
		[1048] = { type = CA_Criterias.TYPE.KILL_NPC, data = {3975} },
		[1048] = { type = CA_Criterias.TYPE.KILL_NPC, data = {3976} }, 
		[1048] = { type = CA_Criterias.TYPE.KILL_NPC, data = {3977} },

		-- Uldaman
		[2278] = { type = CA_Criterias.TYPE.KILL_NPC, data = {2748} }, -- Archaedas 

		-- Zul'Farrak
		[3527] = { type = CA_Criterias.TYPE.KILL_NPC, data = {7267} }, -- Häuptling Ukorz Sandscalp

		-- Maraudon
		[7064] = { type = CA_Criterias.TYPE.KILL_NPC, data = {12201} }, -- Princess Theradras
		[7065] = { type = CA_Criterias.TYPE.KILL_NPC, data = {12201} }, -- Princess Theradras

		-- Sunken Temple (Temple of Atal'Hakkar)
		[3373] = { type = CA_Criterias.TYPE.KILL_NPC, data = {5709} }, -- Shade of Eranikus

		-- Blackrock Depths
		[4003] = { type = CA_Criterias.TYPE.KILL_NPC, data = {9019} }, -- Emperor Dagran Thaurissan
		[4362] = { type = CA_Criterias.TYPE.KILL_NPC, data = {9019} }, -- Emperor Dagran Thaurissan

		-- Lower Blackrock Spire
		[4903] = { type = CA_Criterias.TYPE.KILL_NPC, data = {9568} }, -- 	Oberanführer Wyrmthalak 
		[5081] = { type = CA_Criterias.TYPE.KILL_NPC, data = {9568} }, -- 	Oberanführer Wyrmthalak 

		-- Upper Blackrock Spire
		[5102] = { type = CA_Criterias.TYPE.KILL_NPC, data = {10363} }, -- General Drakkisath
		[6602] = { type = CA_Criterias.TYPE.KILL_NPC, data = {10363} }, -- General Drakkisath
		[6502] = { type = CA_Criterias.TYPE.KILL_NPC, data = {10363} }, -- General Drakkisath

		-- Scholomance
		[5382] = { type = CA_Criterias.TYPE.KILL_NPC, data = {1853} }, -- Darkmaster Gandling
		[5466] = { type = CA_Criterias.TYPE.KILL_NPC, data = {10508} }, -- Ras Frostraunen

		-- Stratholme
		[5262] = { type = CA_Criterias.TYPE.KILL_NPC, data = {10813} }, -- Balnazzar
		[5263] = { type = CA_Criterias.TYPE.KILL_NPC, data = {10440} }, -- Baron Rivendare

		-- Dire Maul
		[7461] = { type = CA_Criterias.TYPE.KILL_NPC, data = {11496} }, -- Immol'thar
		[7461] = { type = CA_Criterias.TYPE.KILL_NPC, data = {11486} }, -- Prinz Tortheldrin
	}
	
	for questID, criteriaInfo in pairs(bossQuestMap) do
        if C_QuestLog.IsQuestFlaggedCompleted(questID) then
            CA_Criterias:Trigger(criteriaInfo.type, criteriaInfo.data)
        end
    end
	
end

local function checkUnexploredAreas()
	local subZone = GetSubZoneText()
	if not subZone or subZone == "" then
		subZone = GetZoneText()
	end
	for areaID, name in pairs(AreaTableLocale) do
		if name == subZone then
			trigger(TYPE.EXPLORE_AREA, {areaID}, 1, true)
			break
		end
	end
end

local function updateReputations()
    local totals = {}
    for factionIndex = 1, GetNumFactions() do
        local name, description, standingId, bottomValue, topValue, earnedValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID = GetFactionInfo(factionIndex)
        if not isHeader then
            for level = 1, standingId do
                trigger(TYPE.REACH_REPUTATION, {factionID, level}, 1, true)
                totals[level] = (totals[level] or 0) + 1
            end
        end
    end
    for standingId, total in pairs(totals) do
        trigger(TYPE.REACH_ANY_REPUTATION, {standingId}, total, true)
    end
end

ClassicAchievementsProfessions = {
    FIRST_AID = {1, false},
    FISHING = {2, false},
    COOKING = {3, false},
    ENCHANTING = {4, true},
    TAILORING = {5, true},
    ENGINEERING = {6, true},
    LEATHERWORKING = {7, true},
    ALCHEMY = {8, true},
    BLACKSMITHING = {9, true},
    HERBALISM = {10, true},
    MINING = {11, true},
    SKINNING = {12, true},
    JEWELCRAFTING = {14, true}
}

ClassicAchievementsSkills = {
    UNARMED = 13,
    RIDING = 15
}

for idx, data in pairs(ClassicAchievementsProfessions) do
    ClassicAchievementsProfessions[idx] = {data[1], data[2], loc:Get('PROF_' .. idx)}
end

for idx, data in pairs(ClassicAchievementsSkills) do
    ClassicAchievementsSkills[idx] = {data, loc:Get('SKILL_' .. idx)}
end

local function triggerProfessions(array, type)
    local size = #array
    if size == 0 then return end
    if size == 1 then trigger(type, array, 1, true) end
    table.sort(array, function(a, b) return a < b end)
    for lvl = 1, array[1] do trigger(type, {lvl}, size, true) end
    for i = 2, size do
        if array[i - 1] ~= array[i] then
            for lvl = 1, array[i] do trigger(type, {lvl}, size - i + 1, true) end
        end
    end
end

local function updateProfessions()
    local main, secondary = {}, {}
    for i = 1, GetNumSkillLines() do
        local skillName, isHeader, _, points, tempPoints = GetSkillLineInfo(i)
        if not isHeader then
            points = min(375, points - tempPoints)
            for idx, data in pairs(ClassicAchievementsProfessions) do
                if data[3] == skillName then
                    for ps = 1, points do trigger(TYPE.REACH_PROFESSION_LEVEL, {data[1], ps}, 1, true) end
                    if data[2] then
                        main[#main + 1] = points
                    else
                        secondary[#secondary + 1] = points
                    end
                    break
                end
            end
            for idx, data in pairs(ClassicAchievementsSkills) do
                if data[2] == skillName then
                    for ps = 1, points do trigger(TYPE.REACH_PROFESSION_LEVEL, {data[1], ps}, 1, true) end
                    break
                end
            end
        end
    end
    triggerProfessions(main, TYPE.REACH_MAIN_PROFESSION_LEVEL)
    triggerProfessions(secondary, TYPE.REACH_SECONDARY_PROFESSION_LEVEL)
end

local previousCookingRecipeCount = 0  -- Cache to store the last counted number

function CountLearnedCookingRecipes()
	local profession = GetTradeSkillLine()
	if profession ~= loc:Get('PROF_COOKING') then return end  -- Only proceed if it's cooking

	local total = 0
	for i = 1, GetNumTradeSkills() do
		local _, type = GetTradeSkillInfo(i)
		if type ~= 'header' then
			total = total + 1
		end
	end
	
	-- Only trigger if count has increased
	if total > previousCookingRecipeCount then
		trigger(TYPE.LEARN_PROFESSION_RECIPES, {ClassicAchievementsProfessions.COOKING[1]}, total, true)
		previousCookingRecipeCount = total
	end
end


local function updateItemsInInventory()
    local items = {}
	
    local function processBag(bagID)
		for i = 1, C_Container.GetContainerNumSlots(bagID) do
			local itemInfo = C_Container.GetContainerItemInfo(bagID, i)
			if itemInfo and itemInfo.itemID and itemInfo.stackCount then
				if not items[itemInfo.itemID] then items[itemInfo.itemID] = 0 end
				items[itemInfo.itemID] = items[itemInfo.itemID] + itemInfo.stackCount
			end
		end
	end
    
    for i = 0, NUM_BAG_SLOTS do 
		processBag(i) 
	end
	
    for id, quantity in pairs(items) do
        trigger(TYPE.OBTAIN_ITEM, {id}, quantity, true)
        if id == 22589 or id == 22630 or id == 22631 or id == 22632 then
            trigger(TYPE.ATIESH, nil, 1, true)
        end
    end
end

local function updateGear()
    for idx, name in pairs(CA_Criterias.GEAR_SLOT) do
        if name == 'WEAPON' then name = 'MAINHAND'
        elseif name == 'FIRST_RING' then name = 'FINGER0'
        elseif name == 'SECOND_RING' then name = 'FINGER1'
        elseif name == 'FIRST_TRINKET' then name = 'TRINKET0'
        elseif name == 'SECOND_TRINKET' then name = 'TRINKET1'
        elseif name == 'CLOAK' then name = 'BACK' end
        
        local slotID = GetInventorySlotInfo(name .. 'SLOT')
        local itemLink = GetInventoryItemLink('player', slotID)
        if itemLink then
            local _, _, quality = GetItemInfo(itemLink)
            if quality ~= nil then
                if quality <= 6 then
                    for q = 2, quality do trigger(TYPE.GEAR_QUALITY, {idx, q}, 1, true) end
                else
                    trigger(TYPE.GEAR_QUALITY, {idx, quality}, 1, true)
                end
            end
            local id = getItemIdFromLink(itemLink)
            if id then
                trigger(TYPE.OBTAIN_ITEM, {id}, 1, true)
                if id == 22589 or id == 22630 or id == 22631 or id == 22632 then
                    trigger(TYPE.ATIESH, nil, 1, true)
                end
            end
        end
    end
end

local AREA_COORD_ADDITION = 0.01
local updatingExploredAreas = false

local function updateExploredAreas(mapIDs)
    for _, mapID in pairs(mapIDs) do
        if C_Map.GetMapInfo(mapID) then
            for x = 0, 1, AREA_COORD_ADDITION do
                for y = 0, 1, AREA_COORD_ADDITION do
                    local areaIDs = C_MapExplorationInfo.GetExploredAreaIDsAtPosition(mapID, CreateVector2D(x, y))
                    if areaIDs then
                        trigger(TYPE.EXPLORE_AREA, {areaIDs[1]}, 1, true)
                    end
                end
            end
        end
    end
end

function CA_UpdateExploredAreas()
    if updatingExploredAreas then return end
    updatingExploredAreas = true

    SexyLib:Logger('Anniversary Achievements'):LogInfoL('UPDATING_EXPLORED_AREAS')
    local callback = function()
        updatingExploredAreas = false
        SexyLib:Logger('Anniversary Achievements'):LogInfoL('UPDATED_EXPLORED_AREAS')
    end

    local mapIDs = {}
    local ranges = {{1411, 1458}, {1941, 1955}, {1957, 1957}}
    for _, range in pairs(ranges) do
        for mapID = range[1], range[2] do
            mapIDs[#mapIDs + 1] = mapID
            if #mapIDs == 10 then
                local batch = mapIDs
                mapIDs = {}
                local previous = callback
                callback = function()
                    updateExploredAreas(batch)
                    C_Timer.After(1, previous)
                end
            end
        end
    end
    
    if #mapIDs > 0 then
        updateExploredAreas(mapIDs)
        C_Timer.After(1, callback)
    else
        callback()
    end
end

function CA_performInitialCheck()
    local kills, _, maxRank = GetPVPLifetimeStats()
    local _, maxRank = GetPVPRankInfo(maxRank)
    trigger(TYPE.KILL_PLAYERS, nil, kills, true)
    for rank = 1, maxRank do trigger(TYPE.REACH_PVP_RANK, {rank}, 1, true) end

    local level = UnitLevel('player')
    for lvl = 1, level do trigger(TYPE.REACH_LEVEL, {lvl}, 1, true) end

    trigger(TYPE.NOT_WORKING, nil, 1, true)
    updateQuests()
    updateBankSlots()
    updateReputations()
    updateProfessions()
    updateItemsInInventory()
    updateGear()
	CheckDungeonQuests()

    CA_CompletionManager:GetLocal():RecheckAchievements()
end

C_Timer.After(5, CA_performInitialCheck)

local function toPattern(message)
    local pattern = message:gsub('%.', '%%.')
    :gsub('\124%d%-%d%(.*%)', '(.*)')
    :gsub('\1244.*:.*;', '.*')

    for i = 1, 100 do
        local result, count = pattern:gsub('%%' .. i .. '$s', '(.*)')
        if count == 0 then break end
        pattern = result
    end
    pattern = pattern:gsub('%%s', '(.*)'):gsub('%%d', '(%%d%+)')
    return pattern
end

local ITEM_CREATION_PATTERN = toPattern(LOOT_ITEM_CREATED_SELF)
local ITEM_CREATION_PATTERN_MULTIPLE = toPattern(LOOT_ITEM_CREATED_SELF_MULTIPLE)

local ZONE_EXPLORED_PATTERN = toPattern(ERR_ZONE_EXPLORED)
local ZONE_EXPLORED2_PATTERN = toPattern(ERR_ZONE_EXPLORED_XP)

local DUEL_VICTORY_PATTERN = toPattern(DUEL_WINNER_KNOCKOUT)

local function getEmoteLocalizations(emote)
    local result = {}
    for i = 1, 100 do
        if not loc:IsPresent(emote .. i) then break end
        result[#result + 1] = loc:Get(emote .. i):gsub('%%s', '%(.*%)')
    end
    return result
end
local EMOTE_LOVE = getEmoteLocalizations('EMOTE_LOVE')
local EMOTE_PAT = getEmoteLocalizations('EMOTE_PAT')

local canGetBattlegroundsAchievement = false
local alteracID, warsongID, arathiID, bgEyeID = 1459, 1460, 1461, 1956

local killingTracker = CA_CreatureKillingTracker
killingTracker:AddHandler(function(targetID) return true end, function(targetID)
    trigger(TYPE.KILL_NPC, {targetID}, 1)
    trigger(TYPE.KILL_NPCS, nil, 1)

    local difficultyID = GetDungeonDifficultyID()
    local _, _, isHeroic = GetDifficultyInfo(difficultyID)
    if isHeroic then trigger(TYPE.KILL_NPC_HEROIC, {targetID}, 1) end
    if time() < 1643871600 then trigger(TYPE.P3_FIRST_WEEK, {targetID}, 1) end
end)

local leeroy = {}
killingTracker:AddHandler(10161, function(targetID)
    local time, any = time()
    for t, _ in pairs(leeroy) do
        if time - t > 15 then leeroy[t] = nil end
    end
    leeroy[time] = (leeroy[time] or 0) + 1
    local total = 0
    for _, v in pairs(leeroy) do total = total + v end
    if total >= 50 then
        trigger(TYPE.SPECIAL, {1}, 1, true)
    end
end)

local bwlDuo = {}
killingTracker:AddHandler({11981, 14601}, function(targetID)
    local time = time()
    bwlDuo[targetID] = time
    if time - (bwlDuo[11981] or 0) <= 45 and time - (bwlDuo[14601] or 0) <= 45 then
        trigger(TYPE.SPECIAL, {2}, 1, true)
    end
end)

local arachnophobia = 0
killingTracker:AddHandler(15956, function(targetID)
    arachnophobia = time()
end)
killingTracker:AddHandler(15952, function(targetID)
    if time() - arachnophobia < 60 * 20 then trigger(TYPE.SPECIAL, {3}, 1, true) end
end)

local horsemen = {}
killingTracker:AddHandler({16062, 16063, 16064, 16065}, function(targetID)
    horsemen[targetID] = time()
    local timings = {}
    for _, timing in pairs(horsemen) do timings[#timings + 1] = timing end
    if #timings == 4 then
        table.sort(timings, function(a, b) return a < b end)
        if timings[2] - timings[1] <= 15 and timings[3] - timings[2] <= 15 and timings[4] - timings[3] <= 15 then
            trigger(TYPE.SPECIAL, {4}, 1, true)
        end
    end
end)

local bossesWithMobs = {
    [15956] = {16573},
    [15953] = {16505, 16506}
}
local bossesWithMobsCache = {}
for bossID, mobIDs in pairs(bossesWithMobs) do
    killingTracker:AddHandler(bossID, function(targetID)
        if bossesWithMobsCache[bossID] == nil then trigger(TYPE.BOSS_WITHOUT_MOBS, {bossID}, 1, true) end
    end)
    killingTracker:AddHandler(mobIDs, function(targetID)
        bossesWithMobsCache[bossID] = false
    end)
end

local bossesWithAllAlives = {
    [15989] = 40
}
for bossID, raidMembers in pairs(bossesWithAllAlives) do
    killingTracker:AddHandler(bossID, function(targetID)
        if raidMembers ~= GetNumGroupMembers() then return end
        local failed = false
        for i = 1, raidMembers do
            if UnitIsDeadOrGhost('raid' .. i) then
                failed = true
                break
            end
        end
        if not failed then trigger(TYPE.BOSS_WITH_ALL_ALIVE, {creatureID}, 1, true) end
    end)
end

local previousPvPKills = GetPVPLifetimeStats()
killingTracker:AddPlayerHandler(function(targetGUID)
    local kills = GetPVPLifetimeStats()
    if kills == previousPvPKills then return end
    trigger(TYPE.KILL_PLAYERS, nil, kills, true)
    previousPvPKills = kills

    local _, className, _, raceName = GetPlayerInfoByGUID(targetGUID)
    trigger(TYPE.KILL_PLAYER_OF_CLASS, {string.upper(className)}, 1)
    trigger(TYPE.KILL_PLAYER_OF_RACE, {string.upper(raceName)}, 1)

    local mapID = C_Map.GetBestMapForUnit('player')
    if mapID == bgEyeID then
        local berserker = false
        for i = 1, 64 do
            local name, _, _, _, _, _, _, _, _, id = UnitAura('player', i, 'HARMFUL')
            if not name then break end
            if id == 24378 then
                berserker = true
                break
            end
        end
        if berserker then
            trigger(TYPE.BG_EYE_BERSERK)
        end
    end
end)

local alteracValleyMineCaptures = 0
killingTracker:AddHandler({11677, 13086, 13088}, function(targetID)
    alteracValleyMineCaptures = alteracValleyMineCaptures + 1
end)

local events = {
    COMBAT_LOG_EVENT_UNFILTERED = function() killingTracker:HandleCombatEvent() end,
    PLAYER_PVP_KILLS_CHANGED = function()
        local kills = GetPVPLifetimeStats()
        trigger(TYPE.KILL_PLAYERS, nil, kills, true)
    end,
    PLAYER_LEVEL_UP = function(level, healthDelta, powerDelta, numNewTalents, numNewPvpTalentSlots, strengthDelta, agilityDelta, staminaDelta, intellectDelta)
        trigger(TYPE.REACH_LEVEL, {level}, 1, true)
    end,
    QUEST_TURNED_IN = function(questID, xpReward, moneyReward)
        trigger(TYPE.LOOT_QUEST_GOLD, nil, moneyReward)
        C_Timer.After(1, updateQuests)
    end,
    PLAYERBANKBAGSLOTS_CHANGED = function()
        C_Timer.After(1, updateBankSlots)
    end,
	BANKFRAME_OPENED = function()
		updateBankSlots()
	end,
    UPDATE_FACTION = function()
        C_Timer.After(1, updateReputations)
    end,
    SKILL_LINES_CHANGED = function()
        C_Timer.After(1, updateProfessions)
    end,
    CHAT_MSG_LOOT = function(msg, initiator, langName, channelName, playerName, flags)
        if flag == 'GM' or flag == 'DEV' then return end
        if not playerName then playerName = initiator end
        if not playerName or playerName ~= UnitName('player') then return end

        C_Timer.After(1, updateItemsInInventory)

        local item, quantity = msg:match(ITEM_CREATION_PATTERN_MULTIPLE)
        if not item then
            item = msg:match(ITEM_CREATION_PATTERN)
            if not item then return end
            quantity = 1
        else
            quantity = tonumber(quantity)
        end
        local id = getItemIdFromLink(item)
        if not id then return end
        trigger(TYPE.CRAFT_ITEM, {id}, quantity)
    end,
    LOOT_OPENED = function()
        if not IsFishingLoot() then return end
        for slot = 1, GetNumLootItems() do
            if LootSlotHasItem(slot) then
                local _, _, quantity = GetLootSlotInfo(slot)
                local link = GetLootSlotLink(slot)
                if link then
                    local id = getItemIdFromLink(link)
                    if id then 
						trigger(TYPE.FISH_AN_ITEM, {id}, quantity)
						trigger(TYPE.FISH_ANY_ITEM, {-1}, quantity)
					end
                end
            end
        end
    end,
    UPDATE_BATTLEFIELD_SCORE = function()
        if not InActiveBattlefield() or not canGetBattlegroundsAchievement then return end
        local winner = GetBattlefieldWinner()
        if not winner then return end
        canGetBattlegroundsAchievement = false
        
        local mapID = C_Map.GetBestMapForUnit('player')
        if mapID ~= alteracID and mapID ~= warsongID and mapID ~= arathiID and mapID ~= bgEyeID then return end

        local numStats, numScores = GetNumBattlefieldStats(), GetNumBattlefieldScores()
        local myName = UnitName('player')
        for i = 1, numScores do
            local name, killingBlows, honorableKills, deaths = GetBattlefieldScore(i)
            if name == myName then
                local scores = {killingBlows, honorableKills}
                for j = 1, numStats do
                    local stat = GetBattlefieldStatData(i, j)
                    trigger(TYPE.BATTLEFIELD_STAT, {mapID, j}, stat)
                    trigger(TYPE.BATTLEFIELD_STAT_MAX, {mapID, j}, stat, true)
                end
                for j, score in pairs(scores) do
                    trigger(TYPE.BATTLEFIELD_SCORE_MAX, {mapID, j}, score, true)
                    trigger(TYPE.BATTLEFIELDS_SCORE, {j}, score)
                end
                if mapID == bgEyeID then
                    if GetBattlefieldStatData(i, 1) >= 3 and deaths == 0 then
                        trigger(TYPE.BG_EYE_GLORY)
                    end
                end
                break
            end
        end

        trigger(TYPE.ALTERAC_VALLEY_MINE_CAPTURE_MAX, nil, alteracValleyMineCaptures, true)
        alteracValleyMineCaptures = 0

        local seconds = GetBattlefieldInstanceRunTime() / 1000

        local myFaction = UnitFactionGroup('player')
        if myFaction == 'Horde' then myFaction = 0 else myFaction = 1 end

        local myFactionPoints = GetBattlegroundPoints(myFaction)
        local enemyFactionPoints = GetBattlegroundPoints(1 - myFaction)

        trigger(TYPE.BG_POINTS, {mapID, myFactionPoints, enemyFactionPoints})

        if winner == myFaction then
            trigger(TYPE.BATTLEFIELD_WINS, {mapID}, 1)
            if seconds ~= 0 then
                if (mapID == alteracID or mapID == arathiID or mapID == bgEyeID) and seconds <= 360 or mapID == warsongID and seconds <= 420 then
                    trigger(TYPE.BATTLEFIELD_FAST_WIN, {mapID})
                end
            end
        end
        
        trigger(TYPE.BATTLEFIELD_MAX_LEVEL_PARTICIPATION)
        
    end,
	ZONE_CHANGED_NEW_AREA = function()
		checkUnexploredAreas()
	end,
	ZONE_CHANGED = function()		
		checkUnexploredAreas()
	end,
    PLAYER_EQUIPMENT_CHANGED = function()
        C_Timer.After(1, updateGear)
    end,
    PLAYER_ENTERING_WORLD = function()
        canGetBattlegroundsAchievement = true
        alteracValleyMineCaptures = 0
    end,
	--check for cooking recipes when cooking window is opened
	TRADE_SKILL_SHOW = function()
		CountLearnedCookingRecipes()	
	end,
    --TRADE_SKILL_UPDATE = function()
		--CountLearnedCookingRecipes()        
    --end,
    CHAT_MSG_SYSTEM = function(msg)
        local winner = msg:match(DUEL_VICTORY_PATTERN)
        if winner and UnitName('player') == winner then
            trigger(TYPE.DUELS)
        end
    end,
    CHAT_MSG_TEXT_EMOTE = function(msg)
        local guid = UnitGUID('target')
        if not guid then return end
        local split = SexyLib:Util():Explode(UnitGUID('target'), '-')
        if split[1] ~= 'Creature' or not split[6] then return end
        local unitID = floor(split[6])
        if unitID == 0 then return end

        local matched = false
        for _, pattern in pairs(EMOTE_LOVE) do
            if msg:match(pattern) then
                trigger(TYPE.EMOTE, {'LOVE', unitID})
                matched = true
                break
            end
        end
        if matched then return end

        for _, pattern in pairs(EMOTE_PAT) do
            if msg:match(pattern) then
                trigger(TYPE.EMOTE, {'PAT', unitID})
                matched = true
                break
            end
        end
        if matched then return end
    end,
    PLAYER_REGEN_ENABLED = function()
        bossesWithMobsCache = {}
    end
}
local eventsHandler = CreateFrame('FRAME', 'ClassicAchievementsEventHandlingFrame')
eventsHandler:SetScript('OnEvent', function(self, event, ...)
    events[event](...)
end)
for k, _ in pairs(events) do eventsHandler:RegisterEvent(k) end
