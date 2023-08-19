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
    print(("Package %s Installed"):format(filename))

end
local function dim(repo,name)
    if not fs.exists("/ccpac/dim.lua") then
        print(("Package dim missing...\n\tDownloading..."):format(name))
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
    print(("Package %s Downloaded"):format(name))
    local Dim = require ".ccpac.dim"
    local Dd = Dim.file:new("/ccpac/tmp.dim")
    if not fs.exists("/ccpac/"..name) then
        fs.makeDir("/ccpac/"..name)
    end
    Dd:save("/ccpac/"..name,2)
    fs.delete("/ccpac/tmp.dim")
    print(("Package %s Installed"):format(name))

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
        print(("Package %s does not exist"):format(pkg))
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
    elseif args[1] == "remove" then
        local pkg = args[2]
        local packages = require ".ccpac.CraftOS"
        if packages[pkg] then
            local p = packages[pkg]
            if p.pt == "file" then
                if fs.exists("/ccpac/"..p.filename) then
                    fs.delete("/ccpac/"..p.filename)
                else
                    print(("Package %s is not installed"):format(pkg))
                end
            elseif p.pt == "dim" then
                if fs.exists("/ccpac/"..pkg) then
                    fs.delete("/ccpac/"..pkg)
                else
                    print(("Package %s is not installed"):format(pkg))
                end
            end
        else
            print(("Package %s does not exist"):format(pkg))
        end
    end
end
