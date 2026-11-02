# TASK U202 - GF1 part C: the finance desk and the floor stations explain themselves (Cursor, S133)

Model: composer-2.5. Worktree `D:/FightCamp/wt/U201` re-branched `cursor/u202-finance-floor` from master.

## Why
Dola's D66 weaknesses 7 and 8 (`research/D66_STRICT_REVIEW.md`): finance reads "net -$231/week, $25k cash, no
breakdown, no forecast"; the floor reads "36/40 used, 1.1x load" with no word on what a station does or what expanding
buys. Your U201 (merged 3ccf0e36) did the card, skills and home; this is the same work on two more screens.

## Prior research
`topics/ui_screens.md`, `J52_TOOLTIPS_AND_TUTORIAL.md`, `S78_DIGEST.md`, `U201_DIGEST.md` (your own pattern).

## What would a human do?
Motorsport Manager's finance screen: every money line says where it comes from on hover, and the runway says how many
weeks the cash lasts. Two Point Hospital's rooms: hover a station, see what it trains and who uses it.

## Prefab check
Reuse `UIKit.tip`, TipLayer, Glossary (you may ADD terms). The finance desk ALREADY has a gym week, a runway, a month
and books: `OfficeHubPanel.gd` (1692 lines) `_build_desk` :296, `_build_gym_week` :328, `_build_runway` :402,
`_build_purse` :438, `_money_line` :551, `_build_month` :678, `_build_books` :843, `_build_named_week` :925. Most of the
gap is EXPLAINING what is there - check before you build anything.

## The work
1. Finance: every money line gets a hover naming its source and cadence (`_money_line`'s `source`); the runway says in
   words how many weeks the cash lasts at this week's net; only if an income-vs-costs breakdown is truly missing from
   the screen, add it from the ledger data the desk already reads - no new GameState maths.
2. Floor (`TrainingFloorPanel.gd`: the station tiles and the used / load / expand line): each station gets a hover -
   what it trains (from its data) and which fighters use it this week; the expand button says what it adds.

## Owned files
`Godot/scripts/OfficeHubPanel.gd` (the functions above), `Godot/scripts/TrainingFloorPanel.gd`, `Godot/scripts/Glossary.gd`
(ADD only), NEW `Godot/tests/gf1_finance_floor_tips_test.gd`, `previews/u202/` (ONLY the finance and floor
stills - not the whole walk), `research/U202_DIGEST.md`. NOT GameState.gd, UIKit.gd, ProfileRevampPanel.gd.

## Tests
Parse gate on every touched .gd. Your test asserts every money line and station tile resolves a NON-EMPTY
`TipLayer.body_for`. Then `python Godot/tools/run_tests.py --jobs 2 --only office_hub,gym_ledger,ledger_words,training_floor,menu_clarity,gf1_finance`.
Stills: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/s64_career_walk.gd -- plan=research/s117_boxer_walk.plan out=<a temp dir> as_game`,
then copy ONLY the finance and floor shots into docs/previews/u202/.

## Deliver
Commit, `git push -u origin cursor/u202-finance-floor`, 10-line digest. A tooltip says only what the code computes.
