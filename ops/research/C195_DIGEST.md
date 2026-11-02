# C195 — blind feint contract test

Added `Godot/tests/fight_feint_blind_test.gd`, written from the `FightFeint`
definition and the realtime engine contract without reading the shipped feint
test, probe, digest, or implementation bodies. It covers the pure bands,
decay, stat defaults, family selection, lift/window boundaries, direct
reaction/reset semantics, and an OFF/ON boxing population with two distinct
fighters. The clean gate reported `FIGHT_FEINT_BLIND checks=62 failures=0`.

Mutation proof (each was reverted immediately):

- flip reaction roll: 1 failure
- drop unanswered increment: 1 failure
- move follow-up window start: 1 failure
- drop glancing from landed contacts: 2 failures
- invert follow-up counter branch: 1 failure

No contract disagreement found. No production file remains changed.
