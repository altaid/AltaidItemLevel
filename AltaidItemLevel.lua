local Frame = CreateFrame("Frame")
local Tooltip = CreateFrame('GameTooltip', 'MyTooltip', UIParent, 'GameTooltipTemplate')
local Tooltip2 = CreateFrame('GameTooltip', 'MyTooltip2', UIParent, 'GameTooltipTemplate')
Frame:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")

local function eventHandler(self, event, ...)
    ilevel()
end

Frame:SetScript("OnEvent", eventHandler)

local Items = {
    "HeadSlot",
    "NeckSlot",
    "ShoulderSlot",
    "ChestSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "WristSlot",
    "HandsSlot",
    "Finger0Slot",
    "Finger1Slot",
    "Trinket0Slot",
    "Trinket1Slot",
    "BackSlot",
    "MainHandSlot",
    "SecondaryHandSlot"
}

function ilevel()
    for _, value in pairs(Items) do
        local slotId = GetInventorySlotInfo(value)
        local itemLink = GetInventoryItemLink("player", slotId)
        local GSlotKey = "Character" .. value
        local Stock = getglobal(GSlotKey .. "Stock")
        local w, h = _G[GSlotKey]:GetSize()

        Stock:Hide();

        -- Creating fontstring for item level
        if not _G[GSlotKey .. "il"] then
            local il = _G[GSlotKey]:CreateFontString(GSlotKey .. "il", "ARTWORK")
            il:SetAllPoints(true)
            il:SetFontObject(Stock:GetFontObject())
            il:SetJustifyV("BOTTOM")
            il:SetTextColor(1, 1, 0)
            il:SetShadowColor(1, 1, 1, 1);
        else
            _G[GSlotKey .. "il"]:SetText("")
        end

        -- Creating fontstring for enchants
        if not _G[GSlotKey .. "en"] then
            local en = _G[GSlotKey]:CreateFontString(GSlotKey .. "en", "OVERLAY")
            en:SetAllPoints(true)
            en:SetFontObject(Stock:GetFontObject())
            en:SetJustifyV("TOP")
            en:SetJustifyH("LEFT")
            en:SetTextColor(1, 1, 0)
            en:SetShadowColor(1, 1, 1, 1);
        else
            _G[GSlotKey .. "en"]:SetText("")
        end

        -- Creating fontstring for gems
        if not _G[GSlotKey .. "ge"] then
            local ge = _G[GSlotKey]:CreateFontString(GSlotKey .. "ge", "OVERLAY")
            ge:SetAllPoints(true)
            ge:SetFontObject(Stock:GetFontObject())
            ge:SetJustifyV("TOP")
            ge:SetJustifyH("RIGHT")
            ge:SetTextColor(1, 1, 0)
            ge:SetShadowColor(1, 1, 1, 1);
        else
            _G[GSlotKey .. "ge"]:SetText("")
        end

        if itemLink then
            local _, _, _, ilvl = GetItemInfo(itemLink)
            local _, gemlink = GetItemGem(itemLink, 1)

            _G[GSlotKey .. "il"]:SetText(ilvl)

            Tooltip:Hide();
            Tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
            Tooltip:ClearLines();
            Tooltip:SetHyperlink(itemLink);

            for m = 1, Tooltip:NumLines() do
                if _G["MyTooltipTextLeft" .. m]:GetText():match(ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)")) then
                    _G[GSlotKey .. "en"]:SetText('e')
                    break
                end
            end

            if gemlink then
                Tooltip2:Hide()
                Tooltip2:SetOwner(UIParent, 'ANCHOR_NONE')
                Tooltip2:ClearLines();
                Tooltip2:SetHyperlink(gemlink)

                for i = 2, Tooltip2:NumLines() do
                    if _G["MyTooltip2TextLeft" .. i]:GetText():find("+") then
                        _G[GSlotKey .. "ge"]:SetText("g")
                        break
                    end
                end
            end
        end
    end
end

ilevel()
