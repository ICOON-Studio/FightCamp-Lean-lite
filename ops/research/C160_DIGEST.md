# C160 digest

Added the blind depth-radius contract witness at
`Godot/tests/fighter_depth_radius_contract_test.gd`.

It covers exact capsule shape, metre/range checks, explicit zero allowances,
depth provenance and cross-rig axis agreement, strict breadth-minus-depth
allowance, symmetric sorted anatomy, both shipped rigs, order independence, and
four injected mutant copies.

Verification: `check_scripts.py` passed; the single Godot gate passed with
`checks=186 failures=0`. The four required mutants fired and `swap_rig_order`
remained green.
