local GetVehiclePacket;

for i,v in pairs (getgc()) do
    if (type(v) == 'function' and getfenv(v).script == game.Players.LocalPlayer.PlayerScripts.LocalScript) then
        if (debug.getinfo(v).name == 'GetVehiclePacket') then
            GetVehiclePacket = v;
        end
    end
end

table.foreach(GetVehiclePacket(), print)
