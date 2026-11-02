# C182 - checkpoint, not an accepted turtle delivery

2026-09-24. Branch `codex/c182-turtle`; model environment confirms
`gpt-6-astra`, effort `medium`. Working alone in FightCamp-C181.

The operator's C182 startup, three-part scope, restricted reads, branch workflow,
and focused gate supersede AGENTS.md task discovery/HANDOFF and C171's old
no-fetch rule and standing eight-hold queue. No forbidden status/handoff or
other-agent digest was read. No solver, retarget, stage-player, live-screen,
binding, or asset was edited.

## Part 1 - reference still pending

No image job submitted; credits spent **0 / 3**. No reference is accepted.
`Tools/higgsfield/loop.py` currently only implements video from an existing
still: `run()` calls `checked_still()` and submits a video job. It has no
still-generation mode. Its provider import fails in plain Python from BOTH
this worktree and the specified main-checkout working-directory fallback
(`ModuleNotFoundError: bl_ext`).

Recovered the existing provider without modifying the main checkout: used
Blender 5.2.1 background Python, unpacked the installed add-on's bundled
Windows/Python 3.13 wheels into temporary `c182-hf-deps`, and imported this
worktree's `loop.provider()`. Verified `C182_PROVIDER_READY`. A read-only
network call successfully retrieved the `gpt_image_2_5` parameter schema.
No credential was printed or written to the repository.

Requested permission to add the missing still-only path and 3-credit cap to
`loop.py`, because it is outside C182's owned-file list. No answer received
at this checkpoint. No silent provider substitution, still generation, video
generation, or invented prompt-log job row.

## Part 2 - contact declaration only; not authored or accepted

Declared the intended shape BEFORE authoring beside the turtle rows in
`s31_contact_probe.gd`: bottom BOTH knees and BOTH elbows on the mat, hips
over knees, rounded spine, tucked head; top knees on the mat and chest on the
upper back, hands controlling waist/seat-belt. Replaced the old left neck row
with a left waist/spine row. These joint-centre rows alone DO NOT test mat
contacts or establish the shape; absolute height/shape checks are still needed.

Cascadeur's script server is reachable through `ensure_server.py` and
`csend.py`. No pose has been changed, no GLB exported, no new sheet rendered.
The rejected shipped turtle remains rejected. Authoring waits for the checked
Part 1 reference. There is no honest side-by-side sheet to attach yet.

## Part 3 - exact rejected C170 baseline reproduced; S63 pending

Fetched origin repeatedly. At this checkpoint the required S63 integration
has not appeared in origin/master. The current live screen has the older
`contact_solve` option, but `_solve_contacts()` explicitly returns when BOTH
players are in a pair; it does not invoke FightPoseSolver for paired holds.
No differing update to either named engine file was found after fetch, so
there was no S63 change to rebase onto. No ON result is claimed.

Ran a temporary copy of the current probe with metadata pointing directly at
`C:/Users/user/AppData/Local/Temp/c170-authoring/Cascy_ClosedGuard_{Att,Vic}.glb`.
The wrist row matches C170's authored LeftHand/a to RightHand/b contract;
knee rows use Spine/b. Candidate files were not copied into the game.

| Contact | Source mean m | Unsolved target mean m | Worst drift % | S63 ON |
|---|---:|---:|---:|---|
| Same-body ankle lock | 0.089997730 | 0.137118932 | 52.359104 | unavailable |
| Left knee / torso | 0.272708697 | 0.280813558 | 5.043183 | unavailable |
| Right knee / torso | 0.261601213 | 0.268711008 | 5.139592 | unavailable |
| Left hand / right wrist | 0.084859054 | 0.190174445 | 128.591813 | unavailable |

241 samples, failures=2. Mean ankle separation increases by 4.7121202 cm;
mean wrist separation increases by 10.5315391 cm. These reproduce C170.
The unsolved baseline is a PairedStagePlayer graft probe, NOT an ON/OFF
live-room comparison. No closed-guard GLB or binding admitted.
Evidence: temporary `c182_guard_off.gd` and `c182-guard-off.log`.

## Validation and remaining work

- Repository probe parse: `CHECK total=1 fails=0`.
- Temporary guard probe parse: `CHECK total=1 fails=0` after fixing indentation.
- Initial focused tests hit TitleHonours; ran the prescribed headless import
  once. An intermediate retry still lacked an imported FBX. Final retry:
  `SUITE total=3 fails=0` for paired_clip_mount, fight_hold_binding,
  technique_id_reference. No full suite.
- Prescribed LocalAppData Godot executable is absent. Headless checks used
  installed Godot 4.7.2 through `C:/ProgramData/chocolatey/bin/godot.exe`.
  No windowed Godot run occurred.
