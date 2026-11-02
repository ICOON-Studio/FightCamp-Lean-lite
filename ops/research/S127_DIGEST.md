# S127 digest - the demo palette (certified moves only), the .exe walked, the result screen fixed, the rules on one page (Claude, 2026-09-29)

**S127 in one line:** on the operator's working brief (D27) a boxer now throws and defends ONLY with C223-certified moves
(switch `certified_palette`, ON in the game); the .exe is BUILT and the boxer career was WALKED IN THE EXPORTED .EXE end to
end (83 steps, 0 failures, 0 script errors); the result screen's stoppage round/clock was wrong on the real path and is fixed;
CLAUDE.md is one page, `start` is ~160 lines, MEMORY.md 135 lines.

Nightly to cite: 2026-09-29 at 9b143308 - SUITE total=459 fails=20 (no newer run yet).
Commits: 734224ff (palette), 3e66fc46 + (payload fix) + (plans card) (result screen), 628ae91c (CLAUDE.md), c38a1cb4 (start).

## 1. The demo palette (DECISION_LEDGER D27)
- `assets/data/certified_moves.json`: 14 strikes (jab, cross, rear_uppercut, jab_body, body_hook, up_jab, overhand, cross_body,
  double_jab, one_two, slip_counter, pull_counter, counter_over_jab, catch_counter) + guards slip/pull/catch + the guard idle.
  `FightMoves.restrict_to_certified` at `_seat_palette`; `certified_palette` in `DEMO_SWITCHES` (headless tests OFF = unchanged).
- DECIDED: FEINTS stay (the room shows no feint - engine pacing that banks a throw, S118) and MOVEMENT-ONLY steps stay (the room's
  locomotion - removing them froze the feet under a moving root). The first cut filtered both away: the probe lost 237 feints and
  12 steps a bout. The 7 C223 footwork moves are the ONE stated exception to D27 until they certify.
- `tests/certified_palette_test.gd` (failures=0): every id RE-DERIVED from s126_final_bound/_chains.json (4 rigs), a mutant id
  rejected; 3 seeded bouts (outside jabber 183 cm, every technique learned, vs pressure puncher 176 cm, no record) emit only
  certified ids with feints and steps kept; CONTROL OFF throws uncertified ones (shovel_hook, liver_combo, ...); kickboxing untouched.
- COST, measured (q212 booked census, 120 career bouts per arm, `no_palette` = control): KO+TKO 44.2% -> **37.5%** (band 40-55,
  BoxRec ~47), draws 4.2 -> 5.0%, KD 20.0 -> 18.3%. Cause: no head hooks until Q217 certifies them. NOT tuned around - the hooks
  are the fix.

## 2. The .exe
- `python Tools/build_playable.py` -> `Builds/FightCamp_Godot/FightCamp.exe` (pck 426 MB; `certified_moves.json` is in the pack).
- Walked IN THE EXPORTED BUILD (`FIGHTCAMP_GODOT_EXE=...FightCamp_console.exe`, `--main-pack FightCamp.pck`, s64_career_walk +
  s117_boxer_walk.plan, `as_game`): new career -> sign -> programme -> Move Lab -> floor -> scouting -> staff -> contracts -> book
  -> camp -> fight week -> weigh-in -> fight night -> BOUT LIVE -> sim to result -> RESULT -> home -> next week -> saved.
  **83 steps, failures=0, 0 SCRIPT ERROR** (three times: before and after each result-screen fix). Stills:
  `docs/previews/s127_exe_walk/` (final), dev-tree walk `docs/previews/s127_walk/`.

