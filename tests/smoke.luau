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
local events = { InputBegan = true, Activated = true, FocusLost = true, MouseEnter = true, MouseLeave = true }
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
function methods:GetChildren()
    return table.clone(self._children)
end
function methods:FindFirstChildWhichIsA(class)
    for _, child in ipairs(self._children) do
        if child:IsA(class) then
            return child
        end
    end
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
                Cancel = function() end,
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
    'src/Logo.luau',
    'src/Storage.luau',
    'src/ThemeManager.luau',
    'src/SaveManager.luau',
    'addons/ThemeManager.lua',
    'addons/SaveManager.lua',
    'Library.lua',
    'Example.lua',
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
local stableConnections = #window.Context.Connections
for i = 1, 12 do
    dropdownButton.Activated:Fire()
    window.Context:ClosePopup()
end
check(
    #window.Context.Connections == stableConnections,
    'Repeated dropdowns do not accumulate hover listeners'
)
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
local linked = section:AddToggle('linked', { Text = 'Linked', Default = true })
local linkedKey =
    linked:AddKeyPicker('linked.key', { Default = 'F9', Mode = 'Toggle', SyncToggleState = true })
check(
    library.Toggles.linked == linked and library.Options['linked.key'] == linkedKey,
    'Public control registries'
)
linkedKey:Activate(true)
check(not linked.Value, 'Keybind toggles its linked control')
linked:Set(true)
linkedKey:Activate(true)
check(not linked.Value, 'Mouse and keybind states stay synchronized')
local changeCount = 0
slider:OnChanged(function()
    changeCount += 1
end)
slider:SetValue(28)
check(changeCount == 1 and slider.Value == 28, 'OnChanged and SetValue aliases')
check(window.ColumnCount == 3, 'Wide desktop uses three columns')
local disk, folders = {}, {}
environment.readfile = function(path)
    assert(disk[path], 'Missing file')
    return disk[path]
end
environment.writefile = function(path, value)
    disk[path] = value
end
environment.isfile = function(path)
    return disk[path] ~= nil
end
environment.isfolder = function(path)
    return folders[path] == true
end
environment.makefolder = function(path)
    folders[path] = true
