# TASK LUDO-DOC2 - the doctor in the LIVE fight: cuts in pips, the inspection, towel or wave on, the scar (V15 / D42; Ludo round-8 #3)

Model: Codex gpt-6.1-sol (CODEX_MODEL=gpt-6.1-sol - engine work). Worktree E:/FightCamp/wt/LUDODOC2, branch codex/ludo-doc2 from master.
Push the branch; never master. Never open a window, image viewer or browser. Godot windowed only via Tools\godot_hidden.ps1 (hidden
desktop); look at stills with your file tool.

## Owned files
- `Godot/scripts/FightRealtime.gd` (8,500 lines - NEVER read whole; windows below)
- `Godot/scripts/FightWorldLiveScreen.gd` (6,200 lines - windows only): the doctor overlay + the choice, pause/resume of the presented clock
- `Godot/scripts/LudoDoctorOverlay.gd` (NEW, Control) - the inspection card: the eye, the pip level, the stoppage odds, TOWEL / WAVE HIM ON
- `Godot/scripts/GameState.gd` (17,800+ lines - windows only): write the scar to the fighter after the bout (find the post-fight result
  write: grep `apply_fight_result` / `_record_bout` / `traits`)
- `Godot/tests/doctor_live_test.gd` (NEW, engine), `Godot/tests/ludo_doctor_overlay_test.gd` (NEW, UI)
- `Godot/tools/doctor_still.gd` (NEW) + `previews/doc2/*.png`

## Prior research
- The pure rules (merged): `Godot/scripts/CutsDoctor.gd` + `Godot/assets/data/cuts_doctor.json` - USE THEM, never re-derive a number.
  Design of record: `research/LUDO_DOCTOR_S191.md` (Ludo round 7, verbatim) and D42.
- Ludo's acceptance (round 8, `LUDO_ROUND8_NEXT_S191.md`): "In Round 3 at 3+ cut pips, the ref waves time out, a ringside doctor overlay
  pops up with stoppage odds, and choosing Wave Him On finishes the bout while branding Leo's post-fight sheet with Cut-Prone Scar (Level 1)."
- TODAY'S engine: `_maybe_doctor_stoppage` ~3464 (S97: the eye shut at MAX_PIPS stops it - PitStop.chips eyes == "doctor"), called at the
  rest minute ~2599; corner towel `throw_towel` ~2793 and Q184 corner stoppage ~3480; the limb-damage trauma pips live in
  `CornerPitStop.gd` (`pips_at`, `_set_pips`, `chips`) - read how a cut is stored today before adding anything.
- The towel the HUD already throws: `FightWorldLiveScreen._on_ludo_towel` (LUDO-HUD1).
- Boxing EA has no dirty fighting: CutsDoctor's elbow/thumb row stays disabled.

## What would a human do?
Keep ONE cut model: express the existing trauma pips on the 0-5 scale CutsDoctor uses, let the doctor rules decide when he looks and
whether he stops it, pause the fight for the player's choice, and write the scar into the career when the bout ends.

## Spec
1. Switch `ludo_doctor`, default OFF in `--script`, NOT in DEMO_SWITCHES yet (the operator turns it on after the stills).
2. ON, boxing only: a cut opens/worsens through CutsDoctor.open_chance / worsen on the engine's clean head shots (clinch clash + hooks;
   jab/cross +0.5); the per-brow pips live where the trauma pips live today (one model). Every change logs {type: "cut", side, brow, pips}.
3. ON: after a clean shot to a 3+ pip brow (and at the bell) roll CutsDoctor.doctor_call_chance with the ENGINE's RNG (draw only when ON);
   4+ pips = mandatory look at the break; 5 = instant stop. On a call: log {type: "doctor_call", ...}; roll stoppage_chance with the
   cutman actions already spent this bout (swab/coagulant from the corner, if LUDO-CORNER2 is not in yet treat as none) -> stop (TKO,
   cause "doctor") or continue.
4. ON, continue: the engine PAUSES for a decision (a state flag the screen reads; headless tests resolve it by option
   `doctor_choice: "towel"|"wave_on"`). TOWEL -> CutsDoctor.towel(): RTD loss, purse 150 recorded, eye heals. WAVE ON -> CutsDoctor.wave_on
   at the final bell: scar_level from the pips at the bell.
5. Screen: LudoDoctorOverlay shows the brow, the pip level (0-5 icons), the stoppage odds in words + percent, and two buttons TOWEL /
   WAVE HIM ON (UIKit tips); the presented clock holds while it is open (like `corner_holds_clock`).
6. Career: after the bout GameState gives the fighter trait "Cut-Prone Scar (Level N)" + `scar: {brow, level, months_clean: 0}`; the
   fighter sheet shows it (find where traits render; one line + icon + tip).
7. OFF arm BYTE-IDENTICAL: same seed with ludo_doctor OFF -> the round-log hash of master (capture it from master BEFORE your change).

## Done = (tier: script edited - parse, focused tests, related runs)
- Parse gate on every touched .gd.
- `doctor_live_test.gd` (2 DIFFERENT boxers - one a cut-seeking slugger like Ray Miller from ludo_cast.json, one Leo-like; 8 seeds):
  ON -> cut entries appear, pips 0-5, a 5-pip cut stops the fight, a 3-4 pip doctor call either stops (cause doctor) or pauses;
  doctor_choice towel -> loss RTD + purse 150; wave_on finishing at 4 pips -> scar_level 2; OFF -> no cut/doctor entries and master's
  log hash. Write it RED first on master (paste the count).
- `ludo_doctor_overlay_test.gd`: both buttons have UIKit tips, the odds label matches CutsDoctor for 3/4 pips +/- swab, nothing clips at
  1920x1080 / 1280x720.
- `python Godot/tools/run_tests.py --only fight_realtime --jobs 2`, `--only corner --jobs 2`, `--only cuts_doctor --jobs 2` -> no NEW
  failures (name any that fail on master too).
- STILLS through `Godot/tools/still_framing.gd` `save_if_framed` (game camera; both men head to feet, or it refuses):
  `doctor_still.gd -- as_game ludo_doctor` -> `01_doctor_overlay.png` (the inspection open) and `02_scar_sheet.png` (the fighter sheet
  after a wave-on win with the scar line). Open both with your file tool.
Commit + push codex/ludo-doc2. Final message: red count, green results, OFF-arm hash proof, the two stills.

## The one trap
Two cut models would disagree on screen - the corner's chips and the doctor must read the SAME pips. Extend the existing trauma pips;
never add a parallel "bleed" counter.
