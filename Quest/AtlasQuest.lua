local _G = getfenv()
-----------------------------------------------------------------------------
-- Colours
-----------------------------------------------------------------------------

local RED = "|cffff0000"
local WHITE = "|cffFFFFFF"
local GREY = "|cff9F3FFF"
local ORANGE = "|cffff6090"
local BLUE = "|cff0070dd"

-- Quest Color
local Grau = "|cff9d9d9d"
local Gruen = "|cff1eff00"
local Orange = "|cffFF8000"
local Rot = "|cffFF0000"
local Gelb = "|cffFFd200"
local Blau = "|cff0070dd"

local AQQuestfarbe = nil

-----------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

local Initialized = nil -- the variables are not loaded yet
AtlasKTW = AtlasKTW or {}
AtlasKTW.Q = AtlasKTW.Q or {}
AtlasKTW.isHorde = AtlasKTW.isHorde or false -- variable that configures whether horde or allians is shown
AtlasKTW.Instances = 1 -- currently shown instance-pic (see Instances.lua)
AQINSTATM = "" -- variable to check whether AtlasKTW.Instances has changed (see function AtlasQuestSetTextandButtons())
--AtlasKTW.Q.ShownSide = "Left" -- configures at which side the panel is shown
--AtlasKTW.Q.WithAtlas (option to show the AQpanel automatically at atlas-startup, true/false)
-- Sets the max number of instances and quests to check for. 
local AQMAXINSTANCES = "98"
local AQMAXQUESTS = "23"
local PlayerName = UnitName("player")

-- Set title for Quest side panel
AtlasKTW.Q.ShownSide = "Left"
AtlasKTW.Q.WithAtlas = true
AQNOColourCheck = nil
AtlasQuestHelp = {}
AtlasQuestHelp[1] = "[/aq + available command: help, left/right, show/hide, autoshow\n]"

local KQuest_Defaults = {
	[PlayerName] = {
		["ShownSide"] = "Left",
		["WithAtlas"] = true,
		["NOColourCheck"] = "yes",
		["CheckQuestlog"] = "yes",
		["AutoQuery"] = "yes",
		["NoQuerySpam"] = "yes",
		["CompareTooltip"] = "yes",
	},
}

-----------------------------------------------------------------------------
-- Buttons
-----------------------------------------------------------------------------
function AQClearALL()
	AQPageCount:SetText()
	HideUIPanel(AQNextPageButton_Right)
	HideUIPanel(AQNextPageButton_Left)
	QuestName:SetText("")
	QuestLeveltext:SetText("")
	Prequesttext:SetText("")
	QuestAttainLeveltext:SetText("")
	REWARDstext:SetText()
	StoryTEXT:SetText()
	AQFQ_TEXT:SetText()
	HideUIPanel(AQFinishedQuest)
	for b=1, 6 do
		_G["AtlasQuestItemframe"..b.."_Icon"]:SetTexture()
		_G["AtlasQuestItemframe"..b.."_Name"]:SetText()
		_G["AtlasQuestItemframe"..b.."_Extra"]:SetText()
		_G["AtlasQuestItemframe"..b]:Disable()
	end
