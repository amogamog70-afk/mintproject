-- MintProject | Facility UI loader
-- Mirrored library: https://github.com/amogamog70-afk/mintproject/tree/main/library
-- Define tabs and controls below the loader and theme settings.

local BASE = "https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/library/"
local ENV = (type(getgenv) == "function" and getgenv()) or _G

local function download(path)
	local ok, source = pcall(function()
		return game:HttpGet(BASE .. path)
	end)
	assert(
		ok and type(source) == "string" and #source > 1000,
		"MintProject: could not download " .. path .. ": " .. tostring(source)
	)
	return source
end

local source = download("main.luau")
local chunk, compileError = loadstring(source, "MintProject/Facility")
assert(chunk, "MintProject: library compilation failed: " .. tostring(compileError))

local previous = ENV.MintProjectUI
if previous and previous.Library and type(previous.Library.Destroy) == "function" then
	pcall(function()
		previous.Library:Destroy()
	end)
end

local Library = chunk()
assert(type(Library) == "table", "MintProject: the library did not return its API")
Library.BaseUrl = BASE

local SaveManager = assert(Library.SaveManager, "MintProject: SaveManager did not load")
local InterfaceManager = assert(Library.InterfaceManager, "MintProject: InterfaceManager did not load")
local ThemeManager = assert(Library.ThemeManager, "MintProject: ThemeManager did not load")
local THEME_FOLDER = "MintProject/Facility"

-- Set the folder before Window(), which preloads its saved palette.
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder(THEME_FOLDER)

-- MintProject theme. Keep Facility's layout and controls.
local MintColors = {
	Window = Color3.fromRGB(9, 14, 12),
	WindowBorder = Color3.fromRGB(37, 56, 47),
	TopBar = Color3.fromRGB(13, 20, 16),
	Section = Color3.fromRGB(14, 22, 18),
	SectionBorder = Color3.fromRGB(32, 46, 38),
	Group = Color3.fromRGB(18, 28, 23),
	GroupBorder = Color3.fromRGB(39, 54, 45),
	Field = Color3.fromRGB(23, 34, 28),
	FieldHover = Color3.fromRGB(32, 47, 39),
	Border = Color3.fromRGB(45, 62, 52),
	BorderSoft = Color3.fromRGB(29, 43, 35),
	PopupBg = Color3.fromRGB(17, 26, 21),
	PopupBorder = Color3.fromRGB(48, 67, 56),
	Track = Color3.fromRGB(39, 54, 45),
	Text = Color3.fromRGB(222, 238, 229),
	TextDim = Color3.fromRGB(133, 159, 144),
	TextBright = Color3.fromRGB(246, 255, 250),
	TextMarked = Color3.fromRGB(224, 207, 139),
	TextCode = Color3.fromRGB(130, 232, 177),
	Danger = Color3.fromRGB(232, 110, 119),
	Accent = Color3.fromRGB(107, 230, 180),
	AccentSoft = Color3.fromRGB(181, 255, 220),
	AccentDim = Color3.fromRGB(56, 128, 94),
}

ThemeManager.Presets.mint = { Bg = MintColors.Window, Accent = MintColors.Accent }
if not table.find(ThemeManager.Order, "mint") then
	table.insert(ThemeManager.Order, 1, "mint")
end

local applyPreset = ThemeManager.Apply
function ThemeManager:Apply(name)
	local ok = applyPreset(self, name)
	if ok and name == "mint" then
		for key, color in pairs(MintColors) do
			Library.Theme[key] = color
		end
		Library:Repaint()
	end
	return ok
end

Library.Theme.Radius = 0
Library.Theme.WindowAlpha = 0
ThemeManager:Apply("mint")
Library:SetGlass(false)
Library:SetToggleKey("RightShift")
ThemeManager:Load()

-- Window.
local Window = Library:Window({
	Title = "MintProject",
	ThemeFolder = THEME_FOLDER,
	Suffix = "",
	Width = 700,
	Height = 620,
	MinWidth = 520,
	MinHeight = 340,
	MobileButton = true,
	TabStyle = "side",
	TabWidth = 140,
})

local Tabs = {
	Main = Window:Tab("Main", "sliders"),
	Elements = Window:Tab("Elements", "layout-grid"),
	Settings = Window:Tab("Settings", "settings"),
}

-- Add your functions here. These controls demonstrate the UI only.
local General = Tabs.Main:Section("General", 1)
local Enabled = General:Toggle({ Text = "Enabled", Flag = "main_enabled", Default = false })
Enabled:Keybind({ Default = "F6", Flag = "main_enabled_key", Mode = "toggle" })
General:Slider({ Text = "Amount", Flag = "main_amount", Min = 0, Max = 100, Default = 50 })
General:Dropdown({
	Text = "Mode",
	Flag = "main_mode",
	Options = { "Default", "Custom" },
	Default = "Default",
})

local Appearance = Tabs.Main:Section("Appearance", 2)
Appearance:ColorPicker({
	Text = "Accent",
	Flag = false,
	Default = Library.Theme.Accent,
	Callback = function(color)
		ThemeManager:SetAccent(color)
	end,
})
Appearance:Button({
	Text = "Reset Mint theme",
	Callback = function()
		ThemeManager:Apply("mint")
	end,
})

local Controls = Tabs.Elements:Section("Controls", 1)
Controls:Toggle({ Text = "Options", Flag = "example_options" }):Gear(function(panel)
	panel:Slider({ Text = "Strength", Flag = "example_strength", Min = 0, Max = 1, Decimals = 2, Default = 0.5 })
end)
Controls:Dropdown({
	Text = "Multiselect",
	Flag = "example_multi",
	Multi = true,
	Options = { "First", "Second", "Third" },
	Default = { "First" },
})
Controls:Input({ Text = "Name", Flag = "example_name", Default = "", Placeholder = "Enter text" })

local Shortcuts = Tabs.Elements:Section("Keybinds", 2)
Shortcuts:Keybind({ Text = "Hold", Flag = "example_hold", Default = "E", Mode = "hold" })
Shortcuts:Keybind({ Text = "Toggle", Flag = "example_toggle", Default = "H", Mode = "toggle" })
Shortcuts:ColorPicker({ Text = "Color", Flag = "example_color", Default = MintColors.Accent, DefaultAlpha = 1 })

-- Built-in managers.
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
InterfaceManager:SetWindow(Window)
ThemeManager:SetLibrary(Library)

InterfaceManager:SetFolder(THEME_FOLDER)
SaveManager:SetFolder("MintProject/Facility/default")
SaveManager:IgnoreThemeSettings()

InterfaceManager:BuildInterfaceSection(Tabs.Settings, 1)
SaveManager:BuildConfigSection(Tabs.Settings, 2)
ThemeManager:Mount(Window)

Window:SetTab(Tabs.Main)
SaveManager:LoadAutoloadConfig()

local MintProject = {
	Library = Library,
	Window = Window,
	Tabs = Tabs,
	Theme = MintColors,
	SaveManager = SaveManager,
	InterfaceManager = InterfaceManager,
	ThemeManager = ThemeManager,
}
ENV.MintProjectUI = MintProject
return MintProject
