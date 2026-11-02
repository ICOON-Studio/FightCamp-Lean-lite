# Q32 DIGEST — Beat stream measurement over 200 boxing bouts

**Tool:** `Godot/tools/measure_beats.gd`
**Deliverable:** `research/Q32_BEAT_STREAM.md`
**Bouts:** 200, seeds 100000–100199, 3-round boxing, two welterweights

## Headline numbers

- **Action beats per fight:** median 66, mean 60.6, range 2–67. No-action: median 6. Ratio ~10:1 action to idle.
- **Regions:** head 65.3 %, torso 28.2 %, left leg 3.3 %, right leg 3.1 %, arms 0.0 % (confirms R84).
- **Contacts:** clean 92.7 %, glancing 5.6 %, absorbed 0.8 %, blocked 0.2 %, slipped 0.1 %, missed 0.5 %.
- **Knockdown in 41.5 % of fights**, flash_knockdown in 32.5 %, shocked in 100 %.
- **Drop rate: 91.9 %** (R97's single-bout 92.6 % confirmed within 0.7 pp).
- **Beat span VARIES:** median 14.0 s but min 0.25 s on the terminal beat of a bout. Clips must handle short beats.
- **Distance:** median 0.89 m, range 0.005–1.10 m. No missing fields. Bodies must slide — fixed stance distance fails at the extremes.
- **Missing fields:** none.