end
-----------------------------------------------------------------------------
-- upper right button / to show/close panel
-----------------------------------------------------------------------------
function AQCLOSE_OnClick()
	if KQuestFrame:IsVisible() then
		HideUIPanel(KQuestFrame)
		HideUIPanel(AtlasQuestInsideFrame)
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
	HideUIPanel(AtlasQuestInsideFrame)
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
	ShowUIPanel(AQFinishedQuest)
	AQFQ_TEXT:SetText(BLUE..AQFinishedTEXT)
	if AtlasKTW.isHorde then
		QuestName:SetText(AQQuestfarbe.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE"])
		QuestLeveltext:SetText(BLUE..AQDiscription_LEVEL..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Level"])
		QuestAttainLeveltext:SetText(BLUE..AQDiscription_ATTAIN..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Attain"]) 
		Prequesttext:SetText(BLUE..AQDiscription_PREQUEST..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Prequest"].."\n \n"..BLUE..AQDiscription_FOLGEQUEST..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Folgequest"].."\n \n"..BLUE..AQDiscription_START..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Location"].."\n \n"..BLUE..AQDiscription_AIM..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Aim"].."\n \n"..BLUE..AQDiscription_NOTE..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Note"])
		for b=1, 6 do
			REWARDstext:SetText(_G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."Rewardtext_HORDE"])
			if _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..b.."_HORDE"] ~= nil then
				-----------------------------------------------------------------------------
				-- Yay for AutoQuery. Boo for odd variable names.
				-----------------------------------------------------------------------------
				SHOWNID = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..b.."_HORDE"]
				if AQAutoQuery ~= nil then
					colour = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..b.."_HORDE"]
					nameDATA = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..b.."_HORDE"]
					if GetItemInfo(SHOWNID) == nil then
						GameTooltip:SetHyperlink("item:"..SHOWNID..":0:0:0")
						if AQNoQuerySpam == nil then
							DEFAULT_CHAT_FRAME:AddMessage(AQSERVERASK.."["..colour..nameDATA..WHITE.."]"..AQSERVERASKAuto)
						end
					end
				end
				local _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(SHOWNID)
				_G["AtlasQuestItemframe"..b.."_Icon"]:SetTexture(itemTexture)
				_G["AtlasQuestItemframe"..b.."_Name"]:SetText(AQgetItemInformation(b,"name"))
				_G["AtlasQuestItemframe"..b.."_Extra"]:SetText(AQgetItemInformation(b,"extra"))
				_G["AtlasQuestItemframe"..b]:Enable()
			else
				_G["AtlasQuestItemframe"..b.."_Icon"]:SetTexture()
				_G["AtlasQuestItemframe"..b.."_Name"]:SetText()
				_G["AtlasQuestItemframe"..b.."_Extra"]:SetText()
				_G["AtlasQuestItemframe"..b]:Disable()
			end
		end
	else
		AQCompareQLtoAQ(Quest)
		QuestName:SetText(AQQuestfarbe.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST])
		QuestLeveltext:SetText(BLUE..AQDiscription_LEVEL..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Level"])
		QuestAttainLeveltext:SetText(BLUE..AQDiscription_ATTAIN..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Attain"]) 
		Prequesttext:SetText(BLUE..AQDiscription_PREQUEST..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Prequest"].."\n \n"..BLUE..AQDiscription_FOLGEQUEST..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Folgequest"].."\n \n"..BLUE..AQDiscription_START..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Location"].."\n \n"..BLUE..AQDiscription_AIM..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Aim"].."\n \n"..BLUE..AQDiscription_NOTE..WHITE.._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Note"])
		for b=1, 6 do
			REWARDstext:SetText(_G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."Rewardtext"])
			if _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..b] ~= nil then
				-----------------------------------------------------------------------------
				-- Yay for AutoQuery. Boo for odd variable names.
				-----------------------------------------------------------------------------
				SHOWNID = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..b]

				if AQAutoQuery ~= nil then
					colour = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..b]
					nameDATA = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..b]
					if GetItemInfo(SHOWNID) == nil then
						GameTooltip:SetHyperlink("item:"..SHOWNID..":0:0:0")
						if AQNoQuerySpam == nil then
							DEFAULT_CHAT_FRAME:AddMessage(AQSERVERASK.."["..colour..nameDATA..WHITE.."]"..AQSERVERASKAuto)
						end
					end
				end
				local _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(SHOWNID)
				_G["AtlasQuestItemframe"..b.."_Icon"]:SetTexture(itemTexture)
				_G["AtlasQuestItemframe"..b.."_Name"]:SetText(AQgetItemInformation(b,"name"))
				_G["AtlasQuestItemframe"..b.."_Extra"]:SetText(AQgetItemInformation(b,"extra"))
				_G["AtlasQuestItemframe"..b]:Enable()
			else
				_G["AtlasQuestItemframe"..b.."_Icon"]:SetTexture()
				_G["AtlasQuestItemframe"..b.."_Name"]:SetText()
				_G["AtlasQuestItemframe"..b.."_Extra"]:SetText()
				_G["AtlasQuestItemframe"..b]:Disable()
			end
		end
	end
	AQQuestFinishedSetChecked()
	AQExtendedPages()
end

-----------------------------------------------------------------------------
-- improve the localisation through giving back the right and translated questname
-- sets the description text too
-- adds a error messeage to the description if item not available
-----------------------------------------------------------------------------
function AQgetItemInformation(count,what)
	local itemId
	local itemtext
	local itemdiscription
	local itemName, itemQuality
	if AtlasKTW.isHorde then
		itemId = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..count.."_HORDE"]
		itemdiscription = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."description"..count.."_HORDE"]
		itemTEXTSAVED = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..count.."_HORDE"].._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..count.."_HORDE"]
	else
		itemId = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..count]
		itemdiscription = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."description"..count]
		itemTEXTSAVED = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..count].._G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..count]
	end
	if GetItemInfo(itemId) then
		itemName, _, itemQuality = GetItemInfo(itemId)
		local r, g, b, hex = GetItemQualityColor(itemQuality)
		itemtext = hex..itemName
		if what == "name" then
			return itemtext
		elseif what == "extra" then
			return itemdiscription
		end
	else
		itemtext = itemTEXTSAVED
		if what == "name" then
			return itemtext
		elseif what == "extra" then
			itemdiscription = itemdiscription.." "..RED..AQERRORNOTSHOWN
			return itemdiscription
		end
	end
