# C73 digest — G39 clinch fold blind contract

- Shipped `5ee3280`: `Godot/tests/grapple_clinch_contract_test.gd` (137 checks).
- Contract trace: G39 §7.2 four adapter tables; §3.3 IJF landing/osaekomi bands; §5 clocks; §6 refusals; §8 defaults; §9 IJF/UWW grade asymmetry.
- Parse: `CHECK total=1 fails=0`. Focused: `TOTAL=137 fails=13`, expected red, no hang or `SCRIPT ERROR`.
- Findings: IJF `control` osaekomi stayed `not_scored` for side and mount at 5, 9, 10, 19, 20, and 30 seconds (12 assertions); UWW accepted unsupported grand-amplitude facts as 5 instead of refusing them at 4 (1 assertion).
- Full suite: `SUITE total=219 fails=219`; C73 was `rc=1`, while the other 218 were host `engine-error` from `Failed to read the root certificate store.`
