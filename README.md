# MintProject

Roblox UI library with a black and green palette, mint accents, square panels, top tabs and subtle white gradients.

**Version: 0.1.0-preview.** This is the first interactive implementation of the agreed design. Button and toggle styling, glow and notification placement remain provisional. Rendered Roblox and device testing is still pending.

## Run the complete demo

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/dist/Demo.lua"))()
```

The demo is a single file, including the library. Open or close it with **Right Shift**, or the **M** button at the bottom left. Only the title bar drags the window. The Profiles tab includes a **Destroy demo** button.

The line above requires a client environment that provides both `loadstring` and `game:HttpGet`. Standard Roblox LocalScripts should use the ModuleScript installation below instead; they do not support this remote loader.

## Use the library

```lua
local Mint = loadstring(game:HttpGet("https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/dist/MintProject.lua"))()

local window = Mint:CreateWindow({
    Title = "My project",
    Width = 790,
    Height = 520,
    ToggleKey = Enum.KeyCode.RightShift,
})

local section = window:Tab("Settings"):Section("General")

section:Toggle({
    Id = "enabled",
    Text = "Enabled",
    Default = true,
    Callback = function(value) print("Enabled:", value) end,
})

section:Slider({
    Id = "volume",
    Text = "Volume",
    Description = "Drag the track or click its number to type a value.",
    Min = 0, Max = 100, Step = 1, Default = 65,
    Callback = function(value) print("Volume:", value) end,
})

section:Dropdown({
    Id = "features",
    Text = "Features",
    Multi = true,
    Options = {"Music", "Effects", "Notifications"},
    Default = {"Music"},
    Callback = function(values) print(table.concat(values, ", ")) end,
})

window:Notify("Ready")
```

## Components

All state controls expose `Get()` and `Set(value, silent?)`. Give controls unique `Id` strings to include them in profiles. Construction does not call callbacks. Callbacks are protected so an error in application code does not stop the menu.

| Method | Options beyond `Text`, `Id`, `Default`, `Callback` |
| --- | --- |
| `section:Button` | `Text`, `Callback`; returns the button Instance |
| `section:Toggle` | Boolean value |
| `section:Slider` | `Min`, `Max`, `Step`; `Step = 0` for smooth values |
| `section:RangeSlider` | `Min`, `Max`, `Step`, `Default = {lower, upper}` |
| `section:Dropdown` | `Options`, `Multi`; search appears above eight options |
| `section:Textbox` | `Placeholder`; string value |
| `section:Keybind` | `Default = Enum.KeyCode.F6`, `OnPress` |
| `section:ColorPicker` | `Default = Color3`; HSV square, hue strip and HEX input |
| `section:Label(text)` | Returns the text Instance |

State controls accept an optional `Description`, shown using a separate **i** button. Multiselects include select all and clear, and return their selections in option order. Escape clears a keybind while capturing it. Keybinds do not fire while typing in a text field.

## Window and theme

```lua
window:SetVisible(false)
window:SetAnimations(true)
window:SetToggleKey(Enum.KeyCode.Insert)
window:SetTheme({
    Accent = Color3.fromRGB(109, 227, 160),
    Background = Color3.fromRGB(9, 23, 14),
})
```

Theme roles: `Background`, `Panel`, `Field`, `Border`, `Text`, `Muted`, `Accent`, `AccentText`, `Hover`, `White`. Supply a `Theme` table to `CreateWindow` or change roles later. Transitions last approximately 0.18 seconds. Notifications live outside the main window.

The initial window size is clamped to the available viewport. Controls support mouse and touch input. A dedicated mobile layout, viewport rotation handling, inline toggle keybinds and full visual polish remain on the roadmap.

## Profiles

```lua
window:SaveProfile("Default")
local ok, errorMessage = window:LoadProfile("Default")
local json = window:ExportConfig()
local imported, failures = window:ImportConfig(json)
```

Named profiles stay in memory in the current library instance. JSON export/import supports keeping a copy across sessions; this preview does not automatically write files or DataStores. Import ignores unknown control IDs and reports rejected controls. Valid controls are applied even if another control is rejected. Theme changes are saved when represented by registered color controls, as in the demo.

`window:Destroy()` removes its GUI and disconnects input and component events. `Mint:Destroy()` destroys all windows created by that library instance. The standalone demo destroys its previous instance when run again in the same shared environment.

## Standard Roblox Studio installation

Sync `default.project.json` using Rojo, then play the project. It installs:

- `ReplicatedStorage.MintProject` from `src/`, as a ModuleScript with child modules.
- `ReplicatedStorage.MintProjectDemo` from `examples/Demo.luau`.
- A demo LocalScript in `StarterPlayerScripts`.

Without Rojo, create a ModuleScript named `MintProject`, paste `src/init.luau` into it and add child ModuleScripts `Core`, `Components` and `Window` using their corresponding source files. Place it in ReplicatedStorage and call it from a LocalScript:

```lua
local Mint = require(game:GetService("ReplicatedStorage"):WaitForChild("MintProject"))
local window = Mint:CreateWindow({Title = "MintProject"})
window:Tab("Home"):Section("General"):Label("Ready")
```

## Custom components

Register a builder before creating sections. Builders receive the UI context, section and options. Register connections with `ctx:Connect` so they are cleaned up by `Destroy`.

```lua
Mint:RegisterComponent("Status", function(ctx, section, options)
    local label = ctx:Text(options.Text or "Ready", section.Body)
    ctx:Bind(label, "TextColor3", "Accent")
    return label
end)

section:Status({Text = "Connected"})
```

## Source and checks

`src/` contains editable modules. `scripts/build.mjs` generates `dist/MintProject.lua` and `dist/Demo.lua`; do not edit generated bundles directly.

```text
node scripts/build.mjs
lune run tests/smoke.luau
```

Tests compile the modules and bundles, construct the UI against Lune's native Roblox property types, simulate input signals, and check controls, profiles and cleanup. They are headless contract tests, not rendered Roblox verification. The test loader maps Roblox's `KeyCode.Unknown` to Lune's internal `KeyCode.None` alias; published bundles keep the Roblox spelling.

This library contains interface components and a demonstration only. Game behavior belongs in the application that uses it.