- Import populated the cache but also produced tracked/untracked import/UID
  metadata and editor-settings save errors; the still-running import command
  was interrupted after the checks passed. Metadata is excluded from this
  checkpoint. Automatic approval review rejected bulk metadata cleanup because
  it might remove pre-existing user work; no workaround was attempted.

Remaining: authorized still-only loop path; generate/log/check reference;
absolute turtle contact checks, Cascadeur author/export/probe/render and direct
visual review; fetch/rebase S63 and measure the exact guard with solve ON/OFF;
admit only candidates meeting all contact and visual gates. This checkpoint
does not complete C182 or override the operator's turtle rejection.

## Continuation - Part 1 accepted reference (2026-09-24)

Lead authorization expands ownership to Tools/higgsfield/loop.py and its budget
helpers. Added gpt_image_2_5 still submission and a code-defined C182 cap of 3
credits. Reservations persist before submission (including uncertain failures);
an exclusive ledger lock prevents concurrent cap checks racing. Three offline
unit checks passed: 12 quarter-credit reservations fill the cap, the next is
refused; fake 3.01-credit API estimate never reaches submit; invalid estimates
are refused. No credentials were written.

Job fb5b329f-79cd-4a75-972e-e45ad002a6ad: estimated/charged 0.25 credit;
C182 total 0.25 / 3. Opened the PNG directly and checked:
- Bottom knees: both grounded, hips above the knee support.
- Bottom elbows: forearms/elbows rest on mat; far elbow partly occluded by
  the near arm in this single view (must verify both in the authored render).
- Spine: clearly rounded dome, abdomen elevated; not the rejected flat pose.
- Head: tucked, chin down.
- Top: chest draped across upper back/hips, waist grip, knees on mat.
Accepted as the authoring reference, not evidence that the game pose is fixed.

![Checked reference](../docs/previews/c182_turtle_reference.png)

Fetch succeeded with linked-worktree permission. origin/master is 723b54f7;
S63 paired contact-solve integration has not landed. No rebase attempted over
protected import metadata. Cascadeur server is reachable.

## Part 2 continuation - two attempts, REJECTED (not admitted)

Used the existing Cascadeur controller/export workflow requested by C182;
that task-specific workflow overrides the asset-production skill's generic
CLI packaging workflow. Authored in the live Cascadeur server, exported two
separate animated GLBs per attempt, stripped only the victim namespace.
`build_turtle_c182.py <scratch-directory> --apply` reproduces attempt 2;
add `--attempt1` to reproduce attempt 1. Both start from the existing checked-in
paired Cascadeur scene. All candidate GLBs remain in temporary directories;
no shipped GLB, runtime binding, or engine/solver file was changed.

Attempt 1: 51.054017% worst drift (left waist). Opened the 24-tile sheet:
elbows grounded, knees floating. Cascadeur joint readback independently showed
knees at 42-48 cm while feet were at 9 cm. Rejected.

Attempt 2: drove the calf limb-direction controllers to bend knees forward/down
instead of writing the solved calf points, and adjusted the waist grip.
Opened the sheet: the bottom has grounded knees and elbows, elevated hips,
a rounded spine and tucked head; top is kneeling and draped over his back.
It reads as turtle now, but the contact-preservation gate still FAILS:

| Contact | Source mean m | Target mean m | Worst drift % |
|---|---:|---:|---:|
| Left waist | 0.185783631 | 0.278657496 | 49.990351 |
| Right hip | 0.179855754 | 0.247184975 | 37.435201 |
| Left knee ride | 0.478176842 | 0.463382959 | 3.093810 |
| Right knee ride | 0.478175545 | 0.467579514 | 2.215929 |
| Chest/back | 0.270188979 | 0.155972689 | 42.272746 |

241 samples, 3 contact failures. Supplemental temporary absolute geometry
probe: max knee/elbow support height above lowest support = 0.026758 m
(ceiling 0.12 m); bottom hip clearance minimum 0.433587 m (floor 0.25 m);
chest above hip-neck chord minimum 0.112359 m (floor 0.03 m); head below chest.
These are joint-centre proxies, not surface collision measurements. The sheet
was reviewed independently. The temporary probe did not alter repository scope.

**Finding / stop:** after two honest attempts the left waist contact remains
above 30%. C171's two-attempt rule applies through C182 Part 2; no third pass,
no widened threshold, and no admission. The shipped rejected pair is unchanged.

| Part 1 reference | Part 2 attempt 2 - rejected on contacts |
|---|---|
| ![Reference](../docs/previews/c182_turtle_reference.png) | ![Opened sheet](../docs/previews/c182_turtle_attempt2_sheet.png) |

