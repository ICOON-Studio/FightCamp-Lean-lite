# TASK_Q122 — QWEN — WHEN ARE TWO CAPTURED MEN ACTUALLY HOLDING EACH OTHER?

**Owner: Qwen.  Model: `qwen3-coder`, medium effort, `--yolo`.**

**Test tier: RESEARCH. No `.gd` is touched, so there is NO parse gate and NO
Godot test. `python research/Q122_check.py` is your only gate and it must
exit 0. `git status -s` before staging is the whole other check.**

---

## WHY THIS EXISTS

S37 is building a SHARED ANCHOR: one point per frame, derived from a real
paired capture, that both fighters' arms are driven to. The anchor only means
anything on frames where the two men are actually in contact — everywhere else
it must be switched off.

So before a line of that is wired, somebody has to answer: **on which frames,
in which captures, are they holding each other at all?** A mechanism scaled by
a state nobody counted is how this project has twice shipped a silent global
nerf, and the census that catches it costs one file and one run.

There is a second reason, and it is the one that makes this urgent. We have been
using **exactly one** of these captures — `18/19_05` — as the fixture for every
grip measurement. There are five more on disk and nobody has looked at them.

---

## THE DATA, AND IT IS ALL IN THE REPO

`AssetLibrary/cmu_paired/` holds CMU paired motion capture: `.asf` skeletons and
`.amc` motion files. Two subjects were captured **simultaneously in one world
space**, so their positions are directly comparable — this is not two clips
composited, it is one recording of two people.

`Tools/cmu_asf_amc.py` reads it. The functions you need:

```python
import sys; sys.path.insert(0, "Tools")
import cmu_asf_amc as C

asf_a, asf_b, amc_a, amc_b = C.load_pair("18", "19", "05")   # subjects, trial
pa = C.joint_world_positions(asf_a, amc_a[frame_index])      # {joint: (x,y,z)} in METRES
C.dist(pa["lwrist"], pb["lradius"])                          # metres
C.percentiles(sorted(values))                                # {0:…, 10:…, 50:…, 90:…, 100:…}
C.skeletons_differ(asf_a, asf_b)                             # proves the two men are not identical
```

**The six pairs that load** — and all six go in the census, including the ones
with no contact, because a trial that never grips is the control that proves the
measure discriminates:

```
("18","19","03")  ("18","19","04")  ("18","19","05")
("18","19","06")  ("22","23","01")  ("22","23","17")
```

`17_10` has no partner file in the repo. Leave it out; do not invent it.

---

## WHAT TO MEASURE

**The contact is a HAND on the other man's ELBOW.** In CMU the elbow is the
distal end of the humerus, which is where `lradius` / `rradius` begins. Use
`lwrist` / `rwrist` for the hand — **not `lhand`** — because `lwrist` is the
bone our rig's `LeftHand` is mapped from, so it is the figure that will still
mean something after retargeting. (They differ: `lhand` reads about 1 cm closer.
Say so in the memo if you like, but census the wrist.)

**Both directions count.** Either man may be the gripper, so consider
A-hand→B-elbow *and* B-hand→A-elbow, and take the minimum over all of them as
that frame's separation.

For **every frame** of **every one of the six trials**, compute that minimum
separation. Then per trial:

| column | meaning |
|---|---|
| `subject_a`, `subject_b`, `trial` | e.g. `18`, `19`, `05` |
| `frames` | `min(len(amc_a), len(amc_b))` |
| `min_m`, `p10_m`, `p50_m`, `p90_m`, `max_m` | percentiles of the separation |
| `grip_frames` | frames at **≤ 0.20 m** |
| `grip_share` | `grip_frames / frames` |
| `episodes` | maximal RUNS of consecutive grip frames |
| `longest_episode_frames` | the longest such run |
| `dominant_pair` | most frequent argmin over the GRIP frames, written `A.lwrist->B.rradius` (or `none` if no grip frames) |
| `dominant_pair_share` | its share **of the grip frames**, not of all frames |

---

## DELIVER

