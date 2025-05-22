local _G = getfenv()
-----------------------------------------------------------------------------
-- Colours
-----------------------------------------------------------------------------

local RED = "|cffff0000"
local WHITE = "|cffFFFFFF"
local GREY = "|cff9F3FFF"
local ORANGE = "|cffff6090"

-- Quest Color
local Grau = "|cff9d9d9d"
local Gruen = "|cff1eff00"
local Orange = "|cffFF8000"
local Rot = "|cffFF0000"
local Gelb = "|cffFFd200"
local Blau = "|cff0070dd"

-----------------------------------------------------------------------------
-- Variables
-----------------------------------------------------------------------------

local Initialized = nil -- the variables are not loaded yet
local TooltipInitForPfUI = nil
AtlasKTW = AtlasKTW or {}
AtlasKTW.isHorde = AtlasKTW.isHorde or false -- variable that configures whether horde or allians is shown
AQINSTANCE = 1 -- currently shown instance-pic (see Instances.lua)
AQINSTATM = "" -- variable to check whether AQINSTANCE has changed (see function AtlasQuestSetTextandButtons())
--AQ_ShownSide = "Left" -- configures at which side the AQ panel is shown
--AQAtlasAuto (option to show the AQpanel automatically at atlas-startup, 1=yes 2=no)
-- Sets the max number of instances and quests to check for. 
local AQMAXINSTANCES = "98"
local AQMAXQUESTS = "23"
local PlayerName = UnitName("player")

-- Set title for AtlasQuest side panel
AQ_ShownSide = "Left"
AQAtlasAuto = 1
AQNOColourCheck = nil
AtlasQuestHelp = {}
AtlasQuestHelp[1] = "[/aq + available command: help, left/right, show/hide, autoshow\n]"

local AtlasQuest_Defaults = {
	[PlayerName] = {
		["ShownSide"] = "Left",
		["AtlasAutoShow"] = 1,
		["NOColourCheck"] = "yes",
		["CheckQuestlog"] = "yes",
		["AutoQuery"] = "yes",
		["NoQuerySpam"] = "yes",
		["CompareTooltip"] = "yes",
	},
}

AQ = {}

-----------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------
--******************************************
-- Events: OnEvent
--******************************************

-----------------------------------------------------------------------------
-- Called when the player starts the game loads the variables
-----------------------------------------------------------------------------
function AtlasQuest_OnEvent()
	if event == "VARIABLES_LOADED" then
		VariablesLoaded = 1 -- data is loaded completely
	else
		AtlasQuest_Initialize() -- player enters world / initialize the data
	end
end

-----------------------------------------------------------------------------
-- Detects whether the variables have to be loaded
-- or reestablishes them
-----------------------------------------------------------------------------
function AtlasQuest_Initialize()
	if Initialized or (not VariablesLoaded) then
		return
	end
	if not AtlasQuest_Options then
		AtlasQuest_Options = AtlasQuest_Defaults
		DEFAULT_CHAT_FRAME:AddMessage("AtlasQuest Options database not found. Generating...")
	elseif not AtlasQuest_Options[PlayerName] then
		DEFAULT_CHAT_FRAME:AddMessage("Generate default database for this character")
		AtlasQuest_Options[PlayerName] = AtlasQuest_Defaults[PlayerName]
	end
	if type(AtlasQuest_Options[PlayerName]) == "table" then
		AtlasQuest_LoadData()
	end

	-- Register AQ Tooltip with EquipCompare if enabled.
	if AQCompareTooltip ~= nil then
		QuestOtwoRegisterTooltip()
	else
		QuestOtwoUnregisterTooltip()
	end
	Initialized = 1
end

