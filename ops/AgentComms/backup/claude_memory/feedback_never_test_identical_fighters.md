---
name: feedback_never_test_identical_fighters
description: "Operator rule 2026-09-12 - never measure the engine with two identical fighters; identical means stats, palette, frame or plan, not just the stat block"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2e96d4ea-3292-48e0-abf9-61469f27415c
  modified: 2026-09-12T02:57:50.208Z
---

**"You can never put to test identical fighters. We are trying to simulate
reality and that's not real."** (operator, 2026-09-12). Binds every measurement,
tool, fixture and test — Claude's and every agent's. Written into `CLAUDE.md`
above `## Product and process rules`.

**Why:** two fighters built from the same numbers are not a control group, they
are an unreal population, and what they measure is the fixture rather than the
engine. It has cost this project four times: R132 reported 12% draws and 3%
submissions as engine defects and both were RETRACTED in R133 once a grappler
faced a striker (25% submissions, zero draws); a "varied fighters" mode used
`((idx * 37 + k * 53) % 37)` where `idx * 37 % 37` is always zero, so five
matchups printed byte-identical rows; and Q67's kick funnel labelled its men
"kicker" and "boxer" while giving them the same stat block and palette.

**How to apply:** identical is not only the stat block. Check all of —
- **the stats key**: `"attributes"` yields an EMPTY stats block because the
  engine reads `athlete["stats"]`. Three separate instances (R133, C96, Q67).
- **known techniques**: a fighter with no `technique_progress` record gets his
  RULESET's whole tier 1–2 palette (`FightMoves.gd:191`), and disciplines come
  from the ruleset not the fighter (`:428`) — so a "boxer" in a kickboxing bout
  knows every kick unless you give him a progress record.
- frame, discipline and plan.

A measurement must **name its population in its own output**, and per [[project_fight_stage_state_2026-09-09]] also name the catalogue it loaded — a
fixture is the fighters AND the data they fight under. Same-seed reruns are
legitimate only as the determinism tripwire, never as a population measurement.

**SECOND HALF OF THE RULE (operator, same day): a fighter must be LEGAL for
the ruleset he is in.** A boxer does not appear in a kickboxing bout. The
obvious repair to rule 1 - giving the "boxer" a boxing-only progress record -
produced a man who could not kick under rules that permit kicking, halved the
kicks thrown and dropped the leg share to 1.64%: a second unreal fixture, not a
better one. **Differentiate by STYLE INSIDE the ruleset** (which branches a man
trained), never by removing what the ruleset legally permits. Differentiating by
rep counts alone changes nothing and the run comes back byte-identical - that
was the fourth breach, committed while writing the rule down.

Related: [[feedback_assert_the_quantity_the_user_sees]],
[[feedback_godot_verification_gate]].
