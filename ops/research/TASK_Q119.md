# TASK_Q119 — QWEN — MAKE `grapple` MEAN SOMETHING, THEN DERIVE THE STAT FLOOR FROM THE ENGINE

**Agent:** Qwen · **Model:** qwen3-coder · **Effort:** medium · **Fast:** off
**Owner rationale:** you wrote Q117, so you already know this code.
**LAUNCH ONLY AFTER Q118 HAS LANDED.** Do not run these two in parallel — both read the same
engine files and Q118's decision inventory is context for Part 2.
**Launch:** from worktree `FightCamp-Q81`:
`Set-Location <wt>; Get-Content <this file> -Raw | qwen.cmd --yolo -m qwen3-coder`
(PowerShell reports exit 1 on its yolo warning — read the `.out` file, never the rc.)

**Read this file and only the files it names**, plus your own
`research/Q117_THE_ATTRIBUTE_CENSUS.md`. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any other digest.

**Test tier — PART 1 EDITS A `.gd`, so:** parse gate first
(`python Godot/tools/check_scripts.py <every .gd you touched>`), then
`python Godot/tools/run_tests.py --only athlete`, then `--only stat`, then `--only development`.
**`--only` DOES NOT STACK — a second one REPLACES the first. Separate commands.**
**NO full suite** — that is Claude's at integration. **fails CEILING:** the tree's four
baseline reds are `athlete_development`, `fight_pair_live` (PARKED on purpose), `fight_scoring`
and `fight_stage_realism`. `athlete_development` is ALREADY RED — match
`AgentComms/last_suite.json` name for name and do not count it as yours, but do not let it get
*worse* either.

**PART 1 IS SHIPPABLE ON ITS OWN. Commit it before starting Part 2.**

---

## PART 1 — MAKE `grapple` INDEPENDENT

`grapple` is currently **the mean of the other six at generation**. It therefore carries **ZERO
independent information**, and all nine grapple ids resolve off an average of unrelated
numbers.

**Give it its own roll.** No new stats. No engine changes. Every existing read of `grapple`
starts seeing real spread immediately, and nothing else in the game has to know.

### The gate for Part 1

Re-run Q117's 252-fighter population and show:

- **`grapple`'s correlation with the mean of the other six falls from 1.0 to under 0.6.**
  Pin the measured value as a **literal in the check script**.
- **Q117's two saturation numbers re-reported, and NEITHER GOT WORSE:** the no-weakness count
  (was 2 of 252) and the count with more than two stats above 90 (was 0).

## PART 2 — DERIVE THE MINIMUM STAT LIST FROM THE ENGINE, NOT FROM A SCREENSHOT

For **each of the nine grapple ids** — `takedown`, `throw`, `sweep`, `submission_attempt`,
`submission_finish`, `escape`, `control`, `clinch_break`, `stand_up`:

1. **What does the engine read to resolve it?** `file:line` for every read.
2. **Which of those reads land on `grapple`?**
3. **WHAT WOULD HAVE TO DIFFER between two fighters for this id to resolve differently?**

**Question 3 is the deliverable.** Its answer, summed across the nine, is the **minimum number
of independent stats** — a floor *derived from the code* rather than chosen from a wishlist.

### The three-way cross-check

One table, three columns:

| our engine's needs | the operator's BJJ vocabulary (14) | what the sport separately measures |

The 14: Sweeps, Passing, Guard, Top Pressure, Scrambles, Sub Defense, Submissions, Back
Attacks, Leg Locks, Takedowns, Flexibility, Composure, Heart, Technique.

For the third column use J20's corpus — **takedown accuracy and takedown defence are distinct
published FightMetric quantities**, and that distinction is the model for the whole column.

- **Where all three agree, the stat is real.**
- **Where only the BJJ list has it, it is a candidate.**
- **Where only we have it, say why.**

### CALL OUT ATTACK vs DEFENCE EXPLICITLY

A takedown resolves **against the other man**. One `grapple` number on both sides means **a
good grappler is automatically good at stopping grappling** — which is false in the sport and
false in the engine. Say for every one of the nine ids whether the read is offensive,
defensive, or both, and where the same number is currently doing both jobs.

---

## DO NOT PROPOSE A FINAL STAT LIST

Produce **the floor and the cross-check**. The list is the operator's call and Claude's to
synthesise. No "I recommend", no groupings invented for the screen.

## THE RULE THAT KEEPS THIS HONEST — CARRY IT INTO THE DIGEST

**Every new stat must land with its engine read in the SAME stage. No stat ships decorative.**

Q117 measured all seven current stats LIVE with **zero decorative and zero write-only**. That
property is the thing being protected here, and ten dead BJJ attributes bolted on for a
prettier screen would destroy it. Write that rule into the digest in your own words so the
next reader inherits it.

## ALSO SETTLE THIS

**Confirm or correct Q117's note that `fight_iq` is derived.** If it is, then only **FIVE** of
the seven carry independent information, and the headline of your own census changes. Say so
plainly if so — correcting your own earlier finding is worth more than defending it.

## OWNED FILES

- the generation site for `grapple` (Part 1 — find it; it is where the mean is taken)
- `research/Q119_THE_STAT_FLOOR.md` (new, the digest)
- `research/Q119_floor.py` (new)
- `research/Q119_check.py` (new, the gate)
- `research/Q119_correlation.json` (new)

**Touch NOTHING else.** Do not edit `AthleteStatModel.gd`'s `MODIFIER_TO_STAT`, do not add a
stat, do not touch any fight script.

## THE GATE SCRIPT

`python research/Q119_check.py` must exit 0 and must RECOMPUTE, not restate:

- re-generate the 252-fighter population and re-derive the correlation, asserting it against
  the pinned literal;
- assert the no-weakness count and the >2-above-90 count against pinned literals and assert
  neither is worse than Q117's;
- assert every `file:line` in the Part 2 read table still resolves to a line naming that read;
- assert a degenerate case: a population of 0 reports "no fighters" rather than dividing by
  zero.

## TWO TRAPS

1. **A correlation of 1.0 is what you are removing, but 0.0 is not the target either.** A
   fighter's grappling is not independent of his conditioning and technique in real life.
   Under 0.6 is the gate; if your roll lands near 0.0, say so and say whether that is
   defensible rather than silently shipping an uncorrelated number.
2. **`grapple` being the mean means some code may RELY on it never being an outlier.** Before
   you commit Part 1, grep every read of `grapple` and check none of them assume a bounded
   relationship to the others. If one does, name it in the digest — that is a finding, not a
   blocker.

## WHEN YOU ARE DONE

Commit Part 1 and Part 2 as **separate commits**, with explicit paths (`git add -- <files>`),
push, then one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic q119-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. Unstage `AgentComms/messages` before any commit that is not the mail.
