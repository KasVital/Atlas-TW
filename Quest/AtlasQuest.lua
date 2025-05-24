local _G = getfenv()
-----------------------------------------------------------------------------
-- Colours
-----------------------------------------------------------------------------
local red = "|cffff0000"
local white = "|cffFFFFFF"
local grey = "|cff808080"
local orange = "|cffff8000"
local blue = "|cff0070dd"
local green = "|cff00FF00"
local yellow = "|cffffd200"

-----------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------
local Initialized -- the variables are not loaded yet
local AQQuestfarbe
AtlasKTW = AtlasKTW or {}
AtlasKTW.Q = AtlasKTW.Q or {}
AtlasKTW.isHorde = AtlasKTW.isHorde or false -- variable that configures whether horde or allians is shown
AtlasKTW.Instances = 1 -- currently shown instance-pic (see Instances.lua)
--AtlasKTW.Q.ShownSide = "Left" -- configures at which side the panel is shown
--AtlasKTW.Q.WithAtlas (option to show the AQpanel automatically at atlas-startup, true/false)
-- Sets the max number of instances and quests to check for.
local AQMAXINSTANCES = "98"
local AQMAXQUESTS = "23"
local AQINSTATM = "" -- variable to check whether AtlasKTW.Instances has changed (see function KQuestSetTextandButtons())
local playerName = UnitName("player")

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------
function AQClearALL()
	AQPageCount:SetText()
	HideUIPanel(KQNextPageButton_Right)
	HideUIPanel(KQNextPageButton_Left)
	QuestName:SetText()
	QuestLeveltext:SetText()
	Prequesttext:SetText()
	QuestAttainLeveltext:SetText()
	REWARDstext:SetText()
	StoryTEXT:SetText()
	--KQFinishedQuestText:SetText()
	HideUIPanel(KQFinishedQuest)
	for b=1, 6 do
		_G["KQuestItemframe"..b.."_Icon"]:SetTexture()
		_G["KQuestItemframe"..b.."_Name"]:SetText()
		_G["KQuestItemframe"..b.."_Extra"]:SetText()
		_G["KQuestItemframe"..b]:Disable()
	end
end
-----------------------------------------------------------------------------
-- upper right button / to show/close panel
-----------------------------------------------------------------------------
function KQCLOSE_OnClick()
	if KQuestFrame:IsVisible() then
		HideUIPanel(KQuestFrame)
		HideUIPanel(KQuestInsideFrame)
	else
		ShowUIPanel(KQuestFrame)
	end
	AtlasKTW.QUpdateNOW = true
end
-----------------------------------------------------------------------------
-- upper left button on the panel for closing
-----------------------------------------------------------------------------
function AQCLOSE1_OnClick()
	HideUIPanel(KQuestFrame)
end
-----------------------------------------------------------------------------
-- inside button to close the quest display
-----------------------------------------------------------------------------
function AQCLOSE2_OnClick()
	HideUIPanel(KQuestInsideFrame)
	WHICHBUTTON = 0
end
-----------------------------------------------------------------------------
-- Hide the AtlasLoot Frame if available
-----------------------------------------------------------------------------
function AQHideAL()
	if AtlasLootItemsFrame ~= nil then
		AtlasLootItemsFrame:Hide() -- hide atlasloot
	end
end
-----------------------------------------------------------------------------
-- Insert Quest Information into the chat box
-----------------------------------------------------------------------------
function AQInsertQuestInformation()
	local OnlyQuestNameRemovedNumber
	local Quest
	Quest = AQSHOWNQUEST
	if Quest <= 9 then
		if AtlasKTW.isHorde then
			OnlyQuestNameRemovedNumber = strsub(_G["Inst"..AtlasKTW.Instances.."Quest"..Quest.."_HORDE"], 4)
		else
			OnlyQuestNameRemovedNumber = strsub(_G["Inst"..AtlasKTW.Instances.."Quest"..Quest], 4)
		end
	elseif Quest > 9 then
		if AtlasKTW.isHorde then
			OnlyQuestNameRemovedNumber = strsub(_G["Inst"..AtlasKTW.Instances.."Quest"..Quest.."_HORDE"], 5)
		else
			OnlyQuestNameRemovedNumber = strsub(_G["Inst"..AtlasKTW.Instances.."Quest"..Quest], 5)
		end
	end
	ChatFrameEditBox:Insert("["..OnlyQuestNameRemovedNumber.."]")
