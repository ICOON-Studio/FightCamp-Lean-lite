# TASK C94 — CODEX — AUDIT THE 32 LOCOMOTION CLIPS BEFORE WE BUY FOUR MORE

Model: gpt-5.6-luna, **medium effort — never high**. Owner: codex.
Test tier: **ONE NEW TOOL AND ONE REPORT. NO SHIPPED `.gd` IS EDITED, NO TEST IS
TOUCHED.** Parse gate the tool, run it, write the report. **Do NOT run the full
suite** — it is Claude's, once, at integration. **Only one Godot at a time in
this checkout.**

```
python Godot/tools/check_scripts.py Godot/tools/audit_locomotion_content.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/audit_locomotion_content.gd
```

## Owned files

- `Godot/tools/audit_locomotion_content.gd` — **NEW. Yours alone.**
- `research/C94_LOCOMOTION_CONTENT.md` — **NEW. Yours alone.**

Nothing else. Do **NOT** edit `audit_striking_content.gd`, `FightClipBinding.gd`,
any script under `Godot/scripts/`, any test, or `HANDOFF.md`. `GameState.gd` is
12,938 lines — you do not need it, never open it.

## Why this exists

The two fighters stand at a fixed distance for three rounds and never move.
M18 (Maria) priced the fix and **recommended BUYING four clips**: `loc_fwd`,
`loc_back`, `loc_circle_l`, `loc_circle_r`, shaped as a boxer shuffle/bounce-step
and explicitly **never a walk or a run**.

**BUT THE SHELF ALREADY HOLDS 32 LOCOMOTION CLIPS** in
`res://assets/anim/audition/ramsterz_h2h/` — WalkForward / WalkBack / WalkLeft /
WalkRight, the four walk diagonals, the same eight as Run, SprintForward,
Turn180 / TurnLeft90 / TurnRight90, and a `_RootMotion` variant of most of them.
They are very probably the WRONG SHAPE. **They are also already paid for.**

**Nobody has measured any of them.** C92 measured 71 striking clips (and its
filter list was short the word "jab", which cost us the single most-thrown clip
in the game — that is fixed now and the tool selects 73). **The locomotion clips
were never in scope at all.** So the buy/don't-buy decision is currently being
made against a shelf nobody has looked at, which is how two of the last four
stages bought something out of a number somebody quoted rather than measured.

**THIS TASK IS THE MEASUREMENT. IT IS NOT THE DECISION.** Claude and the operator
decide what to buy; you tell them what is on the shelf.

## The instrument

**READ `Godot/tools/audit_striking_content.gd` FIRST — it is yours, you wrote it
as C92, and it already solves every hard part of this.** Reuse its structure:
first-key/last-key content window, virtual forward kinematics off the Animation's
own TRACK VALUES, its `PARENT_BY_BONE` and `HUMANOID_BONES` tables.

**THE TRAP YOU ALREADY KNOW: `Skeleton3D.get_bone_global_pose()` RETURNS THE REST
POSE IN A HEADLESS RUN.** Your own C92 header says so. Never ask the skeleton;
sample the tracks.

### What to measure, per clip

1. **`file_s` / `content_s` / `dead_air_s`** — exactly as C92 defines them. A
   bought clip's `length` is not its content length; that is still the most
   expensive finding of the last five stages.
2. **`cycle_s`** — is this a LOOP, and how long is one cycle? Compare the first
   keyed pose to the last keyed pose the way `measure_r110_ladder.gd` does
   (largest bone rotation between them). **Near zero means it returns to where it
   began, which is what makes it loopable.** A locomotion clip that does not loop
   is a one-shot step, not a cycle, and that changes what it can be used for.
3. **`travel_m` and `speed_ms`** — how far the pelvis moves from first to last
   sample, and that distance divided by `content_s`. **THIS IS THE ROW THAT
   DECIDES THE TASK.** M18 measured the mean ring speed at **0.6 m/s** (Thomson).
   A clip that travels at 1.4 m/s is a walk and will not rate-match to a boxer
   moving at 0.6 without visibly skating.
4. **`bob_m`** — the pelvis's vertical range across the cycle. M18 says a
   minimum **4-6 cm** of centre-of-mass bob is what sells an athletic guard
   bounce rather than a flat shuffle. Report the number; do not judge it.
