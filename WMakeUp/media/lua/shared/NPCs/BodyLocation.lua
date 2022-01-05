
--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

-- Locations must be declared in render-order.
-- Location IDs must match BodyLocation= and CanBeEquipped= values in items.txt.
local group = BodyLocations.getGroup("Human")

group:getOrCreateLocation("Bandage")
group:getOrCreateLocation("Wound")
group:getOrCreateLocation("BeltExtra") -- used for holster, empty texture items
group:getOrCreateLocation("Belt") -- empty texture items used for belt/utility belt
group:getOrCreateLocation("BellyButton") --Belly Button Jewellery
group:getOrCreateLocation("MakeUp_FullFace")
group:getOrCreateLocation("MakeUp_Eyes")
group:getOrCreateLocation("MakeUp_EyesShadow")
group:getOrCreateLocation("MakeUp_Lips")
group:getOrCreateLocation("MakeUp_Belly")
group:getOrCreateLocation("MakeUp_ForeHead")
group:getOrCreateLocation("MakeUp_Face")
group:getOrCreateLocation("MakeUp_Breast")
group:getOrCreateLocation("MakeUp_Pussy")
group:getOrCreateLocation("Mask")
group:getOrCreateLocation("MaskEyes")-- Masks that cover eyes, so shouldn't show glasses (Gasmask)
group:getOrCreateLocation("MaskFull")-- covers face fully (welders mask)
group:getOrCreateLocation("Underwear")
group:getOrCreateLocation("UnderwearBottom")
group:getOrCreateLocation("UnderwearTop")
group:getOrCreateLocation("UnderwearExtra1")
group:getOrCreateLocation("UnderwearExtra2")
group:getOrCreateLocation("Hat")
group:getOrCreateLocation("FullHat") -- NBC Mask.. Should unequip everything head related (masks, glasses..)
group:getOrCreateLocation("Ears") --mainly earrings
group:getOrCreateLocation("EarTop") --earring at top of ear
group:getOrCreateLocation("Nose") --Nosestud, nosering
group:getOrCreateLocation("Torso1") -- Longjohns top
group:getOrCreateLocation("Torso1Legs1") -- Longjohns (top + bottom)

group:getOrCreateLocation("TankTop") -- TankTop (goes under tshirt or shirt)
group:getOrCreateLocation("Tshirt") -- TShirt/Vest (goes under shirt)
group:getOrCreateLocation("ShortSleeveShirt") -- ShortSleeveShirt So watches can be worn with short sleeve Shirts
group:getOrCreateLocation("LeftWrist") --Watches and Bracelets
group:getOrCreateLocation("RightWrist") --Watches and Bracelets
group:getOrCreateLocation("Shirt") -- Shirt

-- Neck-tie needs to be above any shirt
group:getOrCreateLocation("Neck")

