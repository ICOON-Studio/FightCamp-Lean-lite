# S126 digest - the jab lunge's root cause, an honest fist-speed row, and a push box for the guard glove (Claude, 2026-09-29)

**S126 in one line:** the RamsterZ jab's post-contact lunge was a TIMING bug, not a pose - the strike warp called 2/3 extension
"contact"; fixed at the root plus a 5.75 deg Spine lean-back solved by target; the gate's fist band now measures the STRIKE (it
had passed the jab on its recovery); a 6 cm arm-vs-arm push box + a 3 mm head clear remove the one_two guard-glove pop and make
the live room's overlap BETTER than master. Boxing **9 -> 14/36** under G147.

Nightly to cite: 2026-09-29 at 9b143308 - SUITE total=459 fails=20 (14 real, routed U198 / Q216b / KM3). No 09-30 run yet.

## 1. The jab lunge (S125 held the jab family on it)
- `tools/s126_jab_lunge_solve.gd` probe (skeleton space, 4 generated legal rigs, identical there): head -8 cm (wind-up) -> +9 cm at
  0.50-0.55 s, i.e. ~12 cm forward AFTER the room's contact at 0.317 s. Hips 0 (root held).
- ROOT CAUSE (per-frame glove trace, `trace_hand`): the glove met the head at 0.22 s and the room's pin held it there to 0.33 s while
  the source arm kept extending to full reach (~source 0.335 s); on release the glove went +8 cm at 5.4 m/s. The binding's
  strike_warp span ended at source 0.25 s and that end IS the contact time (FightClipRetarget meta contact_s) - two-thirds of the jab.
- AND the C223 fist-speed row read the whole-clip peak: S125's jab/up_jab "passed" on 5.5-6.4 m/s measured at 0.45 s, after impact.
  The strike alone was 4.1-4.6 m/s (band 4.5-9.5). Only the jab family peaked after impact (checked every S125 row).
- FIX: warp span to full extension `{"from_s":0.2,"to_s":0.335,"scale":1.5,"pre":{0..0.2 x0.6}}` (glove after contact ~1 cm, was 8),
  + a Spine z 5.75 deg lean-back from contact (solved by target: head <= its contact position; 1.7 cm after contact). On this
  retargeted skeleton the trunk PITCH is local z (x ~ twist) - axis probe in the solver (`try=`). Earlier solves that cancelled
  (Hips -26/Chest +24; Spine -76/Chest +79) were rejected as unauthorable. Source bound: MOVE_SCRIPT_BOXING (n=31 two-man head
  jabs) - thrown mostly in place, hips p90 0.14 T (~7 cm).
- Gate: fist band = peak up to impact +1 frame (`strike_peak_m_s`); `warp=a,b,s,pre_from,pre_to,pre_scale`; `trace_hand`.
- up_jab: its arm layer from 0.0 changed the entry velocity, the phase match took the bouncing idle at 0.317 s and the lead toe slid
  2.5 cm (welter_b). Layer now starts at 0.05 s -> same entry as the jab (1.45 s), slip 0.

## 2. The guard-glove pin (one_two)
- one_two failed on the receiver's guard forearm vs the cross: welter_b pin pop 427 m/s2 at first contact, heavy_c ARM 3.07 cm x 6 f.
- A per-frame ENGAGE RAMP was tried and REJECTED: it traded pops for depth (4-6 cm) and starved the head pass - live room
  fight_body_overlap 28.9 mm head>arm. Removed entirely; FightStagePlayer is unchanged.
- KEPT: `FightContactSolve.PUSH_SKIN_M` 0.06 - arm-vs-arm pairs keep 6 cm apart (a push box, G147), so the guard gives way as the
  punch approaches; arm-vs-head/body pairs have no skin (landing gloves still touch). 3 cm was worse (heavy_c 3.44 cm x 5 f).
- KEPT: `HEAD_CLEAR_M` 0.003 - the head pass (room + Q213 pin_gloves, the same code) cleared only > 1 cm, so a moved glove could rest
  1 cm in a head.