end
-----------------------------------------------------------------------------
-- set the Quest text
-- executed when you push a button
-----------------------------------------------------------------------------
function AQButton_SetText()
	local SHOWNID
	local nameDATA
	local colour
	AQClearALL()
	-- Show the finished button
	ShowUIPanel(KQFinishedQuest)
	KQFinishedQuestText:SetText(blue..AQFinishedTEXT)
	if AtlasKTW.isHorde then
		QuestName:SetText(AQQuestfarbe.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE"])
		QuestLeveltext:SetText(blue..AQDiscription_LEVEL..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Level"])
		QuestAttainLeveltext:SetText(blue..AQDiscription_ATTAIN..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Attain"]) 
		Prequesttext:SetText(blue..AQDiscription_PREQUEST..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Prequest"].."\n \n"..blue..AQDiscription_FOLGEQUEST..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Folgequest"].."\n \n"..blue..AQDiscription_START..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Location"].."\n \n"..blue..AQDiscription_AIM..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Aim"].."\n \n"..blue..AQDiscription_NOTE..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Note"])
		for b=1, 6 do
			REWARDstext:SetText(_G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."Rewardtext_HORDE"])
			if _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..b.."_HORDE"] ~= nil then
				-----------------------------------------------------------------------------
				-- Yay for AutoQuery. Boo for odd variable names.
				-----------------------------------------------------------------------------
				SHOWNID = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..b.."_HORDE"]
				if AQAutoQuery then
					colour = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..b.."_HORDE"]
					nameDATA = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..b.."_HORDE"]
					if not GetItemInfo(SHOWNID) then
						GameTooltip:SetHyperlink("item:"..SHOWNID..":0:0:0")
						if not AQNoQuerySpam then
							DEFAULT_CHAT_FRAME:AddMessage(AQSERVERASK.."["..colour..nameDATA..white.."]"..AQSERVERASKAuto)
						end
					end
				end
				local _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(SHOWNID)
				_G["KQuestItemframe"..b.."_Icon"]:SetTexture(itemTexture)
				_G["KQuestItemframe"..b.."_Name"]:SetText(KQgetItemInformation(b,"name"))
				_G["KQuestItemframe"..b.."_Extra"]:SetText(KQgetItemInformation(b,"extra"))
				_G["KQuestItemframe"..b]:Enable()
			else
				_G["KQuestItemframe"..b.."_Icon"]:SetTexture()
				_G["KQuestItemframe"..b.."_Name"]:SetText()
				_G["KQuestItemframe"..b.."_Extra"]:SetText()
				_G["KQuestItemframe"..b]:Disable()
			end
		end
	else
		KQCompareQuestLogtoQuest(Quest)
		QuestName:SetText(AQQuestfarbe.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST])
		QuestLeveltext:SetText(blue..AQDiscription_LEVEL..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Level"])
		QuestAttainLeveltext:SetText(blue..AQDiscription_ATTAIN..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Attain"]) 
		Prequesttext:SetText(blue..AQDiscription_PREQUEST..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Prequest"].."\n \n"..blue..AQDiscription_FOLGEQUEST..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Folgequest"].."\n \n"..blue..AQDiscription_START..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Location"].."\n \n"..blue..AQDiscription_AIM..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Aim"].."\n \n"..blue..AQDiscription_NOTE..white.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Note"])
		for b=1, 6 do
			REWARDstext:SetText(_G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."Rewardtext"])
			if _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..b] ~= nil then
				-----------------------------------------------------------------------------
				-- Yay for AutoQuery. Boo for odd variable names.
				-----------------------------------------------------------------------------
				SHOWNID = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..b]

				if AQAutoQuery then
					colour = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..b]
					nameDATA = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..b]
					if not GetItemInfo(SHOWNID) then
						GameTooltip:SetHyperlink("item:"..SHOWNID..":0:0:0")
						if not AQNoQuerySpam then
							DEFAULT_CHAT_FRAME:AddMessage(AQSERVERASK.."["..colour..nameDATA..white.."]"..AQSERVERASKAuto)
						end
					end
				end
				local _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(SHOWNID)
				_G["KQuestItemframe"..b.."_Icon"]:SetTexture(itemTexture)
				_G["KQuestItemframe"..b.."_Name"]:SetText(KQgetItemInformation(b,"name"))
				_G["KQuestItemframe"..b.."_Extra"]:SetText(KQgetItemInformation(b,"extra"))
				_G["KQuestItemframe"..b]:Enable()
			else
				_G["KQuestItemframe"..b.."_Icon"]:SetTexture()
				_G["KQuestItemframe"..b.."_Name"]:SetText()
				_G["KQuestItemframe"..b.."_Extra"]:SetText()
				_G["KQuestItemframe"..b]:Disable()
			end
		end
	end
	AQQuestFinishedSetChecked()
	KQExtendedPages()
end

-----------------------------------------------------------------------------
-- Retrieves and formats item information for quest rewards
-- @param count - Index of the item in the quest rewards list
-- @param what - Type of information to return ("name" or "extra")
-- @return Formatted item name or description text
-----------------------------------------------------------------------------
function KQgetItemInformation(count, what)
    -- Cache global variables locally for better performance
    local questId = AQSHOWNQUEST
    local instanceId = AtlasKTW.Instances
    local isHorde = AtlasKTW.isHorde
    -- Build faction-specific path prefix
    local factionSuffix = isHorde and "_HORDE" or ""
    -- Get item data using a single concatenated path
    local basePath = "Inst"..instanceId.."Quest"..questId
    local itemId = _G[basePath.."ID"..count..factionSuffix]
    local itemdiscription = _G[basePath.."description"..count..factionSuffix]
    -- Cache fallback text in case item info isn't available
    local itemTEXTSAVED = _G[basePath.."ITC"..count..factionSuffix].._G[basePath.."name"..count..factionSuffix]
    -- Try to get item info from the game
    if GetItemInfo(itemId) then
        -- Item exists in cache, format with proper quality color
        local itemName, _, itemQuality = GetItemInfo(itemId)
        local _, _, _, hex = GetItemQualityColor(itemQuality)
        local itemtext = hex..itemName
        -- Return requested information type
        if what == "name" then
            return itemtext
        elseif what == "extra" then
            return itemdiscription
        end
    else
        -- Item not in cache, use fallback text
        local itemtext = itemTEXTSAVED
        if what == "name" then
            return itemtext
        elseif what == "extra" then
            itemdiscription = itemdiscription.." "..red..AQERRORNOTSHOWN
            return itemdiscription
        end
    end
end

-----------------------------------------------------------------------------
-- set the checkbox for the finished quest check
-- swaped out to get the code clear
-----------------------------------------------------------------------------
function AQQuestFinishedSetChecked()
local questKey = "KQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST
if AtlasKTW.isHorde then
    questKey = questKey.."_HORDE"
