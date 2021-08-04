for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);

        if (table.find(cons, 'ShouldEject') and table.find(cons, 'Vehicle') and table.find(cons, 'ShouldHotwire')) then
            local func = debug.getupvalue(v, 3);
            
            for idx, value in pairs (debug.getupvalues(func)) do
                if (type(value) == 'table' and rawget(value, 'FireServer')) then
                    local old = debug.getupvalue(func, idx);

                    debug.setupvalue(func, idx, {
                        FireServer = function(self, Key, ...)
                            debug.setupvalue(func, idx, old);

                            print(Key)
                        end
                    })
                    func({});
                end
            end
        end
    end
end