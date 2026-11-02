# S64 digest - THE CAREER LOOP WALKS END TO END (Claude, 2026-09-24)

Lane: management + GUI (operator split 2026-09-24). Commits `986ce320` (tree clean), `4a74d0d6` (loop),
merges `deb67667` U154, `6d9c2c27` C183, `ebd03059` Q163.

## Step 0 - the tree is clean
3,057 untracked files. Committed: 1,369 `.uid`/`.import` sidecars whose source is tracked, the extracted
fighter and Cascy textures, GUI pass renders (`stage_b`, `u54/before`), research notes. Ignored (nothing
deleted): `.qwen/`, `clip_audit/`, `nul`, `Microsoft/`, Codex's `Tools/cascadeur/c1xx_*` working folders,
`Tools/cc_bridge/out/`, `previews/r109` + `arena_art` dumps, roadmap `.bak`s, `_collect/`, `_tmp_*`.

## Step 1 - the walk (`Godot/tools/s64_career_walk.gd`)
Boots the real title, presses buttons by their visible label, screenshots each screen; a missing label is
a DEAD-END. Plan file one step per line (`press`, `press X#n`, `try`, `wait`, `shot`, `route`). Windowed via
`Tools/godot_hidden.ps1`. Walked: NEW CAREER -> Cyprus -> Nicosia -> gym -> THE DAY -> fighter ->
OPEN THE BOARD -> BOOK -> THE DAY -> FIGHT WEEK -> WEIGH-IN -> FIGHT NIGHT -> RESULT -> THE DAY -> week 2.

Two dead ends, both fixed:
1. `ProfileRevampPanel._want` only set a `wants` meta nothing read - OPEN THE BOARD, BOOK, SET PROGRAM,
   FIGHT PLAN, ASSIGN, REMATCH OFFER were all dead. Now routed (camp tab / schedule offers / training /
   `book_fight` / `assign_recovery_station`).
2. **A bout booked off the board could never be fought.** FightNight opened world-event bouts only; THE
   DAY's door carried only `athlete_id`, so the ring sat on AWAITING THE OPENING BELL and `advance_week`
   refused forever ("ATTEND YOUR BOOKED FIGHT(S)") - a soft-lock on the first booking. FightNightScreen now
   opens `booked|<athlete>` (event bookings delegate to the fixture), records via
   `record_live_fight_result`; GameState exposes `get_booked_fight_opponent/_ruleset`.

## Step 2 - FLOW_PASS4 (Kalli) built
Empty card -> `BACK TO THE DAY ▸` (routes `day_feed`); ManagementChrome header -> `NEXT STOP ▸`; schedule
hint -> `OPEN THE DAY FOR WHAT IS DATED`; setpiece leave fallback `calendar` -> `day_feed`; `today` route
retired (SceneRouter, CareerRoot, ManagementChrome registries; two tests retargeted).

## What the walk saw that is NOT fixed (sent to the operator, three worst asked for)
- Day one: all three starter fighters STRAINED loyalty because starter pay is $0.
- Profile: CONDITION 33 vs Training's COND 100; record 0-1 beside "NO BOUT YET"; overprinted label under TOP CONTROL.
- Booked for today, START A CAMP stays lit beside "too late for a camp"; fight week shows SAT, booking is MON.
- Weigh-in 4.2 kg over, fine 0%, fight goes ahead; `book_fight` weight plans all project 76.8 and "makes_it".
- A probe booking matched a fighter against his own gym-mate (NASIR vs RAFAEL NOVAK, regional offer).
- Schedule OFFERS: a BOXER offered only Cyprus MMA Federation amateur bouts; "0 OFFERS" while the profile lists 3; "NOT KNOWN: SEX, HELD UNTIL WEEK" leak.
- Fight night is the 2D card, not the 3D fight; left photo is not our fighter.
- Result: 10-8 in six of eight rounds with zero knockdowns (-> Qwen Q164); PAID TO THE GYM $0; THE READ empty on the real-time path; MARKS column overprints; FIGURE placeholders on setpieces.

## Gates
`tests/career_loop_walk_test.gd` 20 checks, mutant-proven (dead `_want`: 8 fails; ring ignoring THE DAY's
args: 8 fails). Focused subset 20/20 after retargeting setpiece_panels' stale OFFICE words.
Full suite: see HANDOFF block (number read off the run).

## Collected
U154 (Cursor): overlap back to 0.100 s boxing / 0.083 s MMA, teleports 0. C183 (Codex): closed guard
overhook + head cup, reproduced here - worst 10.67%, 0 failures. Q163 (Qwen): RamsterZ sources are METRES;
5 of 7 RamsterZ holds UNUSABLE. G85 (Grok): agrees with J45 - `G85_OUR_OWN_CHARACTER_CREATOR.md`.

## Assigned
Codex C184 (watch-loop take one: a 60 s MMA recording reaching standing, clinch, ground), Qwen Q164 (10-8
without a knockdown), Cursor U153 (live-room grip witness, carried).