end
-----------------------------------------------------------------------------
-- set the Questcolour
-- swaped out to get the code clear
-----------------------------------------------------------------------------
function AQColourCheck(arg1)
	local AQQuestlevelf
	if arg1 == 1 then
		AQQuestlevelf = tonumber(_G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Level"])
	else
		AQQuestlevelf = tonumber(_G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Level"])
	end
	if AQQuestlevelf ~= nil or AQQuestlevelf ~= 0 or AQQuestlevelf ~= "" then
		if AQQuestlevelf == UnitLevel("player") or AQQuestlevelf == UnitLevel("player") + 2 or AQQuestlevelf == UnitLevel("player") - 2 or AQQuestlevelf == UnitLevel("player") + 1 or AQQuestlevelf == UnitLevel("player") - 1 then
			AQQuestfarbe = Gelb
		elseif AQQuestlevelf > UnitLevel("player") + 2 and AQQuestlevelf <= UnitLevel("player") + 4 then
			AQQuestfarbe = Orange
		elseif AQQuestlevelf >= UnitLevel("player") + 5 and AQQuestlevelf ~= 100 then
			AQQuestfarbe = Rot
		elseif AQQuestlevelf < UnitLevel("player") - 7 then
			AQQuestfarbe = Grau
		elseif AQQuestlevelf >= UnitLevel("player") - 7 and AQQuestlevelf < UnitLevel("player") - 2 then
			AQQuestfarbe = Gruen
		end
		if AQNOColourCheck then
			AQQuestfarbe = Gelb
		end
		if AQQuestlevelf == 100 or AQCompareQLtoAQ() then
			AQQuestfarbe = Blau
		end
		if arg1 == 1 then
			if AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST ] == 1 then
				AQQuestfarbe = WHITE
			end
		else
			if AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE" ] == 1 then
				AQQuestfarbe = WHITE
			end
		end
	end
end
-----------------------------------------------------------------------------
-- set the checkbox for the finished quest check
-- swaped out to get the code clear
-----------------------------------------------------------------------------
function AQQuestFinishedSetChecked()
	if AtlasKTW.isHorde then
		if AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE" ] == 1 then
			AQFinishedQuest:SetChecked(true)
		else
			AQFinishedQuest:SetChecked(false)
		end
	else
		if AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST ] == 1 then
			AQFinishedQuest:SetChecked(true)
		else
			AQFinishedQuest:SetChecked(false)
		end
	end
end

-----------------------------------------------------------------------------
-- Allow pages
-- InstXXQuestXX_Page = number of pages
-- HideUIPanel(AQNextPageButton_Left) AQPageCount:SetText()
-----------------------------------------------------------------------------
function AQExtendedPages()
	local SHIT
	-- SHIT is added to make the code smaller it give back the right link for horde or alliance
	if AtlasKTW.isHorde then
		SHIT = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE_Page"]
	else
		SHIT = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_Page"]
	end
	
	if type(SHIT) == "table" then
		if type(SHIT[1]) == "number" then
			ShowUIPanel(AQNextPageButton_Right)
			AQ_NextPageCount = "Quest"
			AQ_CurrentSide = 1
			AQPageCount:SetText(AQ_CurrentSide.."/"..SHIT[1])
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
		QuestName:SetText(BLUE.._G["Inst"..AtlasKTW.Instances.."Caption"])
		if type(_G["Inst"..AtlasKTW.Instances.."Story"]) == "table" then
			StoryTEXT:SetText(WHITE.._G["Inst"..AtlasKTW.Instances.."Story"]["Page1"])
			-- Show Next side button if next site is avaiable
			if _G["Inst"..AtlasKTW.Instances.."Story"]["Page2"] ~= nil then
				ShowUIPanel(AQNextPageButton_Right)
				AQ_CurrentSide = 1
				-- shows total amount of pages
				AQPageCount:SetText(AQ_CurrentSide.."/".._G["Inst"..AtlasKTW.Instances.."Story"]["MaxPages"])
				-- count to make a diffrent between story and normal text
				AQ_NextPageCount = "Story"
			end
		elseif type(_G["Inst"..AtlasKTW.Instances.."Story"]) == "string" then
			StoryTEXT:SetText(WHITE.._G["Inst"..AtlasKTW.Instances.."Story"])
		end
		-- added to work with future versions of atlas (before i update e.g. before you dl the update)
	elseif _G["Inst"..AtlasKTW.Instances.."Story"] == nil then
		QuestName:SetText("not available")
		StoryTEXT:SetText("not available")
	end