end
KQFinishedQuest:SetChecked(AtlasKTW.Q[questKey] == 1)
end

-----------------------------------------------------------------------------
-- Allow pages
-- InstXXQuestXX_Page = number of pages
-- HideUIPanel(KQNextPageButton_Left) AQPageCount:SetText()
-----------------------------------------------------------------------------
function KQExtendedPages()
	-- Get the appropriate page reference based on player's faction
	-- This variable stores the reference to quest pages for the current instance and quest
	local pageReference
	-- Get faction-specific label suffix
	local suffix = AtlasKTW.isHorde and "_HORDE" or ""
	pageReference = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST..suffix.."_Page"]
	-- Check if the page reference exists and is properly formatted
	-- The first element of the table should contain the total number of pages
	if type(pageReference) == "table" then
		if type(pageReference[1]) == "number" then
			-- Show the navigation button for additional pages
			ShowUIPanel(KQNextPageButton_Right)
			-- Set the current page type to "Quest" for proper navigation handling
			AQ_NextPageCount = "Quest"
			-- Initialize to the first page
			AtlasKTW.Q.CurrentPage = 1
			-- Update the page counter display with current/total format
			AQPageCount:SetText(AtlasKTW.Q.CurrentPage.."/"..pageReference[1])
		end
	end
end

-----------------------------------------------------------------------------
-- Set Story Text
-----------------------------------------------------------------------------
function AQButtonSTORY_SetText()
	-- first clear display
	AQClearALL()
	-- show right story text
	if _G["Inst"..AtlasKTW.Instances.."Story"] ~= nil then
		QuestName:SetText(blue.._G["Inst"..AtlasKTW.Instances.."Caption"])
		if type(_G["Inst"..AtlasKTW.Instances.."Story"]) == "table" then
			StoryTEXT:SetText(white.._G["Inst"..AtlasKTW.Instances.."Story"]["Page1"])
			-- Show Next side button if next site is avaiable
			if _G["Inst"..AtlasKTW.Instances.."Story"]["Page2"] ~= nil then
				ShowUIPanel(KQNextPageButton_Right)
				AtlasKTW.Q.CurrentPage = 1
				-- shows total amount of pages
				AQPageCount:SetText(AtlasKTW.Q.CurrentPage.."/".._G["Inst"..AtlasKTW.Instances.."Story"]["MaxPages"])
				-- count to make a diffrent between story and normal text
				AQ_NextPageCount = "Story"
			end
		elseif type(_G["Inst"..AtlasKTW.Instances.."Story"]) == "string" then
			StoryTEXT:SetText(white.._G["Inst"..AtlasKTW.Instances.."Story"])
		end
		-- added to work with future versions of atlas (before i update e.g. before you dl the update)
	elseif _G["Inst"..AtlasKTW.Instances.."Story"] == nil then
		QuestName:SetText(AQNotAvailable)
		StoryTEXT:SetText(AQNotAvailable)
	end
end
-----------------------------------------------------------------------------
-- shows the next side
-----------------------------------------------------------------------------
function AQNextPageR_OnClick()
	local SideAfterThis = 0
	local SHIT
	SideAfterThis = AtlasKTW.Q.CurrentPage + 2
	AtlasKTW.Q.CurrentPage = AtlasKTW.Q.CurrentPage + 1
	-- first clear display
	AQClearALL()
	-- it is a story text
	if AQ_NextPageCount == "Story" then
		StoryTEXT:SetText(white.._G["Inst"..AtlasKTW.Instances.."Story"]["Page"..AtlasKTW.Q.CurrentPage])
		AQPageCount:SetText(AtlasKTW.Q.CurrentPage.."/".._G["Inst"..AtlasKTW.Instances.."Story"]["MaxPages"])
		if _G["Inst"..AtlasKTW.Instances.."Caption"..AtlasKTW.Q.CurrentPage] ~= nil then
			QuestName:SetText(blue.._G["Inst"..AtlasKTW.Instances.."Caption"..AtlasKTW.Q.CurrentPage])
		else
			QuestName:SetText(blue.._G["Inst"..AtlasKTW.Instances.."Caption"])
		end
		-- hide button if no next side
		if _G["Inst"..AtlasKTW.Instances.."Story"]["Page"..SideAfterThis] == nil then
			HideUIPanel(KQNextPageButton_Right)
		else
			ShowUIPanel(KQNextPageButton_Right)
		end
	end
	-- it is a quest text
	if AQ_NextPageCount == "Quest" then
		-- SHIT is added to make the code smaller it give back the right link for horde or alliance
		if AtlasKTW.isHorde then
			SHIT = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Page"]
		else
			SHIT = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Page"]
		end
		StoryTEXT:SetText(white..SHIT[AtlasKTW.Q.CurrentPage])
		AQPageCount:SetText(AtlasKTW.Q.CurrentPage.."/"..SHIT[1])
		-- hide button if no next side
		if SHIT[SideAfterThis] == nil then
			HideUIPanel(KQNextPageButton_Right)
		else
			ShowUIPanel(KQNextPageButton_Right)
		end
	end
	-- it is a boss text
	if AQ_NextPageCount == "Boss" then
		QuestName:SetText(blue.._G["Inst"..AtlasKTW.Instances.."General"][AtlasKTW.Q.CurrentPage][1])
		StoryTEXT:SetText(white.._G["Inst"..AtlasKTW.Instances.."General"][AtlasKTW.Q.CurrentPage][2].."\n \n".._G["Inst"..AtlasKTW.Instances.."General"][AtlasKTW.Q.CurrentPage][3])
		-- Show Next side button if next site is avaiable
		if _G["Inst"..AtlasKTW.Instances.."General"][SideAfterThis] ~= nil then
			ShowUIPanel(KQNextPageButton_Right)
		end
		-- shows total amount of pages
		AQPageCount:SetText(AtlasKTW.Q.CurrentPage.."/"..getn(_G["Inst"..AtlasKTW.Instances.."General"]))
	end
	-- Show backwards button
	ShowUIPanel(KQNextPageButton_Left)
