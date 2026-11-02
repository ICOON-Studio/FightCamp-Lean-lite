# TASK Q56 — QWEN — THE HUNDRED AND THIRTY CLIPS THE GAME NEVER PLAYS

Model: your default, medium effort. Owner: qwen.
Test tier: **RESEARCH — NO `.gd` TOUCHED, SO NO GATE AT ALL.** No parse gate, no
test, no suite. `git status -s` before staging is the whole check.
**Do NOT launch Godot** — another agent is running tests in this checkout and
only one Godot may run at a time. This task needs none: everything you need is a
CSV and some `grep`.

## Owned files

- `research/Q56_THE_VOCABULARY_GAP.md` — **NEW. Yours alone.**

Nothing else. Do not edit `HANDOFF.md`, `CURRENT_STATUS.md`, `TASKS.md`, any
`.gd` file, or any other research doc.

## Why this exists

The operator's direction, today: **"I want to see as many animations as possible,
make the fighters intelligent with many skills available to them."**

Here is the position that direction runs into:

| | count |
|---|---|
| animation clips we OWN (Q47, two RamsterZ packs) | **160** |
| clip bindings the game actually plays (`FightClipBinding.BINDINGS`) | **30** |
| roles the 3D stage has a word for (`FightStageDirector.required_roles()`) | **10** |
| of those ten, roles with NO clip bound | **2** (`strike_body`, `strike_leg`) |
| paired two-body pairs owned | **16** |
| paired pairs bound | **0** |

**The bottleneck is not the clips and it is not the engine. It is the
vocabulary.** The stage can name ten things a body may do, all ten of them
striking, so a hundred and thirty owned clips have nowhere to be called from.

The engine, meanwhile, already scores far more than ten things. A grep of
`Godot/scripts/` finds `takedown`, `submission`, `submission_attempt`,
`submission_finish`, `clinch`, `clinch_break`, `mount`, `guard`, `sweep`,
`reversal`, `scramble`, `pass` — none of which the stage has a word for.

## THE QUESTION

**Build the three-column map: what the ENGINE emits, what we OWN, what is BOUND.**

### Column 1 — what the engine emits (DOCUMENTED, from the repo)

Every distinct technique / event word the fight engine produces that a presenter
could act on. Sources, and read ONLY these:

- `Godot/scripts/FightMoves.gd` — the technique table
- `Godot/scripts/FightStageDirector.gd` — the ten roles and the region/contact words
- `Godot/scripts/FightBeatAdapter.gd` — what a beat carries (see its lines 145-160,
  which state plainly that the ground fight does not come out of `advance_tick`)
- `Godot/scripts/GrappleAdapter.gd` — the grapple seats and awards
- `grep -n '_log_grapple' Godot/scripts/FightRealtime.gd` — the ten call sites
  that write grapple events; report the `kind` each one writes

**`FightRealtime.gd` is ~2,500 lines and `GameState.gd` is ~13,000 — do not open
either whole.** Use `grep -n` and `sed -n 'A,Bp'` windows.

### Column 2 — what we own (DOCUMENTED, from the CSV)

`research/Q47_INVENTORY.csv` is the authoritative inventory: 161 rows,
160 loadable clips. Read the CSV, not the asset folder. Group the clip names into
families (kicks, punches, blocks, dodges, footwork, staggers, ground) and give a
count per family.

### Column 3 — what is bound (DOCUMENTED)

`Godot/scripts/FightClipBinding.gd` — the `BINDINGS` const. 14 keys, 30 paths.

### THE DELIVERABLE: three lists, and they are the point

1. **ENGINE WORD WITH NO CLIP.** The engine scores it and we own nothing that
   shows it. This is a purchase list.
2. **CLIP WITH NO ENGINE WORD.** We own it and the engine never asks for it.
   This is the biggest list and it is the operator's answer — every row is an
   animation we paid for that cannot appear. **Say for each whether the engine
   could plausibly emit a word for it, or whether it is simply not this game**
   (`Equip`, `Unequip` and the weapon clips are not this game; `RoundhouseKick`
   and `GetUp` obviously are).
3. **BOUND BUT NARROW.** A role bound to exactly one clip, so it plays the same
   film every time. `react_head` is the known worst case — it was 5,525 of 9,715
   shown beats. Which roles have how many takes?

Finish with **one number stated plainly: how many of the 160 owned clips could be
on screen if the vocabulary were widened, and how many could never be.**

## HOW TO ANSWER

Label every claim **DOCUMENTED** (with `file:line`), **INFERENCE** (marked as
yours) or **NOT FOUND**. Your Q50/Q51/Q54/Q55 labelling was exactly right and it
is why those studies were usable.

Tables over prose. Keep it under ~200 lines.

## Definition of done

- `research/Q56_THE_VOCABULARY_GAP.md` exists with the three lists.
- `git add -- research/Q56_THE_VOCABULARY_GAP.md`, commit, push to master.
- Send one line:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q56-done --body "<sha> engine_words=N owned=160 bound=30 could_play=X never=Y"`

## The traps specific to Q56

1. **Do not run Godot.** Another Godot is running. You need none.
2. **Do not read `HANDOFF.md`, `CURRENT_STATUS.md` or any digest.** This file is
   self-contained and names every source you may read.
3. **Count from the CSV, not from the asset folder.** The folder holds meshes,
   props and a T-pose reference alongside the clips; Q47 already separated them
   and one of its 161 rows is a mesh with no `AnimationPlayer`. Do not report 161
   animations — report what the CSV says is loadable.
4. **A clip's family is not its filename.** `H2H_JabForward` and `H2H_JabInPlace`
   are one technique in two travel modes, and `_RootMotion` variants are duplicates
   of a clip we already counted. **Say how many DISTINCT techniques there are as
   well as how many files** — those two numbers are different and the second one
   is the one that sounds impressive and means less.
