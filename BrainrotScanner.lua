local Scanner = {}

-- إعدادات عامة
Scanner.Config = {
    AnimalFolderName = "Animals",       -- المكان الذي توجد فيه الحيوانات داخل الـ Workspace
    PriceModuleName = "AnimalPrices",   -- ModuleScript يحتوي الأسعار
    MutationAttribute = "Mutation",     -- اسم الـ Attribute الخاص بالـ Mutation
    RarityAttribute = "Rarity",         -- ندرة الحيوان
}

-- دالة تحميل الأسعار من ModuleScript
function Scanner:LoadPrices()
    local priceModule = workspace:FindFirstChild(self.Config.PriceModuleName)
    if priceModule and priceModule:IsA("ModuleScript") then
        local ok, data = pcall(require, priceModule)
        if ok then
            self.Prices = data
        else
            warn("Price module error.")
            self.Prices = {}
        end
    else
        warn("Price module not found.")
        self.Prices = {}
    end
end

-- دالة قراءة المعلومات من الحيوان
function Scanner:GetAnimalData(animal)
    local name = animal.Name
    local mutation = animal:GetAttribute(self.Config.MutationAttribute) or "None"
    local rarity = animal:GetAttribute(self.Config.RarityAttribute) or "Unknown"
    local price = self.Prices[name] or 0

    return {
        Name = name,
        Price = price,
        Mutation = mutation,
        Rarity = rarity,
        ModelPath = animal:GetFullName(),
    }
end

-- دالة الفحص الكامل
function Scanner:Scan()
    self:LoadPrices()

    local folder = workspace:FindFirstChild(self.Config.AnimalFolderName)
    if not folder then
        warn("Animal folder not found.")
        return {}
    end

    local results = {}
    for _, animal in ipairs(folder:GetChildren()) do
        if animal:IsA("Model") then
            table.insert(results, self:GetAnimalData(animal))
        end
    end

    table.sort(results, function(a, b)
        return a.Price > b.Price
    end)

    return results
end

-- إخراج JSON (مثلاً لإرسال المعلومات إلى Discord)
function Scanner:ToJSON(data)
    local ok, encoded = pcall(function()
        return game:GetService("HttpService"):JSONEncode(data)
    end)

    return ok and encoded or "{}"
end

return Scanner
