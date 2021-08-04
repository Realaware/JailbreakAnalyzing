local func = require(game:GetService("ReplicatedStorage").Game.Item.Donut).InputBegan;
local proto = debug.getproto(func, 1);
local upv = debug.getupvalue(proto, 1);

print(type(upv))