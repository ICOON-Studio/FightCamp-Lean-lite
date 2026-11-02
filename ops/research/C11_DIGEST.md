# C11 — Set-piece read API

Four disposable-Career projections now supply the rebuilt set-pieces:
fight week, weigh-in, pending fight result, and pending crowning. They add no
save fields and do not resolve weigh-ins, settle fights, or consume crowning.

`setpiece_api_test.gd` drives a real DevJump booking and production
FightSimulation result rather than constructing a pending-result fixture.
Parser: 2/2. Focused: 15/15. Smoke/full-suite runs were attempted with normal
Godot test-save access but are blocked by concurrent R26 work: smoke loads the
currently deleted `scenes/OfficeHub.tscn`, and the suite runners hang behind
that shared-tree state. No C11-focused failure was observed.
