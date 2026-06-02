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
function methods.m.getValFromEvDetector(value)
    return tostring(methods.environmentDetector[value]())
end
function methods.m.findBlockInChunk(blockid)
    local res = {

    }
    for block in methods.modem.call(methods.geoScanner, "scan") do
        if block.id == blockid then
            table.insert(res, block)
        end
    end
    return res
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
    },
    {
        type = "function",
        ["function"] = {
            name = "getValFromEvDetector",
            description = "Returns a value from the environment detector.",
            parameters = { 
                type = "object", 
                properties = {
                    value = { type = "string", description = "The value to retrieve",
                    enums = {"getBiome", "getSkyLightLevel", "getDimension", "getMoonId", "isRaining", "isThunder", "isSlimeChunk"} }
                }
            }
        }
    },
    {
        type = "function",
        ["function"] = {
            name = "findBlockInChunk",
            description = "Scans the current chunk for a specific block and returns their coordinates. Usage: findBlockInChunk({blockid: 'minecraft:block'})",
            parameters = { 
                type = "object", 
                properties = {
                    blockid = { type = "string", description = "The ID of the block to find" }
                }
            }
        }
    }
}

function methods.init(owners)
    methods.owners = owners
    
    methods.modem = peripheral.find("modem")
    
    local modem = methods.modem
    
    for i,name in pairs(modem.getNamesRemote()) do
        if (modem.getTypeRemote(name) == "player_detector") then
            methods.playerDetector = name
        elseif (modem.getTypeRemote(name) == "environment_detector") then
            methods.environmentDetector = name
        elseif (modem.getTypeRemote(name) == "geo_scanner") then
            methods.geoScanner = name
        elseif (modem.getTypeRemote(name) == "nbt_storage") then
            methods.nbtStorage = name
        end
    end



end