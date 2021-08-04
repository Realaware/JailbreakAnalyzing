for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);

        if (table.find(cons, 'ShouldEject') and table.find(cons, 'Vehicle')) then
            local upv = debug.getupvalue(v, 2);
            table.foreach(debug.getupvalues(upv), function(idx, value)
                if (type(value) == 'table' and rawget(value, 'FireServer')) then
                    local old = debug.getupvalue(upv, idx);

                    debug.setupvalue(upv, idx, {
                        FireServer = function(self, Key, ...)
                            debug.setupvalue(idx, idx, old);

                            print(Key);
                        end
                    })

                    upv();
                end
            end)
        end
    end
end