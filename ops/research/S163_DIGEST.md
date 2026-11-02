# S163 digest - the campaign (D36), Chapter 1 in the demo, the C223 gate repaired, G158 (Claude, 2026-10-05)

## 1. What now works (evidence opened by me)
- **The campaign plan "Anvil Street"** (`CAMPAIGN_PLAN.md`, D36 in DECISION_LEDGER): merged from four full pitches (Claude `STORY1_CLAUDE`, John `STORY1_JOHN`,
  Dola `STORY1_DOLA` incl. her Part A survey + 10 rules; Maria's section 10 only; Kalli's still being written). Operator: "put chapter 1 in the demo".
- **STORY2, Chapter 1 'Keys' (9 cards) is playable**: `StoryCampaign.gd` (pure, no autoload), `story_beats.json`, GameState hooks (additive, 0 deletions),
  `StoryCard.gd` mounted in CareerRoot (no node when the story is off). Interrupts ONLY at the week review + the opening welcome on HOME; defaults fire after 7 days;
  never scripts a fight; On/Beside/Off. Tests: `story_campaign_test` 102/0, `story_campaign_game_test` 25/0 (real career), `story_card_test` 15/0; the
  neighbours (tutorial, week_review, front_door, menu_modernization, shell_back_button) green; mutants red (morale cost, may_show, baseline).
  Stills opened: `docs/previews/story2/` (week review over a card, game size) and the REAL game's HOME welcome (`home_welcome_real_game.png`, via the walk).
- **Two defects my own stills found**: results before the story began fired a result card (starter fighters have lifetime records) -> a baseline; the cards said
  "Kit" while the boxer is generated -> a `{fighter}` token; the real HOME showed "So is the kid" on an EMPTY gym -> text fixed.
- **C223 production gate repaired**: GLOVES2 (S162) added the `FighterWrist` modifier and `q213e_skin.gd` asserted on any modifier but FighterFist, so EVERY C223 row
  errored on master (both KM3 A/B arms: 128 errors, 0/272 accepted, identical = no measurement). Fixed; a probe run measures rows again.
- **G158**: 9 of the 12 switch tests verified (ON passes, mutant fails) and on master; 3 held out in the digest `G158_DIGEST.md` (angle_guard = test bug, contact_push_on_line =
  25% not 30%, hand_contact_sync = no pop reduction). **NIGHTLY1C**: PR #47 merged (MMA footwork 11.2->12.9 m/min, sub-finish 11.8->26.7%), verified locally.
- **.exe rebuilt** (Builds/FightCamp_Godot, pck 542 MB, 12:31) with Chapter 1, skinned gloves, wrist bound, READROUND, corner, camera cap.

## 2. NOT done (said plainly)
- A full FIGHT walked in the exe: the old walk plans (s117) are stale for the empty-gym start. `research/s162_chapter1_walk.plan` reaches scouting only (16 steps, 0 failures);
  opening a prospect needs the right label. Owed.
- STORY3-6 (NEXT UP + Inbox + New Career questions, the Wall, fight-night hooks, the writers' card text) are queued, not built.
- KM3 A/B v2 is RUNNING (sequential, 2 Godots, started 12:30): `E:/FightCamp/wt/KM3_C223_v2/KM3_AB_DIFF.md` when `done_cut.txt` appears. PR #43 is applied only if it holds.
- Writers: Dola's STORY6 card draft sent (chat "FightCamp Story Cards"), John's refused (picker open), Maria's section 1-9 and Kalli's pitch not collected.

## 3. Traps recorded
- `_console.exe` (even via godot_hidden.ps1) opens a Windows Terminal on the operator's other monitor: headless runs use `Godot_v4.7.2-stable_win64.exe`
  (memory `feedback_headless_godot_use_noconsole_exe`). `Tools/build_playable.py` now exports with it.
- `gbot` launches a hidden Grok Bot copy that blocks his own launch; `grokbots.py launch` is the supported route, and a send is refused if the New-chat picker is open.
- A plain `git commit` takes everything staged: my STORY1 commit swallowed the 12 staged G158 test files (fixed by a follow-up commit). Always `git commit -- <paths>`.
- Arena's sandbox has no Godot (its PRs are untested) and its CI timed out at 1 h on the project import: verify locally.
- A tool collapses `\\n` in a Python heredoc: build the match with `chr(92)+'n'`.

## 4. Next
Collect KM3 v2; STORY3 (NEXT UP banner + Inbox + the three New Career questions); extend the walk plan to a fight; fold in the writers' work.

## 5. Nightly 2026-10-05 and the PR #47 revert (added late in S163)
Nightly @26b106e9: 544 tests, 13 reds (was 19). 3 = my held-out G158 tests swept in by a STORY1 commit (removed 5b512cff). NEW: result_screen_why (a pinned seed moved) and,
checked with #47's values reverted, fight_contact_stop + grapple_naming_contract + judge_panel: ALL FOUR were caused by PR #47 (MMA footwork speed 0.86->0.93, RNC finish 0.085->0.095), which I
merged after running only its two target tests. #47 REVERTED (2e91c5a2); the four are green again; result_screen_why_test also finds its own finish seed now (13489b32).
The 2 MMA band tests are red again (known, off the boxing path): queued as NIGHTLY1C2 with the neighbour list. q226_strands is red with or without #47 (pre-existing);
fight_pair_live (parked), fight_stage_realism (flip-hang), reachability (KM3), strike_whole and ring_position were not looked at.
LESSON: a constant nudge in a shared engine file is merged only after its neighbours (judge_panel, contact_stop, grapple_naming, result_screen_why ...) run green.
