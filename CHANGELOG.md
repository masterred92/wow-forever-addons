# Changelog

## 2026-10-18
### For players
- **New: FarmTracker 0.1.0**: gold/hour for farming sessions, with top items and a "this spot vs your best" verdict.
- **New: PriceLog 0.1.0**: logs prices from your own AH scans and searches; `/pricelog export` gives a CSV; rising/falling/stable trends.
- **MatTooltip 0.2.0**: uses PriceLog prices when they're newer; tooltip-provider plugin API; `/mattip report` bug report; settings migrate from 0.1.0 automatically.
- All three are still **untested in-game**.
### For developers
- Shared `Compat.lua` (feature-tested API calls, secret values treated as unknown) and `Core.lua` (defaults-in-code SavedVariables with schema migrations, error ring buffer, bug-report window, plugin registry).
- Unique `Kenny*` globals, SavedVariables, slash keys and frame names, so they run alongside other addons such as Polestar.
- `tools/release.js` (version sync, reproducible zips, SHA256SUMS), `tools/test.sh`, mock-client tests, generic `tools/verify_api.py`.

## 2026-10-14
- MatTooltip 0.1.0.
