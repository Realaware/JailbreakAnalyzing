for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);

        if (table.find(cons, 'InjanHorn') and table.find(cons, 'Passenger')) then
            local upv = debug.getupvalue(v, 5);
            local hash = debug.getconstant(upv, 6);
        end
    end
end