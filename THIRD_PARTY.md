# Third-party material

These addons contain **no third-party code and ship no third-party data.** Everything in `shared/`,
the three addon folders, `tools/` and `tests/` was written for this repository and is MIT licensed (see `LICENSE`).

| Component | Used for | Licence | Where / revision |
|---|---|---|---|
| Blizzard UI source, via [Gethe/wow-ui-source](https://github.com/Gethe/wow-ui-source) | Reference only: `tools/verify_api.py` checks that every API name we call exists. Nothing is copied or shipped. | Blizzard's | `forever` branch, commit `735496de78eb`, client 1.60.1 build 70374 (Oct 13 2026) |
| [auctionhouse.fyi](https://auctionhouse.fyi) Forever item data | Facts only: confirming item IDs (Pristine Leather 249427, Frilled Lichen 249399, plus test IDs 2318, 2447, 2589) and their class/subclass. No data is shipped. | n/a (facts) | item build 1.60.1.70009, checked Oct 14 and Oct 18 2026 |
| [Polestar](https://github.com/fitzforge/polestar) | Ideas only (Compat layer, schema'd SavedVariables, bug-report window, release flow, plugin registration). **No Polestar code was copied**; it is GPL-3.0 and this repo is MIT. | GPL-3.0 | studied at `next` 6d66e054 (v0.2.5) |

Runtime prices come only from **your own** auction house scans and searches inside the game.
The addons have no network access and read no outside data.