end

-----------------------------------------------------------------------------
-- shows the side before this side
-----------------------------------------------------------------------------
function AQNextPageL_OnClick()
	local SHIT
	AtlasKTW.Q.CurrentPage = AtlasKTW.Q.CurrentPage - 1
	-- it is a story text
	if AQ_NextPageCount == "Story" then
		StoryTEXT:SetText(white.._G["Inst"..AtlasKTW.Instances.."Story"]["Page"..AtlasKTW.Q.CurrentPage])
		AQPageCount:SetText(AtlasKTW.Q.CurrentPage.."/".._G["Inst"..AtlasKTW.Instances.."Story"]["MaxPages"])
		if _G["Inst"..AtlasKTW.Instances.."Caption"..AtlasKTW.Q.CurrentPage] ~= nil then
			QuestName:SetText(blue.._G["Inst"..AtlasKTW.Instances.."Caption"..AtlasKTW.Q.CurrentPage])
		else
			QuestName:SetText(blue.._G["Inst"..AtlasKTW.Instances.."Caption"])
		end
		-- hide button if first side
		if AtlasKTW.Q.CurrentPage == 1 then
			HideUIPanel(KQNextPageButton_Left)
		end
	end
	-- it is a quest text 
	if AQ_NextPageCount == "Quest" then
		-- SHIT is added to make the code smaller it give back the right link for horde or alliance
		if AtlasKTW.isHorde then
			SHIT = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Page"]
		else
			SHIT = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Page"]
		end
		if AtlasKTW.Q.CurrentPage == 1 then
			AQButton_SetText()
		else
			StoryTEXT:SetText(white..SHIT[AtlasKTW.Q.CurrentPage])
		end
		AQPageCount:SetText(AtlasKTW.Q.CurrentPage.."/"..SHIT[1])
	end
	-- it is a boss text
	if AQ_NextPageCount == "Boss" then
		QuestName:SetText(blue.._G["Inst"..AtlasKTW.Instances.."General"][AtlasKTW.Q.CurrentPage][1])
		StoryTEXT:SetText(white.._G["Inst"..AtlasKTW.Instances.."General"][AtlasKTW.Q.CurrentPage][2].."\n \n".._G["Inst"..AtlasKTW.Instances.."General"][AtlasKTW.Q.CurrentPage][3])
		-- Show Next side button if next site is avaiable
		if AtlasKTW.Q.CurrentPage == 1 then
			HideUIPanel(KQNextPageButton_Left)
		end
		-- shows total amount of pages
		AQPageCount:SetText(AtlasKTW.Q.CurrentPage.."/"..getn(_G["Inst"..AtlasKTW.Instances.."General"]))
	end
	ShowUIPanel(KQNextPageButton_Right)
end

-----------------------------------------------------------------------------
-- Checkbox for the finished quest option
-----------------------------------------------------------------------------
function KQFinishedQuest_OnClick()
    -- Build the quest key based on faction
    local questKey = "KQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST
    if AtlasKTW.isHorde then
        questKey = questKey.."_HORDE"
    end
    -- Update quest completion status
    AtlasKTW.Q[questKey] = KQFinishedQuest:GetChecked() and 1 or nil
    -- Save to player options
    KQuest_Options[UnitName("player")][questKey] = AtlasKTW.Q[questKey]
    -- Update UI
    KQuestSetTextandButtons()
    AQButton_SetText()
end

--******************************************
-- Events: OnEvent
--******************************************

-----------------------------------------------------------------------------
-- Called when the player starts the game loads the variables
-----------------------------------------------------------------------------
function KQuest_OnEvent()
	if event == "VARIABLES_LOADED" then
		VariablesLoaded = 1 -- data is loaded completely
	else
		KQuest_Initialize() -- player enters world / initialize the data
	end
end

-----------------------------------------------------------------------------
-- Detects whether the variables have to be loaded
-- or reestablishes them
-----------------------------------------------------------------------------
function KQuest_Initialize()
	if Initialized or (not VariablesLoaded) then
		return
	end
	if type(AtlasTWOptions) == "table" then
		KQuest_LoadData()
	else
		DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00Atlas-TW Quest:|r|cff00ffffVariables not loaded!|r")
	end
	-- Register Tooltip with EquipCompare if enabled.
	if AQCompareTooltip ~= nil then
		KQuestRegisterTooltip()
	else
		KQuestUnRegisterTooltip()
	end
	Initialized = 1
end

