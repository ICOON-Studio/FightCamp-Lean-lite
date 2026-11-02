# C64 digest — reachable flash knockdowns

## Change

- Lowered `FLASH_SHOCK_FLOOR` from `0.25` to `0.07`; the existing head-shock curve and healthy-head gate remain unchanged.
- Made `HEAD_SHOCK_MAX` the reachable force-1.0, zero-condition ceiling (`0.16`) and `LIVER_SHOCK_MAX` the reachable force-1.0 ceiling (`0.04`).
- Added an integration check that feeds `shock_chance`'s output directly into `is_flash_knockdown` at both 100 and 80 head condition, plus reachable-cap and expected-rate checks.

## Balance result

Using the task's representative 125 clean head impacts per fight and evenly sampled force from 0 to 1, the composed rule produces **0.60 expected flash knockdowns per fight at 100 head condition** and **1.49 at the healthy-head floor of 80**. Eligibility begins at force `0.9354` for a fresh head and `0.8539` at 80 condition. The result is non-zero and single-digit while danger rises with wear.

## Gates

- Parse: `CHECK total=2 fails=0 autoload_refs=0 time=0s`
- Focused: `IMPACT_MODEL_TEST PASS checks=40`
- Consumer: `FIGHT_REALTIME_TEST PASS (61 checks)`
- Full suite: `SUITE total=199 fails=0`

The requested rebase could not run because the shared worktree already contained unrelated unstaged changes; after fetch, local `master` and `origin/master` reported no divergence. No unrelated files were modified or staged.
