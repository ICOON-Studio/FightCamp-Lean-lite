---
name: feedback_break_on_first_hit_names_the_wrong_cause
description: "A loop that breaks on the first blocker reports a cause determined by iteration order, not geometry"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 928672c1-cd85-44c1-9dba-06a222f809a3
  modified: 2026-09-22T10:18:20.429Z
---

A diagnostic that stops at the **first** candidate it finds reports a cause that
depends on iteration order. Two honest tools over the same data will then name
different causes and both will look right.

S48 (2026-09-22): the S47 reachability audit named `thorax` as the neck's
blocker; Codex's blind C158 test named `head` — same rigs, same method. Both
loops `break` on the first capsule that blocks, so each reported whichever came
first in its own iteration. Scoring every candidate and keeping the **deepest**
gave the real answer: **both** (head 39 directions / 0.169 m, thorax 89 / 0.181 m).

**Why:** the wrong single name sends the next session at the wrong subject. A
whole stage was nearly scoped around narrowing the thorax to expose the neck,
when the head blob buries it just as thoroughly.

**How to apply:** in any "what is obstructing / what failed / what matched"
scan, do not `break` — score every candidate, keep the extremum, and print the
**full list with its per-candidate depth or count**. When two agents disagree
about a cause off the same data, suspect a shared early-exit before suspecting
either measurement. Related: [[feedback_blind_tests_can_collide]],
[[feedback_census_before_you_choose_what_to_refuse]].