-----------------------------------------------------------------------------
-- Loads the saved variables
-----------------------------------------------------------------------------
function KQuest_LoadData()
	-- Which side
	AtlasKTW.Q.ShownSide = AtlasTWOptions["QuestShownSide"]
	-- atlas autoshow
	AtlasKTW.Q.WithAtlas = AtlasTWOptions["QuestWithAtlas"]
	-- Colour Check? if nil = no cc if true = cc
	AtlasKTW.Q.ColourCheck = AtlasTWOptions["QuestColourCheck"]
	-- Finished?
	KQuest_Options = KQuest_Options or {}
	KQuest_Options[playerName] = KQuest_Options[playerName] or {}
	for i=1, AQMAXINSTANCES do
		for b=1, AQMAXQUESTS do
			AtlasKTW.Q["KQFinishedQuest_Inst"..i.."Quest"..b] = KQuest_Options[playerName]["KQFinishedQuest_Inst"..i.."Quest"..b]
			AtlasKTW.Q["KQFinishedQuest_Inst"..i.."Quest"..b.."_HORDE"] = KQuest_Options[playerName]["KQFinishedQuest_Inst"..i.."Quest"..b.."_HORDE"]
		end
	end
	--AtlasKTW.Q.CheckQuestlog
	AtlasKTW.Q.CheckQuestlog = AtlasTWOptions["QuestCheckQuestlog"]
	-- AutoQuery option
	AQAutoQuery = AtlasTWOptions["QuestAutoQuery"]
	-- Suppress Server Query Text option
	AQNoQuerySpam = AtlasTWOptions["QuestQuerySpam"]
	-- Comparison Tooltips option
	AQCompareTooltip = AtlasTWOptions["QuestCompareTooltip"]
end

-----------------------------------------------------------------------------
-- Saves the variables
-----------------------------------------------------------------------------
function KQuest_SaveData()
	-- Save the variables
	AtlasTWOptions["QuestShownSide"] = AtlasKTW.Q.ShownSide
	AtlasTWOptions["QuestWithAtlas"] = AtlasKTW.Q.WithAtlas
	AtlasTWOptions["QuestColourCheck"] = AtlasKTW.Q.ColourCheck
	AtlasTWOptions["QuestCheckQuestlog"] = AtlasKTW.Q.CheckQuestlog
	AtlasTWOptions["QuestAutoQuery"] = AQAutoQuery
	AtlasTWOptions["QuestQuerySpam"] = AQNoQuerySpam
	AtlasTWOptions["QuestCompareTooltip"] = AQCompareTooltip
end

--******************************************
-- Events: OnLoad
--******************************************

-----------------------------------------------------------------------------
-- Call OnLoad set Variables and hides the panel
-----------------------------------------------------------------------------
function KQ_OnLoad()
	AtlasKTW.Map = AtlasMap:GetTexture()
	KQSlashCommandfunction()
	AtlasKTW.QUpdateNOW = true
end

-----------------------------------------------------------------------------
-- Slash command added
-----------------------------------------------------------------------------
function KQSlashCommandfunction()
	SlashCmdList["ATLASQ"]=atlasquest_command
	SLASH_ATLASQ1="/aq"
	SLASH_ATLASQ2="/atlasquest"
end

-----------------------------------------------------------------------------
-- Test messages
-----------------------------------------------------------------------------
function KQTestmessages()
	DEFAULT_CHAT_FRAME:AddMessage("AtlasQuest: Test messages")
end

-----------------------------------------------------------------------------
-- Slashcommand!! show/hide panel
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Slash command handler for Atlas Quest Module
-- Processes user commands entered via /aq or /atlasquest
-- @param param - The command parameter string entered by the user
-----------------------------------------------------------------------------
function atlasquest_command(param)
    -- Always show help text as a default response
    ChatFrame1:AddMessage(red..AQHelpText)
    -- Convert param to lowercase for case-insensitive matching
    local cmd = string.lower(param or "")
    -- Command handler table - maps commands to their handler functions
    local commands = {
        -- Help command
        ["help"] = function()
            ChatFrame1:AddMessage(red..AQHelpText)
        end,
        -- Panel visibility commands
        ["show"] = function()
            ShowUIPanel(KQuestFrame)
            ChatFrame1:AddMessage("Shows Quest Panel")
        end,
        ["hide"] = function()
            HideUIPanel(KQuestFrame)
            HideUIPanel(KQuestInsideFrame)
            ChatFrame1:AddMessage("Hides Quest Panel")
        end,
        -- Panel position commands
        ["right"] = function() KQRIGHTOption_OnClick() end,
        ["left"] = function() KQLEFTOption_OnClick() end,
        -- Configuration commands
        ["option"] = function() ShowUIPanel(KQuestOptionFrame) end,
        ["config"] = function() ShowUIPanel(KQuestOptionFrame) end,
        -- Test command
        ["test"] = function() KQTestmessages() end,
        -- Auto-show toggle
        ["autoshow"] = function() KQAutoshowOption_OnClick() end,
        -- Color toggle
        ["colour"] = function() KQColourOption_OnClick() end,
        -- Instance list command
        ["list"] = function() 
            -- Display alphabetical list of instances with their IDs
            ChatFrame1:AddMessage("Instances, and Numbers (Alphabetical Order):")
            -- TurtleWOW instances
            local turtleInstances = {
                {"Black Morass", 33},
                {"Emerald Sanctum", 37},
                {"Gilneas City", 35},
                {"Hateforge Quarry", 31},
                {"Karazhan Crypt", 34},
                {"Lower Karazhan Halls", 36},
                {"Stormwind Vault", 32},
                {"Tower of Karazhan", 38},
                {"The Crescent Grove", 30}
            }
            -- Vanilla instances
            local vanillaInstances = {
                {"Blackfathom Deeps", 7},
                {"Blackrock Depths", 5},
                {"Blackrock Spire (Lower)", 8},
                {"Blackrock Spire (Upper)", 9},
                {"Blackwing Lair", 6},
                {"Deadmines", 1},
                {"Dire Maul", 10},
                {"Gnomeregan", 29},
                {"Maraudon", 13},
                {"Molten Core", 14},
                {"Naxxramas", 15},
                {"Onyxia's Lair", 16},
                {"RageFire Chasm", 3},
                {"Razorfen Downs", 17},
                {"Razorfen Kraul", 18},
                {"Scarlet Monestary", 19},
                {"Scholomance", 20},
                {"Shadowfang Keep", 21},
                {"Stratholme", 22},
                {"The Ruins of Ahn Qiraj", 23},
                {"The Stockade", 24},
                {"The Sunken Temple", 25},
                {"The Temple of Ahn Qiraj", 26},
                {"Uldaman", 4},
                {"Wailing Caverns", 2},
                {"Zul Farrak", 27},
                {"Zul Gurub", 28}
            }
            -- Display all instances in alphabetical order
            for _, instance in ipairs(turtleInstances) do
                ChatFrame1:AddMessage(instance[1]..": "..instance[2].." -- TurtleWOW")
            end
            for _, instance in ipairs(vanillaInstances) do
                ChatFrame1:AddMessage(instance[1]..": "..instance[2])
            end
        end,
        -- Alliance quest list command
        ["inst a"] = function()
            ChatFrame1:AddMessage(red.._G["Inst"..AtlasKTW.Instances.."Caption"])
            ChatFrame1:AddMessage(grey.._G["Inst"..AtlasKTW.Instances.."QAA"])
            for q=1,23 do
                local questName = _G["Inst"..AtlasKTW.Instances.."Quest"..q]
                if questName then
                    ChatFrame1:AddMessage(orange..questName)
                end
            end
        end,
        -- Horde quest list command
        ["inst h"] = function()
            ChatFrame1:AddMessage(red.._G["Inst"..AtlasKTW.Instances.."Caption"])
            ChatFrame1:AddMessage(grey.._G["Inst"..AtlasKTW.Instances.."QAH"])
            for q=1,23 do
                local questName = _G["Inst"..AtlasKTW.Instances.."Quest"..q.."_HORDE"]
                if questName then
                    ChatFrame1:AddMessage(orange..questName)
                end
            end
        end
    }
    -- Handle numeric parameters (quest details)
    local questNum = tonumber(param)
    if questNum then
        -- Display detailed information about the specified quest
        DisplayQuestDetails(questNum)
        return
    end
    -- Execute the command if it exists in our command table
    if commands[cmd] then
        commands[cmd]()
    end
