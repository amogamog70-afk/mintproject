local fs = require('@lune/fs')
local luau = require('@lune/luau')
local roblox = require('@lune/roblox')
local serde = require('@lune/serde')
local root = ''
local disk = {}
local Library = {Theme = {}, ThemeAlpha = {}}
local Http = {
    JSONEncode = function(_, value) return serde.encode('json', value) end,
    JSONDecode = function(_, value) return serde.decode('json', value) end,
}
function Library:BuildFolders() end
function Library:Repaint() end
function Library:SetColor(key, value, alpha) self.Theme[key] = value self.ThemeAlpha[key] = alpha end
Library.FileSystem = {
    Read = function(_, path) return disk[path] end,
    Write = function(_, path, value) disk[path] = value end,
}
-- Roblox accepts fractional RGB channels; Lune's native fromRGB requires u8s.
local colors = setmetatable({fromRGB = function(r,g,b) return roblox.Color3.new(r/255,g/255,b/255) end}, {__index = roblox.Color3})
local env = {Color3 = colors, game = {GetService = function(_, name) assert(name == 'HttpService') return Http end}}
local makeManager = luau.load(fs.readFile(root .. 'library/addons/ThemeManager.luau'), {environment = env})()
local manager = makeManager(Library)
manager:SetFolder('MintProject/Facility')
local mint = roblox.Color3.fromRGB(107,230,180)
manager.Presets.mint = {Bg = roblox.Color3.fromRGB(9,14,12), Accent = mint}
assert(manager:Apply('mint'))
assert(not manager:Load() and Library.Theme.Accent == mint, 'First run must retain the Mint default')
disk['Facility/settings/theme.json'] = Http:JSONEncode({Preset = 'rose', Colors = {Accent = '#FF0000FF'}})
assert(not manager:Load() and Library.Theme.Accent == mint, 'Unrelated Facility save must not override MintProject')
manager:SetAccent(roblox.Color3.fromRGB(140,190,255))
Library:SetColor('Window', roblox.Color3.fromRGB(18,19,30), 0.75)
assert(manager:Save())
manager:Apply('mint')
assert(Library.Theme.Accent == mint)
assert(manager:Load())
assert(Library.Theme.Accent == roblox.Color3.fromRGB(140,190,255), 'Saved custom accent must be restored')
assert(Library.Theme.Window == roblox.Color3.fromRGB(18,19,30), 'Saved custom background must be restored')
assert(math.abs(Library.ThemeAlpha.Window - 191/255) < 0.001, 'Saved alpha must be restored')
local entry = fs.readFile(root .. 'MintProject.lua')
local loadIndex = assert(entry:find('ThemeManager:Load()', 1, true))
local windowIndex = assert(entry:find('local Window = Library:Window({', 1, true))
assert(loadIndex < windowIndex and entry:find('ThemeFolder = THEME_FOLDER', 1, true), 'Restore before building the window, with one theme folder')
print('PASS: first-run Mint, unrelated-folder isolation, custom colors/alpha roundtrip and startup order')
