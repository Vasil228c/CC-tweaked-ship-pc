local methods = {}
methods.owners = {}
methods.m = {}

methods.modem = {}

function methods.m.getOwners()
        local res = "Owners: "
        for i,v in pairs(methods.owners) do
            res = res .. v .. " "
        end 
        return res
end
function methods.m.getComputerTime()
    return "Current world time is " .. textutils.formatTime(os.time(), true)
end
function methods.m.getPlayerData(name,prop)
    local data = methods.modem.call(methods.playerDetector, "getPlayer", name)
    if prop then
        return data and data[prop] or "Property not found"
    else
        return "Player or data not found"
    end
end
methods.tools = {
    {
        type = "function",
        ["function"] = {
            name = "getComputerTime",
            description = "Returns the current internal Minecraft world time.",
            parameters = { type = "object", properties = {} }
        }
    },
    {
        type = "function",
        ["function"] = {
            name = "getOwners",
            description = "Returns owners.",
            parameters = { type = "object", properties = {} }
        }
    },

    {
        type = "function",
        ["function"] = {
            name = "getPlayerData",
            description = "Returns data about a player. Usage: getPlayerData({name: 'playerName', prop: 'propertyName'})",
            parameters = { 
                type = "object", 
                properties = {
                    name = { type = "string", description = "The player's name" },
                    prop = { type = "string", description = "The property to retrieve (optional)",
                    enum = {"uuid", "name", "dimension", "eyeHeight", "pitch", "health", "maxHealth", "airSupply", "respawnPosition", "respawnDimension", "respawnAngle", "yaw", "x", "y", "z"} }
                },
                
            }
        }
    }       
}

function methods:init(owners)
    self.owners = owners
    
    self.modem = peripheral.find("modem")
    
    local modem = self.modem
    
    for i,name in pairs(modem.getNamesRemote()) do
        if (modem.getTypeRemote(name) == "player_detector") then
            self.playerDetector = name
        elseif (modem.getTypeRemote(name) == "environment_detector") then
            self.environmentDetector = name
        elseif (modem.getTypeRemote(name) == "geo_scanner") then
            self.geoScanner = name
        elseif (modem.getTypeRemote(name) == "nbt_storage") then
            self.nbtStorage = name
        end
    end



end