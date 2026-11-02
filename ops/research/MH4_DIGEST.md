# MH4 cast - COMPLETE

Worktree `E:/FightCamp/wt/MH4`, branch `codex/mh4-cast`; intake `900a9b53`.
The task's enumerated cast totals **26**, despite its “24” heading: 10 staff,
12 boxers, 4 members. Deliver every enumerated role. No review-board posts.

## Batch 1

Six staff built: the four original file names replaced in place, plus
`mh_staff_coach_2` and `mh_staff_coach_3`. Creator constraints use lean fat and
athletic muscularity. Walter's waist is now 78 cm, replacing 104 cm. Two fit
MH2 boxers retained with distinct matte trunk colours; their mesh/skin/image
binary chunks are unchanged. Boxer 03 is scheduled for a lighter silhouette
after opening the initial still; 04 must reduce its 96 cm waist.

Opened `lineup_retained.png`, `lineup_1.png`, and the accepted corrected
`lineup_1_palette.png`. Body/variety observations and rejected iterations are
recorded in `previews/mh4/visual_review.json`. The batch-1 audit recorded eight delivered/retained models, 18 still to build;
the final audit now covers all 26.

## Batch 2

Four further staff delivered: cutman (woman), desk clerk (man), cleaner
(woman), physio (man). Boxer 03 rebuilt with chest 96 / waist 75 cm,
muscularity 0.3 and fat -1.5; measured thigh falls from 60.09 to 53.5 cm and
bicep from 35.82 to 31.39 cm. Boxer 04 rebuilt at height 190 / chest 114 /
waist 86 cm, replacing the failing 96 cm waist. Opened and accepted
`lineup_2.png`; all six are lean and visibly distinct. Numerical audit:
14 characters PASS, 12 missing. One scoped six-model headless import.
All four required regression lines PASS: `SUITE total=4 fails=0`;
`tests_batch_2.txt` preserves every line.

Watchdog RED pauses were honored between engine launches; no MH4 heavy
process ran during those waits. Boxer 04's owned UE PID was explicitly
verified at affinity mask 3; future UE launches use that two-CPU cap.

## Batch 3

Boxers 05–10 delivered: five men over fly/bantam/light/light-heavy/heavy,
plus a woman flyweight. Hip/thigh/bicep and muscularity constraints vary by
class instead of repeating a single athletic body. Opened `lineup_3.png`,
then rejected boxer 10's older-looking Lani face. Rebuilt with the unused
Zuri preset and opened/accepted `lineup_3_age.png`. White Creator tee retained
over the woman's MH2 trunks. Opened and accepted `lineup_5.png`, comparing
retained 01/02 directly with slimmer 03, rebuilt 04 and new 05/06.

Numerical audit: 20 PASS, six missing. One six-model scoped import; the
age correction received one separate single-model repair import.
All four required regression lines PASS: `SUITE total=4 fails=0`;
`tests_batch_3.txt` preserves every line.
Pilot-cache slowdown attempt preserved as `boxer_10_pilot_cache_attempt.txt`;
the retry completed using only the task-local writable cache and engine pak.

UE reset its initial process affinity during startup. The guard now verifies
and reapplies the mask to owned process trees every two seconds. A sidecar
guarded the in-flight third batch; its samples are `affinity_batch_3.json`.
Later UE launches use mask `0x140` (two logical CPUs outside the host's shared
Godot/Blender `0x3F` mask), with per-launch verification receipts.

## Pipeline and measurement provenance

MH2/STAFF1 Creator → Blender exporters are reused through MH4 wrappers.
An isolated UE project, shader scratch and writable DDC live in ignored
`Tools/metahuman/.mh4/`; early batches accessed the old pilot DDC read-only,
then removed that backend after the third-batch slowdown. Startup
device profiles cap textures at 1024, texture compilation is serial, shader
workers are limited to two. After repeated host RED readings in batch 2,
future UE launches are pinned to two logical CPUs; Blender/Godot use six.
UE and Blender run without windows; renders use the hidden Godot desktop.
Blender uses factory startup to avoid operator-installed add-ons.

