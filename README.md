# WoW: Forever addons

AI-assisted addons for WoW: Forever (Classic+, Midnight 12.1.5 addon API, Interface 16001), aimed at gathering and gold-making within the rules.
**No gameplay automation:** they work out the answer ahead of time and show one clear prompt; you press every action yourself.

> **Moved:** since 2026-10-26 each addon lives in its own repo, which is where releases, issues and CurseForge/Wago packaging happen. This repo is kept as an index. The code below is frozen at the 2026-10-18 versions, and its existing GitHub releases stay as they are.

| Addon | Repo | What it does | Slash |
|---|---|---|---|
| NeutralFlip | [masterred92/NeutralFlip](https://github.com/masterred92/NeutralFlip) | Compares your faction AH with the neutral goblin AH (Booty Bay / Gadgetzan / Everlook) and lists flips worth carrying, after the 5%/15% cut. TomTom waypoint and LDB launcher | `/nflip` |
| PriceLog | [masterred92/PriceLog](https://github.com/masterred92/PriceLog) | Logs prices from your own AH scans and searches, CSV export, rising/falling/stable trends. LDB launcher | `/pricelog`, `/kpl` |
| MatTooltip | [masterred92/MatTooltip](https://github.com/masterred92/MatTooltip) | AH price, vendor price and a SELL ON AH / VENDOR / HOLD verdict on Skinning and Herbalism mats, plus a never-vendor flag. Bagnon badges and LDB bag value | `/mattip`, `/kmt` |
| GoldPerSpot (was FarmTracker) | [masterred92/GoldPerSpot](https://github.com/masterred92/GoldPerSpot) | Gold/hour for a farming session, top items, session history and a "this spot vs your best" verdict. LDB launcher | `/goldspot`, `/kspot` |
| BRBoss (new) | [masterred92/BRBoss](https://github.com/masterred92/BRBoss) | `/brb 5` starts DBM's or BigWigs' own break bar and plays a vanilla boss line when it ends. Optional Pull Quote at pull 0 | `/brb` |
| WipeAndWin (new) | [masterred92/WipeAndWin](https://github.com/masterred92/WipeAndWin) | Vanilla boss lines as DBM Victory/Defeat sounds and LibSharedMedia sounds for BigWigs (DBM's defeat list is empty on Forever) | `/wipewin` |
| FloorIsLava (new) | [masterred92/FloorIsLava](https://github.com/masterred92/FloorIsLava) | Details! plugin: after-combat board of avoidable damage taken and deaths | `/lava` |
| QuestieJobsDone (new) | [masterred92/QuestieJobsDone](https://github.com/masterred92/QuestieJobsDone) | Questie plugin: a peon "Job's done!" when a quest's objectives are finished, with an optional party ping | `/jd` |
| ParchmentBars (new) | [masterred92/ParchmentBars](https://github.com/masterred92/ParchmentBars) | BigWigs bar style "Old Parchment", made from client textures | `/parchment` |
| GruntCount (new) | [masterred92/GruntCount](https://github.com/masterred92/GruntCount) | BigWigs countdown voices from client sounds: "Critters" (gnome, goblin, gnoll, kobold, murloc) and "Work Work" (peon) | `/gruntcount` |
| RecipeMaster (new) | [masterred92/RecipeMaster](https://github.com/masterred92/RecipeMaster) | Pick a material and see every recipe that uses it, with prices from PriceLog, Auctionator, TSM or Auctioneer, profit and crafting chains. Inspired by Terraria's Guide | `/rmaster`, `/craftguide` |

Downloads (first release at launch, Nov 4). Report bugs on each addon's own GitHub Issues page.

| Addon | CurseForge | Wago |
|---|---|---|
| NeutralFlip | [curseforge.com/wow/addons/neutralflip](https://www.curseforge.com/wow/addons/neutralflip) | [addons.wago.io/addons/neutralflip](https://addons.wago.io/addons/neutralflip) |
| PriceLog | [curseforge.com/wow/addons/pricelog](https://www.curseforge.com/wow/addons/pricelog) | [addons.wago.io/addons/pricelog](https://addons.wago.io/addons/pricelog) |
| MatTooltip | [curseforge.com/wow/addons/mattooltip](https://www.curseforge.com/wow/addons/mattooltip) | [addons.wago.io/addons/mattooltip](https://addons.wago.io/addons/mattooltip) |
| GoldPerSpot | [curseforge.com/wow/addons/goldperspot](https://www.curseforge.com/wow/addons/goldperspot) | [addons.wago.io/addons/goldperspot](https://addons.wago.io/addons/goldperspot) |
| BRBoss, WipeAndWin, FloorIsLava, QuestieJobsDone, ParchmentBars, GruntCount, RecipeMaster | maybe later | coming at launch (Nov 4); GitHub until then |

## Packages

Suggested bundles. Install each addon on its own: neither Wago nor CurseForge has a WoW addon-pack feature that works on Forever yet (Wago UI Packs don't list Interface 16001, and CurseForge profile codes are Minecraft-only).

| Bundle | Ours | Pair with |
|---|---|---|
| **Raid night** | BRBoss, FloorIsLava, WipeAndWin (+ ParchmentBars, GruntCount on BigWigs) | DBM or BigWigs, Details! |
| **Goblin / AH** | NeutralFlip, PriceLog, MatTooltip, GoldPerSpot, RecipeMaster | An LDB display (ElvUI, Titan Panel, Bazooka, ChocolateBar); optional Bagnon, TomTom |
| **Leveling** | QuestieJobsDone | Questie, TomTom |
| **Just for laughs** | GruntCount, WipeAndWin, BRBoss (pull quotes on), QuestieJobsDone | BigWigs, DBM or BigWigs, Questie |

Author profile: [MasterRed92 on CurseForge](https://www.curseforge.com/members/masterred92/projects).
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
