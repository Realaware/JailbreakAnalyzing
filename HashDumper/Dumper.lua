local Maps = {};
local FindingMethod = {};
local Hashes = {};


-- hash maps that we are going to find.
Maps = {
    OpenDoor = {
        Constants = {'SequenceRequireState'},
        isFunction = true,
    },
    CarKick = {
        Constants = {'Eject', 'GetChildren'},
        ProtoIndex = 1,
        UpvalueIndex = 1
    },
    Eject = {
        Constants = {'ShouldEject', 'Vehicle'},
        UpvalueIndex = 2,
        isFunction = true
    },
    GetInCar = {
        Constants = {'ShouldEject', 'Vehicle'},
        UpvalueIndex = 3,
        isFunction = true,
        Arguments = {{}},
    },
    Punch = {
        Constants = {'Punch', 'Play'},
        Arguments = {{ Name = 'Punch'}, true}
    },
    ExitCar = {
        Constants = {'OnVehicleJumpExited', 'LastVehicleExit', 'FireServer'},
        isFunction = true,
        Modify = function(Function)
           local _old = debug.getupvalue(Function, 1);
           debug.setupvalue(Function, 1, { old = _old })
        end,
        Fix = function(Function)
            debug.setupvalue(Function, 1, debug.getupvalue(Function, 1).old);
        end
    },
    PlaySound = {
        Constants = {'InjanHorn', 'Passenger'},
        UpvalueIndex = 5,
        isFunction = true,
        noScan = true,
    },
    Arrest = {
        Constants = {'Handcuffs', 'GetLocalEquipped', 'Reloading'},
        UpvalueIndex = 7,
        isFunction = true,
        Arguments = {{}},
    },
    -- SewerHatch and ExplodeWall etc..
    Door2 = {
        Constants = {'SewerHatch', 'Fun'},
        ProtoIndex = 1,
        UpvalueIndex = 1,
        Arguments = {nil, true}
    },
    RobSmallStore = {
        Constants = {'Rob', 'Duration'},
        UpvalueIndex = 1,
        isFunction = true,
        UpvalueIndex = 1,
        Arguments = {{}, true},
        NeedRepeat = true,
    },
    OpenSafe = {
        Location = require(game:GetService("ReplicatedStorage").Game.SafesUI).SetupUseSafes,
        Find = function(Function)
            local Cons = debug.getconstants(Function);
            local Index = table.find(Cons, 'Inner');

            Hashes.OpenSafe = Cons[Index + 1];
            print(Cons[Index + 1])
        end
    },

    DeleteRoadSpike = {
        Location = require(game:GetService("ReplicatedStorage").Game.Item.RoadSpike).SetupGui,
        ProtoIndex = 1,
        UpvalueIndex = 1,
    },
    GetGun = {
        Location = require(game:GetService("ReplicatedStorage").Game.GunShop.GunShopUI).displayList,
        ProtoIndex = 1,
        Modify = function(Function)
            debug.setupvalue(Function, 1, {
                hasItemName = function(...)
                    return false;
                end
            })
            debug.setupvalue(Function, 4, {
                doesPlayerOwn = function(...)
                    return true
                end
            })
        end,
        UpvalueIndex = 3,
    },
    SwitchTeam = {
        Location = require(game:GetService("ReplicatedStorage").Game.TeamChooseUI).Show,
        ProtoIndex = 6,
        UpvalueIndex = 2,
    },
}

FindingMethod = {
    HookFireServer = function(Function, UpvalueIndex, MapData, MapIndex)
        local Old = debug.getupvalue(Function, UpvalueIndex);

        debug.setupvalue(Function, UpvalueIndex, {
            FireServer = function(self, Key, ...)
                debug.setupvalue(Function, UpvalueIndex, Old);

                if (MapData.Fix) then
                    MapData.Fix(Function);
                end

                Hashes[MapIndex] = Key;
            end
        })
    end,
    Call = function(Function, MapData)
        if (MapData.Arguments) then
            Function(unpack(MapData.Arguments));
        else
            Function();
        end
    end,
    FindCustomMethods = function(MapData, ...)
        for Index, Value in pairs (MapData) do
            if (type(Value) == 'function' and Index ~= 'Location') then
                Value(...);
            end
        end
    end,
    MatchConstants = function(FConstants, RequiredConstants)
        local Success = true;
        for Index, Value in pairs (RequiredConstants) do
            if (not table.find(FConstants, Value)) then
                Success = false;
            end
        end

        return Success;
    end,
    UpvalueScan = function(Function, MapData, MapIndex)
        local UpvalueIndex = MapData.UpvalueIndex or 1;

        for Index, Value in pairs (debug.getupvalues(Function)) do
            if (type(Value) == 'table' and rawget(Value, 'FireServer')) then
                UpvalueIndex = Index;
            end
        end

        FindingMethod.HookFireServer(Function, UpvalueIndex, MapData, MapIndex);
        FindingMethod.Call(Function, MapData);
    end
}

-- For located functions.
for Index, Value in pairs (Maps) do
    local LocatedFunction = Value.Location;
    if (LocatedFunction) then
        if (Value.ProtoIndex and Value.UpvalueIndex) then
            local Function = debug.getproto(LocatedFunction, Value.ProtoIndex);
            FindingMethod.FindCustomMethods(Value, Function);
            
            FindingMethod.HookFireServer(Function, Value.UpvalueIndex, Value, Index);
            FindingMethod.Call(Function, Value);
        end
        if (not Value.ProtoIndex and not Value.UpvalueIndex) then
            FindingMethod.FindCustomMethods(Value, LocatedFunction);
        end
    end
end

-- For not located functions.
for Index, Value in pairs (getgc()) do
    if (type(Value) == 'function' and getfenv(Value).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        local Cons = debug.getconstants(Value);

        for Index2, Value2 in pairs (Maps) do
            if (not Value2.Location) then
                local isMatched = FindingMethod.MatchConstants(Cons, Value2.Constants);

                if (isMatched) then
                    if (Value2.ProtoIndex and Value2.UpvalueIndex) then
                        if (Value2.NeedRepeat) then
                            -- todo: implements
                        else
                            local Function = debug.getproto(Value, Value2.ProtoIndex);
                            FindingMethod.HookFireServer(Function, Value2.UpvalueIndex, Value2, Index2);
                            FindingMethod.Call(Function, Value2);
                        end
                    end

                    if (not Value2.ProtoIndex and Value2.UpvalueIndex) then
                        if (Value2.isFunction and not Value2.noScan) then
                            local Upvalue = debug.getupvalue(Value, Value2.UpvalueIndex);
                            print(Index2)
                            FindingMethod.UpvalueScan(Upvalue, Value2, Index2);
                        end
                        if (Value2.isFunction and Value2.noScan) then
                            Hashes[Index2] = Value;
                        end
                    end

                    if (not Value2.ProtoIndex and not Value2.UpvalueIndex) then
                        if (Value2.isFunction) then
                            Hashes[Index2] = Value;
                        else
                            FindingMethod.UpvalueScan(Value, Value2, Index2);
                        end
                    end
                end
            end
        end
    end
end

table.foreach(Hashes, warn)