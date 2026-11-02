# C15 — Ring Read API

`GameState.get_ring_read_contract(bout, fight_state, observation_mode)` is a
copy-safe read for the RING build. It adds explicit `watch` mode, keeps LAB
stakes suppressed, and projects each fighter's head/body/legs/gas rail,
arrival chips, plan contingency calls, and the live combo's eight-second
window. `classify_ring_method()` maps raw results to IPPON, TECHNICAL,
DOCTOR, DECISION, or KO without changing resolution or settlement.

Owned changes are append-only `GameState.gd` plus `ring_api_test.gd`; no RING
screen or fight/corner math changed. Evidence: parse gate 2/2; focused C15
9/9; `smoke_test.gd` green. A full-suite wrapper ran with elevated isolated
user data but detached its aggregate summary in this shell, so no suite count
is claimed.
