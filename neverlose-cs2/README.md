# MintProject — Neverlose CS2 UI

## Run

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/neverlose-cs2/loader.luau"))()
```

Right Shift opens and closes the menu. Color swatches sit to the left of each ESP switch. The three-dot button opens the associated options.

The ESP tab contains player boxes, names, distance, health, held-item names and icons. Team check uses Defusal's T/CT attributes. Icons support a tintable white silhouette and original colors. Visual removals are separate switches in Visuals. Example contains the UI demonstration controls.

## Build

Run `node tools/build-neverlose-cs2.mjs` from this folder. The self-contained build is written to `dist/main.luau` and `MintProject Neverlose CS2.lua`. The PNG silhouettes are embedded in `assets/equipment/WhiteIcons.luau` and cached locally by the executor.

## Crosshair and markers in 2026.10.29.3

- No scope overlay removes the scope mask, edge bars and blur while keeping the zoom container intact. The normal game crosshair supplies the visible reticle while the scope mask is hidden.
- Force crosshair keeps the standard game crosshair visible with sniper rifles. Game crosshair edits its existing frames: length, width, gap, color, center dot and outline. These settings are inside its three-dot options button.
- No enemy markers hides the game's `Enemy_` indicators. No ping markers hides in-world ping markers without touching scoreboard ping values or MintProject ESP.
- Disabling features or unloading restores the controlled properties. Gameplay zoom and weapon data are not modified.

## UI repairs

- The HSV picker uses gradients drawn by Roblox, without an external color-map texture. Hex entry validates input. Dragging ends on release outside the popup or when the window loses focus.
- Compact options use the original 220-pixel panel style and inline sliders when they fit. Long rows move controls below the label when needed. Numbers are validated and clamped.
- The ESP options retain text size, distance, health thickness/gradient/numbers and original icon colors. Secondary outline/background color controls are hidden; existing saved values remain supported.
- Option and color panels stay inside the viewport. Closing the menu or changing tabs closes open panels. Nested color panels keep their parent options open.
- Unloading disconnects the added input handlers and restores modified visual properties.

Validation: Luau compilation; live HSV/HEX, slider bounds, layout and popup checks; Defusal ESP/icon/team checks; visual-property restoration tests. Desktop screenshot capture was unavailable, so these checks do not establish a complete visual audit on every display size.

## Third-party sources

The UI base is [NLCS2UI](https://github.com/0zdac/NLCS2UI) by 4lpaca, under the MIT license included in `library/NeverloseCS2/LICENSE`.

Equipment art originates from Defusal's Roblox image assets. Where a public source image was unavailable, silhouettes use corresponding stock weapon images listed by [CSGO-API](https://github.com/ByMykel/CSGO-API) or simple vector item symbols. Original-color mode uses the game's native image IDs. Third-party artwork retains its original ownership.
