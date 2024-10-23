local TR_Manager = require("resurrected_modpack.manager")

CoinFlipper = TR_Manager:RegisterMod("Coin Flip", 1)

local json = require("json");

function CoinFlipper:Save()
    local data = self.Data;
    local str = json.encode(data);
    self:SaveData(str);
end
function CoinFlipper:Load()
    if (not self:HasData()) then
        self.Data = {};
    else
        local str = self:LoadData();
        local data = json.decode(str);
        self.Data = data;
    end
    return self.Data;
end
function CoinFlipper:SetKeyboardKey(key)
    local data = self.Data or self:Load();
    data.Key = key;
    self:Save();
end
function CoinFlipper:GetKeyboardKey()
    local data = self.Data or self:Load();
    return data.Key or Keyboard.KEY_K;
end
function CoinFlipper:SetControllerKey(key)
    local data = self.Data or self:Load();
    data.ControllerKey = key;
    self:Save();
end
function CoinFlipper:GetControllerKey()
    local data = self.Data or self:Load();
    return data.ControllerKey or -1;
end
function CoinFlipper:ClearSeed()
    local data = self.Data or self:Load();
    data.Seed = nil;
    self:Save();
end
function CoinFlipper:RandomInt(min, max)
    local data = self.Data or self:Load();
    local seed = data.Seed or Game():GetSeeds():GetStartSeed();
    local rng = RNG();
    rng:SetSeed(seed, 35);
    local value = rng:RandomInt(max) + min;
    data.Seed = rng:Next();
    self:Save();
    return value;
end
function CoinFlipper:CreateSprite(good)
    local anim = "FlipGood";
    if (not good) then
        anim = "FlipBad";
    end
    local spr = Sprite();
    spr:Load("gfx/coin_flipper.anm2", true);
    spr:Play(anim);
    return spr;
end

function CoinFlipper:PostPlayerUpdate(player)
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
        local keyboardKey = CoinFlipper:GetKeyboardKey();
        local controllerKey = CoinFlipper:GetControllerKey();
        if (keyboardKey >= 32) then
            pressed = pressed or Input.IsButtonTriggered(keyboardKey, player.ControllerIndex);
        end
        if (controllerKey < 32) then
            pressed = pressed or Input.IsButtonTriggered(controllerKey, player.ControllerIndex);
        end
        if (pressed) then
            local sfx = SFXManager();
            data.Flipping = true;
            data.FlipResult = CoinFlipper:RandomInt(0, 2) == 0;
            data.FlipSprite = CoinFlipper:CreateSprite(data.FlipResult);
            sfx:Play(SoundEffect.SOUND_ULTRA_GREED_PULL_SLOT);
            sfx:Play(SoundEffect.SOUND_ULTRA_GREED_SLOT_SPIN_LOOP)
        end
    else
        data.FlipSprite = data.FlipSprite or CoinFlipper:CreateSprite(data.FlipResult);
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
CoinFlipper:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CoinFlipper.PostPlayerUpdate);

function CoinFlipper:PostPlayerRender(player, offset)
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
CoinFlipper:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, CoinFlipper.PostPlayerRender);

function CoinFlipper:PostGameStarted(isContinued)
    if (not isContinued) then
        CoinFlipper:ClearSeed();
    end
end
CoinFlipper:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, CoinFlipper.PostGameStarted);