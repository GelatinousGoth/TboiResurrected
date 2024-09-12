local mod = require("resurrected_modpack.mod_reference")

mod.CurrentModName = "Coin Flip"

local json = require("json");



function mod:Save()
    local data = self.Data;
    local str = json.encode(data);
    self:SaveData(str);
end
function mod:Load()
    if (not self:HasData()) then
        self.Data = {};
    else
        local str = self:LoadData();
        local data = json.decode(str);
        self.Data = data;
    end
    return self.Data;
end
function mod:SetKeyboardKey(key)
    local data = self.Data or self:Load();
    data.Key = key;
    self:Save();
end
function mod:GetKeyboardKey()
    local data = self.Data or self:Load();
    return data.Key or Keyboard.KEY_K;
end
function mod:SetControllerKey(key)
    local data = self.Data or self:Load();
    data.ControllerKey = key;
    self:Save();
end
function mod:GetControllerKey()
    local data = self.Data or self:Load();
    return data.ControllerKey or -1;
end
function mod:ClearSeed()
    local data = self.Data or self:Load();
    data.Seed = nil;
    self:Save();
end
function mod:RandomInt(min, max)
    local data = self.Data or self:Load();
    local seed = data.Seed or Game():GetSeeds():GetStartSeed();
    local rng = RNG();
    rng:SetSeed(seed, 35);
    local value = rng:RandomInt(max) + min;
    data.Seed = rng:Next();
    self:Save();
    return value;
end
function mod:CreateSprite(good)
    local anim = "FlipGood";
    if (not good) then
        anim = "FlipBad";
    end
    local spr = Sprite();
    spr:Load("gfx/coin_flipper.anm2", true);
    spr:Play(anim);
    return spr;
end

function mod:PostPlayerUpdate(player)
    if (player.Parent) then
        return;
    end
    local playerType = player:GetPlayerType();
    if (playerType == PlayerType.PLAYER_ESAU or playerType == PlayerType.PLAYER_THESOUL_B) then
        return;
    end

    local playerData = player:GetData();
    playerData._CoinFlipper = playerData._CoinFlipper or {};
    local data = playerData._CoinFlipper;

    if (not data.Flipping) then
        local pressed = false;
        local keyboardKey = mod:GetKeyboardKey();
        local controllerKey = mod:GetControllerKey();
        if (keyboardKey >= 32) then
            pressed = pressed or Input.IsButtonTriggered(keyboardKey, player.ControllerIndex);
        end
        if (controllerKey < 32) then
            pressed = pressed or Input.IsButtonTriggered(controllerKey, player.ControllerIndex);
        end
        if (pressed) then
            local sfx = SFXManager();
            data.Flipping = true;
            data.FlipResult = mod:RandomInt(0, 2) == 0;
            data.FlipSprite = mod:CreateSprite(data.FlipResult);
            sfx:Play(SoundEffect.SOUND_ULTRA_GREED_PULL_SLOT);
            sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SLOT_SPIN_LOOP)
        end
    else
        data.FlipSprite = data.FlipSprite or mod:CreateSprite(data.FlipResult);
        local spr = data.FlipSprite;
        spr:Update();
        if (spr:IsFinished(spr:GetAnimation())) then
            data.Flipping = nil;
            data.FlipResult = nil;
            data.FlipSprite = nil;
        else
            local sfx = SFXManager();
            if (spr:IsEventTriggered("Good")) then
                sfx:Play(SoundEffect.SOUND_THUMBSUP);
            elseif (spr:IsEventTriggered("Bad")) then
                sfx:Play(SoundEffect.SOUND_THUMBS_DOWN);
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.PostPlayerUpdate);

function mod:PostPlayerRender(player, offset)
    local playerData = player:GetData();
    local data = playerData._CoinFlipper;
    if (data and data.Flipping) then
        local spr = data.FlipSprite;
        local game = Game();
        local room = game:GetRoom();
        local pos =  Isaac.WorldToScreen(player.Position) + Vector(0, -64) + offset - room:GetRenderScrollOffset() - game.ScreenShakeOffset;
        spr:Render(pos, Vector.Zero, Vector.Zero);
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.PostPlayerRender);

function mod:PostGameStarted(isContinued)
    if (not isContinued) then
        mod:ClearSeed();
    end
end
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.PostGameStarted);


require("compatibilities/mod_config_menu");