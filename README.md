# WoW: Forever addons

> [!WARNING]
> **Untested in-game. Use at your own risk.** WoW: Forever has not launched yet (Nov 4 2026), so none of this has run in the real client.
> - API usage is verified against Blizzard's UI source only (Gethe/wow-ui-source `forever` branch, 1.60.1 build 70374), plus luacheck and mock-client tests.
> - Item IDs were checked against auctionhouse.fyi's Forever item data (build 1.60.1.70009), not in-game.
> - `## Interface: 16001` is unconfirmed (the UI source .toc files show `0`).
> - Found a bug? Use the addon's `report` command and [open an issue](https://github.com/masterred92/wow-forever-addons/issues).

AI-assisted addons for WoW: Forever (Classic+, Midnight 12.1.5 addon API, Interface 16001), aimed at gathering and gold-making within the rules.
**No gameplay automation:** they work out the answer ahead of time and show one clear prompt; you press every action yourself.

> **Moved:** since 2026-10-26 each addon lives in its own repo, which is where releases, issues and CurseForge/Wago packaging happen. This repo is kept as an index. The code below is frozen at the 2026-10-18 versions, and its existing GitHub releases stay as they are.

| Addon | Repo | What it does | Slash |
|---|---|---|---|
| NeutralFlip (new) | [masterred92/NeutralFlip](https://github.com/masterred92/NeutralFlip) | Compares your faction AH with the neutral goblin AH (Booty Bay / Gadgetzan / Everlook) and lists flips worth carrying, after the 5%/15% cut | `/nflip` |
| PriceLog | [masterred92/PriceLog](https://github.com/masterred92/PriceLog) | Logs prices from your own AH scans and searches, CSV export, rising/falling/stable trends | `/pricelog`, `/kpl` |
| MatTooltip | [masterred92/MatTooltip](https://github.com/masterred92/MatTooltip) | AH price, vendor price and a SELL ON AH / VENDOR / HOLD verdict on Skinning and Herbalism mats, plus a never-vendor flag | `/mattip`, `/kmt` |
| GoldPerSpot (was FarmTracker) | [masterred92/GoldPerSpot](https://github.com/masterred92/GoldPerSpot) | Gold/hour for a farming session, top items, session history and a "this spot vs your best" verdict | `/goldspot`, `/kspot` |

CurseForge and Wago pages are coming soon. Author profile: [MasterRed92 on CurseForge](https://www.curseforge.com/members/masterred92/projects).
FarmTracker was renamed to GoldPerSpot because several CurseForge addons already use "FarmTracker". Sessions saved by the FarmTracker 0.1.0 pre-release don't carry over.

The rest of this page describes the frozen monorepo snapshot.

## Install
1. Download the addon zip from [Releases](https://github.com/masterred92/wow-forever-addons/releases) (or copy the folder from this repo).
2. Put the addon folder (e.g. `FarmTracker`) in `World of Warcraft\_forever_\Interface\AddOns\`. That folder sits next to `_retail_`; the exact name may differ.
3. Restart the game, or type `/reload`. Check it is ticked in the AddOns list on the character screen.

## Running alongside other addons (e.g. Polestar)
- All globals, SavedVariables, slash keys and frame names are `Kenny`-prefixed, so they can't collide.
- The tooltip hook only *adds* lines after existing ones and never clears or rewrites another addon's lines.
- The FarmTracker frame starts at the left middle of the screen, away from the top-right minimap/quest/guide area and the bottom action bars. It's movable, clamped to the screen, `/kfarm lock` locks it and `/kfarm resetpos` resets it.
- Report and export windows only open when you ask for them.

## Plugin API
- `KennyMatTooltip.RegisterProvider{ id, format = 1, priority, title, author, version, getLine = function(itemID) return text end }` adds a tooltip line.
- `KennyPriceLog.RegisterSource{ id, format = 1, getPrice = function(itemID) return copper end, onScan = function(summary) end }` adds a fallback price source or receives scan summaries.
- Plugin addons can add `## X-KennyAddons-Plugin: 1` to their TOC so `/mattip plugins` and `/pricelog plugins` list them.
- Every plugin call is wrapped in `pcall`. A plugin is switched off after 3 errors, plugins with a newer `format` are rejected, and errors appear in the bug report.

## Development
```
tools/test.sh <wow-ui-source checkout, forever branch>   # sync check, release check, luac, luacheck, API verify, mock tests
tools/sync_shared.sh                                      # copy shared/Compat.lua + Core.lua into each addon
node tools/release.js version FarmTracker 0.1.1           # bump one addon's version everywhere
node tools/release.js pack                                # dist/*.zip (byte-reproducible) + SHA256SUMS
```
See [THIRD_PARTY.md](THIRD_PARTY.md) and [CHANGELOG.md](CHANGELOG.md). MIT licensed.
