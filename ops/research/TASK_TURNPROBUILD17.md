# TURNPROBUILD17 - build turning pro v17 into the game, four steps, each one green (S543)

Kind: build. Model: claude-opus-5-5 (Code Mode tab). Discipline: boxing. Estimate: 5-7 hours.
The owner: Q-S294-320 "Yes, build it" (the rules), Q-S294-323 "Yes, build v17 now" (S543). The spec is
`ops/research/DESIGN_TURNPRO1_V17.md` (read it whole first; sections 1-3, 6, 7), the approved page
`ops/research/TURNPRO17_RULES_S542.md` and the interview `ops/research/TURNPRO_INTERVIEW_S541.md`. Step 1 is DONE on main:
`scripts/rules/ProStart.gd` (the pure rules, 124 lines) + `tests/pro_start_test.gd`. Use it; change a number there only
with the reason written in your result.

## Where you work
Other workers are running probes on the main checkout that READ the pro and bout modules. Do NOT edit main.
1. `git worktree add E:\FightCamp\wt\TURNPROBUILD17 -b build/turnpro17` from the main checkout, then
   `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\TURNPROBUILD17`.
2. Work, test and commit ONLY inside that worktree (absolute paths; never `cd` back into the main checkout to edit).
3. Tests: `TESTS="<names>" JOBS=1 sh tools/run_tests.sh` from the worktree (headless, Dummy audio; never the whole suite).
   Before each run `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`: RED = wait; the
   owner's game (ArcheAge) in the top list with memory AMBER = wait. A parse error hangs a headless test: after every
   edit run the smallest test that loads the file first.
4. After each step: commit on `build/turnpro17` and `git push -u origin build/turnpro17` (the branch only, never main).
   The coordinator merges by diff.

## The steps (each ends with its tests green and one commit)
STEP 2 - WHEN (the offer, Not yet, the rival gym). State and rules, no screen work beyond the pop-up's buttons.
- The fighter carries `f["pro_start"]` (`ProStart.new_state()`) from the first offer; it survives save and load.
- `scripts/state/Roster.gd` (334 lines) `pro_ready`: the line no longer moves with declines - 7 wins and top 3, or 9 wins;
  a national finalist is called whatever the record; the "3 declines = the door is closed" line goes.
- `decline_pro` becomes "Not yet": `ProStart.not_yet`, the offer returns `ProStart.NOT_YET_WEEKS` later; no morale hit
  (`ProOfferWire.apply_morale`), no loyalty hit (`Loyalty` decline_pro), no +2 wins (`PRO_RETURN_WINS`), no terms x0.9
  (`PRO_SECOND_TERMS`, `ProCall.SECOND_TERMS`). During a live nationals run (`Champs.active`) no call comes, as today.
- With no mark left (`ProStart.can_wait` false) the next call is a RIVAL GYM's: the pop-up offers Turn pro now / Let the
  boxer go; refusing sends the boxer to a rival club for good through the game's own leaving path
  (`scripts/state/Leaving.gd`, 131 lines: read how a boxer leaves today and use it; one news line).
- ONE promoter, one offer: `scripts/state/ProOfferWire.gd` (202) makes one house; the two-house side by side, "who calls
  by seats" (`ProCall.promoters`, `who_calls`, `ProLean` LEAN_KIND / LEAN_WORD) and the five asks and counter-offers
  (`scripts/rules/ProCall.gd`, 337: LATER2/4, SPLIT_*, PRICE_*, COSTS_*, SOFTER_*; `ProOfferWire.ask`) are DELETED with
  their screen parts in `scripts/ui/modals/ProOffer.gd` (226). `DebutPick.gd` (100) shrinks: the debut is fight 1 of the six.
  What stays: the gym's purse share (`Roster.GYM_SHARE`, `signing_share`, `StarDeal`), `ProDebut.gd` (costs, licence,
  tickets), the purse ladder (`PRO_PURSE*`).
