# S96 DIGEST - wear as shape, a tier 3 that looks expensive, mirrors + a worn floor; the corner becomes a pit stop (Claude, 2026-09-27)
Commits: 00f1254d, 6c798572 (C213 merge), d55d3b95, 13f023a5 (Q196 merge), 7f54af50, + D43/Q197/ship. Suite: nightly
2026-09-26 at 9847dd13 total=416 fails=13 (AgentComms/nightly/latest.txt; the 09-27 night had not run). This session ran
subsets only: training_floor + gym_ 15/15 (x4), asset_manifest 1/1, fight_realtime + judge_panel + grapple_adapter +
fight_footwork 7/7, fight_stage/world/retarget/floor 32 with the same 4 reds as master (C213's master comparison).

## Built
- **Room**: mirror wall behind the bag row (1 m aluminium-framed silvered panels + two glints each; a fully metallic pane
  rendered BLACK - the probe had nothing to reflect - so the glass carries its own pale colour), clear of decor and
  posters; tier floor - tier 1-2 scuffed concrete + old mats + silver tape ON THE OPEN FLOOR (first pass hid them under
  station zones), tier 3-4 black rubber tiles. Mutant (worn floor at tier 3) turns training_floor red.
- **Wear as shape**: `prop_model_path(id, tier, condition)` -> `_t3_worn` / `_t3` / `_worn` / base; worn below 40.
  Tripo Pro (H3.1, 1K, ~270 credits, 2165 left): heavy_bag_worn, first_aid_worn, focus_mitts_locker_worn; tier 3
  re-made with D42's cues: heavy_bag_t3, compact_weights_t3, focus_mitts_locker_t3 (ONE narrow locker). The S95 coat is a
  faint even film only where no worn model exists. Fit fixes: a bag by its BODY width (min axis), a cabinet by its face
  (door ajar is depth), locker/cabinet footprint pulled in to its device (the 45 cm locker came 1.03 m deep).
- Renders: docs/previews/s96/room_tier1-3.png, *_wear.png, *_tier.png (sent). Tools: s96_render_room.gd, s96_render_wear.gd.

## Verdicts
- **D43** (Dola): wear now reads as YEARS OF USE, not paint - the D42 camouflage complaint is gone. Tier 3: rack YES, bag
  and locker BARELY ("clean is not expensive"). Next cheap cue each: bag brand panel + slight lived-in curve; locker
  brushed handle + emblem.

## Collected
- **C213** (Codex) MERGED: generated MPFB fighters in the fight room + floor behind `skin=generator` (opt-in, male only);
  170 takes, worst limb 18.7 deg, soles +/-0.05 m, two ids; bout.mp4. Unclothed base mesh - not final art.
- **Q196** (Qwen) MERGED: fight_realtime GREEN on master; subs unchanged by economy. My review: the judo seat shift
  (side 8->4, yuko 8->4) is UNDERPOWERED, not proven noise -> **Q197** (Qwen, running) counts to 100 SCORING throws/arm.
- **G131** (Grok): ~10% of judo throw attempts score, ~1 scored throw per elite match; 24 bouts cannot tell defect from noise.
- **G132** (Grok): corner playbook per region; recommends on-fighter cues + letter chips live, NO full body-outline HUD;
  1-2 real choices per damaged fight; legs persist between rounds.
- **D44** (Dola, re-sent - the first send got no answer): body language first + small colour chips; ONE treatment + ONE
  instruction per minute; MM pit-stop corner "absolutely exciting"; rule: decidable in 5 s.

## The operator's new direction (mid-session)
Motorsport Manager's setup loop, read from his own install (E:), mapped to the camp and the corner:
`research/S96_MOTORSPORT_MANAGER_SETUP_TO_THE_CORNER.md`. Measured: inputs -1..1 step 0.01, six sliders -> three
outputs, driver opinion bands at 0.03/0.10/0.20/0.30 from a hidden optimum, knowledge shrinks the visible band 1.0 ->
0.75 -> 0.3, radio feedback every 20-120 s, pit strategies safe/balanced/fast trade seconds for mechanic-error chance.
**Decision:** S97's corner is the MM pit stop - problem cards on a small body figure, a 60 s bar with per-action seconds,
careful/normal/rushed cutman, the nose-blow dilemma as the first two-sided card; fight-plan-as-setup is a later stage.
G133 (Grok) sent for the tuning-loop survey + real corner timings.

## In flight at handover
Cursor U188 (Temp/FightCamp-U171, branch cursor/u188-below-baseline, out Temp/u188_out.txt); Qwen Q197
(Temp/FightCamp-Q164, branch qwen/q197-throw-landings, out Temp/q197_out.txt); Grok G133 (grok.com/c/912b5e19-700b-4a35-b51e-2de1c237589b).

## Traps earned
- A fully metallic mirror with nothing in its probe renders as a black TV; give the glass its own colour + glints.
- Floor dressing placed at random lands under the station zones; sample the OPEN floor.
- A generator's box props (lockers, cabinets) come deeper than asked; cap the footprint, keep the height.
- A Cici `send` can land the task with no reply; read the chat before calling it collected.
