local module = require(game:GetService("ReplicatedStorage").Module.UI).CircleAction;
table.foreach(module.Specs, function(i,v)
    v.Duration = 0;
end)