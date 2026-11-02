# TASK_C139 — chain the transforms, walk them in, bow, and cut instead of splitting

**Agent:** Codex · **Model:** gpt-5.6-luna · **Effort:** MEDIUM (the only setting) · **Fast:** off
**Branch:** `codex/c139-walk-in-and-chain` (cut from `codex/c138-bjj-long-script`)
**Worktree:** `C:\Users\user\AppData\Local\Temp\FightCamp-C134`
**Read this file and nothing else.** Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest. Do not explore to "get oriented".

---

## THE OPERATOR'S RULING, AND IT REVERSES WHAT C134/C135/C137 WERE OPTIMISING

Verbatim, on C138's recording:

> **"i dont mind too much if some body parts intertwine but the movements need to be accurate"**

**MOTION ACCURACY IS THE GATE. INTERPENETRATION IS TOLERABLE.** C134 spent four pose iterations on
forearm clearance, wrist contact and torso pressure and stopped at a "side visual gate" over
exactly those. That was the wrong thing to spend on. **Do not re-author a single contact pose in
this task.** If a hand passes through a shoulder and the movement reads correctly, ship it.

And on C138 specifically:

> **"the first 5 seconds are incoherent"**

They are, and Part 1 is why.

---

## PART 1 — THE TRANSFORM CHAIN. THIS IS THE WHOLE FIRST FIVE SECONDS AND IT IS TWO LINES.

`Godot/tools/c138_sequence_review.gd` captures the spawn transforms ONCE, before beat 1:

```gdscript
initial_roots = [room.get("_node_a").transform, room.get("_node_b").transform]
```

and then, at the top of **every** beat:

```gdscript
room.get("_node_a").transform = initial_roots[0]
room.get("_node_b").transform = initial_roots[1]
```

**The chain never chains.** Every beat is staged from the same spawn marks instead of from where
the previous beat left the two men. Beat 1 carries its 2.03 m of real travel across the mat; beat 2
then snaps both bodies back to the start line.

**THE MEASUREMENT PROVES IT RATHER THAN MERELY FITTING IT.** Your own
`C138_MEASUREMENTS.json`: the join 1→2 is **1.562 m** and beat 2's live graft travel is
**1.573 m**. That is ONE displacement counted twice — once as the teleport, once as the men sliding
back toward where they should have been. It is also why beat 1 is the only beat whose source travel
survives: it is the only beat that starts where it was placed.

**THE FIX: carry the PREVIOUS beat's END transform into the next beat.** Snapshot both root nodes
after the last frame of beat N and use that as beat N+1's base, instead of `initial_roots`. The
`place_paired_hold` / `_align_pair` correction then has a small residual to remove rather than a
metre-and-a-half jump it created itself.

**GATE ON THE NUMBER, NOT ON THE LOOK:** re-run the capture and report the same join table. **Every
join must come out below 0.30 m on attacker hips, and the 1→2 join specifically must be under
0.20 m.** If a join cannot reach that, say which and why, with the number — do not tune the
tolerance to pass.

---

## PART 2 — THE WALK-IN AND THE BOW (NEW, AND THE OPERATOR ASKED FOR IT BY NAME)

> **"i want to see the fighters at each side walking closer to each other, bow and then start the
> fight"**

Build an opening ceremony that plays before the first beat:

1. **Both men start at their own side of the mat**, apart, facing each other.
2. **They walk toward each other** and stop at the fight's opening range.
3. **They bow.**
4. **The fight starts** — the existing sequence takes over.

**WHAT WE OWN, AND WHAT WE DO NOT.**

- **The walk EXISTS and is already bound.** Eight measured locomotion clips are grafted and carry
  U84's measured direction and stride speed (`FightClipBinding.locomotion_roles()`; `loc_advance`
  is straight ahead). Use `loc_advance` and let the stride speed drive the distance — **do not
  slide a root at an invented speed under a walk cycle**, that is the foot-skate defect the foot
  lock exists to prevent.
- **The idle EXISTS**: `H2H_Idle.FBX`, bound as `idle` (`FightClipBinding.gd:193`) — hands up, no
  bounce. That is the pose to arrive in and to leave the bow into.
- **THERE IS NO BOW CLIP. WE OWN NONE.** I checked the whole audition tree: no bow, no salute, no
  glove touch. **So author it procedurally — and a bow is one of the very few animations that is
  honestly authorable without an animator, because it IS a hinge.** Rotate the spine/chest forward
  about the hip axis over roughly 0.8–1.2 s, hold briefly, return. Keep the head following the
  spine rather than counter-rotating. **Say in the digest exactly which bones you drove and by how
  many degrees** — an authored magnitude with no source must be labelled AUTHORED, never implied to
  be measured.
- **A GLOVE TOUCH IS ALREADY WITHIN REACH AND IS THE RIGHT GESTURE FOR SOME RULESETS.**
  `Godot/scripts/FightContactSolve.gd` (97 lines) already pushes a hand to a world-space target
  through `FightLegIK`'s analytic two-bone solve. A glove touch is exactly that: one world-space
  target per man, met in the middle. Build it if the bow lands cheaply; it is the authentic
  courtesy for boxing and MMA where a bow is not.

