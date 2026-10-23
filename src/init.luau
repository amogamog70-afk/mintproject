local Window = require(script.Window)
local Components = require(script.Components)
local Core = require(script.Core)
local ThemeManager = require(script.ThemeManager)
local SaveManager = require(script.SaveManager)
local Http = game:GetService('HttpService')
local MintProject = {
    Version = '0.4.0',
    Windows = {},
    Profiles = {},
    Toggles = {},
    Options = {},
    DefaultTheme = table.clone(Core.Theme),
    Theme = table.clone(Core.Theme),
}
MintProject.ThemeManager = ThemeManager.new(MintProject)
MintProject.SaveManager = SaveManager.new(MintProject)

function MintProject:RegisterComponent(name, builder)
    Components.register(name, builder)
end

function MintProject:CreateWindow(options)
    options = table.clone(options or {})
    options._Library = self
    options.Theme = options.Theme or self.Theme
    local window = Window.new(options, self.Profiles)
    table.insert(self.Windows, window)
    return window
end

function MintProject:SetTheme(patch)
    for role, color in pairs(patch) do
        if self.Theme[role] and typeof(color) == 'Color3' then
            self.Theme[role] = color
        end
    end
    for _, window in ipairs(self.Windows) do
        if not window.Context.Destroyed then
            window:SetTheme(patch)
        end
    end
end
function MintProject:Notify(text, duration)
    for _, window in ipairs(self.Windows) do
        if not window.Context.Destroyed then
            window:Notify(text, duration)
            return
        end
    end
end
function MintProject:ExportConfig(ignore)
    local values = {}
    for _, window in ipairs(self.Windows) do
        if not window.Context.Destroyed then
            local data = Http:JSONDecode(window:ExportConfig(ignore))
            for id, value in pairs(data.values) do
                values[id] = value
            end
        end
    end
    return Http:JSONEncode({ version = 1, values = values })
end
function MintProject:ImportConfig(json)
    local failures = {}
    for _, window in ipairs(self.Windows) do
        if not window.Context.Destroyed then
            local ok, err = window:ImportConfig(json)
            if not ok then
                table.insert(failures, err)
            end
        end
    end
    return #failures == 0, table.concat(failures, ', ')
end

function MintProject:Destroy()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    table.clear(self.Windows)
end

MintProject.Unload = MintProject.Destroy
return MintProject
