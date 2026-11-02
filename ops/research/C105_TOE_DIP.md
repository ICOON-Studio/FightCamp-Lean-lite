## DECISIONS

- baseline: NOT REPRODUCED; the room uses the live beat scheduler and this isolated replay differs in its transition setup.
- Variants keeping the toe above -0.0263 m: baseline, previous_still_playing, blend_0, blend_0_20, deterministic_true, deterministic_false.
- Room rows identify the leg chain by the local-rotation jumps; the mechanism is INFERENCE: a one-frame AnimationPlayer crossfade pose between outgoing and incoming bone rotations.

## MEASUREMENTS

The room stepped 2442 frames and recorded 20 dip rows (seed 51227).

The complete per-frame reproduction heights and room rows are in `C105_toe_dip.json`.
