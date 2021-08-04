local module = require(game:GetService("ReplicatedStorage").Game.Item.RoadSpike);
local a = module.SetupGui;
local b = debug.getproto(a, 1);
local c = debug.getupvalue(b, 1);
debug.setupvalue(b, 1, {
    FireServer = function(self, key, ...)
        debug.setupvalue(b, 1, c);
        print(key);
    end
})
b()