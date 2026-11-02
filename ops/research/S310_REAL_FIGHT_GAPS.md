# S310 REAL FIGHT GAPS - real women's amateur boxing vs our 3D fight, frame by frame

Operator S310: "is there any agent that can watch a real boxing fight with a skill similar to your eyes and try to find
how to improve animations and reactions etc to match a human fight".

**Answer in one line:** the punches are right (rate, level change on body shots). What makes ours read as a game is
everything around them. The two boxers stand at one fixed 0.95 m gap for the whole round, their feet barely move,
their gloves sit at eye level, a hit freezes the hit boxer in place, and there is no clinch. Real bouts breathe in and
out of range every few seconds. The hit boxer counters, steps out or ties up within 0.1-0.3 s.

## Prior research (read, not redone)
- `J67_VISUAL_REALISM_REPLY.md`: literature numbers (Olympic activity profiles [S1][S2], French elite distance and
  travel [S6], London 2012 time-moving [S7], Tokyo 2020 sequences [S5], women's WC clinch time [S13]). It named guard
  height, steps, range split and reaction length as gaps that "our own video study" should close. This study closes them.
- Memory note S246 (real full-body footage frame by frame, feet included) and `C198_DIGEST.md` (MMA standing motion,
  a different seat) were checked; nothing here repeats them.
- `HitSnap.gd` / `HitStun.gd` / `GuardLife.gd` / `GuardTuck.gd` headers: S302-S310 decisions and the J-GUARDPACE1
  guard (gloves 0.10-0.20 m in front of the face) that this footage revises for long range.

## What was watched (population)
Analysis only: no footage is in the project. The sheets in `previews/s310_real/` are small study excerpts
with their source and time on every row.

| # | Bout | Source (public, official uploader unless noted) | Video |
|---|---|---|---|
| R1 | Beatriz Ferreira (BRA, red) vs Sacha Hickey (ENG, blue), women's 65 kg final, World Boxing Cup Guiyang 2026, 3x3:00 | youtube.com/watch?v=2vs2HqtrsBo (World Boxing) | 12:41, 25 fps |
| R2 | Hu Meiyi (CHN, red) vs Alua Balkibekova (KAZ, blue), women's 50 kg final, IBA Women's World Championships Nis 2025 | youtube.com/watch?v=2qwFL8dI-do (IBA Boxing) | 15:45, 60 fps |
| R3 | Nitu Ghanghas (IND, red) vs Lutsaikhan Altantsetseg (MGL, blue), 48 kg final, IBA Women's World Championships New Delhi 2023 | youtube.com/watch?v=PXpzbuuklzA (re-upload, "Amateur Boxing Bout") | 14:51, 30 fps |
| OURS | Lucy Jackson (red; power 58, speed 63, technique 60, defence 57, conditioning 63, IQ 59, chin 66) vs Maria Ortega (blue; southpaw pressure fighter, 165 cm, rating 61.5), round 1 in full | Lean `8b96fa5` (committed HEAD; the working tree had another session's unparsable edit), quick-start career to fight night, every shout answered "say nothing" | 3:01, 30 fps fixed |

Our film: `tools/s310_film.gd` (a copy of `fight3d_film.gd` that skips the S307 intro and answers the shout bar; the
stock film script stops after 5 s since S307) on the hidden desktop in a scratch worktree, plus the per-frame bone log
(`joins=`: clip, pelvis position, hands/head/hips/feet in her body frame).

## How it was measured (one instrument for both sides)
- **Eyes**: `eyes index` on all three bouts, then my own timestamped frame sheets at 2-12.5 fps for every moment
  quoted below, read frame by frame.
- **Pose tracker** (same code on real and ours): RTMDet + RTMPose (rtmlib, CPU, idle priority) on sampled frames (ours
  5 fps, real 3 fps). It finds the two boxers by singlet colour inside the torso and ignores the referee and the crowd.
  It keeps only wide frames with both boxers head to feet, and only in-round time (the broadcast round clock read by
  OCR; breaks, intros and the decision dropped). Lengths are in **NA** = her own nose-to-ankle length (0.885 x height),
  turned into metres at NA = 1.48 m (a 1.67 m woman).
- **Validation**: on our film the tracker reads the pelvis gap as 0.64 NA = 0.95 m, and the bone log says 0.96 m. On R2
  it reads a median 1.22 m, and the published elite mean is 1.23 +- 0.16 m (J67 [S6]). The instrument agrees with both
  ground truths.
- Kept frames: ours 433 (87 s), R1 228 (76 s), R2 534 (178 s), R3 162 (54 s; that broadcast cuts to close and corner
  angles a lot, so R3's distances are the weakest of the three). Close-ups, replays and
  overlapping bodies drop out, which biases the real samples a little toward separated boxers. The inside share below
  is therefore a floor.
- Scripts (not in the repo): shared notes folder `s310_real_tools/` (pose_measure, inround, compare, joins_stats, sheet,
  stack, s310_film.gd). Per-frame CSVs: `E:\FightCamp\tmp\s310_real\`.

## Real vs ours

| Item | Real (source, time) | Ours (round 1) | Gap |
|---|---|---|---|
| Pelvis gap, median (p10-p90) | R1 0.91 m (0.40-2.11); R2 1.22 m (0.45-1.91); R3 1.39 m (0.55-2.41); literature 1.23 +- 0.16 m [S6] | 0.95 m (0.88-1.01); bone log min 0.80, max 0.98 | ours never leaves one distance |
| Gap spread (sd) | R1 0.42, R2 0.39, R3 0.49 NA | 0.04 NA | **10x too steady** |
| Range mix, inside < 0.65 m / mid / long > 1.1 m | R1 31 / 29 / 40 %; R2 20 / 25 / 55 %; R3 17 / 20 / 63 % | 0 / 99 / 1 % | no inside work, no resets out of range |
| Range swings (> 0.45 m within 1.5 s: entries, exits) | R1 23 in 76 s (~18/min); R2 105 in 178 s (~35/min, some tracker jitter); R3 26 in 54 s (~29/min) | 0 | no entry lunges, no exits |
| Entry step | R2 4:51.7: Hu lunges ~1 m in ~0.3 s from long range to land | `step_in` moves the attacker 0.32 s and the other retreats a beat later (`FightView._fire` -> `stage.step(other, -1, .., true)`), so the gap is held | the step never closes distance |
| Feet moving | 53-56 % of round [S7]; R1 1:21.7-1:27 both bounce and shuffle out of range | step clips 8-9 % of frames (bone log) | **~6x too still** |
| Ring travel per boxer | 155 +- 28 m per round [S6] | 10.5 m and 9.9 m | **~15x too little** |
| Guard at range (wrist vs shoulder line) | R1 lower wrist -0.18 NA, higher -0.11; R2 -0.21 / -0.13; R3 -0.21 / -0.12: gloves chin-to-chest and forward (R1 1:01.4, R2 3:49.5) | 0.00 / +0.03 NA: gloves at eye level, tucked to the face | **ours ~25-30 cm too high and tight at range** |
| Stance stagger (front-back feet, side view) | R1 0.34, R2 0.30, R3 0.32 NA (p90 ~0.6) | 0.26 NA (p90 0.40) | a little square; never a long stride |
| Punch rate | ~20/min per boxer, Olympic [S1][S2] | 18.6 and 20.9/min (bone log) | **matches** |
| Punches per exchange | 2-5 most common [S5]; R1 1:31.8 left to the body + clinch, R2 4:51.7 lunge + right + exit | median 1; 54 % single shots; 71 bursts in 3:00, one every 1.7 s (max quiet 10 s) | an even tempo of single shots, no long quiet spells |
| Arm reach at contact (wrist-shoulder, p99) | R1 0.40, R2 0.42, R3 0.55 NA (max 0.80) | 0.37 NA | straights land a little bent (the gap is short) |
| Body-shot puncher | R2 4:41.3-4:42.2: Hu dips deep (level change) to throw it | 1:13.0-1:13.3 the Pro body shot dips deep | **matches** |
| Head shot taken | R1 2:10.90: head back + lean ~0.1 s, Ferreira **counters at +0.16 s**, both at long range by +0.7 s. R2 4:52.3: head turns ~0.2 s *while moving*, upright +0.3 s, out of range +0.7 s | 0:20.7: hit clip **locked 0.67 s in place** (HitStun), her own jab cut after 0.1 s, then the same guard at the same 0.95 m; no counter, no step | real reaction is short and flows into a counter or an exit; ours is a held pose |
| Body shot taken | R1 1:31.83: Hickey **folds forward onto the hitter** 1:32.07-1:32.49 (~0.45 s), they part by 1:32.8, guard up 1:33.0 (**~1.2 s** to reset) | 1:13.3: fold 1:13.43-1:13.74 (~0.3 s), upright ~0.5 s after impact, then both stand still | fold too short, no lean-on or tie-up, no exit |
| Hit reaction clip length (all) | see the two rows above | 0.5-0.7 s each, 41 in the round (7.3 + 6.3/min), all in place | |
| Clinch | 2.5 -> 3.2 -> 4.8 per round, 4.1 +- 2.3 s each [S1][S13]; R1 1:14.0-1:16.5 chest-to-chest tie-up, R1 5:22.9-5:24.8 heads together + referee parts them, R3 2:25.5 tie-up on the ropes | none: the `clinch` beat plays the slip clip (`FightView._fire`), no referee in the ring | missing entirely |
| Between exchanges | R1 1:21.7-1:27: long range, bouncing, pawing the jab out of reach; R1/R2 the referee walks round them | 0:30-0:42: 12 s at one spot, gloves almost touching | the quiet spell is in the pocket, not outside it |

Sheets (real on top, ours below, same seconds):
- `previews/s310_real/cmp_distance.jpg`: R1 1:17-1:27 vs ours 0:30-0:40, 1 fps
- `previews/s310_real/cmp_guard_stance.jpg`: R1 1:01.4 + R2 3:49.5 vs ours 0:36 + 1:41
- `previews/s310_real/cmp_reaction_head.jpg`: R1 2:10.8 vs ours 0:20.3, 11 fps, 1.36 s each
- `previews/s310_real/cmp_reaction_body.jpg`: R1 1:31.75 vs ours 1:13.0, 9.4 fps, 1.6 s each
- `previews/s310_real/cmp_clinch.jpg`: R1 1:14, R1 5:22.9, R3 2:22.5 (ours has none)

## Root cause found in code (Lean 8b96fa5)
- `FightStage._compose` holds the pelvis gap at `gap_m` (the jab's reach, ~0.96 m) on every frame. While a boxer
  steps she is "held on the gap"; when both stand, the nearer one takes a corrective step back to it. So distance
  cannot change by design.
- `FightView._fire` turns `step_in` / `step_out` into a step by one boxer **and** a follow step by the other the same
  way, which keeps the gap again.
- `FightView._fire` plays `"slip"` for `clinch`.
- `HitStun` locks the hit boxer until the reaction is back in guard (to 1.0 s); she cannot defend or step, and her own
  started punch is cut.
- `GuardTuck` draws both wrists 0.10 m toward the face at all times (S302, from J-GUARDPACE1's close-guard number).

## Ranked fix list (what to change, where, to which number)

1. **Let the range breathe** - `scripts/fight3d/FightStage.gd` (`_compose`, `gap_m` -> a target that changes per
   phase), `scripts/fight3d/ExchangeBeats.gd` (phase per beat), `FightView._fire` step beats (no follow step on
   `step_in`). Rest between exchanges at **long range 1.3-1.6 m** pelvis to pelvis (out of reach). An exchange opens with
   **one** boxer's entry lunge of 0.4-0.7 m in 0.25-0.35 s; the other holds or counters. Punches land at 0.9-1.1 m;
   hooks and body work at 0.5-0.7 m (inside). After the last punch one boxer **steps out** within 0.3-0.7 s. Targets on
   the same tracker: gap sd >= 0.3 NA, inside >= 15 %, long >= 35 %, >= 10 range swings a minute. This one change also
   puts the quiet spells out of range (the "Rock 'Em Sock 'Em" read, J67 fake #1).
2. **Hit reactions that keep fighting** - `scripts/fight3d/HitStun.gd`, `scripts/fight3d/BeatClips.gd` (REACT,
   `REACT_PEAK_S`), `scripts/fight3d/HitSnap.gd`. Head shot (not hurt): keep the snap and cut the lock to **~0.2-0.3 s**
   (snap peak + a short settle). After that, allow her counter or her step out; the hit clip blends out of its peak. The
   R1 counter came at +0.16 s. A hurt/big shot keeps today's longer lock. Body shot: fold held **~0.45 s**
   (`FOLD_HOLD_S` 0.3 -> 0.45). She falls forward onto the hitter (tie-up, see 4) or steps out; no punch of hers for
   **~1.0-1.2 s** total.
3. **Feet that never stop** - `scripts/fight3d/GuardLife.gd` (between beats) + `FightStage.gd` (`circle`, step lengths)
   + `scripts/fight3d/FootPlant.gd` (keep the planted look). Real boxers have their feet moving 53-56 % of the round and
   travel ~155 m. Ours: 9 % and 10 m. In the quiet gaps use short rhythm steps (in-out bounce, half steps, circling one
   way for 1-3 s), which pairs with fix 1's long-range rest. Target **feet moving >= 35 %** and **>= 60 m** travel a round.
   Use mocap step clips only, never sliding (FootPlant stays).
4. **A clinch, and a referee who breaks it** - `ExchangeBeats.gd` (when: `clinches_when_tired`, after a body shot taken,
   on the ropes), `FightView._fire` (`clinch` must not play `slip`), new two-body tie-up clips (`BeatClips.gd`), plus a
   referee figure in `scripts/fight3d/RingSet.gd` / `FightStage.gd`. Real: 2.5-4.8 a round, ~4 s each, chest to chest,
   heads side by side; the referee steps in and they part to long range. **Prefab check first**: ActionForge / Rokoko /
   Mixamo for a two-person tie-up and a referee "break" (none in our clip list today). It is the biggest piece of work,
   so it is ranked below the three that need no new clips.
5. **Guard by range** - `scripts/fight3d/GuardTuck.gd` (make `TUCK_M` range-dependent) and `GuardLife.gd`. At long range
   the wrists sit **~0.18-0.21 NA (~25-30 cm) below the shoulder line**: gloves chin-to-chest and forward, the lead a
   little lower. Inside, and when the other boxer punches, they come up to the face (today's tucked guard). Ours sits
   at eye level everywhere. This revises S302's J-GUARDPACE1 number for range only; inside it still holds.
6. **Exchange shape** - `scripts/rules/RoundScript.gd` / `ExchangeBeats.gd`: fewer, longer bursts. 2-5 punches an exchange
   (most common real sequence [S5]), then a quiet spell of several seconds at range. Ours: 71 bursts a round, median 1
   punch, one every 1.7 s. The round's punch total already matches, so it is the grouping that changes, not the count.
7. **Stance a little longer** - stance stagger 0.30-0.34 NA real vs 0.26 ours (`scripts/fight3d/BoxerBuild.gd` /
   guard clip choice in `BeatClips.GUARD`). Minor; fix 1's entry lunges and exits make the long strides happen anyway.

Already right, leave alone: punch rate (18.6 / 20.9 vs ~20 a minute), the deep level change on body shots, head snap
direction (back for straights, round for hooks), the hit-stop.

## What would a human do?
A boxing coach watching the two side by side would say: "they're standing in the pocket all round. Make them come in,
punch and get out." Then: "when she gets hit she fires back or moves, she doesn't pose." That is fixes 1-2.

## Not measured / limits
- Hip bounce rate: 3 fps on the real bouts is too slow to count a ~1 Hz bob; J67's 47-56/min stands.
- Steps per minute: not counted (the camera pans); feet-moving share and travel come from the literature [S6][S7].
- Reaction timings are hand-read from 9-12.5 fps sheets of 4 events (2 head, 1 body, plus R2 4:41 puncher); treat them
  as +-0.05-0.1 s. More events would tighten them; the direction (short and flowing vs held) was the same in every
  one.
- All three bouts are elite (world final level) women in headguards; our demo boxers are club amateurs. Expect real
  club fighters to be a bit squarer, slower to reset and more often inside. None of the gaps above is close enough to
  flip on that.
