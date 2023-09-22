TrackerAPI = {}

--- Returns the map id number of the current location of the player's character. When not in the game, the value is 0 (intro screen).
--- @return number mapId
function TrackerAPI.getMapId()
	return Program.GameData.mapId or 0
end

--- Returns a storted list of all the trainers that the player has done battle with
--- @return table trainerIds The sorted list of unique trainerIds
function TrackerAPI.getDefeatedTrainers()
	local trainerIds = {}
	for trainerId, _ in pairs(Tracker.Data.allTrainers or {}) do
		table.insert(trainerIds, trainerId)
	end
	table.sort(trainerIds, function(a,b) return a < b end)
	return trainerIds
end

--- Saves a setting to the user's Settings.ini file so that it can be remembered after the emulator shuts down and reopens.
--- @param extensionName string The name of the extension calling this function; use only alphanumeric characters, no spaces
--- @param key string The name of the setting. Combined with extensionName (ext_key) when saved in Settings file
--- @param value string|number|boolean The value that is being saved; allowed types: number, boolean, string
function TrackerAPI.saveExtensionSetting(extensionName, key, value)
	if extensionName == nil or key == nil or value == nil then return end

	if type(value) == "string" then
		value = Utils.encodeDecodeForSettingsIni(value, true)
	end

	local encodedName = string.gsub(extensionName, " ", "_")
	local encodedKey = string.gsub(key, " ", "_")
	local settingsKey = string.format("%s_%s", encodedName, encodedKey)
	Main.SetMetaSetting("extconfig", settingsKey, value)
	Main.SaveSettings(true)
end

--- Gets a setting from the user's Settings.ini file
--- @param extensionName string The name of the extension calling this function; use only alphanumeric characters, no spaces
--- @param key string The name of the setting. Combined with extensionName (ext_key) when saved in Settings file
--- @return string|number|boolean|nil value Returns the value that was saved, or returns nil if it doesn't exist.
function TrackerAPI.getExtensionSetting(extensionName, key)
	if extensionName == nil or key == nil or Main.MetaSettings.extconfig == nil then return nil end

	local encodedName = string.gsub(extensionName, " ", "_")
	local encodedKey = string.gsub(key, " ", "_")
	local settingsKey = string.format("%s_%s", encodedName, encodedKey)
	local value = Main.MetaSettings.extconfig[settingsKey]
	return tonumber(value or "") or value
end