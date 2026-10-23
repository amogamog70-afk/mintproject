-- MintProject ThemeManager
local Storage=(function()
local Storage = {}
function Storage.new(folder, backend)
    backend = backend
        or {
            readfile = readfile,
            writefile = writefile,
            isfile = isfile,
            isfolder = isfolder,
            makefolder = makefolder,
            listfiles = listfiles,
            delfile = delfile,
        }
    assert(
        type(folder) == 'string'
            and #folder > 0
            and not folder:find('%.%.')
            and not folder:find('[:%c]')
            and not folder:match('^[/\\]'),
        'Invalid storage folder'
    )
    folder = folder:gsub('\\', '/'):gsub('/+$', '')
    local disk = type(backend.readfile) == 'function'
        and type(backend.writefile) == 'function'
        and type(backend.isfile) == 'function'
        and type(backend.isfolder) == 'function'
        and type(backend.makefolder) == 'function'
        and type(backend.listfiles) == 'function'
    local self = {
        Folder = folder,
        Backend = backend,
        Memory = {},
        Persistent = disk,
        Mode = disk and 'local files' or 'session memory',
    }
    local function key(name)
        assert(
            type(name) == 'string' and name:match('^[%w _%-]+$') and #name <= 64,
            'Use 1–64 letters, numbers, spaces, - or _'
        )
        return folder .. '/' .. name .. '.json'
    end
    function self:Write(name, data)
        local path = key(name)
        assert(type(data) == 'string', 'Expected JSON string')
        if disk then
            local ok, err = pcall(function()
                local current = ''
                for part in folder:gmatch('[^/]+') do
                    current = current == '' and part or current .. '/' .. part
                    if not backend.isfolder(current) then
                        backend.makefolder(current)
                    end
                end
                backend.writefile(path, data)
                assert(backend.isfile(path) and backend.readfile(path) == data, 'File verification failed')
            end)
            if not ok then
                return false, tostring(err)
            end
        end
        self.Memory[name] = data
        return true
    end
    function self:Read(name)
        local path = key(name)
        if disk then
            local ok, data = pcall(function()
                if backend.isfile(path) then
                    return backend.readfile(path)
                end
            end)
            if not ok then
                return nil, tostring(data)
            end
            return data
        end
        return self.Memory[name]
    end
    function self:List()
        local names = {}
        if disk then
            local ok, files = pcall(function()
                return backend.isfolder(folder) and backend.listfiles(folder) or {}
            end)
            if not ok then
                return {}, tostring(files)
            end
            for _, path in ipairs(files) do
                local name = path:gsub('\\', '/'):match('/([%w _%-]+)%.json$')
                    or path:match('^([%w _%-]+)%.json$')
                if name and not name:match('^__') then
                    names[name] = true
                end
            end
        else
            for name in pairs(self.Memory) do
                if not name:match('^__') then
                    names[name] = true
                end
            end
        end
        local result = {}
        for name in pairs(names) do
            table.insert(result, name)
        end
        table.sort(result)
        return result
    end
    function self:Delete(name)
        local path = key(name)
        if disk then
            if type(backend.delfile) ~= 'function' then
                return false, 'This environment does not support deleting files'
            end
            local ok, err = pcall(function()
                if backend.isfile(path) then
                    backend.delfile(path)
                end
            end)
            if not ok then
                return false, tostring(err)
            end
        end
        self.Memory[name] = nil
        return true
    end
    return self
end
return Storage

end)()
local Manager=(function()
local Storage = Storage
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
        local group = tab:AddLeftGroupbox('Theme')
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
        local name = group:AddInput('__theme.name', { Text = 'Name', Default = 'Custom' })
        local function refresh()
            selection:SetValues(self:GetThemes())
        end
        group:AddButton({
            Text = 'Save theme',
            Func = function()
                local ok, err = self:SaveCustomTheme(name:Get())
                if ok then
                    refresh()
                end
                self.Library:Notify(ok and 'Theme saved' or err)
            end,
        })
        group:AddButton({
            Text = 'Delete theme',
            Func = function()
                local ok, err = self:DeleteCustomTheme(selection:Get())
                if ok then
                    refresh()
                end
                self.Library:Notify(ok and 'Theme deleted' or err)
            end,
        })
        local colors = tab:AddRightGroupbox('Colors')
        self.ColorControls = {}
        for _, role in ipairs({
            'Accent',
            'Background',
            'Panel',
            'Field',
            'Border',
            'Text',
            'Hover',
        }) do
            self.ColorControls[role] = colors:AddLabel(role):AddColorPicker('__theme.color.' .. role, {
                Default = self.Library.Theme[role],
                ThemeRole = role,
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

end)()
return Manager.new()
