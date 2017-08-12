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

local gemFrame = CreateFrame('GameTooltip', 'SocketTooltip', UIParent, 'GameTooltipTemplate');
gemFrame:SetOwner(UIParent, 'ANCHOR_NONE');
function checkEmptySockets(unitid, slot)
    local count = 0;
    gemFrame:SetOwner(UIParent, 'ANCHOR_NONE');
    gemFrame:ClearLines();
    gemFrame:SetInventoryItem(unitid, slot)

    for textureCount = 1, 10 do
        local temp = _G["SocketTooltipTexture" .. textureCount]:GetTexture();

        if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Meta" then
            count = count + 1;
        end

        if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Red" then
            count = count + 1;
        end

        if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Yellow" then
            count = count + 1;
        end

        if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Blue" then
            count = count + 1;
        end

        if temp and temp == "Interface\\ItemSocketingFrame\\UI-EmptySocket-Prismatic" then
            count = count + 1;
        end
    end
    return count;
end

function ilevel()
    for key, value in pairs(Items) do
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
            en:SetShadowColor(1, 1, 1, 1)
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
            ge:SetShadowColor(1, 1, 1, 1)
        else
            _G[GSlotKey .. "ge"]:SetText("")
        end

        if itemLink then
            local _, _, _, ilvl = GetItemInfo(itemLink)
            local _, gemlink = GetItemGem(itemLink, 1)

            _G[GSlotKey .. "il"]:SetText(ilvl)

            if key == 2 or key == 14 or key == 11 or key == 10 then
                _G[GSlotKey .. "en"]:SetText('E')
            end

            Tooltip:Hide();
            Tooltip:SetOwner(UIParent, 'ANCHOR_NONE')
            Tooltip:ClearLines();
            Tooltip:SetHyperlink(itemLink);

            for m = 1, Tooltip:NumLines() do
                if _G["MyTooltipTextLeft" .. m]:GetText():match(ENCHANTED_TOOLTIP_LINE:gsub("%%s", "(.+)")) then
                    _G[GSlotKey .. "en"]:SetTextColor(1, 1, 0)
                    break
                else
                    _G[GSlotKey .. "en"]:SetTextColor(0.77, 0.12, 0.23)
                end
            end

            if checkEmptySockets("player", slotId) > 0 then
                _G[GSlotKey .. "ge"]:SetText('G')
                _G[GSlotKey .. "ge"]:SetTextColor(0.77, 0.12, 0.23)
            end

            if gemlink then
                Tooltip2:Hide()
                Tooltip2:SetOwner(UIParent, 'ANCHOR_NONE')
                Tooltip2:ClearLines();
                Tooltip2:SetHyperlink(gemlink)

                for i = 2, Tooltip2:NumLines() do
                    if _G["MyTooltip2TextLeft" .. i]:GetText():find("+") then
                        _G[GSlotKey .. "ge"]:SetText('G')
                        _G[GSlotKey .. "ge"]:SetTextColor(1, 1, 0)
                        break
                    end
                end
            end
        end
    end
end

ilevel()
