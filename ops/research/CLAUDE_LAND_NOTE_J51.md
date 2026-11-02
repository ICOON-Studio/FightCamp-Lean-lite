Task: J51 Fight camera craft (broadcast fight camera rules plus game camera smoothing), research memo assigned 2026-09-25.
Target path: research/J51_FIGHT_CAMERA_CRAFT.md (copy of /workspace/j51/J51_FIGHT_CAMERA_CRAFT.md, about 50 KB).
Headline: our camera shakes because it re-aims and re-zooms every frame at all four limbs. Pros hold a steady head-to-toe shot (Cam 1) or trunks-up shot (Cam 2) of both bodies and get variety by cutting, not by whipping the camera.
Finding 1: Cams 1/2 are "most of what a viewer sees" in boxing (Tugman, S1, BROADCAST). UFC's live cover is 4 cage-side handhelds plus the JITA, and 2 of the handhelds (6x) give 90% of slo-mo replays (S3, TRADE 2020-01-17).
Finding 2: cut rules. Come out head-to-toe on the referee's "break", never mid-exchange (Chenery, S2, 2017-05-03). Always go back "home" to Cam 1. Never cut apron to opposite apron. Corner trap goes to Cam 2 (S1).
Finding 3: pan no faster than 1 frame width per 7 s at 24 fps (RED, S28). EBU action-safe margin is 3.5% per edge (S30). Aim at the point between the fighters and limit reorientation speed (Haigh-Hutchinson GDC 2005, S43).
Finding 4: tool defaults are too twitchy for broadcast. Cinemachine rotation damping 0.5 = 0.075 s half-life. Group framing damping 2 = 0.30 s. Dead zone 0.2 and soft zone 0.8 when enabled (S35, DEV plus COUNT).
Verdict: chest/pelvis midpoint aim, dead zone 0.20x0.12, aim half-life 0.30 s, zoom 1.0 s, pan cap hFOV/2.8 per s (max 25 deg/s), zoom cap 15%/s with 20% hysteresis, shots 0.75H-2.5H, minimum shot 3 s, 6x knockdown replays (mostly PROXY/JUDGEMENT).
Biggest NOT FOUNDs: live fight ASL or cuts/min, per-camera share of airtime, operators' numeric reframe/pan/zoom rules, and any dead-zone or spring numbers from UFC, Fight Night or Undisputed.
Research only: no code written, no repo touched. Do not edit HANDOFF. Land the memo file only.
