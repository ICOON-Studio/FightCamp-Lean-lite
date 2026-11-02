---
name: project_session_S49_2026-09-22
description: S49 - grapple moves named, free camera, four cage bugs, seven agents put on standing work
metadata:
  type: project
---

**S49, 2026-09-22.** Engine: the grapple move is now NAMED at every
`_log_grapple` site - 0.6% -> 97.8% of events, 3 -> 23 distinct techniques -
and the picker reads `via` and filters the palette by PHASE. The beat adapter
was NOT over-collapsing; the engine simply never named the move.

Every ruleset now fields a legal differentiated pair: a BJJ bout was being
fought by two BOXERS, because `demo_fighter` chose between MMA_STYLES and one
boxing table for all nine other rulesets.

**FREE CAMERA in the live room** - drag to orbit, wheel to zoom, R to reset.
An untouched camera is byte-identical, so every A/B recording stays comparable
(`fight_camera_orbit_test`, 64/0). It is also the cheapest instrument for
occlusion-vs-interpenetration: one man in front of another resolves when the
angle changes, two bodies in one space do not.

**The cage had FOUR bugs, and the operator found one of them by orbiting the
new camera:** an opaque fence (a six-digit hex under TRANSPARENCY_ALPHA);
an octagon that never closed (arc at the circumradius instead of chord at the
apothem); panels rotated EXACTLY 90 degrees wrong at every angle; and decks
casting 11 m shadows. Cursor then traced the last streak to `fence_5`
chain-link moire.

**Arena dimensions EXIST and are sourced** - R61 read the governing bodies'
PDFs into `arena_specs.json`. I said "the schematics do not exist" and was
wrong; what is missing is ART. See [[feedback_check_research_record_first]].

Seven agents were put on standing long-running work
([[feedback_long_running_agent_tasks]]). The ~90 stale OPEN board entries were
asked for and NOT cleaned - that is S50's.
