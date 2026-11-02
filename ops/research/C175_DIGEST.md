# C175 - knee-on-belly against the checked still

C172 first missed the abdomen by 0.651 m, then reached it but failed at
38.596042% drift with a low cross-body silhouette. What is different now:
`knee_on_belly_still.png` supplies the pose target. The top hips must be high,
torso upright, knee/shin across the stomach, far foot wide and planted, and
the bottom player flat with a knee frame. Relative contact drift alone is
not acceptance. Existing contacts and thresholds remain unchanged.

Task-specific no-fetch/rebase, no HANDOFF, explicit-path staging and bounded
gates override the general startup and full-suite rules. Model requested:
gpt-6-astra / medium. Two attempts maximum.

## Two measured attempts - SKIPPED

Attempt 1 raises the hip, keeps a solved knee on the stomach, uses a strong
leg bend pole, and reaches for a wide independent foot base. Construction
checks rejected unreachable hand targets before the first exported candidate.
The exported candidate passes all four old drift rows (worst 21.146200%) but
fails width (0.376723 m on the actual mounts) and torso angle (46.277851 deg).
The render additionally exposes a pointed-down far foot and floating bottom
body. The initial minimum-of-ankle/toe floor check masked that problem; it
was tightened, never relaxed, to require both points within the height limit.

Attempt 2 turns the near shin across the abdomen, extends the far foot wider,
levels its source controller group independently of the torso, and raises the
spine by five degrees. The exported target still fails planted-foot height.
No third attempt, retarget correction, solver change, or threshold relaxation.
The temporary binding and both runtime GLBs were removed; FightClipBinding.gd
has no final diff. Both rejected exports and exact controller clips remain here.

| Final visible property, 241 samples on actual 66.7/93 kg render mounts | Value | Gate |
|---|---:|---:|
| Knee to bottom Spine (abdomen), maximum | 0.232547 m | <=0.30 |
| Hips above both knees, minimum | 0.253699 m | >=0.20 |
| Far foot ankle/toe above posed canvas, maximum | **0.167194 m** | **<0.05 FAIL** |
| Far foot lateral from near knee, minimum | 0.651232 m | >=0.40 |
| Top spine from vertical, maximum | 41.277821 deg | <=45 |
| Bottom hips above posed canvas, maximum | 0.099693 m | <=0.20 |

Lateral means the horizontal top-player hip axis; floor means the lowest
posed bone across both bodies, matching the renderer's canvas placement.
Foot height checks both RightFoot and RightToes; it is a joint-point gate,
not a mesh sole/collision measurement. Missing required bones fail loudly.
The upright-spine and bottom-floor ceilings are additional visual guards.

The unchanged historical unscaled contact probe reports knee/belly source
0.152246714 m -> target 0.180543165 m, worst **18.905917%**. Other rows:
left shoulder-distance 7.596590%, right hip-distance 6.762849%, bottom knee
frame 7.255025%. Those top-hand source gaps are 0.446/0.416 m: preserved
separation is not proof of a grip. The crossed arms visibly miss the target's
hand arrangement. No accepted contact claim is made for this rejected pose.
Actual scaled shape measurements above take precedence over attractive drift.

**Visual verdict:** the second attempt resembles the high-hip knee-over-abdomen
arrangement, but its bent/floating far foot and crossed arms do not match the
checked target; both attempts are rejected. RENDER 1/0 for each only proves
24 populated views, not pose acceptance. All four views and six instants were
inspected; the supplied video sheet is beside the final candidate below.

![Checked video sheet beside rejected attempt 2](../../Tools/cascadeur/c175_knee_on_belly/attempt2/comparison.png)
![Checked still beside four rejected views](../../Tools/cascadeur/c175_knee_on_belly/attempt2/still_comparison.png)
![Rejected attempt 2 full sheet](../../Tools/cascadeur/c175_knee_on_belly/attempt2/sheet.png)
![Rejected attempt 1 comparison](../../Tools/cascadeur/c175_knee_on_belly/attempt1/comparison.png)

## Reproduce and evidence boundary

`python Tools/cascadeur/c175_knee_on_belly/gates.py Tools/cascadeur/c175_knee_on_belly`
runs the parse gate, historical controls, C172/C174 holds, both archived
rejections, and only clip/grapple/pair. The archived probes use
`bjj_knee_on_belly --c175-attempt2` (or `--c175-attempt1`) and remain runnable
without binding a rejected asset. Both probes must exit 1 for attempt 2.

`build.py <workdir>` constructs CLIP.json from the retained RIG.json;
`author.py` replays it from the checked-in C171 native source and defaults to
exporting into the evidence-only `replay` directory. `verify_attempt.py` is the
authoring-phase capture helper requiring a temporary candidate binding/runtime
export; final regression uses archived bytes through gates.py instead.
MANIFEST.json records both pairs' hashes. These are held breathing loops,
not an entry/exit or striking sequence, and no new native .casc save is claimed.

Initial sandboxed probes emitted host cache/certificate errors. Final attempt 2
and regression use the normal host cache. The stale stage guard was explicitly
overridden for the user's new C175 assignment with FIGHTCAMP_STAGE_GATE=off.

## Final gates and disposition

Parse **2/0** for the two changed/new probes; earlier temporary binding parse
was 3/0. Archived attempt 1 has three shape failures; attempt 2 has one shape
failure, the far-foot height. Both are intentional red pose witnesses.
Final bounded subsets: **clip 10/0, grapple 10/0, pair 7/1**, with only the
known PARKED `fight_pair_live_test.gd`. `C175GATES PASS`; no full suite.

Hard controls unchanged: RamsterZ **0.302639 / 0.304671 m**, clinch collar
**15%**, side control **14.8173%**, mount **18.716070%**, turtle **11.194065%**,
open guard **21.533121%**, 50/50 **11.882802%**. C172/C174 controls unchanged:
closed guard **23.765509%**, front headlock **20.406136%**, north-south
**17.603796%**, live-source clinch **25.699268%**; C174 shape failures **0**.
Exact outputs are retained in the named logs under this task's evidence folder.

**SKIPPED after two honest attempts.** No knee-on-belly runtime binding or
GLB ships. This commit ships the stricter shape/contact gate, reproducible
rejected evidence, and comparison. No HANDOFF/status/archive edits, no
fetch/rebase, and no other agent's files staged. The CLI accepts `--topic C175`,
not `--subject C175`; publication uses one send with that supported spelling.
