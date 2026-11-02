---
name: project-session-s66-2026-09-24
description: "S66 - result screen says why (real-time reads were empty), ledger names payees, C190+U159 merged; operator approved manager contract, asked body map + TRAPS"
metadata:
  node_type: memory
  type: project
  originSessionId: 1929e275-9223-4681-a15b-83320d3ddae6
  modified: 2026-09-24T10:01:28.946Z
---

S66 (2026-09-24), management/GUI lane. Digest `research/S66_DIGEST.md`.

- **Every post-fight read was blind to the real-time engine**: `FightRealtime` logs one record per blow
  (`actor`/`contact`/`region`/`band`/`significant`) and files scorecards as `{round, cards, consensus}`;
  BroadcastRead/PostFightRead/ScorecardRead only knew the old engine's `burst` and top-level `a`/`b`. THE READ,
  round cards, totals, THE RANGE and causation lines were all empty. Fixed in the shared modules. Lesson: when a
  second engine feeds an old reader, check the reader's KEY NAMES against a real log (see [[feedback-a-zero-term-is-invisible]]).
- **PAID TO THE GYM $0** was (a) settlement at the bell clears `pending_fight_result`, so the card read is always
  empty, and (b) the fighter's money labelled as the gym's. By J4 E1/E23 the gym gets a share only via a filed
  manager contract, and nothing files one - the operator APPROVED building it (S67).
- Q167's clip-phase data was wrong under a green test: 81/88 punches timed on a FOOT. Corrected; NO_RETURN 41 -> 20.
- S65's "no ground game was the screen" RETRACTED: the live room has passed `grapple_beats: true` since S6;
  Qwen's probe drove the bare adapter.
- Codex hit its credit limit mid-C190; the operator restored credits; relaunched as a CONTINUATION from the
  salvaged commit via `codex_task.cmd` (not `resume` - a 299k-token context re-bills every turn). C190 + U159
  merged: with both ON, live ankle 31.8/34.8 -> 5.5/7.6 m/s (= vendor control).
- Operator verdict on take three (verbatim in digest): much better, elbows too fast, weird hands while moving,
  still clipping, "right path". -> Cursor U160, Codex C191.
- Agent deliveries rejected on inspection: U160 r1 (caps changed nothing, tables identical), Q166 r3 (finish
  scaled by sqrt(70/attacker_grapple) - worse grapplers tap more). Both sent back with a round.
- Operator direction: TRAPS as an engine state for critical moments (verbatim in digest) - study Grok G72.
  Operator asked for a hoverable segmented BODY MAP on the profile (S68).
- The operator wants to SEE animation as VIDEO, not contact sheets: `tools/s66_hold_video.gd` (Cascadeur pairs
  are in centimetres). [[feedback-show-animation-as-video]]
