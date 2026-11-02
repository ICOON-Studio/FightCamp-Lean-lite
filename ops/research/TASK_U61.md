# TASK U61 — CURSOR — THE BLIND CONTRACT TEST FOR THE LAYERED PRESENTER

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: ONE NEW TEST FILE. Parse gate, then that one test. Do NOT run the
full suite** — a new test file cannot break another test, and the suite is
Claude's once at integration. **Only one Godot at a time in this checkout** and
other agents are working right now: check
`Get-CimInstance Win32_Process -Filter "Name LIKE '%odot%'"` first and wait
rather than starting a second one. (Note: the *console* Godot exe spawns the
windowed exe as a child, so ONE run legitimately shows as TWO processes — check
the parent chain before concluding two agents are running.)

```
python Godot/tools/check_scripts.py Godot/tests/fight_body_layers_contract_test.gd
%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_body_layers_contract_test.gd
```

## Owned files

- `Godot/tests/fight_body_layers_contract_test.gd` — **NEW. Yours alone.**

**Nothing else.** Do NOT edit `FightBodyLayers.gd`, `FightStagePlayer.gd`,
`FightClipBinding.gd`, any other test, or `HANDOFF.md`. `GameState.gd` is ~13,000
lines — you do not need it, never open it.

## THIS IS A BLIND TEST AND THAT IS THE WHOLE POINT

**You are writing this test from the CONTRACT below, not from the
implementation.** Do not read `FightStagePlayer.gd` to find out what it does and
then assert that. A test written against an implementation only ever agrees with
it — that is precisely how R116 shipped a facing assertion that defined forward
as `-basis.z`, the same premise the code under test used, asked whether the code
does what the code does, answered 1.0000, and passed while **both fighters fought
back to back in every bout ever run.**

You MAY read `Godot/scripts/FightBodyLayers.gd` (6.6 KB, read it whole) because
it is the module whose behaviour the contract describes, and you need its exact
API names. You may read two or three neighbouring files in `Godot/tests/` for the
harness idiom. **Do not read `FightStagePlayer.gd`.**

## Why this exists

`FightBodyLayers` (R125) splits the body: a locomotion loop plays on the whole
skeleton, and firing an `AnimationNodeOneShot` whose filter allows only the 13
bones from `Spine` up overlays the action on the arms and torso while the legs
keep walking. It is proven by render — legs stride while the arms punch — and
**it is not wired into the fight yet.** It is about to be. When it is, this test
is what says whether the wiring is honest.

G58 (Grok, 2026-09-12) priced partial-body layering as **the single best
animation multiplier available to a team with no animator**, 6–15 distinct
playbacks per source clip. Our own arithmetic is 4 lower × 19 upper = 76
playbacks from 23 clips. That is what is at stake if the wiring is quietly wrong.

## THE CONTRACT — assert these, and nothing about how they are achieved

**C1. LEGS ARE NEVER MASKED OFF A KICK.** `FightBodyLayers.wants_layering(role)`
must return `false` for every role in `LEGS_ARE_THE_POINT` and `true` for a
plain hand strike role. A roundhouse masked at the hips is a man waving. Assert
both directions: the refusals AND at least one acceptance.

**C2. THE PELVIS BELONGS TO THE WALK.** `UPPER_BONES` must NOT contain `Hips`,
and must contain `Spine` and `Head`. Hip sway is the foundation of a gait; an
upper-body clip that seizes the pelvis makes a man whose torso and legs disagree.

**C3. THE FILTER IS ACTUALLY APPLIED.** After `build()` succeeds,
`filtered_count()` must be greater than zero and must not exceed
`UPPER_BONES.size()`. A filter that silently filtered nothing would produce
whole-body playback that *looks* layered from the outside — that is the failure
mode this assertion exists for.

