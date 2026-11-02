# TASK LUDO-CORNER2A - composure LIVE in the fight + the band tag on the HUD card (V14, D41, D43; Ludo round-8 item 1)

Model: Codex gpt-6.1-sol (CODEX_MODEL=gpt-6.1-sol - engine work). Worktree E:/FightCamp/wt/LUDOCORNER2A, branch codex/ludo-corner2a from
master (AFTER LUDO-PAD1 is merged - it touches the same file). Push the branch; never master. Never open a window, image viewer or browser.
Godot windowed only via Tools\godot_hidden.ps1 (hidden desktop); look at stills with your file tool.

## Owned files
- `Godot/scripts/FightRealtime.gd` (8,390+ lines - NEVER read whole; grep + sed -n windows)
- `Godot/scripts/LudoFightHud.gd` (the fight HUD, ~640 lines) - add `set_composure(side, value)` + the band tag
- `Godot/scripts/FightWorldLiveScreen.gd` (6,200+ lines - windows only) - feed the HUD from the fight state in `_rr_update` (~5135)
- `Godot/tests/composure_live_test.gd` (NEW, engine), `Godot/tests/ludo_fight_hud_test.gd` (extend)
- `Godot/tools/composure_still.gd` (NEW) + `previews/corner2a/*.png`

## Prior research
- The pure rules: `Godot/scripts/Composure.gd` + `Godot/assets/data/composure.json` (LUDO-COMPOSURE1). IF THEY ARE NOT ON MASTER WHEN YOU
  START, STOP and say so - do not re-implement them. Numbers of record: `research/LUDO_CORNER_TABLES_S190.md` section COMPOSURE +
  D43 (counter latency Focused 0 / Rattled 0.15 / Shaken 0.30 / Broken 0.60 s).
- Ludo's acceptance (round 8, `LUDO_ROUND8_NEXT_S191.md`): "When Leo takes a clean hook or lands his pad chain, his live card displays his
  composure tier tag changing color (Focused in green, Rattled in yellow, Shaken in orange, Broken in flashing red)."
- Engine anchors: `DEMO_SWITCHES` ~1169 + `as_game()` (the switch pattern), `_build_fighter` ~1246-1551, the strike resolution (grep
  `"contact"` / `clean`), knockdowns (grep `knockdown` ~2043, ~2612, ~2929), the round scoring (grep `ten_point` / `score_round`), the ropes
  (grep `ropes` / `_on_ropes`), the pad-chain fire point LUDO-PAD1 added (grep `pad_chain`), whiff/counter (grep `whiff` / `counter`).
- How a corner effect reaches behaviour today: `_corner_read` ~2838 and `read_active` ~4927 (plan adherence lives near there).

## What would a human do?
Give each fighter a composure number at the first bell, move it on the events Ludo listed, let the band scale three things the engine
already has (plan adherence, guard, counter reaction), and show the band on the HUD card - all behind one switch, OFF arm untouched.

## Spec
1. Switch `ludo_composure`, default OFF in `--script` runs, NOT in DEMO_SWITCHES yet (the operator turns it on after the still).
2. ON: fighter["composure"] = Composure.start_value(fight_iq, chin, traits) at the first bell; Composure.apply on: clean power head shot
   taken, rocked, knockdown suffered, knockdown scored, pad chain fired (LUDO-PAD1's event), counter on a whiff, round won/lost (at the
   bell, from the live cards), ropes > 4 s (per second); corner recovery (+ conditioning x 0.15) at the stool. (Cut opened comes with
   LUDO-DOC2 - leave a named hook.) Every change appends a log entry {type: "composure", side, value, band, cause}.
3. ON: the band scales plan adherence, guard and counter-reaction latency through the EXISTING knobs (find them; do not invent parallel
   ones); Broken blocks pad chains (PadChain fire check).
4. HUD: `LudoFightHud.set_composure(side, value)` shows a small band tag under each card's bars: Focused green / Rattled yellow /
   Shaken orange / Broken flashing red, with a UIKit tip ("Composure 77 - Focused: follows the plan"). Fed from the log in `_rr_update`.
5. OFF arm BYTE-IDENTICAL: same seed, switch OFF -> identical log/result hash before and after your change (print both in the test).

## Done = (tier: script edited - parse, focused tests, related runs)
- Parse gate on every touched .gd.
- `composure_live_test.gd`: 2 DIFFERENT boxers (never identical; name the population in the output), 6 seeds: ON -> composure entries
  exist, values stay 0-100, a knockdown suffered lowers it by 25 (unless clamped), Broken fires no pad chain, latency per band applied;
  OFF -> no composure entries and the log hash equals master's. Write it RED first on master (paste the count).
- `ludo_fight_hud_test` extended: the tag colour per band, tip present, nothing overlaps.
- `python Godot/tools/run_tests.py --only fight_realtime --jobs 2`, `--only pad_chain --jobs 2`, `--only ludo_fight_hud --jobs 2` -> 0 fails.
- STILLS through `Godot/tools/still_framing.gd` `save_if_framed` (the game camera; both men head to feet or it refuses):
  `composure_still.gd -- as_game ludo_composure` -> `01_focused.png` (round 1 start) and `02_after_knockdown.png` (the frame after a
  knockdown, the struck man's tag changed). Open both with your file tool.
Commit + push codex/ludo-corner2a. Final message: red count, green results, OFF-arm hash proof, the two stills.

## The one trap
Composure must read the PRESENTED event order the HUD shows (the log), never a future tick - otherwise the tag changes before the punch lands.
