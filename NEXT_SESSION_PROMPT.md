# S536 handover (written 2026-11-21 evening, during S535 - Opus)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. S535 is in roadmap `now`; digest ops/research/S535_DIGEST.md.
FIRST: `python ops/Tools/godot_slot.py status` - the owner plays games on this PC (ArcheAge ~5 GB); RAM, not CPU, starves the queue.
Close every Fable console the moment its result is collected (10 GB of claude processes at one point in S535).

## METHOD lines - quote all of them in your first message
- MECHANICS NEED 8 (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe; under 8 -> his cut-or-keep.
- FREE HAND (owner S534): remove / add / interconnect to reach 8, then report.
- DEPTH (S534 + S535): flat prices do not make choices (DEPTHPRICE1A); a choice is real when its VALUE depends on the moment.
- WEIGHT (owner S535 "Go deep with weight mechanic for 10/10 ... manageable to a certain point"): one mechanic, three decisions,
  one screen (diet Monday, water in fight week, class between bouts); natural vs walking weight; a cut costs stamina far more than
  power (John SQ278); men's 65 kg; a boxer may refuse a move; the 3D body shows his weight after the critics pass.
- GUARD (S535): a fixed Hands setting is never right (GUARDPROBE6) -> the guard is a fight-plan WHEN-line reaction (GUARDREV7).
- FIGHT CODE WHILE PROBES RUN: edit on a worktree branch (s535/dmgfix), merge after the probes stop.
- Fight animation: fight player v2 only. The mocap pack is his money call at the END OF NOVEMBER.
- BOARD QUESTIONS: 20 words max, options 5 words; detail in --attach. NAMES ONLY IN HEADERS.

## Running when S535 ended - collect, do not relaunch (each commits to main and stops)
Fable consoles (terminal tabs of the S535 session; they keep running): WEIGHT2R3 (weight map v2 with Q-292..294 + John, probe
round 3 - the first PROBE3 file was a 2-seed smoke run, wait for the committed one), BODYTEX2 (muscle skin on every body, shape
re-export where the stomach caves, shoulder seam), OFFERBUILD1 (owner Q-296 "Yes, build it": the bout offer as a letter, spec =
ops/previews/s535_offer_mockup/offer.png), GUARDPROBE8 (guard v7 PASSED; does a guard line cost a punch line? then critic briefs),
TURNPRO12, STEPPAY2 (phase 4); S534's DEPTHPRICE1B (stipend / loan second prices) and KNOWMISREAD1.
Export of the S535 build queued (correctives + boxer 01 skin + arms by Strength + Last 5 on the tape).
Close each console's tab once its result is collected (RAM starves the Godot queue).

## Landed after the handover
- WEIGHT2R3 (41a932360): map v2 + probe round 3 on John's numbers "PASS, weak": CUT 4, STAY 2, UP 2, DOWN 2, but 0 of 10 cells
  clear of the noise and CUT harder is in the leading group of ALL 10 - with real numbers the weight choices barely differ and
  cutting harder is never worse. Kalli critic queued (SQ279). DO NOT launch the code-checked critic (TASK_WEIGHT2V2CRIT.md) yet:
  first re-size so the amateur same-day scale makes a hard cut clearly cost (John: amateurs box carrying the cut) and cells
  clear the noise; then critics.

## Next, in order
1. Collect as they land; WEIGHT2R3 PASS -> launch its code-checked critic (TASK_WEIGHT2V2CRIT.md) + the queued chat critic.
2. Branch s535/dmgfix: PASS on it - knockdowns, crack_wire, debut_pick, golden_path, towel_wire, male_boxer, ladder_season,
   region_shows (76 checks). Still to read: liver_ribs, corner_jobs, fight_week, fight_week_screen (queued in S535,
   E:/FightCamp/wt/s535_out/*.out). Merge into main once the fight probes stop; export.
3. Bodies: BODYTEX2 stills to the owner; then GLOVEFACE1 (his C447: the guard glove sinks into the cheek).
4. OFFERTAPE1: the form row built; the offer mockup to the owner before any build.


---
Previous handover (S535 start) below, for reference.

# S535 handover (written 2026-11-21 ~16:00, end of S534 - Opus, 680k context)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. S534 is in roadmap `now`.
FIRST: `python ops/Tools/godot_slot.py status` (the owner may be playing a game - RAM was 86% at 14:09).

## METHOD lines - quote all of them in your first message
- MECHANICS NEED 8 (owner S534: "mechanics need an 8 critic's to stay in the game for depth and fun"): 8+ DEPTH and 8+ PLAY from critics, after the probe; a built mechanic under 8 goes to him as cut-or-keep. Plan: ops/research/DEPTH_SCOPE_S534.md (his "Yes, that plan").
- DEPTH (S534, ops/research/DEPTH_AUDIT_S534.md): the game is WIDE, not deep - of 23 measured decisions 5 are real, 10
  one-answer, 8 faint. Five maps passed critics at 7+ and then failed in the game. So: a mechanic's lever is PROBED on a
  greybox BEFORE critics score its map (pass: moves the result, no pick best in more than 6 of 10 cells); no new system
  until the five changes in the audit's part 4 are on the owner's board. Turning pro v11 waits for its probe, not critics.
- FOOTWORK (S533, STEPS_PAYOFF_SCOPE_S533.md, owner Q-285 "Yes"): a step must pay where it takes you. STEPPAY2 phase 2 built
  PlaceEdge (ropes +5.0, corner +6.5, own ropes -5.0). No StepEffect TABLE sizing until phase 4's re-gate of all 10 steps is read.
- GUARD (S534, Kalli on v5): every guard rule acted AFTER the exchange was settled, so covering never changed who wins a round.
  Map v6 puts Hands High / Normal / Loose into the exchange edge BEFORE settle. No guard build until v6 passes 7+ and its probe.
- DESIGN MAPS are written FROM THE CODE (a Fable console in this checkout - Arena only when it is free; owner S534 "dont wait
  on arena"), never by a chat seat; a code-checked critic finds real defects (S534: the towel chin bug, F13).
- Fight animation (owner S510): fight player v2 only (scripts/fight3d/v2). The mocap pack is his money call at the END OF
  NOVEMBER - do not ask before.
- BOARD QUESTIONS (owner S533): 20 words max, options 5 words; detail goes in --attach.
- NAMES ONLY IN HEADERS (owner S448): S534 almost broke it (the debutant's name in a row) - the name goes on the card's
  header / versus line, rows say why.

## Running when S534 ended (~16:00) - collect, do not relaunch
- Fable consoles (terminal tabs in the S534 session; each commits its own file to main and stops):
  STEPPAY2 (from S533: phase 3 code UNCOMMITTED in LineGrade.gd / LiveRound.gd / StepWire.gd; gate run for cut_off,
  pivot_out, step_back then the other seven; then BoutRead recalibration -> debut_read_test's 2 Lucy lines);
  TURNPROBE11 (probe turning pro v11 before critics -> docs/TURNPROBE11_RESULT.md);
  DEPTHPRICE1A (price pace / ice / fight-week load / partner -> docs/DEPTHPRICE1A_RESULT.md);
  DEPTHPRICE1B (price class nights / stipend / loan / diet -> docs/DEPTHPRICE1B_RESULT.md);
  GUARDPROBE6 (guard v6 Hands before settle -> docs/GUARDPROBE6_RESULT.md);
  KNOWMISREAD1 (BUILD: shared misread in Knowledge.gd + tests/know_misread_test.gd).
  The Godot queue was jammed at 16:00 (PC RED on CPU 96% from 3 probe runs; 10+ waiting): slow, not stuck.
- The ATHLETIC-ARMS REPAINT of the 152 painted bodies is imported and committed (f3e86aab8); not yet in an exported build.
- Arms by Strength in 3D is committed STRONGER (owner "make it stronger": 40 -> 1.00, 60 -> 1.12, 80 -> 1.24); its 40 vs 80
  stills were NOT re-rendered (queue timeout): `tools/fight3d_still.gd -- <out> armstr=40,40` and `armstr=80,80` on the
  hidden desktop, then post to the review board and send.
- Seat queue (chat critics, the 30-min job): SQ273 Kalli + SQ274 John on guard v6; SQ275 Kalli + SQ276 John on DMGCLASS v3.
  DMGCLASS v3 code-checked (Fable): depth 6 - class is never a choice (comes with the boxer). Guard v6 Arena: 6/7/5.
  Turning pro v10: John 6/7/7, Kalli 6/7/6 -> v11 written, probe first.
- Board questions all answered (Q-289 Keep painted, Q-290 Follow Strength, Q-291 Yes, that plan).

## Next, in order
1. Collect the six Fable results above as they land (read each RESULT; a probe that PASSES goes to two fresh critics -
   one code-checked - at the 8+ bar; a FAIL is re-sized or dropped under the FREE HAND).
2. Build the passing prices (DEPTHPRICE1A/1B) with red-first tests; then DEPTH_SCOPE_S534 changes 3 and 5 (maps from code).
3. DMGCLASS: under FREE HAND decide - a weight-class choice at the turn-pro call (its critic's #1), merge, or cut; tell him.
4. The owner plays the latest build (export after the repaint lands): painted bodies with athletic arms, arms by Strength.

## Built in S534 (all on main, build exported 14:09)
- Pro offer: VS <debutant> on each house header (each house its own name), the Debut row = why picked, no rating gap; hover =
  what the debutant brings + the softer-opponent ask; MORALE line (ProOfferWire.morale_line) instead of "(morale -5)".
- Tooltip card 86% opaque (TipParts.CARD_BG); clipboard face removed; tooltip tests at 0 broken (ratchets locked at 0).
- BoutFinish: an RTD (towel / cracked rib) wears no chin (towel_wire_test red -> green).
- Fight player v2: GuardHold holds both hands through a reaction (film 16, player2_test HANDS 336/710 -> 0/710).
- LOANPROBE1 collected (docs/LOANPROBE1_RESULT.md): the loan grows the gym, never a trap; the "8 weeks banked" bar was the
  probe's player, not a game rule.
- Palette guard green (RingTopDown colours into Palette).

## Next, in order
1. Collect STEPPAY2 + DMGCLASS v3. 2. Act on the critics' scores (v10 pro, v6 guard). 3. The owner plays the S534 build
   (Builds/FightCamp.exe, WHAT_TO_TRY.txt top section): act on his notes and review-board comments.
