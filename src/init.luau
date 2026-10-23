local Window = require(script.Window)
local Components = require(script.Components)
local MintProject = { Version = '0.1.0-preview', Windows = {}, Profiles = {} }

function MintProject:RegisterComponent(name, builder)
    Components.register(name, builder)
end

function MintProject:CreateWindow(options)
    local window = Window.new(options, self.Profiles)
    table.insert(self.Windows, window)
    return window
end

function MintProject:Destroy()
    for _, window in ipairs(self.Windows) do
        window:Destroy()
    end
    table.clear(self.Windows)
end

return MintProject
