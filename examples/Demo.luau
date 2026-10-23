return function(Library, options, ThemeManager, SaveManager)
    ThemeManager = ThemeManager or Library.ThemeManager
    SaveManager = SaveManager or Library.SaveManager
    local Window = Library:CreateWindow(options or { Title = 'MintProject', Columns = 2, AutoShow = true })
    local Tabs = {
        Main = Window:AddTab('Main'),
        Elements = Window:AddTab('Elements'),
        Settings = Window:AddTab('Settings'),
    }

    local Controls = Tabs.Main:AddLeftGroupbox('Controls')
    Controls:AddToggle('Enabled', { Text = 'Enabled', Default = true })
        :AddKeyPicker('EnabledKey', { Default = 'F6', Mode = 'Toggle', SyncToggleState = true })
    Controls:AddSlider('Amount', { Text = 'Amount', Min = 0, Max = 100, Default = 65, Rounding = 0 })
    Controls:AddDropdown(
        'Mode',
        { Text = 'Mode', Values = { 'Balanced', 'Minimal', 'Detailed' }, Default = 'Balanced' }
    )
    Controls:AddButton({
        Text = 'Apply',
        Primary = true,
        Func = function()
            Library:Notify('Applied')
        end,
    })

    local Appearance = Tabs.Main:AddRightGroupbox('Appearance')
    Appearance:AddToggle('Animations', {
        Text = 'Animations',
        Default = true,
        Callback = function(value)
            Window:SetAnimations(value)
        end,
    })
    Appearance:AddLabel('Accent'):AddColorPicker('Accent', {
        Default = Library.Theme.Accent,
        ThemeRole = 'Accent',
        Callback = function(color)
            Library:SetTheme({ Accent = color })
        end,
    })
    Appearance:AddLabel('Text'):AddColorPicker('Text', {
        Default = Library.Theme.Text,
        ThemeRole = 'Text',
        Callback = function(color)
            Library:SetTheme({ Text = color })
        end,
    })
    Appearance:AddDropdown('Options', {
        Text = 'Options',
        Values = { 'First', 'Second', 'Third' },
        Multi = true,
        Default = {
            'First',
            'Third',
        },
    })

    local Values = Tabs.Elements:AddLeftGroupbox('Values')
    Values:AddSlider('Smooth', { Text = 'Smooth', Min = 0, Max = 1, Default = 0.6, Step = 0 })
    Values:AddRangeSlider('Range', { Text = 'Range', Min = 0, Max = 100, Default = { 20, 80 } })
    Values:AddInput('Name', { Text = 'Name', Default = 'Default' })
    local Inputs = Tabs.Elements:AddRightGroupbox('Inputs')
    Inputs:AddToggle('Linked', { Text = 'Linked', Default = false })
        :AddKeyPicker('LinkedKey', { Default = 'MB2', Mode = 'Hold', SyncToggleState = true })
    Inputs:AddDropdown('Search', {
        Text = 'Search',
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
    Inputs:AddLabel('Color'):AddColorPicker('Color', { Default = Color3.fromRGB(107, 230, 180) })

    ThemeManager:SetLibrary(Library)
    ThemeManager:SetFolder('MintProject')
    ThemeManager:ApplyToTab(Tabs.Settings)
    SaveManager:SetLibrary(Library)
    SaveManager:SetFolder('MintProject')
    SaveManager:IgnoreThemeSettings()
    SaveManager:BuildConfigSection(Tabs.Settings)
    local Menu = Tabs.Settings:AddRightGroupbox('Window')
    local menuKeys = { Enum.KeyCode.RightShift, Enum.KeyCode.LeftShift }
    local function updateMenuKey(index, key)
        if key.EnumType == Enum.KeyCode then
            menuKeys[index] = key
            Window:SetToggleKey(menuKeys)
        end
    end
    Menu:AddLabel('Menu key'):AddKeyPicker('__window.menuKey', {
        Default = 'RightShift',
        NoModes = true,
        ChangedCallback = function(key)
            updateMenuKey(1, key)
        end,
    })
    Menu:AddLabel('Alternative key'):AddKeyPicker('__window.menuKeyAlt', {
        Default = 'LeftShift',
        NoModes = true,
        ChangedCallback = function(key)
            updateMenuKey(2, key)
        end,
    })
    Menu:AddToggle('Watermark', {
        Text = 'Watermark',
        Default = true,
        Callback = function(value)
            Window:SetWatermark(value)
        end,
    })
    Menu:AddToggle('KeybindList', {
        Text = 'Keybind list',
        Default = true,
        Callback = function(value)
            Window:SetKeybindsVisible(value)
        end,
    })
    Menu:AddButton({
        Text = 'Unload',
        Func = function()
            Library:Unload()
        end,
    })
    SaveManager:LoadAutoloadConfig()
    return Window
end
