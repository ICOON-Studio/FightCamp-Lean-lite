# U42 DIGEST — audit a clip before we pay for it

## What landed
- `FightClipAudit.gd` — `audit`, `summarise`, `disagrees_with_name`
- `fight_clip_audit_test.gd` — real asset on disk
- No edits to Slice / Mirror / Binding / Director

## Known asset (combo_jab_cross_hook.glb)
windows=3 hands=RightHand×3 alternates=**false** moves_bones=22/22 unmatched=0
kind=`single_hand_drill`
summarise: `2.47s | moved 22 bones | unmatched 0 | 3 punches R-R-R (no-alternation) | kind=single_hand_drill`
disagreement: *name promises alternating hands (combo_jab_cross_hook); clip uses one hand only (R-R-R)*

## Name vocabulary (deliberately dumb)
Recognises: punch tokens `jab/cross/hook/uppercut/punch/strike`; combo `combo/combination`; loco `idle/walk/run/jog/locomotion/cycle/stance`; reaction `reaction/hit/hurt/flinch/block/guard/slip/duck/knockdown/kd/down/getup/get_up`.
Anything else → **`cannot check`**, never a silent pass.

## Kind / no-punches trap
`kind` ∈ `empty|inert|no_punches|single_punch|alternating_combo|single_hand_drill`.
`walk_relaxed` + 0 windows → empty disagreements (no punches is fine). A tool that treated 0 windows as broken would fail every loco/reaction buy.

## Gate
own 16/0; slice 22/0; mirror 45/0; world 5/0.
