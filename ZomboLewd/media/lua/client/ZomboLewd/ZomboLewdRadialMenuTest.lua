-- @author Jaivosdents & QueuedResonance 2022

require "ISUI/ISEmoteRadialMenu"

local ISEmoteRadialMenu = ISEmoteRadialMenu
local ZomboLewdAnimationList = ZomboLewdAnimationList

--- Save the previous selections
local OldRadialMenuCache = ISEmoteRadialMenu.fillMenu
local OldEmoteMenuCache = ISEmoteRadialMenu.emote

local ImageExtension = ".png"

--- Fill the radial menu with new kinky moves
function ISEmoteRadialMenu:fillMenu(submenu)
	local animationList = self.character:isFemale() and ZomboLewdAnimationList.Female or ZomboLewdAnimationList.Male

	--- Fill in category icon
	ISEmoteRadialMenu.menu["ZLD"] = {}
	ISEmoteRadialMenu.menu["ZLD"].subMenu = {}
	ISEmoteRadialMenu.menu["ZLD"].name = getText('IGUI_Emote_ZLD')
	ISEmoteRadialMenu.icons["ZLD"] = getTexture('media/ui/UI_ZLD.png')

	--- Fill in submenu selections
	for _, animationName in ipairs(animationList) do
		local anim = string.gsub(animationName, "%s+", "_")
		local text, texture = getText(string.format("IGUI_Emote_%s", anim)), getTexture(string.format("media/ui/ZLDordinary/%s%s", anim, ImageExtension))
		
		if text and texture then
			ISEmoteRadialMenu.menu["ZLD"].subMenu[anim] = text
			ISEmoteRadialMenu.icons[anim] = texture
		else
			print(string.format("Missing Text or Texture: %s", anim))
		end
	end

	OldRadialMenuCache(self, submenu)
end

function ISEmoteRadialMenu:emote(emote)
	local bobZD = "BobZD"

	if string.sub(emote, 1, string.len(bobZD)) == bobZD then
		self.character:setPrimaryHandItem(nil)
		self.character:setSecondaryHandItem(nil)
	end

	OldEmoteMenuCache(self, emote)
end

function OnCreatePlayer(_, playerObj)
	if not playerObj:getModData()["zld"] then
		playerObj:getModData()["zld"] = true
	end
end

Events.OnCreatePlayer.Add(OnCreatePlayer)
