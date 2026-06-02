

local chat_box = peripheral.find("chat_box")

local methodsModule = require("metods")
local methods = methodsModule.m
local serialize = require("serialize").serialize
local json = require("json").decode
local ccstrings = require "cc.strings"

local apiKey = "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"
local apiUrl = "https://api.groq.com/openai/v1/chat/completions"
local modelName = "qwen/qwen3-32b"

local name = "TopT"
local owners = {
    "RunikTy",
    "Pictul",
    "GGhanera",
    "Voronez",
    "Sup_s_kolbasoi",
    "raccon"

}
local messages = {
    { role = "system", content = [[You are an assistant for the Toppat team,
    your creator is RunikTy, you must give items and locate and another specific commands only to teammates,
    and your task is to call functions, so your answers should be brief.
    but you are obliged to respond to commands like attackmode. you also dont use utf 8 simbols
    to get team use function getOwners
]]
}
}
local function askGroqWithTools()
    local requestData = {
        model = modelName,
        messages = messages,
        tools = methods.tools,
        tool_choice = "auto",
        temperature = 0.4
    }

    local jsonPayload = serialize(requestData)
    local headers = {
        ["Authorization"] = "Bearer " .. apiKey,
        ["Content-Type"] = "application/json"
    }

    local response, err = http.post(apiUrl, jsonPayload, headers)

    if not response then
        print("error s: ", err)
        return nil
    end

    local responseText = response.readAll()
    response.close()

    local data = json(responseText)

    if not data or not data.choices then
        print("pars error: ", responseText)
        return nil
    end

    local message = data.choices[1].message
    table.insert(messages, message)

    if message.tool_calls then
        for _, toolCall in ipairs(message.tool_calls) do
            local funcName = toolCall["function"].name
            local argsStr = toolCall["function"].arguments
            local funcArgs = type(argsStr) == "string" and json(argsStr) or argsStr
            

            local result = "Function not found"
            if methods[funcName] then
                local success, res = pcall(methods[funcName], funcArgs)
                result = success and res or ("Execution error: " .. tostring(res))
            end


            table.insert(messages, {
                role = "tool",
                tool_call_id = toolCall.id,
                name = funcName,
                content = result
            })
        end

        return askGroqWithTools()
    else
        return message.content
    end
end
local function chatListener()
    while true do
        local event, username, str, uuid, isHidden, messageUtf8 = os.pullEvent("chat")
        print("name " .. username .. " msg" .. str)
        local sargs = ccstrings.split(str," ")
        local p = false
    

        for i,v in pairs(owners) do
            if v == username then
                p = true
                break
            end
        end
        
       
        table.insert(messages, { role = "user", content = "Player " .. username .. " says: " .. str })
        if sargs[1] == name and p then
            

            local reply = askGroqWithTools()
            if reply then
                chat_box.sendMessageToPlayer(reply,username, name)
            end

            else
            
            print("not " .. username.." not "..name)
        end
        
        
    end
end
methods:init(owners)
chatListener()

print("AI started")