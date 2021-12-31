--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISUseDildo = ISBaseTimedAction:derive("ISUseDildo");

function ISUseDildo:isValid()
	return self.character:getInventory():contains("Lewd_Dildo");
end

function ISUseDildo:update()
	self.item:setJobDelta(self:getJobDelta());
end

function ISUseDildo:start()
	self.item:setJobType(getText("ContextMenu_Use_Dildo"));
	self.item:setJobDelta(0.0);
	self:setActionAnim(CharacterActionAnims.UseDildo);
	self:setOverrideHandModels(nil, self.item);
end

function ISUseDildo:stop()
    ISBaseTimedAction.stop(self);
    self.item:setJobDelta(0.0);

end

function ISUseDildo:perform()
    self.item:getContainer():setDrawDirty(true);
    self.item:setJobDelta(0.0);
    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function ISUseDildo:new (character, item, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	return o
end