-----------------------------------------------------------------------------
-- Loads the saved variables
-----------------------------------------------------------------------------
function AtlasQuest_LoadData()
	-- Which side
	if AtlasQuest_Options[PlayerName]["ShownSide"] ~= nil then
		AQ_ShownSide = AtlasQuest_Options[PlayerName]["ShownSide"]
	end
	-- atlas autoshow
	if AtlasQuest_Options[PlayerName]["AtlasAutoShow"] ~= nil then
		AQAtlasAuto = AtlasQuest_Options[PlayerName]["AtlasAutoShow"]
	end
	-- Colour Check? if nil = no cc if true = cc
	AQNOColourCheck = AtlasQuest_Options[PlayerName]["ColourCheck"]
	-- Finished? 
	for i=1, AQMAXINSTANCES do
		for b=1, AQMAXQUESTS do
			AQ[ "AQFinishedQuest_Inst"..i.."Quest"..b ] = AtlasQuest_Options[PlayerName]["AQFinishedQuest_Inst"..i.."Quest"..b]
			AQ[ "AQFinishedQuest_Inst"..i.."Quest"..b.."_HORDE" ] = AtlasQuest_Options[PlayerName]["AQFinishedQuest_Inst"..i.."Quest"..b.."_HORDE"]
		end
	end
	--AQCheckQuestlog
	AQCheckQuestlog = AtlasQuest_Options[PlayerName]["CheckQuestlog"]
	-- AutoQuery option
	AQAutoQuery = AtlasQuest_Options[PlayerName]["AutoQuery"]
	-- Suppress Server Query Text option
	AQNoQuerySpam = AtlasQuest_Options[PlayerName]["NoQuerySpam"]
	-- Comparison Tooltips option
	AQCompareTooltip = AtlasQuest_Options[PlayerName]["CompareTooltip"]
	
end

-----------------------------------------------------------------------------
-- Saves the variables
-----------------------------------------------------------------------------
function AtlasQuest_SaveData()
	-- Save the variables
	AtlasQuest_Options[PlayerName]["ShownSide"] = AQ_ShownSide
	AtlasQuest_Options[PlayerName]["AtlasAutoShow"] = AQAtlasAuto
	AtlasQuest_Options[PlayerName]["ColourCheck"] = AQNOColourCheck
	AtlasQuest_Options[PlayerName]["CheckQuestlog"] = AQCheckQuestlog
	AtlasQuest_Options[PlayerName]["AutoQuery"] = AQAutoQuery
	AtlasQuest_Options[PlayerName]["NoQuerySpam"] = AQNoQuerySpam
	AtlasQuest_Options[PlayerName]["CompareTooltip"] = AQCompareTooltip
end

--******************************************
-- Events: OnLoad
--******************************************

-----------------------------------------------------------------------------
-- Call OnLoad set Variables and hides the panel
-----------------------------------------------------------------------------
function AQ_OnLoad()
	AQSetButtontext() -- translation for all buttons
	AQATLASMAP = AtlasMap:GetTexture()
	AQSlashCommandfunction()
	AQUpdateNOW = true
end

-----------------------------------------------------------------------------
-- Slash command added
-----------------------------------------------------------------------------
function AQSlashCommandfunction()
	SlashCmdList["ATLASQ"]=atlasquest_command
	SLASH_ATLASQ1="/aq"
	SLASH_ATLASQ2="/atlasquest"
end

-----------------------------------------------------------------------------
-- Set the button text
-----------------------------------------------------------------------------
function AQSetButtontext()
	STORYbutton:SetText(AQStoryB)
	OPTIONbutton:SetText(AQOptionB)
	AQOptionCloseButton:SetText(AQ_OK)
	AQAutoshowOptionTEXT:SetText(AQOptionsAutoshowTEXT)
	AQLEFTOptionTEXT:SetText(AQOptionsLEFTTEXT)
	AQRIGHTOptionTEXT:SetText(AQOptionsRIGHTTEXT)
	AQColourOptionTEXT:SetText(AQOptionsCCTEXT)
	AQFQ_TEXT:SetText(AQFinishedTEXT)
	AQCheckQuestlogTEXT:SetText(AQQLColourChange)
	AQAutoQueryTEXT:SetText(AQOptionsAutoQueryTEXT)
	AQNoQuerySpamTEXT:SetText(AQOptionsNoQuerySpamTEXT)
	AQCompareTooltipTEXT:SetText(AQOptionsCompareTooltipTEXT)
end

