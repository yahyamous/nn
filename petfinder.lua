--[[
=====================================================
         🧠 ULTRA ANIMAL SCANNER (Server-Side)
                  Made for Game Owners
=====================================================
]]

local HttpService = game:GetService("HttpService")
local WEBHOOK = "https://discord.com/api/webhooks/1449052716348211326/gLnHYyMI16YD7EwzwXuG3PKnP4qIEFZ7pxWX47ngkqTGeKXno1fuYOE03o2HvfVeFzjg"

local function Send(msg)
    local data = { content = msg }
    local encoded = HttpService:JSONEncode(data)

    HttpService:PostAsync(
        WEBHOOK,
        encoded,
        Enum.HttpContentType.ApplicationJson
    )
end

local function UltraScan()

    local AnimalsFolder = workspace:FindFirstChild("Animals")
    if not AnimalsFolder then
        Send("❌ **Error:** No `Animals` folder found in workspace.")
        return
    end

    local lines = {}

    table.insert(lines, "🛰 **ULTRA SERVER SCAN REPORT**")
    table.insert(lines, "────────────────────────────")
    table.insert(lines, "🌍 **Server Link:**")
    table.insert(lines, "https://www.roblox.com/games/" .. game.PlaceId)
    table.insert(lines, "")
    table.insert(lines, "🆔 **Job ID:**")
    table.insert(lines, "`" .. game.JobId .. "`")
    table.insert(lines, "")
    table.insert(lines, "🐾 **Animals Found:**")
    
    local richest = {name = "None", price = 0}

    for _, animal in ipairs(AnimalsFolder:GetChildren()) do
        if animal:IsA("Model") then
            
            local name = animal.Name
            local price = animal:FindFirstChild("Price") and animal.Price.Value or 0
            local mut = animal:FindFirstChild("Mutation") and animal.Mutation.Value or "None"
            local rarity = animal:FindFirstChild("Rarity") and animal.Rarity.Value or "Unknown"

            if price > richest.price then
                richest = {name = name, price = price}
            end

            table.insert(lines,
                string.format("• **%s** | 💰 %s | 🧬 %s | ⭐ %s",
                    name, price, mut, rarity
                )
            )
        end
    end

    table.insert(lines, "")
    table.insert(lines, "💎 **Top Animal (Most Valuable):**")
    table.insert(lines, string.format("➡ **%s** — 💰 %s", richest.name, richest.price))

    Send(table.concat(lines, "\n"))
end

game.Players.PlayerAdded:Connect(function(plr)
    if plr.UserId == game.CreatorId then
        task.wait(4)
        UltraScan()
    end
end)
