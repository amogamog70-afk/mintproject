# Facility UI source mirror

Original project: https://github.com/FacilityHUB/UI-Facility-Test

Snapshot: [`a91649b5ef8a8bec2888aa5e668a768056506183`](https://github.com/FacilityHUB/UI-Facility-Test/tree/a91649b5ef8a8bec2888aa5e668a768056506183), committed 2026-10-19. Mirrored on 2026-10-23.

This directory contains all six source files from that snapshot, including the Icons, InterfaceManager, SaveManager and ThemeManager addons. The only source edits redirect the library's addon URL and the upstream example's loader URL to this repository. Original code and comments are otherwise preserved.

`UPSTREAM.json` records the original Git blob IDs, the mirrored SHA-256 hashes and the changes made to each file. The upstream snapshot does not contain a license file. This mirror preserves attribution and does not claim authorship of or relicense Facility's code.

The MintProject theme and editable entry point are in [`../MintProject.lua`](../MintProject.lua). Loading the current interface does not require the original Facility GitHub repository. Roblox-hosted icons and any optional service APIs used by the library remain external services.
