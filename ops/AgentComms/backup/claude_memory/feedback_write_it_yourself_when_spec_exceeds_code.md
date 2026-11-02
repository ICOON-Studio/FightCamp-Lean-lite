---
name: feedback-write-it-yourself-when-spec-exceeds-code
description: "Don't delegate work whose spec is as long as the code; write it. Judge by spec-to-delivery ratio plus whether judgement is needed."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 87fced1b-c222-4236-959a-4bbf73a65bc1
  modified: 2026-09-09T01:59:32.143Z
---

Delegating a task costs the task file, the review of what comes back, and any
ambiguity the prose introduced. When the spec is as long as the implementation
and needs no judgement, writing the code myself is cheaper on every axis -
including my own token budget, since dense prose costs more output than the
code it describes.

**Why:** operator challenge 2026-09-09 - "5 minutes to write the task to Grok,
he finishes in 47 seconds, how is that efficient?" Correct. Measured on that
day's work:

- G27: 100-line task file -> 63-line `RingPlace.gd`, zero judgement (the
  contract table specified all nine transitions). Bad trade. It also cost a
  cell-by-cell review pass and surfaced a contract ambiguity that only existed
  because the behaviour was written in prose instead of code.
- Q12: ~95-line task file -> a three-literal change I had **already fully
  diagnosed** (exact lines, root cause, the fix). Worst trade of the day, and
  mine from that session.
- U19: 108-line brief -> 567 lines across 11 files with real design work. Worth
  it.
- C61: ~110-line brief -> a 200-bouts x 5-levels x 2-conditions measurement
  study plus a 500-bout matchup. Worth it; could not have been done faster
  myself.

**How to apply:** before writing a task file, estimate spec lines vs delivered
lines and ask whether the work needs judgement I would otherwise have to
duplicate. Roughly 1:1 with no judgement -> write it myself. Several-fold
leverage, or genuine design/measurement work -> delegate.

The module/test split rule ([[project-qwen-build-agent]], and the shell-less
rule in CLAUDE.md) is **not** a counter-argument: it requires a written
*contract*, not a delegated *module*. Writing the contract and the module
myself still lets the test be written independently from that contract. A
test-only contract is ~25 lines, not a 100-line task file.

Does not override the shell-less agents' constraints ([[feedback-gloss-every-task-code]],
[[project-mailbox-scoped-to-readers]]) - it changes what is worth giving them,
not what they are capable of.
