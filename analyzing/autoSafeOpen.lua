local module = require(game:GetService("ReplicatedStorage").Game.SafesUI);
local skipButton = game:GetService("Players").LocalPlayer.PlayerGui.SafesGui.ContainerSlider.ContainerSkip; 
local list = module.ListSafes;

if (not firesignal) then return end;

local cons = debug.getconstants(module.SetupUseSafes);
local hash = nil;

local Index = table.find(cons, 'Inner');
hash = cons[Index + 1];

local net

for i,v in pairs(getgc(true)) do
    if (type(v) == 'table' and rawget(v, 'FireServer')) then
        net = v;
    end
end

for i,v in pairs (list) do
    net:FireServer(hash, v);
    wait();
    firesignal(skipButton.MouseButton1Down, true);
    wait(1);
end