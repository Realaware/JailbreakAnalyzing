-- explode wall, liftgate and sewerhatch
-- they use same hash
-- so process of finding it is same.

for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);

        if (table.find(cons, 'SewerHatch') and table.find(cons, 'Fun')) then
            local proto = debug.getproto(v, 1);
            local index = 1;
            local old = debug.getupvalue(proto, index);
            debug.setupvalue(proto, index, {
                FireServer = function(self, key, ...)
                    debug.setupvalue(proto, index, old);
                    print(key);
                end
            })

            proto(nil, true)
            
        end
    end
end