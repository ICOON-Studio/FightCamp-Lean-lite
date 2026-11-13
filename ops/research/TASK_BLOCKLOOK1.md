# TASK BLOCKLOOK1 - a blocked punch meets the glove, on a body that looks human (S446 finding; brief to finish next session)

Status: SUPERSEDED - S447-S449 BLOCKLOOK2 and BLOCKLOOK3 (Grok Dev) took the block over.
His words (review board C324/C325, 2026-11-12, markup ops/Feedback/2026-11-12-11): "doesnt even look like a normal human";
"nothing seem to be blocked red fighter misses , blue fighter just holds guard".

## S446 finding (main after the POWER1 merge, 74a910de)
Re-rendered with `tools/block_meet_probe.gd -- shots=<dir>` on the hidden desktop: docs/mockups/s446/block_A_B_jab_after_power1.png.
The picture is UNCHANGED by POWER1 - the probe stands its own pair (GAP 0.80-1.10 m), not the played fight's per-punch distance:
- the blocker (B) leans hard sideways, head tucked into the arm, the high glove ABOVE her head - the block clip `mc_to_block`
  as played (or BlockGloveLift lifting the wrong glove), not a guard that meets a jab;
- the jab lands on her upper arm / chest, under the raised glove: the punch is not met by a glove at all;
- the probe exited rc=1 (read its output before trusting its rows).

## Next
1. Film blocks in the PLAYED fight (a block row in tools/hit_frame_film.gd or fight3d_play), not the probe's staging.
2. Look at `mc_to_block` alone (pose sheet): if the clip itself is the bent body, replace it with a guard-based block
   (a high guard that moves the near glove onto the punch line), not more IK on a bad clip.
3. Seat: Grok Dev (Cursor replaced, S446) for the code; Claude renders and judges the stills.
