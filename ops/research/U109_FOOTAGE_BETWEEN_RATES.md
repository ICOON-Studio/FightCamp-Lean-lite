# U109 - what fighters do between punches, measured

## POPULATION

- -vPZqptk8jo: camera side-on, boxing partner drill, 88.2 s usable (denominator excludes punch windows)
- 2m1Ftv_l_Xc: camera side-on, boxing partner drill, 0.0 s usable (denominator excludes punch windows)
- 7pIskYcLKVw: camera side-on, boxing partner drill, 0.0 s usable (denominator excludes punch windows)
- FCM7m6TJWUQ: camera side-on, boxing partner drill, 44.4 s usable (denominator excludes punch windows)
- HFSZxKUUE98: camera side-on, boxing slow motion, 0.0 s usable (denominator excludes punch windows)
- HL261oRyURE: camera side-on, boxing partner drill, 51.0 s usable (denominator excludes punch windows)
- LfpNJ5fIYA4: camera side-on, boxing partner drill, 0.0 s usable (denominator excludes punch windows)
- XIja1S9SXI4: camera three-quarter, boxing coaching demo, 104.8 s usable (denominator excludes punch windows)
- _mkFV2H2oCk_r1: camera side-on, UFC MMA broadcast round 1, 86.5 s usable (denominator excludes punch windows)
- cyXGrr7YTeg: camera side-on, boxing partner drill, 0.0 s usable (denominator excludes punch windows)
- d_PSlBJheZI: camera side-on, boxing gym sparring body shots, 0.4 s usable (denominator excludes punch windows)
- isLkzN3d7rA: camera side-on, boxing partner drill, 0.0 s usable (denominator excludes punch windows)
- kuABaA2PY0U: camera side-on, boxing gym sparring, 27.3 s usable (denominator excludes punch windows)
- vOFmsN3JROs: camera side-on, boxing partner drill, 4.8 s usable (denominator excludes punch windows)
- wzUWvsviqTM: camera side-on, pro boxing bout ringside, 109.6 s usable (denominator excludes punch windows)
- xaXXD-w45b0: camera three-quarter, amateur boxing bout, 13.5 s usable (denominator excludes punch windows)
- yg_N42n_Jdk: camera side-on, boxing gym sparring, 13.6 s usable (denominator excludes punch windows)

## RATES

| kind | pooled /min | UFC round /min | p50 magnitude_T | p90 duration_s | n | LABEL |
| --- | --- | --- | --- | --- | --- | --- |
| lead_foot_crossings | 7.5 | 4.9 | 0.225 | 1.616 | 57 | MEASURED (footage) |
| direction_changes | 3.7 | 2.1 | 0.423 | 0.400 | 28 | MEASURED (footage) |
| resets | 0.4 | 0.0 | 0.175 | 0.300 | 3 | MEASURED (footage) |
| level_changes | 17.2 | 27.8 | 0.094 | 0.920 | 131 | MEASURED (footage) |
| head_moves | 70.6 | 105.5 | 0.148 | 0.300 | 539 | MEASURED (footage) |
| turn_yaw_deg_s | p50=35.0 deg/s | p50=27.3 deg/s | p90=113.6 | max=342.4 | — | MEASURED (footage) |

## METHOD

- All lengths in torso lengths (T); identity and `usable()` match `pair_events.py`.
- lead_foot_crossings: lead-ankle lateral offset from hip midline changes sign, held >= 0.25 s (threshold-sensitive).
- **lead_foot_crossings IS NOT A STANCE SWITCH.** It was called `stance_switches` until 2026-09-20 and the name was wrong: it counts the leading ankle crossing the hip midline, which is ordinary foot traffic - shuffles, steps and pivots - and it fires 7.5 times a minute. A boxer changing ORTHODOX to SOUTHPAW is a rare, deliberate event, a handful of times in a whole bout at most, and nothing in this pass measures it. Do not bind a stance-switching rule to this row.
- direction_changes: hip-mid lateral velocity sign reverses at >= 0.15 T/s (3-frame smooth), new sign holds >= 0.4 s, displacement >= 0.20 T across reversal (threshold-sensitive).
- resets: both wrists in a chin band (nose y - 0.05 T to nose y + 0.30 T) >= 0.3 s within 1.5 s after a punch window (threshold-sensitive; shoulder height was wrong).
- level_changes: hip height drops >= 0.08 T below 1 s rolling median, returns within 1.2 s.
- head_moves: nose lateral >= 0.10 T in 0.30 s while hips move < 0.05 T.
- turn_yaw_deg_s: hip-line normal rate deg/s; L/R hip label unswap (minimum assignment); shoulder/hip width-collapse gates; |d_yaw| >= 60 deg pairs excluded as unresolvable; 5-wide median on the RATES; per-minute omitted.
- turn_yaw_deg_s MAX carries L/R label swap artefacts and is NOT a measurement: MediaPipe exchanges the left and right landmarks when a man turns edge-on, which reads as 180 deg x fps. Use the p50 and p90; the max is printed for transparency only.
- -vPZqptk8jo: fps=50.000 from events file (never npz)
- 2m1Ftv_l_Xc: fps=25.000 from events file (never npz)
- 7pIskYcLKVw: fps=29.000 from events file (never npz)
- FCM7m6TJWUQ: fps=50.000 from events file (never npz)
- HFSZxKUUE98: fps=59.945 from events file (never npz)
- HL261oRyURE: fps=50.000 from events file (never npz)
- LfpNJ5fIYA4: fps=60.000 from events file (never npz)
- XIja1S9SXI4: fps=29.970 from events file (never npz)
- _mkFV2H2oCk_r1: fps=29.970 from events file (never npz)
- cyXGrr7YTeg: fps=25.000 from events file (never npz)
- d_PSlBJheZI: fps=59.950 from events file (never npz)
- isLkzN3d7rA: fps=60.000 from events file (never npz)
- kuABaA2PY0U: fps=29.970 from events file (never npz)
- vOFmsN3JROs: fps=59.940 from events file (never npz)
- wzUWvsviqTM: fps=29.970 from events file (never npz)
- xaXXD-w45b0: fps=59.816 from events file (never npz)
- yg_N42n_Jdk: fps=29.970 from events file (never npz)

## Open

- Six boxing ids carry no two-man segments (excluded from pooled rates): 2m1Ftv_l_Xc, 7pIskYcLKVw, HFSZxKUUE98, LfpNJ5fIYA4, cyXGrr7YTeg, isLkzN3d7rA.
- Real population: ten boxing videos with usable time plus the kept UFC round.
- UFC round divides by usable seconds inside tracked segments only (126.8 s of 300 s round).
- HFSZxKUUE98 slow-motion: events-file fps used; zero usable segments here.
- Boxing/sparring pool and UFC round are never averaged.
- resets: n=3 pooled across every video. THE n IS TOO SMALL TO BIND A RULE TO - it sits in the same table as rows with hundreds of events and must not be read the same way.
