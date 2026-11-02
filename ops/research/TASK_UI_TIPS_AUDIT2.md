# TASK_UI_TIPS_AUDIT2 - second tooltip census: the screens the first pass did not read (agy, read-only)

Model: Antigravity default. Tier: research only - NO game script is edited, no test run. USE ONLY YOUR FILE READ AND WRITE TOOLS: run NO shell commands (headless mode auto-denies them).

## Why
Operator S184: "almost everything in the game needs a tooltip". Pass 1 (`research/S184_TIPS_AUDIT.md`, applied 3d328a04) covered the 11 hub panels and only buttons.
Pass 2 covers the remaining screens AND the non-button things a player hovers: stat labels, number cells, chips, badges, icons, bars.
The helper is `UIKit.tip(node, spec)` in `Godot/scripts/UIKit.gd` (~line 206): spec is a String, `{"title","text"}` or `{"term": <glossary key>}`. Native `tooltip_text` is wiped at runtime and does not count.

## Prior research
searched: top bar icons tooltip sidebar nav tycoon (nothing); see `research/S184_TIPS_AUDIT.md` for the format and `topics/ui_screens.md` / J52 (a tip starts with a verb, never repeats its label).

## What would a human do?
Hover every button, number, bar, chip and icon on each screen; list what stays silent and what it should say.

## Prefab check
UIKit.tip exists; nothing new is built. This task only measures.

## Owned files (you write ONLY this one)
- `research/S184_TIPS_AUDIT2.md` (new).

## Do
Read these in windows of ~200 lines (never whole), all under `Godot/scripts/`: `AthleteProfileShellScreen.gd` (the fighter card shell), `FightCampPanel.gd` (1,715 lines),
`FightWeekPanel.gd`, `WeekReviewPanel.gd` (1,344), `CornerPanel.gd`, `FightNightScreen.gd`, `CreationFlowPanel.gd`, `TrainingFloorPanel.gd`, `ShellChrome.gd` (only the top bar part: lines 440-700).
For each file list controls and displayed things with no `UIKit.tip` on the same node (or its builder helper): buttons, `UIKit.label`/`UIKit.display` numbers, `UIKit.chip`, bars, icons.
Write `S184_TIPS_AUDIT2.md`: one table per file (line, what it is, covered yes/no, proposed tip of at most 12 words, verb first), totals at the top, the 10 worst at the top.
Do NOT write tips into the scripts; Claude applies them.

## Trap
Pass 1 under-counted: it missed buttons made by helper calls such as `_offer_button(card, "Name", ...)`. Grep-by-eye for `_button(` helpers and `.name = "` lines, and list the helper too.

## Acceptance
The file exists, covers all 9 files, every row has a line number, and a spot check of 5 random rows by Claude matches the source.
