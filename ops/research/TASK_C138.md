# TASK_C138 — the long BJJ script: many continuous moves, and four cameras that never cross the line

**Agent:** Codex · **Model:** gpt-5.6-luna · **Effort:** MEDIUM (the only setting) · **Fast:** off
**Branch:** `codex/c138-bjj-long-script` · **Worktree:** the MAIN checkout
**Read this file and nothing else.** Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest. Do not explore to "get oriented".

---

## WHY YOU ARE DOING THIS — THE OPERATOR ACCEPTED C137 AND ASKED FOR MORE

C137 put ONE synchronised two-fighter BJJ sequence into FightCamp and recorded it. The operator
watched that recording and ruled, **verbatim**:

> **"this is pretty good ! need more movements"**

and, separately, on the four-angle still C134 rendered as evidence:

> **"we can use 4 cameras like in the video for the fight coverage if that helps with camouflaging
> animations"**

**That is the whole brief. The contact is GOOD ENOUGH — stop polishing it.** Do not iterate poses,
do not chase forearm clearance, do not re-author wrist contact. Those were C134's job and the
operator has set the bar above them. **What is missing is LENGTH AND CONTINUITY: a long script of
moves running into one another, and a camera that can cut between them.**

---

## PART 1 — THE LONG SCRIPT

Build and record **ONE continuous ground sequence of AT LEAST SIX paired beats** playing in
FightCamp, each flowing into the next with no visible reset between them.

**WE OWN SIXTEEN PAIRED FILMS AND NINE ARE BOUND.** The nine bound grapple ids and their films are
in `Godot/scripts/FightClipBinding.gd`, `const PAIRED_BINDINGS` (starts around `:882`). As of
2026-09-20 they are:

| grapple id | film (`_Att` / `_Vic` in `Godot/assets/anim/audition/ramsterz/`) |
|---|---|
| `grapple_throw` | `Paired_FullMount_Takedown_BodyLock_Start` |
| `grapple_takedown` | `Paired_FullMount_Takedown_DoubleLeg_Start` |
| `grapple_control` | `Paired_FullMount_Takedown_BodyLock_Loop` |
| `grapple_sweep` | `Paired_FullMount_Reversal` |
| `grapple_submission_attempt` | `Paired_FullMount_H2H_ArmBar` |
| `grapple_submission_finish` | `Paired_FullMount_H2H_Strangle` |
| `grapple_escape` | `Paired_FullMount_PushOff` |
| `grapple_clinch_break` | `Paired_FullMount_PushOff` |
| `grapple_stand_up` | `Paired_FullMount_Takedown_BodyLock_End` |

**VERIFY THAT TABLE AGAINST THE FILE BEFORE YOU USE IT. A TASK FILE'S TABLE CAN BE STALE** — this
project lost a render once to a brief that listed seven clips as unbound when three already were.
Read `PAIRED_BINDINGS` yourself and work from what is actually there.

**A CHAIN THAT USES WHAT WE OWN**, offered as a starting point and not an instruction — if reading
the bindings suggests a better order, take it and say why:

```
throw (BodyLock_Start) -> control (BodyLock_Loop) -> ground strikes (H2H_Punches, bound as
mma_guard_gnp) -> sweep (Reversal) -> submission attempt (ArmBar) -> submission finish (Strangle)
```

with `escape (PushOff)` and `stand_up (BodyLock_End)` available as alternative endings.

**FOUR FILMS ARE REFUSED AND ARE NOT AVAILABLE TO YOU. DO NOT BIND THEM AND DO NOT ASK AGAIN.**
`1HM_AxeToFace`, `1HM_BluntSmack`, `1HM_KnifeStab` and `1HM_SlashNeck` are weapon animations and no
ruleset this game simulates permits them. `H2H_HeadSmash` is a head driven into the canvas —
refused on content, do not even open it. `AttackBlock` and `VictimAttack` are refused for reasons
recorded elsewhere; leave them alone.

**WHAT "CONTINUOUS" HAS TO MEAN, and it is the whole difficulty:** each film ends in some pose and
the next begins in another. The sequence is only continuous if the JOIN between two films reads as
one movement. The operator's standing direction on this, verbatim from 2026-09-13, is
*"transition between animations needs to feel normal, natural, study ufc fights videos if you need
to, do whatever it takes to have that realism"*. **Measure each join** — the attacker's and
victim's hip and hand positions on the last frame of film N against the first frame of film N+1 —
and report the discontinuity in metres per join. A join with a large jump is the thing to fix, or
to cut away from (see Part 2).

## PART 2 — FOUR CAMERAS, AND THE ONE RULE THEY MUST OBEY

