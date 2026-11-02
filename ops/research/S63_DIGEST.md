# S63 digest - THE PAIRED HOLDS' GRIPS HOLD IN THE LIVE GAME (Claude, 2026-09-24)

## The finding the stage was opened for
C168 (Codex) built a graft-time grip solve - a two-bone arm IK baked into the grafted clip that keeps
the SOURCE clip's hand-to-anchor offset, rotating only the arm's own bones, never a root. It was gated
on `pair_key_name in ["bjj_side_control", "bjj_half_guard"]`. The probe and the tests pass the BINDING
id and saw it run; **the live room grafts with `meta["pair_key"]` = `"Cascy_SideControl"`, so the grip
solve had never run in the game.** Every in-game grip was the raw retarget. Measured on the live key
with the solve OFF: side control's `vic_lhand_to_att_neck` drifts **133%**.

## What shipped (952762dd, 33546623, merges 05ed5c20 / 1398acf1 / U152)
- `PairedStagePlayer.HOLD_GRIPS`: one grip table for all 11 authored holds, keyed by the CLIP'S OWN
  pair name (read off the att path), plus `grips_for(key, att_path, solve)` and `set_contact_solve`.
  OFF = S62 byte for byte, defect included (the control arm). With the solve ON a hold whose grip bone
  is missing still plays and reports why in `graft["contacts"]`; OFF keeps S62's refusal.
- `FightClipRetarget.preserve_pair_contacts` / `_contact_arm`: the chain is read off the EFFECTOR - a
  hand moves the arm, a FOOT moves the leg - and an optional 4th field names the anchor's body, so the
  closed guard's crossed ankles (a same-body contact) are a row like any other.
- Room switch `pair_grip_solve` (default ON). NOT `contact_solve`, which is S4a's glove push.
- `FightPoseSolver.refine_hands` + `W_HANDS`: `refine` with the roots frozen; the header now lists the
  full public API and states "hands yield first" as a number (root write 0, hand write != 0).
- `s31_contact_probe.gd`: `--live-key` (graft as the room does) and `--grip-solve-off`; prints `S63GRIPS`.
- `Tools/clip_status.py record` refuses `--arm-error` without `--arm-pair` (the headline had tracked a
  fixed pair while another pair set the number).

## The numbers (probe, live key, f01 welter 1.78 m vs f02 heavy 1.88 m, Cascadeur holds from
## combat bindings; worst contact drift vs the source clip, 241 samples; OFF = S62, ON = S63)
| hold | OFF | ON | note |
|---|---|---|---|
| side control | 133% (vic_lhand_to_att_neck) | 2% | the live-path defect |
| closed guard ankle lock | 23.8% | 0.0003% | leg chain, same-body row |
| mount bottom frames | 18.7% | 0.0001% | worst row now knee flank 9.1% (unsolved) |
| turtle (old clip) | 11.2% | 0.0001% | |
| dirty boxing | 15% (att_lhand_to_vic_neck) | 11% (vic_rhand_to_att_larm) | the 34% on record did not reproduce: that row read 13% OFF |
unreachable = 0 on every hold. Solved rows read ~0% BY CONSTRUCTION (the solve targets the offset the
probe compares against) - the evidence is the OFF column, the unsolved rows (unchanged) and the sheets.
U152 (Cursor, blind contract, 4/4 mutants): on bjj_mount with the roots frozen both grips reach
`grip_max=0.006 m` (<= 0.012) with `root_moved=0.000` - the hands-yield result U151 could not get.

## Gates
- Focused 18/0 (c168, c169, paired_stage, fight_grapple*, fight_room_no_teleport, fight_world*,
  paired_clip, hold_binding, lean_survives, pose_solver*, pair_schedule, beat_grapple).
- u145 arm A, seed 94301: jumps boxing 0 / MMA 4 (ceilings 5/8); longest >3 cm overlap run boxing
  **0.200 s**, MMA **0.150 s** - ABOVE the 0.10 budget and above S62's 0.100 / 0.083. **CONTROL ARM
  (S63's three engine files reverted, same run): identical, 522/0.200 and 426/0.150.** S63 does not
  move it; the rise came from something landed after S62's measurement. OPEN, not S63's.
- Full suite (--jobs 2, read off the run at the U152 merge): **`SUITE total=375 fails=9`** - exactly the nine
  documented reds (athlete_development, capsule_coverage_contract, fight_body_overlap, fight_metres [--jobs
  hang, passes alone], fight_pair_live [PARKED], fight_scoring, fight_stage_realism,
  fighter_reachability_contract, weight_cut). S62 read 375/12; its three floor-caused reds are gone.

## Collected this session
Q161 (Qwen: render_paired_hold resolves RamsterZ .fbx pairs, all 8 rendered, none lie - its "high view
shows a standing clinch" rows are overhead shots of the same ground hold, misread; Cascadeur keys now
take the table's clip window, so NOT byte-identical as it claimed), U152 (Cursor), C182 (Codex: turtle
re-authored from a checked still, 0.25 of 3 credits; bottom man on knees AND elbows, spine rounded -
ADMITTED with hands solved, chest-on-back 42% open (a body-placement contact no hand solve fixes);
closed guard re-probed: ankle passes, wrist peaks 33% - rejected), G84 (Grok: grips per hold - the
C170 wrist-to-wrist grip is the named animator miss), D16 (Dola: four leg DOFs, knee-first yield; her
MEASURED labels carry no citation -> D17). D9 closed as LOST (both "restorations" contradict the record).

## Operator threads
Ops board: 60 s refresh paused while reading, folds remembered, long text behind more/less (~200k ->
~8k chars). Own character creator: Reallusion's EULA bans shipping a generator and copying its morphs;
plan = open base (MakeHuman/MPFB2; J45 VERIFIED the assets CC0) as Godot blend shapes; G85 (Grok) is the
second opinion; a build is a new stage awaiting the operator's go.

## Operator decisions this session (verbatim, do not re-ask)
- 'go with S64 and the watch loop', then the SPLIT: 'can the other agents work on the engine and motion and
  we focus management and gui' - YES. Agents own engine + motion; Claude owns management + GUI (S64 = play
  the career loop, screenshots to the operator, build Kalli's FLOW_PASS4_CUTOVER toward stage D) and
  integrates agent branches and relays their videos.
- Grok Bot (John/Kalli/Maria) weekly usage at 98%, resets ~2026-09-25: no new bot work until then.
- J45 (John): MakeHuman/MPFB2 assets are CC0 and shippable in a closed game; their code (AGPL/GPLv3) is not;
  SMPL blocked. Own creator = a later stage on the operator's go.

## Handed on
C183 (Codex: closed guard re-authored to overhook + head cup), U154 (Cursor: the overlap regression),
then U153 (live-room grip witness), Q163 (Qwen: RamsterZ source units - Q162's 'same position' is a probable
x10 unit mismatch; Q162 merged, conclusion rejected), G85 (Grok: creator licences),
D17 (Dola: cite the leg limits). The u145 overlap rise needs a bisect between S62 and S63.
