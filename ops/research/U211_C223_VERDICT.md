# U211 (FOOTLOCK by cause, Cursor) - C223 production gate verdict, S146 2026-10-02: NOT MERGED

Gate: `c223_parallel.py production --jobs 2` in E:/FightCamp/wt/U211 (branch cursor/u211-footlock-by-cause, 162b1bb1),
welter_a + welter_b finished 19:25 (reports `previews/c223/u211_c223__generator_welter_{a,b}.json` in that
worktree); heavy_c/d stopped by Claude once the welter verdict was decisive (PC at 80-85 C).
Same scope string as master's certificate ("production player pipeline A, isolated distinct rigs, no binding promotion"),
same stance offset (0.16). Pass rule = certified_palette_test._proven (move row, mechanical_failures empty).

Result: all 16 certified boxing moves that pass on master (s136_bound.json) FAIL on U211, on BOTH welter rigs (32 of 32
pairs regress, 0 improve). Examples, welter_a, master -> U211:
- boxing_lead_hook: contact_slip 0.005 -> 13.9 cm, skate p95 0.0002 -> 1.74 m/s, join_root 1.2 -> 2.9 cm, skin_floor 0 -> 2.2 cm;
  fails recovery_clock, join_discontinuity, contact_slip_cm, peak_fist_band, target_line.
- boxing_cross: join_hand 1.6 -> 2.7 cm; fails join_discontinuity, peak_fist_band, target_line.
- boxing_jab: contact_slip 0.002 -> 0.16 cm; fails peak_fist_band, target_line.
Read: the footlock planner moves the feet/root inside strikes - slide went down 30% in bouts (S144) but the certified
clips no longer hold their contact and target line. Caveat: U211 branches from S141; a master run of the same gate is
the clean control (not run - the regression size makes it moot).
Next: send-back when a Cursor/Codex seat returns - the planner must not touch the root/feet inside a certified clip's
contact window (gate: this same production run, 0 regressions vs master).