Evidence: `c182-turtle-attempt1` and `c182-turtle-attempt2` under LocalAppData/Temp
contain CLIP.json, exported pair, solved RIG.json and probe.log. Temporary
`c182-turtle-probe.gd` and `c182-turtle-render.gd` select those candidates without
changing shipped assets. Both render runs used `Tools/godot_hidden.ps1`:
`RENDER total=1 fails=0`; both sheets `SHEET total=1 fails=0`, 24 populated tiles.
The LocalAppData Godot executable is now present and worked with process
permission. This supersedes the earlier checkpoint's missing-executable finding.

Validation this continuation: repository probe `CHECK total=1 fails=0`;
temporary probe/render `CHECK total=2 fails=0`; focused gate
`SUITE total=3 fails=0`; offline budget tests 3 passed. No full suite.
Protected .import/.uid metadata was neither cleaned nor committed.

## Part 3 continuation - required live integration still absent

Final fetch checked origin/master 723b54f7. S63 has added
`FightPoseSolver.refine_hands` (107 lines relative to this branch), but this is
NOT the requested live paired integration. `FightWorldLiveScreen._solve_contacts`
still contains `if pair_a and pair_b: return`; neither FightWorldLiveScreen,
FightClipRetarget nor PairedStagePlayer differs from this branch. No `grips_for`
or paired `contact_solve` wiring was found in origin's PairedStagePlayer.

**Finding / blocker:** the prerequisite for Part 3 has not landed. No ON column
can be measured honestly yet. The exact C170 OFF numbers above remain the prior
checkpoint's measured baseline, not a fresh run. No closed-guard candidate or
binding was admitted. Rebase is deferred until the relevant integration exists;
protected metadata remains untouched.

