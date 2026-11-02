# C174 ? the live stance and upright kneeling guard

Task-specific no-fetch/rebase, owned paths, no HANDOFF and per-item publication
supersede the general entry workflow. Model: gpt-6-astra; task requests medium.
No engine, catalogue, FightRealtime or FightStance edits. No full suite.

## Cascy_Switch_O2S

Rebased on **H2H_Idle.FBX frame 110 at 60 Hz (1.833333 s)**, sampled through
exactly the existing silhouette corrections and hip carry on f01. An exhaustive
281-frame scan is retained as `Tools/cascadeur/c174_switch/idle_scan.tsv`.
The idle itself has 0.180?0.207 m body-facing lead separation, so copying it
unchanged cannot meet 0.35 m. The authored endpoint uses the allowed tolerance:
4.9 degrees per bone, widening the fore/aft split while preserving knee flexion.
One rigid mount yaw canonicalizes both the source reference and authored pose;
no per-bone alignment or changing measurement axes hides a difference.

The rebase script authors measured target-space rotations and inverts the
**unchanged** runtime corrections into the Cascy export skeleton. It produces
skeletal GLB animation directly; this switch revision is not claimed to be a
new Cascadeur GUI solve. The existing rig/reference supplies its provenance.
The endpoint is the reflected anatomical start pose with left/right exchanged.
The midpoint is an eased small hop; holds remain .30 s and motion .50 s.

| Measurement | Result | Requirement |
|---|---:|---:|
| Both endpoint knees, minimum | 35.1071 deg | >=15 |
| Both endpoint lateral widths, minimum | 0.439699 m | >=0.30 |
| Both endpoint lead/rear gaps, minimum | 0.361502 m | >=0.35 |
| Per-bone idle-frame difference, maximum | <=4.901 deg | <=5 |
| Original lead, mirror, root, hands checks | PASS | unchanged |

Extended probe RESULT failures=0. Original unmirrored-end and never-switching
mutants remain red (15 failures each). Narrow-leg mutant specifically fails
width. Actual saved C173 upright export specifically fails both knees, lead
separation, and source-pose identity. No threshold was loosened.

**Visual verdict:** the start matches the live idle's bent-kneed guard within
the measured tolerance, and the hop exchanges the lead while retaining guard.
Source is the left column; accepted motion is immediately beside it:

![H2H_Idle beside O2S](../../Tools/cascadeur/c174_switch/O2S_comparison.png)

Reproduce: `python Tools/cascadeur/build_c174_switch.py O2S`, parse
`Godot/tools/switch_step_probe.gd`, then run it with
`-- Cascy_Switch_O2S --mutants --render`. `--inspect-idle` refreshes source
measurements and `--render-idle` renders the chosen source frame.

Parse: 1/0. Probe: 0 failures. `--only clip`: SUITE total=10 fails=0.
Some sandboxed direct Godot runs report user-cache/certificate access errors;
they are host limitations, not pose-gate failures. Render PNGs were inspected.


O2S publication: **a8008cb9**, pushed master; message cf347daf240c.

## Cascy_Switch_S2O

Same measured source and exact reflected endpoints, with their order reversed.
No independently invented southpaw stance. Endpoint minimum knees >=35.107 deg,
width >=0.439699 m and lead/rear gap >=0.361502 m. Its orthodox endpoint is compared
against the same idle frame; all 22 bone differences remain <=4.901 deg.
Original mirror/root/hand/lead checks pass. Extended probe RESULT failures=0;
original two mutants (37 failures each), narrow mutant and C173 upright all red.
Parse 1/0; `--only clip`: SUITE total=10 fails=0.

**Visual verdict:** the reverse hop leaves the mirrored bent-kneed stance and
lands in the live-idle stance within the measured tolerance.

![H2H_Idle beside S2O](../../Tools/cascadeur/c174_switch/S2O_comparison.png)


S2O publication: **9a5efa90**, pushed master.

## Cascy_StepThrough_O2S

Same live stance and exact mirrored endpoint. The rear foot moves first and
the lead foot follows after 40% of the motion. A two-link target-space leg solve
keeps each foot on its own path while the hips travel. Forward root motion is
**0.550000 m**, carried by the existing audition mount exactly as in C173;
this does not claim the game engine consumes a new switch tactic.

Endpoint knees >=35.107 deg; width >=0.439699 m; lead/rear >=0.361502 m;
all 22 idle-frame differences <=4.901 deg; mirrored bones <=0.039565 deg;
minimum wrists above sternum 0.067839 m. Extended probe RESULT failures=0.
All four mutant cases red, including the original two (15 failures each).
Parse 1/0. `--only clip`: SUITE total=10 fails=0.

**Visual verdict:** the rear foot steps through, the other follows, and the
fighter advances into the mirrored live stance with guard retained.

