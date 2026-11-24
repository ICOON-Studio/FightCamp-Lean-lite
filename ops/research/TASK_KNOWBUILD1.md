# KNOWBUILD1 - the signing card in the game: a prospect as a moment, read on ranges (S545)

Kind: build. Model: claude-opus-5-5 (Code Mode tab). Discipline: boxing. Estimate: 5-7 hours.
The owner (interview S543, `ops/research/PUSH_KNOW_INTERVIEW_S543.md` section "Knowledge", where it and the map differ
the interview wins): "K1-3 yes k4 yes to a no to b".
- K1: a wrong signing costs THE PLACE on a small roster for a season and THE STORY (the one who got away signs for the
  rival club and comes back against your boxer), not dollars.
- K2: stop the paper rounds; build step 1 of v9 - the signing card with the ranges, the two dates, the three calls - so
  he plays it. Critics score the played build.
- K3: a prospect is a moment, three to five signings a year, SHOWN LIKE THE PRO OFFER.
- K4: each trial evening the player picks tomorrow's question (body, skills, the pad test, the hard spar). No fourth
  call "sign short".
The spec is `ops/research/DESIGN_KNOW_STAKES1_V9.md` (read it whole first: sections 2, 3, 4, 5, 8) with those four
answers on top. `docs/KNOWSTAKES9_RESULT.md` holds the measured numbers the map quotes.

## METHOD (quote in your first message)
- A DECISION SCREEN IS A SCENE, AND A CLICK SHOWS WHAT CHANGED (owner S544: "looks like spreadheet you need to use art",
  "i click turn pro now , i expect to see what changed"). The signing card is a picture of the moment (the prospect in
  the gym) with the calls as cards: a painting, a name, at most FOUR plain facts, its own button; details on hover. Never
  rows of key / value as the main content. After Sign the player lands on the new boxer's profile, and THE PROFILE
  ITSELF says what changed: its top card (the pattern is `WhatsNew.card`: a title, one line, what changed as plain
  "was -> now" words, the one pulsing next action) and NEW marks on the things that are new. NO POP-UP over the
  profile and NO GRID OF ICON TILES (owner S545 on the four-tile pop-up a worker built: "this looks like AI slop";
  its button left it open over the next page: "the window doesnt go away"). Reuse: `scripts/ui/ProScene.gd`,
  `modals/ProOffer.gd`, `WhatsNew.gd`, `ProBars.mark`; `tests/test_jump_test.gd` (the "pro" block) shows the check
  that a decision's button lands on its page with nothing left open - write the same check for Sign.
- NOTHING CUT BY THE SCREEN (owner S544: "why half the screen isout of bounds"): `tools/jump_snapshot.gd` on the hidden
  desktop with `--log`; no BOUNDS line; open every picture yourself.
