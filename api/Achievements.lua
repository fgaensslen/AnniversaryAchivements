CA_Database = {}

local struct = CA_Database
local loc = SexyLib:Localization('Anniversary Achievements')

struct.tabs = {}
struct.categories = {}
struct.achievements = {}

struct.TAB_ID_PLAYER = 1
struct.TAB_ID_GUILD = 2
struct.TAB_ID_STATS = 3

struct.CTYPE_KILL_NPC = 1

struct.selectedTab = struct.TAB_ID_PLAYER

local lastAchievementID, lastCategoryID = 0, 0

local function Achievement(name, description, points, icon, localize, forceID)
    local id
    if forceID then
        id = forceID
    else
        lastAchievementID = lastAchievementID + 1
        id = lastAchievementID
    end
    if localize then
        name = loc:Get(name)
        description = loc:Get(description)
    end
    local result = {
        id = id,
        name = name,
        description = description,
        points = points,
        icon = icon,
        criterias = {},
        criteriasSorted = {},
        AddCriteria = function(self, criteria)
            if not criteria or not criteria.id then error('illegal criteria provided') end
            self.criterias[criteria.id] = criteria
            self.criteriasSorted[#self.criteriasSorted + 1] = criteria
        end,
        GetCriteria = function(self, id)
            return self.criterias[id]
        end,
        GetCriterias = function(self)
            return self.criterias
        end,
        GetCriteriasSorted = function(self)
            return self.criteriasSorted
        end,
        SetNext = function(self, achievement)
            self.nextID = achievement.id
            achievement.previousID = self.id
        end,
        GetNextID = function(self)
            return self.nextID or nil
        end,
        GetPreviousID = function(self)
            return self.previousID or nil
        end,
        SetRewardText = function(self, text)
            self.rewardText = text
        end,
        GetRewardText = function(self)
            return self.rewardText or nil
        end,
        SetHordeOnly = function(self)
            self.faction = true
            if not self:IsFactionValid() then self:deactivateCriterias() end
        end,
        SetAllianceOnly = function(self)
            self.faction = false
            if not self:IsFactionValid() then self:deactivateCriterias() end
        end,
        SetUnavailable = function(self)
            self.unavailable = true
            self:deactivateCriterias()
        end,
        SetAnyCompletable = function(self)
            self.anyCompletable = true
        end,
        IsAnyCompletable = function(self)
            return self.anyCompletable or false
        end,
        IsFactionValid = function(self)
            return self.faction == nil or self.faction == (UnitFactionGroup('player') == 'Horde')
        end,
        IsAvailable = function(self)
            return self.unavailable ~= true and self:IsFactionValid()
        end,
        deactivateCriterias = function(self)
            for _, criteria in pairs(self.criterias) do
                criteria.deactivated = true
            end
        end
    }
    struct.achievements[id] = result
    return result
end

local function Category(name, parentID, localize, forceID)
    local id
    if forceID then
        id = forceID
    else
        lastCategoryID = lastCategoryID + 1
        id = lastCategoryID
    end
    if localize then name = loc:Get(name) end
    local result = {
        id = id,
        name = name,
        parentID = parentID or -1,
        achievements = {},
        CreateAchievement = function(self, ...)
            local result = Achievement(...)
            self.achievements[result.id] = result
            return result
        end,
        GetAchievement = function(self, id)
            return self.achievements[id]
        end,
        GetAchievements = function(self)
            return self.achievements
        end
    }
    struct.categories[id] = result
    return result
end

local function Tab(id)
    if struct.tabs[id] then error('tab with id ' .. id .. ' already exists') end
    struct.tabs[id] = {
        id = id,
        categories = {},
        CreateCategory = function(self, ...)
            local result = Category(...)
            self.categories[result.id] = result
            return result
        end,
        SkipCategories = function(self, count)
            for i = 1, (count or 1) do
                lastCategoryID = lastCategoryID + 1
            end
        end,
        GetCategory = function(self, id)
            if id == -1 then return self.summaryCategory end
            return self.categories[id]
        end,
        GetCategories = function(self)
            return self.categories
        end,
        summaryCategory = {
            id = -1,
            name = 'summary',
            parentID = -1,
            GetAchievement = function(self, id)
                return struct.achievements[id]
            end,
            GetAchievements = function(self)
                local result = {}
                for _, category in pairs(struct.tabs[id].categories) do
                    for id, achievement in pairs(category:GetAchievements()) do
                        result[id] = achievement
                    end
                end
                return result
            end
        },
        printCategories = function(self)
            for id, category in pairs(self.categories) do
                print(id, category.name)
            end
        end
    }
end

Tab(struct.TAB_ID_PLAYER)
Tab(struct.TAB_ID_GUILD)
Tab(struct.TAB_ID_STATS)

function struct:GetTab(id)
    return struct.tabs[id]
end

function struct:GetSelectedTab()
    return struct:GetTab(struct.selectedTab)
end

function struct:GetTabSpecial(isGuildOrPlayerTab)
    if isGuildOrPlayerTab then return struct:GetTab(struct.TAB_ID_GUILD) end
    return struct:GetTab(struct.TAB_ID_PLAYER)
end

function struct:GetCategory(id)
    if id == -1 then return self:GetSelectedTab():GetCategory(id) end
    return struct.categories[id]
end

function struct:GetAllCategories()
    return struct.categories
end

function struct:GetAchievement(id)
    return struct.achievements[id]
end

function struct:GetAllAchievements()
    return struct.achievements
end

function struct:SetSelectedTab(index)
    struct.selectedTab = index
end
