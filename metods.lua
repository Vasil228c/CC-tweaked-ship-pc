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