![H2H_Idle beside step-through](../../Tools/cascadeur/c174_switch/StepThrough_O2S_comparison.png)


Step-through publication: **94478b83**, pushed master; message 80a6f931db09.
S2O message: b19be36539d5.

## Cascy_ClosedGuard pair

Re-authored through Cascadeur controllers and replayed from the checked-in
`c171_closed_guard/ClosedGuard_authored.casc` before the final export, so no
unstated current-tab pose is required. Both GLBs carry the four-second breathing
hold. RIG.json, CLIP.json and the build/replay scripts are retained. The native
scene-save call failed in an earlier exploratory export; no new saved `.casc`
is claimed. Final replay/export does not depend on saving a native scene.

The original C173 pair is an actual negative control: spine **96.2074 deg** from
vertical, and it fails the new shape gate. Final top spine is **33.7994 deg**;
both knees are below the hips and on the canvas. Additional shape checks were
added when renders exposed a floating bottom pelvis and poor wrist framing.
The final comparison also rejected a 19.7668-degree bottom torso curl; an added
15-degree ceiling now measures the corrected 9.7882-degree torso, rather than
letting a floating sit-up pass as the reference posture. These checks run on the renderer's actual 66.7/93 kg fighter mounts, including height
scales, rather than unscaled helper bodies.

| Visible property, over 241 samples | Final | Gate |
|---|---:|---:|
| Top spine from vertical, maximum | 33.799420 deg | <=35 |
| Hips above both knees, minimum | 0.481481 m | >0 |
| Both knees above posed canvas plane, maximum | 0.003288 m | <=0.10 |
| Knee horizontal offset from its hip, maximum | 0.168668 m | <=0.25 |
| Both knee flexions, minimum | 92.502311 deg | >=90 |
| Top wrists to bottom stomach, maximum | 0.296950 m | <=0.30 |
| Bottom wrists to opposing top wrists, maximum | 0.109210 m | <=0.15 |
| Bottom hips above canvas, maximum | 0.160095 m | <=0.20 |
| Bottom torso above horizontal, maximum | 9.788178 deg | <=15 |
| Bottom ankle lock gap, maximum | 0.114512 m | <=0.15 |

Every pre-existing declared contact remains under 30%, unmodified:
ankle lock **23.765509%**, left knee wrap **4.835000%**, right knee wrap
**8.210560%**, left collar-distance row **0.683477%**, right **0.508440%**.
The two historical `collar_frame` row names are unchanged for compatibility;
the checked image calls for a stomach/wrist frame, so those rows now measure
preservation of wrist-to-neck distance (about 0.494 m), **not a collar grip**.
The new absolute stomach/wrist checks prevent that distance-preservation gate
from being mistaken for proof of visible contact. The source ankle gap remains
0.097980 m; it was not widened to make the percentage pass.

The new `closed_guard_kneeling_duo.mp4` arrived during the work. Its supplied
four-instant, two-camera sheet was reviewed; the first instant matches the
checked still. This asset implements that upright hold, not the video's later
posture-breaking and hand-fighting sequence.

**Visual verdict:** the final four-view render matches the target's upright
kneeling silhouette, bilateral knee base, stomach/wrist frame and crossed ankles
behind the back; different body proportions and boxing gloves remain visible.

![Target beside final guard views](../../Tools/cascadeur/c174_kneeling_guard/target_comparison.png)
![Four-view six-frame guard sheet](../../Tools/cascadeur/c174_kneeling_guard/guard_sheet.png)

Reproduce from repository root, with Cascadeur server running:
```
python Tools/cascadeur/build_c174_kneeling_guard.py Tools/cascadeur/c174_kneeling_guard
python Tools/cascadeur/author_c174_guard.py
python Tools/cascadeur/verify_c174_guard.py
python Tools/cascadeur/c174_compare_guard.py
```

Final parse: 2/0. Shape: 0 failures; baseline mutant: 2 failures, including
spine. Contact: 0 failures. Render: total=1 fails=0, all 24 frames nonempty.
The final verifier runs only the named hard controls and clip/grapple/pair
subsets. Final gate results are retained in `c174_kneeling_guard/gates.log`.


Final bounded gate: **clip 10/0; grapple 10/0; pair 7/1**, with only the known
PARKED `fight_pair_live_test.gd` failure. All seven hard controls are unchanged:
RamsterZ gap **0.302639 / 0.304671 m**, clinch **15%**, side control
**14.8173%**, mount **18.716070%**, turtle **11.194065%**, open guard
**21.533121%**, 50/50 **11.882802%**. `C174GATES PASS`.

The final guard verification ran outside the restricted cache environment and
completed normally. No full-suite run, fetch/rebase or forbidden-file edit.
