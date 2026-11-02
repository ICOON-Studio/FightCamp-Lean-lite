# TASK_U122 — CURSOR — WHICH CLIPS LOSE DATA AT 30 Hz: THE BAKE-RATE CENSUS

**Owner: Cursor.  Model: `composer-2.5`, MEDIUM effort.**
Launch: `-p --force --trust --model composer-2.5 --workspace <your worktree>`.
**Unstage `AgentComms/messages` before you launch.**

**Test tier: NO GATE AT ALL beyond your own check script.** This run touches no
`.gd` file and boots no Godot, so there is no parse gate and no test.
`git status -s` before staging is the whole check. **DO NOT RUN THE FULL SUITE**
— it is 314 tests and twenty-five minutes, and it is Claude's gate at
integration, not yours.

**Owned files (yours, nobody else touches them this run):**
- `Tools/fbx_native_rate.py`  (NEW — the reader)
- `research/U122_check.py`  (REWRITE — your own gate, see below)
- `research/U122_BAKE_RATE_CENSUS.md`  (REWRITE — your report)
- `research/U122_fbx_rates.json`  (NEW — the machine-readable census)

**Delete `Godot/tools/census_clip_bake_rate.gd` and `research/U122_rates.json`
from your branch** — they implement the superseded method and would mislead the
next reader.

**You own NOTHING else.** Do not edit `Godot/scripts/FightClipRetarget.gd`.
If you find a clip whose behaviour contradicts this brief, that is a finding for
your report, not a fix.

---

## WHY THIS EXISTS

`GLTFDocument.generate_scene()` and `FBXDocument.generate_scene()` resample every
animation curve onto a `bake_fps` grid, and **the engine default is 30.** Any
clip authored above 30 Hz has been arriving in this project with the intervening
frames interpolated back in — the caller gets the sample count it asked for and
not the detail.

S39 measured what that costs on a 120 Hz motion capture: the closest approach in
the CMU 18/19_05 paired fixture reads **0.1455 m at 30 Hz against 0.1407 m at
120 Hz**. 4.8 mm, sitting directly on the figure that fixture is validated by.
On a *sustained* contact the same resample costs nothing to four decimals.
**A resample destroys single-frame extrema and leaves distributions alone**, which
is why nobody saw it for two stages.

`_load_fbx` now takes a `bake_fps` and both shipped callers still pass 30, so
nothing in the game has changed. **The open question is how much there is to
gain, and where.** That is this task: a census, not a fix.

---

## CORRECTION, 2026-09-21 — THE FIRST VERSION OF THIS TASK SPECIFIED A METHOD THAT CANNOT WORK

**This is my error, not yours.** Run 1 followed the brief exactly and produced a
census that is structurally wrong, so the method below has been replaced. Read
this section before anything else.

The original brief said: load each clip at 30 and at 240, count keys, and derive
`native_hz = keys_240 / length`. **That cannot recover a native rate**, because
`generate_scene()` interpolates **UP** as well as down — ask for 240 Hz and it
manufactures a 240 Hz grid out of whatever the file holds.

Proof, and it is the clip run 1 named as the headline finding:

```
combo_jab_cross_hook.glb
   in the FILE (glTF sampler input times):   75 keys, dt=0.033333, native  30.00 Hz
   loaded at bake_fps=240:                  593 keys                    "240.41 Hz"
```

It is a 30 Hz clip. It loses **nothing** at a 30 Hz bake. The census called it
the highest-rate file in the corpus and the big prize, and it is neither.

**The only way to read a native rate is from the source file's own key times.**
Run 1's `U122_rates.json`, `U122_check.py` and `U122_BAKE_RATE_CENSUS.md` are
superseded — the check script passed because it recomputed the same wrong
formula, which is what a gate that shares its subject's assumption always does.

**The GLB half is already done, by me, in Python, and you do not need to redo
it.** Reading glTF sampler `input` accessors directly over every `.glb` under
`Godot/assets/`:

```
GLB files: 64   with animation: 59   no animation: 2   single key: 3
   30 Hz : 55 files
  120 Hz :  4 files  — cmu_18_05, cmu_19_05, cmu_22_17, cmu_23_17, and nothing else
```

**Four files, and all four are the CMU paired captures.** Every other GLB in the
project is 30 Hz native.

---

## WHAT TO BUILD — THE FBX HALF, WHICH IS THE WHOLE REMAINING QUESTION

245 of the 309 animation files are `.fbx` and none of them are covered above:
`ramsterz_h2h` (124), `motifect/.../FBX` (40), `ramsterz` (37),
`magicpot_fm1` (43 incl. `nomove`), plus a handful elsewhere.

Write `Tools/fbx_native_rate.py` — **Python, not GDScript, and no Godot at
all.** For every `.fbx` under `Godot/assets/`, read the file's own timing:

- An FBX stores animation as `AnimationCurve` nodes holding a `KeyTime` array in
  **FBX time units of 1/46186158000 of a second**. The native rate is
  `1 / (median delta between consecutive KeyTimes, converted to seconds)`.
- Binary FBX (most of these) is a node-record tree with a 27-byte header
  starting ``Kaydara FBX Binary  ` followed by a NUL byte`. Parse the record structure and pull the
  `KeyTime` arrays; they are type `l` (int64 array), usually zlib-deflated.
  Handle the encoding flag.
