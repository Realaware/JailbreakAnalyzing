for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);
        if (table.find(cons, 'ShouldEject') and table.find(cons, 'Vehicle')) then
            local upvalue = debug.getupvalues(v)[1];
            local upvalues = debug.getupvalues(upvalue);
            
            table.foreach(upvalues, function(index, value)
                local old = debug.getupvalue(upvalue, index);

                debug.setupvalue(upvalue, 1, {
                    FireServer = function(self, Key, ...)
                        debug.setupvalue(upvalue, 1, old);
    
                        print(Key);
                    end
                });
                upvalue()
            end)
        end
    end
end