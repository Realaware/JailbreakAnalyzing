local func = require(game:GetService("ReplicatedStorage").Game.TeamChooseUI).Show;

local proto = debug.getproto(func, 6);
local old = debug.getupvalue(proto, 2);

debug.setupvalue(proto, 2, {
    FireServer = function(self, Key, ...)
        debug.setupvalue(proto, 2, old);

        print(Key);
    end
});

proto();