# KNOWBOTS6 Result: Does a shared misread make knowing a boxer pay?

Status: PROBE COMPLETE. Discipline: boxing.
Red Test: `tools/knowbots6_probe.gd -> KNOWBOTS6 done`

## Method
Same worlds, signers and measures as KNOWBOTS5. Added one probe-side lever: a prospect-level shared offset.
Each prospect draws `s` uniform in -0.6..0.6 (hash of its seed). Every attribute's offset becomes:
`rho * s + (1 - rho) * own_offset` where own_offset = Knowledge._offset's value.
Then the centre is built exactly as Knowledge.range_of builds it (truth + (offset + hype lift) x width).

## Arms
rho = 0.0 (control, must equal KNOWBOTS5), 0.5, 0.8, 1.0
Signers: BLIND and ORACLE only

## Results
Control match: true
Mean |shown - true| errors: [0.85503152073733, 1.77121960061444, 2.72317584024578, 3.3693753609831]
Pass rho: 0.5
Top10 at pass rho: [8.69565217391304, 9.78260869565217, 14.4444444444444]

## Timing
Pilot: 57.89 s
Projected: 2605.14 s (43.42 min)
