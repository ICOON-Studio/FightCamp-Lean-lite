# TASK_U134 — CURSOR — WIRE THE POST-FIGHT RESULT BLOCK INTO THE REAL SCREEN

**Owner:** cursor
**Model:** `composer-2.5`, MEDIUM. `-p --force --trust --workspace <worktree>`
**Worktree:** `C:\Users\user\AppData\Local\Temp\FightCamp-U114`.
**Cut a FRESH branch off `origin/master` first** — the worktree sits on an old
branch, and `origin/master` now carries work that landed after U130.
**Test tier:** parse gate on every touched `.gd`, then
`python Godot/tools/run_tests.py --only ui`, then
`python Godot/tools/run_tests.py --only fight_result`. **`--only` DOES NOT
STACK** — one substring per invocation, and read `total=` to confirm how many
ran. **Do NOT run the full suite**; it is Claude's, once, at integration.

## WHAT YOU ALREADY BUILT, AND WHAT IS MISSING

U130 shipped `UIKit.result_block` (840×64) and `UIKit.causation_box` (840×148,
five 22 px slots, `_clip_measure_width` at 576 px), with tokens, five kit-book
variants and `Godot/tests/ui_post_fight_test.gd`. `--only ui` read
**total=17 fails=0**. That work is on `cursor/u130-post-fight-result` @
`930e9402`.

**Nothing calls either of them.** They are kit components with a kit book and no
consumer. U134 is the wiring.

## FIRST: FIND OUT WHETHER U130 IS ON MASTER YET

Your branch may or may not have been merged by the time you start.

- If `UIKit.result_block` exists on `origin/master`, build on it.
- If it does not, **merge your own `cursor/u130-post-fight-result` into your
  fresh branch first**, say so in the digest, and carry on. Do not rewrite the
  components — they passed their gate.

**Check, do not assume.** A session that assumed its own earlier branch had
landed is how U130's factories ended up committed twice.

## WHAT TO BUILD

Wire both components into the post-fight result screen so a finished fight
actually renders them.

1. **Find the screen.** `FightResultPanel` is the name Maria's M29 art pack
   places against; confirm the real script and scene before editing.
   `grep -rn "FightResultPanel" Godot/scripts/` is the whole search.
2. **Feed `result_block` from the engine's own fight outcome** — winner, loser,
   method, round, time. **Derive these from the fight state, never from a
   string the screen already had.** If the outcome does not carry one of the
   five, that is a finding: report it and render what you have rather than
   inventing a value.
3. **Feed `causation_box` from whatever the engine names as the cause.** U130's
   contract says >5 bullets returns `null` and unknown methods return `null`
   with no `push_error` — **honour both**. A `null` means render nothing there,
   not crash and not a placeholder.
4. **A DRAW and an NC must render.** Both layouts exist in the component; prove
   both reach the screen.

## THE ART CONSTRAINT, WHICH IS ALREADY DECIDED

Maria's M29 corrected leave layout is **COMPUTED against `FightResultPanel`**,
not sketched: the eye-slot is the body with **ONE GREEN Continue, left foot, at
`VERDICT_X 96, y 776`**. Read
`research/M29_LEAVE_AND_CONTINUE.md` for that geometry and **do not move
it**. There is no rematch button, no share, no TALLY.

**The `WAY OUT` chrome is a SEPARATE slate** (`today → SCHEDULE`), not part of
this panel. Do not fold it in — that is a different surface and Kalli owns its
words.

## WHAT YOU MUST NOT DO

- **Do not invent a second Continue.** The dual-Continue defect is the named
  next stage and two independent agents converged on it; adding one here would
  land the exact bug we are about to remove.
- **Do not name the leave CTA.** Kalli owns that word and is writing it now
  (`TASK_FLOW_PASS4_CUTOVER.md`). If the screen needs a leave control to
  compile, use the existing string and leave a one-line comment saying the word
  is pending pass 4.

## Owned files

- The post-fight result screen script and its scene.
- `Godot/tests/fight_result_panel_test.gd` (new).
- `research/U134_DIGEST.md`.

Do **not** edit `UIKit.gd`'s `result_block` or `causation_box` bodies — they are
under contract from U130's test. If one of them is genuinely wrong, **report it
rather than changing it**.

## The trap specific to this task

**A `Control` with full-rect anchors must never have `size` assigned when it is
mounted.** With anchors at 0..1 that writes the OFFSETS and the node ends up
twice the parent — it has cost this project a fix cycle more than once. Let the
anchors fill it and pass the size down. Both U130 components are fixed-size
(840×64 and 840×148), so they are mounted INTO a filled parent, not as one.

## What already exists, so you do not rebuild it

`RESEARCH_INDEX.md` — 789 research documents, 220 tools, 116 drivers, one line
each. **GREP IT, NEVER READ IT WHOLE** (214 KB). Worth running:
`grep -i 'result panel\|post.fight' RESEARCH_INDEX.md` and
`grep -i 'M29\|G66' RESEARCH_INDEX.md`. **A negative result is a result.**

## Rules

- Never `git stash`, `git reset --hard`, `git checkout .`, `git clean` or
  `git add -A`. Stage explicit paths only.
- Commit, push your branch, write the digest, send one line with
  `python Tools/agent_comms.py send`. **Do NOT edit `HANDOFF.md`.**
