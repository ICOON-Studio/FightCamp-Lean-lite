# TASK_Q121 — QWEN — WHAT CAGE SIZE DOES TO THE FIGHT

**Agent:** Qwen · **Model:** `qwen3-coder` · **Effort:** medium · **Fast:** off
**Launch:** `Set-Location <worktree>; Get-Content <this file> -Raw | qwen.cmd --yolo -m qwen3-coder`
**PowerShell reports exit 1 on qwen's yolo warning — read the `.out` file, never the rc.**
**Branch:** `qwen/q121-cage-size` — **branch from `master`.**
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

**Test tier — RESEARCH plus ONE new tool script. No `.gd` in `Godot/scripts/` is edited,
so there is NO parse gate on the engine and NO suite run.** If you add a `.gd` under
`Godot/tools/`, parse-gate that one file and nothing else. `git status -s` before staging is
the rest of the check.

---

## THE QUESTION, IN ONE LINE

**Every fight this project has ever measured was fought in a 6 metre cage. A championship
octagon is 9.14 m. What does that change?**

## WHY IT IS BEING ASKED NOW

The operator supplied a manufacturer's assembly drawing for a gym octagon on 2026-09-09. It is
in the repo as `mma_cage_gym_6m` in `Godot/assets/data/arena_specs.json`, it is complete and it
validates, and `ArenaSurface.for_discipline("mma")` (`Godot/scripts/ArenaSurface.gd:45`) points
every MMA bout at it. It is an honest, real, EQUIPMENT-grade object.

**It is also an amateur cage.** The UFC competition octagon is 30 feet across the flats —
9.14 m — against this one's 6 m. For a regular octagon, area = 2(√2 − 1)·W², so that is
**29.8 m² against 69.2 m², a factor of 2.32**. (69.3 m² agrees with dimensions.com's published
750 ft² and euro-mat's ~70 m², and the implied side 9.144/(1+√2) = 3.788 m lands on
dimensions.com's stated 3.79 m — the width, the area and the side are mutually consistent,
which is what confirms 9.144 m is across the FLATS and not across the corners.)

**The two sources are `dimensions.com/element/ufc-octagon` and
`euro-mat.ru/oktagony/razmery-i-vidy-oktagonov`, both operator-supplied 2026-09-21, and they
agree on the geometry.** euro-mat independently classifies a 6 m octagon as a TRAINING cage for
clubs, which is a third witness that today's default is not a competition size.

`FightRealtime.DEFAULT_HALF_WIDTH` is **3.0** (`Godot/scripts/FightRealtime.gd:107`), whose own
comment describes it as a 6 m *boxing ring*. The engine simulates 2D positions in real metres
and `RingSpace` implements a true octagon (`Godot/scripts/RingSpace.gd`), so cage width is a
live physical input to every bout, not a decoration.

**So this is not a re-skin. If cage size moves the engine's numbers, adding a championship
octagon costs a re-baseline of the anchors R150 calibrated, and we need to know the size of
that bill BEFORE S7 builds venues — not after.**

## WHAT TO MEASURE

Run the existing engine at a SWEEP of cage half-widths and report what moves. At minimum:

