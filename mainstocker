-- ME Bridges
local main = peripheral.wrap("top")
local reference = peripheral.wrap("bottom")

-- Network item lists
local mainItems = main.listItems()
local referenceItems = reference.listItems()
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
    local mainItem = getItem(mainItems, referenceItem)

    -- Calculate needed items
    local needed = referenceItem.amount
    if mainItem ~= nil then
        needed = referenceItem.amount - mainItem.amount
    end
    if needed <= 0 then return end

    -- Check if craftable
    if getItem(craftable, referenceItem) ~= nil then
        main.craft(referenceItem.name, referenceItem.meta, needed)
        
        print("+", needed, referenceItem.displayName)
    else
        print("Missing", needed, referenceItem.displayName)
    end
end

function restock()
    for i=1,#referenceItems do
        restockItem(referenceItems[i])
    end
end

print("Stocking!")
while true do
    mainItems = main.listItems()
    referenceItems = reference.listItems()
    craftable = main.listCraft()

    restock()

    os.sleep(10)
    sleep(1)
end
