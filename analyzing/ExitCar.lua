for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);

        if (table.find(cons, 'OnVehicleJumpExited') and table.find(cons, 'LastVehicleExit') and table.find(cons, 'FireServer')) then
            local upv = debug.getupvalues(v);
            local _old = debug.getupvalue(v, 1);

            debug.setupvalue(v, 1, {});

            table.foreach(upv, function(idx, value)
                if (type(value) == 'table' and rawget(value, 'FireServer')) then
                    local old = debug.getupvalue(v, idx);
                    debug.setupvalue(v, idx, {
                        FireServer = function(self, Key, ...)
                            debug.setupvalue(v, idx, old);

                            print(Key);
                        end
                    })

                    v();
                end
            end)
            debug.setupvalue(v, 1, _old);
        end
    end
end