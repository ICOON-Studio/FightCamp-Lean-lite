# TASK Q48 — QWEN — ONE CLIP, TWELVE DIFFERENT BODIES

Model: Qwen CLI, medium effort. Owner: qwen.
**Reassigned from Kalli (K28) on the operator's call, 2026-09-11.** Kalli is out
of rotation; the study is still wanted. `TASK_K28.md` stays on disk as the
original — do not edit it.

Study. **No GDScript, no engine work, no test command.**
Test tier: **RESEARCH, NO `.gd` TOUCHED — NO GATE AT ALL.** Not the parse gate,
not a test. `git status -s` before staging is the whole check.

## Owned files

- `research/Q48_ONE_CLIP_TWELVE_BODIES.md` — **NEW. Yours alone.**

Nothing else. Do **not** edit `HANDOFF.md`, `CURRENT_STATUS.md`, any other task
file, or any script. Do not read `HANDOFF.md`, `HANDOFF_ARCHIVE.md` or any
digest, and do not explore the repository to "get oriented" — this task is
self-contained and the repo has nothing you need.

## Why this exists

We have twelve rigged 3D fighters and we have bought a small set of shared
animation clips. **One clip, retargeted onto all twelve, costs us nothing extra —
that is the whole reason the plan is affordable.** The clips are mesh-free, and
their 22 bones already match the standard humanoid profile, so there is no
per-fighter conversion cost. That much is measured and settled.

But the twelve are not the same body. They span a flyweight woman and a
heavyweight man — different heights, different limb lengths, different mass. The
clip does not know that. **This study answers what breaks, and what shipped games
do about it.**

## The questions

1. **What actually goes wrong** when one animation plays on bodies of different
   size? Name the specific failure modes, not the general worry — feet sliding or
   sinking through the floor, a punch that lands short or passes through the
   opponent's head, hands clipping into the torso, a stance that reads correctly
   on one build and bow-legged on another. For each, say **whether it is visible
   at our camera distance**: our fight camera sits **9–11 m back, 3.8–4.2 m up,
   at a 20 degree downward pitch**, shooting over the ropes. A defect nobody can
   see at that distance is not a defect we should pay to fix.
2. **Height disparity between the two fighters.** Two men on a canvas, one 165 cm
   and one 195 cm, both playing the same in-place punch clip aimed at "head
   height". Where does the taller man's fist actually go? What do games do —
   scale the clip, aim with IK, ignore it, or forbid the matchup?
3. **What shipped games actually do.** Boxing and MMA titles have solved this; so
   have team sports games with wildly different body sizes. Which approach wins
   in practice: retarget-and-accept, per-size clip sets, procedural correction,
   or constraining the roster so bodies do not differ much?
4. **The cheap fixes, ranked.** If we do nothing, how bad is it? If we do ONE
   thing, what is the highest-value single fix — foot planting, a hand-aim IK
   chain, uniform scaling of the whole clip, or simply matching each fighter's
   height to a small number of body archetypes?
5. **Does weight class save us?** Our booking already matches weight classes, and
   females never fight males. So the two bodies on the canvas are always roughly
   similar. **Does that constraint make most of this moot?** Answer honestly — if
   the answer is "yes, and you are worrying about a case your own rules already
   prevent", **that is the most valuable finding in the study and it belongs in
   the headline.**

## Standards

- **Use web search.** This is a literature question, not a reasoning exercise.
- Cite sources: animation-programming references, retargeting documentation, GDC
  talks, engine documentation on humanoid retargeting and IK.
- **Separate DOCUMENTED from FOLKLORE from your own INFERENCE, and label each.**
  The last study we commissioned did exactly this and it was the most useful
  thing about it.
- **Mark what is not published as NOT FOUND.** Do not derive a tolerance and
  present it as a measured one. An honest "nobody publishes this" is worth more
  than an invented number, and we will act on the difference.
- Do not write GDScript and do not propose an implementation in code.
- Rank recommendations by cost. We are optimising for the smallest amount of work
  that makes the fight read correctly, not for correctness in the abstract.

## Deliverable shape

A **DECISIONS** section at the very top — short typeable lines Claude can act on
without reading the body, including a one-line answer to question 5. Body and
citations below. Be concise; a long study is not a better study.

## Deliver

Stage **only your own file**:

```
git add -- research/Q48_ONE_CLIP_TWELVE_BODIES.md
```

Never `git add -A`, and never stage `audio_exports/`. Check `git status -s`
first — another agent's work in progress may be pre-staged in this shared
checkout. **Never `git stash`, `reset --hard`, `checkout .` or `clean`** here: a
concurrent session's `git stash` once wiped an entire finished stage off disk.

Commit, push to `master`, then send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --subject Q48-done --body "<sha> <one-line answer to question 5>"
```

Do **not** edit `HANDOFF.md` — Claude writes your block.