**C4. LAYERING CHANGES ROUTING, NEVER SELECTION.** Whatever clip is chosen for a
given role, the same clip must be chosen whether or not layering is active.
Layering is a presentation route, not a director decision. If you cannot reach
selection without reading the presenter, assert the weaker form: `set_lower()`
and `play_upper()` accept the same animation names the AnimationPlayer holds, and
neither invents nor rewrites a name.

**C5. IT REFUSES CLEANLY WHEN IT CANNOT WORK.** `build()` against an
AnimationPlayer with no skeleton, or with a `skel_path` that matches no track,
must return `false` and leave `is_ready()` false — **not** half-build and not
crash. The caller must be able to fall back to whole-body playback. Assert that
`set_lower()` and `play_upper()` return `false` rather than erroring when
`is_ready()` is false.

**C6. `active()` REFLECTS THE ONE-SHOT, NOT A LOCAL FLAG.** Assert that
`set_active(true)` then `active()` is true, `set_active(false)` then `active()`
is false. R125's render proved the one-shot holds `active=true` for 7 frames; a
local boolean that merely remembers what it was told would pass a naive test and
lie about the real tree.

## HOW TO BUILD THE FIXTURE

You need an `AnimationPlayer` with a `Skeleton3D` and at least two named
animations. **Do not depend on the bought FBX packs** — 124 of them did not
import on this machine and `load()` returned null for all of them (R118), so a
test that needs them is a test that fails for the wrong reason. Build a minimal
skeleton and two trivial `Animation` resources in code inside `_initialize()`.

Add bones named exactly as `UPPER_BONES` lists them plus `Hips`, so the filter
paths resolve. The filter path has to match the track path byte for byte —
`Skeleton3D:Spine` — so whatever string you hand `build()` as `skel_path` must be
the same one your tracks use.

## THE GATE — A CEILING, NOT AN EXACT COUNT

Your test must pass and must print its own summary line in the house form
(`checks=N failures=0`). **A test that prints nothing is counted as a FAILURE by
the runner, and rc=0 is NOT a pass** — a GDScript runtime error leaves rc=0, so a
test whose module was clobbered prints twenty `SCRIPT ERROR` lines, then prints
`0 failure(s)`, and exits 0.

**If an assertion written honestly from this contract FAILS, you have found a
real defect and that is the best outcome available.** Do not weaken the assertion
to make it green and do not push a red test. Print it as a `KNOWN GAP:` line that
does not count toward `failures`, keep the suite green, and **lead your mail with
the gap**. Say in the commit message that it is reported and not fixed.

## THE TRAP SPECIFIC TO THIS TASK

**A paused or zero-speed AnimationPlayer contributes NOTHING to the pose.**
`play(); seek(); pause()` renders the REST pose, and so does seeking at
`speed_scale = 0` — and both look exactly like a successful render: right
filenames, right frame count, no error. That defect wrote 264 byte-identical
contact-sheet frames on this project, twice, before anyone noticed. **If you
assert anything about a resulting POSE, play the clip and read consecutive
frames; never seek-and-pause.**

Second trap: `var x := <call>` fails to compile when the call returns Variant,
and `.get()` on an untyped dictionary or `.size()` on an untyped value both do.
Write the type: `var n: int = ...`. Reusing a variable name inside one function
is a parse error even across separate `if`/`for` blocks. `%` inside a format
string must be `%%`. **A parse error HANGS a headless test for 600 s instead of
failing it**, so run the parse gate first, every time.

## When you are done

```bash
git add -- Godot/tests/fight_body_layers_contract_test.gd
git commit
git push origin master
python Tools/agent_comms.py send --from cursor --to claude --subject U61-done --body "checks=<N> failures=<N> known_gaps=<N> worst=<one line>"
```

Check `git status -s` before you stage — another agent's work-in-progress may be
pre-staged in this shared checkout. Stage explicit paths only. **Push to `master`
and leave HEAD on `master`.** Do NOT edit `HANDOFF.md`.
