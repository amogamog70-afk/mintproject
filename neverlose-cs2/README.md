# MintProject — Neverlose CS2 UI

## Run

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/neverlose-cs2/loader.luau"))()
```

Right Shift opens and closes the menu. Color swatches sit to the left of each ESP switch. The three-dot button opens the associated options.

The ESP tab contains player boxes, names, distance, health, held-item names and icons. Team check uses Defusal's T/CT attributes. Icons support a tintable white silhouette and original colors. Visual removals are separate switches in Visuals. Example contains the UI demonstration controls.

## Build

Run `node tools/build-neverlose-cs2.mjs` from this folder. The self-contained build is written to `dist/main.luau` and `MintProject Neverlose CS2.lua`. The PNG silhouettes are embedded in `assets/equipment/WhiteIcons.luau` and cached locally by the executor.

## UI repairs in 2026.10.29.1

- The HSV picker uses gradients drawn by Roblox, without an external color-map texture. Hex entry validates input. Dragging ends on release outside the popup or when the window loses focus.
- Sliders reserve a separate line below the label, validate numbers and clamp their range. Long rows also move their controls below the label when needed.
- Option and color panels stay inside the viewport. Closing the menu or changing tabs closes open panels. Nested color panels keep their parent options open.
- Unloading disconnects the added input handlers and restores modified visual properties.

Validation: Luau compilation; live HSV/HEX, slider bounds, layout and popup checks; Defusal ESP/icon/team checks; visual-property restoration tests. Desktop screenshot capture was unavailable, so these checks do not establish a complete visual audit on every display size.

## Third-party sources

The UI base is [NLCS2UI](https://github.com/0zdac/NLCS2UI) by 4lpaca, under the MIT license included in `library/NeverloseCS2/LICENSE`.

Equipment art originates from Defusal's Roblox image assets. Where a public source image was unavailable, silhouettes use corresponding stock weapon images listed by [CSGO-API](https://github.com/ByMykel/CSGO-API) or simple vector item symbols. Original-color mode uses the game's native image IDs. Third-party artwork retains its original ownership.
