# DEFFLOW study S382 - elite defence chain, frame by frame

Reference: YouTube short A1hSw3k1Ij0 (Canelo vs Mbilli, 21.8 s, 360x640, 29.97 fps), eyes ref `youtube-a1hsw3k1ij0`.
Operator sent it with "!!". Notes are our own words and numbers only; nothing copied into the project.

## Method
- Motion judged on the VIDEO with the eyes CLI: `eyes burst <t> --count 12 --span 1` across the whole short (21 bursts),
  frame-by-frame bursts (`--span 0.4`, every frame) on the intro and on the right hand / uppercut, and `eyes crop`
  (fraction boxes) on the defender's head, gloves and feet at 40 moments. No ffmpeg stills or contact sheets used as evidence.
- The edit is NOT real time. Per-frame difference scan of the fighter band (numbers only): ~13.5 s of the 21.8 s are
  freeze frames (with circle call-outs), the replays run at 2x slow (every frame doubled) or ~2.5x slow (blended), and
  only ~8.3 s of real motion exist. **All seconds below are converted to real time** = unique source frames / 29.97.
- The intro (edit 0.00-2.60) plays the whole jab -> right -> hook -> right -> hook -> uppercut run at ~1x and with no
  hidden cut (no difference spike). Cross-check: hook last 0.10 s = 0.10 s in both intro and replay; duck 0.27 vs 0.20 s.
- Units: hw = Canelo's head width, hh = head height, tw = torso width (shoulder to shoulder). Chest distances are
  foreshortened in depth, so +-0.5 tw. Timing resolution +-0.03-0.07 s.
- Sign: onset "-0.10" = defence starts 0.10 s BEFORE the punch starts / before the glove reaches the head.

## Per punch (attacker Mbilli, defender Canelo; both orthodox)