end
-----------------------------------------------------------------------------
-- shows the next side
-----------------------------------------------------------------------------
function AQNextPageR_OnClick()
	local SideAfterThis = 0
	local SHIT
	SideAfterThis = AQ_CurrentSide + 2
	AQ_CurrentSide = AQ_CurrentSide + 1
	-- first clear display
	AQClearALL()
	-- it is a story text
	if AQ_NextPageCount == "Story" then
		StoryTEXT:SetText(WHITE.._G["Inst"..AtlasKTW.Instances.."Story"]["Page"..AQ_CurrentSide])
		AQPageCount:SetText(AQ_CurrentSide.."/".._G["Inst"..AtlasKTW.Instances.."Story"]["MaxPages"])
		if _G["Inst"..AtlasKTW.Instances.."Caption"..AQ_CurrentSide] ~= nil then
			QuestName:SetText(BLUE.._G["Inst"..AtlasKTW.Instances.."Caption"..AQ_CurrentSide])
		else
			QuestName:SetText(BLUE.._G["Inst"..AtlasKTW.Instances.."Caption"])
		end
		-- hide button if no next side
		if _G["Inst"..AtlasKTW.Instances.."Story"]["Page"..SideAfterThis] == nil then
			HideUIPanel(AQNextPageButton_Right)
		else
			ShowUIPanel(AQNextPageButton_Right)
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
		StoryTEXT:SetText(WHITE..SHIT[AQ_CurrentSide])
		AQPageCount:SetText(AQ_CurrentSide.."/"..SHIT[1])
		-- hide button if no next side
		if SHIT[SideAfterThis] == nil then
			HideUIPanel(AQNextPageButton_Right)
		else
			ShowUIPanel(AQNextPageButton_Right)
		end
	end
	-- it is a boss text
	if AQ_NextPageCount == "Boss" then
		QuestName:SetText(BLUE.._G["Inst"..AtlasKTW.Instances.."General"][AQ_CurrentSide][1])
		StoryTEXT:SetText(WHITE.._G["Inst"..AtlasKTW.Instances.."General"][AQ_CurrentSide][2].."\n \n".._G["Inst"..AtlasKTW.Instances.."General"][AQ_CurrentSide][3])
		-- Show Next side button if next site is avaiable
		if _G["Inst"..AtlasKTW.Instances.."General"][SideAfterThis] ~= nil then
			ShowUIPanel(AQNextPageButton_Right)
		end
		-- shows total amount of pages
		AQPageCount:SetText(AQ_CurrentSide.."/"..getn(_G["Inst"..AtlasKTW.Instances.."General"]))
	end
	-- Show backwards button
	ShowUIPanel(AQNextPageButton_Left)
end

-----------------------------------------------------------------------------
-- shows the side before this side
-----------------------------------------------------------------------------
function AQNextPageL_OnClick()
	local SHIT
	AQ_CurrentSide = AQ_CurrentSide - 1
	-- it is a story text
	if AQ_NextPageCount == "Story" then
		StoryTEXT:SetText(WHITE.._G["Inst"..AtlasKTW.Instances.."Story"]["Page"..AQ_CurrentSide])
		AQPageCount:SetText(AQ_CurrentSide.."/".._G["Inst"..AtlasKTW.Instances.."Story"]["MaxPages"])
		if _G["Inst"..AtlasKTW.Instances.."Caption"..AQ_CurrentSide] ~= nil then
			QuestName:SetText(BLUE.._G["Inst"..AtlasKTW.Instances.."Caption"..AQ_CurrentSide])
		else
			QuestName:SetText(BLUE.._G["Inst"..AtlasKTW.Instances.."Caption"])
		end
		-- hide button if first side
		if AQ_CurrentSide == 1 then
			HideUIPanel(AQNextPageButton_Left)
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
		if AQ_CurrentSide == 1 then
			AQButton_SetText()
		else
			StoryTEXT:SetText(WHITE..SHIT[AQ_CurrentSide])
		end
		AQPageCount:SetText(AQ_CurrentSide.."/"..SHIT[1])
	end
	-- it is a boss text
	if AQ_NextPageCount == "Boss" then
		QuestName:SetText(BLUE.._G["Inst"..AtlasKTW.Instances.."General"][AQ_CurrentSide][1])
		StoryTEXT:SetText(WHITE.._G["Inst"..AtlasKTW.Instances.."General"][AQ_CurrentSide][2].."\n \n".._G["Inst"..AtlasKTW.Instances.."General"][AQ_CurrentSide][3])
		-- Show Next side button if next site is avaiable
		if AQ_CurrentSide == 1 then
			HideUIPanel(AQNextPageButton_Left)
		end
		-- shows total amount of pages
		AQPageCount:SetText(AQ_CurrentSide.."/"..getn(_G["Inst"..AtlasKTW.Instances.."General"]))
	end
	ShowUIPanel(AQNextPageButton_Right)
