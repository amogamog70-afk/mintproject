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
    local self = { Context = ctx, Tabs = {}, Profiles = profiles or {}, Visible = true, Version = '0.2.0' }
    local gui = ctx:New('ScreenGui', {
        Name = options.Name or 'MintProjectUI',
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 50,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, ctx.Parent)
    ctx.Gui = gui
    local root = ctx:New(
        'CanvasGroup',
        { Name = 'Window', GroupTransparency = 1, Active = true, ClipsDescendants = true },
        gui
    )
    ctx:Paint(root, 'Background')
    ctx:Stroke(root)
    ctx:New('UICorner', { CornerRadius = UDim.new(0, 3) }, root)
    self.Root = root
    local header = ctx:New('Frame', { Name = 'Header', Size = UDim2.new(1, 0, 0, 48), Active = true }, root)
    ctx:Paint(header, 'Panel')
    Logo.draw(ctx, header, UDim2.fromOffset(14, 9), UDim2.fromOffset(30, 28))
    ctx:Text(options.Title or 'MintProject', header, {
        Position = UDim2.fromOffset(56, 6),
        Size = UDim2.new(1, -130, 0, 23),
        TextSize = 15,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    local subtitle = ctx:Text(
        options.Subtitle or 'INTERFACE LIBRARY',
        header,
        { Position = UDim2.fromOffset(57, 28), Size = UDim2.new(1, -130, 0, 13), TextSize = 9 }
    )
    ctx:Bind(subtitle, 'TextColor3', 'Muted')
    local gloss = ctx:New('Frame', { Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 0.25 }, header)
    ctx:Paint(gloss, 'White')
    ctx:New('UIGradient', {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.68),
            NumberSequenceKeypoint.new(1, 1),
        }),
    }, gloss)
    local close = ctx:Button(
        '×',
        header,
        { Position = UDim2.new(1, -38, 0, 12), Size = UDim2.fromOffset(25, 25), TextSize = 18 }
    )
    ctx:Connect(close.Activated, function()
        self:SetVisible(false)
    end)
    local tabs = ctx:New('ScrollingFrame', {
        Name = 'Tabs',
        Position = UDim2.fromOffset(12, 49),
        Size = UDim2.new(1, -24, 0, 34),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarThickness = 0,
    }, root)
    ctx:List(tabs, 0, true)
    local line =
        ctx:New('Frame', { Position = UDim2.fromOffset(12, 83), Size = UDim2.new(1, -24, 0, 1) }, root)
    ctx:Paint(line, 'Border')
    local body = ctx:New('Frame', {
        Name = 'Body',
        Position = UDim2.fromOffset(12, 95),
        Size = UDim2.new(1, -24, 1, -123),
        BackgroundTransparency = 1,
    }, root)
    local footer = ctx:Text(
        'MINTPROJECT / 0.2',
        root,
        { Position = UDim2.new(0, 16, 1, -22), Size = UDim2.new(0.6, 0, 0, 16), TextSize = 9 }
    )
    ctx:Bind(footer, 'TextColor3', 'Muted')
    local hint = ctx:Text('', root, {
        Position = UDim2.new(0.6, 0, 1, -22),
        Size = UDim2.new(0.4, -16, 0, 16),
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    ctx:Bind(hint, 'TextColor3', 'Muted')
    local open = ctx:Button('M', gui, {
        Name = 'OpenMenu',
        Position = UDim2.new(0, 14, 1, -50),
        Size = UDim2.fromOffset(36, 34),
        TextSize = 15,
        ZIndex = 20,
    })
    ctx:Bind(open, 'TextColor3', 'Accent')
    ctx:Connect(open.Activated, function()
        self:SetVisible(not self.Visible)
    end)
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
    ctx.ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    ctx.ToggleVisible = function()
        self:SetVisible(not self.Visible)
    end
    local wantedW, wantedH = options.Width or 960, options.Height or 640
    local positioned = false
    local function viewport()
        return workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    end
    local function layout()
        local v = viewport()
        local width = math.floor(math.min(wantedW, math.max(200, v.X - 24)))
        local height = math.floor(math.min(wantedH, math.max(200, v.Y - 24)))
        root.Size = UDim2.fromOffset(width, height)
        local columns = width >= 900 and 3 or width >= 650 and 2 or 1
        self.ColumnCount = math.min(options.Columns or 3, columns)
        ctx.Mobile = columns == 1
        if not positioned then
            root.Position = options.Position
                or UDim2.fromOffset(math.floor((v.X - width) / 2), math.floor((v.Y - height) / 2))
            positioned = true
        else
            root.Position = UDim2.fromOffset(
                math.round(math.clamp(root.AbsolutePosition.X, 0, math.max(0, v.X - width))),
                math.round(math.clamp(root.AbsolutePosition.Y, 0, math.max(0, v.Y - height)))
            )
        end
        notices.Size = UDim2.fromOffset(math.min(270, math.max(150, v.X - 32)), 0)
        for _, tab in ipairs(self.Tabs) do
            local n = self.ColumnCount
            for i, column in ipairs(tab.Columns) do
                column.Visible = i <= n
                column.Position = UDim2.new((i - 1) / n, i > 1 and 5 or 0, 0, 0)
                column.Size = UDim2.new(1 / n, n == 1 and 0 or -7, 1, 0)
            end
            for _, section in ipairs(tab.Sections) do
                section.Root.Parent = tab.Columns[math.min(section.Column, n)]
            end
        end
        for _, tab in ipairs(self.Tabs) do
            tab.Button.Size =
                UDim2.new(0, math.max(90, math.floor((width - 24) / math.max(1, #self.Tabs))), 1, 0)
        end
    end
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
    local dragStart, positionStart
    ctx:Connect(header.InputBegan, function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            dragStart = input.Position
            positionStart = root.AbsolutePosition
        end
    end)
    ctx:Pointer(header, function(position)
        if not dragStart then
            return
        end
        local delta = position - dragStart
        local v = viewport()
        local size = root.AbsoluteSize
        root.Position = UDim2.fromOffset(
            math.round(math.clamp(positionStart.X + delta.X, 0, math.max(0, v.X - size.X))),
            math.round(math.clamp(positionStart.Y + delta.Y, 0, math.max(0, v.Y - size.Y)))
        )
    end)
    function self:SetVisible(value)
        if ctx.Destroyed then
            return
        end
        self.Visible = value == true
        ctx:ClosePopup()
        self.VisibilitySequence = (self.VisibilitySequence or 0) + 1
        local sequence = self.VisibilitySequence
        if self.Visible then
            root.Visible = true
            ctx:Animate(root, { GroupTransparency = 0 })
        else
            ctx:Animate(root, { GroupTransparency = 1 })
            task.delay(ctx.Animations and 0.18 or 0, function()
                if not ctx.Destroyed and sequence == self.VisibilitySequence then
                    root.Visible = false
                end
            end)
        end
    end
    function self:SetTheme(patch)
        ctx:SetTheme(patch)
    end
    function self:SetAnimations(value)
        ctx.Animations = value == true
    end
    function self:SetToggleKey(key)
        assert(typeof(key) == 'EnumItem' and key.EnumType == Enum.KeyCode, 'Expected KeyCode')
        ctx.ToggleKey = key
        hint.Text = key == Enum.KeyCode.Unknown and 'M / OPEN MENU' or key.Name .. ' / TOGGLE MENU'
    end
    self:SetToggleKey(ctx.ToggleKey)
    function self:Notify(text, duration)
        if ctx.Destroyed then
            return
        end
        local card = ctx:New(
            'CanvasGroup',
            { Name = 'Notification', Size = UDim2.new(1, 0, 0, 54), GroupTransparency = 1, ZIndex = 90 },
            notices
        )
        ctx:Paint(card, 'Panel')
        ctx:Stroke(card)
        local mark = ctx:New('Frame', { Size = UDim2.new(0, 2, 1, 0), ZIndex = 91 }, card)
        ctx:Paint(mark, 'Accent')
        ctx:Text(tostring(text), card, {
            Position = UDim2.fromOffset(12, 7),
            Size = UDim2.new(1, -24, 1, -14),
            TextWrapped = true,
            ZIndex = 91,
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
        local button = ctx:Button(name, tabs, { BackgroundTransparency = 1, Size = UDim2.fromOffset(90, 34) })
        for _, child in ipairs(button:GetChildren()) do
            if child:IsA('UIStroke') then
                child:Destroy()
            end
        end
        local underline = ctx:New(
            'Frame',
            { Position = UDim2.new(0, 10, 1, -2), Size = UDim2.new(1, -20, 0, 2), Visible = false },
            button
        )
        ctx:Paint(underline, 'Accent')
        local page = ctx:New(
            'Frame',
            { Name = name, Size = UDim2.fromScale(1, 1), Visible = false, BackgroundTransparency = 1 },
            body
        )
        tab.Page = page
        tab.Button = button
        tab.Underline = underline
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
            ctx:List(column, 10)
            ctx:Padding(column, 2)
            local sequence = 0
            ctx:Connect(column:GetPropertyChangedSignal('CanvasPosition'), function()
                ctx:ClosePopup()
                sequence += 1
                local current = sequence
                column.ScrollBarThickness = 2
                task.delay(0.7, function()
                    if not ctx.Destroyed and current == sequence then
                        column.ScrollBarThickness = 0
                    end
                end)
            end)
            tab.Columns[i] = column
        end
        function tab:Select()
            ctx:ClosePopup()
            for _, other in ipairs(self.Owner.Tabs) do
                other.Page.Visible = other == self
                other.Underline.Visible = other == self
                ctx:Bind(other.Button, 'TextColor3', other == self and 'Accent' or 'Muted')
            end
            footer.Text = 'MINTPROJECT / ' .. string.upper(name)
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
