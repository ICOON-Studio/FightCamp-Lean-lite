# C193 blind body-map contract test

The new blind test is `Godot/tests/body_map_blind_test.gd`. Parse gate passed:
`CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`. The one clean Godot
run printed `FAILURES 2`.

Retained contract disagreements (the assertions were not weakened):

- The body figure was absent at the required `TabBody/BodyFigure` path after
  mounting `ProfileRevampPanel` and selecting the body tab.
- For an injury before its training date, `region_ceiling` did not equal the
  amber threshold required by the definition.

Mutation checks, each reverted immediately: empty `region_ids` printed 1 FAIL
(the baseline panel failure only; not caught); training threshold `0` printed
4 FAILs (caught); competition threshold `0` printed 2 FAILs (caught);
`get_region_value` returning `0` printed 9 FAILs (caught); the injury ceiling
returning `100` printed 2 FAILs (caught); empty `region_ids` after the explicit
six-region assertion printed 2 FAILs (caught). No shipped code remains changed.

No full suite was run, per the task's new-test-only gate.