- Control table, fight_body_overlap (live MMA room seed 810039, worst penetration): master 3.4 mm | ramp only 8.2 | skin only 9.0 |
  skin+ramp 28.9 | **skin + 3 mm head clear 2.7 mm hand>head, head>arm 0** (shipped; the test stays red - allowance 0, U198's).

## Results
Final pin (6 cm skin + 3 mm head clear), production gate `plant phase live_contact bound`, 4 generated legal pairs,
`docs/previews/c223/s126_final_bound.json` (errors 0): **every S125-certified move still 4/4** (cross, rear_uppercut, jab_body,
body_hook, overhand, cross_body, pieces slip / pull / catch) + **jab 4/4 and up_jab 4/4** (strike 6.5-8.7 m/s up to impact, onset
267 ms, 0 slip, 0 pops). reference_jab (the raw RamsterZ control, 16 m/s) pops on 3 rigs as before - it is the control.
Chains, sequence gate `bound live_contact certificates=s126_final_bound.json` -> `s126_final_chains.json` (errors 0): **one_two,
double_jab, slip_counter, pull_counter, counter_over_jab, catch_counter all 4/4**.
Stills (game 35 deg + side 90 deg, welter_a): s126game_/s126side_ owned_jab + boxing_up_jab - the jab lands straight with the head
held back and is at guard by 0.567 s (S125's stacked heads at 0.45-0.60 s are gone); the up-jab's glove drops to chest height at
0.1 s and rises into the head line.
**Boxing 14/36 certified:** jab, cross, rear_uppercut, jab_body, body_hook, up_jab, overhand, cross_body, double_jab, one_two,
slip_counter, pull_counter, counter_over_jab, catch_counter. Open: close-range 6 (Q217), check_hook, counter_combination,
footwork 7, feint, drawing, 3+ part combos. Kickboxing 0/20 (not on the demo road - D27).

## Tests (tier: scripts edited; full suite is the nightly)
Parse gate on every touched file. fight_contact_stop 1/0, q213_clip_gate_contract 1/0, fight_contact_solve 1/0,
fight_body_overlap TOTAL=2 fails=1 (as master; worst 2.7 mm vs master 3.4 mm).

## Collected / decided
- Q217 (Qwen) part 2: lead_uppercut reads right from the game camera but has NO side still and the rear glove drops to the hip at
  contact; inside_uppercut HELD (side still 0.367 s: rear arm flung behind the hip, back turned). Hooks 4/4 blocked on G147 -> re-run
  on the new pin first. Send-back AgentComms/prompts/Q217c.txt. Spacing 0.83-0.91 m is inside POCKET 1.07 m (not moved apart).
- U198 (Cursor) send-back 1 (da2cd445): kept the time-scaled cap + order; misses its bar (overlap 4.3 mm vs master 2-3 mm;
  room_positions not run) -> send-back 2 AgentComms/prompts/U198c.txt on the new master control.
- Operator questions answered with notes: S126_ANIMGEN_EVALUATION.md (UE 5.8 AnimGen: not for the demo road),
  S126_SPACE_BUNNY_NOTE.md (stealth LLM: not now).

## Next (S127)
OPERATOR WORKING BRIEF (2026-09-29, memory feedback_working_brief_2026-09-29; DECISION_LEDGER D27): demo .exe by 2026-10-06 with the
boxer's palette restricted to CERTIFIED moves. S127 does, in order: (1) the PALETTE RESTRICTION - a certified-id list checked in
FightMoves `_knows` for boxing (decide footwork/defence: the room's movement and defence roles are not thrown techniques), with a test
that a boxing bout emits only certified ids; then `build_playable.py` and the career walked in the .exe; (2) SHRINK THE RULES
(CLAUDE.md one page, RULES_HISTORY.md, `start` ~150 lines, MEMORY.md < 150 lines, no gate weakened); (3) collect Q217 part 3 and
U198 send-back 2 the session they land.
