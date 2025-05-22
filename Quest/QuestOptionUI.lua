-----------------------------------------------------------------------------
-- Option handlers
-----------------------------------------------------------------------------

-- Autoshow
function AQAutoshowOption_OnClick()
	AQAtlasAuto = AQAtlasAuto == 1 and 2 or 1
	AQAutoshowOption:SetChecked(AQAtlasAuto == 1)
	ChatFrame1:AddMessage(AQAtlasAuto == 1 and AQAtlasAutoON or AQAtlasAutoOFF)
	AtlasQuest_SaveData()
end

-- Right position
function AQRIGHTOption_OnClick()
	AtlasQuestFrame:ClearAllPoints()
	AtlasQuestFrame:SetPoint("TOP", "AtlasFrame", 567, -36)
	AQRIGHTOption:SetChecked(true)
	AQLEFTOption:SetChecked(false)
	AQ_ShownSide = "Right"
	AtlasQuest_SaveData()
end

-- Left position
function AQLEFTOption_OnClick()
	if AQ_ShownSide == "Right" then
		AtlasQuestFrame:ClearAllPoints()
		AtlasQuestFrame:SetPoint("TOP", "AtlasFrame", -556, -36)
	end
	AQRIGHTOption:SetChecked(false)
	AQLEFTOption:SetChecked(true)
	if AQ_ShownSide ~= "Left" then
		ChatFrame1:AddMessage(AQShowLeft)
	end
	AQ_ShownSide = "Left"
	AtlasQuest_SaveData()
end

-- Color check
function AQColourOption_OnClick()
	AQNOColourCheck = not AQNOColourCheck
	AQColourOption:SetChecked(not AQNOColourCheck)
	ChatFrame1:AddMessage(AQNOColourCheck and AQCCOFF or AQCCON)
	AtlasQuest_SaveData()
	AQUpdateNOW = true
end

-- Questlog check
function AQCheckQuestlogButton_OnClick()
	AQCheckQuestlog = AQCheckQuestlog == nil and "no" or nil
	AQCheckQuestlogButton:SetChecked(AQCheckQuestlog == nil)
	AtlasQuest_SaveData()
	AQUpdateNOW = true
end

-- Auto query
function AQAutoQueryOption_OnClick()
	AQAutoQuery = AQAutoQuery == nil and "yes" or nil
	AQAutoQueryOption:SetChecked(AQAutoQuery ~= nil)
	AtlasQuest_SaveData()
end

-- Query spam suppression
function AQNoQuerySpamOption_OnClick()
	AQNoQuerySpam = AQNoQuerySpam == nil and "yes" or nil
	AQNoQuerySpamOption:SetChecked(AQNoQuerySpam ~= nil)
	AtlasQuest_SaveData()
end

-- Tooltip comparison
function AQCompareTooltipOption_OnClick()
	AQCompareTooltip = AQCompareTooltip == nil and "yes" or nil
	AQCompareTooltipOption:SetChecked(AQCompareTooltip ~= nil)
	if AQCompareTooltip then
		if QuestOtwoRegisterTooltip then
			QuestOtwoRegisterTooltip()
		end
	else
		if QuestOtwoUnregisterTooltip then
			QuestOtwoUnregisterTooltip()
		end
	end
	AtlasQuest_SaveData()
end

-- Options panel initialization
function AtlasQuestOptionFrame_OnShow()
	-- Autoshow
	AQAutoshowOption:SetChecked(AQAtlasAuto ~= 2)

	-- Position (left/right)
	local isLeft = AQ_ShownSide == "Left"
	AQLEFTOption:SetChecked(isLeft)
	AQRIGHTOption:SetChecked(not isLeft)

	-- Color check
	AQColourOption:SetChecked(not AQNOColourCheck)

	-- Questlog check
	AQCheckQuestlogButton:SetChecked(AQCheckQuestlog == nil)

	-- Auto query
	AQAutoQueryOption:SetChecked(AQAutoQuery ~= nil)

	-- Query spam suppression
	AQNoQuerySpamOption:SetChecked(AQNoQuerySpam ~= nil)

	-- Tooltip comparison
	AQCompareTooltipOption:SetChecked(AQCompareTooltip ~= nil)
end