end
environment.listfiles = function(folder)
    local result = {}
    for path in pairs(disk) do
        if path:sub(1, #folder + 1) == folder .. '/' then
            table.insert(result, path)
        end
    end
    return result
end
environment.delfile = function(path)
    disk[path] = nil
end
local manager = load(fs.readFile('addons/SaveManager.lua')):SetLibrary(library)
check(manager.Storage.Persistent, 'File backend detection')
check(manager:Save('Default'), 'Config writes and verifies a local file')
slider:Set(10)
check(manager:Load('Default') and slider.Value == 28, 'Config restores state from file')
check(manager:SetAutoloadConfig('Default'), 'Autoload records selected config')
slider:Set(12)
local nextManager = load(fs.readFile('addons/SaveManager.lua')):SetLibrary(library)
check(nextManager:LoadAutoloadConfig() and slider.Value == 28, 'New manager restores config across sessions')
check(
    not manager:Save('../escape') and not manager:Load(nil),
    'Manager rejects invalid names without crashing'
)
local themeManager = load(fs.readFile('addons/ThemeManager.lua')):SetLibrary(library)
check(
    themeManager:ApplyTheme('Ice') and library.Theme.Accent == roblox.Color3.fromHex('82C7F0'),
    'Preset theme applies to the library'
)
check(themeManager:SaveCustomTheme('Custom'), 'Custom palette saves to file')
themeManager:ApplyTheme('Mint')
check(
    themeManager:ApplyTheme('Custom') and library.Theme.Accent == roblox.Color3.fromHex('82C7F0'),
    'Custom palette roundtrip'
)
check(not themeManager:SaveCustomTheme('Mint'), 'Built-in palettes cannot be overwritten')
local camera = environment.workspace.CurrentCamera
camera.ViewportSize = roblox.Vector2.new(390, 844)
local phoneWindow = library:CreateWindow({ Parent = instance('PlayerGui'), Touch = true })
local phoneTab = phoneWindow:AddTab('Phone')
local phoneGroup = phoneTab:AddRightGroupbox('Right')
check(
    phoneWindow.ColumnCount == 1 and phoneGroup.Root.Parent == phoneTab.Columns[1],
    'Phone stacks right groups into one column'
)
check(phoneWindow.Root.Size.X.Offset == 366, 'Phone layout keeps readable text without scaling the UI')
phoneWindow:Destroy()
camera.ViewportSize = roblox.Vector2.new(1280, 720)
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
environment.loadstring = function(source)
    return luau.load(source:gsub('Enum.KeyCode.Unknown', 'Enum.KeyCode.None'), { environment = environment })
end
environment.game.HttpGet = function(_, url)
    local path = url:match('https://raw%.githubusercontent%.com/amogamog70%-afk/mintproject/main/(.+)')
    assert(path, 'Unexpected network request in the editable example')
    return fs.readFile(path)
end
local editable = load(fs.readFile('Example.lua'))
check(
    #editable.Tabs == 4 and editable.Tabs.Settings ~= nil,
    'Editable example runs library and manager loaders'
)
local editableGui = editable.Context.Gui
local editableAgain = load(fs.readFile('Example.lua'))
check(not editableGui.Parent, 'Rerunning the editable example unloads its previous instance')
editableAgain:Destroy()
flush()
for _, name in ipairs({ 'readfile', 'writefile', 'isfile', 'isfolder', 'makefolder', 'listfiles', 'delfile' }) do
    environment[name] = nil
end
local demo = load(fs.readFile('dist/Demo.lua'))
check(#demo.Tabs == 4, 'Standalone demo creates four tabs')
if require('@lune/process').args[1] == '--preview' then
    local function encode(value)
        local kind = typeof(value)
        if kind == 'Color3' then
            return '#' .. value:ToHex()
        elseif kind == 'UDim2' then
            return { value.X.Scale, value.X.Offset, value.Y.Scale, value.Y.Offset }
        elseif kind == 'UDim' then
            return { value.Scale, value.Offset }
        elseif kind == 'Vector2' then
            return { value.X, value.Y }
        elseif kind == 'EnumItem' then
            return value.Name
        elseif kind == 'ColorSequence' or kind == 'NumberSequence' then
            local points = {}
            for _, point in ipairs(value.Keypoints) do
                table.insert(points, { point.Time, encode(point.Value) })
            end
            return points
        elseif type(value) == 'number' or type(value) == 'string' or type(value) == 'boolean' then
            return value
        end
        return nil
    end
    local properties = {
        'Name',
        'Size',
        'Position',
        'AnchorPoint',
        'Visible',
        'BackgroundColor3',
        'BackgroundTransparency',
        'LayoutOrder',
        'Rotation',
        'ZIndex',
        'AutomaticSize',
        'ClipsDescendants',
        'GroupTransparency',
        'Text',
        'TextColor3',
        'TextSize',
        'TextXAlignment',
        'TextYAlignment',
        'TextWrapped',
        'TextTruncate',
        'Font',
        'PlaceholderText',
        'ScrollBarThickness',
        'CornerRadius',
        'Padding',
        'FillDirection',
        'HorizontalAlignment',
        'VerticalAlignment',
        'PaddingTop',
        'PaddingBottom',
        'PaddingLeft',
        'PaddingRight',
        'Color',
        'Thickness',
        'Transparency',
    }
    local function tree(node)
        local data = { class = node._native.ClassName, props = {}, children = {} }
        for _, property in ipairs(properties) do
            local ok, value = pcall(function()
                return node._native[property]
            end)
            if ok then
                data.props[property] = encode(value)
            end
        end
        for _, child in ipairs(node._children) do
            table.insert(data.children, tree(child))
        end
        return data
    end
    local function snapshot(window, name, width, height)
        fs.writeFile(
            '.validation/' .. name .. '.json',
            serde.encode('json', { width = width, height = height, tree = tree(window.Context.Gui) })
        )
    end
    snapshot(demo, 'desktop-main', 1280, 720)
    demo.Tabs.Settings:Select()
    snapshot(demo, 'desktop-settings', 1280, 720)
    demo:Destroy()
    environment.workspace.CurrentCamera.ViewportSize = roblox.Vector2.new(390, 844)
    input.TouchEnabled = true
    demo = load(fs.readFile('dist/Demo.lua'))
    snapshot(demo, 'mobile-main', 390, 844)
end
demo:Destroy()
flush()
print(
    'PASS: '
        .. checks
        .. ' checks; headless property, state, profile and lifecycle tests. Rendered Roblox QA pending.'
)