| # | edit t | punch | defence | onset vs punch start | onset vs contact | defence time | head move | knees | feet | chests | right after |
|---|--------|-------|---------|----------------------|------------------|--------------|-----------|-------|------|--------|-------------|
| 1 | 3.25-3.55 | jab (L) | catch on high right glove (block) | pre-set, <= -0.10 | <= -0.20 | contact 0.10 | ~0 (<0.2 hw back) | some | none | ~2.0 tw | stays in guard |
| 2 | 3.85-4.10 | jab (L) | catch + short lean back-left | +0.03 | -0.07 | 0.10-0.15 | 0.3-0.5 hw back/left | some | none | ~2.0 tw | already loading the dip |
| 3 | 4.40-6.45 | right cross (R) | dip forward-down to his left + step back-left out of range ("step away") | **-0.03** (before the glove leaves the shoulder) | -0.17 | 0.45 (0.23 down, 0.20 back up) | 1.5 hh down, 1 hw left | some -> deep | **step** back-left, both feet | 2.0 -> ~3.0 tw | resets to guard at range; attacker bent over, overextended |
| 4 | 7.70-7.97 | jab (L) | parry: right glove meets it ~0.5 hw in front of the face, pushes out | +0.10 | -0.05 | 0.10-0.17 | ~0 (chin tuck) | some | none | ~2.0 tw | guard, near the corner post |
| 5 | 8.65-8.95 (intro 0.25-0.45) | 2nd jab (L) | slip: head off-line to his left, a little down | ~0 (+-0.03) | -0.20 | never returns: flows into #6 | 1 hw left, 0.5 hh down | some | none (weight to lead leg) | ~2.0 tw | keeps going down |
| 6 | 8.95-11.70 (intro 0.50-1.05) | chopping overhand right (R) | dip-away: deep waist bend + drift back-left to the post; glove passes over his back | -0.25 (already moving from #5) | bottom reached as the glove passes (0.0) | ~0.50 (0.25 down, 0.25 up sliding along the ropes) | 2 hh down, 1 hw back-left | deep | small step back-left to the ropes | 2.0 -> 1.5 tw | rises gloves-high, back on the ropes |
| 7 | 13.15-13.51 (intro 1.10-1.25) | left hook (L) | block: right glove fixed at the right temple, elbow tight, chin down | pre-set, -0.10 (gloves came up while rising) | glove hit at +0.10-0.13 after start | 0.10 | 0.2-0.3 hw away from impact | some | none (on ropes) | ~1.3 tw | drops at once into #8 |
| 8 | 15.38-15.82 (intro 1.27-1.55) | right hand (R) | duck **inside**: knees + waist drop, head goes down AND toward the attacker's chest | **~0** (1 frame after start; 0.03 s after the hook landed on the glove) | -0.15 | 0.20 down + ~0.15 held low | 2 hh down, 0.5-1 hw forward | deep | none | 1.3 -> ~0.6 tw | stays low and close |
| 9 | 17.78-18.45 (intro 1.60-2.05) | left hook (L) | smother: rises forward, chest onto chest, head onto the attacker's lead shoulder; hook wraps behind his head with no lever | **-0.10** (moves in before the hook starts) | hook arrives +0.15 already dead | tie 0.25-0.30 | 1.5 hh up, 1 hw forward | some | weight shift forward, no clear step | **~0 tw** | stays close, gloves high; parts 0.1-0.2 s later |
| 10 | 19.69-21.10 (intro 2.10-2.45) | uppercut (lead side by the replay angle; low confidence) | pull: torso leans back over the top rope, ropes take the weight | ~0 (+0.03) | -0.10 | 0.20-0.30 | 1.5-2 hw back, a little up | none/slight | none | 0 -> ~2.0 tw | upright, guard reset; attacker backs off |

## Totals
- Defences in a row without a clean head shot: **10 of 10** (4 with the gloves: catch, catch, parry, block;
  5 with the head/body: lean, dip+step, slip, dip, duck; 1 by position: smother; 1 lean-back: pull).
- Attacker tempo: combo A (jab, jab, right) = 3 punches in 0.77 s from first start to last arrival, spacing 0.33-0.40 s.
  Run B (2nd jab -> uppercut, intro, continuous) = 6 punches in 1.9 s, spacing 0.30 / 0.43 / 0.19 / 0.43 / 0.45 s
  (mean 0.36 s, ~3.2 punches per second; the 0.43 after #6 includes Canelo getting up from the dip).
- Counters by the defender: **none visible** in the clip. Pure defence; any short inside work during the tie is not readable.
- Feet: only 2 of 10 defences move the feet (#3 step away, #6 drift to the post). On the ropes: zero steps in 4 defences.
- Head never returns to centre between #5-#6 and #7-#8-#9: each defence ends in the start pose of the next.

## Our side (as of S382)
- Defence kinds in code: slip / block / weave / pull (+ slip_rope, roll, roll_out in plans). No parry, no catch,
  no duck-inside, no smother, no rope lean.
- `BeatFire.gd` starts a slip/weave/pull at 0.35 of the punch's travel and a block at 0.8 - always reactive.
  Measured elite onsets: -0.10 to 0.00 s vs punch start on reads (after a jab, after a hook), +0.03 to +0.10 on single jabs.
- `MovePlayer.gd DEF_PEAK_S`: dodges 0.70-0.93 s, weaves 0.40-0.53 s to the deepest point. Measured: 0.10 s (pull),
  0.15-0.20 s (slip, duck), 0.23-0.25 s (dip). Our dodge clips reach depth 3-6x too late for this tier.
- Owned mocap that fits (Downloads, never buy): High_Right_Block (hook block #7), Outward_Block / Blocking__Blocking_Outward
  (parry #4), Boxing_Dodge_Retreat (step away #3), Boxing_Dodge_Advance (duck-in -> smother entry #8-#9),
  Standing_Dodge_Backward (pull #10, check depth; Dodging_Back jumps - too big). Time-scale each so the deepest pose
  lands at the measured peak.

## 8 takeaways for the sim + 3D
1. **Chain, not single defences.** Within a flurry the head never goes back to centre: slip -> dip, block -> duck -> smother.
   Sim: a defence ends in a state (UP / LOW / INSIDE / BACK) and the next defence must start from it. 3D: blend each
   defence from the previous defence's deepest pose, not from guard idle.
2. **Onset belongs to the read, depth belongs to the contact.** On predictable follow-ups (the right after a jab, the
   right after a hook, the hook after a duck) he starts at or before the punch (-0.10..0.00 s); on lone jabs he reacts
   +0.03..+0.10 s. Either way the head is deepest exactly when the glove arrives (0.10-0.25 s after onset).
   Replace the fixed 0.35/0.8 travel fractions with onset = read skill and peak = contact.
3. **Size scales with the punch.** Jabs: 0-1 hw of head travel, mostly gloves (catch/parry). Power shots: 1.5-2 hh down
   with deep knees and a 30-60 deg waist bend. Small, cheap defences vs jabs are what keeps him fresh.
4. **Duck goes INSIDE.** Under the right he goes down and toward the attacker's chest (1.3 -> 0.6 tw), which makes the
   next hook smotherable. Add `duck_in` (ends close) beside `roll_out` (ends away); the end distance drives the next beat.
5. **Smother is a defence.** At ~0 tw a hook has no lever: zero/low damage, and the attacker's best answer becomes the
   uppercut - which Canelo answers with a pull. Sim: punch effectiveness by distance (hooks dead at 0, uppercuts live).
6. **Ropes as a tool, not a trap.** 4 rope defences, 0 steps: block, duck, smother, lean-back with the ropes taking the
   weight. Add `rope_lean` (pull that may exceed normal depth on the ropes); feet stay planted - only 2 of 10 moved.
7. **Flow numbers.** Attacker spacing 0.19-0.45 s (mean ~0.36), 3 in 0.77 s, 6 in 1.9 s; defender 10/10 with no counter.
   Sim: a "flow" streak - each clean defence shortens the next read (onset earlier) until fatigue or a feint breaks it;
   a defence like #3 leaves the attacker overextended at ~3 tw = a counter window the AI may or may not take.
8. **Clip timing targets (1x seconds):** catch/parry 0.10-0.17; block contact 0.10; slip to peak 0.15-0.20; dip/duck
   0.20-0.25 down + 0.20-0.25 up; pull 0.10 to peak, 0.20-0.30 total; smother tie 0.25-0.30. Probe new defence
   clips against these with the existing peak probe and judge them on video (eyes burst), not stills.

## Confidence
- High: order of punches and defences, real-time conversion, onset sign (before/after), feet planted vs stepping.
- Medium: onset values +-0.05 s, head travel +-0.5 hw, chest distance +-0.5 tw (camera depth).
- Low: hand of the final uppercut; whether anything landed lightly during the tie.
