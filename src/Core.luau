local UIS = game:GetService('UserInputService')
local Tween = game:GetService('TweenService')
local Core = {}
Core.Theme = {
    Background = Color3.fromRGB(10, 14, 16),
    Panel = Color3.fromRGB(16, 22, 25),
    Field = Color3.fromRGB(24, 32, 36),
    Border = Color3.fromRGB(37, 49, 52),
    Text = Color3.fromRGB(230, 240, 235),
    Muted = Color3.fromRGB(123, 139, 130),
    Accent = Color3.fromRGB(107, 230, 180),
    AccentText = Color3.fromRGB(10, 30, 22),
    Hover = Color3.fromRGB(33, 44, 47),
    White = Color3.new(1, 1, 1),
}
function Core.number(value, min, max, step)
    value = tonumber(value)
    if not value or value ~= value or math.abs(value) == math.huge then
        return nil
    end
    value = math.clamp(value, min, max)
    if step and step > 0 then
        value = math.clamp(min + math.floor((value - min) / step + 0.5) * step, min, max)
    end
    return value
end
function Core.new(parent, options)
    local self = {
        Parent = parent,
        Theme = table.clone(Core.Theme),
        Connections = {},
        Bindings = setmetatable({}, { __mode = 'k' }),
        Controls = {},
        Keybinds = {},
        Animations = true,
        Destroyed = false,
        Library = options._Library,
        Touch = options.Touch == true or UIS.TouchEnabled == true,
        ActiveTweens = setmetatable({}, { __mode = 'k' }),
    }
    for key, value in pairs(options.Theme or {}) do
        if self.Theme[key] and typeof(value) == 'Color3' then
            self.Theme[key] = value
        end
    end
    function self:Connect(signal, callback, bucket)
        local c = signal:Connect(callback)
        table.insert(bucket or self.Connections, c)
        return c
    end
    function self:Bind(node, property, role)
        if property == 'TextColor3' then
            node.TextTransparency = role == 'Muted' and 0.3 or 0
            role = 'Text'
        elseif property == 'PlaceholderColor3' then
            role = 'Text'
        end
        self.Bindings[node] = self.Bindings[node] or {}
        self.Bindings[node][property] = role
        node[property] = self.Theme[role]
        return node
    end
    function self:New(class, props, parent)
        local n = Instance.new(class)
        if n:IsA('GuiObject') then
            n.BorderSizePixel = 0
        end
        if n:IsA('TextLabel') or n:IsA('TextButton') or n:IsA('TextBox') then
            n.Font = Enum.Font.Roboto
            n.TextSize = self.Touch and 14 or 13
            self:Bind(n, 'TextColor3', 'Text')
        end
        if n:IsA('TextButton') then
            n.AutoButtonColor = false
        end
        for k, v in pairs(props or {}) do
            n[k] = v
        end
        if n:IsA('TextLabel') or n:IsA('TextButton') or n:IsA('TextBox') then
            self:Bind(n, 'TextColor3', 'Text')
            if props and props.TextTransparency then
                n.TextTransparency = props.TextTransparency
            end
            if n:IsA('TextBox') then
                self:Bind(n, 'PlaceholderColor3', 'Text')
            end
        end
        n.Parent = parent
        return n
    end
    function self:Stroke(node)
        local s = self:New('UIStroke', { Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, node)
        self:Bind(s, 'Color', 'Border')
        return s
    end
    function self:Corner(node, radius)
        -- All controls are square; color swatches opt into their own small radius.
        return nil
    end
    function self:Gradient(node)
        return self:New('UIGradient', {
            Rotation = 90,
            Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(190, 211, 202)),
        }, node)
    end
    function self:Paint(node, role)
        return self:Bind(node, 'BackgroundColor3', role)
    end
    function self:Text(text, parent, props)
        local p = {
            BackgroundTransparency = 1,
            Text = text,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, 0, 0, 24),
        }
        for k, v in pairs(props or {}) do
            p[k] = v
        end
        return self:New('TextLabel', p, parent)
    end
    function self:Button(text, parent, props)
        local p = { Text = text, Size = UDim2.new(0, 120, 0, 28) }
        for k, v in pairs(props or {}) do
            p[k] = v
        end
        local b = self:New('TextButton', p, parent)
        self:Paint(b, 'Field')
        self:Stroke(b)
        for _, child in ipairs(b:GetChildren()) do
            if child:IsA('UIStroke') then
                child.Transparency = 0.65
            end
        end
        self:Corner(b, 6)
        self:Gradient(b)
        local bucket
        local ancestor = parent
        while ancestor do
            if ancestor == self.Popup then
                bucket = self.PopupConnections
                break
            end
            ancestor = ancestor.Parent
        end
        self:Connect(b.MouseEnter, function()
            self:Animate(b, { BackgroundColor3 = self.Theme.Hover })
        end, bucket)
        self:Connect(b.MouseLeave, function()
            local role = self.Bindings[b] and self.Bindings[b].BackgroundColor3 or 'Field'
            self:Animate(b, { BackgroundColor3 = self.Theme[role] })
        end, bucket)
        return b
    end
    function self:List(parent, padding, horizontal)
        return self:New('UIListLayout', {
            Padding = UDim.new(0, padding or 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
        }, parent)
    end
    function self:Padding(parent, n)
        self:New('UIPadding', {
            PaddingTop = UDim.new(0, n),
            PaddingBottom = UDim.new(0, n),
            PaddingLeft = UDim.new(0, n),
            PaddingRight = UDim.new(0, n),
        }, parent)
    end
    function self:Animate(node, props, duration)
        if self.Destroyed then
            return
        end
        if not self.Animations then
            if self.ActiveTweens[node] then
                self.ActiveTweens[node]:Cancel()
                self.ActiveTweens[node] = nil
            end
            for k, v in pairs(props) do
                node[k] = v
            end
            return
        end
        if self.ActiveTweens[node] then
            self.ActiveTweens[node]:Cancel()
        end
        local tween = Tween:Create(
            node,
            TweenInfo.new(duration or 0.24, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
            props
        )
        self.ActiveTweens[node] = tween
        tween:Play()
    end
    function self:Callback(callback, ...)
        if not callback then
            return
        end
        local ok, err = pcall(callback, ...)
        if not ok then
            warn('[MintProject callback] ' .. tostring(err))
        end
    end
    function self:ClosePopup()
        if self.Popup then
            for node, tween in pairs(self.ActiveTweens) do
                local ancestor = node
                while ancestor do
                    if ancestor == self.Popup then
                        tween:Cancel()
                        self.ActiveTweens[node] = nil
                        break
                    end
                    ancestor = ancestor.Parent
                end
            end
            self.Drag = nil
            self.DragInput = nil
            self.DragMouse = nil
            self.DragEnd = nil
        end
        if self.PopupConnections then
            for _, c in ipairs(self.PopupConnections) do
                c:Disconnect()
            end
        end
        self.PopupConnections = {}
        if self.Popup then
            self.Popup:Destroy()
        end
        self.Popup = nil
        self.PopupAnchor = nil
    end
    function self:OpenPopup(anchor, width, height)
        self:ClosePopup()
        local host = self.MenuRoot or self.Gui
        local v = host == self.Gui
                and (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600))
            or host.AbsoluteSize
        local origin = host == self.Gui and Vector2.new(0, 0) or host.AbsolutePosition
        width = math.floor(math.min(width, v.X - 16))
        height = math.floor(math.min(height, v.Y - 16))
        local pos = anchor.AbsolutePosition - origin
        local y = pos.Y + anchor.AbsoluteSize.Y + 4
        if y + height > v.Y - 8 then
            y = math.max(8, pos.Y - height - 4)
        end
        local p = self:New('Frame', {
            Name = 'MintPopup',
            Position = UDim2.fromOffset(
                math.round(math.clamp(pos.X, 8, math.max(8, v.X - width - 8))),
                math.round(y)
            ),
            Size = UDim2.fromOffset(width, height),
            ZIndex = 100,
            Active = true,
        }, host)
        self:Paint(p, 'Panel')
        self:Stroke(p)
        self:Corner(p, 8)
        self.Popup = p
        self.PopupAnchor = anchor
        return p
    end
    local function inside(node, pos)
        local a, b = node.AbsolutePosition, node.AbsoluteSize
        return pos.X >= a.X and pos.Y >= a.Y and pos.X <= a.X + b.X and pos.Y <= a.Y + b.Y
    end
    self:Connect(UIS.InputBegan, function(input, processed)
        if
            self.Popup
            and (
                input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            )
        then
            if not inside(self.Popup, input.Position) and not inside(self.PopupAnchor, input.Position) then
                self:ClosePopup()
            end
        end
        if UIS:GetFocusedTextBox() then
            return
        end
        if
            self.CaptureKey
            and (
                input.UserInputType == Enum.UserInputType.Keyboard
                or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.MouseButton2
            )
        then
            local f = self.CaptureKey
            self.CaptureKey = nil
            f(input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType)
            return
        end
        -- Roblox may consume Shift for its own controls. The menu shortcut still works,
        -- while focused textboxes and key capture above retain priority.
        if
            input.UserInputType == Enum.UserInputType.Keyboard
            and self.ToggleKeys
            and self.ToggleKeys[input.KeyCode]
            and self.ToggleVisible
        then
            self.ToggleVisible()
            return
        end
        if not processed then
            for control in pairs(self.Keybinds) do
                if
                    control.Value ~= Enum.KeyCode.Unknown
                    and (control.Value == input.KeyCode or control.Value == input.UserInputType)
                then
                    if control.Activate then
                        control:Activate(true)
                    else
                        self:Callback(control.OnPress)
                    end
                end
            end
        end
    end)
    self:Connect(UIS.InputChanged, function(input)
        if
            self.Drag
            and (
                input == self.DragInput
                or self.DragMouse and input.UserInputType == Enum.UserInputType.MouseMovement
            )
        then
            self.Drag(input.Position)
        end
    end)
    self:Connect(UIS.InputEnded, function(input)
        for control in pairs(self.Keybinds) do
            if
                control.Activate and (control.Value == input.KeyCode or control.Value == input.UserInputType)
            then
                control:Activate(false)
            end
        end
        if
            input == self.DragInput
            or self.DragMouse and input.UserInputType == Enum.UserInputType.MouseButton1
        then
            local finish = self.DragEnd
            self.Drag = nil
            self.DragInput = nil
            self.DragMouse = nil
            self.DragEnd = nil
            if finish then
                finish()
            end
        end
    end)
    if UIS.WindowFocusReleased then
        self:Connect(UIS.WindowFocusReleased, function()
            for control in pairs(self.Keybinds) do
                if control.Mode == 'Hold' and control.SetState then
                    control:SetState(false)
                end
            end
            self.Drag, self.DragInput, self.DragMouse, self.DragEnd = nil, nil, nil, nil
        end)
    end
    function self:Pointer(node, callback, finish, bucket)
        self:Connect(node.InputBegan, function(input)
            if self.MenuClosing then
                return
            end
            if
                input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            then
                self.DragInput = input
                self.DragMouse = input.UserInputType == Enum.UserInputType.MouseButton1
                self.Drag = callback
                self.DragEnd = finish
                callback(input.Position, true)
            end
        end, bucket)
    end
    function self:SetTheme(patch)
        for k, v in pairs(patch) do
            if self.Theme[k] and typeof(v) == 'Color3' then
                self.Theme[k] = v
            end
        end
        for node, properties in pairs(self.Bindings) do
            if node.Parent then
                if self.ActiveTweens[node] then
                    self.ActiveTweens[node]:Cancel()
                    self.ActiveTweens[node] = nil
                end
                for prop, role in pairs(properties) do
                    node[prop] = self.Theme[role]
                end
            end
        end
        for _, control in pairs(self.Controls) do
            if control.ThemeRole and control.Set and self.Theme[control.ThemeRole] then
                control:Set(self.Theme[control.ThemeRole], true)
            elseif control.Refresh then
                control:Refresh()
            end
        end
    end
    function self:Destroy()
        if self.Destroyed then
            return
        end
        self.Destroyed = true
        self:ClosePopup()
        self.Drag = nil
        self.CaptureKey = nil
        for _, tween in pairs(self.ActiveTweens) do
            tween:Cancel()
        end
        table.clear(self.ActiveTweens)
        if self.Library then
            for id, control in pairs(self.Controls) do
                if self.Library.Options[id] == control then
                    self.Library.Options[id] = nil
                end
                if self.Library.Toggles[id] == control then
                    self.Library.Toggles[id] = nil
                end
            end
        end
        for _, c in ipairs(self.Connections) do
            c:Disconnect()
        end
        table.clear(self.Connections)
        table.clear(self.Keybinds)
        table.clear(self.Controls)
        if self.Gui then
            self.Gui:Destroy()
        end
    end
    return self
end
return Core
