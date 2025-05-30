local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- Настройки поиска
local SEARCH_FOLDER = "ItemPickup"  
local TARGET_ITEMS = {    
    "Small present",
    "Mustang key",
    "NextBot Grenade",
    "Heavy Vest",
    "Rollie",
    "Gold AK-47",
    "P90",
    "Airstrike Marker",
    "helicopter key",
    "Gold Lucky Block", 
    "Blue Lucky Block",
    "Police Armory Keycard",
    "Red Lucky Block",
    "Orange Lucky Block",
    "Military Armory Keycard",
    "Airdrop Marker",
    "Ammo Box",
    "Green Lucky Block"

}

local function findItemFolder()
    local path = Workspace
    for _, folderName in ipairs({"Game", "Entities", SEARCH_FOLDER}) do
        path = path:FindFirstChild(folderName)
        if not path then return nil end
    end
    return path
end


local function findTargetItems(folder)
    local found = {}
    for _, item in ipairs(folder:GetDescendants()) do
        if item:IsA("BasePart") or item:IsA("Model") then
            local itemName = item:GetAttribute("itemName") or item.Name
            if itemName then
                for _, target in ipairs(TARGET_ITEMS) do
                    if string.lower(itemName) == string.lower(target) then
                        local pos = item:IsA("Model") and (item.PrimaryPart and item.PrimaryPart.Position or item:GetPivot().Position) or item.Position
                        table.insert(found, {
                            Object = item,
                            Position = pos
                        })
                    end
                end
            end
        end
    end
    return found
end


local function teleportPlayer(player, position)
    if not player or not player.Character then return false end
    
    local humanoid = player.Character:FindFirstChild("Humanoid")
    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return false end
    

    rootPart.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
    return true
end


local function main()
    local folder = findItemFolder()
    if not folder then
        warn("❌ Папка не найдена! Проверьте путь: Workspace.Game.Entities."..SEARCH_FOLDER)
        return
    end

    local items = findTargetItems(folder)
    if #items == 0 then
        warn("⚠️ Объекты не найдены! Проверьте атрибуты itemName или имена объектов.")
        return
    end

    local player = Players.LocalPlayer
    if not player then return end

    for i, item in ipairs(items) do
        print(string.format("🚀 Телепортация к объекту %d/%d: %s @ %s", 
            i, #items, item.Object.Name, tostring(item.Position)))
        
        if teleportPlayer(player, item.Position) then
            task.wait(2)  -- Задержка между телепортациями
        end
    end

    print("✅ Телепортация завершена! Найдено объектов: "..#items)
end

-- Запуск с задержкой (если объекты подгружаются динамически)
task.wait(2)
main()