**PER DISCIPLINE, and this matters because the game simulates several:** bow for BJJ, judo and
Muay Thai; glove touch for boxing and MMA. If you only have budget for one, **build the bow** — the
operator asked for it — and leave a named seam where the glove touch goes.

**THE REFEREE IS NOT IN SCOPE.** Do not add one, do not mime one.

---

## PART 3 — CUT, DO NOT SPLIT

The operator asked whether splitting the screen into four on the ground would let us avoid the 3D
ground animation problems. **It does not, and it costs us the tool that is working.** A permanent
quad shows the SAME defect in all four cells at once — there is nowhere to cut *to* — and C138's
worst join is invisible today precisely BECAUSE one camera cut on it. A wide or top-down cell is
also the worst possible view for a positional error, because the mat grid gives the eye an absolute
reference.

**So keep C138's grammar, which was right:** four cameras, ONE on screen at a time, cutting only at
beat boundaries, all four inside the same 180-degree arc (S7's standing ruling — keep the 3D room,
broadcast grammar, stay one side of the fight line, hard cam by default, **"cut HIGH for ground
work"**).

**ADD ONE THING: a QUAD REPLAY.** After a submission attempt or a sweep, cut to a short four-up
replay of that beat alone — **2 to 3 seconds, and it must not span a join**. Short enough that no
discontinuity lands inside it, and it reads as deliberate broadcast language rather than a
workaround.

**AND FIX C138's FRAMING WHILE YOU ARE IN THERE.** The delivered top-down still frames two men as a
thumbnail on an empty mat. "Cut HIGH for ground work" does not mean cut to orbit. Frame the pair,
not the venue.

---

## DELIVERABLES

1. **`research/C139_RECORDING.mp4`** — the full thing: walk-in, bow, the six-beat chain with
   corrected transforms, four-camera cutting, one quad replay. **Do NOT commit the video**; commit
   its sha256 in the measurements file, as C137 and C138 both did.
2. **`research/C139_MEASUREMENTS.json`** — the join table again (attacker hips, victim hips,
   attacker hands, source vs live hip travel, pair clock drift) **before and after the chain fix**,
   so the improvement is a number rather than a claim. Plus the ceremony: walk distance per man,
   walk duration, stride speed used, bow bones and degrees, and the cut list.
3. **`research/C139_FOUR_ANGLES.jpg`** — this time genuinely FOUR panels of one moment, as
   C134's sheet was. C138 delivered a single top-down and called it four angles.
4. **`research/C139_WALK_IN_AND_CHAIN.md`** — at most 120 lines. What moved, the before/after
   join table, what is AUTHORED versus measured, and what still looks wrong.

## GATE — TIERED. DO NOT RUN THE FULL SUITE.

```
python Godot/tools/check_scripts.py <each .gd you touched>
python Godot/tools/run_tests.py --only c134
python Godot/tools/run_tests.py --only clip
python Godot/tools/run_tests.py --only pair
python Godot/tools/run_tests.py --only grapple
python Godot/tools/run_tests.py --only room_positions
```

`fight_pair_live_test` is RED ON PURPOSE (an operator ruling of 2026-09-15 parks the authored jab
pair) — a baseline red, not your regression. `fight_room_positions_test` is in the list because the
walk-in touches locomotion and that test gates the eight bound walks and the room's spacing; it was
rewritten on 2026-09-20 and is green at 24/0, so any red there IS yours.

**The full suite is Claude's, once, at integration. It is 312 tests and 18 minutes; do not run it.**

## HOW TO WORK

- **Commit after each step.** An honest partial beats an uncommitted whole. Part 1 is small and
  self-contained — commit it on its own, before you start Part 2, so the chain fix survives even if
  the ceremony runs long.
- **Stage explicit paths** (`git add -- <files>`), never `git add -A`; check `git status -s` first,
  and confirm with `git show --stat HEAD`.
- End commit messages with `Co-Authored-By: Codex <noreply@openai.com>`.
- **Do NOT edit `HANDOFF.md`.**
- Finish with one line:
  `python Tools/agent_comms.py send --from codex --to claude --topic "C139 ready" --message "<one line>"`
  (the CLI takes `--topic`, not `--subject`).

## THE ONE TRAP SPECIFIC TO THIS TASK

**A WALK THAT ARRIVES AT THE WRONG DISTANCE IS THE SAME BUG YOU ARE FIXING IN PART 1.** The men
must stop at the fight's real opening gap, and that gap is **derived, not chosen**: each man's
`FightIntent.preferred_range` is in ARM LENGTHS, so his own standoff in metres is that value times
`FightMoves.arm_length_m(his reach_cm)`, and the pair's opening separation is the mean of the two.
For the room's boxing pair (186 cm and 172 cm reach) that is **1.087 m** — measured and gated on
2026-09-20. **Do not pick a walk-in distance.** Compute it from the two men who are actually
fighting, print it in the measurements file, and let the stride speed decide how long the walk
takes rather than fitting the duration to a number you liked.
