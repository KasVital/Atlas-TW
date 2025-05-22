-----------------------------------------------------------------------------
-- Option handlers
-----------------------------------------------------------------------------

-- Autoshow
function KQAutoshowOption_OnClick()
	AtlasKTW.Q.WithAtlas = not AtlasKTW.Q.WithAtlas
	KQAutoshowOption:SetChecked(AtlasKTW.Q.WithAtlas)
	ChatFrame1:AddMessage(AtlasKTW.Q.WithAtlas and AQAtlasAutoON or AQAtlasAutoOFF)
	KQuest_SaveData()
end

-- Right position
function KQRIGHTOption_OnClick()
	KQuestFrame:ClearAllPoints()
	KQuestFrame:SetPoint("TOP", "AtlasFrame", 567, -36)
	AQRIGHTOption:SetChecked(true)
	AQLEFTOption:SetChecked(false)
	AtlasKTW.Q.ShownSide = "Right"
	KQuest_SaveData()
end

-- Left position
function KQLEFTOption_OnClick()
	if AtlasKTW.Q.ShownSide == "Right" then
		KQuestFrame:ClearAllPoints()
		KQuestFrame:SetPoint("TOP", "AtlasFrame", -556, -36)
	end
	AQRIGHTOption:SetChecked(false)
	AQLEFTOption:SetChecked(true)
	if AtlasKTW.Q.ShownSide ~= "Left" then
		ChatFrame1:AddMessage(AQShowLeft)
	end
	AtlasKTW.Q.ShownSide = "Left"
	KQuest_SaveData()
end

-- Color check
function KQColourOption_OnClick()
	AQNOColourCheck = not AQNOColourCheck
	AQColourOption:SetChecked(not AQNOColourCheck)
	ChatFrame1:AddMessage(AQNOColourCheck and AQCCOFF or AQCCON)
	KQuest_SaveData()
	AtlasKTW.QUpdateNOW = true
end

-- Questlog check
function KQCheckQuestlogButton_OnClick()
	AQCheckQuestlog = AQCheckQuestlog == nil and "no" or nil
	AQCheckQuestlogButton:SetChecked(AQCheckQuestlog == nil)
	KQuest_SaveData()
	AtlasKTW.QUpdateNOW = true
end

-- Auto query
function KQAutoQueryOption_OnClick()
	AQAutoQuery = AQAutoQuery == nil and "yes" or nil
	AQAutoQueryOption:SetChecked(AQAutoQuery ~= nil)
	KQuest_SaveData()
end

-- Query spam suppression
function KQNoQuerySpamOption_OnClick()
	AQNoQuerySpam = AQNoQuerySpam == nil and "yes" or nil
	AQNoQuerySpamOption:SetChecked(AQNoQuerySpam ~= nil)
	KQuest_SaveData()
end

-- Tooltip comparison
function KQCompareTooltipOption_OnClick()
	AQCompareTooltip = AQCompareTooltip == nil and "yes" or nil
	AQCompareTooltipOption:SetChecked(AQCompareTooltip ~= nil)
	if AQCompareTooltip then
		if KQuestRegisterTooltip then
			KQuestRegisterTooltip()
		end
	else
		if KQuestUnRegisterTooltip then
			KQuestUnRegisterTooltip()
		end
	end
	KQuest_SaveData()
end

-- Options panel initialization
function KQuestOptionFrame_OnShow()
	-- Autoshow
	KQAutoshowOption:SetChecked(AtlasKTW.Q.WithAtlas)

	-- Position (left/right)
	local isLeft = AtlasKTW.Q.ShownSide == "Left"
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
function CreateKQuestOptionFrame()
	local frame = CreateFrame("Frame", "KQuestOptionFrame", UIParent)
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
	frame:SetScript("OnShow", KQuestOptionFrame_OnShow)
	frame:SetScript("OnKeyDown", function()
		if arg1 == "ESCAPE" then
			HideUIPanel(this)
		end
	end)
	frame:SetScript("OnHide", function()
		KQuestOptionFrame:StopMovingOrSizing()
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
		HideUIPanel(KQuestOptionFrame)
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
	CreateOptionText("KQAutoshowOptionTEXT", -50)
	CreateOptionText("AQLEFTOptionTEXT", -80)
	CreateOptionText("AQRIGHTOptionTEXT", -110)
	CreateOptionText("AQColourOptionTEXT", -140)
	CreateOptionText("AQCheckQuestlogTEXT", -170)
	CreateOptionText("AQAutoQueryTEXT", -200, 35)
	CreateOptionText("AQNoQuerySpamTEXT", -230, 35)
	CreateOptionText("AQCompareTooltipTEXT", -260, 35)

	-- Create checkboxes
	CreateCheckbox("KQAutoshowOption", -50, KQAutoshowOption_OnClick)
	CreateCheckbox("AQLEFTOption", -80, KQLEFTOption_OnClick)
	CreateCheckbox("AQRIGHTOption", -110, KQRIGHTOption_OnClick)
	CreateCheckbox("AQColourOption", -140, KQColourOption_OnClick)
	CreateCheckbox("AQCheckQuestlogButton", -170, KQCheckQuestlogButton_OnClick)
	CreateCheckbox("AQAutoQueryOption", -200, KQAutoQueryOption_OnClick)
	CreateCheckbox("AQNoQuerySpamOption", -230, KQNoQuerySpamOption_OnClick)
	CreateCheckbox("AQCompareTooltipOption", -260, KQCompareTooltipOption_OnClick)

	return frame
end