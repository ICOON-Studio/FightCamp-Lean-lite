---
name: feedback_audit_before_more_fix_rounds
description: "S224 animation audit - after 2-3 red fix rounds, stop and audit the whole pipeline from the code; a digest is not code; the code reader beats agents guessing from the brief"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 38843fd0-0b48-4c09-a2fe-8dc8e3813f16
  modified: 2026-10-14T12:54:54.865Z
---

S224 the operator asked for a multi-agent audit after ~10 sessions of red animation rounds. Results (ANIM_AUDIT_VERDICT_S224.md):
the MetaHuman models were fine; Ludo, John and Dola all endorsed MY hypothesis from the brief ("flip the right side") - Codex read the
code and showed the main retarget was already rest-aware and the real bugs were a blind local mirror, fixed-Euler pose layers, a foot
bone-line alignment, a double fold - and that the native MH clips MHNATIVE1's digest called "wired" were never in the code.

**Why:** agents fed a hypothesis tend to echo it; only the one reading file:line can confirm or refute. Ten rounds stacked corrective
layers because nobody traced the worst frame through every stage. A digest claim was trusted for days.

**How to apply:** after two red rounds on the same defect, brief a read-only code audit (file:line, per-stage readback at the worst
frame) before any new fix round; keep my hypothesis out of the external auditors' brief or mark it clearly as unverified; verify any
digest claim of "wired/ON" with a grep of the production call path before building on it. Related: [[reference_how_to_reach_each_agent]].
