-- ME Bridges
local main = peripheral.wrap("top")
local reference = peripheral.wrap("back")
local subnet = peripheral.wrap("bottom")
local chatbox = peripheral.wrap("right")

-- Network item lists
local mainItems = main.listItems()
local referenceItems = reference.listItems()
local subnetItems = subnet.listItems()
local craftable = main.listCraft()

-- name, amount, meta, nbt, displayName

function getItem(list, item)
    for i=1,#list do
        if list[i].name == item.name and list[i].meta == item.meta then
            return list[i]
        end
    end
end

function restockItem(referenceItem)
    local subnetItem = getItem(subnetItems, referenceItem)
    local mainItem = getItem(mainItems, referenceItem)

    -- Calculate needed items
    local needed = referenceItem.amount
    if subnetItem ~= nil then
        needed = referenceItem.amount - subnetItem.amount
    end
    if needed <= 0 then return end

    -- Calculate missing items
    local missing = needed
    if mainItem ~= nil then
        if needed > mainItem.amount then
            missing = needed - mainItem.amount
        else
            missing = 0
        end
    end

    if missing > 0 then
        -- Check if craftable
        if getItem(craftable, referenceItem) ~= nil then
            main.craft(referenceItem.name, referenceItem.meta, missing)
            
            print("Crafting", missing, referenceItem.displayName)
        else
            print("Missing", missing, referenceItem.displayName)
            pcall(chatbox.say, "Missing " .. missing .. " " .. referenceItem.displayName)
        end
    end

    if missing == needed then return end
    
    print("+", needed - missing, referenceItem.displayName)

    main.export(referenceItem.name, referenceItem.meta, needed - missing, "west", referenceItem.nbt)
end

function purgeItem(subnetItem)
    local referenceItem = getItem(referenceItems, subnetItem)
    local needed = 0
    if referenceItem ~= nil then
        needed = referenceItem.amount
    end
    if subnetItem.amount <= needed then return end
    print("-", subnetItem.amount - needed, subnetItem.displayName)

    subnet.export(subnetItem.name, subnetItem.meta, subnetItem.amount - needed, "west", subnetItem.nbt)
end

function restock()
    for i=1,#referenceItems do
        restockItem(referenceItems[i])
    end
end

function purge()
    for i=1,#subnetItems do
        purgeItem(subnetItems[i])
    end
end

print("Stocking!")
while true do
    mainItems = main.listItems()
    referenceItems = reference.listItems()
    subnetItems = subnet.listItems()
    craftable = main.listCraft()
    purge()
    restock()
    os.sleep(10)
end
