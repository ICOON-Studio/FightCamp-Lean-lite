# S269 digest (2026-10-20) - eyelashes, brow cut audit (placement + look), NIGHTLY11 split, Ziva playtest restarted

Operator this session: "whats the url/port for ziva ?"; sent https://www.youtube.com/shorts/ELsXhePjBxI "is this good ?";
"whats up with the colours/textures?" (with a crop of the boxer's eye: white lashes); "did ziva finish the playtest ?".

## Shipped (master)
| commit | what | evidence |
|---|---|---|
| 3d0806ca | Matte MetaHuman eyelashes. The lash cards (no texture, albedo 0.03) are two-sided and stacked; at the default specular 0.5 they summed the ring lights' sheen into a WHITE fringe on every dark face (operator crop) - MetaHumanRig lash material specular 0, roughness 1 | docs/previews/s269_cut/face_guard.png (white) vs s269_lash/face_guard.png (dark); review board |
| 6b5c48e9 | CUTVISIBLE1 r3 collected (Cursor e61f589b) + Claude audit after 3 red look rounds: (1) brow band was 4-7 cm above the eye centre at the midline = mid-forehead, seen edge-on from the broadcast side = a red DOT at the temple -> band 2-4.5 cm, \|x\| 2.8-5.2 cm (outer half of the eye); (2) fighter LEFT is +X (glb hand_l +0.50, foot_l +0.14; the body faces +Z) - CutMark and cut_visible_test had it mirrored; (3) Decal projects along Y - `size` (length, height, depth) put the 4 mm height on the projection axis; (4) drip/swell offsets now along the face's real up, ON the skin (the head bone's axes are not the face's) | cut_visible_test + cut_visible_live_test 2/2 plain and as_game; s269_cut4 stills |
| 543c0a43 | Cut LOOK: r3's rim term was 1 for every pixel past \|v\| 0.1 -> the whole decal box painted neon red (0.92) = a glowing smear; the drip stream was 1/14 of its decal (~0.3 mm) = invisible. Now a dark lens gash (core 0.09 red-black, rim 0.48), a drip that fills its decal, muted swelling, decal 10-13 mm | brow_before_crop.png vs brow_after_crop.png (s269_cut4), review board; tests 2/2 both arms |
| c9fd92b7 + briefs | NIGHTLY11 split 12 -> 3 x 4 tests: the 12-test Cursor run was SIGTERMed at ~26 min (exit 143) with nothing pushed. #282 = 4 hangs, #286 NIGHTLY11B, #287 NIGHTLY11C; each pushes after every test | 3 cloud-agent runs in_progress 23:10Z |

## Found, not fixed (next)
- The broadcast `guard.png` cannot show the cut in that frame: the cut boxer has his back to the camera. The face close-up is the
  honest gate for a cut; the broadcast read needs a camera beat (cutaway / corner close-up), not a bigger decal.
- Forehead: a lighter scalp band across the forehead (head albedo hairline under the brush-cut cards) and dark crack lines on the
  shoulder in face_mid.png (s269_cut4) - texture seams to look at with the HUD/visual round.
- Ziva's ZIVAPLAYTEST1 brief (sent S268 01:06) never started - re-sent 01:43 in the same chat ("ZIVAPLAYTEST1 Instructions
  Clarified"), reasoning MAX; running.

## Decided (developer calls)
- Cut look done by Claude, not a Cursor round 4: Cursor cannot see images and 3 look rounds missed; the defects were a measurement
  bug and a texture-math bug, both visible only on a still.
- HUD round 2 waits for Ziva's report (it judges the gym HUD against Two Point) - one round, not two.
- The YouTube short ("This Free Tool Cuts Claude Code Token Usage by 49x on Large Codebases", InsiderForce) could not be watched;
  the claim is a best case. Our token cost is images (1920x1080 stills) and long tool output, not code search; RTK already
  compresses shell output. Worth a look only if he names the tool.

## Agents
- Ziva ZIVAPLAYTEST1 running (wt/ZIVA, ziva/playtest). Cursor NIGHTLY11/11B/11C running (cloud). Arena: no self-contained pure
  item fit this stage (HUD round 2 waits on Ziva's report).
