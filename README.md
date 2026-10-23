# MintProject

A compact Roblox UI library with a near-black palette, mint accents, thin borders and column-based group boxes. Version **0.2.0**.

The redesign follows the supplied Aurora/Astra references, using the selected upper-left M-and-leaf symbol. The library and managers are original implementations; the public API follows familiar Linoria-style naming. This is not a drop-in implementation of every Linoria feature.

## Quick demo

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/Example.lua"))()
```

[Read the editable example](Example.lua): it starts by loading the library and managers, then defines the window, tabs, groups and controls directly below those links. The previous standalone [dist/Demo.lua](dist/Demo.lua) entry still works and contains everything in one download.

**Right Shift** or the **M** button opens/closes the menu. Drag the title bar to move it.

Remote loading requires a client environment that provides `loadstring` and `game:HttpGet`. For standard Roblox LocalScripts, install the ModuleScripts instead.

## Your own interface

```lua
local repo = "https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Window = Library:CreateWindow({
    Title = "MintProject",
    Subtitle = "MY PROJECT",
    Columns = 3,
    AutoShow = true,
})

local Tabs = {
    Main = Window:AddTab("Main"),
    Settings = Window:AddTab("Settings"),
}

local Main = Tabs.Main:AddLeftGroupbox("General")
Main:AddToggle("Enabled", {Text = "Enabled", Default = true})
    :AddKeyPicker("EnabledKey", {
        Default = "F6",
        Mode = "Toggle",
        SyncToggleState = true,
    })

Main:AddSlider("Amount", {
    Text = "Amount", Min = 0, Max = 100,
    Default = 65, Rounding = 0, Suffix = "%",
})

Main:AddDropdown("Mode", {
    Text = "Mode",
    Values = {"Balanced", "Detailed", "Minimal"},
    Default = "Balanced",
})

Library.Toggles.Enabled:OnChanged(function(value)
    print("Enabled:", value)
end)

ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MintProject")
ThemeManager:ApplyToTab(Tabs.Settings)

SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("MintProject")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
```

## Layout and appearance

- Three columns above 900 px window width; two above 650 px; one on narrower screens. Groups move between columns without rebuilding controls.
- No font shrinking on phones. Touch controls have larger hit areas; tabs can scroll horizontally.
- Opaque black panels, small corner radii, thin borders, understated gradients and mint accents.
- Header-only dragging, viewport resize handling and camera replacement handling.
- Approximately 0.18-second fades and hover transitions, with cancellation of previous tweens.
- Notifications outside the window, with a colored edge and fade-in/out.
- Logo is a native UI vector trace. It needs no image asset upload, file API or HTTP request. The editable vector is [assets/mint-logo.svg](assets/mint-logo.svg).
- No permanent render loop or scene scans. Input and layout changes are event-driven.

## Tabs and groups

```lua
local tab = Window:AddTab("Main")
local left = tab:AddLeftGroupbox("Left")
local middle = tab:AddGroupbox("Middle", {Column = 2})
local right = tab:AddGroupbox("Right", {Column = 3})
local second = tab:AddRightGroupbox("Second column")

left:SetExpanded(false)
tab:Select()
```

`Window.Tabs.Main` and `Window.Tabs[1]` both reference tabs. Collapsing a group preserves its values.

## Controls

| Method | Main options |
| --- | --- |
| `AddToggle(id, options)` | `Text`, boolean `Default`, `Callback` |
| `AddSlider(id, options)` | `Min`, `Max`, `Default`, `Step` or `Rounding`, `Suffix` |
| `AddRangeSlider(id, options)` | Same bounds, `Default = {lower, upper}` |
| `AddDropdown(id, options)` | `Values`, `Default` as name/index, `Multi` |
| `AddInput(id, options)` | `Default`, `Placeholder`, `Numeric`, `MaxLength` |
| `AddButton(options)` | `Text`, `Func` or `Callback`, optional `Primary` |
| `AddLabel(text)` | Label handle with `SetText`, `AddKeyPicker`, `AddColorPicker` |
| `AddDivider()` | Thin separator |

Use `Tooltip` or `Description` for a separate **i** help button.

Controls expose `Value`, `Get()`, `Set(value, silent?)`, `SetValue(value)` and `OnChanged(callback)`. Values only enter profiles when they have a unique ID. Toggles are in `Library.Toggles`; other controls are in `Library.Options`. These registries are local to the library, not injected as globals.

Defaults do not invoke callbacks. A bad application callback is reported without stopping the interface.

### Dropdowns

Long lists have search. Multiselects have select all and clear; their values are ordered arrays of names. `SetValue` also accepts a map such as `{Alpha = true, Beta = true}`. `dropdown:SetValues(newValues)` updates the available list.

### Sliders

`Step = 0` gives a smooth value. `Rounding = 2` gives two decimal places. Clicking the displayed number permits direct input. Values are validated, clamped and rounded. Range sliders expose two handles and two number fields.

### Keybinds and colors

```lua
Main:AddToggle("Feature", {Text = "Feature"})
    :AddKeyPicker("FeatureKey", {
        Default = "MB2", -- keyboard names, MB1 or MB2
        Mode = "Hold", -- Toggle, Hold or Always
        SyncToggleState = true,
        Callback = function(active) print(active) end,
    })

