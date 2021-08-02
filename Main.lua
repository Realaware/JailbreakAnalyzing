--[[
    experimental jailbreak script.
]]

-- ready stage
local Doors = {};
local Functions = {};
local Functions2 = {};
local Hashes = {};

local LocalPlayer = game:GetService('Players').LocalPlayer;

-- jailbreak modules
local oldSpecs = require(game:GetService("ReplicatedStorage").Module.UI).CircleAction.Specs;
local Notification = require(game:GetService("ReplicatedStorage").Game.Notification);
local GunShop = require(game:GetService("ReplicatedStorage").Game.GunShop.GunShopUI);
local Safes = require(game:GetService("ReplicatedStorage").Game.SafesUI);
local PlayerUtil = require(game:GetService("ReplicatedStorage").Game.PlayerUtils);

for i,v in pairs (getgc(true)) do
    if (type(v) == 'function') then
        local cons = debug.getconstants(v);
        if (getfenv(v).script == LocalPlayer.PlayerScripts.LocalScript) then
            if (table.find(cons, 'SequenceRequireState')) then
                Functions.OpenDoor = v;
            elseif (table.find(cons, 'NitroLoop') and table.find(cons, 'Nitro1')) then
                Functions.NitroFunction = v;
            elseif (table.find(cons, 'Eject') and table.find(cons, 'GetChildren')) then
                local proto = debug.getproto(v, 1);
                local old = debug.getupvalue(proto, 1);
                
                debug.setupvalue(proto, 1, {
                    FireServer = function(self, Key, ...)
                        debug.setupvalue(proto, 1, old);
    
                        Hashes.CarKick = Key;
                    end
                });
                proto() -- hash
            elseif (table.find(cons, 'ShouldEject') and table.find(cons, 'Vehicle')) then
                do
                    local upvalue = debug.getupvalues(v)[1];
                    local upvalues = debug.getupvalues(upvalue);
                    
                    table.foreach(upvalues, function(index, value)
                        local old = debug.getupvalue(upvalue, index);
        
                        debug.setupvalue(upvalue, 1, {
                            FireServer = function(self, Key, ...)
                                debug.setupvalue(upvalue, 1, old);
            
                                Hashes.Eject = Key;
                            end
                        });
                        upvalue()
                    end)
                end
                do
                    local func = debug.getupvalue(v, 3);
            
                    for idx, value in pairs (debug.getupvalues(func)) do
                        if (type(value) == 'table' and rawget(value, 'FireServer')) then
                            local old = debug.getupvalue(func, idx);

                            debug.setupvalue(func, idx, {
                                FireServer = function(self, Key, ...)
                                    debug.setupvalue(func, idx, old);

                                    Hashes.GetInCar = Key;
                                end
                            })
                            func({});
                        end
                    end
                end
            elseif (table.find(cons, 'Punch') and table.find(cons, 'Play')) then
                local upv = debug.getupvalues(v);

                for idx, value in pairs (upv) do
                    if (type(value) == 'table' and rawget(value, 'FireServer')) then
                        local old = debug.getupvalue(v, idx);
    
                        debug.setupvalue(v, idx, {
                            FireServer = function(self, Key, ...)
                                debug.setupvalue(v, idx, old);
    
                                Hashes.Punch = Key;
                            end
                        })
                        -- why should we do like this is that a function which contains punch func require those arguments.
                        v({ Name = 'Punch' }, true);
                    end
                end
            elseif (table.find(cons, 'OnVehicleJumpExited') and table.find(cons, 'LastVehicleExit') and table.find(cons, 'FireServer')) then
                local upv = debug.getupvalues(v);
                local _old = debug.getupvalue(v, 1);
    
                debug.setupvalue(v, 1, {});
    
                table.foreach(upv, function(idx, value)
                    if (type(value) == 'table' and rawget(value, 'FireServer')) then
                        local old = debug.getupvalue(v, idx);
                        debug.setupvalue(v, idx, {
                            FireServer = function(self, Key, ...)
                                debug.setupvalue(v, idx, old);
    
                                Hashes.ExitCar = Key;
                            end
                        })
    
                        v();
                    end
                end)
                debug.setupvalue(v, 1, _old);
            end
        end
    elseif (type(v) == 'table') then
        if (rawget(v, 'OpenFun') and rawget(v, 'State')) then
            table.insert(Doors, v);
        elseif (rawget(v, 'Ragdoll')) then
            Functions.Ragdoll = v;
        elseif (rawget(v, 'FireServer')) then
            Functions.Network = v;
        end
    end
end

do
    local cons = debug.getconstants(Safes.SetupUseSafes);
    local Index = table.find(cons, 'Inner');

    Hashes.OpenSafe = cons[Index + 1];
end

do
    local func = require(game:GetService("ReplicatedStorage").Game.TeamChooseUI).Show;

    local proto = debug.getproto(func, 6);
    local old = debug.getupvalue(proto, 2);

    debug.setupvalue(proto, 2, {
        FireServer = function(self, Key, ...)
            debug.setupvalue(proto, 2, old);

            Hashes.SwitchTeam = Key
        end
    });

    proto();
end

function Functions2:OpenAllDoors()
    table.foreach(Doors, function(_, v)
        v.Settings.Team = true;
        Functions2.OpenDoor(v);
    end);
end

function Functions2:SetNitro(value)
    debug.getupvalue(Functions.NitroFunction, 8).Nitro = value;
end

-- Police or Prisoner
function Functions2:ChangeTeam(value)
    Functions.Network:FireServer(Hashes.SwitchTeam, value);
end

function Functions2:NoWait(value)
    local module = require(game:GetService("ReplicatedStorage").Module.UI).CircleAction;
    if (value) then
        table.foreach(module.Specs, function(i,v)
            v.Duration = 0;
        end)
    else
        table.foreach(module.Specs, function(i,v)
            v.Duration = oldSpecs[i].Duration;
        end)
    end
end

function Functions2:Notify(Text, Duration)
    Notification.new({Text = Text, Duration = Duration});
end

function Functions2:OpenAllSafe(amount)
    if (type(amount) ~= 'number' or amount == 0) then return end
    
    local list = Safes.ListSafes;
    local button = LocalPlayer.PlayerGui.SafesGui.ContainerSlider.ContainerSkip; 

    for i,v in pairs (list) do
        if (i == amount) then return end;
        Functions.Network:FireServer(Hashes.OpenSafe, v);
        wait();
        firesignal(button.MouseButton1Down, true);
        wait(1);
    end
end

local oldRagdoll = Functions.Ragdoll;

function Functions2:NoRagdoll(value)
    Functions.Ragdoll = function(...)
        if (value) then
            return wait(9e9);
        else
            return oldRagdoll(...)
        end
    end
end

local oldFunction1 = PlayerUtil.isPointInTag;

function Functions2:NoFallDamage(value)
    PlayerUtil.isPointInTag = function(...)
        local arg = {...};

        if (table.find(arg, 'NoFallDamage')) then
            if (value) then
                return true
            else
                return oldFunction1(...);
            end
        end
    end
end

local SpamPunch = false;

spawn(function()
    while SpamPunch do
        Functions.Network:FireServer(Hashes.Punch);
        wait();
    end
end)

function Functions2:SpamPunch(value)
    SpamPunch = value;
end
