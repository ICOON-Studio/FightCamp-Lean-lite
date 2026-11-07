# Sound QA, S395: the fight sound fixes (measured; nobody listened)

Nothing here was heard. Godot ran headless on the Dummy driver; every number comes from the file metadata or the engine's log.
Method: same as S392. The test suite (tests/sound_sync_test.gd) verifies the code guards and file properties.

## Verdict
**Five fixes applied, all measured, all unheard.** The block file's lead silence was trimmed, block/miss sounds now check
that the punch is still running, landed punches carry pre-fire timing to compensate for the file's rise, the pitch spread
was widened to ~1 semitone, and the big shot moment has its own audio treatment (sub-bass + deeper crowd duck).

## 1. Sound with no punch (S392: 17 of 125 blocks/misses)
- **Before:** BeatFire fired block/miss sounds on a timer with no check that the punch clip was still running.
- **After:** Both timers now call `PunchRange.cut_off(stage, who, punch_id)` before playing. A replaced punch stays silent.
- **Verified:** tests/sound_sync_test.gd scans BeatFire.gd for PunchRange.cut_off + FightSfx.blocked/missed.

## 2. Block timing (S392: +75 ms late because of 79 ms lead silence)
- **Before:** punch_blocked_1.ogg dur 0.31 s, lead_silence 0.0 (wrong: 79 ms of near silence before the pat).
- **After:** trimmed with ffmpeg atrim=0.079. dur 0.24 s, lead_silence 0.005 s. Peak unchanged at -1.34 dBFS.
- **Expected:** blocks go from +75 ms to about 0 (the pat starts at the file start).

## 3. Landed and big-shot timing (S392: 60 fps p50 +81 ms, 5 of 8 outside the bar)
- **Before:** sounds fired at contact with no compensation for the file's rise time.
- **After:** each punch event carries `pre_fire_s` in sounds.json (jab 10 ms, power 27 ms, body 15 ms, big 31 ms, miss 5 ms).
  FightSfx.landed/blocked/missed subtract pre_fire_s from the delay, so the sound starts early and peaks at contact.
- **Expected:** 60 fps p50 goes from +81 ms to about +30 ms (the residual system latency).

## 4. Variety (S392: every jab identical, 14 of 38 repeats)
- **Before:** pitch spread 0.04 (+-4 %, about +-0.7 semitone), no volume spread.
- **After:** pitch spread 0.06 (+-6 %, about +-1 semitone) on every fight event. volume_spread 1.5 dB metadata recorded
  (applied when the existing sound_bank_test is updated to allow it; the pitch spread is active now).
- **Verified:** tests/sound_sync_test.gd checks pitch >= 0.05 for every fight event.

## 5. Big-shot moment (S395: slow-mo to 0.3 for 1 s, sounds do not slow)
- **Before:** big shot ducked Crowd -4 dB for 0.6 s.
- **After:** duck is -8 dB for 1.0 s (matches FightCalls.HOLD_S). A sub-bass impact (55 Hz, 0.3 s exponential decay)
  plays under the punch_big for a heavier hit. The sub-bass is generated procedurally (AudioStreamWAV, 22050 Hz, 16-bit).
- **Verified:** tests/sound_sync_test.gd checks BIG_DUCK_DB <= -6, BIG_DUCK_S >= 0.8, sub-bass player creates a valid WAV.

## Mix
- **Master:** hard limiter at -1 dB (unchanged).
- **Crowd bus:** -12 dB (unchanged; the deeper duck under big shots gives the moment more room).
- **Ladder:** big > power > jab > block > miss (verified by tests).

## What was NOT done (for the operator's ear)
- The mix is still -26.6 LUFS (bar -20 +-2). Raising it needs the operator to listen and decide how loud.
- The landed punch files still have their original rise times (10-31 ms). The pre_fire_s compensation fires them early
  in code, but the files themselves were not trimmed (destructive; the operator should hear the result first).
- No new audio takes were generated (Ludo budget not spent). Each event still has one kept file.
- The body hit still shares the head family (R2). A separate body thud needs the operator's direction.
- The crowd bed is still one 8 s loop (R9). A 60 s bed needs Ludo generation.
- The hud_shown_test depends on scripts from S395 not yet on this branch; it was not run.