5. **`_RootMotion` PAIRS: DOES THE PAIR AGREE?** Where both `X.FBX` and
   `X_RootMotion.fbx` exist, measure both and report whether the root-motion
   variant carries the translation that the plain one does not. **G42 says the
   ENGINE owns translation and the clips are in-place**, so the plain variant is
   the one we would use — but if the plain variant ALSO travels, that is a
   finding, because it means the clip fights the engine for the same job.

Print one machine-readable `C94_CLIP ...` line per clip with every field, plus a
`C94_TOTALS clips=N ...` line. Skip nothing silently: print a `status=` for any
clip you could not read, exactly as C92 does.

### Scope

Every `.fbx` / `.FBX` in `res://assets/anim/audition/ramsterz_h2h/` whose name
begins `H2H_Walk`, `H2H_Run`, `H2H_Sprint` or `H2H_Turn`, **including the
`_RootMotion` files** — which C92 deliberately excluded and which are the point
here. That should be 32 files. **If it is not 32, report the number you actually
found and do not adjust the filter to reach 32.** A count quoted in a task file
is not a measurement; two task files carried a wrong paired-clip count forward
last week and a whole audit was nearly done against a quarter of the pack.

## The report

`research/C94_LOCOMOTION_CONTENT.md`. Lead with the decision table, then
the raw rows:

| clip | content_s | dead_air_s | loops? | travel_m | speed_ms | bob_m |

Then a short section headed **"AGAINST M18'S 0.6 m/s"**: how many of the 32 sit
within, say, ±25% of 0.6 m/s, how many are far above it, and which four clips —
if any — come closest to serving as `loc_fwd` / `loc_back` / `loc_circle_l` /
`loc_circle_r`. **State that as a measurement, not as a recommendation to buy or
not buy.** One sentence saying which of the two the numbers favour is welcome;
a paragraph arguing for it is not your call.

**LABEL EVERY CLAIM**: `MEASURED` for anything your tool printed, `INFERENCE` for
anything you concluded, `NOT FOUND` for anything you could not determine.

## Done means

- `check_scripts.py` clean on the tool; the tool runs headless and prints a
  `C94_CLIP` line for every file it found.
- `research/C94_LOCOMOTION_CONTENT.md` written, decision table first.
- `git status -s` FIRST (another agent's WIP may be pre-staged), then
  `git add --` your two explicit paths only. Never `audio_exports/`.
- Commit your two paths ON the commit line (`git commit -m "C94: ..." -- <path1> <path2>`),
  ending `Co-Authored-By: Codex <noreply@openai.com>`. Then `git show --stat HEAD` must
  list exactly those two files. **Do NOT push, pull or rebase** (2026-09-13: this checkout
  is shared with a live Claude session holding uncommitted work; Claude pushes your commit).
- One line of mail:
  `python Tools/agent_comms.py send --from codex --to claude --topic C94-done --body "<hash> clips=<n> loops=<n> median_speed_ms=<n> within_25pct_of_0.6=<n> dead_air_s=<n>"`
- Do NOT edit `HANDOFF.md` — Claude writes your block.

## The one trap for this task

**A "walk" clip that measures 0.6 m/s is not thereby a boxer's step.** Speed is
necessary and not sufficient — M18's whole point is that the SHAPE is a
shuffle/bounce-step with a hip and shoulder counter-sway, and a walk cycle has
neither however slowly it is played. **Your job is to say what the numbers are,
including when they flatter a clip that is still the wrong shape.** If every one
of the 32 rate-matches beautifully, say so plainly and let somebody look at them
before that becomes a reason not to buy.

## GDScript traps

- `var x := <call>` fails when the call returns Variant — write the type.
- A `%` inside a format string must be `%%`.
- Reusing a variable name inside one function is a parse error even across
  separate `if`/`for` blocks.
- **Parse gate BEFORE the run.** A parse error does not fail a headless run, it
  HANGS it for 600 seconds.
- Use only
  `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe`. **You
  ran a chocolatey `godot.exe` on a previous task** — there is a second Godot on
  this machine and it is NOT the project's engine.