end

-----------------------------------------------------------------------------
-- Helper function to display detailed quest information
-- @param questNum - The quest number to display details for
-----------------------------------------------------------------------------
function DisplayQuestDetails(questNum)
    -- Display instance caption
    ChatFrame1:AddMessage(red.._G["Inst"..AtlasKTW.Instances.."Caption"])

    -- Helper function to display quest details for a faction
    local function DisplayFactionQuestDetails(faction)
        local suffix = faction == "HORDE" and "_HORDE" or ""
        local prefix = faction == "HORDE" and "Horde Quest: " or "Alliance Quest: "
        local questKey = "Inst"..AtlasKTW.Instances.."Quest"..questNum..suffix
        local questName = _G[questKey]
        if questName then
            ChatFrame1:AddMessage(orange..prefix..questName)
            -- Quest detail fields to display
            local fields = {
                {"Level", "_Level"},
                {"Attain", "_Attain"}, 
                {"Goal", "_Aim"},
                {"Start", "_Location"},
                {"Note", "_Note"},
                {"Prequest", "_Prequest"},
                {"Postquest", "_Folgequest"}
            }
            -- Display each field
            for _, field in ipairs(fields) do
                local label, suffix = field[1], field[2]
                local value = _G[questKey..suffix] or "N/A"
                if label == "Prequest" or label == "Postquest" then
                    value = value ~= "N/A" and value or "None"
                end
                ChatFrame1:AddMessage(label..": "..value)
            end
        end
    end
    -- Display details for both factions
    DisplayFactionQuestDetails("")        -- Alliance
    DisplayFactionQuestDetails("HORDE")   -- Horde
end

--******************************************
-- Events: OnUpdate
--******************************************
-----------------------------------------------------------------------------
-- hide panel if instance is 99 (nothing)
-----------------------------------------------------------------------------
function KQ_OnUpdate(arg1)
	local previousInstance = AtlasKTW.Instances
	KQuest_Instances()
	-- Cache UI panels for better performance
	local questFrame = KQuestFrame
	local insideFrame = KQuestInsideFrame
	-- Check if we need to hide/update the quest panels
	if AtlasKTW.Instances == 99 then
		-- Hide both panels if no quests available
		HideUIPanel(questFrame)
		HideUIPanel(insideFrame)
	elseif AtlasKTW.Instances ~= previousInstance or AtlasKTW.QUpdateNOW then
		-- Update quest text and buttons if instance changed or update forced
		KQuestSetTextandButtons()
		AtlasKTW.QUpdateNOW = false
	end