Height/waist are **Creator constraint receipts**, not independent mesh
metrology. Weight is authored character biodata: Creator has no mass constraint.
BMI is calculated from that biodata. Visual silhouette review is mandatory;
numerical metadata alone cannot mark the cast complete. Skin columns use the
nearest of Maria's six palette swatches to the delivered neck texture median.
Groom + that quantized skin tone must be unique, as must face presets.

Garment colours are converted from task sRGB hex to linear glTF factors.
Creator tees/shorts remain the installed clothing fallback, without shoes.
Men boxers use MH2's coloured body-material trunks mask. Women boxers retain
Creator tees with garment shorts faces removed, plus the same MH2 trunks mask.

The first root headless import encountered unrelated unhydrated research LFS
art and regenerated metadata. It was stopped; only its generated `.uid` files
and `.import` changes were restored to intake state (including Git's CRLF
filters). Native status confirms **zero unowned changes**. Subsequent imports
use tiny batch projects with identical `res://assets/models/metahuman/` paths,
then copy only the owned import products and their cache entries into the
seeded cache. One headless import per such batch; no full editor launch. The
palette correction received a separate repair batch. Root-certificate-store
warnings are host sandbox evidence, not suppressed or claimed fixed.

## Gates and scope

Initial selected regression subset: `SUITE total=4 fails=0`.
Changed harness parse: `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
Batch 1: all four selected test lines PASS, `SUITE total=4 fails=0`;
staff pose remains 248 checks / 0 failures. Full lines are recorded in
`previews/mh4/tests_batch_1.txt`.
Per-batch audit receipts and full Creator logs are in the same preview folder.
No full suite is authorized or run.

Task precedence replaces the generic one-commit-then-end rule with continued
batch commits/pushes. HANDOFF is outside MH4 ownership and is not edited. No
main-checkout source is changed. Native Godot 4.7.2 is installed under
Chocolatey, rather than this session's redirected LOCALAPPDATA path.

## Batch 4 and final acceptance

Delivered women boxers 11/12 and four members. Opened `lineup_4.png` and
rejected the male member's native female body despite its masculine setting.
Rebuilt member 3 with Cameron and boxer 12 with Etta, preserving their role
measurements. Opened and accepted `lineup_4_sex.png`: masculine member chest,
feminine boxer torso, flat waists, varied heights/faces/grooms, complete feet.
One scoped six-model import and one scoped two-model correction import.
Every generated still was personally opened, including rejected iterations.
Accepted final coverage: `lineup_1_palette.png`, `lineup_2.png`,
`lineup_3_age.png`, `lineup_4_sex.png`, and retained-boxer comparison `lineup_5.png`.

Member 3's corrected UE commandlet completed and exported valid Body, Face,
outfit and grooms, but UE stalled during shutdown after shader workers exited.
Only that owned UE process was stopped. Its completed receipts were validated
and adopted, then Blender conversion and Godot import/render succeeded.
`member_3_shutdown_wait.txt` preserves the stall; no successful UE process
exit is claimed for that attempt.

Final `cast_audit.json` is complete: 26/26 body and variety passes, no missing.
10 staff, 12 boxers (3 women), 4 members (2 women); 10/17 women outside male
boxers (58.8%), six ethnicity groups, 26 unique face presets and unique
groom/quantized-skin pairs. Each model has one 341-joint skin including the
required anatomical chains, embedded textures <=1024, and the established
6 MB bare-boxer / 8 MB clothed budget. Weights remain authored biodata.
Full table and check lines: `previews/mh4/audit_final.txt`.

All four required tests pass at baseline and after each of four batches.
Each log preserves every test line (`tests_baseline.txt`, `tests_batch_1.txt`
through `tests_batch_4.txt`), each with `SUITE total=4 fails=0`.
Harness parse passed before the first regression gate. This is cast asset
acceptance and Godot lineup verification; gameplay roster integration and
new motion certification were outside the owned task scope.

Batches pushed only to `codex/mh4-cast`: e1dcd1e5, 7d1ab771, 1adca87e, plus
the final batch commit containing this digest. No master push or review-board
post. No HANDOFF or main checkout edits. MH1's recorded licence provenance
was read; this task did not replace its primary-source release verification.