-----------------------------------------------------------------------------
-- Slashcommand!! show/hide panel
-----------------------------------------------------------------------------
function atlasquest_command(param)

	-- Show help text if no /aq command used.
	ChatFrame1:AddMessage(RED..AQHelpText)

	--help text
	if param == "help" then
		ChatFrame1:AddMessage(RED..AQHelpText)
		-- hide show function
	elseif param == "show" then
		ShowUIPanel(AtlasQuestFrame)
		ChatFrame1:AddMessage("Shows AtlasQuest")
	elseif param == "hide" then
		HideUIPanel(AtlasQuestFrame)
		HideUIPanel(AtlasQuestInsideFrame)
		ChatFrame1:AddMessage("Hides AtlasQuest")
		-- right/left show function
	elseif param == "right" then
		AQRIGHTOption_OnClick()
	elseif param == "left" then
		AQLEFTOption_OnClick()
		-- Options
	elseif param == "option" or param == "config" then
		ShowUIPanel(AtlasQuestOptionFrame)
		--test messages
	elseif param == "test" then
		AQTestmessages()
		-- autoshow
	elseif param == "autoshow" then
		AQAutoshowOption_OnClick()
		-- CC
	elseif param == "colour" then
		AQColourOption_OnClick()
		--List of Instances
	elseif param == "list" then
		ChatFrame1:AddMessage("Instances, and Numbers (Alphabetical Order):")
    	ChatFrame1:AddMessage("Black Morass: 33"); -- TurtleWOW
		ChatFrame1:AddMessage("Blackfathom Deeps: 7")
		ChatFrame1:AddMessage("Blackrock Depths: 5")
		ChatFrame1:AddMessage("Blackrock Spire (Lower): 8")
		ChatFrame1:AddMessage("Blackrock Spire (Upper): 9")
		ChatFrame1:AddMessage("Blackwing Lair: 6")
		ChatFrame1:AddMessage("Deadmines: 1")
		ChatFrame1:AddMessage("Dire Maul: 10")
    	ChatFrame1:AddMessage("Emerald Sanctum: 37"); -- TurtleWOW 1.17.0
    	ChatFrame1:AddMessage("Gilneas City: 35"); -- TurtleWOW 1.17.0
		ChatFrame1:AddMessage("Gnomeregan: 29")
    	ChatFrame1:AddMessage("Hateforge Quarry: 31"); -- TurtleWOW
    	ChatFrame1:AddMessage("Karazhan Crypt: 34"); -- TurtleWOW
    	ChatFrame1:AddMessage("Lower Karazhan Halls: 36"); -- TurtleWOW 1.17.0
		ChatFrame1:AddMessage("Maraudon: 13")
		ChatFrame1:AddMessage("Molten Core: 14")
		ChatFrame1:AddMessage("Naxxramas: 15")
		ChatFrame1:AddMessage("Onyxia's Lair: 16")
		ChatFrame1:AddMessage("RageFire Chasm: 3")
		ChatFrame1:AddMessage("Razorfen Downs: 17")
		ChatFrame1:AddMessage("Razorfen Kraul: 18")
		ChatFrame1:AddMessage("Scarlet Monestary: 19")
		ChatFrame1:AddMessage("Scholomance: 20")
		ChatFrame1:AddMessage("Shadowfang Keep: 21")
    	ChatFrame1:AddMessage("Stormwind Vault: 32"); -- TurtleWOW
		ChatFrame1:AddMessage("Stratholme: 22")
    	ChatFrame1:AddMessage("Tower of Karazhan: 38"); -- TurtleWOW 1.17.2
    	ChatFrame1:AddMessage("The Crescent Grove: 30"); -- TurtleWOW
		ChatFrame1:AddMessage("The Ruins of Ahn Qiraj: 23")
		ChatFrame1:AddMessage("The Stockade: 24")
		ChatFrame1:AddMessage("The Sunken Temple: 25")
		ChatFrame1:AddMessage("The Temple of Ahn Qiraj: 26")
		ChatFrame1:AddMessage("Uldaman: 4")
		ChatFrame1:AddMessage("Wailing Caverns: 2")
		ChatFrame1:AddMessage("Zul Farrak: 27")
		ChatFrame1:AddMessage("Zul Gurub: 28")
		--List of Alliance Quests
	elseif param == "inst a" then
		ChatFrame1:AddMessage(RED.._G["Inst"..AQINSTANCE.."Caption"])
		ChatFrame1:AddMessage(GREY.._G["Inst"..AQINSTANCE.."QAA"])
		for q=1,23 do
			ChatFrame1:AddMessage(Orange.._G["Inst"..AQINSTANCE.."Quest"..q])
		end
		--List of Horde Quests
	elseif param == "inst h" then
		ChatFrame1:AddMessage(RED.._G["Inst"..AQINSTANCE.."Caption"])
		ChatFrame1:AddMessage(GREY.._G["Inst"..AQINSTANCE.."QAH"])
		for q=1,23 do
			ChatFrame1:AddMessage(Orange.._G["Inst"..AQINSTANCE.."Quest"..q.."_HORDE"])
		end

		-- Very temporary fix to /AQ bug. Must find way to check if Param is an Integer. Where's isint()?
	elseif param == "1" then 
		ChatFrame1:AddMessage(RED.._G["Inst"..AQINSTANCE.."Caption"])

		--Alliance
		ChatFrame1:AddMessage(ORANGE.."Alliance Quest: ".._G["Inst"..AQINSTANCE.."Quest"..param])
		ChatFrame1:AddMessage("Level: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_Level"])
		ChatFrame1:AddMessage("Attain: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_Attain"])
		ChatFrame1:AddMessage("Goal: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_Aim"])
		ChatFrame1:AddMessage("Start: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_Location"])
		ChatFrame1:AddMessage("Note: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_Note"])
		ChatFrame1:AddMessage("Prequest: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_Prequest"])
		ChatFrame1:AddMessage("Postquest: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_Folgequest"])

		--Horde
		ChatFrame1:AddMessage(ORANGE.."Horde Quest: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_HORDE"])
		ChatFrame1:AddMessage("Level: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_HORDE_Level"])
		ChatFrame1:AddMessage("Attain: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_HORDE_Attain"])
		ChatFrame1:AddMessage("Goal: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_HORDE_Aim"])
		ChatFrame1:AddMessage("Start: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_HORDE_Location"])
		ChatFrame1:AddMessage("Note: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_HORDE_Note"])
		ChatFrame1:AddMessage("Prequest: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_HORDE_Prequest"])
		ChatFrame1:AddMessage("Postquest: ".._G["Inst"..AQINSTANCE.."Quest"..param.."_HORDE_Folgequest"])
	end
