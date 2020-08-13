
local function  writefile(file,str )
	local fp=io.open(file,"a")
	io.output(fp)
	fp:write(str,"\n")
	fp:close()
end 
local function getfilename(str)
	local  tmp= os.getenv("TMP") or os.getenv("TEMP") or "c:/tmp"
	return  tmp .. "/librime-lua_" .. tostring(str)  .. os.date("_%Y%m%d.log") 
end    

local function init( orglog) 
	local log={ orglog=orglog    }

	function log.info(str)
		if log.orglog.info then  log.orglog.info(str) end 
		local filename=getfilename("info")
		local msg= string.format("I%s: %s" , os.date("%Y%m%d %H%M%S"), tostring(str) )
		writefile(filename,msg)   
	end
	function log.warning(str)
		if log.orglog.warning then  log.orglog.warning(str) end 
		local filename=getfilename("warning")
		local msg= string.format("W%s: %s" , os.date("%Y%m%d %H%M%S"), tostring(str) )
		writefile(filename,msg)
	end
	function log.error(str)
		if log.orglog.error then  log.orglog.error(str) end 
		local filename=getfilename("error")
		local msg= string.format("E%s: %s" , os.date("%Y%m%d %H%M%S"), tostring(str) )
		writefile(filename,msg)
	end 
	return log

end 

return init 

