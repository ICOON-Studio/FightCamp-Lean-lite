# S129 digest - reach plays a role, the check hook and the lead hook certified (palette 17) (Claude, 2026-09-29)

Nightly to cite: 2026-09-29 at 9b143308 - SUITE total=459 fails=20 (no newer run).

## 1. RC1 - reach plays an active role (operator: "i want the reach to play an active role on the fight")
- WHY IT WAS WEAK (read in FightRealtime): the strike gate is ONE shared range (`_strike_range_m`, 2.11 m in boxing) for both men,
  and the contact ladder never read reach - so at any gap the short man hit back exactly as well. Mean standing gap 1.15 m, far
  inside 2.11 m: scaling that gate by reach would change nothing (measured before choosing).
- THE MECHANISM: outside the pocket (the gap in the pair's mean arm is MID or LONG), the thrower's contact ladder is scaled by the
  reach ratio ^ `REACH_EDGE_EXP` (`FightRealtime.reach_fit`, switch `reach_edge`, ON in DEMO_SWITCHES). Inside the pocket 1.0; equal
  reach exactly 1.0 at every gap; no draw (OFF byte-identical).
- THE INSTRUMENT: `Tools/reach_census.py` + `tools/s129_reach_census.gd` - 4 differentiated boxing pairs (technician/presser,
  counter/volume, slugger/boxer-puncher, swarmer/stylist), each fought with the long reach on EACH side (the swap cancels the
  pair's skill edge), 50 seeds x 2 sides x 4 pairs = n=400 per arm, sharded (~105 s). Prints the longer man's win share (Wilson 95%).
- CALIBRATION at 8.7 in (22 cm), exponent swept: OFF 54.2% | 0.5 59.0 | 0.75 67.4 | **1.0 69.9 [65.2-74.2]** | 2 83.8 | 3 92.2 | 4 95.8.
  Chosen **1.0** (the ratio itself - a man with 13% longer arms lands 13% more at range).
- AT 1.0, against J33 Q6 (>=6.5 in ~2/3 Fightnomics; 6 in+ 59.4% FightAlpha n=596; <2 in 49.9%; ~74% mostly standing):
  | arm | longer man wins | landed long/short | sourced |
  |---|---|---|---|
  | boxing 6.5 in (16.5 cm) | 65.8% [61.0-70.2] | 1.14 | ~66.7% |
  | boxing 8.7 in (22 cm) | 69.9% [65.2-74.2] | 1.22 | 66.7-74% |
  | boxing 1.6 in (4 cm) | 54.9% [50.0-59.7] | 1.04 | 49.9% |
  | boxing OFF, 6.5 in | 50.9% [46.0-55.7] | 1.00 | (control: swap cancels skill) |
  | **MMA 6.5 in (NOT tuned)** | **61.6% [56.8-66.3]** | 1.18 | 59.4-66.7% (the data IS UFC) |
  | MMA OFF | 50.5% | 1.01 | control |
  MMA was not used to fit the constant and lands inside the sourced UFC band, lower than boxing - the "nullified on the ground,
  accentuated standing" shape falls out on its own. Stoppage rates unchanged (boxing 15-17%). Rows: `docs/previews/s129_reach/`.
- `tests/fight_reach_edge_test.gd` (0 fails): the law; OFF == key absent byte for byte; CONTROL equal reach ON == OFF; ON lifts the
  longer man's landed share (OFF 0.503 -> ON 0.533); MUTANT exponent 0 reads no lift. The five DEMO_SWITCHES tests pass.
  Commit 23bbf217.

## 2. The QuickMagic check hook - the float was OURS (palette 16)
- PRIMARY SOURCE: the source FBX in Blender - toes 3.6-4.0 cm on all 120 frames. **QuickMagic's export is grounded.** The Motion
  Editor (opened in the operator's Chrome, clip imported, nothing edited) had nothing to fix: no download, no credits spent.
- ROOT CAUSE: QuickMagic writes frame 0's crouch (Hips 0.878 m) into the FBX HIERARCHY and keeps the T-pose (0.998 m) only in the
  skin BIND pose. `c223_mixamo_adapter` saved the hierarchy as the reference ("never frame zero" - asserted, not checked), and the
  hip carry subtracts the reference from every frame -> the crouch cancelled -> 12.0 cm float (the exact rest-vs-crouch difference;
  `tools/s129_rest_probe.gd`, `tools/s129_bind_probe.gd`). Adobe Mixamo exports carry a T-pose hierarchy (1.043 m), so they never
  showed it.
- FIX AT THE SOURCE: the adapter takes a skinned FBX's rest from its BIND pose (what Blender imports as rest), refuses a rest that
  is frame zero or does not stand on the floor, records `rest_source`, and names the right licence (QuickMagic, not Adobe).
- THEN: warp 0.8-1.15 x0.35 squeezed the elbow's end-of-arc jolt (source 1.00-1.13 s) into a pin pop -> **0.8-1.05 x0.30 (pre 0-0.8
  x0.4)** ends the strike span at full extension: 0 pops. Recovery was 2.95 s (QuickMagic pads 2.3 s of guard drift) -> the adapter
  gained `end_s=` (`QM_Check_Hook_v1_t17`, cut at 1.7 s where the glove is back in guard): recovery 0.65 s.
- **CERTIFIED (bound production path, 4/4)**: strike 9.8-11.5 m/s, onset 350 ms, G147 pass, 0 pops, lead foot planted (slip 0.00 cm),
  pivot rule pass. Stills `s129game_/s129side_qm_check_hook_t17_generator_welter_a.png`: hook arc at the head, rear glove at the chin,
  rear heel up, both feet on the canvas. Certificate (re-run on the final tree with the lead hook) `s129_final_bound.json`. Commit 6c844501.

## 3. The lead hook - FOOT LOCK (palette 17)
- Every hook failed G147 on LEG only (s128_hooks_baseline): attacker's lead thigh into the receiver's lead thigh, 5-13 cm. The clips
  STEP the lead foot while `hold_root_xz` holds the hips. A hook pivots on the lead foot.
- NEW: `FightClipFootPlant.lock_foot` - holds one ankle's floor position (XZ) from `from_s`; height and the foot's own rotation stay
  authored (the heel lifts, the ball pivots); two-bone IK; binding key `"foot_lock":{"side":"Left"}`; gate trial arg `foot_lock=`.
- Lead hook with the lock: LEG 6.5-8.3 -> 0.0 cm, BUT the stills showed the S125 defect - no root hold, the torso travelled past
  contact (heads stacked at 0.567 s). With `hold_root_xz` the fist fell to 6.7-7.6 m/s (the lunge was the speed); warp 0.50 gave 9-10 m/s
  but onset 133 ms on the band's 132 edge; **split warp (pre 0-0.2 x0.9, strike 0.2-0.333 x0.40)**: 4/4, every G147 class 0.0 cm, 0 pops,
  strike 10.1-11.9 m/s, onset 167 ms (band 132-657; precedent: cross sits 27 ms over its floor). Stills s129game_/s129side_owned_lead_hook:
  no lunge, feet planted, hook arc at head height. Certificate `s129_final_bound.json` (both moves, final tree, 4/4 each).
- The other three hooks carry the lock (uncertified): rear_hook 11-14 cm and rear_hook_body 5-9 cm unchanged (the KNEE turns in
  with the hips - the ankle is not the problem), shovel 9-11 -> 3-8 cm. -> Q217 part 4 (Qwen), `AgentComms/prompts/Q217d.txt`.

## 4. Defects found and fixed on the way
- **boxing_catch_counter never played**: certified S125 as a sequence (catch -> jab) but missing from
  `FightClipBinding.technique_roles()`; `FightStagePlayer.prepare` registers sequences only for listed roles, so the 3D fight
  had no clip for it. Listed; `fight_clip_alias_test` 276/0 (it was red since S124 - no nightly has run since).
- `certified_palette_test`'s mutant was a NAMED uncertified id (boxing_lead_hook) - stale the day it certified. Now derived:
  the first bound boxing id no certificate proves. 0 fails.
- `fight_clip_load_test`: the QuickMagic glbs were never imported (`--import`, 4 `.import` files). 0 fails.
- **NOT fixed, queued (SW1)**: `fight_strike_whole_test` "OFF boxing events byte-identical to baseline" - hash 5c14146d... vs the
  pinned 96d0c1f3... The SAME hash with the pre-session FightRealtime.gd (swapped in and restored), so S129's reach switch is
  byte-identical OFF; the drift came in S123-S127 (commits touching FightRealtime/FightWorldLiveScreen after 9b143308). Needs a
  bisect to say whether it was intended before anyone re-pins it.

## 5. The .exe and the stoppage rate
- `python Tools/build_playable.py` -> Builds/FightCamp_Godot (pck 426 MB). Walked IN THE EXPORTED BUILD (s64_career_walk +
  s117_boxer_walk.plan, as_game): **83 steps, failures=0; the exe's godot.log 0 SCRIPT ERROR, 0 ERROR**. Live bout on the canvas,
  result "KO R 2 1:07" with cards, plans and the read (docs/previews/s129_exe_walk).
- q212 booked census (120 career bouts per arm, all light heavyweight boxing, the game's own booking path):
  | arm | KO+TKO | draw | KD |
  |---|---|---|---|
  | S127 palette 15 | 37.5% | 5.0% | 18.3% |
  | **S129 palette 17 + reach** | **43.3%** | 5.8% | 25.8% |
  | S129 no palette (control) | 45.8% | 3.3% | 23.3% |
  Back inside the band (40-55, BoxRec ~47) - the hooks were the fix, as S127 said. (Running both arms in parallel collided on
  the census's shared save dir - run them one at a time.)
- The operator was sent `S129_new_hooks.mp4` (both moves, game + side, 1x and 1/3). c223_production_gate `video` renders every
  other recorded frame for it.

## Next (S130)
(1) Collect Q217d (Qwen: rear_hook, rear_hook_body, shovel_hook - the knee turning in with the hips); apply ONLY its diff to the
three hook entries + lock_foot options; re-certify bound 4/4 + stills; palette 18-20; census; rebuild + walk the exe.
(2) SW1: bisect the fight_strike_whole OFF boxing hash drift (9b143308..14b99a99) - intended or a defect - then re-pin with the
commit named. (3) RC2: arm length follows reach in the body builder (acceptance: rendered arm span within 2 cm of reach_cm on 4
generated fighters, stills; re-run the C223 gates after - arm length moves every contact).
