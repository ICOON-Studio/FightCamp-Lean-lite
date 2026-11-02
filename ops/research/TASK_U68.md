# TASK U68 — CURSOR — WHICH BALANCE-BREAK TECHNIQUES ARE TAKEDOWNS?

Model: Composer, **medium effort**. Owner: cursor.

**Queued behind U67, which is already landed — so this is ready to launch.**

**Test tier: ONE DATA FILE plus ONE NEW TEST.** Parse gate your test, run it,
then `--only fight_scoring`, `--only grapple` and `--only fight_simulation`. **Do
NOT run the full suite.** **ONLY ONE GODOT AT A TIME in this checkout.**

## Owned files

- `Godot/assets/data/technique_catalog.json` — **the `match.role` field ONLY**,
  and only on the nodes this task names or that your rule selects. Nothing else.
- `Godot/tests/takedown_vocabulary_test.gd` — **NEW, yours alone.**
- `research/U68_BALANCE_BREAK_ROLES.md` — **NEW, yours alone.**

Do **NOT** edit `HANDOFF.md`, `AgentComms/roadmap.json`, or any script.

## Why this exists

S1c settled the vocabulary and repaired 85 nodes with two DERIVED rules, both
documented in `Godot/tools/derive_technique_roles.py`. Read that file first — it
is short, and it is the standard this task has to meet.

Rule 1 is **one-directional on purpose**: a literal `takedown` effect implies
role `takedown`; the converse does not. That protection exists because **seven
nodes carry role `takedown` with no `takedown` effect at all** — savate's
`coup_bas`, capoeira's `rasteira`, silat's `sapuan` and `guntingan`, sambo's
`front_trip`, sanda's chain — because a sweep is authored with `sweep` and
`balance_break` instead. Making rule 1 symmetric would have stripped the role
off all seven.

**That protection also means S1c could not repair the mirror case, and there is
one.** Two muay thai nodes were `role: takedown` on master, have **byte-identical
effect keys** on the branch, and came back as `control`:

| node | master | branch | effects (unchanged) |
|---|---|---|---|
| `muay_thai_clinch_dump` | takedown | **control** | `balance_break`, `control_score` |
| `muay_thai_dumps_offbalance` | takedown | **control** | `balance_break`, `score_or_damage` |

Same content, different physics. Under `control` a clinch dump scores control
and drains stamina; it never sets `phase = "GROUND"` and can never score. A muay
thai clinch dump puts a man on the canvas.

And one more, a different shape: `judo_uranage_counter` was `counter` on master
and is `damage` now. Its effects changed too (`score_or_damage` →
`throw_damage`), so it is genuine re-authoring rather than a pure label move —
but an ura-nage is a counter-throw and it is currently neither a counter nor a
takedown.

## The question, and it is a CONTENT question

**Which techniques that break balance should set `phase = "GROUND"`?**

This is not derivable from one effect key, which is exactly why S1c left it.
`balance_break` and `sweep` appear on techniques that put a man down (o-soto-gari)
and on techniques that merely stagger him (a teep). The answer depends on the
technique, and in some cases on the ruleset scoring it.

So: **adjudicate, node by node, and write down the reasoning.** Then encode
whatever rule your adjudication reveals — if one exists — back into
`derive_technique_roles.py` as a rule 3, with the same standard of comment. **If
no clean rule exists, say so** and leave the repairs as an explicit,
individually-justified list in your research file. A short honest list beats a
rule invented to look principled.

## Scope

Survey every node carrying `balance_break`, `sweep`, `counter_throw`,
`throw_damage`, `counter_takedown` or `strike_to_throw` whose role is not
already `takedown`. Report the count first; it is roughly 30-40 nodes. For each,
say: does landing this put the opponent on the ground?

**ADJUDICATE AND COMMIT ONE DISCIPLINE AT A TIME — OPERATOR RULING 2026-09-12.**
Muay thai first (it has the two clearest cases), then judo, then the rest. Each
tree is its own commit with the three `--only` subsets run before you move on.
`derive_technique_roles.py --discipline <id>` takes the flag for exactly this.
A 696-node sweep validated by a single suite run cannot tell you which tree
moved a fight; one tree per commit can. **And a discipline is the unit a human
can actually review** — "is judo right?" is answerable, "are 696 nodes right?"
is not.

## The test

`takedown_vocabulary_test.gd` asserts the PROPERTY you settle on, derived from
the catalogue at run time — never a hardcoded list of ids. For example: every
node whose `match.phases` include a ground phase and whose effects carry a
throw-family key must be `takedown` or `submission`. Derive it; do not pin it.

**A gate that keeps its own copy of the answer is what cost this tree nine
defects in one day.**

## THE TRAP

**`_apply_landed_effect`'s `takedown` arm can end the bout.** It prices the throw
against the ruleset's scoring profile and sets `event["ippon"]` when the throw
class or accumulated throw points cross the threshold. Promoting a node to
`takedown` therefore does not just move a man to the ground — it can finish a
fight. So promoting a light stagger (a teep carries `balance_break: 5`) would
make teeps end fights by ippon under judo rules. **Check what your rule does to
the smallest `balance_break` values before you apply it**, and report the
magnitude range of everything you promote.

## Done

- Your test green; the three `--only` subsets at **fails=0 as a CEILING** — if a
  pre-existing failure disappears, say so and push.
- `git status -s` FIRST, then `git add --` your three explicit paths. Never
  `git add -A`, never a bare `git stash` / `reset --hard` / `checkout .`.
- Commit ending `Co-Authored-By: Cursor <noreply@cursor.com>`, then push.
- One line of mail:
  `python Tools/agent_comms.py send --from cursor --to claude --topic U68-done --body "<hash> surveyed=<n> promoted=<n> rule3=<yes|no> min_magnitude_promoted=<n>"`