Main:AddLabel("Accent"):AddColorPicker("Accent", {
    Default = Color3.fromRGB(116, 227, 174),
    Callback = function(color) Library:SetTheme({Accent = color}) end,
})
```

Escape clears a captured key. Key actions do not fire while typing in a textbox. Color popups include an HSV square, hue strip and HEX input.

## Theme manager

Five built-in palettes: Mint, Ice, Amber, Rose and Violet. The editor exposes every theme color. Custom palettes can be saved, selected and deleted.

```lua
ThemeManager:ApplyTheme("Ice")
ThemeManager:SaveCustomTheme("My palette")
ThemeManager:DeleteCustomTheme("My palette")

Library:SetTheme({
    Accent = Color3.fromRGB(116, 227, 174),
    Background = Color3.fromRGB(10, 12, 12),
})
```

Theme roles: `Background`, `Panel`, `Field`, `Border`, `Text`, `Muted`, `Accent`, `AccentText`, `Hover`, `White`.

## Config manager

Supports save, load, delete, refresh, ignored IDs and a selected autoload profile.

```lua
SaveManager:SetIgnoreIndexes({"TemporaryValue"})
SaveManager:Save("Default")
SaveManager:Load("Default")
SaveManager:SetAutoloadConfig("Default")
SaveManager:LoadAutoloadConfig()
SaveManager:Delete("Default")

local json = Library:ExportConfig()
local ok, errors = Library:ImportConfig(json)
```

Local persistence uses the environment's file APIs if available. Writes are verified by reading back the saved data. Without file APIs, managers use session memory and label this clearly in the settings panel. Themes live in `MintProject/themes`, configs in `MintProject/configs`. Names are validated; paths cannot escape the selected folder.

In standard Roblox, session memory and JSON export/import work; persistent player profiles need an application-side server/DataStore integration. Import ignores unknown IDs, reports rejected values and applies valid controls.

## Window and lifecycle

```lua
Window:SetVisible(false)
Window:SetAnimations(true)
Window:SetToggleKey(Enum.KeyCode.Insert)
Library:Notify("Ready", 3)
Window:Destroy()
Library:Unload() -- destroys every window and its listeners
```

The original `Tab`, `Section`, `Toggle`, `Slider`, `Dropdown`, `Textbox`, `ColorPicker` and `Keybind` methods remain available. Custom components can be registered with `Library:RegisterComponent(name, builder)`.

## Studio installation

Sync `default.project.json` with Rojo and run its included LocalScript. Or create a ModuleScript named `MintProject` in ReplicatedStorage using `src/init.luau`, add all other `src/*.luau` as children and require it from a LocalScript:

```lua
local Library = require(game:GetService("ReplicatedStorage"):WaitForChild("MintProject"))
local Window = Library:CreateWindow({Title = "MintProject"})
Window:AddTab("Main"):AddLeftGroupbox("General"):AddToggle("Enabled", {Text = "Enabled"})
```

Managers are also available as `Library.ThemeManager` and `Library.SaveManager`, without remote loading.

## Build and validation

```text
node scripts/logo.mjs
node scripts/build.mjs
lune run tests/smoke.luau
```

Editable source is in `src/`. `Library.lua`, `Example.lua`, `addons/` and `dist/` are generated; edit the source and rebuild.

Headless tests compile the code, validate native Roblox property types, simulate UI input, exercise config files and autoload using a mock filesystem, and check popup/lifecycle cleanup. The test loader maps Roblox's KeyCode.Unknown name to Lune's internal alias.

The layout previews below are rendered from the UI instance tree in a browser. They are layout approximations, **not screenshots from Roblox**. A connected Roblox client is still needed for final visual, touch and animation verification.

![Desktop layout preview](assets/preview/desktop-main.png)
![Settings layout preview](assets/preview/desktop-settings.png)
![Phone layout preview](assets/preview/mobile-main.png)

API naming reference: [LinoriaLib](https://github.com/violin-suzutsuki/LinoriaLib). No Linoria source is bundled and there is no runtime dependency on it.