## 3. The result screen (found by the walk, fixed)
- The walk's KO read "KO · R 1 0:00" and "ROUND 1"; the bout ended in ROUND 2 (the plans card's round-2 read was right). Two
  causes: the panel read rounds COMPLETED and a clock the real-time path never writes, AND `payload_from_sim` dropped the engine's
  stoppage `round` + fight time `t_s` - so the first fix passed its unit test and the exe still read 0:00 ("assert the quantity
  the user sees"). Now `FightResultPanel.ended_round()` (header, headline, result line, empty-cards line) + in-round clock from
  `t_s`; the realtime result carries round/rest seconds. The exe reads **KO · R 2 1:09 / ROUND 2 / "in round 2"**.
- `tests/result_clock_test.gd`: fails 2/4 on the old panel; now drives a REAL engine stoppage through payload_from_sim (seed 701:
  R 3 0:13). Result-panel tests 7/7; fight_beat 7/0, fight_realtime, boxing_output, defence_model pass.
- THE PLANS: a lone corner's plan gets the whole card (its read was clipped mid-number).

## 4. The rules (operator brief item 1)
- CLAUDE.md 694 -> 110 lines; the full old text verbatim in `research/RULES_HISTORY.md`; `decision_ledger.py` still reads it.
- `agent_comms.py start` compact by default (~160 lines; 2,080 with `--full`); every gate prints in both modes;
  test_agent_comms_triage 3/0, _evidence 6/0.
- MEMORY.md 203 -> 135 lines: rule memories -> `feedback_rules_now_in_claude_md`, agent notes -> `reference_agent_notes`,
  S104-S125 session lines -> the session log. No memory file deleted.

## 5. Later in S127 (after the first handover commit)
- **U198 (Cursor) merged** as its diff (7cce20e4): one root coordinator caps root motion per frame; head-overlap correction after
  the late cap. Merged tree: contact_stop, room_no_teleport, room_ring_bounds, footwork_beats_reach_room, body_layers_live,
  boxing_output pass; fight_body_overlap worst **1.8 mm** (master 2.7). fight_room_positions = the pre-existing nightly hang.
- **boxing_lead_uppercut certified** (Q217's layer + a rear glove held at the chin; inside_uppercut's turn-away NOT taken):
  4/4 on master, strike 8.85-9.64 m/s, 0 pin pops, stills s127game_/s127side_. **Palette 15** (certified_moves.json +
  s127_lu_parallel.json). Boxing **15/36**.
- **Compute (operator: "ok do it"):** the gates take `rig=`; `Tools/c223_parallel.py` runs one idle-priority Godot per rig
  and merges the report. lead_uppercut: **serial 156 s -> parallel 44 s, rows identical (0 differing fields)**. The PC was
  waiting, not working (watchdog CPU 4-12% during serial gates). Mini PC / GPU rental: not needed yet.
- **QuickMagic Basic** (operator subscribed 2026-09-29, $14.9/mo, 200 credits, 60 s clips, 2 people, FBX/Mixamo export,
  commercial on paid plans). First test = `_captures/ground_video/mount_gnp_2human_locked.mp4` (two-person mount; the
  unproven link is the video -> 3D solve on bodies in contact). Uploading a local file from this session is refused by the
  harness (exfiltration check) - the OPERATOR uploads; Claude reviews and (with the operator's OK) fetches the FBX, then:
  Mixamo retarget path -> Blender contact cleanup -> the C223 / C222 gates. Grappling GPU rental answered from G95: only
  SAM 3D Body (per person, no contact) needs a CUDA GPU (this PC: AMD RX 6800 XT); SMPL-X contact fitters are licence-barred.
- Rebuilt .exe with U198 + palette 15: BUILD OK, boot 0 script errors.

## 6. First QuickMagic run (QM1) and the hook baseline
- **QuickMagic, mount_gnp_2human_locked.mp4** (operator uploaded; V2.1, 30 fps, full body + hands, Mixamo export, penetration
  prevention OFF - ON triples the cost to 27): **9 credits, ~8 min queue+solve, ONE body** ("Animation - 1"): the TOP man
  (upright/posting - plausible, but squatting on his feet where the video kneels astride). The BOTTOM man, pinned under him,
  was never detected. QuickMagic's own doc: "keep each person visible and avoid prolonged overlap". **Verdict: not a two-body
  ground solver.** Use it for SINGLE-performer clips in clear view - the uncertified BOXING moves (check_hook, footwork steps,
  counter_combination) from a Higgsfield suited-boxer video - and for standing entries before bodies tangle. 191 credits left.
- **Hooks on the push-box master** (`Tools/c223_parallel.py`, 100 s for 4 moves x 4 rigs, s128_hooks_baseline.json): ARM
  clipping is GONE on every hook except rear_hook heavy_d (4.9 cm); **every hook now fails on LEG** (lead_hook 6.5-8.3 cm at a
  1.19-1.29 m gap; rear_hook 10.5-12.7 cm; rear_hook_body 5.2-9.7; shovel_hook 9.1-11.3). Rear_hook also pops the pin on 3 rigs.
  Next is FOOT PLACEMENT (the source clips step the lead foot into the other man's lead leg), not more arm layers.

## Not done / open
- Stoppage rate under the palette (37.5%) until the hooks certify (Q217). Boxing 14/36.
- Q217 part 3 (Qwen) and U198 send-back 2 (Cursor) running - collect when they land.
- The operator's eye on the .exe (taste).

## Next (S128)
Collect Q217 part 3 (hooks on the new pin; the hook that certifies joins `certified_moves.json` the same session with its
certificate, and the census shows the stoppage rate move) and U198 send-back 2; then check_hook, footwork 7 (the stated exception),
feint visibility. Rebuild the .exe after every palette addition.
