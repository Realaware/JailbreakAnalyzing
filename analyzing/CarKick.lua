for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);

        if (table.find(cons, 'Eject') and table.find(cons, 'GetChildren')) then
            local proto = debug.getproto(v, 1);
            local old = debug.getupvalue(proto, 1);
            
            debug.setupvalue(proto, 1, {
                FireServer = function(self, Key, ...)
                    debug.setupvalue(proto, 1, old);

                    print(Key);
                end
            });
            proto() -- hash
        end
    end
end