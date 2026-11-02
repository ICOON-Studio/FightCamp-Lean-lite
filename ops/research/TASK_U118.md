# TASK_U118 — CURSOR — SPLIT `grapple` INTO OFFENCE AND DEFENCE, AND WIRE BOTH

**Agent:** Cursor · **Model:** composer-2.5 · **Effort:** medium · **Fast:** off
**Launch:** `python Tools/next_task.py cursor --launch` (it picks this up once U117 is
marked done), or `Tools\cursor_task.cmd <this file> <workspace>` directly.
**Branch:** `cursor/u118-grapple-split` — **branch from `master`.**
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest other than
`research/Q119_THE_STAT_FLOOR.md`, which is the read table you are working from.

**Test tier — `.gd` files ARE edited:** parse gate first
(`python Godot/tools/check_scripts.py <every .gd you touched>`), then
`python Godot/tools/run_tests.py --only grapple`, then `--only athlete`, then `--only stat`,
then `--only development`, then `--only fight`. **`--only` DOES NOT STACK — separate
commands.** **NO full suite** — that is Claude's at integration.
**fails CEILING, matching `AgentComms/last_suite.json` name for name:**
`athlete_development` (ALREADY RED — not yours, but do not make it worse),
`fight_pair_live` (PARKED), `fight_scoring`, `fight_stage_realism`.

---

## THE OPERATOR RULED ON THIS, 2026-09-21

The stat list is **the grounded 8**: power, speed, technique, defense, conditioning,
**grapple_offense**, **grapple_defence**, top_control — with `fight_iq` staying derived.
**This task does the grapple split only.** Do not add `top_control` and do not touch any other
stat; those are separate slices.

**WHY, in one line each, all three measured this session:**
- **The engine**: `grapple` reads on BOTH sides in 6 of the 9 grapple ids, so a good grappler
  is automatically good at STOPPING grappling.
- **The sport** (`J33_WHAT_THE_SPORT_MEASURES.md`): takedown accuracy and takedown DEFENCE are
  separately published quantities, as are control time, passes and reversals.
- **The market** (`K66_ATTRIBUTE_SYSTEMS_IN_SHIPPED_GAMES.md`): the two games closest to us by
  subject, Undisputed and Fire Pro Wrestling World, BOTH split offense from defense. Fire Pro
  is literally 12 offense + 12 defense.

## WHAT Q119 ALREADY ESTABLISHED — DO NOT RE-DERIVE ANY OF IT

`grapple` already has its own independent roll at generation (Q119 part 1): correlation with
the mean of the other six is **0.3525**, down from 1.0000. **You are splitting a real stat, not
an average.**

The call sites, from `Q119_THE_STAT_FLOOR.md`:

| id | resolver | note |
|---|---|---|
| takedown | `GrappleResolve.takedown_resolve` — `GrappleResolve.gd:76` | both sides |
| throw | same resolver — `GrappleResolve.gd:76` | both sides |
| sweep | `GrappleResolve.position_resolve` — `GrappleResolve.gd:98` | both sides |
| submission_attempt | `GrappleResolve.submission_advance` — `GrappleResolve.gd:122`, tick at `:147` | both sides |
| clinch_break | `CLINCH_OFF_WEIGHTS` — `GrappleResolve.gd:27` + `DEF_WEIGHTS` | both sides |
| submission_finish | `GrappleResolve.gd:127` | **no stat read — flat probability. LEAVE IT.** |
| escape | `FightSimulation._resolve_escape_attempt` — `FightSimulation.gd:2664` | opponent's only (defensive) |
| stand_up | same as escape — `FightSimulation.gd:2664` | opponent's only (defensive) |
| control | `FightSimulation._top_control_norm` — `FightSimulation.gd:2651` | top fighter's only (offensive) |

Plus the realtime reads at `FightRealtime.gd:3843` and `:3844`.

## THE RULE, AND IT IS THE OPERATOR'S

**Every stat lands with its engine read in the SAME stage. No stat ships decorative.** Q117
measured all seven current stats LIVE with zero decorative and zero write-only, and that
property is what this task must not break. **If you add `grapple_defence` and nothing reads it,
you have made the game worse, not better.**

