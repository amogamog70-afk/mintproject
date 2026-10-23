-- Editable UI example. The generated root Example.lua loads the library first,
-- then contains these tab/group/control definitions directly below the links.
return function(Library, options, ThemeManager, SaveManager)
    ThemeManager = ThemeManager or Library.ThemeManager
    SaveManager = SaveManager or Library.SaveManager
    local Window = Library:CreateWindow(options or {
        Title = 'MintProject',
        Subtitle = 'UNIVERSAL / DESIGN PREVIEW',
        Columns = 3,
        AutoShow = true,
    })
    local Tabs = {
        Main = Window:AddTab('Main'),
        Components = Window:AddTab('Components'),
        Settings = Window:AddTab('Settings'),
        About = Window:AddTab('About'),
    }
    local Toggles, Options = Library.Toggles, Library.Options

    local General = Tabs.Main:AddLeftGroupbox('General')
    General:AddToggle('Enabled', { Text = 'Enable interface', Default = true }):AddKeyPicker(
        'EnabledKey',
        { Default = 'F6', Mode = 'Toggle', SyncToggleState = true, Text = 'Enable interface' }
    )
    General:AddDropdown(
        'ProfileMode',
        { Text = 'Workspace', Values = { 'Default', 'Creative', 'Focused' }, Default = 'Default' }
    )
    General:AddSlider(
        'Intensity',
        { Text = 'Intensity', Min = 0, Max = 100, Default = 65, Rounding = 0, Suffix = '%' }
    )
    General:AddSlider(
        'Transition',
        { Text = 'Transition speed', Min = 0.05, Max = 1, Default = 0.18, Rounding = 2, Suffix = ' s' }
    )
    General:AddDropdown('VisibleWidgets', {
        Text = 'Visible widgets',
        Values = { 'Notifications', 'Status bar', 'Tooltips' },
        Multi = true,
        Default = { 'Notifications', 'Status bar' },
    })

    local Display = Tabs.Main:AddGroupbox('Display', { Column = 2 })
    Display:AddToggle('Motion', {
        Text = 'Smooth transitions',
        Default = true,
        Callback = function(value)
            Window:SetAnimations(value)
        end,
    })
    Display:AddToggle('Information', { Text = 'Contextual information', Default = true })
    Display:AddToggle('Compact', { Text = 'Compact spacing', Default = false })
    Display:AddLabel('Accent color'):AddColorPicker('AccentColor', {
        Default = Library.Theme.Accent,
        Callback = function(color)
            Library:SetTheme({ Accent = color })
        end,
    })
    Display:AddDropdown(
        'Detail',
        { Text = 'Detail level', Values = { 'Balanced', 'Minimal', 'Detailed' }, Default = 'Balanced' }
    )
    Display:AddSlider(
        'ScalePreview',
        { Text = 'Preview amount', Min = 0, Max = 100, Default = 80, Rounding = 0 }
    )
    Display:AddButton({
        Text = 'Show notification',
        Func = function()
            Library:Notify('MintProject / Your interface is ready.')
        end,
    })

    local Session = Tabs.Main:AddGroupbox('Session', { Column = 3 })
    Session:AddInput('WorkspaceName', { Text = 'Workspace name', Default = 'My workspace' })
    Session:AddDropdown(
        'UpdatePolicy',
        { Text = 'Update policy', Values = { 'Automatic', 'On change', 'Manual' }, Default = 'On change' }
    )
    Session:AddToggle('Hints', {
        Text = 'Show help buttons',
        Default = true,
        Tooltip = 'Descriptions open with the separate i button.',
    })
    Session:AddButton({
        Text = 'Save quick profile',
        Primary = true,
        Func = function()
            Window:SaveProfile('Quick')
            Library:Notify('Quick profile saved for this session')
        end,
    })
    Session:AddButton({
        Text = 'Restore quick profile',
        Func = function()
            local ok, err = Window:LoadProfile('Quick')
            Library:Notify(ok and 'Quick profile restored' or err)
        end,
    })

    local Actions = Tabs.Main:AddLeftGroupbox('Actions')
    Actions:AddButton({
        Text = 'Apply settings',
        Primary = true,
        Func = function()
            Library:Notify('Settings applied')
        end,
    })
    Actions:AddButton({
        Text = 'Hide interface',
        Func = function()
            Window:SetVisible(false)
        end,
    })

    local Sliders = Tabs.Components:AddLeftGroupbox('Sliders')
    Sliders:AddSlider('SmoothSlider', { Text = 'Smooth value', Min = 0, Max = 1, Default = 0.72, Step = 0 })
    Sliders:AddSlider('StepSlider', { Text = 'Stepped value', Min = 0, Max = 100, Default = 40, Step = 5 })
    Sliders:AddRangeSlider('Range', { Text = 'Range', Min = 0, Max = 100, Default = { 25, 75 }, Step = 1 })
    local Select = Tabs.Components:AddRightGroupbox('Selection')
    Select:AddDropdown('LongList', {
        Text = 'Searchable list',
        Values = {
            'Amber',
            'Birch',
            'Cedar',
            'Clover',
            'Fern',
            'Graphite',
            'Ice',
            'Jade',
            'Mint',
            'Olive',
            'Sage',
            'Willow',
        },
        Default = 'Mint',
    })
    Select:AddDropdown('MultiExample', {
        Text = 'Multiple values',
        Values = { 'Alpha', 'Beta', 'Gamma', 'Delta' },
        Multi = true,
        Default = {
            'Alpha',
            'Gamma',
        },
    })
    Select:AddInput('ExampleInput', { Text = 'Editable text', Default = 'Hello, MintProject' })
    local Bindings = Tabs.Components:AddGroupbox('Keybinds & colors', { Column = 3 })
    Bindings:AddToggle('LinkedToggle', { Text = 'Linked control', Default = false })
        :AddKeyPicker('LinkedKey', { Default = 'F7', Mode = 'Toggle', SyncToggleState = true })
    Bindings:AddLabel('Custom color')
        :AddColorPicker('ExampleColor', { Default = Color3.fromRGB(116, 227, 174) })
    Bindings:AddLabel('Notification key'):AddKeyPicker('NoticeKey', {
        Default = 'F8',
        Mode = 'Toggle',
        Callback = function(active)
            if active then
                Library:Notify('Keybind pressed')
            end
        end,
    })

    ThemeManager:SetLibrary(Library)
    ThemeManager:SetFolder('MintProject')
    ThemeManager:ApplyToTab(Tabs.Settings)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetFolder('MintProject')
    SaveManager:BuildConfigSection(Tabs.Settings)
    local Menu = Tabs.Settings:AddLeftGroupbox('Menu')
    Menu:AddLabel('Open / close'):AddKeyPicker('__theme.menuKey', {
        Default = 'RightShift',
        ChangedCallback = function(key)
            if key.EnumType == Enum.KeyCode then
                Window:SetToggleKey(key)
            end
        end,
    })
    Menu:AddButton({
        Text = 'Unload interface',
        Func = function()
            Library:Unload()
        end,
    })

    local About = Tabs.About:AddLeftGroupbox('MintProject')
    About:AddLabel('Version 0.2 / Reference redesign')
    About:AddLabel('Black panels. Mint accents. Compact controls.')
    About:AddButton({
        Text = 'Show notification',
        Func = function()
            Library:Notify('Made for your own interfaces')
        end,
    })
    Options.Intensity:OnChanged(function(value)
        -- Put application behavior here. UI creation stays above.
    end)
    SaveManager:LoadAutoloadConfig()
    return Window
end
