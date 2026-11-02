# TASK LUDO-HUD1 - Ludo's live fight HUD, top band + towel tray (V12, approved D40)

Model: Cursor (cursor_task.cmd). Worktree E:/FightCamp/wt/LUDOHUD1, branch cursor/ludo-hud1 from master. Push the branch; never master.
Never open a window, image viewer or browser on the operator's screens. Windowed Godot ONLY through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>` (hidden desktop). Look at stills with your FILE tool.

## Owned files
- `Godot/scripts/LudoFightHud.gd` (NEW, Control)
- `Godot/assets/data/ludo_fight_hud.json` (NEW - pulse constants)
- `Godot/scripts/FightWorldLiveScreen.gd` (6192 lines - NEVER read whole; windows below)
- `Godot/tests/ludo_fight_hud_test.gd` (NEW)
- `Godot/tools/ludo_hud_still.gd` (NEW - the stills tool)
- `previews/ludo_hud1/*.png` (NEW stills)
Read-only: `Godot/scripts/BroadcastScorebug.gd` (432 lines - its public API is the contract you copy), `Godot/scripts/UIKit.gd` (`UIKit.tip`),
`Godot/scripts/UITokens.gd`.

## Prior research
- Ludo (lead designer, approved by the operator as V12): `research/LUDO_ROUND4_S190.md` lines ~190-215 - the mock-up
  `previews/ludo_s190/02_fight_night_screen.png` (read the LAYOUT, its text is AI-garbled) and Ludo's acceptance: "Player watches
  fighter take an overhand right; pulse spikes to 180+ BPM and turns red instantly on the top-left HUD."
- `research/LUDO_EVALUATION_S190.md` M1 / V12.
- The current HUD = `BroadcastScorebug` (lower-left, S141 K83), mounted in `FightWorldLiveScreen._build_round_clock()` (~line 5030) and
  fed in `_rr_update()` (~5076-5111): set_stamina, set_ticker, add_knockdown, set_punches; set_clock + set_badges elsewhere
  (`grep -n "_scorebug\." Godot/scripts/FightWorldLiveScreen.gd`).
- Operator UI rules: icons over text, every icon has a tooltip via `UIKit.tip` (native tooltip_text is cleared - S164).

## What would a human do?
Build the new HUD as a drop-in with the SAME API as the scorebug, swap it in behind a switch, and prove it on stills from the live fight.

## Prefab check
N/A - our own UI kit (UIKit/UITokens) is the house style.

## Scope (ONLY this - the bottom corner panels are other tasks)
In scope, from mock-up 02:
1. TOP-LEFT card, our fighter: portrait slot (reuse whatever `_scorebug_identity("a")` gives; initials chip if no portrait), surname,
   health bar (head damage), stamina bar, and an ECG pulse line with a BPM number tinted green / amber / flashing red.
2. TOP-CENTRE: ROUND n | mm:ss | speed chips 1X 2X 4X (wire to the screen's existing speed control if one exists - grep `speed`; if
   none, show the chips disabled with a tooltip "speed control comes later").
3. TOP-RIGHT card, the opponent: same bars mirrored + a row of up to 3 tell icons (`set_tells(list)`; empty list = row hidden - the tells
   data lands with LUDO-TELLS1).
4. BOTTOM-RIGHT: a red THROW TOWEL tray button, wired to the existing towel path (grep `towel` in FightWorldLiveScreen ~780 and ~5550);
   tooltip says what it does.
OUT of scope: mid-round shouts (operator approved V1: NO mid-round shouts), stool/cutman/strategy panels (= LUDO-CORNER2), referee badge
(referee personalities are not built - leave a hidden slot named "RefereeBadge").

## Spec
- `LudoFightHud.gd` extends Control, full-rect, mouse_filter IGNORE except the towel button. Public API = every BroadcastScorebug method
  the screen calls (same names + args) PLUS `set_pulse(side, bpm)`, `set_health(side, fraction)`, `set_tells(list)`, `pulse(side) -> int`.
- Pulse model (pure static func on LudoFightHud, constants from `ludo_fight_hud.json`, never inline):
  `bpm = rest_bpm + (1 - stamina) * fatigue_bpm + spike` where every CLEAN head hit taken adds `head_spike_bpm` (power-scaled if the log entry
  has power) that decays with `spike_half_life_s`; clamp [rest_bpm, max_bpm]. Bands: green < amber_from, amber < red_from, red >= red_from
  (red flashes). Start values: rest 72, fatigue 70, head_spike 45, half-life 3 s, max 200, amber_from 140, red_from 170. Ludo's acceptance
  must hold: fresh fighter (stamina 0.8) + one clean power head shot -> >= 180 and red the same frame.
- Switch `ludo_hud` DEFAULT OFF (operator S117 switch rule): `var ludo_hud: bool = OS.get_cmdline_user_args().has("ludo_hud")` on
  FightWorldLiveScreen, settable by a test before setup. OFF = today's scorebug, byte-for-byte unchanged code path. ON = LudoFightHud mounted
  in place of the scorebug in `_build_round_clock()`; keep `_scorebug` working by typing it as Control and calling through the shared API
  (or a second var - your call, keep the OFF path identical).
- Labels outside Containers break lines with `\n`; full-rect Controls never assign `size` on mount; TextureRect: expand/stretch mode before
  texture (CLAUDE.md s9).

## Done = (tier: script edited - parse, focused test, then the related run)
1. `python Godot/tools/check_scripts.py Godot/scripts/LudoFightHud.gd Godot/scripts/FightWorldLiveScreen.gd Godot/tests/ludo_fight_hud_test.gd Godot/tools/ludo_hud_still.gd`
2. `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/ludo_fight_hud_test.gd`
   (NEVER the _console exe) -> `LUDO_FIGHT_HUD_TEST FAILS=0`. The test: pulse bands at the 3 thresholds; Ludo's acceptance case
   (>= 180, red); decay (after 3 half-lives the spike is < 1/8); every icon in the HUD has a UIKit tip; nothing clips at 1920x1080 and
   1280x720 (each Label's text fits its rect, no two cards overlap); switch OFF mounts BroadcastScorebug and no LudoFightHud. Write it RED
   first (before LudoFightHud exists) and paste that red count in your final message.
3. `python Godot/tools/run_tests.py --only scorebug --jobs 2` and `--only fight_world --jobs 2` -> 0 fails.
4. STILLS from the live fight's own camera, switch ON: `Tools\godot_hidden.ps1 --path Godot --script tools/ludo_hud_still.gd -- as_game ludo_hud`
   -> `docs/previews/ludo_hud1/01_guard.png` (round 1, fighters at guard), `02_mid_punch.png` (a clean head shot landing, pulse red),
   `03_break.png` (between rounds), plus `04_off.png` (switch OFF, today's scorebug). Open each with your file tool; fix anything that clips,
   overlaps or covers the fighters before you finish.
Commit + push cursor/ludo-hud1. Final message: red count, green result, the 4 still paths, and anything you could not fit.

## The one trap
The mock-up's text is garbled AI lettering - copy its LAYOUT (corners, sizes, colours), never its words.
