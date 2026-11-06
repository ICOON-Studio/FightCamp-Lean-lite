# Sound QA, S392: is the wired sound in sync and sensibly mixed? (measured; nobody listened)

Nothing here was heard. Godot rendered films on the Dummy driver; every number comes from the film's audio track or the engine's log.
Films: **round** (men's bout, one whole 180 s round, 30 fps, 151 sounds), **big** (59 s, five big shots forced, one knockdown forced), **60 fps** (45 s of round, 8 landed), **bench** (each event alone, bed alone, limiter on and off).
Method: a probe outside the project patched `Sfx`, `BeatFire` and `HitImpact` in memory (no file under scripts/ changed), logging each `Sfx.play`, refusal and landed hit by engine frame, and both gloves and targets on each drawn frame. Each sound was then located in the track by matching its own file, which finds it under the crowd.
"Heard" = file start + the file's own rise to 20 dB under its peak. "Contact" = first frame the striking glove is within 8 cm of the target. Tools, logs, films: E:/FightCamp/tmp/s392/soundqa/.

## Verdict
**Sound fires on the right engine frame, but it is not cleanly in sync.** Nothing lands early. Landed punches run late, at the edge of the bar. Blocks are about 100 ms late because of the file. One block or miss in seven sounds for a punch no longer on screen. The mix is safe but quiet, with levels out of order.

## 1. Sync (bar: 50 ms early to 80 ms late)
| Event | n | Against | p50 | p90 | Worst | Outside bar |
|---|---|---|---|---|---|---|
| Landed, file start, 30 fps | 39 | glove contact | +38 ms | +74 | +78 / -29 | 0 |
| Landed, heard, 30 fps | 39 | glove contact | +48 ms | +97 | +107 | 8 late |
| Landed, heard, 30 fps, contact = 3 cm | 39 | glove contact | +19 ms | +69 | +104 | 2 late |
| Landed, heard, 60 fps | 8 | glove contact | +81 ms | +97 | +99 | 5 late |
| Big shot, heard, 30 fps | 5 | glove contact | +73 ms | +105 | +107 | 2 late |
| Blocked, heard | 21 | glove at full reach | +75 ms | +98 | +102 / -241 | 8 late, 2 early |
| Missed, heard | 51 | glove at full reach | +4 ms | +37 | +494 / -138 | 4 late, 4 early |
| Step, heard | 24 | next foot plant | -65 ms | +10 | -1579 | 13 early |

- Landed: 60 fps is the truer picture. 30 fps steps hide part of the gap, because the reach brings the glove onto the target before the contact time: typically 1 frame early at 30 fps, 2 to 5 at 60 (about 50 ms). The file's rise adds the rest (jab 10 ms, power 27, big 31). By sound at 30 fps: jab +19, body +51, power +70, big +73. The 60 fps sample is small and half power punches.
- Blocks: `punch_blocked_1` has 79 ms of near silence (-43 dBFS) before its pat, though sounds.json says lead_silence 0.0. Every block in every film is heard 93 to 108 ms after its frame.
- Misses: the whoosh lands on full reach, 68 ms (p50) after the glove's fastest frame, and peaks 42 ms after the swing ends. Whether that sounds wrong is for his ear.
- Bells: opening bell on the first playing frame (t=0.00), closing bell at t=180.03, one of each. The bed starts with the first bell. Roar: 241 to 246 ms after contact, 5 of 5. Knockdown thud: one forced sample, about +86 ms from the head reaching the canvas; too few to rate.
- **Sound with no punch: 17 of 125 blocks and misses, all films** (12 of 84 in the round). The attacker's punch clip had been replaced by a hit reaction or another move and the sound played anyway: landed punches check `PunchRange.cut_off`, the delayed block and miss sounds do not. One landed sound (frame 1537, cross) had the glove 13 cm short at best.
- **Contact with no sound:** 3 landed beats were cut off and stayed silent by design. In two the glove never came within 18 cm; one jab (frame 4241) came within 5 cm. Another 14 moments had a glove stop within 10 cm of a face or ribs with no sound within 100 ms (6 in idle clips, 8 in punch clips). Not checked by eye.
- Blind check: 167 sudden jumps in the round's audio. 161 trace to a logged sound, 6 to my clapper, none unexplained.
- Steps: one scuff per step_in or step_out beat, 7.9 a minute. Feet stop about 360 times a minute (rough count), so about 3 % have a sound near.

**What the film proves.** A clapper (one white frame and one 1 kHz burst on the same engine frame) ran 16 times at 30 fps: the white frame was always the logged frame, the burst 1 to 13 ms later, no drift over 202 s. Every sound started 3 to 13 ms after its frame began (mixer block plus limiter). So game timing and mixing are proven, and the track is locked to the picture.
**It does not prove** what reaches his ears: the project's 15 ms output latency, the Windows buffer and speakers, or vsync and monitor delay on the picture. Audio delay adds to these lateness figures and picture delay subtracts. Neither was measured; a real driver would have played aloud.

## 2. Mix
- **Round:** -26.6 LUFS integrated, range 9.8 LU, true peak -0.9 dBTP, sample peak -1.00 dBFS, no full-scale samples (ffmpeg ebur128, numpy; 183 s). hud.avi agrees: -26.9 LUFS, -0.9 dBTP.
- **Limiter: installed and working.** Runtime dump: Master has AudioEffectHardLimiter, enabled, ceiling -1.00, added at the first Sfx call. Eight big shots on one frame: -1.00 dBFS and 0 clipped samples with it on, 8,068 clipped with it off. It works on every hard hit, though: power, body and big reach it on 100 % of plays (+0.5, +2.0, +1.5 dBFS before it), so all three read the same peak.
- **Crowd floor:** -39.3 dBFS RMS over the 131 s with nothing else sounding; bed alone -33.1 LUFS. One-shots sound for 28 % of the round. The 13.2 s from the corners to the bell has no sound at all.

| Event (round film; big from both) | File peak | Volume | Peak in film | Loudest 50 ms | Over floor, peak / 50 ms |
|---|---|---|---|---|---|
| punch_big | -1.3 | +4.8 (+2 power) | -1.0 | -7.6 | +38 / +32 |
| punch_power_head | -2.0 | +6.5 | -1.0 | -12.2 | +38 / +27 |
| punch_jab_head | -1.3 | +3.4 | -2.1 | -13.2 | +37 / +26 |
| punch_blocked | -1.4 | +2.2 | -3.3 | -14.0 | +36 / +25 |
| punch_body | -1.5 | +7.5 | -1.0 | -17.1 | +38 / +22 |
| punch_miss | -5.0 | 0 | -9.0 | -18.4 | +30 / +21 |
| footwork_canvas | -9.8 | 0 | -13.3 | -24.4 | +26 / +15 |
| bell start / end | -3.9 / -6.7 | 0 | -8.1 / -11.4 | -18.5 / -20.4 | +31 / +21, +28 / +19 |
| crowd_roar | -3.7 | 0 | -13.1 | -22.4 | +26 / +17 |

Out of order: a block is within 1 dB of a landed jab, and a body shot is 4 dB under a jab.

**SOUND_BENCHMARK_S385 rules, measured.** R1, R10, R19, R20, R21 are not built, so not rated. R11 asks for 30 minutes of play; this is 3.
PASS: R5 pitch (-70 to +66 cents) · R7 big shot never ducked · R8 hush depth and loudest second · R9 roar inside 300 ms · R13 48 kHz · R14 mono and most tails · R16 bell +19 dB over bed · R17 no commentary · R24 13 of 13 kept.
FAIL: **R2** body centroid 424 Hz is 98 % of head 432 (bar 70 %) · **R3** 1 file per event (bar 3 to 10) · **R4** no-repeat cannot work on one file · **R5** no volume spread, though SOUND_LIST promises +-1.5 dB · **R6** only big passes power · **R7** duck -4 dB (bar 6 to 9), none under normal punches · **R8** hush starts 0.07 to 0.50 s before the shot (bar 0.6 to 1.0), no low-pass · **R9** one 8 s bed (bar 60 s), no momentum · **R11** -26.6 LUFS (bar -20 +-2), true peak -0.9 (bar -1.0) · **R12** 7 of 13 files off class: power -5.3, body -7.4, big -5.6, miss +4.7, footwork +3.1, bed +5.4, click -4.7 LU · **R13** short sounds are Ogg, not WAV · **R14** block lead 79 ms and tail 0.311 s, footwork lead 8.9 ms · **R15** 28 % of landed inside 33 ms · **R16** no clapper or referee · **R22** no sliders · **R23** block -16.4 dB, fall -16.0 dB (bar 15).
Lint: DC offset over 0.001 on 5 files (miss -0.0097, block -0.0061, body +0.0042, start bell -0.0041, power +0.0023). Bed seam 3.8 dB (bar 1). 63 to 77 % of power, jab and big energy sits under 120 Hz.

## 3. Repetition
Per minute in the round: 12.8 landed punches (jab 4.9, power 5.3, body 2.0, big 0.7), 8.2 blocks, 19.4 misses, 7.9 steps. That is 40 punch-family sounds a minute from 6 files, each play the same waveform at the same level with only pitch moved. 14 of 38 landed punches used the same file as the one before. Back-to-back plays of one event land within 0.5 % pitch about 1 time in 8 (17 of 139). The bed repeats 22.5 times a round (correlation 1.0000 at 8.000 s).

## 4. Cooldowns and pool
Nothing is swallowed in a fast combination. 191 `Sfx.play` calls in the round and big films: 0 refused, 0 voices stolen, all fired; busiest pool 3 of 16. Only crowd_roar has a cooldown. Forcing 40 sounds on one frame: 16 played, 24 stole a voice, none refused.
**One real refusal:** at a knockdown the fall's roar is refused by the 2 s cooldown the big shot's roar just started (real order, real time: 2 calls, 1 played), so the crowd does not answer the fall. The cooldown reads the wall clock, so films under-count it.

## Could not measure
How it sounds; real-speaker sync; a natural knockdown (mine was forced, not after a big shot); 2x fast mode; the walk-in intro and corner minute; women's bouts and BJJ; the R2, R6, R23 ear tests. Another agent edited HUD and body files during the films; no sound file changed.

## Fixes, in order
No new audio:
1. Cut the 75 ms lead off `punch_blocked_1` (or start playback there). Blocks go from +75 ms to about 0.
2. Fire block and miss sounds from a BeatFire timer that checks `PunchRange.cut_off`. Removes the 14 % with no punch.
3. Landed sound about 50 ms before the contact time, in seconds rather than frames, with the power and big rise cut to 5 ms. Simulated on the round with one frame (33 ms): p50 +10, p90 +46, none late, 74 % inside 33 ms. Re-measure at 60 fps.
4. Knockdown roar skips the cooldown; cooldowns use game time. Add the promised +-1.5 dB volume spread. Remove DC from the 5 files.
5. For his ear: hush starts 0.6 s or more before a big shot (the beat is known); big duck -4 to -8 dB; bed starts at the walk-in.
6. For his ear: body up, block down 3 dB, power and body 2 to 3 dB off the limiter. Crowd bus -12 to -6 gives about -24.2 LUFS (estimate: bed added to the film track); -20 needs Crowd near 0, so R11 is his call.
New sounds, for his ear:
7. Variants to R3: 8 each for jab, power, body; 6 for block and miss; 10 steps; 3 big; 4 roars. The biggest gain in this report.
8. A body hit that differs from a head hit (R2). A bed of 60 s or more with a clean seam, then calm, tense and roaring beds. More 1 to 5 kHz in the block and fall.
