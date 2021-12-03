require 'ISUI/ISEmoteRadialMenu'
local ISEmoteRadialMenu_fillMenu_old = ISEmoteRadialMenu.fillMenu

local OrdinaryAnim = {
"BobZD Finger Pussy",
"BobZD Finger Ass",
"BobZD Finger Both"
"BobZD Stroke Cock",
}


function ISEmoteRadialMenu:fillMenu(submenu)
	ISEmoteRadialMenu.menu['ZLD'] = {};
	ISEmoteRadialMenu.menu['ZLD'].name = getText('IGUI_Emote_ZLD');
	ISEmoteRadialMenu.menu['ZLD'].subMenu = {};	
	ISEmoteRadialMenu.icons['ZLD'] = getTexture('media/ui/UI_ZLD.png');
	
	if self.character:isFemale() then
		ISEmoteRadialMenu.menu['ZLD'].subMenu['BobZD_Finger_Pussy'] = getText('IGUI_Emote_BobZD_Finger_Pussy');
		ISEmoteRadialMenu.icons['BobZD_Finger_Pussy'] = getTexture('media/ui/ZLDordinary/BobZD_Finger_Pussy.png')
		ISEmoteRadialMenu.menu['ZLD'].subMenu['BobZD_Finger_Ass'] = getText('IGUI_Emote_BobZD_Finger_Ass');
		ISEmoteRadialMenu.icons['BobZD_Finger_Ass'] = getTexture('media/ui/ZLDordinary/BobZD_Finger_Ass.png')
		ISEmoteRadialMenu.menu['ZLD'].subMenu['BobZD_Finger_Both'] = getText('IGUI_Emote_BobZD_Finger_Both');
		ISEmoteRadialMenu.icons['BobZD_Finger_Both'] = getTexture('media/ui/ZLDordinary/BobZD_Finger_.Both.png')
		else
		ISEmoteRadialMenu.menu['ZLD'].subMenu['BobZD_Stroke_Cock'] = getText('IGUI_Emote_BobZD_Stroke_Cock');
		ISEmoteRadialMenu.icons['BobZD_Stroke_Cock'] = getTexture('media/ui/ZLDordinary/BobZD_Stroke_Cock.png')
	end
local allItems = self.character:getInventory():getItems()

	ISEmoteRadialMenu_fillMenu_old(self, submenu)
end

local old_ISEmoteRadialMenu_emote = ISEmoteRadialMenu.emote

function ISEmoteRadialMenu:emote(emote)
	if string.sub(emote,1,string.len('BobZD'))=='BobZD' then
		self.character:setPrimaryHandItem(nil)
		self.character:setSecondaryHandItem(nil)
	end
	old_ISEmoteRadialMenu_emote(self, emote)
end

function ZLDOnCreatePlayer(playerNum, playerObj)
	if not playerObj:getModData()['zld'] then
		playerObj:getModData()['zld'] = true
	end
end
Events.OnCreatePlayer.Add(ZLDOnCreatePlayer)



