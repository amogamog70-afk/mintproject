-- Headless contract tests. Native Lune Roblox instances validate UI property types;
-- signals and input are simulated. This does not replace a rendered Roblox test.
local fs = require('@lune/fs')
local luau = require('@lune/luau')
local roblox = require('@lune/roblox')
local serde = require('@lune/serde')
local checks, connections, all, delayed = 0, {}, {}, {}
local function check(value, message)
    assert(value, message)
    checks += 1
end
local function signal()
    local listeners = {}
    return {
        Connect = function(_, callback)
            local connection = { Connected = true }
            function connection:Disconnect()
                self.Connected = false
            end
            table.insert(listeners, { connection, callback })
            table.insert(connections, connection)
            return connection
        end,
        Fire = function(_, ...)
            for _, item in ipairs(table.clone(listeners)) do
                if item[1].Connected then
                    item[2](...)
                end
            end
        end,
    }
end
local methods = {}
local events = { InputBegan = true, Activated = true, FocusLost = true }
local function instance(class)
    local object = { _native = roblox.Instance.new(class), _signals = {}, _children = {} }
    setmetatable(object, {
        __index = function(self, key)
            if methods[key] then
                return methods[key]
            end
            if events[key] then
                self._signals[key] = self._signals[key] or signal()
                return self._signals[key]
            end
            if key == 'Parent' then
                return rawget(self, '_parent')
            end
            if key == 'AbsoluteSize' then
                if class == 'ScreenGui' or class == 'PlayerGui' then
                    return roblox.Vector2.new(1280, 720)
                end
                local size = self._native.Size
                local p = self.Parent and self.Parent.AbsoluteSize or roblox.Vector2.new(1280, 720)
                return roblox.Vector2.new(
                    p.X * size.X.Scale + size.X.Offset,
                    p.Y * size.Y.Scale + size.Y.Offset
                )
            end
            if key == 'AbsolutePosition' then
                if class == 'ScreenGui' or class == 'PlayerGui' then
                    return roblox.Vector2.zero
                end
                local p = self.Parent and self.Parent.AbsolutePosition or roblox.Vector2.zero
                local ps = self.Parent and self.Parent.AbsoluteSize or roblox.Vector2.new(1280, 720)
                local s, anchor = self._native.Position, self._native.AnchorPoint
                return p
                    + roblox.Vector2.new(ps.X * s.X.Scale + s.X.Offset, ps.Y * s.Y.Scale + s.Y.Offset)
                    - self.AbsoluteSize * anchor
            end
            return self._native[key]
        end,
        __newindex = function(self, key, value)
            if key == 'Parent' then
                local old = self.Parent
                if old then
                    local i = table.find(old._children, self)
                    if i then
                        table.remove(old._children, i)
                    end
                end
                rawset(self, '_parent', value)
                if value then
                    table.insert(value._children, self)
                end
                self._native.Parent = value and value._native or nil
            else
                self._native[key] = value
            end
            if self._signals[key] then
                self._signals[key]:Fire()
            end
        end,
    })
    table.insert(all, object)
    return object
end
function methods:IsA(class)
    return self._native:IsA(class)
end
function methods:GetPropertyChangedSignal(property)
    self._signals[property] = self._signals[property] or signal()
    return self._signals[property]
end
function methods:Destroy()
    for _, child in ipairs(table.clone(self._children)) do
        child:Destroy()
    end
    self.Parent = nil
end
local function flush()
    local tasks = delayed
    delayed = {}
    for _, callback in ipairs(tasks) do
        callback()
    end
end
local input = { InputBegan = signal(), InputChanged = signal(), InputEnded = signal() }
function input:GetFocusedTextBox()
    return self.Focused
