# S76 digest - 2026-09-25 (Claude, Opus 5.5, on the PC)

## Shipped (master, all pushed)
- **Novices in the world** (27b507fb): world amateur records now come from G98's bout bands
  (`AmateurBooking.world_record`, PROXY: 0 22% / 1-2 20% / 3-5 16% / 6-10 16% / 11-20 15% / 21-30 11%), derived from the
  athlete id so the generator's rng stream is untouched (the two old draws kept). The debut desk drops every pairing
  `AmateurMatchmaking.grade` calls unsafe - G96's 0-2 debut rule, enforced. Census 4 countries x 3 disciplines: BEFORE
  0 of 37 debut opponents had <=2 bouts (all 3-9); AFTER 21 of 21, no desk empty (1-3 names each - thinner, legal).
  `world_novices_test` (bands within 0.2 pts; mutants caught: filter removed -> 4-8 bout opponents; band weight 22->12).
- **Real organisation names back** (5d5e242c; operator ruling: names only, no logos): the four data files S74 renamed restored
  from `3db93183^`; athletes stay fictional (swap file). `default_build_shows_no_real_name_test` now checks athletes only,
  requires every real org in the default world with `brand_assets_policy text_name_only` and no logo field, and refuses
  endorsement wording ("officially licensed", "official partner"...) in assets/scripts/scenes. Tale of the Tape lost
  "OFFICIAL FIGHT DATABASE". Mutants caught (renamed PFL; planted "officially licensed").
- **Broadcast plate between rounds (G97)** (3fb7a811): `FightBroadcast.gd` (pure, folded from the fight log): CompuBox card for
  boxing (total/jab/power, body row only with body work), MMA card sig/TD/control/KD; control seconds from TickBudget's
  decision cadence (0.5 s/event); clinch throws count as takedowns. ONE caption per break, damage first. G97 highlight
  score + picker (<5 never a clip, max 2, 1 if quiet). `BroadcastCardPanel` shows it in the rest above the corner card,
  click to skip. `fight_broadcast_test` (synthetic + real non-identical MMA/boxing bouts, catalogue
  combat_rulesets.json; mutants caught: throw kinds dropped, wrong cadence, damage order removed).
- **Desk wording**: "NONE FIGHTS TO TWO" -> "A DEBUT AGAINST TWO FIGHTS".
- **Process**: `start` prints AGENT RUNS IN FLIGHT from worktree write times (a new session owns them - operator);
  tests and agent launches run at IDLE priority, max two shell agents at once (operator: PC at 87% CPU, no new PC);
  `agent_window.cmd` passed its LAST argument as the command (shift bug) - fixed.

## Collected
- **U173** (Cursor, dd3b2bb2 -> a080c40b, 5 real files only - its commit also carried ~4,000 `.godot` cache files): anticipate +
  counter under `defence_model`, default OFF. Verified here: subset 7/7; control arm - the 9 feint-off hashes are
  identical with and without U173.
- **C202** (Codex, 03b1f8e4) DIAGNOSIS ONLY: the hook crouch is in the SOURCE (`H2H_HookPunch_InPlace` knees 123/122 deg,
  retarget matches); crossfade/foot-lock arms leave it; hip-carry-off floats the body (rejected). MP4 md5s re-verified.
- **G98** (Grok) amateur population, verbatim; **D20** (Dola) links on every D19 row, raw.
- **Q175 pass 2** (Qwen, 78c03f22) NOT merged: boxing hold in band (5.02 s), OFF hashes identical, but MMA clinch time
  share 10.07% < 10.36%. Its "unreachable" rests on a 0.010 body-vs-leg landing-rate gap on one fixed-seed sample
  (head 0.527 / body 0.538 / leg 0.528 - nearly flat). PASS 3 assigned: pooled 4-seed-set measurement decides.

## Walked
Windowed dev-tree walk `research/s76_walk.plan` (27 steps, 0 failures, `docs/previews/s76_walk/`): the desk lists only
0-2 bout opponents; the plate shows END OF ROUND 1 with the card and one caption above the corner card. The exported
build was rebuilt (`python Tools/build_playable.py`, pck 213 MB, 15:10) but the walk ran in the dev tree, not the exe.

## Finding for the engine (assigned U174 + G99 + D21)
The card shows it plainly: a boxing round reads ~25 punches per fighter, 50-60% landed, ~20% jabs. Real CompuBox is far
busier, ~30% accurate and jab-heavy. G99 (boxing) and D21 (UFC) fetch the anchors; U174 (Cursor, queued) calibrates.

## Gate
Subsets: 29/29 (world/amateur/org/rankings/smoke), 9/9 (broadcast, live screen, desk), 7/7 (U173). Nightly suite: no run
yet - `AgentComms/nightly/` does not exist until the first 05:00 run; last full number S75 `409/9` (the S73 nine).
