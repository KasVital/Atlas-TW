--[[
	
	AtlasQuest, a World of Warcraft addon.
	Email me at mystery8@gmail.com
	
	This file is part of AtlasQuest.
	
	AtlasQuest is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	
	AtlasQuest is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU General Public License for more details.
	
	You should have received a copy of the GNU General Public License
	along with AtlasQuest; if not, write to the Free Software
	Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
	
--]]


-----------------------------------------------------------------------------
-- This functions returns AQINSTANCE with a number
-- that tells which instance is shown atm for Atlas or AlphaMap
-----------------------------------------------------------------------------
function AtlasQuest_Instanzenchecken()
	AQATLASMAP = AtlasMap:GetTexture()

	-- Original Instances

	if AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TheDeadmines" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TheDeadminesEnt" then
		AQINSTANCE = 1
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\WailingCaverns" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\WailingCavernsEnt" then
		AQINSTANCE = 2
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\RagefireChasm" then
		AQINSTANCE = 3
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Uldaman" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\UldamanEnt" then
		AQINSTANCE = 4
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\BlackrockDepths" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\BlackrockMountainEnt" then
		AQINSTANCE = 5
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\BlackwingLair" then
		AQINSTANCE = 6
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\BlackfathomDeeps" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\BlackfathomDeepsEnt" then
		AQINSTANCE = 7
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\BlackrockSpireLower" then
		AQINSTANCE = 8
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\BlackrockSpireUpper" then
		AQINSTANCE = 9
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\DireMaulEast" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\DireMaulEnt" then
		AQINSTANCE = 10
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\DireMaulNorth" then
		AQINSTANCE = 11
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\DireMaulWest" then
		AQINSTANCE = 12
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Maraudon" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\MaraudonEnt" then
		AQINSTANCE = 13
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\MoltenCore" then
		AQINSTANCE = 14
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Naxxramas" then
		AQINSTANCE = 15
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\OnyxiasLair" then
		AQINSTANCE = 16
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\RazorfenDowns" then
		AQINSTANCE = 17
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\RazorfenKraul" then
		AQINSTANCE = 18
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\SMLibrary" then
		AQINSTANCE = 19
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\SMArmory" then
		AQINSTANCE = 20
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\SMCathedral" then
		AQINSTANCE = 21
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\SMGraveyard" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\SMEnt" then
		AQINSTANCE = 22
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Scholomance" then
		AQINSTANCE = 23
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\ShadowfangKeep" then
		AQINSTANCE = 24
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Stratholme" then
		AQINSTANCE = 25
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TheRuinsofAhnQiraj" then
		AQINSTANCE = 26
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TheStockade" then
		AQINSTANCE = 27
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TheSunkenTemple" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TheSunkenTempleEnt" then
		AQINSTANCE = 28
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TheTempleofAhnQiraj" then
		AQINSTANCE = 29
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\ZulFarrak" then
		AQINSTANCE = 30
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\ZulGurub" then
		AQINSTANCE = 31
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Gnomeregan" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\GnomereganEnt" then
		AQINSTANCE = 32
		
		-- Outdoor Raids
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\FourDragons" then
		AQINSTANCE = 33
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Azuregos" then
		AQINSTANCE = 34
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\LordKazzak" then
		AQINSTANCE = 35
		
		-- Battlegrounds
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\AlteracValleyNorth" then
		AQINSTANCE = 36
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\AlteracValleySouth" then
		AQINSTANCE = 36
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\ArathiBasin" then
		AQINSTANCE = 37
		
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\WarsongGulch" then
		AQINSTANCE = 38

		-- Turtle-WOW
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TheCrescentGrove" then
		AQINSTANCE = 39
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Concavius" then
		AQINSTANCE = 40
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\KarazhanCrypt" then
		AQINSTANCE = 41
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Nerubian" then
		AQINSTANCE = 42
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Reaver" then
		AQINSTANCE = 43
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Turtlhu" then
		AQINSTANCE = 44
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\CavernsOfTimeBlackMorass" then
		AQINSTANCE = 45
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\HateforgeQuarry" then
		AQINSTANCE = 46
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\StormwindVault" then
		AQINSTANCE = 57
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Ostarius" then
		AQINSTANCE = 58
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\CowKing" then
		AQINSTANCE = 59
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\GilneasCity" or AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\GilneasCityEnt" then
		AQINSTANCE = 61
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\LowerKarazhan" then
		AQINSTANCE = 62
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\EmeraldSanctum" then
		AQINSTANCE = 63
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TowerofKarazhan" then
		AQINSTANCE = 64
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\Clackora" then
		AQINSTANCE = 65
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\TransportRoutes" then
		AQINSTANCE = 66
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\DLEast" then
		AQINSTANCE = 67
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\DLWest" then
		AQINSTANCE = 68
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\FPAllianceEast" then
		AQINSTANCE = 69
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\FPAllianceWest" then
		AQINSTANCE = 70
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\FPHordeEast" then
		AQINSTANCE = 71
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\FPHordeWest" then
		AQINSTANCE = 72
	elseif AQATLASMAP == "Interface\\AddOns\\Atlas-TW\\Images\\Maps\\RareMobs" then
		AQINSTANCE = 73
		-- Default
		
	else --added for newer atlas version until i update atlasquest and for the flight pass maps
		AQINSTANCE = 99
	end
end


---------------------------
--- AQ Instance Numbers ---
---------------------------

-- 1 = Deadmines (VC)
-- 2 = Wailing Caverns (WC)
-- 3 = Ragefire Chasm (RFC)
-- 4 = Uldaman (ULD)
-- 5 = Blackrock Depths (BRD)
-- 6 = Blackwing Lair (BWL)
-- 7 = Blackfathom Deeps (BFD)
-- 8 = Lower Blackrock Spire (LBRS)
-- 9 = Upper Blackrock Spire (UBRS)
-- 10 = Dire Maul East (DM)
-- 11 = Dire Maul North (DM)
-- 12 = Dire Maul West (DM)
-- 13 = Maraudon (Mara)
-- 14 = Molten Core (MC)
-- 15 = Naxxramas (Naxx)
-- 16 = Onyxia's Lair (Ony)
-- 17 = Razorfen Downs (RFD)
-- 18 = Razorfen Kraul (RFK)
-- 19 = SM: Library (SM Lib)
-- 20 = SM: Armory (SM Arm)
-- 21 = SM: Cathedral (SM Cath)
-- 22 = SM: Graveyard (SM GY)
-- 23 = Scholomance (Scholo)
-- 24 = Shadowfang Keep (SFK)
-- 25 = Stratholme (Strat)
-- 26 = The Ruins of Ahn'Qiraj (AQ20)
-- 27 = The Stockade (Stocks)
-- 28 = Sunken Temple (ST)
-- 29 = The Temple of Ahn'Qiraj (AQ40)
-- 30 = Zul'Farrak (ZF)
-- 31 = Zul'Gurub (ZG)
-- 32 = Gnomeregan (Gnomer)
-- 33 = Four Dragons
-- 34 = Azuregos
-- 35 = Lord Kazzak
-- 36 = Alterac Valley (AV)
-- 37 = Arathi Basin (AB)
-- 38 = Warsong Gulch (WSG)
-- 39 = The Crescent Grove (TCG)
-- 40 = Concavius (Concavius)
-- 45 = Caverns Of Time: Black Morass
-- 61 = Gilneas City
-- 62 = LowerKarazhan
-- 63 = Emerald Sanctum
-- 64 = TowerofKarazhan
-- 65 = Clackora
-- 99 = default "rest"