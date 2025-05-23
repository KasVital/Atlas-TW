local _G = getfenv()
local L = AceLibrary("AceLocale-2.2"):new("Atlas")
local BZ = AceLibrary("Babble-Zone-2.2a")

local ORANGE = "|cffFF8400"

function AtlasLootWorldEventMenu()
	AtlasLoot_PrepMenu(nil, L["World Events"])
	AtlasLootCharDB.LastBoss = "WORLDEVENTMENU"
	AtlasLootCharDB.LastBossText = L["World Events"]
	--Abyssal Council
	AtlasLootMenuItem_2_Name:SetText(L["Abyssal Council"])
	AtlasLootMenuItem_2_Extra:SetText(ORANGE..BZ["Silithus"])
	AtlasLootMenuItem_2_Icon:SetTexture("Interface\\Icons\\Spell_Nature_TimeStop")
	AtlasLootMenuItem_2.lootpage="AbyssalCouncil"
	AtlasLootMenuItem_2:Show()
	--Elemental Invasion
	AtlasLootMenuItem_3_Name:SetText(L["Elemental Invasion"])
	AtlasLootMenuItem_3_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_3_Icon:SetTexture("Interface\\Icons\\INV_Ammo_FireTar")
	AtlasLootMenuItem_3.lootpage="ElementalInvasion"
	AtlasLootMenuItem_3:Show()
	--Gurubashi Arena
	AtlasLootMenuItem_4_Name:SetText(L["Gurubashi Arena"])
	AtlasLootMenuItem_4_Extra:SetText(ORANGE..BZ["Stranglethorn Vale"])
	AtlasLootMenuItem_4_Icon:SetTexture("Interface\\Icons\\INV_Box_02")
	AtlasLootMenuItem_4.lootpage="GurubashiArena"
	AtlasLootMenuItem_4:Show()
	--Harvest Festival
	AtlasLootMenuItem_5_Name:SetText(L["Harvest Festival"])
	AtlasLootMenuItem_5_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_5_Icon:SetTexture("Interface\\Icons\\INV_Misc_Food_Wheat_01")
	AtlasLootMenuItem_5.lootpage="HarvestFestival"
	AtlasLootMenuItem_5:Show()
	--Lunar Festival
	AtlasLootMenuItem_6_Name:SetText(L["Lunar Festival"])
	AtlasLootMenuItem_6_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_6_Icon:SetTexture("Interface\\Icons\\INV_Misc_ElvenCoins")
	AtlasLootMenuItem_6.lootpage="LunarFestival1"
	AtlasLootMenuItem_6:Show()
	--Noblegarden
	AtlasLootMenuItem_7_Name:SetText(L["Noblegarden"])
	AtlasLootMenuItem_7_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_7_Icon:SetTexture("Interface\\Icons\\INV_Egg_03")
	AtlasLootMenuItem_7.lootpage="Noblegarden"
	AtlasLootMenuItem_7:Show()
	--Stranglethorn Fishing Extravaganza
	AtlasLootMenuItem_8_Name:SetText(L["Stranglethorn Fishing Extravaganza"])
	AtlasLootMenuItem_8_Extra:SetText(ORANGE..BZ["Stranglethorn Vale"])
	AtlasLootMenuItem_8_Icon:SetTexture("Interface\\Icons\\INV_Fishingpole_01")
	AtlasLootMenuItem_8.lootpage="FishingExtravaganza"
	AtlasLootMenuItem_8:Show()
	--Children's Week
	AtlasLootMenuItem_17_Name:SetText(L["Children's Week"])
	AtlasLootMenuItem_17_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_17_Icon:SetTexture("Interface\\Icons\\Ability_Hunter_BeastCall")
	AtlasLootMenuItem_17.lootpage="ChildrensWeek"
	AtlasLootMenuItem_17:Show()
	--Feast of Winter Veil
	AtlasLootMenuItem_18_Name:SetText(L["Feast of Winter Veil"])
	AtlasLootMenuItem_18_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_18_Icon:SetTexture("Interface\\Icons\\INV_Holiday_Christmas_Present_01")
	AtlasLootMenuItem_18.lootpage="Winterviel1"
	AtlasLootMenuItem_18:Show()
	--Hallow's End
	AtlasLootMenuItem_19_Name:SetText(L["Hallow's End"])
	AtlasLootMenuItem_19_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_19_Icon:SetTexture("Interface\\Icons\\INV_Misc_Food_59")
	AtlasLootMenuItem_19.lootpage="Halloween1"
	AtlasLootMenuItem_19:Show()
	--Love is in the Air
	AtlasLootMenuItem_20_Name:SetText(L["Love is in the Air"])
	AtlasLootMenuItem_20_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_20_Icon:SetTexture("Interface\\Icons\\INV_ValentinesBoxOfChocolates02")
	AtlasLootMenuItem_20.lootpage="Valentineday"
	AtlasLootMenuItem_20:Show()
	--Midsummer Fire Festival
	AtlasLootMenuItem_21_Name:SetText(L["Midsummer Fire Festival"])
	AtlasLootMenuItem_21_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_21_Icon:SetTexture("Interface\\Icons\\INV_SummerFest_Symbol_Medium")
	AtlasLootMenuItem_21.lootpage="MidsummerFestival"
	AtlasLootMenuItem_21:Show()
	--Scourge Invasion
	AtlasLootMenuItem_22_Name:SetText(L["Scourge Invasion"])
	AtlasLootMenuItem_22_Extra:SetText(ORANGE..L["Various Locations"])
	AtlasLootMenuItem_22_Icon:SetTexture("Interface\\Icons\\INV_Jewelry_Talisman_13")
	AtlasLootMenuItem_22.lootpage="ScourgeInvasionEvent1"
	AtlasLootMenuItem_22:Show()
end

function AtlasLootAbyssalCouncilMenu()
	AtlasLoot_PrepMenu("WORLDEVENTMENU", L["Abyssal Council"])
	
	--Templars
	AtlasLootMenuItem_2_Name:SetText(L["Abyssal Council"].." - "..L["Templars"])
	AtlasLootMenuItem_2_Extra:SetText("")
	AtlasLootMenuItem_2_Icon:SetTexture("Interface\\Icons\\INV_Jewelry_Talisman_05")
	AtlasLootMenuItem_2.lootpage="AbyssalTemplars"
	AtlasLootMenuItem_2:Show()
	--Dukes
	AtlasLootMenuItem_3_Name:SetText(L["Abyssal Council"].." - "..L["Dukes"])
	AtlasLootMenuItem_3_Extra:SetText("")
	AtlasLootMenuItem_3_Icon:SetTexture("Interface\\Icons\\INV_Jewelry_Ring_36")
	AtlasLootMenuItem_3.lootpage="AbyssalDukes"
	AtlasLootMenuItem_3:Show()
	--High Council
	AtlasLootMenuItem_4_Name:SetText(L["Abyssal Council"].." - "..L["High Council"])
	AtlasLootMenuItem_4_Extra:SetText("")
	AtlasLootMenuItem_4_Icon:SetTexture("Interface\\Icons\\INV_Staff_13")
	AtlasLootMenuItem_4.lootpage="AbyssalLords"
	AtlasLootMenuItem_4:Show()
end