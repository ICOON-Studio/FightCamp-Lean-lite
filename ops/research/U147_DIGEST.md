# U147 digest — overlap duration at >3 cm

Population: seed **94301**, arm **A**, 1 round, boxing f01 out-boxer vs f09 pressure puncher / MMA f05 vs f06; `u145_transition_probe.gd` (`stills=off`). Overlap runs exclude paired-grapple and mount-blend frames (U146 easing applies on the standing track only).

Threshold: rendered refused-overlap **depth > 0.03 m** (OPINION_TELEPORTS_SYNTHESIS budget: ≤ 0.1 s at > 3 cm).

## Duration (longest consecutive run above 3 cm)

| Phase | Boxing longest | MMA longest | p90 run | Body jumps (box / mma) |
|---|---:|---:|---:|---|
| U146 defaults (before) | 0.150 s | 0.150 s | 0.033 s | 2 / 4 |
| U147: after 0.05 s >3 cm, gap push 5 m/s cap 0.07 m/frame (after) | 0.150 s | 0.150 s | 0.033 s | 2 / 4 |

Frames above 3 cm (standing): boxing **366**, MMA **177** per round.

## Fix attempts (not shipped)

Raising `_correct_refused_overlap` step toward 0.07–0.10 m/frame while depth > 3–5 cm cut longest runs toward **0.10 s** but **`fight_room_no_teleport_test` failed** (14+ root jumps) and probe boxing jumps rose above the **5 / 8** ceiling. Reverted to gap-only persist boost above.

## Verdict

U146 depth max (0.070 m) was already measured; **duration was not**. Max shallow-overlap runs sit at **0.150 s** (9 frames @ 60 Hz), above the **0.1 s** synthesis cap, mostly on 3–4 cm excess without a safe faster root correction. Next stage likely needs contact/hand yield before root push (synthesis item 1), not a larger hip-gap step alone.

## Gates

- `fight_room_no_teleport_test.gd` — pass (0 teleports)
- `run_tests.py --only room` — 4/0
- `run_tests.py --only world` — 6/0
- `run_tests.py --only grapple` — 10/11 pass (`grapple_naming_contract_test.gd` red; unchanged by this slice)