STEP 3 - HOW (pro fights 1 to 6: two bouts).
- A new `scripts/state/ProPair.gd` (ProLadder.gd is at 484 lines: do not grow it). For the debut and each booking until
  `ProStart.on` is false it offers TWO bouts: SAFE and RISKY. Each is a real opponent (`DebutOpp.make`; a little better
  each fight, the map's +0.3 rating a fight) whose rating gap is SEARCHED so the game's own read of the bout
  (`DebutRead.card` -> `BoutRead`) lands inside the bout's band (`ProStart.SAFE_BAND` / `RISKY_BAND`): the matchmaker
  finds the man, the printed number is never squeezed afterwards.
- CONFIDENCE moves the fight, not a printed number: find how the boxer's mood already enters both the bout and the win
  read (S539 MOODREAD1: "the win read's caches carry the boxer's mood") and put confidence beside it, sized so that
  confidence 0 / 100 moves the read by about 5 points either way and never more (measure it on ten different boxers and
  write the table in your result). The chance on the card is the read WITH confidence: the number the fight uses.
- The risky bout's purse is `ProStart.purse` (x1.75). On a win the boxer's name grows (`ProStart.name_gain`), kept in
  `pro_start.name`; it is ALSO added to the club's reputation on top of what a win gives today
  (`BoutRules.WIN_REPUTATION`), so the number does something in this build (coordinator's decision, reported to the owner).
- After the bout (`scripts/state/BoutFinish.gd`): `ProStart.after_fight(kind, outcome)` - "win", "points" (lost on the
  cards) or "ko" (stopped); the medical rest after a stoppage (`Matchmaking.STOP_REST_WEEKS`) -> `ProStart.rest`.
  Fights 1-6 are `Matchmaking.NEXT_WEEKS` apart (QUICK_WEEKS / HARD_WEEKS start at fight 7).
- At each booking `ProStart.booking_check`: a warning on the boxer card, and at "gone" the boxer leaves (the same leaving
  path as step 2). From fight 7 `ProLadder._make_offers` books as today, untouched.
STEP 4 - THE SCREENS (owner S425: wired and shown on the correct menus).
| Menu | Shows | File |
|---|---|---|
| Pro offer pop-up | the purse; fight 1's safe and risky chance; the same two chances four weeks on (four weeks of `TrainingPreview.plan_gain` on the current focus fed into the same read - new, build it small); the three patience marks; Turn pro now / Not yet; the third time the rival gym's call | `scripts/ui/modals/ProOffer.gd` |
| Boxer card | the patience marks (until pro); CONFIDENCE and HUNGER as animated meters (every bar tweens: use the meter the other cards use); a warning line at hunger 0 ("Warning 1 of 2") | `scripts/ui/FighterPage.gd` |
| Booking, pro fights 1-6 | two cards side by side, SAFE and RISKY: the opponent, the chance, the purse, the name gain, and what a win and a loss do to both bars | `scripts/ui/ProFights.gd` (it reads `ProLadder.offer_rows` today) |
| Result page | one line: what the fight did to both bars (`ProStart.bar_line`) | `scripts/ui/ResultPage.gd` |
Words: SAFE and RISKY, each with its small line "the promoter's tune-up" / "the promoter's step up" (`ProStart.KIND_IS`:
the booking's own words from fight 7). "The boxer", "the opponent"; names only in headers; no he / she / him / her in
game text (tests/no_pronoun_test.gd). Every hover explains what the thing does, never repeats its label. Colours only
from `Palette.gd` (tests/palette_guard_test.gd). Read `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript.
STEP 5 - THE WALK AND THE STILLS.
- `tests/turnpro17_walk_test.gd`, written FIRST and red on the branch before step 2: a career reaches the offer; Not yet
  (a mark gone, hunger 55, the offer back four weeks later); Not yet again; the rival gym's call; Turn pro now; the debut
  booking shows two bouts with both chances inside their bands; the risky bout is fought; the result page carries the
  bar line; bookings 2-6 offer two bouts; the booking after fight 6 is the normal one. A second short walk: six safe
  wins take hunger to 10, and a boxer at 0 gets two warnings then leaves.
- Stills of the four screens, rendered on the never-shown desktop (`python tools/hidden_desktop.py run --timeout=180
  <godot.exe> --path . --windowed --resolution 1920x1080 --script res://tools/layout_snapshot.gd -- <out_dir>`; one
  windowed render at a time; add the four states to the snapshot tool if they are missing), saved under
  `docs/playtest/s543_turnpro17/`. Open each with the file tool and fix what is cut off, overlapping or unreadable.

## Tests
- Old tests of rules the owner cut (asks, two houses, the moving line): `pro_call_test`, `pro_offer_wire_test`,
  `pro_contract_test`, `pro_lean_test`, `debut_pick_test`, parts of `approach_test`, `loyalty_hooks_test`,
  `promises_test`, `next_step_test`, `pro_week_lines_test`, `debut_read_test`. For each: keep the checks whose rule still
  stands, rewrite those whose rule changed, delete only those whose rule is deleted - and LIST every deleted or rewritten
  check in your result with the rule it tested (map section 6). Never delete a test to go green without that line.
- Must stay green: `pro_start_test`, `golden_path_test`, `save_load_test`, `pro_ladder_test`, `pro_debut_test`,
  `pro_read_test`, `loyal_pro_share_test`, `file_limits_test`, `no_pronoun_test`, `palette_guard_test`,
  `words_on_screens_test`, `plain_words_test`, plus every test you touched. Add new test names to the list in
  `tools/run_tests.sh`. A plain `--script` test is the control arm: follow how the repo's other new features are switched.

## Result
`docs/TURNPROBUILD17_RESULT.md` on the branch: what each step changed (files, functions), the confidence table, every test
deleted or rewritten and why, the test run's pass lines, the stills, and anything the map says that the code could not do
(say so plainly; do not invent a rule to fill a gap - write the gap down).

## Feedback loops
As the map's section 5 (confidence capped at 5 points, both bars 0-100, hunger a one-way sink fed by the player's picks,
the name never changes a fight 1-6 offer). New in the build: the name adds club reputation -> members -> money; it is
bounded by six fights (18 points at most) and reputation's own cap.

## Prior research
`docs/TURNPROBE17_RESULT.md` (the numbers), `ops/research/CRITIC_TURNPRO1_V17_BRIEF_KALLI.md` "Code check" (what the map
got wrong about the code: the four-weeks-on read does not exist; the finalist rule; the decline path's morale and
loyalty; the gym share is not flat; a step up needs a ranked name) - each is handled above; say if one is not.

## What would a human do?
A manager offered a pro contract for his best amateur says yes or "not yet", knows the boxer will not wait for ever, and
then picks each early opponent himself: mostly men the boxer should beat, now and then a real test.

## Prefab check
None (our own modules and screens).

## Contract
OWNS: scripts/state/Roster.gd, scripts/state/ProOfferWire.gd, scripts/rules/ProCall.gd, scripts/state/ProLean.gd, scripts/rules/DebutPick.gd, scripts/state/ProPair.gd, scripts/state/BoutFinish.gd, scripts/ui/modals/ProOffer.gd, scripts/ui/FighterPage.gd, scripts/ui/ProFights.gd, scripts/ui/ResultPage.gd, tests/turnpro17_walk_test.gd, docs/TURNPROBUILD17_RESULT.md (and the tests listed above; any other file you must touch is named in the result with the reason)
RED_TEST: tests/turnpro17_walk_test.gd
REGRESSION: tests/golden_path_test.gd, tests/save_load_test.gd, tests/pro_ladder_test.gd, tests/pro_start_test.gd
VISUAL: docs/playtest/s543_turnpro17/ (four stills, opened by the worker, then by the coordinator)

Do not ask questions: decide, and write what you decided in the result.
