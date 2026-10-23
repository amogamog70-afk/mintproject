-- This module is shared by the Studio example and the standalone demo bundle.
return function(MintProject, options)
    local window = MintProject:CreateWindow(options or { Title = 'MintProject  /  UI preview' })
    local overview = window:Tab('Overview')
    local welcome = overview:Section('MINTPROJECT')
    welcome:Label(
        'A compact black and mint interface. Drag the title bar. Right Shift or M toggles the window.'
    )
    welcome:Button({
        Text = 'Show notification',
        Callback = function()
            window:Notify('MintProject is ready. This is a UI demonstration.')
        end,
    })
    local preview = overview:Section('Quick controls')
    preview:Toggle({ Id = 'demo.enabled', Text = 'Enable preview', Default = true })
    preview:Slider({
        Id = 'demo.amount',
        Text = 'Amount',
        Description = 'Drag the track to adjust. Click its number to type a precise value.',
        Min = 0,
        Max = 100,
        Step = 1,
        Default = 65,
    })
    preview:Dropdown({
        Id = 'demo.mode',
        Text = 'Mode',
        Options = { 'Balanced', 'Compact', 'Detailed' },
        Default = 'Balanced',
    })

    local components = window:Tab('Components')
    local sliders = components:Section('Sliders')
    sliders:Slider({ Id = 'slider.smooth', Text = 'Smooth', Min = 0, Max = 1, Step = 0, Default = 0.65 })
    sliders:Slider({ Id = 'slider.step', Text = 'Stepped', Min = 0, Max = 100, Step = 5, Default = 40 })
    sliders:RangeSlider({
        Id = 'slider.range',
        Text = 'Range',
        Min = 0,
        Max = 100,
        Step = 1,
        Default = { 20, 80 },
    })
    local lists = components:Section('Selection and input')
    lists:Dropdown({
        Id = 'demo.multiselect',
        Text = 'Components',
        Multi = true,
        Options = {
            'Buttons',
            'Toggles',
            'Sliders',
            'Ranges',
            'Dropdowns',
            'Multiselects',
            'Textboxes',
            'Keybinds',
            'Colors',
            'Profiles',
        },
        Default = { 'Buttons', 'Sliders', 'Colors' },
    })
    lists:Textbox({ Id = 'demo.message', Text = 'Message', Default = 'Hello, MintProject' })
    lists:Keybind({
        Id = 'demo.key',
        Text = 'Notification key',
        Default = Enum.KeyCode.F6,
        OnPress = function()
            window:Notify('Keybind pressed')
        end,
    })

    local appearance = window:Tab('Appearance')
    local theme = appearance:Section('Theme')
    theme:ColorPicker({
        Id = 'theme.accent',
        Text = 'Mint accent',
        Default = window.Context.Theme.Accent,
        Callback = function(color)
            window:SetTheme({ Accent = color })
        end,
    })
    theme:ColorPicker({
        Id = 'theme.background',
        Text = 'Background',
        Default = window.Context.Theme.Background,
        Callback = function(color)
            window:SetTheme({ Background = color })
        end,
    })
    theme:Toggle({
        Id = 'theme.animations',
        Text = 'Smooth transitions',
        Default = true,
        Callback = function(value)
            window:SetAnimations(value)
        end,
    })
    theme:Keybind({
        Id = 'theme.openKey',
        Text = 'Open / close menu',
        Default = Enum.KeyCode.RightShift,
        Callback = function(key)
            window:SetToggleKey(key)
        end,
    })

    local profiles = window:Tab('Profiles')
    local storage = profiles:Section('Named profiles')
    storage:Label('Profiles stay in memory for this session. Use JSON to keep a copy between sessions.')
    local name = storage:Textbox({ Text = 'Profile name', Default = 'Default' })
    storage:Button({
        Text = 'Save profile',
        Callback = function()
            if #name:Get() == 0 then
                window:Notify('Enter a profile name')
                return
            end
            window:SaveProfile(name:Get())
            window:Notify('Saved: ' .. name:Get())
        end,
    })
    storage:Button({
        Text = 'Load profile',
        Callback = function()
            local ok, err = window:LoadProfile(name:Get())
            window:Notify(ok and 'Profile loaded' or err)
        end,
    })
    local transfer = profiles:Section('Import / export')
    local json = transfer:Textbox({ Text = 'Profile JSON', Default = '' })
    transfer:Button({
        Text = 'Export to JSON field',
        Callback = function()
            json:Set(window:ExportConfig(), true)
        end,
    })
    transfer:Button({
        Text = 'Import from JSON field',
        Callback = function()
            local ok, err = window:ImportConfig(json:Get())
            window:Notify(ok and 'Imported' or err)
        end,
    })
    local lifecycle = profiles:Section('Session')
    lifecycle:Button({
        Text = 'Destroy demo',
        Callback = function()
            window:Destroy()
        end,
    })
    return window
end
