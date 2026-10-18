package.path = "tests/?.lua;" .. package.path
local W = require("mock_wow"); W.install()
local check = W.check
W.loadAddon("PriceLog", "PriceLog"); W.fire("PLAYER_LOGIN")
local ns = W.loadAddon("FarmTracker", "FarmTracker")
local FT, db = KennyFarmTracker, KennyFarmTrackerDB
check(db.schema == 1 and _G["KennyFarmTrackerFrame"], "loaded, frame created with unique name")
check(db.point == nil, "default position not stored")

KennyPriceLog.Record(2318, "Light Leather", 100, nil, 10, "scan", W.now) -- AH 100c, vendor 15c
W.money = 1000
W.bags[0] = { [1] = { 2318, 5 } }
FT.Start("Westfall boars")
W.bags[0][1] = { 2318, 9 }; W.bags[0][2] = { 2447, 3 }
W.fire("BAG_UPDATE_DELAYED")

-- coin only while loot window open
W.fire("LOOT_OPENED"); W.money = 1500; W.fire("PLAYER_MONEY"); W.fire("LOOT_CLOSED")
W.money = 2500; W.fire("PLAYER_MONEY") -- e.g. quest reward: not counted
-- merchant purchase doesn't count
W.fire("MERCHANT_SHOW"); W.bags[0][3] = { 2589, 20 }; W.fire("BAG_UPDATE_DELAYED"); W.fire("MERCHANT_CLOSED")
W.fire("BAG_UPDATE_DELAYED")
-- combat: bag diff deferred until combat ends
W.combat = true; W.bags[0][1] = { 2318, 10 }; W.fire("BAG_UPDATE_DELAYED")
W.combat = false; W.fire("PLAYER_REGEN_ENABLED")
-- secret stack count ignored
W.bags[0][4] = { 249399, 77 }; W.secret[77] = true; W.fire("BAG_UPDATE_DELAYED"); W.secret[77] = nil
-- pause: gains ignored
FT.Pause(); W.bags[0][5] = { 249427, 1 }; W.fire("BAG_UPDATE_DELAYED"); W.clock = W.clock + 500; FT.Pause()
W.clock = W.clock + 1800
local lines = FT.Lines()
-- 5 leather * 95c (AH net) + 3 peacebloom * 10c vendor + 500 coin = 475 + 30 + 500 = 1005 copper in 1800s
check(lines[2] == "Total 1005c   2010c/hr", "total and gold/hour: " .. tostring(lines[2]))
check(lines[3] == "Coin 500c", "coin while looting only: " .. lines[3])
check(lines[4]:find("5x Light Leather", 1, true) and lines[5]:find("(v)", 1, true), "top items with vendor marker")
local joined = table.concat(lines, "\n")
check(not joined:find("Linen", 1, true) and not joined:find("Frilled", 1, true) and not joined:find("Pristine", 1, true),
  "purchase, secret slot and paused loot not counted")
check(lines[#lines]:find("first saved session", 1, true), "verdict with no history")
FT.Stop()
check(#db.spots["Westfall boars"].sessions == 1 and db.spots["Westfall boars"].sessions[1].copper == 1005, "session saved under spot")

-- second spot, worse rate -> compare against best
W.zone = "Loch Modan"
FT.Start(); W.bags[0][6] = { 2447, 6 }; W.fire("BAG_UPDATE_DELAYED"); W.clock = W.clock + 3600
local v = FT.Lines()
check(v[#v]:find("vs your best 0.2g/hr (Westfall boars) - consider Westfall boars", 1, true), "verdict vs best: " .. v[#v])
check(FT.Verdict("X", 999999, db.spots):find("NEW BEST", 1, true), "new best")
SlashCmdList.KENNYFARMTRACKER("value vendor")
check(db.settings.valuation == "vendor", "valuation setting stored")
SlashCmdList.KENNYFARMTRACKER("value ah")
check(db.settings.valuation == nil, "default valuation stores nil")
FT.Stop()
check(db.spots["Loch Modan"], "zone used as spot name")
SlashCmdList.KENNYFARMTRACKER("report")
check(_G["KennyFarmTrackerReportWindow"].shown, "bug report window")
check(#ns.Core.errors == 0, "no errors recorded: " .. (ns.Core.errors[1] and ns.Core.errors[1].msg or ""))
W.done("FarmTracker")
