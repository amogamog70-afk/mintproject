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
