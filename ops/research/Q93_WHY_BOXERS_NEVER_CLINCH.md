## DECISIONS

### Clinch entry sites

| Site | File | Line | Gate | What |
|------|------|------|------|------|
| _tie_up | FightRealtime.gd | 2318 | none (always succeeds) | The only _move_seat whose to_stance is "clinch"; called from _grapple_standing when the gate roll falls in the clinch slice between p_shoot and p_shoot + p_clinch. |

### Ruleset clinch palettes

| Ruleset | Disciplines (resolved) | Clinch-phase moves | Why |
|---------|----------------------|--------------------|-----|
| boxing | boxing | 0 | _scores_grappling returns false: boxing weights none of takedowns, throws, positions or submissions. The grappling system is disabled at bout start (grappling=false) and _run_grapple early-returns before any clinch roll. |
| kickboxing | boxing, kickboxing | 1 (kickboxing_clinch_knee_sweep) | Same _scores_grappling gate as boxing. The node exists in the catalogue but the grappling system is never live to reach it. |
| muay_thai | muay_thai, boxing | 4 (muay_thai_catch_sweep, muay_thai_chapko_lang, muay_thai_chapko_head_sweep, muay_thai_chapko_sweep_throw) | takedowns=1.5 passes _scores_grappling; the muay_thai discipline contributes four clinch-phase techniques. Measured at 1.9% of round time (Q90). |
| mma | boxing, kickboxing, muay_thai, wrestling, judo, brazilian_jiu_jitsu, sambo, mma | 101 (judo throws dominate: 86 nodes; plus wrestling 2, bjj 4, sambo 9, muay_thai 4, kickboxing 1) | takedowns=3.0, positions=1.0, submissions=1.5 all pass _scores_grappling. Eight disciplines feed the palette. Measured at 1.8% (Q90). |

### What a boxing clinch would need

A boxing clinch requires three things that do not exist today. First, `_scores_grappling` must return true for the boxing ruleset - at minimum one of takedowns, throws, positions or submissions must be weighted above zero in the boxing scoring profile. Second, the boxing discipline in the technique catalogue must carry at least one node with a grapple effect and "clinch" in its phases array; it currently has zero grapple nodes of any kind. Third, the CLINCH_ENGAGE_BASE probability (0.0020 per decision tick, shared with all rulesets) would need to produce a boxing-realistic rate - real elite boxers clinch 2.5-4.8 times per round (K38, Davis et al. 2015), roughly ten percent of round time, which is an order of magnitude above what the current constant would yield even if the gate opened.