end

-----------------------------------------------------------------------------
-- Checkbox for the finished quest option
-----------------------------------------------------------------------------
function AQFinishedQuest_OnClick()
	if AQFinishedQuest:GetChecked() and not AtlasKTW.isHorde then
		AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST ] = 1
		setglobal("AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST , 1);
	elseif AQFinishedQuest:GetChecked() and AtlasKTW.isHorde then
		AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE" ] = 1
	elseif not AQFinishedQuest:GetChecked() and not AtlasKTW.isHorde then
		AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST ] = nil
	elseif not AQFinishedQuest:GetChecked() and AtlasKTW.isHorde then
		AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE" ] = nil
	end
	--save everything
	if AtlasKTW.isHorde then
		KQuest_Options[UnitName("player")]["AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE"] = AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."_HORDE" ]
	else
		KQuest_Options[UnitName("player")]["AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST] = AtlasKTW.Q[ "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST ]
	end
	AtlasQuestSetTextandButtons()
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
	if not KQuest_Options then
		KQuest_Options = KQuest_Defaults
		DEFAULT_CHAT_FRAME:AddMessage("AtlasQuest Options database not found. Generating...")
	elseif not KQuest_Options[PlayerName] then
		DEFAULT_CHAT_FRAME:AddMessage("Generate default database for this character")
		KQuest_Options[PlayerName] = KQuest_Defaults[PlayerName]
	end
	if type(KQuest_Options[PlayerName]) == "table" then
		KQuest_LoadData()
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
	if KQuest_Options[PlayerName]["ShownSide"] ~= nil then
		AtlasKTW.Q.ShownSide = KQuest_Options[PlayerName]["ShownSide"]
	end
	-- atlas autoshow
	if KQuest_Options[PlayerName]["WithAtlas"] ~= nil then
		AtlasKTW.Q.WithAtlas = KQuest_Options[PlayerName]["WithAtlas"]
	end
	-- Colour Check? if nil = no cc if true = cc
	AQNOColourCheck = KQuest_Options[PlayerName]["ColourCheck"]
	-- Finished? 
	for i=1, AQMAXINSTANCES do
		for b=1, AQMAXQUESTS do
			AtlasKTW.Q[ "AQFinishedQuest_Inst"..i.."Quest"..b ] = KQuest_Options[PlayerName]["AQFinishedQuest_Inst"..i.."Quest"..b]
			AtlasKTW.Q[ "AQFinishedQuest_Inst"..i.."Quest"..b.."_HORDE" ] = KQuest_Options[PlayerName]["AQFinishedQuest_Inst"..i.."Quest"..b.."_HORDE"]
		end
	end
	--AQCheckQuestlog
	AQCheckQuestlog = KQuest_Options[PlayerName]["CheckQuestlog"]
	-- AutoQuery option
	AQAutoQuery = KQuest_Options[PlayerName]["AutoQuery"]
	-- Suppress Server Query Text option
	AQNoQuerySpam = KQuest_Options[PlayerName]["NoQuerySpam"]
	-- Comparison Tooltips option
	AQCompareTooltip = KQuest_Options[PlayerName]["CompareTooltip"]
	
end

-----------------------------------------------------------------------------
-- Saves the variables
-----------------------------------------------------------------------------
function KQuest_SaveData()
	-- Save the variables
	KQuest_Options[PlayerName]["ShownSide"] = AtlasKTW.Q.ShownSide
	KQuest_Options[PlayerName]["WithAtlas"] = AtlasKTW.Q.WithAtlas
	KQuest_Options[PlayerName]["ColourCheck"] = AQNOColourCheck
	KQuest_Options[PlayerName]["CheckQuestlog"] = AQCheckQuestlog
	KQuest_Options[PlayerName]["AutoQuery"] = AQAutoQuery
	KQuest_Options[PlayerName]["NoQuerySpam"] = AQNoQuerySpam
	KQuest_Options[PlayerName]["CompareTooltip"] = AQCompareTooltip
end

--******************************************
-- Events: OnLoad
--******************************************