end
local services = {
    UserInputService = input,
    TweenService = {
        Create = function(_, node, _, props)
            return {
                Play = function()
                    for k, v in pairs(props) do
                        node[k] = v
                    end
                end,
            }
        end,
    },
    HttpService = {
        JSONEncode = function(_, value)
            return serde.encode('json', value)
        end,
        JSONDecode = function(_, value)
            return serde.decode('json', value)
        end,
    },
    Players = {},
}
local environment = {
    game = {
        GetService = function(_, name)
            return assert(services[name], name)
        end,
    },
    workspace = { CurrentCamera = { ViewportSize = roblox.Vector2.new(1280, 720) } },
    Instance = { new = instance },
    task = {
        delay = function(_, callback)
            table.insert(delayed, callback)
        end,
    },
    TweenInfo = {
        new = function(...)
            return { ... }
        end,
    },
    _G = {},
}
for _, name in ipairs({
    'Color3',
    'Vector2',
    'Vector3',
    'UDim',
    'UDim2',
    'Enum',
    'NumberSequence',
    'NumberSequenceKeypoint',
    'ColorSequence',
    'ColorSequenceKeypoint',
}) do
    environment[name] = roblox[name]
end
local function load(source)
    -- Lune's reflection database calls Roblox's KeyCode.Unknown (value 0) None.
    -- Only the headless test loader translates that alias; distributed files do not.
    source = source:gsub('Enum.KeyCode.Unknown', 'Enum.KeyCode.None')
    return luau.load(source, { environment = environment })()
end

for _, file in ipairs({
    'src/Core.luau',
    'src/Window.luau',
    'src/Components.luau',
    'src/init.luau',
    'examples/Demo.luau',
    'examples/Studio.client.luau',
    'dist/MintProject.lua',
    'dist/Demo.lua',
}) do
    luau.compile(fs.readFile(file))
    checks += 1
end
local library = load(fs.readFile('dist/MintProject.lua'))
local window = library:CreateWindow({ Parent = instance('PlayerGui'), Title = 'Contract test' })
local section = window:Tab('Test'):Section('Controls')
library:RegisterComponent('Badge', function(ctx, owner, options)
    return ctx:Text(options.Text, owner.Body)
end)
check(
    section:Badge({ Text = 'Extended' }).Text == 'Extended',
    'Custom components receive the correct section'
)
check(not pcall(function()
    library:RegisterComponent('Slider', function() end)
end), 'Built-in names are reserved')
local calls = 0
local toggle = section:Toggle({
    Id = 'toggle',
    Default = true,
    Callback = function()
        calls += 1
    end,
})
local slider = section:Slider({ Id = 'slider', Min = 10, Max = 30, Step = 2, Default = 15 })
local range = section:RangeSlider({ Id = 'range', Min = 0, Max = 100, Default = { 20, 80 } })
local multi = section:Dropdown({
    Id = 'multi',
    Text = 'Multi',
    Multi = true,
    Options = { 'A', 'B', 'C' },
    Default = { 'B' },
})
local text = section:Textbox({ Id = 'text', Default = 'Mint' })
local color =
    section:ColorPicker({ Id = 'color', Text = 'Accent', Default = roblox.Color3.fromRGB(10, 20, 30) })
local pressed = 0
local key = section:Keybind({
    Id = 'key',
    Default = roblox.Enum.KeyCode.F6,
    OnPress = function()
        pressed += 1
    end,
})
check(calls == 0, 'Defaults must not invoke callbacks')
check(slider:Get() == 16, 'Stepped default rounds relative to Min')
check(slider:Set(100) and slider:Get() == 30, 'Slider clamps at upper bound')
check(
    not slider:Set(0 / 0) and not slider:Set(math.huge) and not slider:Set('oops'),
    'Slider rejects invalid values'
)
check(range:Set({ 90, 10 }) and range:Get()[1] == 10 and range:Get()[2] == 90, 'Range normalization')
check(not range:Set({ 1, 'bad' }), 'Range rejects malformed input')
check(
    multi:Set({ 'C', 'C', 'A' }) and table.concat(multi:Get(), ',') == 'A,C',
    'Multiselect deduplicates and preserves option order'
)
check(not multi:Set({ 'Unknown' }), 'Unknown option is rejected')
local values = multi:Get()
values[1] = 'B'
check(multi:Get()[1] == 'A', 'Get returns a copy')
toggle:Set(false)
check(calls == 1, 'Callback runs on a state change')
toggle:Set(false)
check(calls == 1, 'Identical toggle state does not retrigger')
check(not pcall(function()
    section:Toggle({ Id = 'toggle' })
end), 'Duplicate Id is rejected')
local json = window:SaveProfile('Saved')
slider:Set(12)
text:Set('Changed')
color:Set(roblox.Color3.new(1, 0, 0))
local restored, restoreError = window:LoadProfile('Saved')
check(
    restored == true and slider:Get() == 30 and text:Get() == 'Mint',
    'Profile roundtrip: ' .. tostring(restoreError)
)
check(color:Get() == roblox.Color3.fromRGB(10, 20, 30), 'Color survives JSON roundtrip')
check(not window:ImportConfig('broken'), 'Malformed JSON rejected')
check(not window:ImportConfig('{"version":2,"values":{}}'), 'Unsupported schema rejected')
check(not window:LoadProfile('Missing'), 'Missing profile is reported')
local keyboard = { UserInputType = roblox.Enum.UserInputType.Keyboard, KeyCode = roblox.Enum.KeyCode.F6 }
input.InputBegan:Fire(keyboard, false)
check(pressed == 1, 'Keybind activation')
input.Focused = true
input.InputBegan:Fire(keyboard, false)
input.Focused = nil
check(pressed == 1, 'Typing blocks keybind activation')
local function findButton(label)
    for _, node in ipairs(all) do
        if node:IsA('TextButton') and node.Text == label and node.Parent then
            return node
        end
    end
    error('Button not found: ' .. label)
