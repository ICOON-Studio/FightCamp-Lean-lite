# TASK R19 — CLAUDE — the profile in the game, and the record numbers

Self-contained. Read this file, then only the files it names. R18 shipped
the profile as a panel that exists only in the render tool; R19 makes it
the screen the player opens, and feeds its record numbers from Grok's
module instead of hand-rolled sums.

## 1. The wrapper (small, do it first)

At the END of `Godot/scripts/GameState.gd`, next to
`get_fight_log(athlete_id)` at `:9970`:

    func get_fight_record_stats(athlete_id: String) -> Dictionary:
        return FightRecordStats.summarize(get_fight_log(athlete_id))

`FightRecordStats` is `Godot/scripts/FightRecordStats.gd` (Grok G8,
`4b3eb45`, pure static; shape in `research/G8_DIGEST.md`). Preload
it as a const like the other modules; do not name it as an autoload.

## 2. The FIGHT RECORD tab reads it

`Godot/scripts/ProfileRevampPanel.gd:983 _fill_numbers` currently sums
purse, hype and title fights over the log by hand and derives the finish
rate from `wins_by_*`. Replace that with `get_fight_record_stats(id)` and
show what the module adds that the tab cannot say today: the current
STREAK and the BEST streak, the FORM of five, and the by-event line.
Keep the four stat tiles and the wins-by split bar; nothing new invented.

## 3. The panel becomes the screen

- Entry point: `Godot/scripts/OfficeHub.gd:6246 _open_athlete_profile`,
  scene const at `:26` (`ATHLETE_PROFILE_SCENE`).
- Pattern to copy: `Godot/scripts/DayFeedScreen.gd` — `SHELL_PATH` const,
  `load()` by path inside the function, never the bare autoload
  identifier (scene scripts compile before the autoloads), content at
  `ShellChrome.CONTENT_POSITION`, the Continue handler passed in.
- The legacy `AthleteProfileScreen.tscn` stays for the screens that still
  mount panels into it (DevelopmentPanel, SkillsMovesPanel); R19 only
  routes the roster click to the shell-hosted profile. Migrating the rest
  of the legacy screens is its own stage — do not start it here.

## 4. Verify

- Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/ProfileRevampPanel.gd Godot/scripts/OfficeHub.gd`
- `tests/profile_revamp_test.gd` (extend it: the record numbers come from
  the module; the streak and form read what the log holds),
  `tests/fight_record_stats_test.gd`, `tests/office_nav_and_profile_overlay_test.gd`,
  then the full suite ONCE.
- Re-render the pictures if the profile changed:
  `Godot_v4.7.2-stable_win64_console.exe --path Godot --script tools/render_profile_revamp.gd`
  (windowed, NOT headless) and rebuild `sheet.png` as a 3x3 contact sheet
  (960x540 thumbs, 10 px gutter, ground #0e1116).
- Commit, push `master`, digest in `HANDOFF.md` (max 8 lines), END the session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/GameState.gd
Godot/scripts/ProfileRevampPanel.gd
```
