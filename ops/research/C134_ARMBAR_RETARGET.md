# C134 armbar: lost travel is proven; live contact acceptance remains open

Continuation 3, seed 77321, f05 MMA light / f06 MMA lhw, both attacker assignments.
Current branch was already at `10c7bc60` (master merge), not the handover's `dad2bb59`.
No rebase or engine changes were made.

## What was measured

`tools/c134_armbar_measure.gd` samples all 135 frames at 30 Hz over 4.466667 s.
Source positions are composed from the FBX's animated node hierarchy, including its root.
Target positions are read from the actual room's posed skeletons in a rendered process loop.
Both animation clocks are explicitly sought to the same sample time. No headless pose reads.
Six named joints per body are exported for every frame to local JSON, in metres.

The grip proxy is the midpoint of the attacker's LeftHand/RightHand joint centres; the
victim wrist is RightHand. This measures joint proximity, not skin/glove surface contact.
The whole clip includes acquisition and separation, so its largest gap is not a grip-slip
metric. We report the whole clip and the 0.8-2.8 s roll as well as the 1.4-2.4 s lock.

## Cause, independently of placement

Source attacker Hips ranges: **X 1.020333 m, Y 0.784589 m, Z 0.843685 m**.
Source victim Hips ranges: **X 0.164263 m, Y 0.152774 m, Z 0.089696 m**.
The live graft has **exactly zero horizontal hip displacement on BOTH bodies**.
Attacker/victim Y ranges are 0.766147 / 0.153918 m (their different rig scales).

`PairedStagePlayer.graft_pair` uses `FightClipRetarget.retarget_clip` with the ordinary
standing defaults. That path writes the pelvis height and removes horizontal displacement.
Its optional standing sway is also unsuitable: it is gated on returning motion and subtracts
the first frame. No amount of CONSTANT placement can restore the missing animated trajectory.
The source files also have different root placements/facing; their raw wrist-to-hand distance
is NOT a valid source-contact score until those coordinate spaces are aligned.

## Controlled repair

`FightStagePlayer.restore_paired_travel` restores source X/Z displacement relative to the first
frame, through the retarget's existing hip-parent axes and body scale. It preserves all original
rotation keys and Y keys. It is explicitly opt-in, idempotent and currently audition-only.
No ordinary standing, accepted mount or production binding is changed.
The same 180-degree attacker turn is applied with and without travel in the controlled comparison.

| Armbar, attacker f05 | Grip gap min-max, m | Best constant-offset residual RMS, m |
|---|---:|---:|
| Turn only, entire film | 0.078-0.878 | 0.468 |
| Travel + turn, entire film (includes release) | 0.067-1.447 | 0.626 |
| Turn only, roll 0.8-2.8 s | 0.078-0.757 | 0.264 |
| Travel + turn, roll 0.8-2.8 s | 0.068-0.348 | 0.151 |
| Turn only, lock 1.4-2.4 s | 0.474-0.757 | 0.115 |
| Travel + turn, lock 1.4-2.4 s | 0.068-0.178 | 0.100 |
| Travel + turn, lock, reversed f06 attacker | 0.129-0.229 | 0.097 |

The residual is RMS of the separation VECTOR after subtracting its mean, not just the range
of its length. It distinguishes a constant offset from time-varying separation. The source
lock with attacker yaw corrected has 0.076 m residual by the same joint-centre proxy.
Whole-film maximum grows after repair because the bought film actually separates at the end;
flattening the root had erased that movement as well as the roll.

Opened four-angle sheets at 0.8/2.0/3.8 s for both role assignments:
`C134_EVIDENCE/armbar-travel.jpg`, `armbar-travel-reversed.jpg`.
The lock and separation are now recognisable. Grip error and close body intersections remain.
This is NOT certification of a sporting finish or a tap. Live refusal remains in place.
Buying another pair is not inherently futile: this pipeline fault has a measurable repair.
It also does not guarantee a new SKU fits these proportions or depicts the required positions.

## Reproduce

```powershell
$g = "$PWD/.godotbin/Godot_v4.7.2-stable_win64_console.exe"
& $g --path Godot --rendering-method gl_compatibility --fixed-fps 30 --script tools/c134_armbar_measure.gd -- seed=77321 discipline=bjj tag=armbar-measure
& $g --path Godot --rendering-method gl_compatibility --fixed-fps 30 --script tools/c134_armbar_measure.gd -- seed=77321 discipline=bjj turn tag=armbar-turn
& $g --path Godot --rendering-method gl_compatibility --fixed-fps 30 --script tools/c134_armbar_measure.gd -- seed=77321 discipline=bjj travel turn tag=armbar-travel
& $g --path Godot --rendering-method gl_compatibility --fixed-fps 30 --script tools/c134_action_review.gd -- seed=77321 discipline=bjj raw travel turn tag=armbar-travel-review
```

Add `top=b` and a different `tag=` to reverse roles. JSON/JPG outputs go to `.c134/`.
Summarize without extra Python dependencies:
`python Godot/tools/c134_armbar_summary.py .c134/armbar-turn.json .c134/armbar-travel.json`
Focused regression: `run_tests.py --only c134_paired_travel`: **1 test, 0 failures**.
It checks actual travel on both rigs/roles, preserved height/rotations, and no accumulation.
