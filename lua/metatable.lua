
function metatable(...)
	if ... and type(...) == "table" then 
        return setmetatable( ... , {__index=table})
	else 
        return setmetatable( {...} , {__index=table})
	end 
end 

table.eachi=function(tab,func)
	for i=1,#tab   do
		func(tab[i],i)
	end
	return tab
end
table.eacha=function(tab,func)
	for i,v in ipairs(tab) do
		func(v,i)
	end 
	return tab
end 
table.each=function(tab,func)
	for k,v in pairs(tab) do
		func(v,k)
	end
	return tab
end
table.reduce=function(tab,func,arg)
	local new,old=arg,arg
	for i,v in ipairs(tab) do
		new,old= func(v,new)
	end
	return new ,arg
end 
table.map=function(tab,func)
	local newtab=setmetatable({} , {__index=table}) 
	func= func or function(v) return v end 
	for i,v in ipairs(tab) do
		newtab[i]= func(v)
	end 
	return newtab
end 



setmetatable(string,{__index=table})

function string:filter(func,...)
	return func( self, ... )
end 


function string.split( str, sp,sp1)
	if   type(sp) == "string"  then     
		if sp:len() == 0 then
			sp= "([%z\1-\127\194-\244][\128-\191]*)"
		elseif sp:len() > 1 then 
			sp1= sp1 or "^"
			_,str= pcall(string.gsub,str ,sp,sp1)
			sp=  "[^".. sp1.. "]*"

		else 
			if sp =="%" then 
				sp= "%%"
			end 
			sp=  "[^" .. sp  .. "]*"
		end 
	else 
		sp= "[^" .. " " .."]+"
	end

	local tab= setmetatable( {} , {__index=table} )
	flag,res= pcall( string.gmatch,str,sp)
	for  v  in res   do
		tab:insert(v)
	end 
	return tab 
end 

