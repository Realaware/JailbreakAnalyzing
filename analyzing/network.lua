local net

for i,v in pairs(getgc(true)) do
    if (type(v) == 'table' and rawget(v, 'FireServer')) then
        net = v;
    end
end