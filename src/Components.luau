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
    control.Changed = {}
    local original = options.Callback
    options.Callback = function(value)
        ctx:Callback(original, value)
        for _, callback in ipairs(control.Changed) do
            ctx:Callback(callback, value)
        end
    end
    if options.Id then
        assert(type(options.Id) == 'string' and #options.Id > 0, 'Id must be a nonempty string')
        assert(
            not ctx.Controls[options.Id]
                and (
                    not ctx.Library
                    or not (ctx.Library.Toggles[options.Id] or ctx.Library.Options[options.Id])
                ),
            'Duplicate control Id: ' .. options.Id
        )
        ctx.Controls[options.Id] = control
        if ctx.Library then
            local registry = type(control.Value) == 'boolean' and ctx.Library.Toggles or ctx.Library.Options
            registry[options.Id] = control
        end
    end
    function control:Get()
        return type(self.Value) == 'table' and table.clone(self.Value) or self.Value
    end
    function control:SetValue(value)
        return self:Set(value)
    end
    function control:OnChanged(callback)
        assert(type(callback) == 'function', 'Expected callback')
        table.insert(self.Changed, callback)
        return self
    end
    return control
end
local function row(ctx, parent, text, height, description)
    local frame = ctx:New('Frame', {
        Name = text,
        Size = UDim2.new(1, 0, 0, height or (ctx.Touch and 42 or 36)),
        BackgroundTransparency = 1,
    }, parent)
    ctx:Text(text, frame, {
        Position = UDim2.fromOffset(description and 22 or 0, 4),
        Size = UDim2.new(1, description and -112 or -90, 0, 28),
        TextSize = 13,
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    if description then
        local info = ctx:Button('i', frame, {
            Position = UDim2.fromOffset(0, 10),
            Size = UDim2.fromOffset(15, 15),
            TextSize = 10,
            ZIndex = 5,
            BackgroundTransparency = 0.5,
        })
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
    return { Position = UDim2.new(0.44, 0, 0, 3), Size = UDim2.new(0.56, 0, 0, 30) }
end
local function aliasOptions(id, options)
    options = table.clone(options or {})
    options.Id = id
    options.Description = options.Description or options.Tooltip
    if options.Rounding and not options.Step then
        options.Step = 10 ^ -options.Rounding
    end
    options.Options = options.Options or options.Values
    if options.Options and type(options.Default) == 'number' then
        options.Default = options.Options[options.Default]
    end
    if options.Multi and type(options.Default) == 'string' then
        options.Default = { options.Default }
    end
    return options
end
function Components.section(ctx, parent, title)
    local root = ctx:New(
        'Frame',
        { Name = title, Size = UDim2.new(1, -4, 0, 0), AutomaticSize = Enum.AutomaticSize.Y },
        parent
    )
    ctx:Paint(root, 'Panel')
    ctx:List(root, 0)
    local heading = ctx:New('TextButton', {
        Name = 'GroupHeading',
        Text = title,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundTransparency = 1,
    }, root)
    ctx:Padding(heading, 11)
    ctx:Bind(heading, 'TextColor3', 'Text')
    local symbol = ctx:New('Frame', {
        Name = 'CollapseIcon',
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(1, -17, 0.5, 0),
        Size = UDim2.fromOffset(10, 10),
        BackgroundTransparency = 1,
    }, heading)
    local minus =
        ctx:New('Frame', { Position = UDim2.fromOffset(0, 4), Size = UDim2.fromOffset(10, 2) }, symbol)
    local plus = ctx:New(
        'Frame',
        { Position = UDim2.fromOffset(4, 0), Size = UDim2.fromOffset(2, 10), Visible = false },
        symbol
    )
    ctx:Paint(minus, 'Text')
    ctx:Paint(plus, 'Text')
    local line =
        ctx:New('Frame', { Position = UDim2.fromOffset(12, 37), Size = UDim2.new(1, -24, 0, 1) }, root)
    ctx:Paint(line, 'Border')
    line.BackgroundTransparency = 0.55
    -- The divider belongs inside the heading so the group's vertical layout has only two items.
    line.Parent = heading
    local body = ctx:New('Frame', {
        Name = 'Content',
        LayoutOrder = 1,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
    }, root)
    ctx:Padding(body, 12)
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
        line.Visible = self.Expanded
        plus.Visible = not self.Expanded
    end
    ctx:Connect(heading.Activated, function()
        section:SetExpanded(not section.Expanded)
    end)
    function section:Label(text)
        return ctx:Text(text, body, {
            Name = text,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            TextColor3 = ctx.Theme.Muted,
            TextSize = 12,
        })
    end
    function section:Button(options)
        local button = ctx:Button(options.Text or 'Button', body, {
            Name = options.Text or 'Button',
            Size = UDim2.new(1, 0, 0, ctx.Touch and 40 or 34),
            TextSize = 13,
        })
        if options.Primary then
            ctx:Paint(button, 'Hover')
            for _, child in ipairs(button:GetChildren()) do
                if child:IsA('UIStroke') then
                    ctx:Bind(child, 'Color', 'Accent')
                    child.Transparency = 0.45
                end
            end
            local marker = ctx:New(
                'Frame',
                { Position = UDim2.fromOffset(12, 11), Size = UDim2.fromOffset(3, 12) },
                button
            )
            ctx:Paint(marker, 'Accent')
            ctx:Corner(marker, 2)
        end
        ctx:Connect(button.Activated, function()
            ctx:Callback(options.Callback or options.Func)
        end)
        return button
    end
    local function attachments(owner)
        owner.Slots = owner.RightInset or 0
        function owner:AddKeyPicker(id, settings)
            settings = aliasOptions(id, settings)
            settings._Host = self.Root
            self.Slots += 70
            settings._Offset = self.Slots
            settings.SyncOwner = self
            settings.ActivationCallback = settings.Callback
            settings.Callback = settings.ChangedCallback
            local binding = section:Keybind(settings)
            if settings.SyncToggleState and self.OnChanged then
                binding.State = self.Value
                self:OnChanged(function(value)
                    binding.State = value
                    if ctx.UpdateKeybinds then
                        ctx.UpdateKeybinds()
                    end
                end)
            end
            if ctx.UpdateKeybinds then
                ctx.UpdateKeybinds()
            end
            local label = self.Root:FindFirstChildWhichIsA('TextLabel')
            if label then
                label.Size = UDim2.new(1, -self.Slots - 12, 0, 28)
            end
            return binding
        end
        function owner:AddColorPicker(id, settings)
            settings = aliasOptions(id, settings)
            settings._Host = self.Root
            self.Slots += 32
            settings._Offset = self.Slots
            local label = self.Root:FindFirstChildWhichIsA('TextLabel')
            if label then
                label.Size = UDim2.new(1, -self.Slots - 12, 0, 28)
            end
            return section:ColorPicker(settings)
        end
        return owner
    end
    function section:Toggle(options)
        local frame = row(ctx, body, options.Text or 'Toggle', nil, options.Description)
        local button = ctx:New('TextButton', {
            Text = '',
            Position = UDim2.new(1, -38, 0, 8),
            Size = UDim2.fromOffset(38, 20),
            BackgroundTransparency = 1,
        }, frame)
        local rail = ctx:New('Frame', { Size = UDim2.fromScale(1, 1) }, button)
        ctx:Corner(rail, 10)
        ctx:Stroke(rail)
        ctx:Gradient(rail)
        local thumb =
            ctx:New('Frame', { Position = UDim2.fromOffset(4, 4), Size = UDim2.fromOffset(12, 12) }, rail)
        ctx:Corner(thumb, 6)
        ctx:Gradient(thumb)
        local control =
            register(ctx, options, { Value = options.Default == true, Root = frame, RightInset = 48 })
        function control:Refresh()
            ctx.Bindings[rail] = { BackgroundColor3 = self.Value and 'Hover' or 'Field' }
            ctx.Bindings[thumb] = { BackgroundColor3 = self.Value and 'Accent' or 'Text' }
            ctx:Animate(rail, { BackgroundColor3 = ctx.Theme[self.Value and 'Hover' or 'Field'] }, 0.32)
            ctx:Animate(thumb, {
                Position = UDim2.fromOffset(self.Value and 22 or 4, 4),
                BackgroundColor3 = ctx.Theme[self.Value and 'Accent' or 'Text'],
                BackgroundTransparency = self.Value and 0 or 0.5,
            }, 0.32)
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
        return attachments(control)
    end
    function section:Textbox(options)
        local frame = row(ctx, body, options.Text or 'Text', ctx.Touch and 44 or 38, options.Description)
        local props = fieldProps()
        props.Text = tostring(options.Default or '')
        props.ClearTextOnFocus = false
        props.PlaceholderText = options.Placeholder or ''
        local input = ctx:New('TextBox', props, frame)
        ctx:Paint(input, 'Field')
        ctx:Corner(input, 6)
        ctx:Stroke(input)
        local control = register(ctx, options, { Value = props.Text, Root = frame })
        function control:Set(value, silent)
            if type(value) ~= 'string' or options.Numeric and not tonumber(value) then
                return false
            end
            if options.MaxLength then
                value = value:sub(1, options.MaxLength)
            end
            local changed = self.Value ~= value
            self.Value = value
            input.Text = value
            if changed and not silent then
                ctx:Callback(options.Callback, value)
            end
            return true
        end
        ctx:Connect(input.FocusLost, function()
            if not control:Set(input.Text) then
                input.Text = control.Value
            end
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
        local frame = row(ctx, body, options.Text or 'Slider', ctx.Touch and 62 or 56, options.Description)
        local hit = ctx:New('Frame', {
            Position = UDim2.fromOffset(0, 28),
            Size = UDim2.new(1, 0, 0, 22),
            BackgroundTransparency = 1,
            Active = true,
        }, frame)
        local track =
            ctx:New('Frame', { Position = UDim2.fromOffset(0, 7), Size = UDim2.new(1, 0, 0, 8) }, hit)
        ctx:Paint(track, 'Field')
        ctx:Corner(track, 4)
        local fill = ctx:New('Frame', { Size = UDim2.new() }, track)
        ctx:Paint(fill, 'Accent')
        ctx:Gradient(fill)
        local thumb =
            ctx:New('Frame', { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(12, 12) }, track)
        ctx:Paint(thumb, 'Accent')
        ctx:Corner(thumb, 6)
        local valueBox = ctx:New('TextBox', {
            Position = UDim2.new(1, -62, 0, 3),
            Size = UDim2.fromOffset(62, 24),
            BackgroundTransparency = 0,
            ClearTextOnFocus = false,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextSize = 12,
        }, frame)
        ctx:Paint(valueBox, 'Field')
        ctx:Corner(valueBox, 6)
        ctx:Bind(valueBox, 'TextColor3', 'Text')
        local control = register(ctx, options, {
            Value = Core.number(options.Default or minimum, minimum, maximum, step) or minimum,
            Root = frame,
        })
        function control:Refresh()
            local alpha = (self.Value - minimum) / (maximum - minimum)
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            thumb.Position = UDim2.new(alpha, 0, 0.5, 0)
            valueBox.Text = string.format('%.4f', self.Value):gsub('0+$', ''):gsub('%.$', '')
                .. (options.Suffix or '')
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
        ctx:Pointer(hit, function(pos)
            local alpha = math.clamp((pos.X - hit.AbsolutePosition.X) / math.max(1, hit.AbsoluteSize.X), 0, 1)
            control:Set(minimum + alpha * (maximum - minimum))
        end)
        ctx:Connect(valueBox.FocusLost, function()
            local value = valueBox.Text
            if options.Suffix and #options.Suffix > 0 and value:sub(-#options.Suffix) == options.Suffix then
                value = value:sub(1, -#options.Suffix - 1)
            end
            if not control:Set(value) then
                control:Refresh()
            end
        end)
        control:Refresh()
        return control
    end
    function section:RangeSlider(options)
        local minimum, maximum, step = options.Min or 0, options.Max or 100, options.Step or 1
        assert(maximum > minimum and step >= 0, 'Invalid range')
        local frame = row(ctx, body, options.Text or 'Range', 58, options.Description)
        local track = ctx:New(
            'Frame',
            { Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 0, 8), Active = true },
            frame
        )
        ctx:Paint(track, 'Field')
        ctx:Corner(track, 4)
        local fill = ctx:New('Frame', {}, track)
        ctx:Paint(fill, 'Accent')
        ctx:Gradient(fill)
        local handles = {}
        for i = 1, 2 do
            handles[i] = ctx:New(
                'Frame',
                { Size = UDim2.fromOffset(12, 12), AnchorPoint = Vector2.new(0.5, 0.5) },
                track
            )
            ctx:Paint(handles[i], 'Accent')
            ctx:Corner(handles[i], 6)
        end
        local inputs = {}
        for i = 1, 2 do
            inputs[i] = ctx:New('TextBox', {
                Position = UDim2.new(1, i == 1 and -112 or -54, 0, 0),
                Size = UDim2.fromOffset(48, 24),
                ClearTextOnFocus = false,
                BackgroundTransparency = 1,
                TextSize = 11,
            }, frame)
            ctx:Bind(inputs[i], 'TextColor3', 'Muted')
        end
        local control = register(ctx, options, { Value = { minimum, maximum }, Root = frame })
        function control:Refresh()
            local a, b =
                (self.Value[1] - minimum) / (maximum - minimum),
                (self.Value[2] - minimum) / (maximum - minimum)
            fill.Position = UDim2.fromScale(a, 0)
            fill.Size = UDim2.new(b - a, 0, 1, 0)
            handles[1].Position = UDim2.fromScale(a, 0.5)
            handles[2].Position = UDim2.fromScale(b, 0.5)
            for i = 1, 2 do
                inputs[i].Text = string.format('%.3f', self.Value[i]):gsub('0+$', ''):gsub('%.$', '')
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
        local active
        ctx:Pointer(track, function(pos)
            local v = minimum
                + math.clamp((pos.X - track.AbsolutePosition.X) / math.max(1, track.AbsoluteSize.X), 0, 1)
                    * (maximum - minimum)
            if not active then
                active = math.abs(v - control.Value[1]) <= math.abs(v - control.Value[2]) and 1 or 2
            end
            local values = control:Get()
            values[active] = active == 1 and math.min(v, values[2]) or math.max(v, values[1])
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
        control:Set(options.Default or { minimum, maximum }, true)
        return control
    end
    function section:Dropdown(options)
        local entries, allowed = {}, {}
        local frame = row(ctx, body, options.Text or 'Select', ctx.Touch and 44 or 38, options.Description)
        local button = ctx:Button('', frame, fieldProps())
        button.TextTruncate = Enum.TextTruncate.AtEnd
        button.TextSize = 12
        button.TextXAlignment = Enum.TextXAlignment.Left
        ctx:Padding(button, 10)
        local control = register(ctx, options, { Value = options.Multi and {} or nil, Root = frame })
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
                for k, v in pairs(value) do
                    local name = type(k) == 'string' and v == true and k or v
                    if not allowed[name] then
                        return false
                    end
                    selected[name] = true
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
        function control:SetValues(values)
            local nextEntries, nextAllowed = {}, {}
            for _, v in ipairs(values) do
                assert(type(v) == 'string' and not nextAllowed[v], 'Dropdown options must be unique strings')
                nextAllowed[v] = true
                table.insert(nextEntries, v)
            end
            entries, allowed = nextEntries, nextAllowed
            if options.Multi then
                local keep = {}
                for _, v in ipairs(self.Value) do
                    if allowed[v] then
                        table.insert(keep, v)
                    end
                end
                self:Set(keep, true)
            elseif not allowed[self.Value] then
                self:Set(entries[1], true)
            else
                self:Refresh()
            end
        end
        control:SetValues(options.Options or {})
        control:Set(options.Default or (options.Multi and {} or entries[1]), true)
        ctx:Connect(button.Activated, function()
            if ctx.PopupAnchor == button then
                ctx:ClosePopup()
                return
            end
            local searchHeight = #entries > 8 and 32 or 0
            local actionsHeight = options.Multi and 30 or 0
            local popup = ctx:OpenPopup(
                button,
                math.max(220, button.AbsoluteSize.X),
                math.min(300, #entries * 27 + searchHeight + actionsHeight + 12)
            )
            local list = ctx:New('ScrollingFrame', {
                Position = UDim2.fromOffset(6, 6 + searchHeight + actionsHeight),
                Size = UDim2.new(1, -12, 1, -12 - searchHeight - actionsHeight),
                CanvasSize = UDim2.new(),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ScrollBarThickness = 0,
                ZIndex = 101,
            }, popup)
            ctx:List(list, 2)
            ctx:Bind(list, 'ScrollBarImageColor3', 'Accent')
            ctx:Connect(list:GetPropertyChangedSignal('CanvasPosition'), function()
                list.ScrollBarThickness = 2
            end, ctx.PopupConnections)
            local rows = {}
            local function refresh()
                for value, b in pairs(rows) do
                    local selected = options.Multi and table.find(control.Value, value) ~= nil
                        or not options.Multi and control.Value == value
                    b.Text = '  ' .. value
                    ctx:Paint(b, selected and 'Hover' or 'Field')
                    b.BackgroundTransparency = selected and 0 or 0.6
                    b.TextTransparency = selected and 0 or 0.35
                    for _, child in ipairs(b:GetChildren()) do
                        if child:IsA('UIStroke') then
                            ctx:Bind(child, 'Color', selected and 'Accent' or 'Border')
                            child.Transparency = selected and 0.45 or 1
                        end
                    end
                end
            end
            for _, value in ipairs(entries) do
                local b = ctx:Button(value, list, {
                    Size = UDim2.new(1, -3, 0, 25),
                    ZIndex = 102,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                })
                rows[value] = b
                ctx:Connect(b.Activated, function()
                    if options.Multi then
                        local values = control:Get()
                        local index = table.find(values, value)
                        if index then
                            table.remove(values, index)
                        else
                            table.insert(values, value)
                        end
                        control:Set(values)
                        refresh()
                    else
                        control:Set(value)
                        ctx:ClosePopup()
                    end
                end, ctx.PopupConnections)
            end
            if searchHeight > 0 then
                local search = ctx:New('TextBox', {
                    Position = UDim2.fromOffset(6, 6),
                    Size = UDim2.new(1, -12, 0, 26),
                    PlaceholderText = 'Search…',
                    Text = '',
                    ClearTextOnFocus = false,
                    ZIndex = 102,
                }, popup)
                ctx:Paint(search, 'Field')
                ctx:Stroke(search)
                ctx:Connect(search:GetPropertyChangedSignal('Text'), function()
                    for value, b in pairs(rows) do
                        b.Visible = string.find(string.lower(value), string.lower(search.Text), 1, true)
                            ~= nil
                    end
                end, ctx.PopupConnections)
            end
            if options.Multi then
                local a = ctx:Button('Select all', popup, {
                    Position = UDim2.fromOffset(6, 6 + searchHeight),
                    Size = UDim2.new(0.5, -9, 0, 25),
                    ZIndex = 102,
                })
                local b = ctx:Button('Clear', popup, {
                    Position = UDim2.new(0.5, 3, 0, 6 + searchHeight),
                    Size = UDim2.new(0.5, -9, 0, 25),
                    ZIndex = 102,
                })
                ctx:Connect(a.Activated, function()
                    control:Set(entries)
                    refresh()
                end, ctx.PopupConnections)
                ctx:Connect(b.Activated, function()
                    control:Set({})
                    refresh()
                end, ctx.PopupConnections)
            end
            refresh()
        end)
        return control
    end
    function section:Keybind(options)
        local frame = options._Host or row(ctx, body, options.Text or 'Keybind', nil, options.Description)
        local button = ctx:Button('', frame, {
            Name = 'Keybind',
            Position = UDim2.new(1, -(options._Offset or 68), 0, 7),
            Size = UDim2.fromOffset(66, 24),
            TextSize = 11,
        })
        local control = register(ctx, options, {
            Value = Enum.KeyCode.Unknown,
            Root = frame,
            Button = button,
            Mode = options.Mode or 'Toggle',
            State = options.Mode == 'Always',
            Name = options.Text or (options.SyncOwner and options.SyncOwner.Root.Name) or 'Keybind',
            HideFromList = options.HideFromList == true or options.NoModes == true,
            NoModes = options.NoModes == true,
            OnPress = options.OnPress,
        })
        function control:Refresh()
            local names = {
                MouseButton1 = 'MB1',
                MouseButton2 = 'MB2',
                Unknown = 'None',
                LeftShift = 'LShift',
                RightShift = 'RShift',
                LeftControl = 'LCtrl',
                RightControl = 'RCtrl',
            }
            self.KeyName = names[self.Value.Name] or self.Value.Name
            button.Text = self.KeyName
            if ctx.UpdateKeybinds then
                ctx.UpdateKeybinds()
            end
        end
        function control:GetState()
            return self.State
        end
        function control:SetState(value)
            local changed = self.State ~= value
            self.State = value
            if changed then
                if options.SyncToggleState and options.SyncOwner and options.SyncOwner.Set then
                    options.SyncOwner:Set(value)
                end
                ctx:Callback(options.ActivationCallback, value)
            end
            if ctx.UpdateKeybinds then
                ctx.UpdateKeybinds()
            end
        end
        function control:SetMode(mode, silent)
            if self.NoModes then
                return false
            end
            if type(mode) ~= 'string' then
                return false
            end
            mode = mode:sub(1, 1):upper() .. mode:sub(2):lower()
            if mode ~= 'Hold' and mode ~= 'Toggle' and mode ~= 'Always' then
                return false
            end
            if self.Mode == mode then
                return true
            end
            self.Mode = mode
            if not silent then
                self:SetState(mode == 'Always')
                ctx:Callback(options.ModeChangedCallback, mode)
            end
            self:Refresh()
            return true
        end
        function control:Set(value, silent)
            if type(value) == 'string' then
                local aliases = {
                    MB1 = 'MouseButton1',
                    MB2 = 'MouseButton2',
                    LShift = 'LeftShift',
                    RShift = 'RightShift',
                }
                local name = aliases[value] or value:gsub('%s+', '')
                local ok, key = pcall(function()
                    return name == 'MouseButton1' and Enum.UserInputType.MouseButton1
                        or name == 'MouseButton2' and Enum.UserInputType.MouseButton2
                        or Enum.KeyCode[name]
                end)
                value = ok and key or nil
            end
            if
                typeof(value) ~= 'EnumItem'
                or (
                    value.EnumType ~= Enum.KeyCode
                    and value ~= Enum.UserInputType.MouseButton1
                    and value ~= Enum.UserInputType.MouseButton2
                )
            then
                return false
            end
            if self.Mode == 'Hold' and self.State and value ~= self.Value then
                self:SetState(false)
            end
            self.Value = value
            self:Refresh()
            if not silent then
                ctx:Callback(options.Callback, value)
            end
            return true
        end
        function control:Activate(down)
            if self.Mode == 'Hold' then
                self:SetState(down)
            elseif self.Mode == 'Toggle' and down then
                self:SetState(not self.State)
            elseif self.Mode == 'Always' then
                self:SetState(true)
            end
            if down then
                ctx:Callback(self.OnPress)
            end
        end
        assert(
            control.Mode == 'Hold' or control.Mode == 'Toggle' or control.Mode == 'Always',
            'Invalid keybind mode'
        )
        control:Set(options.Default or Enum.KeyCode.Unknown, true)
        ctx.Keybinds[control] = true
        ctx:Connect(button.Activated, function()
            ctx:ClosePopup()
            button.Text = '…'
            ctx.CaptureKey = function(key)
                control:Set(key == Enum.KeyCode.Escape and Enum.KeyCode.Unknown or key)
            end
        end)
        ctx:Connect(button.InputBegan, function(input)
            if
                input.UserInputType ~= Enum.UserInputType.MouseButton2
                or control.NoModes
                or ctx.MenuClosing
            then
                return
            end
            ctx.CaptureKey = nil
            control:Refresh()
            if ctx.PopupAnchor == button then
                ctx:ClosePopup()
                return
            end
            local popup = ctx:OpenPopup(button, 132, 102)
            ctx:Padding(popup, 6)
            ctx:List(popup, 3)
            for _, mode in ipairs({ 'Hold', 'Toggle', 'Always' }) do
                local item = ctx:Button(mode, popup, { Size = UDim2.new(1, 0, 0, 28), ZIndex = 102 })
                ctx:Paint(item, control.Mode == mode and 'Hover' or 'Field')
                item.TextTransparency = control.Mode == mode and 0 or 0.3
                ctx:Connect(item.Activated, function()
                    control:SetMode(mode)
                    ctx:ClosePopup()
                end, ctx.PopupConnections)
            end
        end)
        if ctx.UpdateKeybinds then
            ctx.UpdateKeybinds()
        end
        return control
    end
    function section:AddToggle(id, options)
        return self:Toggle(aliasOptions(id, options))
    end
    function section:AddSlider(id, options)
        return self:Slider(aliasOptions(id, options))
    end
    function section:AddRangeSlider(id, options)
        return self:RangeSlider(aliasOptions(id, options))
    end
    function section:AddDropdown(id, options)
        return self:Dropdown(aliasOptions(id, options))
    end
    function section:AddInput(id, options)
        return self:Textbox(aliasOptions(id, options))
    end
    function section:AddButton(options, callback)
        if type(options) == 'string' then
            options = { Text = options, Callback = callback }
        end
        return self:Button(options)
    end
    function section:AddLabel(text)
        local frame = row(ctx, body, text)
        local label = frame:FindFirstChildWhichIsA('TextLabel')
        local owner = attachments({ Root = frame })
        function owner:SetText(value)
            label.Text = value
        end
        return owner
    end
    function section:AddDivider()
        local line = ctx:New('Frame', { Size = UDim2.new(1, 0, 0, 1) }, body)
        ctx:Paint(line, 'Border')
        return line
    end
    function section:ColorPicker(options)
        local frame = options._Host or row(ctx, body, options.Text or 'Color', 36, options.Description)
        local button = ctx:Button(
            '',
            frame,
            { Position = UDim2.new(1, -(options._Offset or 28), 0, 6), Size = UDim2.fromOffset(24, 24) }
        )
        button.BackgroundTransparency = 1
        for _, child in ipairs(button:GetChildren()) do
            child:Destroy()
        end
        local swatch = ctx:New('Frame', { Name = 'Swatch', Size = UDim2.fromScale(1, 1) }, button)
        ctx:New('UICorner', { CornerRadius = UDim.new(0, 4) }, swatch)
        local control = register(
            ctx,
            options,
            { Value = options.Default or ctx.Theme.Accent, ThemeRole = options.ThemeRole, Root = frame }
        )
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
