# TASK R23 — CLAUDE — the FIGHTER CARD, the third replacement

Model: **Opus 5**. Effort: **high**. Fast mode: **ON**.
This is step-6-shaped work on the screen the player opens most: 1863
lines deleted, five tests and four tools swept, and the panel repointed
at a new read. High, not medium — that is where a lower setting leaves a
hanging parse error costing a timeout per test. Fast mode carries the
mechanical sweep. All three are decided at assignment; do not
self-escalate.
Starts now: C6 landed 2026-09-05 as `0b84633` (suite 120/120), so nothing
blocks this. Not date-gated. One session; end it on ship.

Self-contained. Read this file, `C6_DIGEST.md` and the anchors below.
Never `HANDOFF_ARCHIVE.md`; never `GameState.gd` whole.

## Why

Legacy scenes are discarded, not migrated (user decision 2026-09-05,
HANDOFF Direction notes). GYM shipped as R21, TRAINING as R22
(`18295ae`). The fighter card is the third — and the cheapest, because
**the kit panel is already the live route**: R19 mounted
`ProfileRevampPanel.gd` inside `AthleteProfileShellScreen.gd`, and R20
made `fighter_card` a CareerRoot panel route.

So `AthleteProfileScreen.gd` (1863 lines) has **no production caller
left**. Verify that yourself before deleting — the only hits outside
tests and tools are comments in `OfficeHub.gd` (28, 2483, 3952),
`EventsBoard.gd` (7), `DevelopmentPanel.gd` (10), `SkillsMovesPanel.gd`
(11), `TaleOfTape.gd` (125), `GameState.gd` (10127) and
`AthleteProfileShellScreen.gd` (5). Comments only. Nothing loads it.

## Build, in this order

1. **Adopt C6.** `ProfileRevampPanel.gd` makes **25 separate GameState
   calls per rebuild**, and it rebuilds on every tab switch, every
   answered ask and every route arrival. C6 shipped
   `get_fighter_card(athlete_id)` — one projection carrying identity,
   ratings, record, next bout, week plan and offers, flags, goals,
   titles, ranking, loyalty/request, awards, weight, camp, contract, log
   and both clearances. Replace the reads in `_read()` (144) with one
   call. Keep `respond_to_request` exactly where it is: it is a WRITE and
   stays on the panel.
   List what the panel calls before you start:

       grep -o '_call("[a-z_]*"' Godot/scripts/ProfileRevampPanel.gd | sort -u

   **The render must not change.** `DesignLibrary/screens/profile_revamp/`
   is the approved bar (nine views plus `sheet.png`); re-render with
   `tools/render_profile_revamp.gd` (windowed, NOT headless) and compare.
   A number that moves means the adoption is wrong, not the picture.
   C6's contract notes that matter: unknown id returns `{}`, and a world
   fighter returns `identity.roster = false` with the roster-only regions
   present but empty — the card opens on opponents from a bout list, so
   prove that path.

2. **Delete the legacy screen.** `Godot/scripts/AthleteProfileScreen.gd`
   and `Godot/scenes/AthleteProfileScreen.tscn`.

3. **The sweep.** Every reference, with its line today:

   - `Godot/tests/smoke_test.gd:16` — the scene list entry.
   - `Godot/tests/athlete_profile_test.gd:3` — `preload`s the scene and
     is entirely about it. Retire it, moving any assertion that is about
     GameState into `profile_revamp_test.gd`.
   - `Godot/tests/fight_camp_panel_test.gd:37` — `load`s the `.gd` to
     mount the camp panel. Mount it the way the kit panel does.
   - `Godot/tests/development_screen_test.gd:81` and
     `Godot/tests/skills_moves_screen_test.gd:112` — these read the
     legacy screen's SOURCE as a string to prove a panel is loaded by
     path and never names an autoload. That rule outlives the screen:
     re-assert it against `ProfileRevampPanel.gd` instead of deleting it.
   - `Godot/tests/stage4d_recovery_ui_test.gd:88` — instantiates the
     scene for the medical profile's assigned-station claim. R22 already
     moved that test's first half onto GameState; finish the job.
   - `Godot/tools/CaptureManagementCompletionPreviews.gd:51`,
     `CaptureStage3CodexPreviews.gd:96`,
     `CaptureStage4DRecoveryPreviews.gd:87` — drop the entry, keep the
     tool (none exists only for the profile).
   - `Godot/tools/text_overflow_audit.gd:20` — drop the scene entry.

   Keep every assertion that is about GameState and repoint it at the
   system that owns it; drop only claims about the dead screen's own
   widgets. That is the R22 rule and it held up.

4. **Verify by grep** that no `AthleteProfileScreen` scene path or script
   load remains. Comments that name it in the past tense are fine —
   reword them the way R22 did ("the retired ...").

## The gotcha R22 paid for

`HANDOFF.md` and several tests carry **mixed line endings** — a CRLF file
with LF-appended lines. Anchor-based patching silently fails on them.
Patch those files by **line index**, keeping untouched lines byte-for-byte
and writing new lines with the file's dominant terminator.

## Anchors

    Godot/scripts/ProfileRevampPanel.gd:47   setup()
    Godot/scripts/ProfileRevampPanel.gd:108  _call()      ← the 25 reads land here
    Godot/scripts/ProfileRevampPanel.gd:144  _read()
    Godot/scripts/AthleteProfileShellScreen.gd:1  the host, stays
    Godot/scripts/SceneRouter.gd:54          the fighter_card route, stays
    Godot/scripts/GameState.gd:10192         get_fight_record_stats
    research/C6_DIGEST.md              the projection's contract

## Gate

    python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd <every other touched .gd>
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd

`profile_revamp_test.gd` grows the C6 adoption proof: the panel builds
for a real roster fighter from ONE `get_fighter_card()` call, a world
fighter builds with the roster-only regions empty, an unknown id builds
nothing rather than half a card, and answering an ask still goes through
`respond_to_request` and rebuilds.

Then `scene_router_test`, `development_screen_test`,
`skills_moves_screen_test`, `fight_camp_panel_test`,
`stage4d_recovery_ui_test`, `smoke_test`; the full suite once, in the
background, right before the commit. Digest
`research/R23_DIGEST.md` (short); cite C6's hash in it and this
stage's hash in the next digest.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/ProfileRevampPanel.gd
Godot/tests/profile_revamp_test.gd
research/R23_DIGEST.md
```