- If a file is ASCII FBX, `KeyTime:` appears as plain text and is far easier.
- A file whose curves you cannot parse is reported `unreadable` **with its
  reason** — never silently dropped, and never guessed at.

Report per file: `path`, `keys`, `span_s`, `native_hz`, `loses_at_30`
(`native_hz > 31.0`), `status`. Write `research/U122_fbx_rates.json` with
those rows plus a `summary` of `total`, `parsed`, `unreadable`, `losing_at_30`.

**Do not load anything through Godot.** That is what produced the wrong answer.

### Sanity check you must include

`motifect/.../GLB` and `motifect/.../FBX` are **the same 40 clips in two
formats**. The GLB half is measured above and is uniformly 30 Hz. **Your FBX
reader must agree with it on those 40 files**, name them in the report, and any
disagreement is a bug in your reader, not a finding. That is a real control arm
and it costs you nothing — use it.

## YOUR OWN GATE — `research/U122_check.py`

Write a check script that **recomputes the verdict from `U122_fbx_rates.json`
independently** rather than re-reading the tool's own summary. **Run 1's check
script passed on a wrong census because it recomputed the same wrong formula —
so this one must go back to the FBX bytes, not to the JSON's own arithmetic.**
It must:

1. **Re-read the KeyTime deltas from the FBX itself for a random 10 rows** and
   fail if the stored `native_hz` disagrees by more than 0.5 Hz. This is the
   check that matters; the rest are arithmetic.
2. Fail if the 40 motifect FBX files do not all land within 0.5 Hz of 30.0 —
   their GLB twins are measured at 30 Hz and the two must agree.
3. Fail if any parsed row has `span_s <= 0` while `keys > 1`.
4. Recompute `loses_at_30` from `native_hz` and fail if it disagrees.
5. Recompute all four `summary` counts from the rows and fail on any mismatch.
6. Fail if `total` is under 240 — a census that silently walked half the tree is
   the failure mode this catches.

**The check must not import the tool or read its stdout.** A gate that learns
its answer from its subject cannot fail; this one derives every figure from the
JSON and the arithmetic.

---

## GATE — RUN EXACTLY THIS, IN THIS ORDER

```
python Tools/fbx_native_rate.py
python research/U122_check.py
```

**No parse gate and no Godot run — you touch no `.gd` file this time.**
`git status -s` before staging is the whole check.

Pass condition: the check script exits 0, the census covers at least 240 FBX
files, and the 40 motifect files agree with their GLB twins. **That is a floor,
not an equality.** If you parse all 245, say so.

---

## WHAT THE REPORT MUST ANSWER

`U122_BAKE_RATE_CENSUS.md`, short, and it answers exactly four questions.
**Report the GLB half as already-measured context (the four CMU files) and your
FBX numbers beside it**, so the document covers the whole corpus.

1. **How many FBX clips are above 30 Hz, and which families?** Group by
   directory — `ramsterz_h2h` (124), `motifect/FBX` (40), `ramsterz` (37),
   `magicpot_fm1` (43). **A family that is uniformly 30 Hz is as much a finding
   as one that is 120**, and on the GLB evidence that is the likely answer for
   most of them. Do not strain to find losers.
2. **Did the 40 motifect FBX files agree with their GLB twins?** Say so
   explicitly with the worst disagreement in Hz. This is your control arm.
3. **What is the highest native rate in the FBX corpus, and on which file?**
4. **Which of the losing clips are actually BOUND and played?** Grep
   `Godot/scripts/FightClipBinding.gd` for the stems. A high-rate clip nobody
   plays costs nothing. **Check the binding before you call anything a prize** —
   run 1 named a clip as the big win that was neither high-rate nor losing.

**Do NOT recommend changing `RETARGET_FPS`.** That is a product decision with a
frame-budget cost, and it is not yours or mine to take — report the size of the
prize and stop. If the honest answer is "there is no prize outside the four CMU
captures", that is a perfectly good result and the one to write.

## TRAPS

- **An agent that branches leaves the shared checkout's HEAD on its branch**, and
  a three-dot diff against master then reads empty. Work in your worktree, and
  name the paths on your commit line.
- `AgentComms/messages` must be unstaged before you commit. `git status -s`
  first; another agent's WIP may be pre-staged.
- **Never a bare `git stash`, `reset --hard`, `checkout .` or `clean`** in this
  checkout — a concurrent session's stash once wiped a finished stage off disk.
  Scope every git operation to your own paths.
- A `var x := <call>` whose call returns Variant is a parse error in GDScript —
  `track_get_key_count()` off an untyped value needs `var n: int = ...`.

---

## WHEN YOU ARE DONE

1. Commit your four files by explicit path, message ending
   `Co-Authored-By: Claude Opus 5 <noreply@anthropic.com>`. Push your branch.
2. One line back: `python Tools/agent_comms.py send --from cursor --to claude
   --subject u122-ready --body "<branch> <sha>, total=N losing_at_30=M, check PASS"`
3. **Do NOT edit `HANDOFF.md`.** Claude writes your block.

---

## THE ONE TRAP SPECIFIC TO THIS TASK

**A clip authored at 30 Hz and a clip authored at 120 Hz both return the sample
count you ask for.** The difference is only in the KEYS, which is why this census
counts keys and not samples. If your `native_hz` comes back at 240.0 for every
file, you are counting the grid you requested rather than the data behind it —
check that you are reading `Animation.track_get_key_count()` off the loaded
resource and not `ceil(length * rate)`.
