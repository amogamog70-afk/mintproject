# MintProject — Neverlose CS2 UI

## Run

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/amogamog70-afk/mintproject/main/neverlose-cs2/loader.luau"))()
```

Right Shift opens and closes the menu. Color swatches sit to the left of each ESP switch. The three-dot button opens the associated options.

The ESP tab contains player boxes, names, distance, health, held-item names and icons. Team check uses Defusal's T/CT attributes. Icons support a tintable white silhouette and original colors. Visual removals are separate switches in Visuals. Example contains the UI demonstration controls.

## Build

Run `node tools/build-neverlose-cs2.mjs` from this folder. The self-contained build is written to `dist/main.luau` and `MintProject Neverlose CS2.lua`. The PNG silhouettes are embedded in `assets/equipment/WhiteIcons.luau` and cached locally by the executor.

## World visuals in 2026.10.29.6

- Visuals → Crosshair → No sniper zoom keeps the camera at the game's normal field of view while scoped. Scope state and the separate scope-overlay controls continue working. Turning it off restores the game's requested zoom.
- Visuals → World contains World lighting, Shadow color, Custom skybox, Custom fog and World tint. Color swatches precede switches; three-dot buttons contain their compact options.
- Lighting options include brightness, exposure, time of day and sunlight color. Shadow color controls Ambient and OutdoorAmbient, with shadow casting and softness in its options.
- Skybox options contain 30 presets, rotation, star count and sun/moon visibility. The 28 downloadable PNG cubemaps load only when selected and cache under `MintProject/Skyboxes/v1`; Classic blue and Sunset use Roblox assets. All six faces are preloaded before replacing the previous sky. Late results cannot overwrite a newer choice. If loading fails, the previous appearance stays in place and a notification offers retry.
- Fog includes color, start/end distances, atmospheric density and haze. World tint provides a separate tint, contrast and saturation effect. Properties restore on disable/unload and new map skies/atmospheres are handled through events.
- Dropdowns inside options keep their parent panel open during selection, fit within the viewport and close with the menu.

Validation: compiled the complete build; live checks for FOV enforcement/restoration, lighting overrides/restoration, shadow settings, fog range clamping, atmosphere, tint, sky controls and sky restoration. All 168 downloadable source faces were checked for valid PNG headers/dimensions. Aurora, Sunset and Classic blue were loaded through the live client. Complete visual screenshot review remains unavailable.

## Shot effects in 2026.10.29.7

- Visuals → Removals → No bullet effects suppresses cosmetic shot effects. Its three-dot options independently select Bullet tracers, Impact particles, Bullet holes and Blood effects; all four filters default on, and the master defaults off.
- No damage numbers is a separate switch for the game's floating damage-number billboards.
- Classification follows Defusal's actual effect containers: pooled Trails under Terrain, laser Beams under the camera's `_TrailHolder`, material/blood particles in `Terrain.phold`, and ImageHandleAdornments tagged `BulletHole`. Damage-number billboards use `PlayerGui.BBG`. Muzzle flash remains its existing independent setting.
- Property overrides handle game updates and restore on disable/unload. Pooled effects are released when unparented and detected when reused; transient targets are removed. No additional frame loop or projectile/weapon-data changes are used.

Validation: full Luau compilation and live fixtures for all four filters, master toggling, manual-emission transparency, late BulletHole tagging, pooled Trail reuse, transient-target cleanup, native damage-number template restoration, and exclusions for weapon ammo meshes/decorative trails. Complete screenshot review remains unavailable.

## Fixed ESP size in 2026.10.29.8

ESP → Enabled → three-dot options contains Fixed size (on by default), Box width and Box height. The default box measures 64×112 screen pixels at every distance and player rotation. Text keeps its configured pixel size; health bars, names, distance and equipment remain positioned relative to the box. Fixed mode projects only the center and skips periodic body measurement/eight-corner projection. Turning Fixed size off restores the original body-bound projection.

Validation: full Luau compilation; fixed dimensions at 10/40/200/1000 studs and four rotations; custom width/height; behind-camera/offscreen hiding; dynamic-mode distance scaling; live box/health-bar alignment and reload cleanup. Complete screenshot review remains unavailable.

## Crosshair and markers

- No scope overlay removes the scope mask, edge bars and blur while keeping the zoom container intact. Four white sniper-reticle lines replace the mask. Its options control line length, center gap, spin and spin speed.
- Force crosshair keeps the standard game crosshair visible with sniper rifles. Game crosshair edits its existing frames: length, width, gap, color, center dot and outline. These settings are inside its three-dot options button.
- Both reticles have independent Spin and Spin speed controls. Speed is measured in degrees per second. The animation uses one shared render connection, which stops when neither visible reticle is rotating. Turning Spin off restores the regular orientation.
- Both reticles have Size (25–300%) and Transparency (0–100%). Size scales line length, width, gap and center dot together. Transparency 0% is fully visible; 100% also hides the outline and stops the invisible reticle's animation.
- No enemy markers hides the game's `Enemy_` indicators. No ping markers hides in-world ping markers without touching scoreboard ping values or MintProject ESP.
- Disabling features or unloading restores the controlled properties. Weapon data is not modified.

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

Skybox PNG sets are linked unchanged from [purplesstrat/skyboxes](https://github.com/purplesstrat/skyboxes), pinned at `2198292ca0f7f5a8d224eb14e78d82addc8f390b`, under Apache-2.0 (`assets/skyboxes/LICENSE`). The preset registry adapts their names and adds Roblox Classic blue and Sunset. Sunset's six Roblox asset IDs are documented in [VISUALBOSS](https://github.com/scotdotwtf/VISUALBOSS); the images remain Roblox-hosted assets.
