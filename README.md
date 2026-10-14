# Mat Tooltip (WoW: Forever) — private v0.1.0

> **Untested in-game.** WoW: Forever hasn't launched (Nov 4 2026). API calls were checked only against
> Blizzard's UI source (Gethe/wow-ui-source `forever` branch, 1.60.1 build 70374) and a mock harness.

Adds lines to item tooltips for **Leather (Skinning) and Herb** trade goods:

- **AH (your scan)**: the lowest per-unit buyout from your own last full AH scan (no internet, ever)
- **Vendor**: the vendor sell price from item info
- **NEVER VENDOR**: flag for scarce mats on your list (seeded: Pristine Leather 249427, Frilled Lichen 249399; IDs confirmed in auctionhouse.fyi's Forever item data, build 1.60.1.70009)
- One verdict: **SELL ON AH** / **VENDOR** / **HOLD**
  - AH price after the 5% faction cut beats vendor by 10% or more → SELL ON AH, otherwise VENDOR
  - no scan yet → HOLD; never-vendor items are SELL ON AH or HOLD, never VENDOR; scans older than 3 days say "price is old"

## Commands
`/mattip scan` (at an open AH, out of combat; Blizzard allows about one full scan every 15 minutes) ·
`/mattip never <id|link>` · `/mattip unnever <id>` · `/mattip list` · `/mattip margin 1.1` · `/mattip toggle`

It never buys, sells, posts or clicks anything for you. The scan only runs when you type the command.

## Install
Copy the `MatTooltip` folder to `World of Warcraft\_forever_\Interface\AddOns\` (folder name may differ; it's
the one next to `_retail_`/`_classic_`). Prices are stored in `WTF\Account\<acct>\SavedVariables\MatTooltip.lua`.

## Dev checks
`luacheck .` · `python3 tools/verify_api.py <wow-ui-source forever checkout> MatTooltip.lua` · `lua tools/mock_test.lua`
