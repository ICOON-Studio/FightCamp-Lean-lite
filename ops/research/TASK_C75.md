# TASK C75 — CODEX — WHERE ELSE A FIGHT'S CLIPS CAN COME FROM, AND AT WHAT LICENCE

**Model: Codex, high effort, Fast mode OFF.** Owner: Codex.
Assigned 2026-09-10 by Claude. **Research only — no `.gd` files, no test.**

Read this file and nothing else. Do NOT read `HANDOFF.md`, `CURRENT_STATUS.md`,
`HANDOFF_ARCHIVE.md` or any digest. The one background file you MAY read is
`research/R94_ANIMATION_SPIKE.md` (short) — it is the measurement this
task follows from and it saves you re-deriving anything.

## Why you are being asked

R94 measured the paid path and it is cheap: **0.2 credits per clip**, one clip
serves all twelve fighters, no BoneMap. Two things make the alternative worth
costing anyway, and only the second is urgent:

1. The operator asked directly whether we can do this without paying.
2. **R94's finding 1: the paid library cannot show our grapple model at all.**
   97 combat clips and exactly ONE of them is grappling (`Grab & Throw`) — no
   takedown, no guard, no pass, no mount, no sweep, no submission. R91/R92/R93
   built that whole model into the engine. So we may have to source grappling
   somewhere else regardless of price, and that is the real question.

## The one fact that makes this answerable

Our twelve fighters are rigged to **Godot's `SkeletonProfileHumanoid`** — 22
bones, profile names exactly (`Hips`, `Spine`, `Chest`, `UpperChest`, `Neck`,
`Head`, `Left/RightShoulder`, `…UpperArm`, `…LowerArm`, `…Hand`, `…UpperLeg`,
`…LowerLeg`, `…Foot`, `…Toes`), 0 bones outside the profile. **They are not
locked to any vendor.** Any humanoid clip source can drive them; the integration
cost is a ten-line track-path rewrite, once, whatever the source.

So do not evaluate sources on "can it be made to work". Evaluate them on
**coverage, licence and quality**.

## What to deliver

`research/C75_ANIMATION_SOURCES.md`. Every claim carries a link and a
date, because licence terms are exactly the kind of thing that has changed since
anyone's training data.

### §1 — The candidates, costed

For each realistic source of humanoid combat motion, answer the same five
questions in the same shape so they can be compared in one table:

- **Cost** — free, subscription, per-clip, or per-seat.
- **Licence for a COMMERCIAL game**, quoted, with the clause and the URL. This
  is the section that decides everything and the one most likely to be wrong
  from memory. If a source's terms are ambiguous, say ambiguous — do not
  resolve it in our favour.
- **Format and rig** — what it exports, what skeleton it uses, and how far that
  is from `SkeletonProfileHumanoid`.
- **STRIKING coverage** — how many usable clips for boxing/MMA/muay thai:
  punches by name, kicks, knees, elbows, blocks, parries, hit reactions by
  region, knockdowns, a KO.
- **GRAPPLING coverage** — takedowns, throws by class, guard, half guard, side,
  mount, back, passes, sweeps, submissions, ground-and-pound. **Count them.**
  This is the column that matters.

Cover at least: Mixamo, a mocap archive of the CMU/academic kind, the paid asset
stores (Unity Asset Store, Unreal Marketplace/Fab, itch.io) treating "an MMA
animation pack" as one candidate rather than listing products, and one
text-to-motion research option (MDM / MoMask / T2M-GPT class) so the model-API
answer is on the record with its real quality caveat.

### §2 — The model-API answer, on the record

The operator's question named Stable Diffusion and ElevenLabs specifically. Say
plainly, once and without hedging, what those two categories do and do not
produce, so the question is settled and never re-asked. Then give the honest
state of the category that DOES apply — text-to-motion — including what it emits
(SMPL and friends), what retargeting that then needs, and whether anybody is
shipping combat motion from it.

### §3 — The grappling verdict

The decision this study exists to inform: **can a ground fight be shown at all,
from any source, at a price we would pay?** Three possible answers and all three
are acceptable deliveries — say which, and why:

- yes, from source X, at cost Y;
- only partly, so the ground game is presented rather than animated;
- no, and a 3D grappling fight is out of scope until something changes.

### §4 — What you would NOT chase

The most useful half. A source that is free but needs a per-clip cleanup pass is
not free. Say which candidates look attractive and are not, and why — the same
call the operator made on corner rules, where genuine per-jurisdiction detail was
deliberately collapsed because no player would ever see it.

## Owned files

- `research/C75_ANIMATION_SOURCES.md` (new) — and nothing else.

Do not touch any `.gd` file, any asset, `HANDOFF.md`, `TASKS.md` or
`CURRENT_STATUS.md`. Claude writes your block.

## Test tier — NONE

Research task, no `.gd` touched: **no parse gate, no test.** `git status -s`
before staging is the whole check. Stage explicit paths only — the tree is
shared and Qwen and Cursor are both working in it right now.

## Land it

1. `git status -s`, then `git add -- research/C75_ANIMATION_SOURCES.md`.
   Never `git add -A`, never `git stash`, `reset --hard`, `checkout .` or
   `clean`.
2. Commit and push `master`, trailer `Co-Authored-By: Codex <noreply@openai.com>`.
3. One line of mail:

```
python Tools/agent_comms.py send --from codex --to claude --topic C75-done --body "<commit> — the grappling verdict in one sentence, the cheapest source that clears a commercial licence, and the one candidate you would NOT chase"
```

## The trap

**Do not recommend a source whose licence you could not quote.** "Free for
commercial use" repeated from memory is exactly the kind of claim that survives
until a lawyer reads it, and this project's standing rule is that an invented
number which looks sourced is worse than an admitted gap, because we build on
it. If you cannot find and quote the term, the deliverable for that row is
"terms not verified" — which is a real finding and will be read as one.
