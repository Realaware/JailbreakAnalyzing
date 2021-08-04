
for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);
        if (table.find(cons, 'NitroLoop') and table.find(cons, 'Nitro1')) then
            debug.getupvalue(v, 8).Nitro = 250;
        end
    end
end