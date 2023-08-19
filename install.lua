if not fs.exists("/ccpac") then
    fs.makeDir("/ccpac")
end
local request = http.get("https://raw.githubusercontent.com/CCPackages/index/main/ccpac.lua")
local f,e = fs.open("/ccpac.lua","w")
if f == nil then
    printError(e)
    return
end
f.write(request.readAll())
f.close()
