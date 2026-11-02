# TASK U20 — CURSOR — DAMAGE IN REAL TIME, ON A BODY THAT ALREADY EXISTS

**Model:** your strongest available (Composer if the frontier pool is still
spent) · high effort.

**Research only. You write no `.gd`, no `.tscn`, and you do not edit
`HANDOFF.md` — Claude writes your block from your digest.**

## The decision behind this

Operator ruling 2026-09-09: **the fight becomes real time** — "everything,
damage, movement etc, resolved in real time". Today damage lands once per
resolved 14-fight-second exchange. Real time means it accrues per impact.

You did U18 and refused an eighth attribute and XY combat on the evidence. **The
XY refusal has been overturned by the operator**; your granularity finding was
right and stands — R80 and U19 shipped from it. This task is the damage half.

## What is true today (verify it)

- Six body regions with readiness already exist — `BodyReadiness.gd`, the R55
  six-region model, `GameState.get_body_read()`, and U3's design pack
  (`research/U3_THE_BODY_BY_REGION.md`).
- Damage is applied per exchange in `FightSimulation.gd` — grep
  `_apply_body_condition_deterioration` and `_apply_landed_effect`.
- Per-body-part RECOVERY is a ruled future stage (operator decision
  2026-09-07); healing clocks are deliberately untouched. **Do not design
  healing.** This is about damage during a bout only.
- R80's burst already reports `thrown` / `landed` per exchange — roughly 4.7
  thrown under one named technique. In real time those become real impacts.

## The questions

1. **What is an impact?** Define the record a single strike produces — target
   region, force, whether it was blocked/slipped/absorbed on the guard. Enough
   that damage, the animation and the broadcast read can all consume the same
   thing.
2. **How does damage accumulate continuously?** Today a landed technique
   applies a lump. Real time gives many small impacts. What curve keeps a fight
   from turning into either a war of attrition with no drama or a one-punch
   coin flip? Cite real striking/medical evidence where it exists — accumulated
   vs single-impact, the head/body distinction, the flash-knockdown case.
3. **What survives from the current model?** Stoppage (`_check_stoppage`),
   hurt, the ten-point-must scoring and the six-region read all work now. Say
   which of them keep working unchanged against a stream of impacts and which
   need a new rule.
4. **What does the player SEE?** One paragraph — you own the read. Not a
   screen design, just what must be legible.

## Owned files

- `research/U20_DAMAGE_IN_REAL_TIME.md` — new, the report.
- `research/U20_DIGEST.md` — new, short.

**Do NOT touch** `Godot/scripts/FightSimulation.gd`, any test, or `HANDOFF.md`.
Codex owns C62 (determinism), Qwen owns Q13 (space), Grok owns G28 (clock).

## The trap

**Do not price the tick rate or the determinism** — that is C62 and it may come
back saying real time is not affordable at all. Write the damage model so it is
true at ANY tick rate, expressed per second of fight time rather than per tick.

## Push

Push to a branch as usual, then mail Claude with `agent_comms.py send`. **Your
mail rides the branch and the master inbox cannot see it** — say the branch name
in the message so Claude finds it with `triage`.
