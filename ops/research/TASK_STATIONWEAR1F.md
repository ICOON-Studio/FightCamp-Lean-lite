# TASK STATIONWEAR1F (S222) - station card v2 (icons, not words) + the one tooltip system (TipLayer upgrade)

Model: cloud Cursor (label `cursor`). Repo ICOON-Studio/FightCamp, branch `cursor/issue-<n>` from master. Open a PR, never merge.
No Git LFS on the cloud box: tests must not load models. Do not delete or shorten any existing test.
APPROVED: operator board Q-S221-1 "Approve, build it" on `research/LUDO_ROUND60_VERDICT_S222.md` - read it WHOLE, then sections A
and B of `research/LUDO_ROUND60_REPLY_S222.txt` (Ludo's pixel spec). The VERDICT wins where they differ (numbers come from the game).
Operator notes this answers, verbatim: "make it look less ai-made use icons and nice graphic instead of wording"; "do not use so much
text , use also tooltip modals for explaining things". New features ship ON (operator S221) - no opt-in switch.

## Prior research
STATIONWEAR1B-1E (TASK_STATIONWEAR1E.md, LUDO_ROUND56 verdict): the wear rules in `Godot/scripts/StationIntegrity.gd` (275 lines:
bands good >= 75 / worn >= 45 / damaged >= 20 / failing / out of use; SERVICE_POINTS 50, SERVICE_CAP 95, REPLACE 100).
The card today: `Godot/scripts/StationInfoCard.gd` (759 lines; `build` 63, `_add_integrity_section` 226, `action_rows` 204,
WEAR_CARD_W 360 at 312). Tooltips today: autoload `Godot/scripts/TipLayer.gd` (303 lines, SHOW_DELAY 0.5, MAX_WIDTH 340, plain
RichTextLabel) fed by `UIKit.tip(node, spec)` (UIKit.gd line ~206; spec = Glossary id | line | {term,text,title,now}).

## What would a human do?
Football Manager / Two Point Hospital: the card shows a bar, three icon numbers and two buttons; hovering any number explains it in
two lines. Nobody reads a paragraph on a floating card.

## Prefab check
Icons: Lucide (https://lucide.dev, ISC licence, plain SVG, Godot imports SVG natively) - use: wrench, refresh-cw, trending-down,
cross / shield-alert, clock, coins, users, info, x, dumbbell. Put them in `Godot/assets/ui/icons/lucide/` with the LICENSE text and a
line in the repo's credits file (grep CREDITS). Tint with `modulate`; 24 px and 16 px. No other icon pack.

## Owned files
- `Godot/scripts/StationInfoCard.gd` - the card v2 layout (340 x ~266): row 1 icon + name + "1x2m" pill + close; row 2 10-block band bar
  + "38%" + band pill + (i); row 3 three icon tiles (efficiency x0.65 / injury +1.25% / hours to next band "14h") from the SAME
  numbers the card computes today; row 4 TRAINS pills; row 5 coin "$18/wk" + users "2/2 in use"; row 6 SERVICE $X (+50, max 95%;
  disabled at >= 95 with its tooltip) and REPLACE $Y as HOLD-1-SECOND-to-confirm (a fill runs across the button; release early cancels).
  ALL paragraphs (best for other sports, your fit, the station blurb) move into the (i) tooltip and the tiles' tooltips.
- `Godot/scripts/TipLayer.gd` - the tooltip system per verdict 2: 350 ms show (0 ms when moving to a neighbour already tipped),
  title + up to 2 short lines + optional mini bar or "value (delta)" row, flip at the 1920x1080 edges, 24 px exit grace, hide on click /
  Esc / pause. Keep every existing `UIKit.tip` spec working (Glossary ids, plain lines, dicts) - one system, no second tooltip class.
  New optional dict keys: `icon` (res path), `bar` (0..1 + band colour), `value`, `delta`.
- `Godot/scripts/UIKit.gd` (9,156 lines - NEVER read whole; grep `static func tip`): only if the new dict keys need a helper.
- Tooltip copy for the card: a small `Godot/assets/data/tooltips_station.json` (title + <= 14 words each), written from the game's real
  rules (StationIntegrity, StationDisciplineFit) - NOT Ludo's invented lines (no "chin integrity", no "wrist sprain").
- Tests: update `tests/station_info_card_test.gd` / `tests/station_card_pin_test.gd` ONLY where they asserted removed paragraph text -
  replace each such check with the equivalent check on the tooltip spec (never just delete it); NEW `tests/station_card_v2_test.gd`.

## Acceptance - `station_card_v2_test.gd`
(a) card width 340, height <= 280, no Label on the card longer than 24 characters; (b) the three tiles show the same efficiency / injury
/ hours values the old card computed for a damaged bag (38%); (c) the (i) tooltip spec carries the other-sports fit lines; (d) SERVICE
disabled at 95% with a tooltip; at 38% a service makes it 88%; (e) REPLACE fires only after a 1.0 s hold (simulate with the test hook),
an early release fires nothing; (f) TipLayer: show delay 0.35 s, a tooltip near the right/bottom edge is placed fully on screen;
an old-style `UIKit.tip(node, "upkeep")` still shows its Glossary text. Also run station_info_card, station_card_pin, station_wear,
station_integrity and the four `gf1_*_tips` tests. Parse gate: `python Godot/tools/check_scripts.py <touched .gd>`.

## The one trap
TipLayer is an autoload every screen uses: the gf1_*_tips tests pin its old behaviour - a changed delay or layout must keep their
checks true (read them first); do not loosen them.
