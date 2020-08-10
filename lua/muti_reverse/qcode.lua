local function quick_code(text)
    local str=""
    local tab= text:split()
    tab:sort( function(v1,v2) return   v1:len() < v2:len()  end )
    --tab:each(print)
    local len_min=100
    for i,elm in ipairs(tab) do
        if  len_min  > #elm  then  len_min = #elm end
        --and len_min   or #elm if #elm > len_min then
        if  len_min < #elm then
            break
        end
        str= str .." ".. elm
    end
    return str,text
end
return quick_code
