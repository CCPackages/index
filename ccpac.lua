local args = {...}
local function file(repo,filename)
    local request = http.get("https://raw.githubusercontent.com/"..repo)
    local f,e = fs.open("/ccpac/"..filename,"w")
    if f == nil then
        printError(e)
        return
    end
    f.write(request.readAll())
    f.close()
    print(("\x1B[92mPackage %s Installed"):format(filename))

end
local function dim(repo,name)
    if not fs.exists("/ccpac/dim.lua") then
        print(("\x1B[31mPackage dim missing...\n\tDownloading..."):format(name))
        local packages = require ".ccpac.CraftOS"
        local P = packages.dim
        local Repo = P.loc:format("main")
        file(Repo,P.filename)
    end
    local request = http.get("https://raw.githubusercontent.com/"..repo)
    local f,e = fs.open("/ccpac/tmp.dim","w")
    if f == nil then
        printError(e)
        return
    end
    f.write(request.readAll())
    f.close()
    print(("\x1B[96mPackage %s Downloaded"):format(name))
    local Dim = require ".ccpac.dim"
    local Dd = Dim.file:new("/ccpac/tmp.dim")
    if not fs.exists("/ccpac/"..name) then
        fs.makeDir("/ccpac/"..name)
    end
    Dd:save("/ccpac/"..name,2)
    fs.delete("/ccpac/tmp.dim")
    print(("\x1B[92mPackage %s Installed"):format(name))

end
local function install(pkg,br)
    local packages = require ".ccpac.CraftOS"
    if packages[pkg] then
        local p = packages[pkg]
        if p.pt == "file" then
            local repo = p.loc:format(br)
            file(repo,p.filename)
        elseif p.pt == "dim" then
            local repo = p.loc:format(br)
            dim(repo,pkg)
        end
    else
        print(("\x1B[31mPackage %s does not exist"):format(pkg))
    end
end
if #args == 0 then
    print([[CCPac by Badgeminer2
    refresh                     | refreshes package table
    install <package> [branch]  | installs package
    remove <package>            | removes package]])
else
    if args[1] == "refresh" then
        local request = http.get("https://raw.githubusercontent.com/CCPackages/index/main/CraftOS.lua")
        local f,e = fs.open("/ccpac/CraftOS.lua","w")
        if f == nil then
            printError(e)
            return
        end
        f.write(request.readAll())
        f.close()
    elseif args[1] == "install" then
        local package = args[2]
        local branch = args[3] or "main"
        install(package,branch)
    end
end