Add a four-camera coverage mode to the recording and cut between the cameras across the sequence.

**ALL FOUR CAMERAS STAY ON ONE SIDE OF THE FIGHT LINE.** This is not a preference, it is the
project's standing camera ruling (S7, decided 2026-09-18, OPTION C — *constrain the camera*: keep
the 3D room, broadcast grammar, **stay one side of the fight line**, a hard cam by default, and
**cut HIGH for ground work**). The four-angle sheet C134 produced BREAKS this rule — one of its
four views is from the far side — and that is the shot that makes a viewer think the two men swapped
places. **Four cameras means four positions within a 180-degree arc, never a ring of four.**

Given the ruling's "cut HIGH for ground work", a defensible set is: a hard cam at chest height, a
high three-quarter, a low three-quarter, and a top-down — all within the same 180-degree arc. Pick
what reads best and say why.

**TWO THINGS THE CAMERA CANNOT DO, so do not claim them:**

1. **A cut cannot hide a join it lands in the middle of.** Cut on the boundary BETWEEN two films,
   not during one.
2. **The room runs on a 0.30 s median beat.** A cut needs a beat to breathe on either side. Cutting
   every 0.3 s is a strobe, not coverage. Your sequence is a scripted set piece rather than the
   live beat stream, so you have more room than that — but say what cut rhythm you used, in
   seconds, and do not go below about 1.5 s per shot without a reason.

## DELIVERABLES

1. **A recording of actual in-game playback** — the long sequence, with the four-camera cutting,
   at 30 fps. Put it at `research/C138_RECORDING.mp4` and **do NOT commit the video** (this
   repo tracks no video and has no LFS rule for one). Commit its **sha256** in the measurements
   file instead, exactly as C137 did.
2. **`research/C138_MEASUREMENTS.json`** — per beat: the film key, start/end seconds, frame
   count, the pair clock drift, and **the join discontinuity in metres** (attacker hips, victim
   hips, attacker hands) between that beat and the next. Plus the cut list: shot index, camera
   name, start second, duration.
3. **A four-angle still** of one good moment, as `research/C138_FOUR_ANGLES.jpg`, so the
   operator can judge the coverage without playing the video.
4. **`research/C138_BJJ_LONG_SCRIPT.md`** — at most 120 lines. What you built, the chain you
   chose and why, the join table, the cut rhythm, and **what still looks wrong**. Say it plainly:
   a delivery that claims acceptance it has not earned is worse than one that names its defects.

## GATE — THIS IS A TIERED GATE, DO NOT RUN THE FULL SUITE

```
python Godot/tools/check_scripts.py <each .gd you touched>
python Godot/tools/run_tests.py --only c134
python Godot/tools/run_tests.py --only clip
python Godot/tools/run_tests.py --only pair
python Godot/tools/run_tests.py --only grapple
```

**`fight_pair_live_test` IS RED ON PURPOSE** — the authored jab pair is parked by an operator
ruling of 2026-09-15. It is a baseline red, not your regression. Everything else in those four
subsets must be green, or say which is not and why.

**The full suite is Claude's, once, at integration. Do not run it — it is 312 tests and about
forty minutes, and running it here buys nothing.**

## HOW TO WORK

- **Commit after each step, to `codex/c138-bjj-long-script`. An honest partial beats an
  uncommitted whole.** A previous run of yours hit a usage limit having committed nothing in 189k
  tokens and only luck saved the work.
- **Stage explicit paths on every commit** (`git add -- <files>`), never `git add -A`, and check
  `git status -s` first — another agent's work-in-progress may be pre-staged in this shared
  checkout. Confirm with `git show --stat HEAD` after each commit.
- End every commit message with `Co-Authored-By: Codex <noreply@openai.com>`.
- **Do NOT edit `HANDOFF.md`.** Claude writes your block.
- When you are done, send ONE line:
  `python Tools/agent_comms.py send --from codex --to claude --topic "C138 ready" --message "<one line>"`
  (the CLI takes `--topic`, not `--subject`).

## THE ONE TRAP SPECIFIC TO THIS TASK

**A paired film's two halves must be placed by the SAME transform, and retargeting silently drops
root travel.** C134 proved it and it is the reason its armbar never looked right: the source
attacker's hips travel **1.020 m in X and 0.844 m in Z**, and the live graft strips both to zero,
so the attacker arrives at the lock 0.474–0.757 m away from where the film put him. Your chain
strings SIX of these together, so that error accumulates. **Measure the attacker's hip travel in
the source film and in the live graft for every beat, and report both**, even where the beat looks
fine — a join that reads correctly on one camera and is 0.5 m out on another is exactly what four
cameras will expose.