end

--******************************************
-- Events: OnUpdate
--******************************************
-----------------------------------------------------------------------------
-- hide panel if instance is 99 (nothing)
-----------------------------------------------------------------------------
function AQ_OnUpdate(arg1)
	local previousInstance = AQINSTANCE
	AtlasQuest_Instances()
	-- Cache UI panels for better performance
	local questFrame = AtlasQuestFrame
	local insideFrame = AtlasQuestInsideFrame
	-- Check if we need to hide/update the quest panels
	if AQINSTANCE == 99 then
		-- Hide both panels if no quests available
		HideUIPanel(questFrame)
		HideUIPanel(insideFrame)
	elseif AQINSTANCE ~= previousInstance or AQUpdateNOW then
		-- Update quest text and buttons if instance changed or update forced
		AtlasQuestSetTextandButtons()
		AQUpdateNOW = false
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
	local AQQuestfarbe
	local playerLevel = UnitLevel("player")
	local isHorde = AtlasKTW.isHorde
	local suffix = isHorde and "_HORDE" or ""
	local questName, questLevel, finishedQuest
	-- Hide inner frame if instance changed
	if AQINSTATM ~= AQINSTANCE then
		HideUIPanel(AtlasQuestInsideFrame)
	end
	-- Enable/disable general button based on instance info availability
	AQGeneralButton[_G["Inst"..AQINSTANCE.."General"] and "Enable" or "Disable"](AQGeneralButton)
	-- Update current instance
	AQINSTATM = AQINSTANCE
	-- Set quest count text
	local questCountKey = isHorde and "QAH" or "QAA"
	local questCount = _G["Inst"..AQINSTANCE..questCountKey]
	AtlasQuestAnzahl:SetText(questCount or "")
	-- Process quests
	for b = 1, AQMAXQUESTS do
		-- Define keys for current faction
		local fquestKey = "Inst"..AQINSTANCE.."Quest"..b.."FQuest"..suffix
		local preQuestKey = "Inst"..AQINSTANCE.."Quest"..b.."PreQuest"..suffix
		local finishedKey = "AQFinishedQuest_Inst"..AQINSTANCE.."Quest"..b..suffix
		local questKey = "Inst"..AQINSTANCE.."Quest"..b..suffix
		local levelKey = questKey.."_Level"
		-- Set quest line arrows
		local arrowTexture = nil
		if _G[fquestKey] then
			arrowTexture = "Interface\\Glues\\Login\\UI-BackArrow"
		elseif _G[preQuestKey] then
			arrowTexture = "Interface\\GossipFrame\\PetitionGossipIcon"
		end
		-- Check for completed quests
		if AQ[finishedKey] == 1 then
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
				if AQ[finishedKey] == 1 then
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
				OnlyQuestNameRemovedNumber = strsub(_G["Inst"..AQINSTANCE.."Quest"..Quest.."_HORDE"], 4)
			else
				OnlyQuestNameRemovedNumber = strsub(_G["Inst"..AQINSTANCE.."Quest"..Quest], 4)
			end
		elseif Quest > 9 then
			if AtlasKTW.isHorde then
				OnlyQuestNameRemovedNumber = strsub(_G["Inst"..AQINSTANCE.."Quest"..Quest.."_HORDE"], 5)
			else
				OnlyQuestNameRemovedNumber = strsub(_G["Inst"..AQINSTANCE.."Quest"..Quest], 5)
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
-- Shows the AQ panel with atlas
-- function hooked now! thx dan for his help
-----------------------------------------------------------------------------
original_Atlas_OnShow = Atlas_OnShow -- new line #1
function Atlas_OnShow()
	if AQAtlasAuto == 1 then
		ShowUIPanel(AtlasQuestFrame)
	else
		HideUIPanel(AtlasQuestFrame)
	end
	HideUIPanel(AtlasQuestInsideFrame)
	if AQ_ShownSide == "Right" then
		AtlasQuestFrame:ClearAllPoints()
		AtlasQuestFrame:SetPoint("TOP","AtlasFrame", 567, -36)
	end
	if AQCompareTooltip ~= nil and IsAddOnLoaded("pfUI") and not TooltipInitForPfUI then
		pfUI.api.CreateBackdrop(AtlasOtwoTooltip)
		pfUI.api.CreateBackdropShadow(AtlasOtwoTooltip)
		if pfUI.eqcompare then
			HookScript(AtlasOtwoTooltip, "OnShow", pfUI.eqcompare.GameTooltipShow)
			HookScript(AtlasOtwoTooltip, "OnHide", function()
				ShoppingTooltip1:Hide()
				ShoppingTooltip2:Hide()
			end)
		end
		TooltipInitForPfUI = true
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
	if AtlasOtwoTooltip:IsVisible() then
		AtlasOtwoTooltip:Hide()
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
		SHOWNID = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN.."_HORDE"]
		colour = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."ITC"..AQTHISISSHOWN.."_HORDE"]
		nameDATA = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."name"..AQTHISISSHOWN.."_HORDE"]
	else
		SHOWNID = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN]
		colour = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."ITC"..AQTHISISSHOWN]
		nameDATA = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."name"..AQTHISISSHOWN]
	end
	if SHOWNID ~= nil then
		if GetItemInfo(SHOWNID) ~= nil then
			AtlasOtwoTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 24)
			AtlasOtwoTooltip:SetHyperlink("item:"..SHOWNID..":0:0:0")
			AtlasOtwoTooltip:Show()
		else
			AtlasOtwoTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 24)
			AtlasOtwoTooltip:ClearLines()
			AtlasOtwoTooltip:AddLine(RED..AQERRORNOTSHOWN)
			AtlasOtwoTooltip:AddLine(AQERRORASKSERVER)
			AtlasOtwoTooltip:Show()
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
		SHOWNID = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN.."_HORDE"]
		colour = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."ITC"..AQTHISISSHOWN.."_HORDE"]
		nameDATA = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."name"..AQTHISISSHOWN.."_HORDE"]
	else
		SHOWNID = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN]
		colour = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."ITC"..AQTHISISSHOWN]
		nameDATA = _G["Inst"..AQINSTANCE.."Quest"..AQSHOWNQUEST.."name"..AQTHISISSHOWN]
	end
	if arg1=="RightButton" then
		AtlasOtwoTooltip:SetOwner(this, "ANCHOR_RIGHT", -(this:GetWidth() / 2), 24)
		AtlasOtwoTooltip:SetHyperlink("item:"..SHOWNID..":0:0:0")
		AtlasOtwoTooltip:Show()
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
AtlasQuestFrame = CreateAtlasQuestFrame()
CreateAtlasQuestOptionFrame()
AQ_OnLoad()
DEFAULT_CHAT_FRAME:AddMessage("Atlas-TW v."..ATLAS_VERSION.." loaded")