end
-----------------------------------------------------------------------------
-- Set the Buttontext and the buttons if available
-- and check whether its a other inst or not -> works fine
-- added: Check for Questline arrows
-- Questline arrows are shown if InstXQuestYFQuest = "true"
-- QuestStart icon are shown if InstXQuestYPreQuest = "true"
-----------------------------------------------------------------------------
function KQuestSetTextandButtons()
	local AQQuestlevelf
	local isHorde = AtlasKTW.isHorde
	local suffix = isHorde and "_HORDE" or ""
	local questName
	local playerLevel = UnitLevel("player")
	-- Hide inner frame if instance changed
	if AQINSTATM ~= AtlasKTW.Instances then
		HideUIPanel(KQuestInsideFrame)
	end
	-- Enable/disable general button based on instance info availability
	AQGeneralButton[_G["Inst"..AtlasKTW.Instances.."General"] and "Enable" or "Disable"](AQGeneralButton)
	-- Update current instance
	AQINSTATM = AtlasKTW.Instances
	-- Set quest count text
	local questCountKey = isHorde and "QAH" or "QAA"
	local questCount = _G["Inst"..AtlasKTW.Instances..questCountKey]
	AtlasQuestAnzahl:SetText(questCount or "")
	-- Process quests
	for b = 1, AQMAXQUESTS do
		-- Define keys for current faction
		local fquestKey = "Inst"..AtlasKTW.Instances.."Quest"..b.."FQuest"..suffix
		local preQuestKey = "Inst"..AtlasKTW.Instances.."Quest"..b.."PreQuest"..suffix
		local finishedKey = "KQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..b..suffix
		local questKey = "Inst"..AtlasKTW.Instances.."Quest"..b..suffix
		local levelKey = questKey.."_Level"
		-- Set quest line arrows
		local arrowTexture = nil
		if _G[fquestKey] then
			arrowTexture = "Interface\\Glues\\Login\\UI-BackArrow"
		elseif _G[preQuestKey] then
			arrowTexture = "Interface\\GossipFrame\\PetitionGossipIcon"
		end
		-- Check for completed quests
		if AtlasKTW.Q[finishedKey] == 1 then
			arrowTexture = "Interface\\GossipFrame\\BinderGossipIcon"
		end
		-- Apply arrow texture
		local arrow = _G["AQQuestlineArrow_"..b]
		if arrowTexture then
			arrow:SetTexture(arrowTexture)
			arrow:Show()
		else
			arrow:Hide()
		end
		-- Get quest information
		questName = _G[questKey]
		-- If quest exists, configure button
		if questName then
			AQQuestlevelf = tonumber(_G[levelKey])
			-- Determine quest color based on level
			if AQQuestlevelf then
				local levelDiff = AQQuestlevelf - playerLevel
				-- Determine color based on level difference
				if levelDiff >= -2 and levelDiff <= 2 then
					AQQuestfarbe = yellow
				elseif levelDiff > 2 and levelDiff <= 4 then
					AQQuestfarbe = orange
				elseif levelDiff > 4 and AQQuestlevelf ~= 100 then
					AQQuestfarbe = red
				elseif levelDiff < -7 then
					AQQuestfarbe = grey
				elseif levelDiff >= -7 and levelDiff < -2 then
					AQQuestfarbe = green
				end
				-- Apply color settings
				if not AtlasKTW.Q.ColourCheck then
					AQQuestfarbe = yellow
				end
				if AQQuestlevelf == 100 or KQCompareQuestLogtoQuest(b) then
					AQQuestfarbe = blue
				end
				if AtlasKTW.Q[finishedKey] == 1 then
					AQQuestfarbe = white
				end
			end
			-- Activate button and set text
			_G["AQQuestbutton"..b]:Enable()
			_G["AQBUTTONTEXT"..b]:SetText(AQQuestfarbe..questName)
		else
			-- Deactivate button if quest doesn't exist
			_G["AQQuestbutton"..b]:Disable()
			_G["AQBUTTONTEXT"..b]:SetText()
		end
	end
end

-- Check if a quest exists in the player's quest log and set appropriate color
-- Returns true if quest is found in quest log, false otherwise
function KQCompareQuestLogtoQuest(questId)
    -- Early return if quest log checking is disabled
    if not AtlasKTW.Q.CheckQuestlog then
        return false
    end
    -- Use current shown quest if no specific quest ID provided
    local targetQuest = questId or AQSHOWNQUEST
    -- Extract quest name without level prefix based on faction
    local questName
    local prefixLength = (targetQuest <= 9) and 4 or 5
	local suffix = AtlasKTW.isHorde and "_HORDE" or ""
    questName = strsub(_G["Inst"..AtlasKTW.Instances.."Quest"..targetQuest..suffix], prefixLength)
    -- Remove parentheses and content within them for better matching
    local startPos, _ = strfind(questName, " %(.*%)")
    if startPos then
        questName = strsub(questName, 1, startPos - 1)
    end
    -- Iterate through all quest log entries to find a match
    local totalQuestEntries = GetNumQuestLogEntries()
    for questIndex = 1, totalQuestEntries do
        local logQuestTitle, _, _ = GetQuestLogTitle(questIndex)
        local processedTitle = logQuestTitle
        -- Check if processed quest title matches our target quest name
        if processedTitle == questName then
            return true
        end
    end
    -- Quest not found in quest log
    return false
end

-- Events: HookScript (function)
function HookScript(frame, scriptType, handler)
    -- Store original script handler
    local originalScript = frame:GetScript(scriptType)
    -- Set new script that chains both handlers
    frame:SetScript(scriptType, function()
        -- Call original handler if it exists
        if originalScript then
            originalScript()
        end
        -- Call our new handler
        handler()
    end)
end

