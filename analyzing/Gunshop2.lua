-- i just need new workspace.
local module = require(game:GetService("ReplicatedStorage").Game.GunShop.GunShopUI);
local a = module.displayList;
local b = debug.getproto(a, 1);
local c = debug.getupvalue(b, 3);
local d = debug.getupvalue(b, 1);
local e = debug.getupvalue(b, 4);
debug.setupvalue(b, 1, {
    hasItemName = function(...)
        return false;
    end
})
debug.setupvalue(b, 4, {
    doesPlayerOwn = function(...)
 
        return true
    end
})
debug.setupvalue(b, 3, {
    FireServer = function(self, key, ...)
        debug.setupvalue(b, 3, c);
        print(key);
    end
})
b()
