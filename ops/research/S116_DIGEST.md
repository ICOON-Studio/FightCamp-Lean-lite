# S116 DIGEST - boxing moves: the foot lock, 115+ Mixamo clips, the suit route shot built to pro practice (2026-09-28, Claude)

Suite: nightly 2026-09-27 at 40bec39e `SUITE total=439 fails=24` (AgentComms/nightly/latest.txt); this session ran subsets only.
Boxing certified: **0/36 -> 0/36** (C223 gate now calibrated; run 5 in flight).

## Shipped (master)
- **Ops board reds** cleared with the operator's rulings: 5 already ruled (713c27bf); the other 8 confirmed by the operator and
  recorded as D20-D26 in DECISION_LEDGER (1c7f9933). Idle-in-rotation no longer red (09-28 milestone-wins ruling). C223 route RESUMED.
- **Roadmap tree** fixed (70ed1bda): stale "planned" S93 removed; S93-S115 given real stages (were none or "S"); 7 sessions added.
- **Walk fixes** (3dc6d34c, a78f0357, 99b5e353): physio table empty when nobody is sore; DEVELOPMENT - THE MOVE LAB button restored
  in the training day drawer (operator 09-01 ruling lost in R22); boxing camp no longer offers the Mat Mechanic (ground_policy none);
  gym doors spread along the whole left wall (operator: "so close to each other?"), HQ pitch 2.1 -> 3.33 m.
- **Silent background Godot** (d3b65c0c): godot_hidden.ps1 adds `--audio-driver Dummy` (operator: "i dont want to hear sounds").
- **Whole-clip punches keep planted feet locked** (11e45809): C223 run 3 found FightStagePlayer.advance skipped the foot lock for
  every whole take. Production probe: jab contact slip f01 4.70 -> 0.01 cm, f10 3.17 -> 0.17 cm (gate 2 cm); OFF arm reproduces
  Codex's numbers. Kicks unchanged (roundhouse 5.42 / 9.44 cm - kickboxing later).
- **Q210 merged in two parts** (77c6a5e8, b4fa5a17 grapple): re-pins with intent + judge cards; grapple gate back at 0.75 by fixing
  the DATA (3 muay_thai nodes) + a real engine bug (back-control chokes logged `rnc`, no such node -> bjj_rnc/sambo_rnc).
  NOT merged: fight_separation loosened twice - re-sent (RNG-shift hypothesis).
- **Roster U189 note** corrected (1a66d2c9): U189 IS merged (S98_DIGEST 4-7, 29-31).
- **Suit route written down for good**: route never called "parked" anywhere (operator); slide 17 of the status deck carries the
  program-by-program chain; Kimodo OUT of C223 (operator).
- **QuickMagic** evaluated and logged as an ALTERNATIVE (not bought): free plan 0 credits, video/text-to-motion/editor all paywalled.

## Mixamo (operator's signed-in Chrome, operator gave full download authority)
- 61 boxing clips on disk (punches, body shots, combos, blocks, dodges, steps, pivots, 3 guard idles, reactions, ceremony, knees,
  elbows, headbutt, bows) - `Godot/assets/anim/c223/mixamo/` in the C223 worktree + `D:/FightCamp/sources/mixamo/boxing/`.
- Whole-catalogue scan by term (IDs, 2,301 unique): **439 combat clips**; ~10 of a 361-clip queue downloaded (files named
  `<Title>__<Description>.fbx`, e.g. all four Double Leg Takedown attacker/victim variants queued). Queue lives in the Mixamo tab's
  localStorage `__s116q2`; each download = `await eval(localStorage.getItem('__s116popid'))`, then navigate back to mixamo.com.
  Browser Guard: operator switched Ads/Trackers off for mixamo.com (the S3 file host was blocked as an ad).

## The suit route shot (research: S116_MOCAP_SUIT_PRACTICE.md)
- Pros: Plug-in Gait left/right ASYMMETRIC markers; Wang & Popovic colour glove (~20 unique patches); DeepMotion multi-person rules.
- v2 still (6ee1a63c) + 720p 10 s take (bd0ea29a, 70 cr): 13 unique colours per man, white vs black grid, 4 different gloves,
  T-pose -> ROM -> orthodox guard -> exchange, each man keeps his side. `s116_mocap_boxing_suits_v2_720p.mp4`.
- **Tracked** with `Tools/footage/track_segment_suits.py` + a legend sampled from the calibration still (`s116_v2_legend.json`):
  B all segments 83-100%; A legs/torso/right arm 89-100%, A LEFT ARM weak (pink upper 53%, brown forearm 74%) - pink too close to
  red/coral, brown too dark. Caps (white/grey) and gloves untracked by design. `s116_v2_track.json`, `_sheet.png`.
- Credits: Higgsfield 237 -> ~137 (two stills 0.5, 480p take 30, 720p take 70).

## Walk (boxer career, clicks only - research/s116_boxer_walk.plan)
Sign -> card tabs -> program a day -> Move Lab -> floor -> scouting -> staff -> contracts -> books -> book an amateur bout ->
set camp (Striking Shark / Technical Flow) -> fight week -> weigh-in -> fight night -> BEGIN FIGHT all reached. Open: the walk's
last step (reach RESULT) not reached inside its time budget; bout stills show boxers folded into each other and a wide squat -
the stance/idle is RamsterZ H2H_Idle for every ruleset (C223 run 5 binds a Mixamo boxing guard for boxing).

## In flight (yours now)
- Codex C223 run 5 (Temp/FightCamp-C223, gpt-6-astra): per-ruleset boxing idle from Mixamo + fix the Mixamo floor/rest-height offset
  once, then batch 1. Merge bar: rows pass both rigs through the production player + stills match SHOT_LIST_STRIKING.
- Qwen Q210 separation round 2 (Temp/FightCamp-Q210): prove/refute an RNG shift; bound over 8 seeds, 0.85 kept.
