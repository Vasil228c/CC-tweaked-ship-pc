local target= {x=tonumber(arg[1]),y=tonumber(arg[2]),z=tonumber(arg[3])}
local function calculateDot(vecA, vecB)
    return (vecA.x * vecB.x) + (vecA.y * vecB.y) + (vecA.z * vecB.z)
end
while true do
    local pose= sublevel.getLogicalPose()
    local pos= pose.position
    local orien = pose.orientation
    local pitch,yaw,roll= orien.toEuler()
    
    local distance = math.sqrt((target.x - pos.x)^2 + (target.z - pos.z)^2)

    local substr = {x=target.x-pos.x,y=target.y-pos.y,z=target.z-pos.z}
    
    local forward = {
    x = -2 * (orien.x * orien.z + orien.w * orien.y),
    y = -2 * (orien.y * orien.z - orien.w * orien.x),
    z = -(1 - 2 * (orien.x^2 + orien.y^2)) 
        }

    local dot = calculateDot(forward,substr)
    local yawtotarget = math.atan2(substr.z,substr.x)
    if (yaw > yawtotarget) then
        redstone.setAnalogOutput("left",15)
    elseif (yaw < yawtotarget) then
        redstone.setAnalogOutput("right",15)
    end
    if (dot >0 ) then
    redstone.setAnalogOutput("front",15)
    end
    if (distance < 50) then
        redstone.setAnalogOutput("front",0)
        redstone.setAnalogOutput("left",0)
        redstone.setAnalogOutput("right",0)
        break
    end
    sleep(0.4)
end