group:getOrCreateLocation("Necklace") --Necklace, Necklace_Stone
group:getOrCreateLocation("Necklace_Long") -- Longer Necklaces, NecklaceLong
group:getOrCreateLocation("Right_MiddleFinger")
group:getOrCreateLocation("Left_MiddleFinger")
group:getOrCreateLocation("Left_RingFinger")
group:getOrCreateLocation("Right_RingFinger")
group:getOrCreateLocation("Hands")
group:getOrCreateLocation("HandsLeft")
group:getOrCreateLocation("HandsRight")
group:getOrCreateLocation("Socks")
group:getOrCreateLocation("Legs1") -- Longjohns bottom
group:getOrCreateLocation("Pants") -- Pants
group:getOrCreateLocation("Skirt") -- Skirt
group:getOrCreateLocation("Legs5") -- Unused
group:getOrCreateLocation("Dress") -- Dress (top + skirt) / Robe
group:getOrCreateLocation("BodyCostume") -- Body Costume like spiffo suit or wedding dress
group:getOrCreateLocation("Sweater") -- Sweater
group:getOrCreateLocation("SweaterHat") -- Hoodie UP
group:getOrCreateLocation("Jacket") -- Jacket
group:getOrCreateLocation("JacketHat") -- Padded jacket, Poncho UP (can't wear hat with them)
group:getOrCreateLocation("FullSuit") -- Diverse full suit, head gear still can be wear with it (coveralls..)
group:getOrCreateLocation("FullSuitHead") -- Cover everything (hazmat)
group:getOrCreateLocation("FullTop") -- unequip all top item (except tshirt/vest) (including hat/mask, for ghillie_top for example)
group:getOrCreateLocation("BathRobe") -- Need to avoid having coat/any textured models on top of it
group:getOrCreateLocation("Shoes")
group:getOrCreateLocation("FannyPackFront")
group:getOrCreateLocation("FannyPackBack")
group:getOrCreateLocation("AmmoStrap")

--group:getOrCreateLocation("LeftHand")
--group:getOrCreateLocation("RightHand")

-- Apron model is above jacket + pants, order doesn't seem to matter?
group:getOrCreateLocation("TorsoExtra")

-- Spiffo tail is a separate item
group:getOrCreateLocation("Tail")

-- Backpacks
group:getOrCreateLocation("Back")

group:getOrCreateLocation("LeftEye") --currently for eyepatch left
group:getOrCreateLocation("RightEye") --currently for eyepatch right

group:getOrCreateLocation("Eyes") -- need to be on top because of special UV
group:getOrCreateLocation("Scarf") -- need to be on top of everything!

group:getOrCreateLocation("ZedDmg")

-- underwear
--group:setExclusive("Underwear", "UnderwearTop")
--group:setExclusive("Underwear", "UnderwearBottom")
--group:setExclusive("Underwear", "UnderwearExtra1")

-- can't wear glasses with a mask that cover eyes
group:setExclusive("MaskEyes", "Eyes")
group:setExclusive("MaskEyes", "LeftEye")
group:setExclusive("MaskEyes", "RightEye")
group:setExclusive("MaskFull", "Eyes")
group:setExclusive("MaskFull", "LeftEye")
group:setExclusive("MaskFull", "RightEye")

-- Can't wear hat, mask or earrings with a full hat 
group:setExclusive("FullHat", "Hat")
group:setExclusive("FullHat", "Mask")
group:setExclusive("FullHat", "MaskEyes")
group:setExclusive("FullHat", "MaskFull")
group:setExclusive("FullHat", "RightEye")
group:setExclusive("FullHat", "LeftEye")
group:setExclusive("FullHat", "Eyes")

group:setExclusive("LeftEye", "RightEye")

-- Can't wear skirt and pants.
group:setExclusive("Skirt", "Pants")
group:setExclusive("Skirt", "Legs5")

-- Multi-item (for example: longjohns) takes two slots.
group:setExclusive("Torso1Legs1", "Torso1")
group:setExclusive("Torso1Legs1", "Legs1")

-- Multi-item (for example: a dress) takes two slots.
group:setExclusive("Dress", "Shirt")
group:setExclusive("Dress", "ShortSleeveShirt")
group:setExclusive("Dress", "Pants")
group:setExclusive("Dress", "Skirt")
group:setExclusive("Dress", "FullTop")

-- Hazmat, can't be wear with anything (apart shirt/tshirt as they don't have models)
group:setExclusive("FullSuitHead", "Sweater")
group:setExclusive("FullSuitHead", "Hands")
group:setExclusive("FullSuitHead", "SweaterHat")
--group:setExclusive("FullSuitHead", "Shirt")
--group:setExclusive("FullSuitHead", "Tshirt")
group:setExclusive("FullSuitHead", "Jacket")
group:setExclusive("FullSuitHead", "JacketHat")
group:setExclusive("FullSuitHead", "Dress")
group:setExclusive("FullSuitHead", "Pants")
group:setExclusive("FullSuitHead", "Skirt")
group:setExclusive("FullSuitHead", "BathRobe")
group:setExclusive("FullSuitHead", "Hat")
group:setExclusive("FullSuitHead", "FullHat");
group:setExclusive("FullSuitHead", "Eyes");
group:setExclusive("FullSuitHead", "Mask")
group:setExclusive("FullSuitHead", "MaskEyes")
group:setExclusive("FullSuitHead", "MaskFull")
group:setExclusive("FullSuitHead", "Neck")
group:setExclusive("FullSuitHead", "TorsoExtra")
group:setExclusive("FullSuitHead", "FullTop")
group:setExclusive("FullSuitHead", "BodyCostume")

-- Boiler suit, prisoner jumpsuit, coveralls.. Can't be wear with anything apart from head
group:setExclusive("FullSuit", "Sweater")
group:setExclusive("FullSuit", "SweaterHat")
group:setExclusive("FullSuit", "Jacket")
group:setExclusive("FullSuit", "JacketHat")
group:setExclusive("FullSuit", "Dress")
group:setExclusive("FullSuit", "Pants")
group:setExclusive("FullSuit", "Skirt")
group:setExclusive("FullSuit", "BathRobe")
group:setExclusive("FullSuit", "TorsoExtra")
group:setExclusive("FullSuit", "FullSuitHead")
group:setExclusive("FullSuit", "FullTop")
group:setExclusive("FullSuit", "BodyCostume")

