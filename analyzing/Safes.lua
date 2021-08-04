local module = require(game:GetService("ReplicatedStorage").Game.SafesUI).SetupUseSafes;

local cons = debug.getconstants(module);
local openHash = nil;

local Index = table.find(cons, 'Inner');
openHash = cons[Index + 1];
