local module = require(game:GetService("ReplicatedStorage").Game.PlayerUtils);

local old = module.isPointInTag;

module.isPointInTag = function(...)
    local arg = {...};

    if (table.find(arg, 'NoFallDamage')) then
        return true
    else
        return old(...);
    end
end