- LITTLE TEXT (owner S545, on the pro call: "you do not need to spell everything out for the player"; "A simple You
  pay : 123456$ is enough , if more things are needed use the fucking tooltip"): one number or two words per fact; the
  how and why go in the hover. A tooltip explains, it never repeats the label.

## Where you work
1. `git worktree add E:\FightCamp\wt\KNOWBUILD1 -b build/knowbuild1` from the main checkout, then
   `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\seed_godot_cache.ps1 -Worktree E:\FightCamp\wt\KNOWBUILD1`.
2. Work, test and commit ONLY inside that worktree (absolute paths; never edit the main checkout).
3. Tests: `TESTS="<names>" JOBS=1 sh tools/run_tests.sh` from the worktree (headless, Dummy audio; never the whole suite).
   Before each Godot job `powershell -NoProfile -ExecutionPolicy Bypass -File ops\Tools\pc_watchdog.ps1 -Once`: RED =
   wait; the owner's game (ArcheAge) in the top list with memory AMBER = wait. A parse error hangs a headless test:
   after every edit run the smallest test that loads the file first. Read `ops/research/GDSCRIPT_TRAPS.md` first.
4. After each step: commit on `build/knowbuild1` and `git push -u origin build/knowbuild1` (the branch only, never
   main). The coordinator merges by diff.

## The steps (each ends with its tests green and one commit)
STEP 0 - THE WALK, RED FIRST. `tests/knowbuild1_walk_test.gd`, written first and red on the branch: a prospect arrives;
the card shows ranges (never single numbers) and, when the name has them, the bout date and the rival's window; three
endings are walked: (a) Sign now on the first look; (b) Start the trial, pick tomorrow's question twice, sign on trial
day 3 with narrower ranges than day 0; (c) Wait, the rival's window runs out: the news line and the got-away list carry
the name and the date, and the place is free. Pass is walked once (no news line).

STEP 1 - THE RULES (pure, `scripts/rules/`, unit tests).
- The prospect record gains `bout_day` (when the region sheet has the name on a show), `window_from`, `window_to`,
  `rival_seed` (map 3C: a 7-day window; last day 7 when the rival's look is above the level, 14 when not, plus 0-6).
- The trial BY THE DAY (map 2 C1-C3, 3B): `KnowReads.apply_trial_day(k, question)`, price $36 a day, refunded if the
  rival signs during it. K4: the QUESTION is the player's pick each evening, not a fixed ladder - body, skills, the pad
  test (the ceiling, halved), the hard spar (under fire and the pressure trait; injury x2 that night, +15 tiredness).
  A question may be asked again (it narrows again, less each time: use the map's day-1 / day-6 body pair as the size of
  a second ask). At most 7 trial days a name. `PRICE_TEST_DAY` and the `test_day` read kind fold into "body".
- K1, THE PLACE NOT DOLLARS: there is NO dollar bond (the map's "$250 a week, 12 weeks" is dropped). A signed prospect
  holds one of the club's places for a season: read how the game counts a season and a roster place today
  (`Roster.gd`, `Leaving.gd`, `Champs`) and make the signing a commitment to the season's end - letting go before it
  is not offered on the boxer's menu (say in your result where that button lives and what it now reads). Keep the
  stipend the boxer already draws. Write the season length you used and why.
- The rival: when the window runs out unsigned, the prospect signs for the rival club: one news line ("<Club> sign the
  prospect, <date>") and a row on the got-away list with your last look. Pass frees the slot and writes no news line.
  THE RETURN BOUT (the one who got away meets your boxer within 26 weeks) is the NEXT build (KNOWBUILD2): store what it
  needs on the got-away row (who, where, your look) and stop there.
- Arrivals as the map's 3D (at most two open at once). Print in the walk test's output how many names a two-year
  career sees and how many it can sign: the owner's K3 is three to five signings a year.

STEP 2 - THE SCREENS (owner S425: wired and shown on the correct menus; this build's rows of map section 5).
| Menu | Shows | File |
|---|---|---|
| Signing card (a scene) | the prospect painted in the gym; the read as RANGES in at most three groups (body, skills, ceiling) drawn as bars with a band, not numbers in rows; one strip of 21 days with the bout and the rival's window when the name has them (days before the window marked safe); the calls as cards: SIGN NOW, START THE TRIAL, WAIT FOR THE BOUT (only when there is a bout), and Pass as a plain button. Each card: at most four facts (what it costs, what it answers, the odds line from map 3B in a few words) | new `scripts/ui/modals/Prospect.gd` + a scene helper beside `ProScene.gd` (reuse it if it fits; do not grow a file past 500 lines) |
| Trial evening (`scripts/ui/modals/Trial.gd`, 43 lines today) | before -> after bands for what today's question narrowed, with one "why" line; tomorrow's question as up to four picture buttons (K4) each with what it narrows and tonight's rival odds ("Lynn AC may decide tomorrow: 1 in 5"); SIGN / SEND HOME / ANOTHER DAY | `Trial.gd`, `KnowReads` |
| After Sign | the new boxer's profile opens; its top card says what changed in plain was -> now words (a place taken: 2 of 3; the season's commitment; the read as it stands) with NEW marks on the profile; one pulsing next action (plan the week); no pop-up | `WhatsNew.card` pattern |
| Top bar Continue + the Needs strip | stops each trial evening, on the bout day, on the window's first and last day; "Trial day 3: decide tonight", "The prospect boxes tonight", "Lynn AC decide from today" | `Clock` candidates, `OfficeDesk.needs` |
| Find a fighter / reception | an open prospect is a card that opens the signing card; the first walk-in of a new game uses the same card (no strip when the name has no dates) | `scripts/ui/areas/Fighters.gd`, `RosterActs.gd` |
| Mail (the office computer) + got-away list | the rival's signing line; the got-away row | `OfficeMail.gd` reads the news as today |
NOT in this build (say so in the result, do not half-build): numbers for signed boxers (map 3E), the return bout, the
"Last time" strip, the region show's Watch row beyond the Continue stop.
Words: the player's place is "the gym" in every menu word (owner S545: "i do not understand whatis club and what is gym";
"what happened to normal words like staff"): plain game-menu words, Staff not People. "The prospect", "the boxer", other clubs' names in full; names only in headers; no he / she / him / her in game text
(`tests/no_pronoun_test.gd`). Colours only from `Palette.gd`. Every meter tweens (the meter the other cards use).

STEP 3 - THE JUMPS AND THE STILLS.
- `scripts/ui/TestJump.gd` jumps: `prospect` (the card, a name with a bout and a window), `prospecttrial` (trial
  evening 2), `prospectsigned` (the profile with its what-changed card), `prospectgone` (the window ran out: Mail).
  Add them to `ops/Tools/opsboard/launch_targets.json` as board buttons (how the four "Pro:" buttons were added, S544).
- Stills of the four states on the never-shown desktop through `tools/jump_snapshot.gd` (`--log`; one windowed render
  at a time, inside `python ops/Tools/godot_slot.py run --who KNOWBUILD1 -- ...`), saved under
  `docs/playtest/s545_prospect/`. Open each with the file tool; fix what is cut, overlapping, unreadable, or reads as a
  table. Check each against the three METHOD lines and write the check in the result.

## Tests
- Must stay green: `golden_path_test`, `save_load_test`, `file_limits_test`, `no_pronoun_test`, `palette_guard_test`,
  `words_on_screens_test`, `plain_words_test`, `test_jump_test`, `office_screen_test`, every knowledge test
  (`ls tests | grep -i know`), plus every test you touched. A prospect half way through a trial survives save and load.
- A test whose rule the owner changed (the dollar bond, the test day button, the whole-week trial) is rewritten to the
  new rule and LISTED with the rule it tested; never deleted to go green.
- New test names go in the list in `tools/run_tests.sh`. A plain `--script` test is the control arm: follow how the
  repo's other new features are switched (`GameSwitches.GAME_ON`; new features ship ON).

## Feedback loops
| The change feeds | Does that feed back? | Cap |
|---|---|---|
| Better signings -> wins -> cash -> more trial days | Yes | 3 places; two names open at once; 7 trial days a name ($252) |
| A wrong signing -> a place held for the season -> no room for the next prospect -> the rival signs them -> stronger rivals -> more losses | Yes, downward | the season ends and the place frees; at most one got-away a window; print in the walk how many places a club that always signs on the first look has blocked after two years |
| Prospects the rival signs -> stronger region rows -> a higher level | Yes, slowly | the level is a mean of many rows; print the level's drift over the two-year walk; STOP and report if it passes 2 points |
| Trial days / waiting -> the rival's window | No: the window is fixed when the name arrives | - |
ONE-REP TRIAL FIRST: one prospect walked by hand through `prospect` -> trial -> sign in the windowed game (the jump),
its numbers printed, before the two-year walk.

## Prior research
`ops/research/DESIGN_KNOW_STAKES1_V9.md`, `docs/KNOWSTAKES9_RESULT.md`, `PUSH_KNOW_INTERVIEW_S543.md`, both v9 critics
(`CRITIC_KNOW_STAKES1_V9_BRIEF_KALLI.md`, `_DOLA.md`: 7/8/7 and 8/7/7), `docs/TURNPROBUILD17_RESULT.md` and
`ops/research/S544_DIGEST.md` (what the owner said of a worker-built decision screen), memory notes "A decision screen
is a scene (S544)" and "Tooltips explain (S532)".

## What would a human do?
A club coach watches a kid for a week before the form is signed: pads one night, a hard spar another, and all the
while he knows the club down the road is watching too. A game designer shows that as one picture of the kid in the gym
and three doors, not as a sheet of numbers.

## Prefab check
The pattern exists in the repo (the pro call scene, S544); the knowledge rules exist (`KnowReads.gd`, `Knowledge.gd`,
`KnowWire.gd`). Paintings: use the boxer's own painted body (the pro scene's route) on a gym background already in
`assets/ui/`; no new art is generated in this build (list what art a second pass should ask Ludo for).

## VISUAL GATE
Red first: `tests/knowbuild1_walk_test.gd` red on the branch before step 1. The four stills from the real windowed
game (jump_snapshot, hidden desktop), opened by you, no BOUNDS line, checked against the three METHOD lines. The
coordinator checks them again before the merge; the owner's play closes it.

## Contract
OWNS: scripts/rules/KnowReads.gd, scripts/rules/Knowledge.gd, scripts/state/KnowWire.gd, scripts/ui/modals/Prospect.gd, scripts/ui/modals/Trial.gd, scripts/ui/TestJump.gd, tests/knowbuild1_walk_test.gd, docs/playtest/s545_prospect/
RED_TEST: tests/knowbuild1_walk_test.gd
REGRESSION: tests/golden_path_test.gd, tests/save_load_test.gd, tests/test_jump_test.gd
VISUAL: four stills of the real screens (the card, a trial evening, after Sign, the rival signs), opened, no BOUNDS line

## Result
`docs/KNOWBUILD1_RESULT.md` on the branch: what each step changed (files, functions), the season length and where the
let-go button went, every test rewritten and why, the pass lines (`RESULT: tests/<x>_test.gd -> <exact pass line>`), the
two-year walk's prints (names seen, signings a year, places blocked, the level's drift), the stills, and anything the
map says that the code could not do (write the gap down; do not invent a rule to fill it). Commit only your own paths
with a pathspec; do not ask questions: decide, and write what you decided.
