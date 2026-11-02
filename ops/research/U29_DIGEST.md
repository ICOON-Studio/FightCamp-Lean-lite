# U29 DIGEST — GrappleAdapter blind contract test

## Asserted (from G37 + G34 §1/§2/§8 only)

- `rulesets()` = `[ijf, uww, ibjjf, abc]`; `scores_grappling` true/true/true/false.
- Hold gates: ijf 5/10/20, ibjjf `{score:3}`, **uww and abc empty** (not zero-dicts).
- IJF: takedown not scored; throw bands ippon/waza_ari/yuko; clinch/guard/half/exposure/step_out/unfinished submission not scored.
- UWW bands 2/4/5/2/1 per §1.B; seat `position_change` not scored; **step_out not_scored** (§4 refuse); submission never a finish.
- IBJJF: takedown/throw 2, pass 3, mount/back 4 after 60 ticks; half/guard/standing/clinch/exposure/step_out not scored.
- ABC: every vocabulary event evidence-only (`points == -1`).
- `step_out` not_scored for **all four** rulesets (§4).
- `advantage` IBJJF-only (Art. 5.5: no fire while sequence live); others always 0.
- Junk in → `{kind:not_scored, points:-1}` out.

## Disagreement (red by design)

`GrappleAdapter.award()` returns `{kind:not_scored, points:-1, counter:""}` for **every** scoring emission tried under G34 payload shapes (`kind`/`from_seat`/`to_seat`/`grade`/`held_ticks`/`finished`) plus G37-named extras (`band`, `danger`, `grand_amplitude`, `feet_to_danger`, `reversal`, `top_flip`). Gates, `advantage("ibjjf", …)=1`, ABC refuse, UWW step-out refuse, and junk refuse all pass. Module is present; conversion tables are not firing.

Did not read `GrappleAdapter.gd` or `grapple_adapter_test.gd`.