end
local dropdownButton = findButton('A, C  ▾')
dropdownButton.Activated:Fire()
check(window.Context.Popup ~= nil, 'Dropdown opens')
findButton('Select all').Activated:Fire()
check(#multi:Get() == 3, 'Select all')
findButton('Clear').Activated:Fire()
check(#multi:Get() == 0, 'Clear selection')
window.Context:ClosePopup()
for _, node in ipairs(all) do
    if node:IsA('TextLabel') and node.Text == 'Accent' and node.Parent then
        for _, child in ipairs(node.Parent._children) do
            if child:IsA('TextButton') then
                child.Activated:Fire()
                break
            end
        end
        break
    end
end
check(window.Context.Popup ~= nil, 'Color picker opens without runtime errors')
local hexBox
for _, node in ipairs(all) do
    if node:IsA('TextBox') and node.Parent == window.Context.Popup then
        hexBox = node
    end
end
check(hexBox ~= nil, 'Color picker exposes hex input')
hexBox.Text = '#00FF00'
hexBox.FocusLost:Fire()
check(color:Get() == roblox.Color3.new(0, 1, 0), 'Hex input changes color')
window.Context:ClosePopup()
findButton('F6').Activated:Fire()
input.InputBegan:Fire(
    { UserInputType = roblox.Enum.UserInputType.Keyboard, KeyCode = roblox.Enum.KeyCode.F7 },
    false
)
check(
    key:Get() == roblox.Enum.KeyCode.F7 and pressed == 1,
    'Captured key is assigned without firing its action'
)
window:SetVisible(false)
flush()
check(not window.Root.Visible and not window.Context.Popup, 'Hide closes popup')
window:SetVisible(true)
flush()
check(window.Root.Visible, 'Menu reopens')
window:SetVisible(false)
window:SetVisible(true)
flush()
check(window.Root.Visible, 'Latest visibility wins during fade')
section:SetExpanded(false)
check(not section.Body.Visible and slider:Get() == 30, 'Collapse preserves control values')
window:Notify('Test')
flush()
window:SetTheme({ Accent = roblox.Color3.new(1, 0, 0) })
check(window.Context.Theme.Accent.R == 1, 'Theme can change after construction')
local gui = window.Context.Gui
library:Destroy()
flush()
check(not gui.Parent, 'Destroy removes GUI')
for _, connection in ipairs(connections) do
    check(not connection.Connected, 'Destroy disconnects global and component events')
end
services.Players.LocalPlayer = {
    WaitForChild = function()
        return instance('PlayerGui')
    end,
}
local demo = load(fs.readFile('dist/Demo.lua'))
check(#demo.Tabs == 4, 'Standalone demo creates four tabs')
demo:Destroy()
flush()
print(
    'PASS: '
        .. checks
        .. ' checks; headless property, state, profile and lifecycle tests. Rendered Roblox QA pending.'
)