-----------------------------------------------------------------------------
-- Call OnLoad set Variables and hides the panel
-----------------------------------------------------------------------------
function KQ_OnLoad()
	KQSetButtontext() -- translation for all buttons
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
-- Slashcommand!! show/hide panel
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Slash command handler for AtlasQuest
-- Processes user commands entered via /aq or /atlasquest
-- @param param - The command parameter string entered by the user
-----------------------------------------------------------------------------
function atlasquest_command(param)
    -- Always show help text as a default response
    ChatFrame1:AddMessage(RED..AQHelpText)
    
    -- Convert param to lowercase for case-insensitive matching
    local cmd = string.lower(param or "")
    
    -- Command handler table - maps commands to their handler functions
    local commands = {
        -- Help command
        ["help"] = function()
            ChatFrame1:AddMessage(RED..AQHelpText)
        end,
        
        -- Panel visibility commands
        ["show"] = function()
            ShowUIPanel(KQuestFrame)
            ChatFrame1:AddMessage("Shows Quest Panel")
        end,
        ["hide"] = function()
            HideUIPanel(KQuestFrame)
            HideUIPanel(AtlasQuestInsideFrame)
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
            ChatFrame1:AddMessage(RED.._G["Inst"..AtlasKTW.Instances.."Caption"])
            ChatFrame1:AddMessage(GREY.._G["Inst"..AtlasKTW.Instances.."QAA"])
            for q=1,23 do
                local questName = _G["Inst"..AtlasKTW.Instances.."Quest"..q]
                if questName then
                    ChatFrame1:AddMessage(Orange..questName)
                end
            end
        end,
        -- Horde quest list command
        ["inst h"] = function()
            ChatFrame1:AddMessage(RED.._G["Inst"..AtlasKTW.Instances.."Caption"])
            ChatFrame1:AddMessage(GREY.._G["Inst"..AtlasKTW.Instances.."QAH"])
            for q=1,23 do
                local questName = _G["Inst"..AtlasKTW.Instances.."Quest"..q.."_HORDE"]
                if questName then
                    ChatFrame1:AddMessage(Orange..questName)
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
    ChatFrame1:AddMessage(RED.._G["Inst"..AtlasKTW.Instances.."Caption"])

    -- Alliance quest details
    local allianceQuestName = _G["Inst"..AtlasKTW.Instances.."Quest"..questNum]
    if allianceQuestName then
        ChatFrame1:AddMessage(ORANGE.."Alliance Quest: "..allianceQuestName)
        ChatFrame1:AddMessage("Level: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_Level"] or "N/A")
        ChatFrame1:AddMessage("Attain: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_Attain"] or "N/A")
        ChatFrame1:AddMessage("Goal: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_Aim"] or "N/A")
        ChatFrame1:AddMessage("Start: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_Location"] or "N/A")
        ChatFrame1:AddMessage("Note: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_Note"] or "N/A")
        ChatFrame1:AddMessage("Prequest: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_Prequest"] or "None")
        ChatFrame1:AddMessage("Postquest: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_Folgequest"] or "None")
    end

    -- Horde quest details
    local hordeQuestName = _G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_HORDE"]
    if hordeQuestName then
        ChatFrame1:AddMessage(ORANGE.."Horde Quest: "..hordeQuestName)
        ChatFrame1:AddMessage("Level: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_HORDE_Level"] or "N/A")
        ChatFrame1:AddMessage("Attain: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_HORDE_Attain"] or "N/A")
        ChatFrame1:AddMessage("Goal: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_HORDE_Aim"] or "N/A")
        ChatFrame1:AddMessage("Start: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_HORDE_Location"] or "N/A")
        ChatFrame1:AddMessage("Note: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_HORDE_Note"] or "N/A")
        ChatFrame1:AddMessage("Prequest: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_HORDE_Prequest"] or "None")
        ChatFrame1:AddMessage("Postquest: ".._G["Inst"..AtlasKTW.Instances.."Quest"..questNum.."_HORDE_Folgequest"] or "None")
    end
end

