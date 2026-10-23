-- MintProject SaveManager
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
local SaveManager = {}
function SaveManager.new(library)
    local self =
        { Library = library, Storage = Storage.new('MintProject/configs'), Ignore = {}, IgnoreTheme = true }
    function self:SetLibrary(value)
        self.Library = value
        return self
    end
    function self:SetFolder(folder)
        self.Storage = Storage.new(folder .. '/configs')
        return self
    end
    function self:IgnoreThemeSettings()
        self.IgnoreTheme = true
        return self
    end
    function self:SetIgnoreIndexes(ids)
        for _, id in ipairs(ids) do
            self.Ignore[id] = true
        end
        return self
    end
    function self:Save(name)
        if type(name) ~= 'string' or not name:match('^[%w _%-]+$') or #name > 64 then
            return false, 'Enter a valid config name'
        end
        local ignore = table.clone(self.Ignore)
        for id in pairs(self.Library.Options) do
            if id:match('^__config%.') or (self.IgnoreTheme and id:match('^__theme%.')) then
                ignore[id] = true
            end
        end
        return self.Storage:Write(name, self.Library:ExportConfig(ignore))
    end
    function self:Load(name)
        if type(name) ~= 'string' or not name:match('^[%w _%-]+$') or #name > 64 then
            return false, 'Select a config first'
        end
        local json, err = self.Storage:Read(name)
        if not json then
            return false, err or 'Config not found'
        end
        return self.Library:ImportConfig(json)
    end
    function self:Delete(name)
        if type(name) ~= 'string' or not name:match('^[%w _%-]+$') or #name > 64 then
            return false, 'Select a config first'
        end
        return self.Storage:Delete(name)
    end
    function self:GetConfigs()
        return self.Storage:List()
    end
    function self:SetAutoloadConfig(name)
        if type(name) ~= 'string' or not name:match('^[%w _%-]+$') or #name > 64 then
            return false, 'Select a config first'
        end
        if not self.Storage:Read(name) then
            return false, 'Save the config first'
        end
        return self.Storage:Write('__autoload', Http:JSONEncode({ name = name }))
    end
    function self:LoadAutoloadConfig()
        local json = self.Storage:Read('__autoload')
        if not json then
            return false, 'No autoload config'
        end
        local ok, data = pcall(Http.JSONDecode, Http, json)
        if not ok or type(data) ~= 'table' or type(data.name) ~= 'string' then
            return false, 'Invalid autoload config'
        end
        return self:Load(data.name)
    end
    function self:BuildConfigSection(tab)
        local group = tab:AddGroupbox('Configuration', { Column = 3 })
        group:AddLabel('Storage: ' .. self.Storage.Mode)
        local name = group:AddInput('__config.name', { Text = 'Config name', Default = 'Default' })
        local selected = group:AddDropdown('__config.selected', {
            Text = 'Saved configs',
            Values = self:GetConfigs(),
            Callback = function(value)
                if value then
                    name:Set(value, true)
                end
            end,
        })
        local function refresh()
            selected:SetValues(self:GetConfigs())
        end
        local function report(ok, err, success)
            self.Library:Notify(ok and success or err or 'Operation failed')
        end
        group:AddButton({
            Text = 'Save config',
            Primary = true,
            Func = function()
                local ok, err = self:Save(name:Get())
                if ok then
                    refresh()
                    selected:Set(name:Get(), true)
                end
                report(ok, err, 'Config saved')
            end,
        })
        group:AddButton({
            Text = 'Load selected',
            Func = function()
                local ok, err = self:Load(selected:Get() or name:Get())
                report(ok, err, 'Config loaded')
            end,
        })
        group:AddButton({
            Text = 'Set as autoload',
            Func = function()
                local ok, err = self:SetAutoloadConfig(selected:Get() or name:Get())
                report(ok, err, 'Autoload selected')
            end,
        })
        group:AddButton({
            Text = 'Delete selected',
            Func = function()
                local ok, err = self:Delete(selected:Get() or name:Get())
                if ok then
                    refresh()
                end
                report(ok, err, 'Config deleted')
            end,
        })
        group:AddButton({ Text = 'Refresh list', Func = refresh })
        return group
    end
    return self
end
return SaveManager

end)()
return Manager.new()
