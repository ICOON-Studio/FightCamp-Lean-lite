## DECISIONS

### Native speed and direction per clip
- **H2H_WalkBack.FBX**: native 1.781 m/s, direction 179.8°, 3 planted spans, step 0.611 m NO STUDY (K29 found none), cadence 3.000 steps/s NO STUDY (K29 found none) — twin agrees within 2.8%
- **H2H_WalkBackLeft.FBX**: native 1.781 m/s, direction -135.1°, 3 planted spans, step 0.609 m NO STUDY (K29 found none), cadence 3.000 steps/s NO STUDY (K29 found none) — twin agrees within 2.5%
- **H2H_WalkBackRight.FBX**: native 1.781 m/s, direction 134.9°, 3 planted spans, step 0.612 m NO STUDY (K29 found none), cadence 3.000 steps/s NO STUDY (K29 found none) — twin agrees within 3.0%
- **H2H_WalkForward.FBX**: native 1.736 m/s, direction -0.0°, 2 planted spans, step 0.916 m NO STUDY (K29 found none), cadence 2.000 steps/s NO STUDY (K29 found none) — twin agrees within 5.3%
- **H2H_WalkForwardLeft.FBX**: native 1.735 m/s, direction -45.0°, 3 planted spans, step 0.611 m NO STUDY (K29 found none), cadence 3.000 steps/s NO STUDY (K29 found none) — twin agrees within 5.3%
- **H2H_WalkForwardRight.FBX**: native 1.735 m/s, direction 45.0°, 2 planted spans, step 0.916 m NO STUDY (K29 found none), cadence 2.000 steps/s NO STUDY (K29 found none) — twin agrees within 5.3%
- **H2H_WalkLeft.FBX**: native 1.705 m/s, direction -90.0°, 2 planted spans, step 0.921 m NO STUDY (K29 found none), cadence 2.000 steps/s NO STUDY (K29 found none) — twin agrees within 7.5%
- **H2H_WalkRight.FBX**: native 1.764 m/s, direction 90.0°, 2 planted spans, step 0.921 m NO STUDY (K29 found none), cadence 2.000 steps/s NO STUDY (K29 found none) — twin agrees within 4.3%

### Bound clips at ring speed (Thomson mean 0.6 m/s)
- **loc_advance** (native 1.736 m/s): at **0.6 m/s** play at **0.346×**; at **0.3 m/s** play at **0.173×**.
- **loc_retreat** (native 1.781 m/s): at **0.6 m/s** play at **0.337×**; at **0.3 m/s** play at **0.168×**.

### How the rate changes the look
At 0.6 m/s the bound forward walk runs slower than authored, so each shuffle step lands heavier and the cycle reads as a cautious press rather than a brisk march.

**S4a stride:** Pelvis-height-only in-place clips; rate-match `engine_speed / native_speed_mps` so planted balls stay under the sliding body.