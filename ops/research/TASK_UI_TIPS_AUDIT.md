# TASK_UI_TIPS_AUDIT - which controls have no tooltip (agy, read-only census)

Model: Antigravity default. Tier: research only - NO game script is edited, no test run.

## Why
Operator S184: "almost everything in the game needs a tooltip" and "use icons (with tooltips) not descriptive words".
The helper is `UIKit.tip(node, spec)` in `Godot/scripts/UIKit.gd` (line ~206). `spec` is a String, or a Dictionary
`{"title", "text"}` or `{"term": <glossary key>}`. Native `tooltip_text` is cleared by the tooltip layer, so only UIKit.tip counts.

## Prior research
searched: top bar icons tooltip sidebar nav tycoon (nothing). Related: `research/topics/ui_screens.md` (J52_TOOLTIPS_AND_TUTORIAL.md:
a control tip starts with a verb and does not repeat its label).

## What would a human do?
Hover every button, icon, chip, badge and number in each screen and note which ones stay silent.

## Prefab check
UIKit.tip already exists; nothing new is built. This task only measures.

## Owned files (you write ONLY this one)
- `research/S184_TIPS_AUDIT.md` (new).

## Do
1. Read these panels (windows of ~200 lines, never whole files; each is under 3,000 lines except UIKit.gd 8.7k):
   `ScoutingHubPanel.gd`, `StaffHubPanel.gd`, `TrainingHubPanel.gd`, `ScheduleHubPanel.gd`, `RankingsHubPanel.gd`,
   `OfficeHubPanel.gd`, `AreaHubScreen.gd`, `GymHubPanel.gd`, `DayFeedScreen.gd`, `InterviewPanel.gd`, `GymHallPanel.gd`
   (all under `Godot/scripts/`).
2. For each file: `grep -n "Button.new()\|UIKit.button(\|UIKit.chip(\|_button(\|_choice_card(" <file>` and check whether the SAME
   node (or its builder helper) gets `UIKit.tip(`. A control built through a helper that already tips counts as covered.
3. Write `S184_TIPS_AUDIT.md`: one table per file (line, what the control is, covered yes/no, a proposed tip of at most 12 words
   starting with a verb). Top of the file: totals per file and the 10 worst. Quote line numbers you opened.
4. Do NOT write the tips into the scripts. Claude applies them from your table.

## Trap
`UIKit.tip` called twice on one node may overwrite - note any node that is tipped twice. Do not count `tooltip_text` as covered.

## Acceptance
The file exists, covers all 11 panels, every row has a line number, and a spot check of 5 random rows by Claude matches the source.