--******************************************
-- Events: Atlas_OnShow (Hook Atlas function)
--******************************************
-----------------------------------------------------------------------------
-- Shows the panel with atlas
-- function hooked now! thx dan for his help
-----------------------------------------------------------------------------
local original_Atlas_OnShow = Atlas_OnShow -- new line #1
function Atlas_OnShow()
    -- Handle quest frame visibility based on settings
    local function handleQuestFrameVisibility()
        if AtlasKTW.Q.WithAtlas then
            ShowUIPanel(KQuestFrame)
        else
            HideUIPanel(KQuestFrame)
        end
        HideUIPanel(KQuestInsideFrame)
    end
    -- Position quest frame if shown on right side
    local function positionQuestFrame()
        if AtlasKTW.Q.ShownSide == "Right" then
            KQuestFrame:ClearAllPoints()
            KQuestFrame:SetPoint("TOP", "AtlasFrame", 567, -36)
        end
    end
    -- Setup pfUI tooltip integration if enabled
    local function setupPfUITooltip()
        if not (AQCompareTooltip and IsAddOnLoaded("pfUI") and not KAtlasTooltip.backdrop) then
            return
        end
        -- Create pfUI tooltip backdrop
        pfUI.api.CreateBackdrop(KAtlasTooltip)
        pfUI.api.CreateBackdropShadow(KAtlasTooltip)
        -- Setup equipment comparison if available
        if pfUI.eqcompare then
            HookScript(KAtlasTooltip, "OnShow", pfUI.eqcompare.GameTooltipShow)
            HookScript(KAtlasTooltip, "OnHide", function()
                ShoppingTooltip1:Hide()
                ShoppingTooltip2:Hide()
            end)
        end
    end

    -- Execute all setup functions
    handleQuestFrameVisibility()
    positionQuestFrame()
    setupPfUITooltip()

    -- Call original show handler
    original_Atlas_OnShow()
end

--******************************************
-- Events: OnEnter/OnLeave SHOW ITEM
--******************************************
-----------------------------------------------------------------------------
-- Hide Tooltip
-----------------------------------------------------------------------------
function KQuestItem_OnLeave()
    -- Hide all tooltips when mouse leaves item
    local tooltips = {GameTooltip, KAtlasTooltip}
    local shoppingTooltips = {ShoppingTooltip1, ShoppingTooltip2}
    -- Hide main tooltips if visible
    for _, tooltip in ipairs(tooltips) do
        if tooltip:IsVisible() then
            tooltip:Hide()
            -- Also hide shopping tooltips
            for _, shoppingTip in ipairs(shoppingTooltips) do
                if shoppingTip:IsVisible() then
                    shoppingTip:Hide()
                end
            end
        end
    end
end

-----------------------------------------------------------------------------
-- Show Tooltip and automatically query server if option is enabled
-----------------------------------------------------------------------------

function KQuestItem_OnEnter()
    -- Get the base path for item data
    local basePath = string.format("Inst%dQuest%d", AtlasKTW.Instances, AQSHOWNQUEST)
    local suffix = AtlasKTW.isHorde and "_HORDE" or ""
    -- Build complete paths
    local idPath = basePath .. "ID" .. AQTHISISSHOWN .. suffix
    -- Get item data
    local itemId = _G[idPath]
    if not itemId then return end
    -- Position tooltip relative to frame
    local xOffset = -(this:GetWidth() / 2)
    KAtlasTooltip:SetOwner(this, "ANCHOR_RIGHT", xOffset, 24)
    if GetItemInfo(itemId) then
        -- Show item tooltip if item data exists
        KAtlasTooltip:SetHyperlink(string.format("item:%d:0:0:0", itemId))
    else
        -- Show error tooltip if item data not available
        KAtlasTooltip:ClearLines()
        KAtlasTooltip:AddLine(red..AQERRORNOTSHOWN)
        KAtlasTooltip:AddLine(AQERRORASKSERVER)
    end
    KAtlasTooltip:Show()
end

-----------------------------------------------------------------------------
-- Ask Server right-click
-- + shift click to send link
-- + ctrl click for dressroom
-- BIG THANKS TO Daviesh and ATLASLOOT for the CODE
-----------------------------------------------------------------------------
function KQuestItem_OnClick(mouseButton)
    -- Get item data based on faction
    local function getItemData()
        local suffix = AtlasKTW.isHorde and "_HORDE" or ""
        local baseKey = "Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST
        return {
            id = _G[baseKey.."ID"..AQTHISISSHOWN..suffix],
            color = _G[baseKey.."ITC"..AQTHISISSHOWN..suffix],
            name = _G[baseKey.."name"..AQTHISISSHOWN..suffix]
        }
    end
    local itemData = getItemData()
    -- Handle right click - show tooltip
    if mouseButton == "RightButton" then
        KAtlasTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 24)
        KAtlasTooltip:SetHyperlink(string.format("item:%d:0:0:0", itemData.id))
        KAtlasTooltip:Show()
        if not AQNoQuerySpam then
            DEFAULT_CHAT_FRAME:AddMessage(string.format("%s[%s%s%s]%s", 
                AQSERVERASK, itemData.color, itemData.name, white, AQSERVERASKInformation))
        end
        return
    end
    -- Handle shift click - insert item link
    if IsShiftKeyDown() then
        local itemName, _, itemQuality = GetItemInfo(itemData.id)
        if itemName then
            local _, _, _, hex = GetItemQualityColor(itemQuality)
            local itemLink = string.format("%s|Hitem:%d:0:0:0|h[%s]|h|r", 
                hex, itemData.id, itemName)
            ChatFrameEditBox:Insert(itemLink)
        else
            DEFAULT_CHAT_FRAME:AddMessage("Item unsafe! Right click to get the item ID")
            ChatFrameEditBox:Insert(string.format("[%s]", itemData.name))
        end
        return
    end
    -- Handle control click - dress up item
    if IsControlKeyDown() and GetItemInfo(itemData.id) then
        DressUpItemLink(itemData.id)
    end
end

-- Initialize frames on addon load
CreateKQuestFrame()
CreateKQuestOptionFrame()
KQ_OnLoad()
DEFAULT_CHAT_FRAME:AddMessage("Atlas-TW v."..ATLAS_VERSION.." loaded")