## THE WORK

1. **Add both stats at generation**, alongside the existing ones and rolled the same way
   `grapple` now is. Keep them correlated with each other the way Q119 kept `grapple`
   correlated with the rest — a fighter good at takedowns is usually not hopeless at stopping
   them — but **not deterministic**.
2. **Route every read above to the right one.** The attacker's side of a contested resolve
   reads `grapple_offense`; the defender's side reads `grapple_defence`. The three one-sided
   ids take the one that matches their direction: `control` is offensive, `escape` and
   `stand_up` are defensive.
3. **Decide what happens to the old `grapple` key** and say so in the digest. Keeping it as a
   derived mean of the two is the safe option and keeps any read you missed working; deleting
   it is cleaner and louder. **Whichever you choose, no read may silently fall back to a
   default** — if a call site cannot be classified, name it in the digest rather than guessing.

## THE GATE — THREE NUMBERS

1. **Every call site in the table above reads a SPLIT stat**, proven by a check script that
   resolves each `file:line` and asserts what it names. A site you could not classify is
   listed, not hidden.
2. **A measured behavioural difference.** Generate two fighters — one with high
   `grapple_offense` and low `grapple_defence`, one the reverse — run takedowns both
   directions, and show the outcome is ASYMMETRIC. **This is the whole point of the task**: if
   the split changes no outcome, it is decorative and has failed. Report the rates both ways.
3. **No saturation regression.** Re-run Q117's 252-fighter population: the no-weakness count
   must stay at **2 or fewer** and the >2-above-90 count at **0**.

## THE CONTROL ARM

**A fighter with equal offense and defence must behave exactly as today's `grapple` fighter
did.** Build that fixture and show the takedown rate is unchanged within noise. That is what
proves the split is a refinement and not a rebalance — and a rebalance smuggled in here would
move every engine anchor R150 calibrated.

**NEVER TEST IDENTICAL FIGHTERS** (operator rule, no exceptions): the asymmetry test in gate 2
needs two DIFFERENT men, and the control arm above is a same-parameters *control*, not a
population measurement. Name the population in the output either way.

## OWNED FILES

- the generation site (wherever Q119 part 1 put `grapple`'s roll)
- `Godot/scripts/GrappleResolve.gd`
- `Godot/scripts/FightSimulation.gd` (the three sites named above, nothing else)
- `Godot/scripts/FightRealtime.gd` (lines ~3843-3844 only)
- `research/U118_THE_GRAPPLE_SPLIT.md` (new, the digest, under 70 lines)
- `research/U118_check.py` (new, the gate)

**Touch NOTHING else.** Not `AthleteStatModel.gd`'s `MODIFIER_TO_STAT`, not the training
catalogue, not any test, not `FightClipRetarget.gd`. Codex is writing a BLIND contract test for
this in parallel as C146 — **do not look for it and do not read any `codex/` branch.**

## TWO TRAPS

1. **`var x := <call>` fails when the call returns Variant**, and `Dictionary.get()` on an
   untyped stats block is exactly that. Write the type. A parse error does not fail a headless
   test, it HANGS it until the timeout.
2. **The stats key is `"stats"`, NOT `"attributes"`.** Q117 confirmed it, and this project has
   been burned three separate times by `"attributes"` silently yielding an empty block — which
   reads as every stat at its default and looks like a balance problem rather than a bug.

## IF THE ASYMMETRY IS SMALL

**Report the number, do not tune the weights to make it bigger.** A small measured asymmetry
with honest weights is a finding about how much these reads actually matter; a large one
produced by inventing weights is a rebalance nobody asked for. If it is small, say so and say
which call sites dominate.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push the branch, then one line:

```
python Tools/agent_comms.py send --from cursor --to claude --topic u118-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. **Unstage `AgentComms/messages` before any commit that is not the
mail itself**, and after committing run `git show --stat HEAD` and check the file list is
exactly what you meant — the checkout is shared and on 2026-09-21 a scoped `git add` still
swept in another agent's staged work.
