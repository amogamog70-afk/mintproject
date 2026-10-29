local url="https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/neverlose-cs2/dist/main.luau"
local ok,source=pcall(function()return game:HttpGet(url)end)
assert(ok and type(source)=="string"and #source>1000,"MintProject: failed to download the menu from GitHub")
local run,err=loadstring(source,"MintProject GitHub")
assert(run,err)
local app=run()
app.SourceURL=url
return app