Continuation shipped: Part 1 20b6e2ae (accepted still and capped loop), Part 2
5dd0b803 (rejected candidates' script and visual evidence). C182 remains
incomplete: turtle contact gate failed after two attempts, and closed-guard
ON/OFF awaits live S63 integration. One C182 message sent per part.

## S63 continuation - turtle admitted with one open BODY row; guard rejected

2026-09-24. Rebased `codex/c182-turtle` onto `origin/master` d1f43d7b,
including S63 952762dd. This section supersedes the earlier missing-S63
checkpoint and turtle non-admission. The user's explicit continuation permits
only Turtle/ClosedGuard HOLD_GRIPS rows in PairedStagePlayer, superseding the
task file's prohibition. It also explicitly permits turtle admission when
chest/back alone exceeds 30%; the measurement threshold itself stays unchanged.
The requested Godot/Cascadeur workflow takes precedence over the generic
asset-production skill's CLI packaging workflow. No new generation or spend.

### Part 2 - exact attempt 2, live pair key, solve OFF versus ON

Both columns freshly measured with `--live-key`, 241 samples, source files in
`C:/Users/user/AppData/Local/Temp/c182-turtle-attempt2/`. Temporary probe
`Godot/c182_s63_candidate_probe.gd` overrides metadata only (including explicit
pair_key Cascy_Turtle, start 0/end 4, existing paired reference). OFF additionally
passes `--grip-solve-off`. Turtle HOLD_GRIPS now matches the declared rows:
`[[0,"LeftHand","Spine"],[0,"RightHand","Hips"]]`.

| Contact | Source mean m | OFF target mean m | OFF worst drift % | ON target mean m | ON worst drift % |
|---|---:|---:|---:|---:|---:|
| Left waist | 0.185783631 | 0.278657496 | 49.990351 | 0.185783669 | 0.000029 |
| Right hip | 0.179855754 | 0.247184975 | 37.435201 | 0.179855698 | 0.000104 |
| Left knee ride | 0.478176842 | 0.463382959 | 3.093810 | 0.463382959 | 3.093810 |
| Right knee ride | 0.478175545 | 0.467579514 | 2.215929 | 0.467579514 | 2.215929 |
| Chest/back | 0.270188979 | 0.155972689 | 42.272746 | 0.155972689 | 42.272746 |

OFF failures=3; ON failures=1. ON solver reports 2 grips, 0 unreachable,
max residual 0.00000007679883 m. **Chest/back is the one OPEN row: a BODY-placement
contact unchanged by hand IK.** Its target joint-centre distance is shorter
than source by 0.114216290 m; this is not proof of surface contact or a measured
air gap. Probe correctly remains red. Admitted the exact attempt-2 GLBs under
the lead's explicit exception, not a claim that all rows passed.

The near-zero hand rows are **BY CONSTRUCTION**: solve and probe target the
same authored offset. Evidence of pose quality is the OFF column, the unsolved
rows, and the opened sheet, not the small ON numbers.

Rendered the admitted files with `tools/render_paired_hold.gd -- Cascy_Turtle`
using the hiding logic from `Tools/godot_hidden.ps1`. Its hardcoded LocalAppData
Programs executable is absent in this environment; substituted the installed
WinGet Godot 4.7.2 console path in an in-memory copy of the launcher, without
editing the helper. First invocation lost the positional key and rendered
SideControl; discarded as C182 evidence, corrected argument passing with an
explicit array, and verified the renderer printed Cascy_Turtle and both Turtle
paths. Correct run: RENDER total=1 fails=0; sheet: SHEET total=1 fails=0,
24 populated tiles. Opened the resulting sheet directly.

Visual review: side/low views show the bottom fighter on bent knees and elbows,
abdomen clear of the mat, hips elevated, rounded back and head tucked. The top
fighter kneels and drapes across his back, hands near the waist/hips. The top
and low angles confirm two bodies, not a flattened bottom fighter. Far joints
are partly occluded; this is visual pose evidence, not a surface-collision
clearance claim. Torso contact remains visibly crowded and numerically open.

| Checked Part 1 reference | Admitted turtle, S63 ON, opened this run |
|---|---|
| ![Reference](../docs/previews/c182_turtle_reference.png) | ![S63 sheet](../docs/previews/c182_turtle_s63_sheet.png) |

Admitted SHA256:
- Att: `d35da61e9af4d5bb2a923d670ba631563fce47435921c347b6c6cde077302fec`
- Vic: `c15b6c598f96fba4c25fd6b7b033c17929318ad3823adf64986c2216708a62d2`

### Part 3 - exact C170 candidate, wrist still above ceiling

Candidate metadata points at `C:/Users/user/AppData/Local/Temp/c170-authoring/`,
with pair_key Cascy_ClosedGuard, same 0..4 window and paired reference.
Temporary declared probe rows: ankle LeftFoot/a -> RightFoot/a; both knees
LeftLowerLeg/a and RightLowerLeg/a -> Spine/b; wrist LeftHand/a -> RightHand/b.
Temporary candidate HOLD_GRIPS:
`[[0,"LeftFoot","RightFoot",0],[0,"LeftHand","RightHand"],[0,"RightHand","Neck"]]`.
The original right collar row was retained; only the conflicting left collar
was replaced with the candidate's wrist target.

| Contact | Source mean m | OFF target mean m | OFF worst drift % | ON target mean m | ON worst drift % |
|---|---:|---:|---:|---:|---:|
| Same-body ankle lock | 0.089997730 | 0.137118932 | 52.359104 | 0.089997712 | 0.000280 |
| Left knee / torso | 0.272708697 | 0.280813558 | 5.043183 | 0.295254552 | 9.736890 |
| Right knee / torso | 0.261601213 | 0.268711008 | 5.139592 | 0.268711008 | 5.139592 |
| Left hand / right wrist | 0.084859054 | 0.190174445 | 128.591813 | 0.085092940 | 32.975515 |

241 samples; OFF failures=2; ON failures=1. ON reports 3 grips, 0 unreachable,
max residual 0.00000021950781 m, yet sampled peak wrist drift remains
32.975515%. A close mean and small solver residual do not pass a peak-drift
gate. An initial additive wrist row (also retaining the same hand's neck target)
peaked at 33.315708%; removing that conflicting target did not make it pass.
No solver internals or threshold tuning. **Candidate remains REJECTED**;
no C170 GLBs or binding changes admitted. Restored the shipped closed-guard
HOLD_GRIPS and probe rows after the experiment so a rejected candidate's
contract does not change the currently shipped hold. The ankle is solved now;
the residual wrist peak, not the ankle, is the remaining finding.

Rejected C170 SHA256:
- Att: `b0b40ee4bccf674a41d5ea4d5507b5d1be90305f65c8718e64f33ae37e7d2f10`
- Vic: `c981ad4d5dbf5291a30952d12f804dd791d446f0564fbc7efc7a1fd6cae90376`

### Final gates and hygiene

- Candidate-stage parse: CHECK total=3 fails=0; final player parse CHECK total=1 fails=0.
- Final requested gate: `run_tests.py --only paired_clip_mount,fight_hold_binding,technique_id_reference,c168,c169,paired_stage`: **SUITE total=7 fails=0**.
- No full suite, no new tests, no solver/retarget/live-screen edits. Final code
  diff is only the Turtle HOLD_GRIPS anchor. No binding change needed for Turtle.
- Raw local logs retained under `.c182-evidence/` (not staged). Renderer reported
  user-log/shader-cache permission and certificate-store warnings; GPU output,
  renderer nonempty checks, sheet checks and direct image review succeeded.
- Rebase required refreshing 1029 `.import` index entries only after verifying
  zero content diff. Two untracked SideControl preview import files collided
  with upstream tracked paths; preserved in `.c182-import-backup/`. No bulk
  cleanup, no foreign files committed. Local temporary probe remains unstaged.
- No HANDOFF.md, CURRENT_STATUS.md or other digest opened. C182 Part 1 already
  completed previously; this continuation reports Parts 2 and 3 once each.
