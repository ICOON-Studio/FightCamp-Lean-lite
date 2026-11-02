# UI CENSUS (S227) - every screen through Ludo, one per round (operator: "all screens must be checked by ludo keeping a smooth look
# across all game and menus modals tooltips etc")

Stills: `previews/ui_census_s227/` (tools/ui_census_stills.gd -- as_game, a fresh UK career, 1920x1080), overview
`previews/ui_census_s227_overview.jpg`. Binding look: Ludo round 70 (UI bible). Builder: the UI owner (cloud Cursor).
Each Ludo round in a FRESH chat (the old chat's 1.9M-char page cost 5 CPU cores while streaming).

| # | Screen (route) | Ludo round | State |
|---|---|---|---|
| 1 | Fighter profile + quick-look (fighter_card) | r68 | building - UICARDS1 #201 |
| 2 | Training planner (training) | r69 | queued - TASK_UICARDS2 |
| 3 | Day feed / gym floor HUD (day_feed) | r74 (S229, 16.2k, LUDO_ROUND74_REPLY_S229.txt) | spec ready - UI owner queue |
| 4 | Gym roster list (gym, roster - same list) | r71 (S228, 26.8k, LUDO_ROUND71_REPLY_S228.txt) | spec ready - UI owner queue |
| 5 | Story inbox + wall (story_inbox, story_wall) | r72 (S228, 21.4k, LUDO_ROUND72_REPLY_S228.txt) | spec ready - UI owner queue |
| 6 | Calendar / schedule / events (calendar, events) | r76 (S229, 17.8k, LUDO_ROUND76_REPLY_S229.txt) | spec ready - UI owner queue; HYBRID data bug fixed by Claude |
| 7 | Scouting (scouting) | r77 (S229, 20.4k, LUDO_ROUND77_REPLY_S229.txt) | spec ready - UI owner queue |
| 8 | Rankings (rankings) | - | census |
| 9 | Office tabs: money, contracts, finances (office_menu, contracts, finances) | - | census |
| 10 | Staff (staff) | - | census |
| 11 | Room views: front desk, office, staff room, physio, film room | - (rooms: Ludo r65 art) | census (UI overlays only) |
| 12 | Options menu + modals + tooltips | r70 covers | census |
| 13 | Objectives, weight class, fight week, week review | - | capture fix first (need route args: the census tool lands on Office) |
| 14 | Boot/title, save slots, settings, credits; creation (globe shipped) | - | census (boot tier) |
| 15 | Fight night, fight result (+ CORNER card), weigh-in, crowning | - | census (setpiece tier) |
