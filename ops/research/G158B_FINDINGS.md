# G158B Findings — three held-out switch tests

Date: 2026-10-10. Agent: Qwen. Worktree: G158B, branch qwen/g158b.

## angle_guard (engine-only, 12 seeds, two boxers)

### Test fix
The original test had c228_n=0 in the OFF arm because the engine only populates
the c228 dictionary while the switch is ON. The test-computed share (from the
action log) was used for the check but both arms got 0.097 — a coincidence
because the OFF arm's c228 was empty.

Fix: both arms now compute the same angle-attack landed share from the action
log (n_angled_landed / n_landed). The engine c228 is printed for reference but
NOT used for the check. Added explicit n > 0 check for angled_landed in each arm.

### Result (12 seeds, SEED0=228100)

| Arm | effective | n_landed | n_angled_landed | share  | c228_n |
|-----|-----------|----------|-----------------|--------|--------|
| OFF | false     | 801      | 78              | 0.097  | 0      |
| ON  | true      | 827      | 80              | 0.097  | 4364   |

- Both arms have n_angled_landed > 0 (fix confirmed).
- Share is identical to 3 decimal places (0.097).
- The engine's angle_guard does NOT change the angle-attack landed share.
- **Verdict: FAIL — genuine red.** The switch does not affect this metric.

### Mutant (G158_MUTANT=angle_guard)
Both arms identical (801/78/0.097 vs 801/78/0.097). Exit code 1. **Mutant FAIL confirmed.**

---

## contact_push_on_line (room, seed 92012, 600 frames @ 30 fps)

### Seed limitation
The room library (`tools/switch_gate_room.gd`) hardcodes `SEED := 92012` and
does not expose a seed parameter or env var. The library is read-only per task
rules. Multi-seed runs require editing the library. **Single-seed result below.**

### Result

| Arm | effective | lat_m (m) | lat_max (m) | n pushes |
|-----|-----------|-----------|-------------|----------|
| OFF | false     | 1.802     | 0.151       | 66       |
| ON  | true      | 1.345     | 0.123       | 58       |

- Ratio ON/OFF = 1.345 / 1.802 = **0.746** (threshold: ≤ 0.700).
- The switch reduces lateral push by ~25.4%, not the required 30%.
- **Verdict: FAIL — genuine red.** The switch helps but not enough to meet threshold.

### Mutant
Not run (room test takes ~5.5 min per arm; library can't vary seed for mutant).

---

## hand_contact_sync (room, seed 92012, 600 frames @ 30 fps)

### Seed limitation
Same as contact_push_on_line — single seed only.

### Result

| Arm | effective | hand_pops |
|-----|-----------|-----------|
| OFF | false     | 23        |
| ON  | true      | 24        |

- ON has MORE hand pops than OFF (24 > 23). The test wants ON < OFF.
- **Verdict: FAIL — genuine red.** The switch does not reduce hand pops.
- Either the CHOP3 fix (merged S134b as 8a2a0072) does not reduce pops, or the
  pop_count metric is blind to what it fixes.

### Pop frames
The library's pop_count walks frames but does not expose per-frame pop indices
or bone names. Tracking per-frame pop data requires editing the library
(read-only). The total counts (ON 24, OFF 23) are reported above.

---

## Summary

| Switch                  | ON value   | OFF value  | Threshold      | Ratio  | Verdict     |
|-------------------------|------------|------------|----------------|--------|-------------|
| angle_guard             | share 0.097| share 0.097| ON > OFF       | 1.000  | FAIL (genuine) |
| contact_push_on_line    | lat 1.345  | lat 1.802  | ON ≤ 0.7×OFF   | 0.746  | FAIL (genuine) |
| hand_contact_sync       | pops 24    | pops 23    | ON < OFF       | —      | FAIL (genuine) |

All three are genuine reds — the switches do not meet their thresholds. No
threshold was loosened. No engine or library code was modified.

### angle_guard test fix
The test was fixed to measure the same metric in both arms (action-log
angle-attack landed share, n > 0 each). The metric is identical in both arms,
confirming the engine's angle_guard does not affect the angle-attack landed
share. The mutant correctly forces both arms identical (FAIL count: 1).

### What a human would do (per task)
1. angle_guard: test fixed. Metric is honest. Engine switch does not affect it.
2. contact_push_on_line: switch helps ~25%, threshold wants 30%. Decide:
   tighten the engine mechanism, or loosen the threshold to 0.75×.
3. hand_contact_sync: switch does not reduce pops. Either the fix is ineffective
   or the metric is blind to it. Check on the game camera.

## Claude's verdict (S191, 2026-10-10)
- The three tests stay OFF master (on qwen/g158b, dc72d792): each is red because the SWITCH does not do its job, not because the test is
  wrong - merging them would only turn the nightly red without fixing anything.
- angle_guard: with the test fixed both arms measure the same metric (n 801 / 827) and read 0.097 / 0.097 -> the switch has NO effect on
  angled-landed share. ENGINE finding -> task ANGLE1 (Codex): find why angle_guard changes nothing; fix or retire the switch.
- hand_contact_sync (= CHOP3's merged fix, S134b 8a2a0072): pops ON 24 vs OFF 23 -> the hand-pop fix does not cut pops. ENGINE finding ->
  CHOP4 (Codex): measure pops per clip on the game camera, fix the writer.
- contact_push_on_line: helps 25% (1.802 -> 1.345 m), not 30%. Threshold vs mechanism undecided; one seed only (switch_gate_room.gd
  hardcodes SEED 92012) - a multi-seed census comes first (PUSH1).
