# TASK Q67 — QWEN — WHY WON'T THE LEGS FIRE?

**Model:** qwen3-coder, medium effort, `--yolo`. Fixed at assignment.

**Test tier:** MEASUREMENT ONLY. You change **no** `.gd` under `scripts/` and no
shipped data. One or two headless Godot runs. **Do NOT run the full suite.**
**Only one Godot at a time in this checkout** — check with
`Get-CimInstance Win32_Process -Filter "Name LIKE '%odot%'"` and wait if one is
up. (The *console* Godot exe spawns the windowed exe as a child, so ONE run
legitimately shows as TWO processes — trace the parent chain before concluding
two agents are running.)

Read THIS FILE and the files it names. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## WHAT YOU ALREADY PROVED, AND WHY IT MATTERS

In Q66 you did exactly the right thing: you checked R129's instruction, found it
was a no-op, said so, promoted four more kickboxing kicks to tier 2, measured,
and reported that **the leg share moved 4.41% → 4.38%**. Then you wrote the
sentence this task exists for:

> *"Root cause: simulation has fundamental bias against kicks that tier changes
> cannot fix."*

**That is a claim, and it is probably right, but it is not yet measured.** Your
job is to turn it into a number and a `file:line`.

## THE QUESTION

**Legs are 4.4% of landed strikes against a real-fight anchor of 14–18%. Where
do the kicks go?**

A kick has to survive a chain of gates to become a landed leg strike. Find which
gate eats them. Measure each step, do not reason about it:

1. **Is the kick in the palette at all?** For a seeded kickboxing fighter, how
   many of his tier 1–2 techniques are kicks vs hands? (You measured the palette
   in Q66 — carry the number forward, do not re-derive it.)
2. **Is it CHOSEN?** Of all technique choices made across a sample of bouts, what
   fraction picks a kick? If the palette is 30% kicks and only 8% of choices are
   kicks, the selection weighting is the gate — find what weights it.
3. **Is it ATTEMPTED and then missed?** Do kicks have a lower hit rate than hands?
   If so, what makes it lower — accuracy, the defender's roll, a range gate?
4. **Does it land but get counted somewhere else?** This is the one to check
   hardest. `FightSimulation._technique_target_region` matches by **SUBSTRING**
   (`:2143`), and `FightMoves._regions_for` (`:540`) uses **exact keys** — the two
   region paths are known to disagree. **A kick that lands and is bucketed as
   `head` or `torso` would look exactly like a kick that never fired.**
5. **Is it gated by RANGE?** Kicks carry `range_band` `LONG`/`MID`. If seeded
   bouts spend most of their time in `POCKET`, no kick is ever legal. Measure the
   distribution of range band over a bout.

**Report which gate it is, with the number at each step.** "Selection picks kicks
9.1% of the time although they are 31% of the palette, at `<file:line>`" is the
shape of the answer.

## OWNED FILES

- `research/Q67_WHERE_THE_KICKS_GO.md` — your findings. NEW.
- `Godot/tools/measure_kick_funnel.gd` — a NEW measuring script, yours alone.

You may READ `Godot/scripts/FightSimulation.gd` and `Godot/scripts/FightMoves.gd`
— **both are large, never open either whole.** Use `sed -n 'A,Bp'` windows around
the anchors above and grep for the rest. You may read
`Godot/tools/measure_catalogue_impact.gd` whole as a model for how to write a
measuring script — copy its shape.

**You edit nothing that already exists.** If you find a defect, REPORT it. A fix
moves seeded verdicts, and that rebaseline is Claude's call.

## THE GATE

```bash
python Godot/tools/check_scripts.py Godot/tools/measure_kick_funnel.gd
```
then the one headless run of your own script. Your script must print a clear
funnel table and its own summary line. **A script that prints nothing counts as a
failure, and rc=0 is NOT a pass** — a GDScript runtime error still exits 0.

## THE TRAP SPECIFIC TO THIS TASK

**Do not measure two identical fighters.** The operator's standing ruling:
*"you have to try to reproduce realistic scenarios not 2 identical fighters
fighting each other and base the whole simulation on that."* R132 reported two
engine defects that were both artefacts of a two-identical-fighters fixture and
had to be retracted. Use a realistic kickboxing matchup — a kicker against a
boxer-style pressure fighter — and **say in your write-up what population you
used**, so the next person can tell your finding from your fixture.

Second trap: `var x := <call>` fails on Variant — write the type. A reused
variable name in one function is a parse error even across separate `if`/`for`
blocks. `%` in a format string must be `%%`. A parse error **HANGS** a headless
run for 600 s instead of failing it.

## WHEN YOU ARE DONE

```bash
git add -- research/Q67_WHERE_THE_KICKS_GO.md Godot/tools/measure_kick_funnel.gd
git commit
git push origin master
python Tools/agent_comms.py send --from qwen --to claude --subject Q67-done --body "palette_kick_pct=<N> chosen_pct=<N> landed_pct=<N> bucketed_leg_pct=<N> gate=<one line> at=<file:line>"
```

Check `git status -s` before staging. Stage explicit paths only. Do NOT edit
`HANDOFF.md`.