-----------------------------------------------------------------------------
-- Set the button text
-----------------------------------------------------------------------------
function KQSetButtontext()
	STORYbutton:SetText(AQStoryB)
	OPTIONbutton:SetText(AQOptionB)
	AQOptionCloseButton:SetText(AQ_OK)
	KQAutoshowOptionTEXT:SetText(AQOptionsAutoshowTEXT)
	AQLEFTOptionTEXT:SetText(AQOptionsLEFTTEXT)
	AQRIGHTOptionTEXT:SetText(AQOptionsRIGHTTEXT)
	AQColourOptionTEXT:SetText(AQOptionsCCTEXT)
	AQFQ_TEXT:SetText(AQFinishedTEXT)
	AQCheckQuestlogTEXT:SetText(AQQLColourChange)
	AQAutoQueryTEXT:SetText(AQOptionsAutoQueryTEXT)
	AQNoQuerySpamTEXT:SetText(AQOptionsNoQuerySpamTEXT)
	AQCompareTooltipTEXT:SetText(AQOptionsCompareTooltipTEXT)
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
	local insideFrame = AtlasQuestInsideFrame
	-- Check if we need to hide/update the quest panels
	if AtlasKTW.Instances == 99 then
		-- Hide both panels if no quests available
		HideUIPanel(questFrame)
		HideUIPanel(insideFrame)
	elseif AtlasKTW.Instances ~= previousInstance or AtlasKTW.QUpdateNOW then
		-- Update quest text and buttons if instance changed or update forced
		AtlasQuestSetTextandButtons()
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
function AtlasQuestSetTextandButtons()
	local AQQuestlevelf
	local playerLevel = UnitLevel("player")
	local isHorde = AtlasKTW.isHorde
	local suffix = isHorde and "_HORDE" or ""
	local questName
	-- Hide inner frame if instance changed
	if AQINSTATM ~= AtlasKTW.Instances then
		HideUIPanel(AtlasQuestInsideFrame)
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
		local finishedKey = "AQFinishedQuest_Inst"..AtlasKTW.Instances.."Quest"..b..suffix
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
				if levelDiff >= -2 and levelDiff <= 2 then
					AQQuestfarbe = Gelb
				elseif levelDiff > 2 and levelDiff <= 4 then
					AQQuestfarbe = Orange
				elseif levelDiff > 4 and AQQuestlevelf ~= 100 then
					AQQuestfarbe = Rot
				elseif levelDiff < -7 then
					AQQuestfarbe = Grau
				elseif levelDiff >= -7 and levelDiff < -2 then
					AQQuestfarbe = Gruen
				end
				-- Apply color settings
				if AQNOColourCheck then
					AQQuestfarbe = Gelb
				end
				if AQQuestlevelf == 100 or AQCompareQLtoAQ(b) then
					AQQuestfarbe = Blau
				end
				if AtlasKTW.Q[finishedKey] == 1 then
					AQQuestfarbe = WHITE
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
-----------------------------------------------------------------------------
-- Colours quest blue if they are in your questlog
-----------------------------------------------------------------------------
function AQCompareQLtoAQ(Quest)
	local TotalQuestEntries
	local OnlyQuestNameRemovedNumber
	local Questisthere
	local x
	local y
	local z
	local count
	if AQCheckQuestlog == nil then -- Option to turn the check on or off
		if Quest == nil then -- added for use in button text to change the caption dunno whether i add it or not
			Quest = AQSHOWNQUEST
		end
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
		--this checks should be done everytime when the questupdate event gets executed
		TotalQuestEntries = GetNumQuestLogEntries()
		for CurrentQuestnum=1, TotalQuestEntries do
			x, y, z = GetQuestLogTitle(CurrentQuestnum)
			TotalQuestsTable = {
				[CurrentQuestnum] = x,
			}
			if CT_Core and CT_Core:getOption("questLevels") == 1 then
				count = 4
				if y > 10 then
					count = count + 2
				else
					count = count + 1
				end
				if z == ELITE  or  z == RAID  or  z == "Dungeon"  or  z == "Donjon" then
					count = count + 1
				end
				TotalQuestsTable = {
					[CurrentQuestnum] = strsub(x, count)
				}
			end

			-- Code from Denival to remove parentheses and anything in it so Color Quests blue option works.
			ps, pe = strfind(OnlyQuestNameRemovedNumber," %(.*%)")
			if ps then
				OnlyQuestNameRemovedNumber = strsub(OnlyQuestNameRemovedNumber,1,ps-1)
			end
			--expect this
			if TotalQuestsTable[CurrentQuestnum] == OnlyQuestNameRemovedNumber then
				Questisthere = 1
			end
		end
		if Questisthere == 1 then
			return true
		else
			return false
		end
		--
	else
		return false
	end
end

-- Events: HookScript (function)