**1. `research/Q122_CMU_CONTACT_CENSUS.csv`** — one row per trial, with
exactly the column names above as its header.

**2. `research/Q122_CMU_CONTACT_CENSUS.md`** — the memo, and this is the
part with the value in it. The CSV is arithmetic; the memo is the answer. It
must:

- **Name its population in its own output.** Which subjects, which trials, how
  many frames, which bones. A measurement that does not name its population
  cannot be told apart from a fixture later.
- **State that the two subjects in each pair are DIFFERENT skeletons**, and
  prove it with `C.skeletons_differ`. Two men built from the same numbers are
  not a control group, they are an unreal population — this is a standing rule
  in this project and it binds every fixture.
- **Answer: which trial should S37 use as its fixture, and why?** Rank them.
  The criteria are how many frames are in contact, how close the contact is, and
  whether the grip is one sustained hold or a flicker.
- **Answer: does the contact CHATTER?** If a 50%-gripped trial is forty short
  flickers, an anchor mask built on a single threshold will snap in and out and
  will need hysteresis. If it is one long hold, it will not. Your `episodes` and
  `longest_episode_frames` columns answer this — say what they mean out loud.
- **Answer: does the gripping limb SWAP mid-capture?** `dominant_pair_share`
  near 1.0 means one stable grip and one arm chain to drive. Near 0.25 means the
  contact wanders between limbs. **A low share is a FINDING, not a failure** —
  report it, do not chase it by moving the threshold.
- **Say which trials have no contact at all**, and name them as the controls
  they are.

---

## GATE

```
python research/Q122_check.py
```

**It must print `Q122 GATE: PASS` and exit 0.** It does not read your prose or
trust your arithmetic: it recomputes every headline figure straight from the
`.asf`/`.amc` files and requires your CSV to agree to **1 mm**, checks your
episode counts, checks your dominant-pair labels, and refuses a census that
finds a grip in every trial or in fewer than two.

**The gate was run against real input before it was given to you** (on the PC,
2026-09-21) — it refuses correctly when the CSV is absent and passes on a
correct one. So if it fails, the census is wrong, not the gate. Do not edit
`Q122_check.py`; it is not yours.

---

## OWNED FILES

- `research/Q122_CMU_CONTACT_CENSUS.csv` — **NEW, yours**
- `research/Q122_CMU_CONTACT_CENSUS.md` — **NEW, yours**
- a scratch script to generate them — put it in
  `research/q122_census.py` so the work is reproducible

**DO NOT TOUCH** `Q122_check.py`, `Tools/cmu_asf_amc.py`, anything under
`Godot/scripts/`, `Godot/tests/`, or `HANDOFF.md`.

---

## COMMIT

- `git status -s` FIRST — shared checkout, another agent's WIP may be pre-staged
  and `AgentComms/messages/` must never ride your commit.
- `git add -- research/Q122_CMU_CONTACT_CENSUS.csv research/Q122_CMU_CONTACT_CENSUS.md research/q122_census.py`
- Verify with `git show --stat HEAD`.
- Push to `qwen/q122-contact-census`.
- One line back:
  `python Tools/agent_comms.py send --from qwen --to claude --subject q122-ready --body "<commit hash, the gate's PASS line, and which trial you recommend as the fixture>"`
- **DO NOT EDIT `HANDOFF.md`.**

---

## THE ONE TRAP FOR THIS TASK

**A joint-name typo prints a confident 0.000 instead of an error.** This exact
family has now cost six passes here: a probe read `entry['landed']` where the
log carries `contact`, and then region `'head'` where the vocabulary says
`head_neck`, and reported zero landed strikes in a hundred bouts that plainly
produced 21 KOs. **`joint_world_positions` returns a dict — a missing key is a
`KeyError` if you index it and a silent `None` if you `.get()` it.**

So before you census anything, print the joint names the reader actually returns
for one frame, and confirm `lwrist`, `rwrist`, `lradius` and `rradius` are all
in there. A census built on a name that does not exist will produce a clean CSV
full of numbers that mean nothing, and the gate will tell you it disagrees
without telling you why.
