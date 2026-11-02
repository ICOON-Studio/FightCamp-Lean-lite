# TASK G156 - wire the rest of the built-but-unwired player features (Grok CLI, standing "gated items" owner)
Owner: Grok (Grok Build CLI). Worktree E:/FightCamp/wt/G156, branch grok/g156-wire-the-rest (from master).
Operator 2026-10-01, verbatim: "assign ... someone working on missing gated items" and (S137) "Do not build another exe
unless everything we've built so far is all gated to the gym, fight and the fight engine". "Gated" = WIRED: a built
mechanic must run in the game the player gets (boot -> career -> fight). You own this list until it is empty.

## Source of truth
`research/S137_WIRING_AUDIT.md` sections B and C. ALREADY WIRED since (do not redo): medal table / honours board /
title tenure (Q223), the 44-action offer desk: short notice, promotion bouts, signing, contender, retention, sponsorship,
win % (G154), personality + rivalry heat in the fight (C230 + S138), week in review (U205), camp consequences (G155).
IN FLIGHT elsewhere (do not touch): fighter portraits (Cursor U208/U209), walkout (Codex queue), bot art (U207).

## Step 1 - census (write it into the digest first)
Re-run the audit's method on master: `python Tools/wiring_census.py` (unreached scripts) and the GameState public-func
census (S137_WIRING_AUDIT.md "Method" 2: 356 public funcs, which are never named by another shipped script/scene).
List what is STILL unwired from section B, plus every GameState action still without a button (expected survivors:
media questions, weight-cut plan, cancel booking, and more - list them all with line numbers).

## Step 2 - wire, in this order (each with its own test + control + an opened still)
1. Every GameState action that is a player DECISION and has no button: put it where the player already makes that kind
   of decision (booking -> ScheduleHubPanel, weight -> fight week / weigh-in, media -> the inbox/day feed). Icons over
   text with tooltips (DesignLibrary/GLOSSARY.md "Icon with tooltip"; `UIKit.icon_plate`, `UIKit.tip`).
2. The word modules nobody calls: LedgerWords (injury ledger), SpreadWords + StatSpread, SurfaceWords, ContestLength,
   CompetitionAge, skill band words (D23 - StatWords still says POOR/FAIR/STRONG/ELITE), the stat legend tooltip (C44)
   - each at the screen whose numbers it explains.
3. ArenaFit (G20) at the gym building/expansion caller.
4. FightHudPanel (U25: heart rate, trauma pips, attrition) - ONLY after checking against the live room's own HUD and
   Kalli's K83 scorebug spec (`research/bots_s138/kalli.txt`, K83); if it would duplicate, write why and park it.
5. Anything else the census finds - wire it or write the one-line reason it should stay a dev tool.

## Owned files
The panels the census names (list each with line ranges in the digest), thin GameState reads only (GameState.gd is
17k+ lines - sed -n windows, never read whole), new tests `Godot/tests/g156_*_test.gd`, `Godot/tools/g156_stills.gd`,
`previews/g156/*`, `research/G156_DIGEST.md`.

## Prior research
`python Tools/prior_research.py wiring unwired button gated` - S137_WIRING_AUDIT.md, G154_DIGEST.md (how the offer desk
was wired - copy its pattern), D66_STRICT_REVIEW.md (clarity).

## What would a human do?
A systems designer with a feature list and a build: walk the game as a player, find where each decision naturally
belongs, put one control there, and prove it changes the save.

## Prefab check
Our own UIKit and GameState actions only.

## Tests
Parse gate; each new test (fixture that must show the control + a control fixture that must not); then
`python Godot/tools/run_tests.py --jobs 2 --only smoke,schedule_hub,fight_week,weigh,profile_revamp,office_hub,ui_kit`.
Stills via `Tools\godot_hidden.ps1` - OPEN every one. Watchdog before every heavy run.

## The one trap
Godot 4.7 renames a second sibling with a reused name to `@Panel@N` - your tests that find nodes by name break silently
(G154 `_keep_card_name` solved it; reuse it).

## Finish
git add by explicit path, commit, git push -u origin grok/g156-wire-the-rest. Never edit HANDOFF.md. Do not stop at written.
