# S116 - How professionals set up a capture shot (suits, markers, gloves), and the suit-route shot built to it

Operator 2026-09-28: "regenerate it with unique colours and also consider different colour gloves - why dont you search how pros do it".
Searched: marker set, plug-in gait, colour glove, suit colours, calibration take (prior_research.py: nothing on suit/marker design).

## What would a human do? (what the professionals do)
1. **Optical studios - Vicon Plug-in Gait.** Markers on bony landmarks. The layout is deliberately LEFT/RIGHT ASYMMETRIC so
   auto-labelling can tell left from right: upper-arm, forearm, thigh and shin markers at different heights per side (upper
   third on the right, lower third on the left) and an extra RBAK marker on the right shoulder blade; symmetric clusters are
   avoided. Sources: [Vicon Nexus - full body Plug-in Gait](https://help.vicon.com/space/Nexus216/11607226/Full+body+modeling+with+Plug-in+Gait),
   [IDMIL Plug-in-Gait marker placement](https://www.idmil.org/wp-content/uploads/2020/08/Plug-in-GaitMarkerPlacement.pdf).
2. **Colour-glove tracking - Wang & Popovic, SIGGRAPH 2009.** One camera, an ordinary cloth glove printed with ~20 distinctly
   coloured patches placed so no view is ambiguous - the same idea as the operator's cell suit, for the hand.
   Source: [ACM DL](https://dl.acm.org/doi/10.1145/1576246.1531369).
3. **Markerless multi-person capture - DeepMotion guidelines.** Each person in DISTINCTLY DIFFERENT clothing; fitted; patterned
   rather than solid (solid black worst); joints visible; shoes contrast the floor; even lighting; static camera at CHEST HEIGHT;
   >= 1080p, >= 30 fps; avoid occlusion, avoid performers SWITCHING positions (identity swaps), minimise contact.
   Source: [DeepMotion multi-person guidelines](https://www.deepmotion.com/article/multi-person-ai-motion-capture-guidelines).

## Applied (the S116 shot)
- v1 (`_captures/ground_video/s116_mocap_calib_still.png`, `s116_mocap_boxing_suits_480p.mp4`, 30 cr): segment suits but
  colours REPEATED within each man (red cap/torso/shin; orange upper+forearm; blue cap/torso/shin; cyan/green arms) - a cell
  tracker cannot separate those parts (`s116_mocap_calib_still_repeats.png`). Kept as a take for markerless solvers only.
- v2 still (`s116_mocap_calib_still_v2.png`, gpt_image_2_5, job 6ee1a63c): 13 unique colours per man in two palettes;
  men also differ by grid (white vs black); four different gloves (A right WHITE / left BLACK, B right GOLD / left SILVER - neutral
  colours no suit panel uses) so lead vs rear hand and man vs man are separable; right-side marker dots higher than left + an extra
  right shoulder-blade dot (Plug-in Gait asymmetry); chest-height static camera, full bodies, grey studio.
  Near pairs to watch in tracking: B turquoise thigh vs cyan upper arm; A coral thigh vs pink upper arm.
- v2 take: seedance_2_5 720p 10 s (70 cr), T-pose hold -> range of motion -> orthodox guard -> jab/cross/hook vs slip/jab/uppercut,
  each man keeps his side (no switching). 720p chosen over the 1080p guideline to keep credits for a retake.

## Open
- Legend for `Tools/footage/track_segment_suits.py` is hard-coded to the C180 suit (seed colours + still filename); the v2 suit needs
  its own legend learned from the v2 still before tracking.
- The video -> 3D bone solve (SAM 3D Body, G95) is still the missing step; QuickMagic (paid, see DECISION_LEDGER TOOLS) is the
  logged alternative.
