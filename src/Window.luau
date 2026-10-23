local Core = require(script.Parent.Core)
local Components = require(script.Parent.Components)
local Http = game:GetService('HttpService')
local Window = {}
function Window.new(options, profiles)
    options = options or {}
    local player = game:GetService('Players').LocalPlayer
    assert(options.Parent or player, 'MintProject must run in a client UI context')
    local parent = options.Parent or player:WaitForChild('PlayerGui')
    local ctx = Core.new(parent, options)
    local self =
        { Context = ctx, Tabs = {}, Profiles = profiles or {}, Visible = true, Version = '0.1.0-preview' }
    local gui = ctx:New('ScreenGui', {
        Name = options.Name or 'MintProjectUI',
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 50,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, parent)
    ctx.Gui = gui
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
        or Vector2.new(1000, 700)
    local size = Vector2.new(
        math.min(options.Width or 790, viewport.X - 20),
        math.min(options.Height or 520, viewport.Y - 20)
    )
    local root = ctx:New('CanvasGroup', {
        Name = 'Window',
        Size = UDim2.fromOffset(size.X, size.Y),
        Position = UDim2.fromOffset(
            math.round(math.max(10, (viewport.X - size.X) / 2)),
            math.round(math.max(10, (viewport.Y - size.Y) / 2))
        ),
        GroupTransparency = 1,
        Active = true,
    }, gui)
    ctx:Paint(root, 'Background')
    ctx:Stroke(root)
    self.Root = root
    local header = ctx:New('Frame', { Size = UDim2.new(1, 0, 0, 42), Active = true }, root)
    ctx:Paint(header, 'Panel')
    ctx:Text(
        options.Title or 'MintProject',
        header,
        { Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -95, 0, 26), TextSize = 18 }
    )
    local gloss = ctx:New('Frame', { Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 0.25 }, header)
    ctx:Paint(gloss, 'White')
    ctx:New('UIGradient', {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.9),
            NumberSequenceKeypoint.new(0.5, 0.15),
            NumberSequenceKeypoint.new(1, 0.9),
        }),
    }, gloss)
    local close =
        ctx:Button('×', header, { Position = UDim2.new(1, -38, 0, 7), Size = UDim2.fromOffset(28, 28) })
    ctx:Connect(close.Activated, function()
        self:SetVisible(false)
    end)
    local tabs = ctx:New('ScrollingFrame', {
        Position = UDim2.fromOffset(10, 48),
        Size = UDim2.new(1, -20, 0, 32),
        BackgroundTransparency = 1,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        ScrollingDirection = Enum.ScrollingDirection.X,
        ScrollBarThickness = 0,
    }, root)
    ctx:List(tabs, 6, true)
    local body = ctx:New(
        'Frame',
        { Position = UDim2.fromOffset(10, 90), Size = UDim2.new(1, -20, 1, -100), BackgroundTransparency = 1 },
        root
    )
    local open = ctx:Button(
        'M',
        gui,
        { Position = UDim2.new(0, 14, 1, -48), Size = UDim2.fromOffset(34, 32), ZIndex = 20 }
    )
    ctx:Bind(open, 'TextColor3', 'Accent')
    ctx:Connect(open.Activated, function()
        self:SetVisible(not self.Visible)
    end)
    local notices = ctx:New('Frame', {
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -16, 1, -16),
        Size = UDim2.fromOffset(math.min(280, viewport.X - 30), 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        ZIndex = 90,
    }, gui)
    local nl = ctx:List(notices, 6)
    nl.VerticalAlignment = Enum.VerticalAlignment.Bottom
    ctx.ToggleKey = options.ToggleKey or Enum.KeyCode.RightShift
    ctx.ToggleVisible = function()
        self:SetVisible(not self.Visible)
    end
    local startInput, startPos
    ctx:Connect(header.InputBegan, function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            startInput = input.Position
            startPos = root.AbsolutePosition
        end
    end)
    ctx:Pointer(header, function(pos)
        if not startPos then
            return
        end
        local d = pos - startInput
        local v = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or viewport
        root.Position = UDim2.fromOffset(
            math.clamp(startPos.X + d.X, 0, math.max(0, v.X - size.X)),
            math.clamp(startPos.Y + d.Y, 0, math.max(0, v.Y - 42))
        )
    end)
    function self:SetVisible(value)
        if ctx.Destroyed then
            return
        end
        self.Visible = value == true
        ctx:ClosePopup()
        self.VisibilitySequence = (self.VisibilitySequence or 0) + 1
        local seq = self.VisibilitySequence
        if self.Visible then
            root.Visible = true
            ctx:Animate(root, { GroupTransparency = 0 })
        else
            ctx:Animate(root, { GroupTransparency = 1 })
            task.delay(ctx.Animations and 0.18 or 0, function()
                if not ctx.Destroyed and self.VisibilitySequence == seq then
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
    end
    function self:Notify(text, duration)
        if ctx.Destroyed then
            return
        end
        local n = ctx:New('Frame', { Size = UDim2.new(1, 0, 0, 58), ZIndex = 90 }, notices)
        ctx:Paint(n, 'Panel')
        ctx:Stroke(n)
        ctx:Text(
            tostring(text),
            n,
            {
                Position = UDim2.fromOffset(10, 6),
                Size = UDim2.new(1, -20, 1, -12),
                TextWrapped = true,
                ZIndex = 91,
            }
        )
        task.delay(duration or 3, function()
            if n.Parent then
                n:Destroy()
            end
        end)
    end
    function self:Tab(name)
        local tab = { Name = name }
        local button =
            ctx:Button(name, tabs, { Size = UDim2.fromOffset(math.clamp(#name * 8 + 22, 80, 180), 30) })
        local page = ctx:New('ScrollingFrame', {
            Size = UDim2.fromScale(1, 1),
            Visible = false,
            BackgroundTransparency = 1,
            CanvasSize = UDim2.new(),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            ScrollingDirection = Enum.ScrollingDirection.Y,
        }, body)
        ctx:Bind(page, 'ScrollBarImageColor3', 'Accent')
        ctx:List(page, 8)
        ctx:Padding(page, 2)
        ctx:Connect(page:GetPropertyChangedSignal('CanvasPosition'), function()
            ctx:ClosePopup()
            page.ScrollBarThickness = 3
            tab.ScrollSequence = (tab.ScrollSequence or 0) + 1
            local seq = tab.ScrollSequence
            task.delay(0.7, function()
                if not ctx.Destroyed and seq == tab.ScrollSequence then
                    page.ScrollBarThickness = 0
                end
            end)
        end)
        function tab:Select()
            ctx:ClosePopup()
            for _, t in ipairs(self.Owner.Tabs) do
                t.Page.Visible = t == self
                ctx:Paint(t.Button, t == self and 'Hover' or 'Field')
                ctx:Bind(t.Button, 'TextColor3', t == self and 'Accent' or 'Text')
            end
        end
        function tab:Section(title)
            return Components.section(ctx, page, title)
        end
        tab.Owner = self
        tab.Page = page
        tab.Button = button
        self.Tabs[#self.Tabs + 1] = tab
        ctx:Connect(button.Activated, function()
            tab:Select()
        end)
        if #self.Tabs == 1 then
            tab:Select()
        end
        return tab
    end
    function self:ExportConfig()
        local values = {}
        for id, c in pairs(ctx.Controls) do
            if typeof(c.Value) == 'Color3' then
                values[id] = { type = 'color', r = c.Value.R, g = c.Value.G, b = c.Value.B }
            elseif typeof(c.Value) == 'EnumItem' then
                values[id] = { type = 'key', name = c.Value.Name }
            else
                values[id] = c.Value
            end
        end
        return Http:JSONEncode({ version = 1, values = values })
    end
    function self:ImportConfig(json)
        local ok, data = pcall(Http.JSONDecode, Http, json)
        if not ok or type(data) ~= 'table' or data.version ~= 1 or type(data.values) ~= 'table' then
            return false, 'Invalid MintProject profile'
        end
        local failed = {}
        for id, value in pairs(data.values) do
            local c = ctx.Controls[id]
            if c then
                if type(value) == 'table' and value.type == 'color' then
                    local r, g, b =
                        Core.number(value.r, 0, 1), Core.number(value.g, 0, 1), Core.number(value.b, 0, 1)
                    value = r and g and b and Color3.new(r, g, b) or nil
                elseif type(value) == 'table' and value.type == 'key' then
                    local good, key = pcall(function()
                        return Enum.KeyCode[value.name]
                    end)
                    value = good and key or nil
                end
                local good, result = pcall(c.Set, c, value)
                if not good or result == false then
                    failed[#failed + 1] = id
                end
            end
        end
        return #failed == 0, table.concat(failed, ', ')
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
    self:SetVisible(true)
    return self
end
return Window
