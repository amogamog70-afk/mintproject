local Core = require(script.Parent.Core)
local Components = require(script.Parent.Components)
local Logo = require(script.Parent.Logo)
local Http = game:GetService('HttpService')
local Window = {}
function Window.new(options, profiles)
    options = options or {}
    local player = game:GetService('Players').LocalPlayer
    assert(options.Parent or player, 'MintProject must run in a client UI context')
    local ctx = Core.new(options.Parent or player:WaitForChild('PlayerGui'), options)
    local self = { Context = ctx, Tabs = {}, Profiles = profiles or {}, Visible = nil, Version = '0.4.0' }
    local gui = ctx:New('ScreenGui', {
        Name = options.Name or 'MintProjectUI',
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ScreenInsets = Enum.ScreenInsets.None,
        DisplayOrder = 50,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, ctx.Parent)
    ctx.Gui = gui
    -- Only this transparent CanvasGroup fades. Every visible piece of the menu,
    -- including its border and popups, is a descendant of this composite.
    local root = ctx:New('CanvasGroup', {
        Name = 'Window',
        BackgroundTransparency = 1,
        GroupTransparency = 1,
        Active = true,
        ClipsDescendants = true,
    }, gui)
    self.Root = root
    ctx.MenuRoot = root
    local surface = ctx:New('Frame', { Name = 'Surface', Size = UDim2.fromScale(1, 1) }, root)
    ctx:Paint(surface, 'Background')
    ctx:Stroke(surface)
    ctx:Corner(surface, 3)
    self.Surface = surface
    local header = ctx:New(
        'Frame',
        { Name = 'Header', Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Active = true },
        surface
    )
    self.Header = header
    local brand = ctx:New('Frame', {
        Name = 'Brand',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(0, 30),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
    }, header)
    local brandLayout = ctx:List(brand, 8, true)
    brandLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    Logo.draw(ctx, brand, UDim2.new(), UDim2.fromOffset(26, 26))
    ctx:Text(options.Title or 'MintProject', brand, {
        Size = UDim2.fromOffset(0, 30),
        AutomaticSize = Enum.AutomaticSize.X,
        TextSize = 15,
    })
    local edge = ctx:New('Frame', {
        Name = 'AccentEdge',
        Position = UDim2.fromOffset(18, 50),
        Size = UDim2.new(1, -36, 0, 1),
        BackgroundTransparency = 0.55,
    }, surface)
    ctx:Paint(edge, 'Accent')
    local navigation = ctx:New('ScrollingFrame', {
        Name = 'Navigation',
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.Y,
    }, surface)
    local navList = ctx:List(navigation, 5)
    local rail = ctx:New('Frame', { Name = 'Rail', BackgroundTransparency = 0.45 }, surface)
    ctx:Paint(rail, 'Border')
    local body = ctx:New('Frame', { Name = 'Pages', BackgroundTransparency = 1 }, surface)
    local shield = ctx:New('TextButton', {
        Name = 'InputShield',
        Text = '',
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
        Active = true,
        ZIndex = 200,
    }, root)
    local function draggable(node, handle, onStart, onFinish)
        local pointerStart, positionStart
        ctx:Pointer(handle or node, function(position, initial)
            if initial then
                pointerStart, positionStart = position, node.Position
                if onStart then
                    onStart()
                end
                return
            end
            local delta = position - pointerStart
            node.Position = UDim2.new(
                positionStart.X.Scale,
                math.round(positionStart.X.Offset + delta.X),
                positionStart.Y.Scale,
                math.round(positionStart.Y.Offset + delta.Y)
            )
            if onFinish then
                onFinish(delta, false)
            end
        end)
    end
    local open = ctx:Button('', gui, {
        Name = 'OpenMenu',
        Position = UDim2.new(0, 14, 1, -52),
        Size = UDim2.fromOffset(36, 36),
        ZIndex = 20,
        Modal = true,
    })
    Logo.draw(ctx, open, UDim2.fromOffset(6, 6), UDim2.fromOffset(24, 24))
    self.OpenButton = open
    local launcherMoved = false
    draggable(open, nil, function()
        launcherMoved = false
    end, function(delta)
        if delta.Magnitude > 4 then
            launcherMoved = true
        end
    end)
    ctx:Connect(open.Activated, function()
        if not launcherMoved then
            self:SetVisible(not self.Visible)
        end
    end)
    local watermark = ctx:New('Frame', {
        Name = 'Watermark',
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 16),
        Size = UDim2.fromOffset(172, 34),
        Visible = options.Watermark ~= false,
        Active = true,
    }, gui)
    ctx:Paint(watermark, 'Background')
    ctx:Stroke(watermark)
    Logo.draw(ctx, watermark, UDim2.fromOffset(8, 6), UDim2.fromOffset(22, 22))
    local watermarkText = ctx:Text(options.WatermarkText or options.Title or 'MintProject', watermark, {
        Position = UDim2.fromOffset(38, 0),
        Size = UDim2.new(1, -46, 1, 0),
        TextSize = 12,
    })
    draggable(watermark)
    self.Watermark = watermark
    function self:SetWatermark(value)
        if type(value) == 'string' then
            watermarkText.Text = value
            watermark.Visible = true
        else
            watermark.Visible = value == true
        end
    end
    local keyPanel = ctx:New('Frame', {
        Name = 'KeybindList',
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -16, 0, 62),
        Size = UDim2.fromOffset(210, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = options.Keybinds ~= false,
        Active = true,
    }, gui)
    ctx:Paint(keyPanel, 'Background')
    ctx:Stroke(keyPanel)
    ctx:List(keyPanel, 0)
    local keyHeader = ctx:Text('Keybinds', keyPanel, {
        Name = 'Header',
        Size = UDim2.new(1, 0, 0, 30),
        Active = true,
        TextSize = 12,
    })
    ctx:Padding(keyHeader, 10)
    local keyPanelMoved = false
    draggable(keyPanel, keyHeader, nil, function()
        keyPanelMoved = true
    end)
    self.KeybindPanel = keyPanel
    self.KeybindRows = {}
    function self:SetKeybindsVisible(value)
        keyPanel.Visible = value == true
    end
    ctx.UpdateKeybinds = function()
        for binding in pairs(ctx.Keybinds) do
            if not binding.HideFromList then
                local view = self.KeybindRows[binding]
                if not view then
                    local row = ctx:New(
                        'Frame',
                        { Name = binding.Name, Size = UDim2.new(1, 0, 0, 28), LayoutOrder = 1 },
                        keyPanel
                    )
                    ctx:Paint(row, 'Hover')
                    local marker = ctx:New('Frame', { Size = UDim2.new(0, 2, 1, 0) }, row)
                    ctx:Paint(marker, 'Accent')
                    local name = ctx:Text(binding.Name, row, {
                        Position = UDim2.fromOffset(10, 0),
                        Size = UDim2.new(1, -80, 1, 0),
                        TextSize = 12,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                    })
                    local key = ctx:Text('', row, {
                        Position = UDim2.new(1, -70, 0, 0),
                        Size = UDim2.fromOffset(60, 28),
                        TextSize = 11,
                        TextXAlignment = Enum.TextXAlignment.Right,
                    })
                    view = { Root = row, Marker = marker, Name = name, Key = key }
                    self.KeybindRows[binding] = view
                end
                local active = binding:GetState()
                view.Root.Visible = binding.Value ~= Enum.KeyCode.Unknown or binding.Mode == 'Always'
                view.Root.BackgroundTransparency = active and 0.15 or 1
                view.Marker.Visible = active
                view.Name.TextTransparency = active and 0 or 0.5
                view.Key.TextTransparency = active and 0 or 0.5
                view.Key.Text = binding.KeyName or binding.Value.Name
            end
        end
    end
    local notices = ctx:New('Frame', {
        Name = 'Notifications',
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.fromOffset(270, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 90,
    }, gui)
    ctx:List(notices, 6).VerticalAlignment = Enum.VerticalAlignment.Bottom
    function self:SetToggleKey(value)
        local values = type(value) == 'table' and value or { value }
        local keys = {}
        for _, key in ipairs(values) do
            if type(key) == 'string' then
                local ok, resolved = pcall(function()
                    return Enum.KeyCode[key:gsub('%s+', '')]
                end)
                key = ok and resolved or nil
            end
            assert(
                typeof(key) == 'EnumItem' and key.EnumType == Enum.KeyCode,
                'Expected KeyCode or list of KeyCodes'
            )
            if key ~= Enum.KeyCode.Unknown then
                keys[key] = true
            end
        end
        ctx.ToggleKeys = keys
        ctx.ToggleKey = values[1]
    end
    self:SetToggleKey(options.ToggleKey or { Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift })
    ctx.ToggleVisible = function()
        self:SetVisible(not self.Visible)
    end
    local positioned = false
    local wasMobile
    local wantedW, wantedH = options.Width or 960, options.Height or 640
    local function viewport()
        return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    end
    local function layout()
        local v = viewport()
        local size = Vector2.new(
            math.floor(math.min(wantedW, math.max(200, v.X - 24))),
            math.floor(math.min(wantedH, math.max(200, v.Y - 24)))
        )
        root.Size = UDim2.fromOffset(size.X, size.Y)
        if not positioned then
            root.Position = options.Position
                or UDim2.fromOffset(math.floor((v.X - size.X) / 2), math.floor((v.Y - size.Y) / 2))
            positioned = true
        end
        local mobile = size.X < 700
        ctx.Mobile = mobile
        keyPanel.Size = UDim2.fromOffset(mobile and 210 or math.clamp((v.X - size.X) / 2 - 24, 148, 210), 0)
        if not keyPanelMoved and mobile ~= wasMobile then
            keyPanel.AnchorPoint = Vector2.new(1, mobile and 1 or 0)
            keyPanel.Position = mobile and UDim2.new(1, -16, 1, -12) or UDim2.new(1, -16, 0, 62)
        end
        wasMobile = mobile
        navigation.Position = UDim2.fromOffset(16, mobile and 61 or 70)
        navigation.Size = mobile and UDim2.new(1, -32, 0, 36) or UDim2.new(0, 130, 1, -88)
        navigation.ScrollingDirection = mobile and Enum.ScrollingDirection.X or Enum.ScrollingDirection.Y
        navigation.AutomaticCanvasSize = mobile and Enum.AutomaticSize.X or Enum.AutomaticSize.Y
        navList.FillDirection = mobile and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
        rail.Visible = not mobile
        rail.Position = UDim2.fromOffset(155, 70)
        rail.Size = UDim2.new(0, 1, 1, -88)
        body.Position = UDim2.fromOffset(mobile and 16 or 172, mobile and 110 or 70)
        body.Size = mobile and UDim2.new(1, -32, 1, -126) or UDim2.new(1, -190, 1, -88)
        local available = size.X - (mobile and 32 or 190)
        self.ColumnCount =
            math.min(options.Columns or 2, available >= 900 and 3 or available >= 560 and 2 or 1)
        for _, tab in ipairs(self.Tabs) do
            tab.Button.Size = mobile and UDim2.fromOffset(102, 34) or UDim2.fromOffset(130, 36)
            local n = self.ColumnCount
            for i, column in ipairs(tab.Columns) do
                column.Visible = i <= n
                column.Position = UDim2.new((i - 1) / n, i > 1 and 6 or 0, 0, 0)
                column.Size = UDim2.new(1 / n, n == 1 and 0 or -8, 1, 0)
            end
            for _, section in ipairs(tab.Sections) do
                section.Root.Parent = tab.Columns[math.min(section.Column, n)]
            end
        end
        notices.Size = UDim2.fromOffset(math.min(270, math.max(150, v.X - 32)), 0)
    end
    self.UpdateLayout = layout
    local function connectCamera()
        if self.CameraConnection then
            self.CameraConnection:Disconnect()
        end
        local camera = workspace.CurrentCamera
        if camera and camera.GetPropertyChangedSignal then
            self.CameraConnection = ctx:Connect(camera:GetPropertyChangedSignal('ViewportSize'), layout)
        end
        layout()
    end
    if workspace.GetPropertyChangedSignal then
        ctx:Connect(workspace:GetPropertyChangedSignal('CurrentCamera'), connectCamera)
    end
    connectCamera()
    draggable(root, header)
    function self:SetVisible(value)
        if ctx.Destroyed then
            return
        end
        value = value == true
        if self.Visible == value then
            return
        end
        self.Visible = value
        open.Modal = value
        self.VisibilitySequence = (self.VisibilitySequence or 0) + 1
        local sequence = self.VisibilitySequence
        if value then
            ctx.MenuClosing = false
            shield.Visible = false
            root.Visible = true
            ctx:Animate(root, { GroupTransparency = 0 }, 0.24)
        else
            ctx.MenuClosing = true
            shield.Visible = true
            if ctx.DragEnd then
                ctx.DragEnd()
            end
            ctx.DragEnd = nil
            ctx.Drag = nil
            ctx.DragInput = nil
            ctx.DragMouse = nil
            ctx.CaptureKey = nil
            ctx:Animate(root, { GroupTransparency = 1 }, 0.24)
            local function finish()
                if ctx.Destroyed or sequence ~= self.VisibilitySequence then
                    return
                end
                root.Visible = false
                ctx:ClosePopup() -- Popup disappears only after its containing menu is hidden.
                shield.Visible = false
                ctx.MenuClosing = false
            end
            if ctx.Animations then
                task.delay(0.24, finish)
            else
                finish()
            end
        end
    end
    function self:SetTheme(patch)
        ctx:SetTheme(patch)
    end
    function self:SetAnimations(value)
        ctx.Animations = value == true
    end
    function self:Notify(text, duration)
        if ctx.Destroyed then
            return
        end
        local card = ctx:New('CanvasGroup', {
            Name = 'Notification',
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            GroupTransparency = 1,
            ZIndex = 90,
        }, notices)
        local panel = ctx:New('Frame', { Size = UDim2.fromScale(1, 1), ZIndex = 90 }, card)
        ctx:Paint(panel, 'Panel')
        ctx:Corner(panel, 7)
        ctx:Stroke(panel)
        local mark = ctx:New(
            'Frame',
            { Position = UDim2.fromOffset(9, 16), Size = UDim2.fromOffset(3, 16), ZIndex = 91 },
            panel
        )
        ctx:Paint(mark, 'Accent')
        ctx:Corner(mark, 2)
        ctx:Text(tostring(text), panel, {
            Position = UDim2.fromOffset(22, 7),
            Size = UDim2.new(1, -32, 1, -14),
            TextWrapped = true,
            ZIndex = 91,
            TextSize = 12,
        })
        ctx:Animate(card, { GroupTransparency = 0 })
        task.delay(duration or 3, function()
            if not card.Parent or ctx.Destroyed then
                return
            end
            ctx:Animate(card, { GroupTransparency = 1 })
            task.delay(0.18, function()
                if card.Parent then
                    card:Destroy()
                end
            end)
        end)
    end
    function self:Tab(name)
        assert(type(name) == 'string' and not self.Tabs[name], 'Tab name must be unique')
        local tab = { Name = name, Owner = self, Columns = {}, Sections = {} }
        local button = ctx:Button(name, navigation, {
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 0.7,
            Size = UDim2.fromOffset(130, 36),
        })
        for _, child in ipairs(button:GetChildren()) do
            if child:IsA('UIStroke') then
                child:Destroy()
            end
        end
        ctx:Padding(button, 13)
        local dot = ctx:New('Frame', {
            Name = 'Selected',
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.fromOffset(4, 4),
            Visible = false,
        }, button)
        ctx:Paint(dot, 'Accent')
        ctx:Corner(dot, 2)
        local page = ctx:New(
            'Frame',
            { Name = name, Size = UDim2.fromScale(1, 1), Visible = false, BackgroundTransparency = 1 },
            body
        )
        tab.Page = page
        tab.Button = button
        tab.Underline = dot
        for i = 1, 3 do
            local column = ctx:New('ScrollingFrame', {
                Name = 'Column' .. i,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                ScrollingDirection = Enum.ScrollingDirection.Y,
            }, page)
            ctx:Bind(column, 'ScrollBarImageColor3', 'Accent')
            ctx:List(column, 12)
            ctx:Padding(column, 2)
            local sequence = 0
            ctx:Connect(column:GetPropertyChangedSignal('CanvasPosition'), function()
                ctx:ClosePopup()
                sequence += 1
                local current = sequence
                column.ScrollBarThickness = 2
                task.delay(0.7, function()
                    if not ctx.Destroyed and sequence == current then
                        column.ScrollBarThickness = 0
                    end
                end)
            end)
            tab.Columns[i] = column
        end
        function tab:Select()
            ctx:ClosePopup()
            for _, other in ipairs(self.Owner.Tabs) do
                local selected = other == self
                other.Page.Visible = selected
                other.Underline.Visible = selected
                other.Button.BackgroundTransparency = selected and 0 or 0.7
                ctx:Paint(other.Button, selected and 'Field' or 'Panel')
                ctx:Bind(other.Button, 'TextColor3', 'Text')
                other.Button.TextTransparency = selected and 0 or 0.35
            end
        end
        function tab:Section(title, settings)
            local index = math.clamp(settings and settings.Column or 1, 1, 3)
            local section =
                Components.section(ctx, self.Columns[math.min(index, self.Owner.ColumnCount)], title)
            section.Column = index
            section.Root.LayoutOrder = #self.Sections + 1
            table.insert(self.Sections, section)
            return section
        end
        tab.AddGroupbox = tab.Section
        function tab:AddLeftGroupbox(title)
            return self:Section(title, { Column = 1 })
        end
        function tab:AddRightGroupbox(title)
            return self:Section(title, { Column = 2 })
        end
        function tab:AddMiddleGroupbox(title)
            return self:Section(title, { Column = 2 })
        end
        self.Tabs[#self.Tabs + 1] = tab
        self.Tabs[name] = tab
        ctx:Connect(button.Activated, function()
            tab:Select()
        end)
        if #self.Tabs == 1 then
            tab:Select()
        end
        layout()
        return tab
    end
    self.AddTab = self.Tab
    function self:ExportConfig(ignore)
        local values = {}
        for id, c in pairs(ctx.Controls) do
            if not (ignore and ignore[id]) then
                if typeof(c.Value) == 'Color3' then
                    values[id] = { type = 'color', r = c.Value.R, g = c.Value.G, b = c.Value.B }
                elseif typeof(c.Value) == 'EnumItem' then
                    values[id] = {
                        type = 'key',
                        name = c.Value.Name,
                        enum = c.Value.EnumType == Enum.UserInputType and 'UserInputType' or 'KeyCode',
                        mode = c.Mode,
                    }
                else
                    values[id] = c:Get()
                end
            end
        end
        return Http:JSONEncode({ version = 1, values = values })
    end
    function self:ImportConfig(json)
        local ok, data = pcall(Http.JSONDecode, Http, json)
        if not ok or type(data) ~= 'table' or data.version ~= 1 or type(data.values) ~= 'table' then
            return false, 'Invalid MintProject profile'
        end
        local failures = {}
        for id, value in pairs(data.values) do
            local control = ctx.Controls[id]
            if control then
                if type(value) == 'table' and value.type == 'color' then
                    local r, g, b =
                        Core.number(value.r, 0, 1), Core.number(value.g, 0, 1), Core.number(value.b, 0, 1)
                    value = r and g and b and Color3.new(r, g, b) or nil
                elseif type(value) == 'table' and value.type == 'key' then
                    if value.mode and control.SetMode and not control.NoModes then
                        if not control:SetMode(value.mode) then
                            table.insert(failures, id)
                        end
                    end
                    local good, key = pcall(function()
                        return (value.enum == 'UserInputType' and Enum.UserInputType or Enum.KeyCode)[value.name]
                    end)
                    value = good and key or nil
                end
                local success, result = pcall(control.Set, control, value)
                if not success or result == false then
                    table.insert(failures, id)
                end
            end
        end
        return #failures == 0, table.concat(failures, ', ')
    end
    function self:SaveProfile(name)
        assert(type(name) == 'string' and #name > 0, 'Profile name is empty')
        self.Profiles[name] = self:ExportConfig()
        return self.Profiles[name]
    end
    function self:LoadProfile(name)
        if not self.Profiles[name] then
            return false, 'Profile not found'
        end
        return self:ImportConfig(self.Profiles[name])
    end
    function self:Destroy()
        ctx:Destroy()
    end
    self:SetVisible(options.AutoShow ~= false)
    return self
end
return Window