| preset | half_width | across flats |
|---|---|---|
| gym octagon (today's default) | 3.00 | 6.00 m |
| ABC 18 ft minimum | 2.7432 | 5.4864 m |
| small competition octagon (`mma_cage_ufc_25ft`, UFC Apex) | 3.81 | 7.62 m |
| championship octagon (`mma_cage_ufc_30ft`) | 4.572 | 9.144 m |
| ABC 32 ft maximum | 4.8768 | 9.7536 m |

For each, over enough seeded bouts to be stable (**aim for ≥60 bouts per size**, and say what
you used), report:

1. **Time at the fence** — the share of round time a fighter is within one body radius of a
   wall. `RingSpace` already knows the walls; `FightBodyRadius` already knows the radius. Use
   them, do not invent a second measure of "near the cage".
2. **Corner/vertex time** — the share at one of the eight 135° vertices. `RingSpace.gd`'s
   header says an octagon's vertex is NOT a square's corner and that `FightIntent.decide`
   switches on it; report both separately and do not merge them.
3. **Takedown attempts and success rate**, total and split by whether the defender was against
   the fence when it started. **This is the one most likely to move** — a fence at your back is
   what makes a takedown land in real MMA.
4. **Clinch entries and clinch duration.**
5. **Distance/range distribution** — the share of beats at each range band, and the mean
   fighter separation in metres.
6. **Strikes landed per round and the head/body/leg split**, so we can see whether a bigger
   cage quietly changes the striking mix and walks the J20 anchors off their targets.

## THE THREE RULES THAT BIND THIS MEASUREMENT

**1. NEVER TEST IDENTICAL FIGHTERS** (operator rule, no exceptions). Two men built from the
same numbers are not a control group, they are an unreal population, and what they measure is
the fixture rather than the engine. Use a **grappler against a striker** — different stats,
different frames, different plans — and **run the same two men at every cage size**, so the
only thing changing across the sweep is the cage. **Name the population in the output itself**,
every table, so a later reader can tell a finding from a fixture.

**2. A FIGHTER MUST BE LEGAL FOR THE RULESET HE IS IN.** This is an MMA sweep, so both men can
do everything; differentiate by style and attributes INSIDE the ruleset, never by removing
techniques the ruleset legally permits. A man with no `technique_progress` record is silently
handed his ruleset's whole tier 1-2 palette — check the record you give each fighter, and check
the key name is **`"stats"`** and not `"attributes"`, which silently yields an EMPTY stat block
and has burned this project three separate times.

**3. NAME THE CATALOGUE.** A fixture is not only the fighters, it is the fighters AND the data
they fight under. State which technique catalogue the sweep ran against.

## THE CONTROL ARM — DO NOT SKIP IT

**Run 3.00 twice with different seeds and report the spread.** Every difference you attribute
to cage size must be bigger than the spread between two runs at the SAME size, or it is noise
wearing a finding's clothes. Put that number at the top of the results table and judge every
other row against it.

Separately, as a determinism tripwire only: the same seed at the same size twice must be
**byte-identical**. That is a tripwire, not a population measurement, and it produces no
finding about the engine.

## WHAT I DO NOT WANT

- **Do not tune anything.** No constant is to be changed. This is a measurement.
- **Do not add or edit an arena preset — THE PRESETS YOU NEED ALREADY EXIST.** The operator
  supplied two sources on 2026-09-21 and `mma_cage_ufc_30ft` (9.144 m) and `mma_cage_ufc_25ft`
  (7.62 m) are now in `Godot/assets/data/arena_specs.json`, both validating, both graded
  REFERENCE. **Read their widths from that file rather than retyping them here.**
  `mma_cage_abc_18ft` is still `_incomplete` and still REFUSED by `ArenaRig.validate`, because
  no commission publishes a cage apron and a catwalk width from a reference site does not fill
  a hole in the ABC rules. **Do not invent that measurement to make it validate.**
- **Do not conclude the cage should change size.** Report what moves and by how much; the
  ruling is the operator's and the trade is S7's.

## THE GATE — A CHECK SCRIPT THAT MUST EXIT 0

Write `research/Q121_check.py`. It **recomputes every headline number in your digest
from the raw sweep output** and exits non-zero if any disagrees. It must NOT read the numbers
out of the markdown and compare them to themselves — a gate that reads its subject cannot
fail, and this project has caught that exact shape three times in one day. Derive from the
data files, assert against the digest.

It must also assert the two same-size control runs are present and that the noise figure is
reported, because a sweep without its control arm is not a result.

## OWNED FILES

- `Godot/tools/q121_cage_sweep.gd` (new — the sweep; a tool, not a test)
- `research/Q121_CAGE_SIZE.md` (new — the digest, under 90 lines)
- `research/Q121_check.py` (new — the gate)
- `research/q121_sweep.json` (new — the raw rows the gate recomputes from)

**Touch NOTHING else.** No engine script, no arena spec, no test, no `HANDOFF.md`.

## IF THE ANSWER IS "NOTHING MOVES"

**Say so plainly and push it.** A measured null result here is worth real money: it would mean
a championship octagon is a presentation change with no re-baseline attached, which is the
cheapest possible answer and unblocks S7. Do not hunt for an effect to justify the task.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push the branch, then one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic q121-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. **Unstage `AgentComms/messages` before any commit that is not the
mail itself**, and after committing run `git show --stat HEAD` and check the file list is
exactly what you meant — the checkout is shared.

**THE ONE TRAP SPECIFIC TO THIS TASK:** `half_width` is read from an options/state dict with
`DEFAULT_HALF_WIDTH` as the fallback (`FightRealtime.gd:800` and `:1414`). There are **two**
read sites. If you set the size in one path and not the other, half your sweep runs at 3.0 and
every row looks identically noisy — which reads as "cage size does nothing" and would be a
false null. **Assert in the sweep itself that the width the engine used is the width you
asked for**, per bout, and fail loudly if it is not.
