# C134 continuation 5 - contacts remeasured; visual acceptance still NOT met

2026-09-20. Branch `codex/c134-bjj-presentation`, starting HEAD `5c12b264`.
Requested GPT-6 Astra / medium / Fast OFF. Fixture seed 77321 throughout.

## Operator headline - fresh recordings

| Route | Beats | Named clip played | Honest degrade | Result |
|---|---:|---:|---:|---|
| BJJ | **144** | **0** | **144** | **DECISION** |
| MMA | **73** | **40** | **28** | **DECISION** |

MMA additionally has **3 walk-carried / 2 stance beats**, accounting for all 73.
These are the terminal room counters, not a count of every engine event.
In particular, refused grapple beats are counted separately: BJJ has **71 selected,
71 unshown**, zero paired frames and zero held mount. All 144 BJJ action beats were suppressed.
The earlier 176/2/174 and 76/50 figures are not the current merged-tree baseline.
No production script/binding changed this run, so no coverage gain is claimed.

## Contact result - step 1 committed ee87aca3

Both submissions remain audition-only. Repaired hip travel survives; contact is still not fixed.
Every rendered sample at 30 Hz was measured for both f05/f06 assignments (135 armbar frames,
181 strangle frames each). Grip proxy = midpoint of attacker hand joints, victim target =
RightHand for armbar / Neck for strangle. Residual is variation in the target joint's rotating
local frame around the contact-window mean, not mesh-surface contact or penetration.

| Film / attacker | Window s | Grip distance m | Local residual RMS / peak m |
|---|---|---|---|
| Armbar / f05 | 1.4-2.4 | .068052-.178377 | .085739 / .160632 |
| Armbar / f06 | 1.4-2.4 | .128674-.229267 | .072969 / .159216 |
| Strangle / f05 | 1-5 | .179439-.206941 | .025695 / .062844 |
| Strangle / f06 | 1-5 | .191354-.222337 | .030318 / .073350 |

Opened fresh four-angle armbar .8/2/3.8 s and strangle 1/3/5 s sheets. Armbar retains
loose grip/intersections. Strangle remains a hands-to-neck squeeze without a verified sporting
finish, tap or release. Restored hip travel does not constrain two independently retargeted
limb chains: target lengths, independent travel scaling and rotations remain, without a paired
contact solve. This is the remaining unconstrained relationship, not a measured per-bone blame.
Per-frame CSVs, method, commands and numeric summary: [C134_CONTACTS_CONT5.md](C134_CONTACTS_CONT5.md).
The original source repair remains documented in [C134_RETARGET_CONT4.md](C134_RETARGET_CONT4.md).

## Transition result - step 2 committed 317b77b6

Reopened all four multi-angle auditions with travel restored using the existing compatibility
path (`raw turn travel`), without changing the live gate:
- Clinch break: PushOff starts in mount; the engine starts standing in clinch.
- Sweep: Reversal samples return the same attacker to mount; engine half -> guard swaps top.
- Escape: PushOff ends standing; engine escape ends in guard with top retained.
- Stand-up: BodyLock_End starts in mount; current engine stand-up starts in guard.

These are content/seat mismatches after restoring travel, so all four remain refused.
No new hand-authored holds, purchases, engine edits, full suite, rebase or HANDOFF edit.
Continuation rules override the general startup rebase/HANDOFF instructions. RTK wrapper
failed configuration; native Git/raw commands used. No subagents needed.
Higgsfield checked once: **no callable MCP tool exposed; zero jobs/credits**.

## Engine findings - read-only replay

Using the live room's different fighters, plans and exact begin options:
BJJ still has **59 unnamed head_neck actions with positive wear**, total wear 83.856219
across those records. Four action-selected windows contain four grapple events that lose priority.
BJJ grapple events 78 / selected 71; MMA 27 / selected 22, with three action-priority windows.
The remaining unselected events are not attributed to action priority by this measurement.
Both engine results are DECISION; the earlier BJJ KO again does not reproduce.
No claim that the general engine defect is fixed. Claude owns these issues.
Evidence: C134_EVIDENCE/cont5-engine-summary.json, reproduced by c134_engine_review.gd
then c134_engine_report.py. This probe is engine evidence, not rendered coverage.

## Gates - actual run_tests.py summaries

| Group | Total | Fails | Result |
|---|---:|---:|---|
| c134 | 5 | 0 | Pass |
| clip | 9 | 0 | Pass |
| grapple | 10 | **0** | Better than ceiling 1; previous drift does not reproduce |
| pair | 7 | 1 | Operator-parked fight_pair_live, 39 checks / 6 failures |
| stage | 14 | 1 | Existing fight_stage_realism, 13 rules / 8 failures |

Parse passed both touched/new GDScript tools. Python reporting helpers compile.
No production files or tests changed. No weakened assertions. No full suite.

## Recording review

BJJ: 18,280 frames / 609.333 s / 1,572,332,718 bytes. Opened decoded frames at
4, 19.4, 34, 38, 75, 239.5, 475 and 608.333 s, including the terminal readout.
Stable mat and contained silhouettes; unsupported floor seats still show overlapping standing
fallback. The readout remains 'waiting for the first beat' until the terminal verdict because
no clip was played. This is a visible presentation defect, not a successful BJJ match.
MMA: 9,280 frames / 309.333 s / 1,205,482,498 bytes. Opened decoded frames at
4, 19, 33.9, 35, 37.4, 42, 150 and 308.333 s, including the terminal readout.
22 selected grapple events: 19 unshown, 2 film plays, 1 already-playing event.
105 paired frames / 3.5 s, zero clock error; 2 resting-hold entries / .767 s.
Mount is visible at 33.9/35 s; the guard transition cuts it before the 37.4 s sample.
Nine ground strikes refused outside accepted mount; zero ground-strike films played.
Unsupported seats abruptly return to standing; close overlap remains.
Both logs have zero SCRIPT ERROR / Parse Error lines. The recording shell returned 1
with known certificate/logger warnings and exit leaks; neither is claimed a clean process exit.
Both AVIs decoded through their terminal verdict. Evidence: C134_EVIDENCE/bjj-cont5-match.jpg
and mma-cont5-match.jpg.

These are sampled inspections of newly decoded recordings, not claims to watch every frame.
Movies remain local and uncommitted, one per route, each old file deleted before replacement:
`.c134/bjj-final-77321.avi`, `.c134/mma-final-77321.avi`.
Capture commands remain c134_match_review.gd with seed=77321, discipline=bjj/mma, rounds=1,
finish-exit, --fixed-fps 30, --write-movie and --quit-after 18300/9300 respectively.
Evidence extraction: `python Godot/tools/c134_video_review.py bjj` (then mma).

Only tools, research evidence and this digest changed in continuation 5. Of Claude's overlapping
production files, none changed. Accepted mount and prior mount-TAP/release policy remain;
side, guard, half, back, clinch engagement and passes still lack accepted film.
No continuous believable sporting sequence is claimed. C134 visual acceptance remains OPEN.
