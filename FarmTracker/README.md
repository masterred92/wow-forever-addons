# Farm Tracker (WoW: Forever) v0.1.0

> [!WARNING]
> **Untested in-game. Use at your own risk.** WoW: Forever has not launched yet (Nov 4 2026), so none of this has run in the real client.
> - API usage is verified against Blizzard's UI source only (Gethe/wow-ui-source `forever` branch, 1.60.1 build 70374), plus luacheck and mock-client tests.
> - Item IDs were checked against auctionhouse.fyi's Forever item data (build 1.60.1.70009), not in-game.
> - `## Interface: 16001` is unconfirmed (the UI source .toc files show `0`).
> - Found a bug? Use the addon's `report` command and [open an issue](https://github.com/masterred92/wow-forever-addons/issues).

Tracks a farming session and shows, in a small movable frame:
- spot name and session time
- total value and **gold per hour**
- coin looted
- the top 5 items by value (`(v)` = valued at vendor price)
- a verdict such as `this spot: 3.2g/hr vs your best 4.5g/hr (Westfall boars)`. Under 75% of your best it adds "consider <best spot>"; beating it shows "NEW BEST".

How it counts:
- **Items:** it compares your bags before and after, so skinning, herbs and loot all count in any language. Changes while a vendor, mailbox, bank, trade or AH window is open are ignored, so purchases and mail don't count. Bag changes during combat are counted when combat ends.
- **Coin:** only money gained while a loot window is open (not quest rewards or sales).
- **Value:** your newest AH scan price (PriceLog or MatTooltip) minus the 5% AH cut, or the vendor price if there's no scan. `/kfarm value vendor` forces vendor prices.
- **History:** sessions of 1 minute or more are saved per spot (up to 50 each). Only sessions of 5 minutes or more count as a "best".

Read-only: it never loots, clicks or moves for you.

## Commands
`/kfarm start [spot name]` (default: the zone name) · `pause` / `resume` · `stop` · `show` / `hide` · `lock` · `resetpos` · `history` · `value ah|vendor` · `report` · `reset confirm`
The frame has Start, Pause, Stop and Bug (report) buttons.

## Install
1. Download the addon zip from [Releases](https://github.com/masterred92/wow-forever-addons/releases) (or copy the folder from this repo).
2. Put the addon folder (e.g. `FarmTracker`) in `World of Warcraft\_forever_\Interface\AddOns\`. That folder sits next to `_retail_`; the exact name may differ.
3. Restart the game, or type `/reload`. Check it is ticked in the AddOns list on the character screen.

## In-game test checklist
1. The frame appears at the left middle of the screen, doesn't overlap the minimap, quest tracker or Polestar, and can be dragged; its position survives `/reload`.
2. Click Start, then skin 5 beasts and pick 5 herbs: the item counts match what entered your bags.
3. Loot coin from a mob: Coin goes up. Hand in a quest with a gold reward: Coin does **not** change.
4. Buy something from a vendor during a session: it is **not** counted.
5. Loot during combat: it's counted once combat ends, with no errors or "action blocked".
6. Pause, loot something, Resume: the paused loot is not counted and the timer stopped while paused.
7. With PriceLog or MatTooltip scan data, mats show AH value (no `(v)`). Without a scan, they show `(v)`.
8. Stop after 5 or more minutes, farm a second spot, and check the verdict line compares the two. `/kfarm history` lists both.
9. `/kfarm report` or the Bug button: a copyable report opens.
