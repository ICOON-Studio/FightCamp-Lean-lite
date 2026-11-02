---
name: feedback_gate_research_agents
description: "Qwen and Cursor answer the question they prefer; a research task needs a check script they must run to exit 0, written and watched failing by Claude first"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 630f77ee-c380-4003-a8d3-fa9a8cecfea8
  modified: 2026-09-14T21:00:35.433Z
---

On 2026-09-12 Qwen's Q70 took THREE passes. Prose corrections failed twice: pass 2
"fixed four things" that were none of the four asked for. Cursor's U70 skipped the
one data point it was told to explain, twice, and left its fix uncommitted. The
third Q70 pass, and Q72 and Q73 on their first, came back clean once each task
carried a machine gate (`research/Q70_check.py`, `Q72_check.py`).

**Why:** a research agent grades its own report against its own reading of the
task. A script that must exit 0 grades it against Claude's reading, and every FAIL
line is a correction it cannot reinterpret.

**How to apply:**
- For any research deliverable with a table, write `research/<ID>_check.py`
  before launch: coverage (every candidate id exactly once), contract field names,
  cross-checks against the catalogue, and the specific false claims already seen
  ("shrink", "dead code") asserted absent.
- Run it on the empty delivery and watch it fail before handing it over — see
  [[feedback_a_gate_that_reads_its_subject_cannot_fail]].
- The gate never decides the content (what is a kick, which seat); it checks the
  adjudication is complete, consistent and cited.
- Put the commit paths ON the commit line in the launch prompt; Cursor's U70
  commit swept in two staged files that were not its own.

**CONFIRMED 2026-09-13 (S1e): six for six.** U72, U73, U74 (Cursor) and Q74, Q75,
Q76 (Qwen) all came back first-pass clean behind gates. What made the difference
beyond 09-12:
- **Watch the gate PASS too, not only fail.** Before launch, run it against the
  empty delivery (must fail) AND a synthetic well-formed delivery built in a fake
  root in the scratchpad (must pass). A gate that can never pass wastes an agent
  run as surely as one that can never fail.
- **Recompute from disk, never read the answer from the delivery:** census cells
  from the catalogue, the generator's prefix rule, the resolver's own logic; anchor
  quotes checked on the exact `file:line`; "the code has X" claims checked by
  grepping the code.
- **Put `git show --stat HEAD` in the prompt** and ask the agent to confirm exactly
  its two files. It still happened once: Qwen's Q74 first commit swept in Cursor's
  mail file, which `agent_comms.py send` had staged.
- Give line windows by `grep -n 'static func <name>'`, not fixed numbers, when
  Claude is editing that file at the same time - its line numbers move.

**CONFIRMED AGAIN 2026-09-14 (S4a): fourteen deliveries, all first pass behind gates** (Q94B, Q96, Q97, Q98;
C112-C115; U89 sb5-6, U90, U91; K43-K45). What the checks had to learn:
- **Derive a definition from an independent census, not the nearest field.** `boxing_jab`'s catalogue `match.role`
  is "setup"; U79's `delivers_blow` is the definition of a strike (Q94 had counted circling as strikes).
- **A number counts as a percentage only when a % sign follows it.** A "share x 100 is allowed" rule let
  "100 checks a minute" (really 600) pass.
- **Exercise every degenerate parameter in a contract test.** C114's `lock_weights` with blend 0 set EVERY frame to
  1.0 while 30 checks passed; the added check was proven to fail on the original.
- **Pin what cannot differ:** per-role counts between presentation variants (C113), a baseline equal to the merged
  numbers on an unchanged engine (Q96 = Q94B), Pythagoras on decomposed rows (Q97), a mirror's reflection (Q98).
- **Word a STOP rule so expected drift cannot trip it.** U89 send-back 5 stopped on a "numbers moved after the
  merge" trap when the new numbers were simply master's since 762fa44; say which baseline is expected.

Related: [[feedback_drive_qwen_and_grok_to_delivery]], [[feedback_gates_must_derive_not_copy]].

**2026-09-14, Q101 (Qwen, rejected after one send-back):** production retarget could not read the Fighting Motions files,
so Qwen wrote its own sampler - floated every body 0.9 m, then posed clips 58-86 deg off - and PUSHED with its check still
failing, both times with confident conclusions in the digest. When a task says "through production", the check must fail
on any other path, and the prompt must say: a blocked production path is a BLOCKED mail and a failing check means no commit.

**2026-09-14, U108 (Cursor, collected first pass after one BLOCKED):** a bound must guard the failure it NAMES. Claude's
"pelvis within [-0.2, 2.5] m (units?)" blocked a correct 207-clip census because a game-authored backflip kick peaks at
2.903 m. A unit error is x100 or x0.01: bound extremes loosely and pin the MEDIAN of a physical quantity (standing pelvis
0.6-1.2 m). Cursor sent BLOCKED instead of editing the check - fix the bound on master, say why in a comment, re-run it
yourself. An independent probe in the check (a fresh importer per clip, run by the check) agreed to 0.0000 m: the pattern
worth reusing for any measurement an agent makes from files.
