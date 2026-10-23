# MintProject

Roblox interface using a mirrored copy of **Facility UI**, with a black-and-mint theme and square styling. The full library and every addon are stored in this repository.

## Run

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/MintProject.lua"))()
```

`Example.lua` forwards to the same entry point. **Right Shift** opens and closes the menu.

## Files

- [MintProject.lua](MintProject.lua): editable loader, mint palette, window, tabs and example controls. Add your own callbacks below the loader and theme settings.
- [library/main.luau](library/main.luau): Facility's full UI library; addon downloads point to this repository.
- [library/addons](library/addons): Icons, InterfaceManager, SaveManager and ThemeManager.
- [library/example.luau](library/example.luau): complete upstream API example, also using our mirror.
- [library/UPSTREAM.md](library/UPSTREAM.md): original project, snapshot revision and attribution.
- [library/UPSTREAM.json](library/UPSTREAM.json): original Git blob IDs and mirrored file hashes.

The loader provides Main, Elements and Settings tabs, theme editing, keybind settings and config management. These example controls demonstrate the interface; they do not implement gameplay features. Configs and themes use the `MintProject/Facility` storage namespace. File persistence depends on the client environment's file APIs; Facility also supports session memory.

The theme is restored before the window and its color pickers are created. Window preloading and ThemeManager both read `MintProject/Facility/settings/theme.json`; unrelated themes saved under `Facility/settings/theme.json` are not loaded. Mint is the first-run default. A previously saved MintProject theme takes priority on later runs. Use the paintbrush editor and confirm **save** when closing it to persist color changes; theme storage is separate from normal configs.

The original Facility repository can disappear without removing the library or its addons from this mirror. The interface still needs Roblox and GitHub connectivity for remote loading and Roblox-hosted assets.

This loader requires a client environment that supplies `loadstring` and `game:HttpGet`. For Studio, install the mirrored library and addons as ModuleScripts using Facility's module-loading layout instead.

Earlier MintProject code in `src/`, `dist/` and the old generated files is retained for reference. The current interface starts at **MintProject.lua** and uses **library/**.

## Attribution

Facility UI is from [FacilityHUB/UI-Facility-Test](https://github.com/FacilityHUB/UI-Facility-Test). The snapshot and modifications are documented in [UPSTREAM.md](library/UPSTREAM.md). MintProject's loader and mint preset are separate from that original library.
