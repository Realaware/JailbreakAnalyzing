for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);
        
        if (table.find(cons, 'Play') and table.find(cons, 'Punch')) then
            local upv = debug.getupvalues(v);

            for idx, value in pairs (upv) do
                if (type(value) == 'table' and rawget(value, 'FireServer')) then
                    local old = debug.getupvalue(v, idx);

                    debug.setupvalue(v, idx, {
                        FireServer = function(self, Key, ...)
                            debug.setupvalue(v, idx, old);

                            print(Key);
                        end
                    })
                    -- why should we do like this is that a function which contains punch func require those arguments.
                    v({ Name = 'Punch' }, true);
                end
            end
        end
    end
end