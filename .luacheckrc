std = "lua51"
max_line_length = false
exclude_files = { "**/tools/**", "tests/**", "dist/**" }
-- Our own globals (all Kenny-prefixed except the legacy MatTooltipDB, read once for migration).
globals = { "KennyMatTooltip", "KennyMatTooltipDB", "MatTooltipDB", "KennyFarmTracker", "KennyFarmTrackerDB",
  "KennyPriceLog", "KennyPriceLogDB", "SlashCmdList",
  "SLASH_KENNYMATTOOLTIP1", "SLASH_KENNYMATTOOLTIP2", "SLASH_KENNYFARMTRACKER1", "SLASH_KENNYFARMTRACKER2",
  "SLASH_KENNYPRICELOG1", "SLASH_KENNYPRICELOG2" }
-- WoW API read by the addons; every one is checked against Blizzard's UI source by tools/verify_api.py.
read_globals = { "C_Item", "C_AuctionHouse", "C_Timer", "C_Container", "C_AddOns", "C_RestrictedActions",
  "CreateFrame", "UIParent", "GameTooltip", "ItemRefTooltip", "TooltipDataProcessor", "Enum",
  "GetMoneyString", "GetMoney", "GetTime", "GetRealZoneText", "GetBuildInfo", "GetLocale", "GetRealmName",
  "UnitFactionGroup", "UnitAffectingCombat", "issecretvalue", "NUM_BAG_SLOTS", "NUM_TOTAL_EQUIPPED_BAG_SLOTS",
  "time", "date" }