function HookScript(f, script, func)
  local prev = f:GetScript(script)
  f:SetScript(script, function(a1,a2,a3,a4,a5,a6,a7,a8,a9)
    if prev then prev(a1,a2,a3,a4,a5,a6,a7,a8,a9) end
    func(a1,a2,a3,a4,a5,a6,a7,a8,a9)
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
	if AtlasKTW.Q.WithAtlas then
		ShowUIPanel(KQuestFrame)
	else
		HideUIPanel(KQuestFrame)
	end
	HideUIPanel(AtlasQuestInsideFrame)
	if AtlasKTW.Q.ShownSide == "Right" then
		KQuestFrame:ClearAllPoints()
		KQuestFrame:SetPoint("TOP","AtlasFrame", 567, -36)
	end
	if AQCompareTooltip ~= nil and IsAddOnLoaded("pfUI") and not KAtlasTooltip.backdrop then
		pfUI.api.CreateBackdrop(KAtlasTooltip)
		pfUI.api.CreateBackdropShadow(KAtlasTooltip)
		if pfUI.eqcompare then
			HookScript(KAtlasTooltip, "OnShow", pfUI.eqcompare.GameTooltipShow)
			HookScript(KAtlasTooltip, "OnHide", function()
				ShoppingTooltip1:Hide()
				ShoppingTooltip2:Hide()
			end)
		end
	end
	original_Atlas_OnShow() -- new line #2
end

--******************************************
-- Events: OnEnter/OnLeave SHOW ITEM
--******************************************
-----------------------------------------------------------------------------
-- Hide Tooltip
-----------------------------------------------------------------------------

function AtlasQuestItem_OnLeave()
	if GameTooltip:IsVisible() then
		GameTooltip:Hide()
		if ShoppingTooltip2:IsVisible() or ShoppingTooltip1.IsVisible then
			ShoppingTooltip2:Hide()
			ShoppingTooltip1:Hide()
		end
	end
	if KAtlasTooltip:IsVisible() then
		KAtlasTooltip:Hide()
		if ShoppingTooltip2:IsVisible() or ShoppingTooltip1.IsVisible then
			ShoppingTooltip2:Hide()
			ShoppingTooltip1:Hide()
		end
	end
end

-----------------------------------------------------------------------------
-- Show Tooltip and automatically query server if option is enabled
-----------------------------------------------------------------------------

function AtlasQuestItem_OnEnter()
	local SHOWNID
	if AtlasKTW.isHorde then
		SHOWNID = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN.."_HORDE"]
		colour = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..AQTHISISSHOWN.."_HORDE"]
		nameDATA = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..AQTHISISSHOWN.."_HORDE"]
	else
		SHOWNID = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN]
		colour = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..AQTHISISSHOWN]
		nameDATA = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..AQTHISISSHOWN]
	end
	if SHOWNID ~= nil then
		if GetItemInfo(SHOWNID) ~= nil then
			KAtlasTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 24)
			KAtlasTooltip:SetHyperlink("item:"..SHOWNID..":0:0:0")
			KAtlasTooltip:Show()
		else
			KAtlasTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 24)
			KAtlasTooltip:ClearLines()
			KAtlasTooltip:AddLine(RED..AQERRORNOTSHOWN)
			KAtlasTooltip:AddLine(AQERRORASKSERVER)
			KAtlasTooltip:Show()
		end
	end
end

-----------------------------------------------------------------------------
-- Ask Server right-click
-- + shift click to send link
-- + ctrl click for dressroom
-- BIG THANKS TO Daviesh and ATLASLOOT for the CODE
-----------------------------------------------------------------------------
function AtlasQuestItem_OnClick(arg1)
	local SHOWNID
	local nameDATA
	local colour
	local itemName, itemQuality
	if AtlasKTW.isHorde then
		SHOWNID = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN.."_HORDE"]
		colour = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..AQTHISISSHOWN.."_HORDE"]
		nameDATA = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..AQTHISISSHOWN.."_HORDE"]
	else
		SHOWNID = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN]
		colour = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."ITC"..AQTHISISSHOWN]
		nameDATA = _G["Inst"..AtlasKTW.Instances.."Quest"..AQSHOWNQUEST.."name"..AQTHISISSHOWN]
	end
	if arg1=="RightButton" then
		KAtlasTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 24)
		KAtlasTooltip:SetHyperlink("item:"..SHOWNID..":0:0:0")
		KAtlasTooltip:Show()
		if AQNoQuerySpam == nil then
			DEFAULT_CHAT_FRAME:AddMessage(AQSERVERASK.."["..colour..nameDATA..WHITE.."]"..AQSERVERASKInformation)
		end
	elseif IsShiftKeyDown() then
		if GetItemInfo(SHOWNID) then
			itemName, itemLink, itemQuality = GetItemInfo(SHOWNID)
			local r, g, b, hex = GetItemQualityColor(itemQuality)
			itemtext = hex..itemName
			ChatFrameEditBox:Insert(hex.."|Hitem:"..SHOWNID..":0:0:0|h["..itemName.."]|h|r")
		else
			DEFAULT_CHAT_FRAME:AddMessage("Item unsafe! Right click to get the item ID")
			ChatFrameEditBox:Insert("["..nameDATA.."]")
		end
		--If control-clicked, use the dressing room
	elseif IsControlKeyDown() and GetItemInfo(SHOWNID) then
		DressUpItemLink(SHOWNID)
	end
end

-- Initialize frames on addon load
CreateKQuestFrame()
CreateKQuestOptionFrame()
KQ_OnLoad()
DEFAULT_CHAT_FRAME:AddMessage("Atlas-TW v."..ATLAS_VERSION.." loaded")