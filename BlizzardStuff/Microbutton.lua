function CA_InitializeMicrobutton()
    BINDING_NAME_CLASSIC_ACHIEVEMENT = 'Anniversary Achievements'
    
    local microButtons = {}
    for _, value in pairs(MICRO_BUTTONS) do
        microButtons[#microButtons + 1] = value
        if value == 'QuestLogMicroButton' then
            microButtons[#microButtons + 1] = 'AchievementMicroButton'
        end
    end
    
    MICRO_BUTTONS = microButtons

    hooksecurefunc("UpdateMicroButtons", function()
        if AchievementFrame and AchievementFrame:IsShown() then
            AchievementMicroButton:SetButtonState('PUSHED', true)
        else
            AchievementMicroButton:SetButtonState('NORMAL')
        end
    end)
    
    AchievementMicroButton:SetScript('OnClick', function(self, button)
        if button == 'RightButton' then
            Settings.OpenToCategory("Anniversary Achievements")
        else
            AchievementFrame_ToggleAchievementFrame()
        end
    end)
end

SexyLib:Util():AfterLogin(function()
    if not CA_IsMicrobuttonEnabled() or Bartender4 then return end

    CA_InitializeMicrobutton()
    
    local width = 24
    MainMenuBar:SetWidth(MainMenuBar:GetWidth() + width * 2)
    
    do
        local point, relativeTo, relativePoint, xOfs, yOfs = SocialsMicroButton:GetPoint()
        SocialsMicroButton:SetPoint(point, AchievementMicroButton, relativePoint, xOfs, yOfs)
    end
    
    local function move(thing, delta)
        local point, relativeTo, relativePoint, xOfs, yOfs = thing:GetPoint()
        thing:SetPoint(point, relativeTo, relativePoint, xOfs + delta, yOfs)
    end
    
    local function set(thing, xOf, yOf)
        local point, relativeTo, relativePoint, xOfs, yOfs = thing:GetPoint()
        thing:SetPoint(point, relativeTo, relativePoint, xOf or xOfs, yOf or yOfs)
    end
    
	move(MainMenuBarTexture0, -width + 1.5)
    move(MainMenuBarTexture1, -width + 1.5)
    move(MainMenuBarPageNumber, -width + 1.5)
    move(MainMenuBarTexture2, -width / 2 - 1.5)
    MainMenuBarTexture2:SetWidth(MainMenuBarTexture2:GetWidth() + width)
    AchievementMicroButton:SetFrameStrata('HIGH')
    C_Timer.After(0.01, function()
        MainMenuBarPerformanceBarFrame:SetClampedToScreen(false)  
		MainMenuBarPerformanceBarFrame:SetMovable(1)
		MainMenuBarPerformanceBarFrame:SetUserPlaced(true)
		MainMenuBarPerformanceBarFrame:ClearAllPoints()
		MainMenuBarPerformanceBarFrame:SetPoint("RIGHT", -235, -4)
		move(MainMenuBarPerformanceBarFrame, -width)
    end)
    move(MainMenuBarBackpackButton, -width)
    
    move(MultiBarBottomRight, width)
    
    local expBarWidth = MainMenuExpBar:GetWidth() + width
    MainMenuExpBar:SetWidth(expBarWidth)
    move(MainMenuExpBar, -width / 2)
    for i, part in pairs({-0.375, -0.125, 0.125, 0.375}) do
        local tex = _G['MainMenuXPBarTexture' .. (i - 1)]
        tex:SetWidth(expBarWidth / 4)
        set(tex, expBarWidth * part)
    end
end)
