local Storage = require(script.Parent.Storage)
local Http = game:GetService('HttpService')
local ThemeManager = {}
function ThemeManager.new(library)
    local self = { Library = library, Storage = Storage.new('MintProject/themes'), Current = 'Mint' }
    local presets = { Mint = '74E3AE', Ice = '82C7F0', Amber = 'EDBD74', Rose = 'E7899D', Violet = 'B7A3EF' }
    function self:SetLibrary(value)
        self.Library = value
        return self
    end
    function self:SetFolder(folder)
        self.Storage = Storage.new(folder .. '/themes')
        return self
    end
    function self:GetThemes()
        local names = {}
        for name in pairs(presets) do
            table.insert(names, name)
        end
        for _, name in ipairs(self.Storage:List()) do
            if not presets[name] then
                table.insert(names, name)
            end
        end
        table.sort(names)
        return names
    end
    function self:ApplyTheme(name)
        if type(name) ~= 'string' or not name:match('^[%w _%-]+$') or #name > 64 then
            return false, 'Select a theme first'
        end
        assert(self.Library, 'SetLibrary first')
        local patch = {}
        if presets[name] then
            for role, color in pairs(self.Library.DefaultTheme) do
                patch[role] = color
            end
            patch.Accent = Color3.fromHex(presets[name])
        else
            local json, err = self.Storage:Read(name)
            if not json then
                return false, err or 'Theme not found'
            end
            local ok, data = pcall(Http.JSONDecode, Http, json)
            if not ok or type(data) ~= 'table' then
                return false, 'Invalid theme'
            end
            for role, hex in pairs(data) do
                if self.Library.DefaultTheme[role] then
                    if type(hex) ~= 'string' or #hex ~= 6 or not hex:match('^%x+$') then
                        return false, 'Invalid theme color'
                    end
                    patch[role] = Color3.fromHex(hex)
                end
            end
        end
        self.Library:SetTheme(patch)
        self.Current = name
        for role, control in pairs(self.ColorControls or {}) do
            control:Set(self.Library.Theme[role], true)
        end
        return true
    end
    function self:SaveCustomTheme(name)
        if type(name) ~= 'string' or not name:match('^[%w _%-]+$') or #name > 64 or presets[name] then
            return false, 'Choose a new custom theme name'
        end
        local values = {}
        for role, color in pairs(self.Library.Theme) do
            values[role] = color:ToHex()
        end
        return self.Storage:Write(name, Http:JSONEncode(values))
    end
    function self:DeleteCustomTheme(name)
        if type(name) ~= 'string' or not name:match('^[%w _%-]+$') or #name > 64 then
            return false, 'Select a theme first'
        end
        if presets[name] then
            return false, 'Built-in themes cannot be deleted'
        end
        return self.Storage:Delete(name)
    end
    function self:ApplyToTab(tab)
        assert(self.Library, 'SetLibrary first')
        local group = tab:AddLeftGroupbox('Theme manager')
        group:AddLabel('Preset palettes')
        local selection = group:AddDropdown('__theme.preset', {
            Text = 'Theme',
            Values = self:GetThemes(),
            Default = 'Mint',
            Callback = function(name)
                local ok, err = self:ApplyTheme(name)
                if not ok then
                    self.Library:Notify(err)
                end
            end,
        })
        local name = group:AddInput('__theme.name', { Text = 'Custom theme name', Default = 'My theme' })
        local function refresh()
            selection:SetValues(self:GetThemes())
        end
        group:AddButton({
            Text = 'Save current palette',
            Func = function()
                local ok, err = self:SaveCustomTheme(name:Get())
                if ok then
                    refresh()
                end
                self.Library:Notify(ok and 'Theme saved' or err)
            end,
        })
        group:AddButton({
            Text = 'Delete custom theme',
            Func = function()
                local ok, err = self:DeleteCustomTheme(selection:Get())
                if ok then
                    refresh()
                end
                self.Library:Notify(ok and 'Theme deleted' or err)
            end,
        })
        group:AddButton({ Text = 'Refresh themes', Func = refresh })
        local colors = tab:AddRightGroupbox('Palette editor')
        self.ColorControls = {}
        for _, role in ipairs({
            'Accent',
            'Background',
            'Panel',
            'Field',
            'Border',
            'Text',
            'Muted',
            'AccentText',
            'Hover',
            'White',
        }) do
            self.ColorControls[role] = colors:AddLabel(role):AddColorPicker('__theme.color.' .. role, {
                Default = self.Library.Theme[role],
                Callback = function(color)
                    self.Library:SetTheme({ [role] = color })
                end,
            })
        end
        return group
    end
    return self
end
return ThemeManager
