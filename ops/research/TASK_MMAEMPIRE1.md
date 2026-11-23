# TASK MMAEMPIRE1 - read MMA Empire's new update (installed on E:) and compare with FightCamp (S539)

Model: claude-opus-5-5 (Code Mode tab, owner's subscription). Research only: no game file changes.

## Why
Owner S539: "have we playtested mma empire ? its installed on e", then pasted its new patch notes: fight camps (coaches,
specialties, rosters, prestige; gym quality, coaching, specialties and partners change weekly attribute gains; fighters move
camps; retired fighters become coaches), official weigh-ins (a miss -> accept / replacement / cancel), backup fighters, roster
activity (who needs a booking), a champions view with a defence target, round-by-round stats, suggested host cities.
We never played it: C18_GAME_SURVEY.md lists it as "already have teardowns ... not re-read" (an old project), G103 has a store
line. Several of these are OUR mechanics (camps, weigh-ins, reserves, "who needs a fight", round stats).
Owner rule (global CLAUDE.md, 2026-11-04): REA on an installed game is allowed for documentation and comparison - read-only
inspection of the installed files, findings as notes and numbers in our own words, nothing of theirs (assets, code, text)
copied into our project, no runtime hooking of online games.

## Do
1. E:\SteamLibrary\steamapps\common\MMA Empire is an Electron app (updated 2026-11-23 03:35). Use the REA tools read-only
   (analyze_javascript_application / inspect_artifact on its resources/app.asar) to find the rules behind each patch item:
   camp gain formula (gym quality, coach, specialty, partners -> weekly attribute gain), camp moves and prestige, weigh-in miss
   chance and the three answers, backup eligibility, the "needs a booking" thresholds, round stats recorded. Numbers and logic
   in OUR words; no code, text or asset copied.
2. If it can be played offline: play a short career out of sight (tools/hidden_play.py on the hidden desktop; nothing on the
   owner's monitors; memory reference_hidden_playtest_reference_games_s426) to see the screens: what each new view shows and
   how many clicks a weigh-in miss or a backup takes. Stills only through the hidden desktop, opened with the file tool.
3. Write ops/research/MMAEMPIRE1_COMPARE.md: per item, theirs (numbers, flow) / ours today (file:line) / what is worth taking
   (only if it would raise one of our mechanics' depth or play, with the probe it would need) / what we already do better.
   Top 5 takeaways first, 20 lines max for the owner; the detail below.
4. `python ops/Tools/review_add.py --stage S539 --rating "reference, Claude" --title "MMA Empire update: what it shows" <stills>` if stills.

## Prior research
`python ops/Tools/prior_research.py mma empire camp weigh backup`; ops/research/G103_MENU_BENCHMARK_TEARDOWN.md,
C65_WMMA5_TEARDOWN.md (shape of a teardown), memory feedback_rea_first_for_reference_numbers_s439.

## What would a human do?
Play the competitor's new update for an evening with a notepad, then decide what to borrow.

## Prefab check
n/a (research).

## Contract
OWNS: ops/research/MMAEMPIRE1_COMPARE.md, ops/previews/s539_mmaempire/
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Rules
No Godot. Never open a window on his monitors; never start/explorer/a browser pane on its files. Commit only your paths, push.
When done run `python ops/Tools/idle_guard.py ok MMAEMPIRE1-done`, report in two lines, stop.