group:setExclusive("FullTop", "Sweater")
group:setExclusive("FullTop", "SweaterHat")
group:setExclusive("FullTop", "Jacket")
group:setExclusive("FullTop", "JacketHat")
group:setExclusive("FullTop", "Dress")
group:setExclusive("FullTop", "BathRobe")
group:setExclusive("FullTop", "Hat")
group:setExclusive("FullTop", "FullHat");
group:setExclusive("FullTop", "Eyes");
group:setExclusive("FullTop", "Mask")
group:setExclusive("FullTop", "Neck")
group:setExclusive("FullTop", "TorsoExtra")

-- apart from tanktop/tshirt/longjohns, you shouldn't add stuff on top of your bathrobe to avoid clipping
group:setExclusive("BathRobe", "Sweater")
group:setExclusive("BathRobe", "SweaterHat")
group:setExclusive("BathRobe", "Jacket")
group:setExclusive("BathRobe", "JacketHat")
group:setExclusive("BathRobe", "TorsoExtra")

group:setExclusive("BodyCostume", "Sweater")
group:setExclusive("BodyCostume", "SweaterHat")
group:setExclusive("BodyCostume", "TorsoExtra")
--group:setExclusive("BodyCostume", "Shirt")
--group:setExclusive("BodyCostume", "Tshirt")
group:setExclusive("BodyCostume", "Dress")
group:setExclusive("BodyCostume", "Pants")
group:setExclusive("BodyCostume", "FullTop")
group:setExclusive("BodyCostume", "BathRobe")
group:setExclusive("BodyCostume", "Neck")

-- can't wear hats or earrings with padded jacket/hoodie up
group:setExclusive("JacketHat", "Hat")
group:setExclusive("JacketHat", "FullHat")
group:setExclusive("JacketHat", "Jacket")

-- can't wear hats or earrings with hoodie
group:setExclusive("SweaterHat", "Hat")
group:setExclusive("SweaterHat", "FullHat")
group:setExclusive("SweaterHat", "Sweater")

-- can't wear maskfull with a hats, maskeyes or masks
group:setExclusive("MaskFull", "Hat")
group:setExclusive("MaskFull", "MaskEyes")
group:setExclusive("MaskFull", "Mask")
-- can't wear mask and other masks 
group:setExclusive("Mask", "MaskEyes")
group:setExclusive("Mask", "MaskFull")

-- Backwards compatibility
group:getLocation("Tshirt"):addAlias("Top")
group:getLocation("Pants"):addAlias("Bottoms")

-- Hide items in the second location when an item is in the first location.
-- The item will still be hidden if there is a hole in the outer item.
group:setHideModel("BathRobe", "LeftWrist")
group:setHideModel("BathRobe", "RightWrist")
group:setHideModel("FullSuit", "LeftWrist")
group:setHideModel("FullSuit", "RightWrist")
group:setHideModel("FullSuitHead", "LeftWrist")
group:setHideModel("FullSuitHead", "RightWrist")
group:setHideModel("FullTop", "LeftWrist")
group:setHideModel("FullTop", "RightWrist")
group:setHideModel("Jacket", "LeftWrist")
group:setHideModel("Jacket", "RightWrist")
group:setHideModel("JacketHat", "LeftWrist")
group:setHideModel("JacketHat", "RightWrist")
group:setHideModel("Shirt", "LeftWrist")
group:setHideModel("Shirt", "RightWrist")
group:setHideModel("Sweater", "LeftWrist")
group:setHideModel("Sweater", "RightWrist")
group:setHideModel("SweaterHat", "LeftWrist")
group:setHideModel("SweaterHat", "RightWrist")
--hiding fanny pack front
group:setHideModel("Jacket", "FannyPackFront")
group:setHideModel("TorsoExtra", "FannyPackFront")
group:setHideModel("BathRobe", "FannyPackFront")
group:setHideModel("FullSuit", "FannyPackFront")
group:setHideModel("JacketHat", "FannyPackFront")
--hiding fanny pack back
group:setHideModel("Jacket", "FannyPackBack")
group:setHideModel("TorsoExtra", "FannyPackBack")
group:setHideModel("BathRobe", "FannyPackBack")
group:setHideModel("FullSuit", "FannyPackBack")
group:setHideModel("JacketHat", "FannyPackBack")

-- Multiple items at these locations are allowed.
group:setMultiItem("Bandage", true)
group:setMultiItem("Wound", true)
group:setMultiItem("ZedDmg", true)