-----------------------------------------------------------------------------
-- Options frame creation
-----------------------------------------------------------------------------
function CreateAtlasQuestOptionFrame()
	local frame = CreateFrame("Frame", "AtlasQuestOptionFrame", UIParent)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
	frame:EnableKeyboard(true)
	frame:SetToplevel(true)
	frame:SetWidth(300)
	frame:SetHeight(350)
	frame:SetPoint("CENTER", 0, -240)
	frame:SetBackdrop({
		bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
		edgeFile = "",
		tile = false
	})
	-- Registration of events and handlers
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnShow", AtlasQuestOptionFrame_OnShow)
	frame:SetScript("OnKeyDown", function()
		if arg1 == "ESCAPE" then
			HideUIPanel(this)
		end
	end)
	frame:SetScript("OnHide", function()
		AtlasQuestOptionFrame:StopMovingOrSizing()
	end)
	frame:SetScript("OnDragStart", function()
		this:StartMoving()
		this.isMoving = true
	end)
	frame:SetScript("OnDragStop", function()
		this:StopMovingOrSizing()
		this.isMoving = false
	end)
	-- Title
	local title = frame:CreateFontString("$parent_Title", "ARTWORK", "GameFontNormal")
	title:SetPoint("TOP", 0, -15)
	title:SetText(AQOptionsCaptionTEXT)
	title:SetJustifyH("CENTER")
	-- Close button
	local closeButton = CreateFrame("Button", "AQOptionCloseButton", frame, "OptionsButtonTemplate")
	closeButton:SetWidth(80)
	closeButton:SetHeight(20)
	closeButton:SetPoint("BOTTOM", 0, 15)
	closeButton:SetScript("OnClick", function()
		HideUIPanel(AtlasQuestOptionFrame)
	end)
	closeButton:SetScript("OnShow", function()
		this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
	end)
	closeButton:SetText(CLOSE)
	-- Function to create option text
	local function CreateOptionText(name, yOffset, height)
		local text = frame:CreateFontString(name, "ARTWORK", "GameFontNormalSmall")
		text:SetWidth(240)
		text:SetHeight(height or 25)
		text:SetPoint("TOPLEFT", 45, yOffset)
		text:SetJustifyH("LEFT")
		return text
	end
	-- Function to create checkbox
	local function CreateCheckbox(name, yOffset, onClick)
		local checkbox = CreateFrame("CheckButton", name, frame, "OptionsCheckButtonTemplate")
		checkbox:SetWidth(30)
		checkbox:SetHeight(30)
		checkbox:SetPoint("TOPLEFT", 10, yOffset)
		checkbox:SetChecked(true)
		checkbox:SetHitRectInsets(0, 0, 0, 0)
		checkbox:SetScript("OnClick", onClick)
		checkbox:SetScript("OnShow", function()
			this:SetFrameLevel(this:GetParent():GetFrameLevel() + 1)
		end)
		return checkbox
	end

	-- Create option texts
	CreateOptionText("AQAutoshowOptionTEXT", -50)
	CreateOptionText("AQLEFTOptionTEXT", -80)
	CreateOptionText("AQRIGHTOptionTEXT", -110)
	CreateOptionText("AQColourOptionTEXT", -140)
	CreateOptionText("AQCheckQuestlogTEXT", -170)
	CreateOptionText("AQAutoQueryTEXT", -200, 35)
	CreateOptionText("AQNoQuerySpamTEXT", -230, 35)
	CreateOptionText("AQCompareTooltipTEXT", -260, 35)

	-- Create checkboxes
	CreateCheckbox("AQAutoshowOption", -50, AQAutoshowOption_OnClick)
	CreateCheckbox("AQLEFTOption", -80, AQLEFTOption_OnClick)
	CreateCheckbox("AQRIGHTOption", -110, AQRIGHTOption_OnClick)
	CreateCheckbox("AQColourOption", -140, AQColourOption_OnClick)
	CreateCheckbox("AQCheckQuestlogButton", -170, AQCheckQuestlogButton_OnClick)
	CreateCheckbox("AQAutoQueryOption", -200, AQAutoQueryOption_OnClick)
	CreateCheckbox("AQNoQuerySpamOption", -230, AQNoQuerySpamOption_OnClick)
	CreateCheckbox("AQCompareTooltipOption", -260, AQCompareTooltipOption_OnClick)

	return frame
end