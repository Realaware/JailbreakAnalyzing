local DoorFunc = nil;
local doors = {};

for i,v in pairs (getgc(true)) do
    if (type(v) == 'function' and getfenv(v).script == game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript) then
        local cons = debug.getconstants(v);
        if (table.find(cons, 'SequenceRequireState')) then
            DoorFunc = v;
        end
    elseif (type(v) == 'table' and rawget(v, 'OpenFun') and rawget(v, 'State')) then
        table.insert(doors, v);
    end
end



table.foreach(doors, function(_, v)
    v.Settings.Team = true;
    DoorFunc(v);
end);