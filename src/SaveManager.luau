local Storage = require(script.Parent.Storage)
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
        local group = tab:AddLeftGroupbox('Configs')
        local name = group:AddInput(
            '__config.name',
            { Text = 'Name', Default = 'Default', Tooltip = 'Storage: ' .. self.Storage.Mode }
        )
        local selected = group:AddDropdown('__config.selected', {
            Text = 'Saved',
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
            Text = 'Save',
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
            Text = 'Load',
            Func = function()
                local ok, err = self:Load(selected:Get() or name:Get())
                report(ok, err, 'Config loaded')
            end,
        })
        group:AddButton({
            Text = 'Use on start',
            Func = function()
                local ok, err = self:SetAutoloadConfig(selected:Get() or name:Get())
                report(ok, err, 'Autoload selected')
            end,
        })
        group:AddButton({
            Text = 'Delete',
            Func = function()
                local ok, err = self:Delete(selected:Get() or name:Get())
                if ok then
                    refresh()
                end
                report(ok, err, 'Config deleted')
            end,
        })
        return group
    end
    return self
end
return SaveManager
