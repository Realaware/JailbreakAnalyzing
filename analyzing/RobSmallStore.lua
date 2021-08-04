for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);

        if (table.find(cons, 'Rob') and table.find(cons, 'Duration')) then
            local upv = debug.getupvalue(v, 1);
            local old = debug.getupvalue(upv, 1)
            debug.setupvalue(upv, 1, {
                FireServer = function(self, key, ...)
                    debug.setupvalue(upv, 1, old);
                    print(key);
                end
            })
            upv({}, true)
        end
    end
end