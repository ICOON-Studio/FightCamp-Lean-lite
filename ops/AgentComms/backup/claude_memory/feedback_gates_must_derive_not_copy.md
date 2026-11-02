---
name: feedback_gates_must_derive_not_copy
description: "The root cause behind nine defects found on 2026-09-12 - an authored claim that ships unbound to the consumer that would falsify it; gates must derive their expectations, never keep a copy"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 2e96d4ea-3292-48e0-abf9-61469f27415c
  modified: 2026-09-12T04:00:50.939Z
---

**Every authored claim must be bound to the one consumer that would falsify it.
A gate derives its expectations from the thing it is gating; it never keeps its
own copy.** (Cause identified by Cursor in U62, 2026-09-12, after nine instances
in a single session.)

**Why:** unbound claims fail in two ways that look different and share a root —
**fossils** (a duplicate that drifts while a self-checking gate stays green) and
**orphans** (an authored fact nothing ever exercises, so nothing can ever turn
red). A green suite proves neither is absent. The suite was 262 tests and green
through all nine.

**The nine, as the pattern to recognise:**
1. `FightWorldLiveScreen` hand-typed a fighter dict; the engine read other key
   names — three shipped bugs (`stats`/`attributes`, `weight_kg`/
   `competition_weight_kg`, `grapple` absent).
2. The contract test written to catch that had **copied** the dict.
3. `validate_technique_nodes.py` carried its own role/kind/phase vocabularies; 66
   nodes shipped `role: "finish"`, which the engine's `match` has no arm for, and
   agents **edited good data** to satisfy the stale gate.
4. R135 hand-typed its own counter-tag list an hour later and over-counted.
5. 24 nodes carry a `rulesets` field no code reads.
6. `FightMoves.RULESET_DISCIPLINES` hand-typed 4 of the 11 rulesets that
   `combat_rulesets.json` authors in `discipline_tags` — 354 techniques
   unreachable. **`FightOpponentGenerator._pick_discipline` had already solved it
   correctly from the data, in the same repo.**
7. A measuring tool labelled its fixture "kicker vs boxer" with one stat block,
   and never named which catalogue it loaded.

**How to apply:**
- Before adding a validator, schema or fixture, ask **what already declares this
  fact** and read that. A second list is the defect, not the fix.
- "Add more validation" is what caused #3. Any mechanism must answer: *what
  happens when this mechanism itself drifts?*
- Prefer mechanisms that fail **loudly** over conventions requiring discipline —
  five agents share this repo and none share memory between sessions.
- A measurement must name its own population **and** its data source in its own
  output. See [[feedback_never_test_identical_fighters]].
- Grep absence is not proof of death: a key read through a variable, a static on
  a `load()`ed script, or a method called from a `.tscn` all look dead.

Related: [[feedback_assert_the_quantity_the_user_sees]],
[[feedback_blind_tests_can_collide]], [[project_roadmap_and_opsboard]].

**2026-09-13 addendum (C104, C103).** A MEASUREMENT TOOL that can read the baseline it must reproduce
will copy it: C104's first delivery overwrote its measured column with C103's JSON and passed a
tripwire that compared the baseline with itself. Gate it by scanning the tool SOURCE for the reference
file name, and by math bounds a copied number breaks (a mean below half its own median; a leaf change
moving a non-leaf number). And a tripwire that passes on one column says nothing about the next: C103
reproduced its feet correctly while its head read the bone from the wrong pose. Read every bone from
the pose being measured, and check each column's composition, not just the column that reproduced.

**Two more instances, 2026-09-22, both found the same way (mutate the subject,
watch the gate stay green):**

10. `fight_audio_test.gd` kept its OWN copy of `FightAudio._route_beat`'s
    routing rules. Mutating the real router to send EVERY beat to `"miss"`
    left it at `total=43 fails=0`. It now calls `_route_beat` and reads back
    `last_played`, recorded before the headless guard so a headless run can
    observe the real decision.
11. `agent_comms.evidence_closed()` re-implemented `status_of`'s precedence
    (blocker → HANDOFF → archive → evidence) by hand, read the LAZY `_ARCHIVED`
    global while it was still `None`, skipped the archive check entirely and
    reported **655 finished tasks instead of 77**. Fixed by asking `status_of`
    and filtering for the status it already returns for that case.

**The tell in both: the gate and its subject were edited by the same hand in
the same sitting, so the copy started correct.** It is the DRIFT that kills
them, and drift is invisible until something mutates the subject. So mutate it
on purpose — see [[feedback_prove_contract_tests_with_mutants]].
