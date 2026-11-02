# S155 digest - GLOVES fixed and OK'd by the operator; Q213G briefed; NIGHTLY1 on Cline (Claude Opus 5.5, 2026-10-03)

**In one line:** the operator named two glove defects at the end of S154 and both were one root cause, found by rendering
the glove from four sides: the Sketchfab mesh is a LEFT glove that C241 read as a right one, so both hands wore the
wrong-handed glove and the hand's thumb side and palm heel stuck out through the narrow side. Fixed at the source, proven
with stills and a test that goes red on the old code; the operator: **"Yes, gloves are right"**.

## Operator rulings (S155, verbatim option picks)
- Gloves after the fix (before/after board + uppercut clip): **"Yes, gloves are right"**. GLOVES closed.
- The 3 palette moves the honest skin gate fails (lead_uppercut 3.85, rear_hook 1.56, rear_hook_body 3.63 cm): **"Fix their
  clips first"** (not withdraw, not ship as is). -> Q213G, brief `TASK_Q213G_GLOVE_SIZED_CONTACT.md`; the 3 stay in the palette.
- MetaHuman staff (STAFF1b portrait): **"Not yet, keep OFF"**. Owed before asking again: the coach's hands vanish into the
  shorts line; everyone is barefoot (no shoes in the Creator wardrobe).

## GLOVES - what was wrong, what changed (ff134b75)
- Evidence the mesh is a left glove: slices of `boxing_glove.glb` across the lower fist (0.02-0.04 m past the wrist) bulge
  to -0.063 m on glove -X vs +0.045 on +X; glove +X is the INDEX side of `_pose_glove`'s frame on both hands (X = index
  knuckle - little knuckle). Render from glove +X showed the hand's own thumb edge outside the glove and the lobe on the far
  side. The build script's docstring ("thumb lobe lands on Godot +X/+Z") was wrong.
- `CCFighterSkin._build_glove`: for the one-mesh boxing glove the right hand mirrors X, the left takes the mesh turned half a
  turn about Y (X and Z flipped). MMA / mitt meshes keep the old rule (separate procedural builds, not judged).
- Cover: the MPFB palm is wider than the glove's waist. `hide_hand_meshes` now runs on finger-frame rigs too (finger bones
  count as hand) and its mesh copy keeps blend shapes, their values and the 8-weight flag (the old copy dropped them, which
  is why it was Tripo-only). The Tripo path gets the same handedness fix (same frame convention, same mesh).
- Proof: 1920x1080 stills, every glove from thumb/pinky/palm/back/front, solid and see-through, MPFB man, MPFB woman, the
  `as_game` live room and the OFF-arm Tripo room - all opened. Board: `docs/previews/gloves_s155/S155_gloves_before_after.jpg`.
  Tool: `tools/gloves_s155_stills.gd` (`mpfb`, `female`, `keep`, `as_game`). Uppercut clip re-rendered and sent (silent).
- Test: `tests/glove_handedness_test.gd` 16/0 - lobe side read from the posed glove vertices against the knuckle line (man +
  woman, both hands), no drawn body triangle on a finger-skinned vertex, blend shapes equal to a bare-handed control.
  Mutants: C241 mirror -> 4 FAIL; no cut -> 2 FAIL; C241 cut (no blend shapes) -> 2 FAIL. Two earlier instrument versions
  were blind (wrist->thumb line measured the palm lean; a dropped blend-value restore is not a failure mode in Godot 4.7) -
  caught by mutants, fixed before commit.
- `run_tests --only glove,cc_skin,mh2_bodies,fight_world_ --jobs 3`: 10/11; the 11th was fighter_gloves_both_corners (below).

## fighter_gloves_both_corners_test (nightly "hang")
Measured alone: not a load loop. Each live room takes ~75-100 s to set up (13 rooms) and the test called `queue_free()`
without ever yielding a frame, so all 15 rooms stayed in memory and the process died after the 15th with no TOTAL line.
Fix: free each room before the next (`_free_room`). RESULT alone: rc 0, TOTAL=22 fails=0 in 1286 s (Cline running
beside it) - over the 600 s default, so `run_tests.py` SLOW_TEST_TIMEOUT_S gets 1930 s (one measured pass x1.5, comment beside it).
COLLECT NOTE: Cline's NIGHTLY1 owns that same dict line for its own tests - merge by hand, keep both entries.
After the first room the clip cache works; the "Reading less data than requested" lines are the FBX importer's warning
(~2 uncached `build_silhouette_corrections` loads a room). The real cost is live-room setup time - NIGHTLY1's question.

## Found, not fixed (named)
- OFF arm only (tests' control, not the game): `f01_m_box_welter` claims painted gloves (`_box_` in the path) but its hands
  render as bare fists with red knuckles (`mesh_has_painted_gloves` trusts the file name). f02-f04 `_box_` likely the same.
  The game (`skin=generator`) never uses them. Left alone to keep the control arm byte-identical; backlog.
- Q213 instrument: the gate measures the BARE body mesh (no glove mounted) while the game draws a glove and no hand - the
  glove probably reads worse. Q213G step 1.

## Agents
- NIGHTLY1 RUNNING on Cline (17:33, wt E:/FightCamp/wt/CLINE, branch cline/nightly1, out E:/FightCamp/wt/CLINE_NIGHTLY1_out.txt):
  readable_onset, asset_manifest, 4 flip-hangs. Cline's free model ends 2026-10-05. Collect: diff vs master, check_workflow.
- STAFF1/STAFF1b: collected in S154 (b5a41332); `start`'s "in flight" flag for codex/staff1 was Godot import files in that
  worktree, no process.

## Next (decision)
Q213G (Claude, or Cline after NIGHTLY1): instrument first - the glove as drawn against the head - then glove-sized hand
volume for the existing push/pin, then a lean-back key only if needed; video to the operator. Then STAFF1c (coach hands,
shoes), TUT1 slice 3, exe rebuild + as_game walk.
