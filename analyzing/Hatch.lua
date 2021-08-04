local hash = nil;

function getNetwork()
    for i,v in pairs (getgc(true)) do
        if (type(v) == 'table' and rawget(v, 'FireServer')) then
            return v;
        end
    end
end

for i,v in pairs (getgc(true)) do
    if (type(v) == 'function' and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);

        if (table.find(cons, 'FindFirstChild') and table.find(cons, 'SewerHatch') and table.find(cons, 'Add')) then
            local Proto = debug.getproto(v, 1);
            local con = debug.getconstants(Proto);

            hash = con[1];
        end
    end
end


getNetwork():FireServer(hash, 'SewerHatch', game:GetService("Workspace").EscapeRoutes.SewerHatches.StuckInPrisonTutorialHatch1.SewerHatch);