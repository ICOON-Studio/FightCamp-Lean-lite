# TASK_U123 - the turn-rate row U109 could not deliver

Model: composer-2.5, medium. You own U123. This file is self-contained: read it
and the files it names, nothing else. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest, and do not explore to
"get oriented".

## THE ONE THING THAT IS STILL OPEN

`research/U109_FOOTAGE_BETWEEN_RATES.md` delivered five of its six rows and
they are accepted. The sixth is not:

    | turn_yaw_deg_s | p50=36.3 deg/s | p50=27.8 deg/s | p90=151.8 | max=10576.7 | — | NOT MEASURED |

**10,576.7 deg/s is 29 full rotations per second.** No human does that, so the
row is not a measurement of anything and it is labelled `NOT MEASURED`. Until it
is trustworthy, `FightBearing.TURN_BASE_DEG_S` stays authored at 240 deg/s and
tuned to nothing - that constant is the whole reason this number was asked for.

Your job is to make that row trustworthy **or to prove it cannot be**. Both are
acceptable deliveries. A number you do not believe is not.

## START FROM MASTER

Your worktree `C:\Users\user\AppData\Local\Temp\FightCamp-U80` sits on an old
branch. First:

    git fetch origin
    git checkout -B cursor/u123-turn-rate origin/master

## WHERE THE CODE IS

`Tools/footage/between_events.py`, the block commented
`--- turn yaw rate (usable frames only) ---` at **line 189-259**. Read that block
and the constants at **lines 109-112**. That is the whole surface; the five
accepted rows are computed further down the same file and **you must not change
them** - if any of the five moves, you have broken something.

The gate is `research/U109_check.py`; it recomputes every per-minute figure
from the delivered event files. Run it from the repo root:

    python research/U109_check.py

Footage lives at `C:/Users/user/AppData/Local/Temp/FightCamp-footage` (`track/`
and `events/`). If that directory is missing, STOP and say so - do not
re-download anything.

## A HYPOTHESIS, OFFERED AS A HYPOTHESIS AND NOT AS THE ANSWER

`UNRESOLVED_DEG = 60.0` rejects a frame-to-frame facing change of 60 degrees or
more. **That gate is in degrees PER FRAME, and the reported quantity is degrees
per SECOND** - the code multiplies by `fps` afterwards. So on a high-fps track a
change of, say, 44 degrees in one frame passes the gate and is then reported as
44 x 240 = 10,560 deg/s. 10,576.7 / 60 is about 176, which is inside the fps
range these tracks cover.

**VERIFY OR REFUTE IT, DO NOT ASSUME IT.** Find the actual frame pair that
produced the maximum: print the video id, the frame indices, that clip's `fps`
from `ev["fps"]`, and the raw `d` in degrees. Put those four numbers in the
digest. If the hypothesis is wrong, say what the real cause is with the same
four numbers - a diagnosis that fits the number can still be the wrong one.

Two further things to check while you are in there, because both are cheap and
both would produce the same symptom:

- **Is `ev["fps"]` the track's REAL rate?** `HFSZxKUUE98` is slow motion, so its
  npz fps is not its playback fps. A rate computed against the wrong fps is
  wrong by exactly that ratio.
- **Does `fix_hip_swap` actually catch the flips?** A left/right hip label swap
  is a 180 degree jump; the wrap to +-180 turns it into a small number that looks
  innocent. Count how many pairs it caught and report it.

## WHAT A FIX MAY AND MAY NOT DO

**MAY:** gate on deg/s rather than deg/frame; make the rejection threshold a
function of fps; correct the fps for the slow-motion track; tighten the label-
swap detection; widen the geometry floors.

**MAY NOT: discard samples until the maximum looks reasonable.** Bounding a
maximum invites passing the bound by throwing away the evidence. If you exclude
frames, the exclusion must be justified by a property of the FRAME (the hip line
is not visible, the labels flipped, the fps is wrong) and never by the value it
produced. Report `turn_yaw_excluded_share` before and after; **if your change
excludes more than 25% of pairs, that is a finding to report, not a fix to
ship.**

## THE HONEST NEGATIVE IS A FULL DELIVERY

If after diagnosis monocular 2D simply cannot resolve facing rate on this
footage, say so, keep the row labelled `NOT MEASURED`, and state in one sentence
what WOULD measure it. That answer is worth more than a plausible number.

## DELIVERABLE

1. `Tools/footage/between_events.py` - the yaw block only, if a fix is warranted.
2. `research/U109_FOOTAGE_BETWEEN_RATES.md` - regenerate it. The
   `turn_yaw_deg_s` row carries the new p50/p90/max and the label
   `MEASURED (footage)` **only if you believe it**; otherwise it keeps
   `NOT MEASURED` and the blocking note at the top of the file is rewritten to
   say what you found. **The digest is machine-generated - do not hand-type a
   cell.** The other five rows must come back byte-identical; diff them and say
   so in the digest.
3. `research/U123_TURN_RATE.md`, 50 lines at most: the frame pair that
   produced 10,576.7, the cause, what you changed, the before/after
   `turn_yaw_excluded_share`, and a one-line verdict on whether
   `FightBearing.TURN_BASE_DEG_S` can now be set from footage.

## TEST TIER

**NO `.gd` FILE IS TOUCHED, SO THERE IS NO PARSE GATE AND NO GODOT TEST.** Do not
run `run_tests.py` - it costs forty minutes and this task cannot affect it. Your
gate is:

    python research/U109_check.py

It must print `U109_CHECK PASS`. A FAIL line naming one of the five accepted
rows means you broke a row you do not own.

## NON-VACUITY

Print and assert a denominator before any percentile: how many pairs were
considered, and how many survived. **A derivation that reads nothing prints a
confident 0.000 and looks like a measurement.** If fewer than 100 pairs survive
across the whole corpus, that is the finding.

## OWNED FILES

- `Tools/footage/between_events.py`
- `research/U109_FOOTAGE_BETWEEN_RATES.md`
- `research/U123_TURN_RATE.md` (new)

Nothing else. Do not edit `research/U109_check.py` - a gate that is edited
by the work it gates cannot fail.

## FINISH

`git status -s` first, then commit with explicit paths (`git add -- <files>`;
never `git add .`). **Unstage anything under `AgentComms/` before you commit.**
Push `cursor/u123-turn-rate`. Then ONE line:

    python Tools/agent_comms.py send --from cursor --to claude --topic u123-ready --body "<hash>, cause=<one phrase>, p50/p90/max=<...>, label=<MEASURED|NOT MEASURED>"

Do NOT edit `HANDOFF.md`.

## THE ONE TRAP SPECIFIC TO THIS TASK

**Your branch rides your commits, and so does your mail.** `agent_comms.py send`
writes a file into the repo; if it lands on your branch and the branch is never
merged, the inbox reads `unread=0` and Claude never learns you finished. Push the
branch FIRST, then send, and put the branch name in the body.
