# GUARDPROBE3 - size the opponent's adaptation so guard posture is a real choice

Run: `godot --headless --audio-driver Dummy --path . --script res://tools/guard_probe3.gd`.
Seeds 7000-7049, 50 bouts a cell, 12 cells (6 styles x 2 configs).
Arms: N in {2, 3}, S in {0.15, 0.25, 0.35}. Bots: HIGH, LOW, NEUTRAL, SWITCH, WATCH.

## Method

For each cell, run 50 bouts and measure the baseline body share (her body shots / her landed).
Then for each (N, S) arm and each bot, simulate the posture decisions round-by-round:
- Track consecutive rounds of the same posture
- Once counter >= N, the shift happens: body share += S for HIGH, body share -= S for LOW
- For each round, compute the damage using the adjusted body share and posture multipliers

## Results

Cell am3_pressure: baseline_body_share=0.368 (50 bouts)
Cell am3_slugger: baseline_body_share=0.217 (50 bouts)
Cell am3_outboxer: baseline_body_share=0.214 (50 bouts)
Cell am3_counter: baseline_body_share=0.212 (50 bouts)
Cell am3_volume: baseline_body_share=0.220 (50 bouts)
Cell am3_boxpunch: baseline_body_share=0.214 (50 bouts)
Cell pro6_pressure: baseline_body_share=0.394 (50 bouts)
Cell pro6_slugger: baseline_body_share=0.253 (50 bouts)
Cell pro6_outboxer: baseline_body_share=0.221 (50 bouts)
Cell pro6_counter: baseline_body_share=0.220 (50 bouts)
Cell pro6_volume: baseline_body_share=0.247 (50 bouts)
Cell pro6_boxpunch: baseline_body_share=0.228 (50 bouts)

## Arm results

### Arm N=2_S=0.15
Best bot per cell: { "HIGH": 12, "LOW": 0, "NEUTRAL": 0, "SWITCH": 0, "WATCH": 0 }
Max count: 12, bots above 15%: 1, passes: false

### Arm N=2_S=0.25
Best bot per cell: { "HIGH": 10, "LOW": 0, "NEUTRAL": 1, "SWITCH": 0, "WATCH": 1 }
Max count: 10, bots above 15%: 1, passes: false

### Arm N=2_S=0.35
Best bot per cell: { "HIGH": 2, "LOW": 0, "NEUTRAL": 1, "SWITCH": 0, "WATCH": 9 }
Max count: 9, bots above 15%: 2, passes: false

### Arm N=3_S=0.15
Best bot per cell: { "HIGH": 12, "LOW": 0, "NEUTRAL": 0, "SWITCH": 0, "WATCH": 0 }
Max count: 12, bots above 15%: 1, passes: false

### Arm N=3_S=0.25
Best bot per cell: { "HIGH": 11, "LOW": 0, "NEUTRAL": 0, "SWITCH": 0, "WATCH": 1 }
Max count: 11, bots above 15%: 1, passes: false

### Arm N=3_S=0.35
Best bot per cell: { "HIGH": 9, "LOW": 0, "NEUTRAL": 0, "SWITCH": 0, "WATCH": 3 }
Max count: 9, bots above 15%: 2, passes: false

## Summary
NONE - no arm passes the condition
RESULT: tools/guard_probe3.gd -> NONE
