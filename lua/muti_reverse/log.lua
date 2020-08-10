
local function  writefile(file,str )
    local fp=io.open(file,"a")
	io.output(fp)
	fp:write(str,"\n")
	fp:close()
end 
local function getfilename(str)
   return  os.getenv("TMP") .. "/librime-lua_" .. tostring(str)  .. os.date("_%Y%m%d.log") 
end    
	

local  log={}
function log.info(str)
   local filename=getfilename("info")
   local msg= string.format("I%s: %s" , os.date("%Y%m%d %H%M%S"), tostring(str) )
   writefile(filename,msg)   
end
function log.warning(str)
   local filename=getfilename("warning")
   local msg= string.format("W%s: %s" , os.date("%Y%m%d %H%M%S"), tostring(str) )
   writefile(filename,msg)
end
function log.error(str)
   local filename=getfilename("error")
   local msg= string.format("E%s: %s" , os.date("%Y%m%d %H%M%S"), tostring(str) )
   writefile(filename,msg)
end 



return log 
