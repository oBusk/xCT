--[[   ____    ______
      /\  _`\ /\__  _\   __
 __  _\ \ \/\_\/_/\ \/ /_\ \___
/\ \/'\\ \ \/_/_ \ \ \/\___  __\
\/>  </ \ \ \L\ \ \ \ \/__/\_\_/
 /\_/\_\ \ \____/  \ \_\  \/_/
 \//\/_/  \/___/    \/_/

 [=====================================]
 [  Author: Dandraffbal-Stormreaver US ]
 [  xCT+ Version 4.x.x                 ]
 [  ©2016. All Rights Reserved.        ]
 [====================================]]


local ADDON_NAME, addon = ...
local x, spam = addon.engine, {}
x.spam = spam

local heap = {}

function spam.AddSpamMessage(frame, key, message)
	key = key or addon.merge2h[key]
	local mergeId = addon.merges[key] or key
	local time = GetTime()

	-- Create the frame location
	if not heap[frame] then
		heap[frame] = {}
	end

	-- Create the key location
	if not heap[frame][mergeId] then
		heap[frame][mergeId] = {}
	end

	table.insert(heap[frame][mergeId], message)

	spam.Update()
end

spam.frame = CreateFrame"Frame"
spam.frame.lastUpdate = 0
function spam.frame:OnUpdate(e)
	self.lastUpdate = self.lastUpdate + e
	if self.lastUpdate >= 0.1 then
		self.lastUpdate = 0


	end
end

function spam:Update()
	self.frame:SetScript("OnUpdate", self.frame.OnUpdate)
end




AddOn.SpamMerger = x.class(function (self, owner, spamDB, callback)
		self.owner = owner
		self.db = spamDB
		self.callback = callback
		self.items = x.create()
		self.OnUpdate = p.SpamMerger_OnUpdate
		self.nextUpdate = 0.1
		self.isUpdating = false
	end, {
		AddSpamMessage = function (self, key, item)
			if not self:IsSpam(key) then
				error("'key' ("..key..") needs to be defined in the spamDB")
			end
			key = self.db.merge[key] or key
			local time,i=GetTime(),self.items
			if not i[key]then i[key]=x.create()end
			i[key][#i[key]+1]=item
			i[key].isUpdating=true
			i[key].lastEntry=time
			if not i[key].lastUpdate then
				i[key].lastUpdate=time
			end
			if not self.isUpdating then
				x.RegisterEvent("OnUpdate", self)
				self.isUpdating = true
			end
		end,
		Delete = function (self)
			x.UnregisterEvent("OnUpdate", self)
			for _,t in pairs(self.items) do x.destroy(t) end
			x.destroy(self.items)
			self.items = nil
			self.owner = nil
			self.spamDB = nil
			self.callback = nil

			x.deleteClass(self)
		end,
		IsSpam = function (self, key)
			if self.db.overtime[key] or self.db.instant[key] or self.db.merge[key] then
				return true
			end
			return false
		end,
	}, "SpamMerger")

p.Invoke_Callback = function (self, key, item)
	-- If the callback singals true, clean up the items for them
	if self.callback(self.owner, self, key, item) then
		item.lastUpdate = GetTime()
		for i, v in ipairs(item) do
			x.destroy(v)
			item[i] = nil
		end
	end
end

p.SpamMerger_OnUpdate = function(self, e)
	self.nextUpdate = self.nextUpdate - e
	if self.nextUpdate <= 0.1 then
		local time, updating, db, duration = GetTime(), false, self.db
		local overtimeDB, instantDB = db.overtime, db.instant
		for key, item in pairs(self.items) do
			if #item > 0 then
				duration = instantDB[key] and 0.5 or overtimeDB[key]
				if time - item.lastUpdate >= duration + 0.2 then
					item.lastUpdate = time
				end
				if item.lastUpdate + duration <= time then
					p.Invoke_Callback(self, key, item) -- Call and wipe entries
				else
					updating = true -- Let them know we are checking items
				end
			end
		end
		if not updating then
			x.UnregisterEvent("OnUpdate", self)
			self.isUpdating = false
		end
		self.nextUpdate = 0.1
	end
end
