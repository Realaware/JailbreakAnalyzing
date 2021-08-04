for i,v in pairs (getgc(true)) do
    if (type(v) == 'table' and rawget(v, 'Ragdoll')) then
        v.Ragdoll = function(...)
            return wait(9e9)
        end
    end
end