---
name: feedback_check_pre_merge_authoring
description: "Before deriving a fix for merged catalogue data, read the merge's first parent - the \"ambiguous\" field was often authored there and flattened by the merge"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 630f77ee-c380-4003-a8d3-fa9a8cecfea8
  modified: 2026-09-12T20:22:00.928Z
---

S1d (2026-09-12) was handed "add plain `ground` to both seat lists" as the fix for
128 unreachable ground nodes. Reading the S1 merge's first parent (`f0710f1`)
showed BJJ had authored `ground_bottom`, `ground_top` and explicit both-seat pairs;
the merge flattened them - and flattened BJJ's physics roles (sweeps to `control`,
escapes to `defense`) the same way S1c found for judo's takedowns.

**Why:** the proposed fix would have let a man on his back pass guard and a man on
top sweep. The authored data was the better answer and it was one `git show` away.

**How to apply:**
- For a merged field that looks unspecified, run
  `git show <merge>^1:<path>` and diff the nodes that existed on both sides first.
- Restore what was authored (rule A), derive only for nodes new in the merge
  (rule B), and print how well the derivation agrees with the authored set - S1d's
  rule B agreed on 39 of 47 and the disagreements were published.
- Then measure in seeded bouts before landing a tree: judo's correct-looking seats
  made judo less like judo and were held.

Related: [[feedback_gates_must_derive_not_copy]], [[feedback_assert_the_quantity_the_user_sees]].
