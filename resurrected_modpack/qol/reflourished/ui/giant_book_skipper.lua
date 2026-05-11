local function GiantBookSkipperEnabler()

GiantBookSkipper = RegisterMod(" Giant Book Skipper", 1)
local data = include("gbs.deadseascrolls").Init()

local choice = {
    ButtonAction.ACTION_ITEM,
    ButtonAction.ACTION_DROP,
    ButtonAction.ACTION_PILLCARD,
    ButtonAction.ACTION_BOMB,
    ButtonAction.ACTION_MAP,
}

local overlay = false
local length = Giantbook.ETERNAL_HEART_BLACK
local skipIt = false

GiantBookSkipper.ModdedBlacklist = {}

local ingameblacklist = {
    Giantbook.SUPER_BUM,
    Giantbook.SLEEP_NIGHTMARE,
    Giantbook.MEGA_MUSH,
}

local function isBlacklisted(overlayId)
    for name in pairs(GiantBookSkipper.ModdedBlacklist) do
        local id = Isaac.GetGiantBookIdByName(name)
        if id == overlayId then
            return true
        end
    end

    for _, id in ipairs(ingameblacklist) do
        if id == overlayId then
            return true
        end
    end

    return false
end

local function IsSkipPressed(controllerIndex)
    local c = data.GetOption("actionbind")
    if c ~= 1 then
        return Input.IsActionTriggered(choice[c - 1], controllerIndex)
    end

    for _, action in ipairs(choice) do
        if Input.IsActionTriggered(action, controllerIndex) then
            return true
        end
    end

    return false
end

local function HandleSleepBook(sprite, pressed)
    local frame = sprite:GetFrame()

    if skipIt and frame == 73 then
        sprite:SetFrame(999)
        skipIt = false
        return
    end

    skipIt = false

    if not pressed then
        return
    end

    if frame < 72 then
        sprite:SetFrame(72)
        skipIt = true
    elseif frame >= 73 then
        sprite:SetFrame(999)
    end
end

local function PostRender()
    if not overlay then return end

    overlay = false

    local sprite = ItemOverlay.GetSprite()
    if not (sprite and sprite:GetFrame()) then return end

    local overlayId = ItemOverlay:GetOverlayID()

    if data.GetOption("vanilla") == 2 and overlayId > length then return end

    if isBlacklisted(overlayId) then return end

    local player = ItemOverlay:GetPlayer()
    local controllerIndex = (player and player.ControllerIndex) or 0
    local pressed = IsSkipPressed(controllerIndex)

    if overlayId == Giantbook.SLEEP then
        HandleSleepBook(sprite, pressed)
    else
        skipIt = false
        if pressed then
            sprite:SetFrame(999)
        end
    end
end

local function ItemOverlayRender()
    overlay = true
end


---@param str string
function GiantBookSkipper.AddGiantBookExclusionByName(str)
    if type(str) ~= "string" then
        return
    end
    GiantBookSkipper.ModdedBlacklist[str] = true
end

function GiantBookSkipper.GetExclusionList()
    return GiantBookSkipper.ModdedBlacklist
end

GiantBookSkipper:AddCallback(ModCallbacks.MC_POST_RENDER, PostRender)
GiantBookSkipper:AddCallback(ModCallbacks.MC_POST_ITEM_OVERLAY_RENDER, ItemOverlayRender)

end
return GiantBookSkipperEnabler