local Core = require(script.Parent.Core)
local Components = { Custom = {} }

function Components.register(name, builder)
    local reserved = {
        Label = true,
        Button = true,
        Toggle = true,
        Textbox = true,
        Slider = true,
        RangeSlider = true,
        Dropdown = true,
        Keybind = true,
        ColorPicker = true,
        SetExpanded = true,
    }
    assert(
        type(name) == 'string' and name:match('^%a[%w_]*$') and not reserved[name],
        'Invalid or reserved component name'
    )
    assert(
        type(builder) == 'function' and not Components.Custom[name],
        'Component already registered or builder is not a function'
    )
    Components.Custom[name] = builder
end

local function register(ctx, options, control)
    if options.Id then
        assert(type(options.Id) == 'string' and #options.Id > 0, 'Id must be a nonempty string')
        assert(not ctx.Controls[options.Id], 'Duplicate control Id: ' .. options.Id)
        ctx.Controls[options.Id] = control
    end
    function control:Get()
        return type(self.Value) == 'table' and table.clone(self.Value) or self.Value
    end
    return control
end

local function row(ctx, parent, text, height, description)
    local frame = ctx:New('Frame', {
        Size = UDim2.new(1, 0, 0, height or 32),
        BackgroundTransparency = 1,
    }, parent)
    ctx:Text(
        text,
        frame,
        { Size = UDim2.new(0.48, description and -34 or -8, 0, 30), TextTruncate = Enum.TextTruncate.AtEnd }
    )
    if description then
        local info =
            ctx:Button('i', frame, { Position = UDim2.new(0.48, -30, 0, 4), Size = UDim2.fromOffset(22, 22) })
        ctx:Connect(info.Activated, function()
            if ctx.PopupAnchor == info then
                ctx:ClosePopup()
                return
            end
            local popup = ctx:OpenPopup(info, 260, 100)
            ctx:Text(description, popup, {
                Position = UDim2.fromOffset(10, 8),
                Size = UDim2.new(1, -20, 1, -16),
                TextWrapped = true,
                ZIndex = 101,
            })
        end)
    end
    return frame
end

local function fieldProps()
    return { Position = UDim2.new(0.48, 0, 0, 0), Size = UDim2.new(0.52, 0, 0, 30) }
end

function Components.section(ctx, parent, title)
    local root = ctx:New('Frame', {
        Name = title,
        Size = UDim2.new(1, -4, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
    }, parent)
    ctx:Paint(root, 'Panel')
    ctx:Stroke(root)
    ctx:List(root, 0)
    local heading = ctx:New('TextButton', {
        Text = '−  ' .. title,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1,
    }, root)
    ctx:Padding(heading, 10)
    ctx:Bind(heading, 'TextColor3', 'Accent')
    local body = ctx:New('Frame', {
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    }, root)
    ctx:Padding(body, 10)
    ctx:List(body, 7)
    local section
    section = setmetatable({ Root = root, Body = body, Expanded = true }, {
        __index = function(_, name)
            local builder = Components.Custom[name]
            if builder then
                return function(_, options)
                    return builder(ctx, section, options or {})
                end
            end
        end,
    })
    function section:SetExpanded(value)
        self.Expanded = value == true
        body.Visible = self.Expanded
        heading.Text = (self.Expanded and '−  ' or '+  ') .. title
    end
    ctx:Connect(heading.Activated, function()
        section:SetExpanded(not section.Expanded)
    end)

    function section:Label(text)
        return ctx:Text(text, body, { TextWrapped = true, AutomaticSize = Enum.AutomaticSize.Y })
    end

    function section:Button(options)
        local button = ctx:Button(options.Text or 'Button', body, { Size = UDim2.new(1, 0, 0, 32) })
        ctx:Paint(button, 'Accent')
        ctx:Bind(button, 'TextColor3', 'AccentText')
        ctx:New(
            'UIGradient',
            { Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(185, 215, 198)), Rotation = 90 },
            button
        )
        ctx:Connect(button.Activated, function()
            ctx:Callback(options.Callback)
        end)
        return button
    end

    function section:Toggle(options)
        local frame = row(ctx, body, options.Text or 'Toggle', nil, options.Description)
        local button = ctx:Button('', frame, {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, 0, 0, 3),
            Size = UDim2.fromOffset(44, 24),
        })
        local thumb =
            ctx:New('Frame', { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(4, 4) }, button)
        local control = register(ctx, options, { Value = options.Default == true })
        function control:Refresh()
            ctx:Paint(button, self.Value and 'Accent' or 'Field')
            ctx:Paint(thumb, self.Value and 'AccentText' or 'Muted')
            ctx:Animate(thumb, { Position = UDim2.fromOffset(self.Value and 24 or 4, 4) })
        end
        function control:Set(value, silent)
            if type(value) ~= 'boolean' then
                return false
            end
            local changed = self.Value ~= value
            self.Value = value
            self:Refresh()
            if changed and not silent then
                ctx:Callback(options.Callback, value)
            end
            return true
        end
        ctx:Connect(button.Activated, function()
            control:Set(not control.Value)
        end)
        control:Refresh()
        return control
    end

    function section:Textbox(options)
        local frame = row(ctx, body, options.Text or 'Text', nil, options.Description)
        local props = fieldProps()
        props.Text = tostring(options.Default or '')
        props.ClearTextOnFocus = false
        props.PlaceholderText = options.Placeholder or ''
        local input = ctx:New('TextBox', props, frame)
        ctx:Paint(input, 'Field')
        ctx:Stroke(input)
        local control = register(ctx, options, { Value = props.Text })
        function control:Set(value, silent)
            if type(value) ~= 'string' then
                return false
            end
            self.Value = value
            input.Text = value
            if not silent then
                ctx:Callback(options.Callback, value)
            end
            return true
        end
        ctx:Connect(input.FocusLost, function()
            control:Set(input.Text)
        end)
        return control
    end

    function section:Slider(options)
        local minimum, maximum, step = options.Min or 0, options.Max or 100, options.Step or 1
        assert(
            type(minimum) == 'number' and type(maximum) == 'number' and maximum > minimum,
            'Slider Max must exceed Min'
        )
        assert(type(step) == 'number' and step >= 0, 'Slider Step must be nonnegative')
        local frame = row(ctx, body, options.Text or 'Slider', 55, options.Description)
        local track = ctx:New(
            'Frame',
            { Position = UDim2.fromOffset(0, 31), Size = UDim2.new(1, 0, 0, 22), Active = true },
            frame
        )
        ctx:Paint(track, 'Field')
        ctx:Stroke(track)
        local fill = ctx:New('Frame', { Size = UDim2.new(), BackgroundTransparency = 0.4 }, track)
        ctx:Paint(fill, 'Accent')
        local thumb = ctx:New('Frame', {
            Size = UDim2.fromOffset(12, 24),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0, 0.5),
        }, track)
        ctx:Paint(thumb, 'Accent')
        ctx:New('UICorner', { CornerRadius = UDim.new(0, 3) }, thumb)
        local valueBox = ctx:New('TextBox', {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.fromOffset(90, 22),
            BackgroundTransparency = 1,
            ClearTextOnFocus = false,
            ZIndex = 3,
        }, track)
        local control = register(
            ctx,
            options,
            { Value = Core.number(options.Default or minimum, minimum, maximum, step) or minimum }
        )
        function control:Refresh()
            local alpha = (self.Value - minimum) / (maximum - minimum)
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            thumb.Position = UDim2.new(alpha, 0, 0.5, 0)
            valueBox.Text = string.format('%.4f', self.Value):gsub('0+$', ''):gsub('%.$', '')
        end
        function control:Set(value, silent)
            value = Core.number(value, minimum, maximum, step)
            if not value then
                return false
            end
            local changed = self.Value ~= value
            self.Value = value
            self:Refresh()
            if changed and not silent then
                ctx:Callback(options.Callback, value)
            end
            return true
        end
        ctx:Pointer(track, function(pos)
            local alpha =
                math.clamp((pos.X - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
            control:Set(minimum + alpha * (maximum - minimum))
        end)
        ctx:Connect(valueBox.FocusLost, function()
            if not control:Set(valueBox.Text) then
                control:Refresh()
            end
        end)
        control:Refresh()
        return control
    end

    function section:RangeSlider(options)
        local minimum, maximum, step = options.Min or 0, options.Max or 100, options.Step or 1
        assert(
            type(minimum) == 'number' and type(maximum) == 'number' and maximum > minimum,
            'Range Max must exceed Min'
        )
        assert(type(step) == 'number' and step >= 0, 'Range Step must be nonnegative')
        local frame = row(ctx, body, options.Text or 'Range', 56, options.Description)
        local track = ctx:New(
            'Frame',
            { Position = UDim2.fromOffset(0, 32), Size = UDim2.new(1, 0, 0, 22), Active = true },
            frame
        )
        ctx:Paint(track, 'Field')
        ctx:Stroke(track)
        local fill = ctx:New('Frame', { BackgroundTransparency = 0.4 }, track)
        ctx:Paint(fill, 'Accent')
        local handles = {}
        for i = 1, 2 do
            handles[i] = ctx:New(
                'Frame',
                { Size = UDim2.fromOffset(12, 24), AnchorPoint = Vector2.new(0.5, 0.5) },
                track
            )
            ctx:Paint(handles[i], 'Accent')
            ctx:New('UICorner', { CornerRadius = UDim.new(0, 3) }, handles[i])
        end
        local inputs = {}
        for i = 1, 2 do
            inputs[i] = ctx:New('TextBox', {
                Position = UDim2.new(1, i == 1 and -142 or -68, 0, 0),
                Size = UDim2.fromOffset(68, 28),
                ClearTextOnFocus = false,
            }, frame)
            ctx:Paint(inputs[i], 'Field')
            ctx:Stroke(inputs[i])
        end
        local control = register(ctx, options, { Value = { minimum, maximum } })
        function control:Refresh()
            local a, b =
                (self.Value[1] - minimum) / (maximum - minimum),
                (self.Value[2] - minimum) / (maximum - minimum)
            fill.Position = UDim2.fromScale(a, 0)
            fill.Size = UDim2.new(b - a, 0, 1, 0)
            handles[1].Position = UDim2.fromScale(a, 0.5)
            handles[2].Position = UDim2.fromScale(b, 0.5)
            for i = 1, 2 do
                inputs[i].Text = string.format('%.4f', self.Value[i]):gsub('0+$', ''):gsub('%.$', '')
            end
        end
        function control:Set(value, silent)
            if type(value) ~= 'table' then
                return false
            end
            local a, b =
                Core.number(value[1], minimum, maximum, step), Core.number(value[2], minimum, maximum, step)
            if not a or not b then
                return false
            end
            self.Value = { math.min(a, b), math.max(a, b) }
            self:Refresh()
            if not silent then
                ctx:Callback(options.Callback, self:Get())
            end
            return true
        end
        control:Set(options.Default or { minimum, maximum }, true)
        local active
        ctx:Pointer(track, function(pos)
            local value = minimum
                + math.clamp((pos.X - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
                    * (maximum - minimum)
            if not active then
                active = math.abs(value - control.Value[1]) <= math.abs(value - control.Value[2]) and 1 or 2
            end
            local values = control:Get()
            values[active] = active == 1 and math.min(value, values[2]) or math.max(value, values[1])
            control:Set(values)
        end, function()
            active = nil
        end)
        for i = 1, 2 do
            ctx:Connect(inputs[i].FocusLost, function()
                local values = control:Get()
                values[i] = tonumber(inputs[i].Text)
                if not control:Set(values) then
                    control:Refresh()
                end
            end)
        end
        return control
    end

    function section:Dropdown(options)
        local entries = table.clone(options.Options or {})
        local allowed = {}
        for _, entry in ipairs(entries) do
            assert(type(entry) == 'string' and not allowed[entry], 'Dropdown options must be unique strings')
            allowed[entry] = true
        end
        local frame = row(ctx, body, options.Text or 'Select', nil, options.Description)
        local button = ctx:Button('', frame, fieldProps())
        button.TextTruncate = Enum.TextTruncate.AtEnd
        local control = register(ctx, options, { Value = options.Multi and {} or nil })
        function control:Refresh()
            button.Text = (
                options.Multi and (#self.Value > 0 and table.concat(self.Value, ', ') or 'None')
                or self.Value
                or 'Select'
            ) .. '  ▾'
        end
        function control:Set(value, silent)
            if options.Multi then
                if type(value) ~= 'table' then
                    return false
                end
                local selected = {}
                for _, v in ipairs(value) do
                    if not allowed[v] then
                        return false
                    end
                    selected[v] = true
                end
                value = {}
                for _, v in ipairs(entries) do
                    if selected[v] then
                        table.insert(value, v)
                    end
                end
            elseif value ~= nil and not allowed[value] then
                return false
            end
            self.Value = value
            self:Refresh()
            if not silent then
                ctx:Callback(options.Callback, self:Get())
            end
            return true
        end
        control:Set(options.Default or (options.Multi and {} or entries[1]), true)
        ctx:Connect(button.Activated, function()
            if ctx.PopupAnchor == button then
                ctx:ClosePopup()
                return
            end
            local searchHeight = #entries > 8 and 32 or 0
            local actionsHeight = options.Multi and 32 or 0
            local popup = ctx:OpenPopup(
                button,
                math.max(220, button.AbsoluteSize.X),
                math.min(290, #entries * 30 + searchHeight + actionsHeight + 12)
            )
            local list = ctx:New('ScrollingFrame', {
                Position = UDim2.fromOffset(6, 6 + searchHeight + actionsHeight),
                Size = UDim2.new(1, -12, 1, -12 - searchHeight - actionsHeight),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ScrollBarThickness = 3,
                ZIndex = 101,
            }, popup)
            ctx:Bind(list, 'ScrollBarImageColor3', 'Accent')
            ctx:List(list, 2)
            local rows, switches = {}, {}
            local function refreshRows()
                for v, b in pairs(rows) do
                    local selected = options.Multi and table.find(control.Value, v) ~= nil
                        or not options.Multi and control.Value == v
                    b.Text = '  ' .. v
                    ctx:Bind(b, 'TextColor3', selected and 'Accent' or 'Text')
                    if switches[v] then
                        ctx:Paint(switches[v][1], selected and 'Accent' or 'Field')
                        ctx:Paint(switches[v][2], selected and 'AccentText' or 'Muted')
                        switches[v][2].Position = UDim2.fromOffset(selected and 18 or 3, 3)
                    end
                end
            end
            for _, v in ipairs(entries) do
                local b = ctx:Button(
                    v,
                    list,
                    {
                        Size = UDim2.new(1, -4, 0, 28),
                        ZIndex = 102,
                        TextXAlignment = Enum.TextXAlignment.Left,
                    }
                )
                rows[v] = b
                if options.Multi then
                    local rail = ctx:New('Frame', {
                        AnchorPoint = Vector2.new(1, 0.5),
                        Position = UDim2.new(1, -6, 0.5, 0),
                        Size = UDim2.fromOffset(32, 18),
                        ZIndex = 103,
                    }, b)
                    ctx:Stroke(rail)
                    local thumb = ctx:New('Frame', { Size = UDim2.fromOffset(11, 12), ZIndex = 104 }, rail)
                    switches[v] = { rail, thumb }
                end
                ctx:Connect(b.Activated, function()
                    if options.Multi then
                        local values = control:Get()
                        local index = table.find(values, v)
                        if index then
                            table.remove(values, index)
                        else
                            table.insert(values, v)
                        end
                        control:Set(values)
                        refreshRows()
                    else
                        control:Set(v)
                        ctx:ClosePopup()
                    end
                end, ctx.PopupConnections)
            end
            if searchHeight > 0 then
                local search = ctx:New('TextBox', {
                    Position = UDim2.fromOffset(6, 6),
                    Size = UDim2.new(1, -12, 0, 28),
                    PlaceholderText = 'Search…',
                    Text = '',
                    ClearTextOnFocus = false,
                    ZIndex = 102,
                }, popup)
                ctx:Paint(search, 'Field')
                ctx:Stroke(search)
                ctx:Connect(search:GetPropertyChangedSignal('Text'), function()
                    local query = string.lower(search.Text)
                    for v, b in pairs(rows) do
                        b.Visible = string.find(string.lower(v), query, 1, true) ~= nil
                    end
                end, ctx.PopupConnections)
            end
            if options.Multi then
                local all = ctx:Button('Select all', popup, {
                    Position = UDim2.fromOffset(6, 6 + searchHeight),
                    Size = UDim2.new(0.5, -9, 0, 28),
                    ZIndex = 102,
                })
                local clear = ctx:Button('Clear', popup, {
                    Position = UDim2.new(0.5, 3, 0, 6 + searchHeight),
                    Size = UDim2.new(0.5, -9, 0, 28),
                    ZIndex = 102,
                })
                ctx:Connect(all.Activated, function()
                    control:Set(entries)
                    refreshRows()
                end, ctx.PopupConnections)
                ctx:Connect(clear.Activated, function()
                    control:Set({})
                    refreshRows()
                end, ctx.PopupConnections)
            end
            refreshRows()
        end)
        return control
    end

    function section:Keybind(options)
        local frame = row(ctx, body, options.Text or 'Keybind', nil, options.Description)
        local button = ctx:Button('', frame, fieldProps())
        local control = register(ctx, options, { Value = Enum.KeyCode.Unknown, OnPress = options.OnPress })
        function control:Refresh()
            button.Text = self.Value == Enum.KeyCode.Unknown and 'Unbound' or self.Value.Name
        end
        function control:Set(value, silent)
            if typeof(value) ~= 'EnumItem' or value.EnumType ~= Enum.KeyCode then
                return false
            end
            self.Value = value
            self:Refresh()
            if not silent then
                ctx:Callback(options.Callback, value)
            end
            return true
        end
        control:Set(options.Default or Enum.KeyCode.Unknown, true)
        ctx.Keybinds[control] = true
        ctx:Connect(button.Activated, function()
            button.Text = 'Press a key…'
            ctx.CaptureKey = function(key)
                control:Set(key == Enum.KeyCode.Escape and Enum.KeyCode.Unknown or key)
            end
        end)
        return control
    end

    function section:ColorPicker(options)
        local frame = row(ctx, body, options.Text or 'Color', nil, options.Description)
        local button = ctx:Button('', frame, fieldProps())
        local swatch =
            ctx:New('Frame', { Position = UDim2.fromOffset(5, 5), Size = UDim2.new(1, -10, 1, -10) }, button)
        local control = register(ctx, options, { Value = options.Default or ctx.Theme.Accent })
        function control:Refresh()
            swatch.BackgroundColor3 = self.Value
        end
        function control:Set(value, silent)
            if typeof(value) ~= 'Color3' then
                return false
            end
            self.Value = value
            self:Refresh()
            if not silent then
                ctx:Callback(options.Callback, value)
            end
            return true
        end
        control:Refresh()
        ctx:Connect(button.Activated, function()
            if ctx.PopupAnchor == button then
                ctx:ClosePopup()
                return
            end
            local popup = ctx:OpenPopup(button, 242, 240)
            local hue, sat, val = control.Value:ToHSV()
            local square = ctx:New('Frame', {
                Position = UDim2.fromOffset(10, 10),
                Size = UDim2.new(1, -20, 0, 166),
                Active = true,
                ZIndex = 101,
            }, popup)
            local white = ctx:New(
                'Frame',
                { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(1, 1, 1), ZIndex = 102 },
                square
            )
            ctx:New('UIGradient', { Transparency = NumberSequence.new(0, 1) }, white)
            local black = ctx:New(
                'Frame',
                { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), ZIndex = 103 },
                square
            )
            ctx:New('UIGradient', { Rotation = 90, Transparency = NumberSequence.new(1, 0) }, black)
            local cursor = ctx:New('Frame', {
                Size = UDim2.fromOffset(7, 7),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 104,
            }, square)
            ctx:Stroke(cursor)
            local strip = ctx:New('Frame', {
                Position = UDim2.fromOffset(10, 185),
                Size = UDim2.new(1, -20, 0, 16),
                BackgroundColor3 = Color3.new(1, 1, 1),
                Active = true,
                ZIndex = 101,
            }, popup)
            local colors = {}
            for i = 0, 6 do
                table.insert(colors, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)))
            end
            ctx:New('UIGradient', { Color = ColorSequence.new(colors) }, strip)
            local hueMarker = ctx:New('Frame', {
                Size = UDim2.fromOffset(3, 20),
                AnchorPoint = Vector2.new(0.5, 0),
                BackgroundColor3 = Color3.new(1, 1, 1),
                ZIndex = 102,
            }, strip)
            local hex = ctx:New('TextBox', {
                Position = UDim2.fromOffset(10, 207),
                Size = UDim2.new(1, -20, 0, 25),
                BackgroundTransparency = 1,
                ClearTextOnFocus = false,
                ZIndex = 102,
            }, popup)
            local function refresh()
                square.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                cursor.Position = UDim2.fromScale(sat, 1 - val)
                hueMarker.Position = UDim2.new(hue, 0, 0, -2)
                hex.Text = '#' .. control.Value:ToHex()
            end
            ctx:Pointer(square, function(pos)
                sat =
                    math.clamp((pos.X - square.AbsolutePosition.X) / math.max(1, square.AbsoluteSize.X), 0, 1)
                val = 1
                    - math.clamp(
                        (pos.Y - square.AbsolutePosition.Y) / math.max(1, square.AbsoluteSize.Y),
                        0,
                        1
                    )
                control:Set(Color3.fromHSV(hue, sat, val))
                refresh()
            end, nil, ctx.PopupConnections)
            ctx:Pointer(strip, function(pos)
                hue = math.clamp((pos.X - strip.AbsolutePosition.X) / math.max(1, strip.AbsoluteSize.X), 0, 1)
                control:Set(Color3.fromHSV(hue, sat, val))
                refresh()
            end, nil, ctx.PopupConnections)
            ctx:Connect(hex.FocusLost, function()
                local value = hex.Text:gsub('^#', '')
                if #value == 6 and value:match('^%x+$') then
                    control:Set(Color3.fromHex(value))
                    hue, sat, val = control.Value:ToHSV()
                end
                refresh()
            end, ctx.PopupConnections)
            refresh()
        end)
        return control
    end
    return section
end
return Components
