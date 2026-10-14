# WoW: Forever addons

> [!WARNING]
> **Untested in-game. Use at your own risk.** WoW: Forever has not launched yet (Nov 4 2026), so none of this has run in the real client.
> - API usage is verified against Blizzard's UI source only (Gethe/wow-ui-source `forever` branch, 1.60.1 build 70374), plus luacheck and a mock harness.
> - Mat item IDs were checked against auctionhouse.fyi's Forever item data (build 1.60.1.70009), not in-game.
> - `## Interface: 16001` is unconfirmed (the UI source .toc files show `0`).
> - Found a bug? Please [open an issue](https://github.com/masterred92/wow-forever-addons/issues).

AI-assisted addons for WoW: Forever (Classic+, Midnight 12.1.5 API). No gameplay automation: they work out the answer ahead of time and you press every action yourself. No network access.

| Addon | Status |
|---|---|
| [MatTooltip](MatTooltip/) | v0.1.0: AH/vendor price and SELL/VENDOR/HOLD verdict on Skinning and Herbalism mats |
| Farm session tracker | planned |
| Price log exporter | planned |

## Install
Copy an addon folder (e.g. `MatTooltip`) into `World of Warcraft\_forever_\Interface\AddOns\` (the folder next to `_retail_`; exact name may differ), then restart the game or `/reload`.

## Dev checks
```
luacheck .
python3 MatTooltip/tools/verify_api.py <wow-ui-source forever checkout> MatTooltip/MatTooltip.lua
cd MatTooltip && lua tools/mock_test.lua
```

MIT licensed.
