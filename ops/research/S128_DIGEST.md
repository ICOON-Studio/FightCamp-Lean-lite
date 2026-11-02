# S128 digest - QuickMagic text-to-motion (check hook), reach measured (active but too weak) (Claude, 2026-09-29)

Nightly to cite: 2026-09-29 at 9b143308 - SUITE total=459 fails=20 (no newer run).

## 1. Text-to-motion, again - on the right moves this time
Operator: "why dont you try text to animation ?" Record (C221 pass 2, primary): 47 Kimodo text-to-motion takes, all rejected
on the physical gate on both rigs - BJJ/sambo floor transitions, capoeira inversions, combos, BEFORE the S120-S127 pipeline
(strike warp + pre span, pose layers, foot-plant bake, phase-matched guard). Standing single-body boxing moves are the easy case.
- QuickMagic Text to Motion (no upload needed - Claude runs it): prompt = orthodox check hook (compact left hook, ~45 deg
  pivot on the lead foot, rear glove at the chin, back to guard), V1.0 model, 4 s, Mixamo export, Foot Sliding Fix ON:
  **8 credits** (the fix doubles it; 183 left). Downloaded with the operator's OK -> `D:/FightCamp/sources/quickmagic/check_hook_v1/`
  (SHA-256 in `assets/anim/c223/mixamo_pipeline_a/SOURCE.md`, a new QuickMagic section) -> `tools/c223_mixamo_adapter.gd`
  (22 bones, 4.0 s) -> `QM_Check_Hook_v1(.glb/_rest.glb)`.
- Gate: take `qm_check_hook`; boxing_check_hook gets the hook bands (8-14 m/s, 132-657 ms) and the pivot rule (LeftToes planted,
  RightToes swings) - without bands it would have passed vacuously.
- Raw (s128_qm_check_hook_a.json, 4 rigs, 46 s parallel): G147 clean, 0 pops, but strike 2.9-3.8 m/s, onset 900 ms, contact
  scored before full reach. Hand trace: guard 0-0.8 s, hook 0.82-1.15 s (full reach), 2.5 s guard tail.
- Warp `0.8,1.15,0.35 + pre 0-0.8 x0.4` (s128_qm_ch_probe.json, welter_a): **strike 8.46 m/s, onset 383 ms, target line PASS,
  G147 PASS**. Left: the body FLOATS ~12 cm for the whole move (toes 141 cm vs a certified Mixamo clip's 128-129 on the same
  deck; frame 0 is on the floor, lifted by 0.2 s), so no foot contact registers (pivot/contact rows), and 1 pin pop.
  NEXT: fix the float at the source in QuickMagic's Motion Editor (operator's suggestion) or a Hips drop layer; then 4 rigs +
  stills -> certify -> palette 16.

## 2. Reach (operator: "i want the reach to play an active role on the fight ... a distinct variable for each fighter")
- IMPLEMENTED and per fighter: TaleOfTape.migrate_athlete gives every generated fighter a height (by class) and reach =
  height -6..+10 cm (id-stable); featured real fighters carry their real numbers. The engine uses it: range bands in each man's
  own arm length (FightMoves.band_for / scaled_distance), preferred range grows with reach (FightIntent.preferred_range), the
  shorter man must close (contested_range, reach-deficit bump), defence bands use the target's reach; Tale of the Tape prints it.
- MEASURED (tools/s128_reach_swap_probe.gd; Outside Technician vs Pressure Puncher, differentiated; boxing, game switches;
  40 seeds per arm; the SAME two men with reaches 192/170 then swapped): technician wins 27 -> 24 of 40; stoppages 3 -> 8;
  landed 1764/1575 -> 1587/1483. A 22 cm (8.7 in) edge moves the win share ~4 points each way - inside the noise at n=40.
- SOURCED TARGET (J33_WHAT_THE_SPORT_MEASURES.md, Fightnomics + FightAlpha, UFC): a >=6.5 in edge -> the longer man wins ~2/3;
  6 in+ replication 59.4% (596 fights); accentuated when >70% standing (~74%). Boxing is all standing. Ours is ~2-4x TOO WEAK.
- GAP 2: the 3D bodies scale by HEIGHT only - arm length does not follow reach, so a +10 cm ape index is invisible.
-> queued RC1 (engine calibration to the sourced effect, n>=200 per arm, both arms reported) and RC2 (arm length from reach
   in the body builder) - see roadmap queue.

## Collected / decided
- QuickMagic video-to-motion = single-performer tool (S127 s6); text-to-motion = the route for boxing moves with no source.
- The operator named QuickMagic's Motion Editor for adjustments - use it for the float before patching in our pipeline.

## Next (S129)
(1) Float fix for QM_Check_Hook (Motion Editor, re-export) -> 4 rigs + stills -> certify -> palette 16 -> rebuild .exe.
(2) RC1 reach calibration (Qwen or Claude). (3) Hooks: foot placement (S127 s6). (4) More QuickMagic text-to-motion for the
footwork steps and feint (the stated D27 exception).
