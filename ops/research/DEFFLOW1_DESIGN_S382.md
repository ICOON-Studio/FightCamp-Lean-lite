# DEFFLOW1 design, S382: matched defences (Part A, build) + FLOW (Part B, proposal)

Inputs: `ops/research/DEFFLOW_STUDY_S382.md` (the short, judged with eyes, real-time seconds), the S382 defence audit
(origin/main 143b63d0, film `E:/FightCamp/tmp/s382/defflow/ours_ropes.mp4`, FBX measures `fbx_measure.json`), and the
code at 143b63d0: `RoundStyle.defend`, `RoundScript._stopped`, `ExchangeBeats.build`, `HabitBeats`, `BeatFire` (defence
branch), `BeatClips.DEFENCE`, `MovePlayer.DEF_PEAK_S`, `HitSnap.brace`, `RingPlace`, `TheRead`, `PLAYBOOK_SPEC_S381.md` 3.10.
Discipline: boxing only. BJJ is untouched.
Reviewed S382 (coach + design critic pass): impact-side gloves, rear_hook, no pull vs body, repertoire, pick temperature,
peak pinned to contact, counter-window gap rule, zero-mean stamina, LiveRound balance gate, 3D build checks, FLOW
clean-streak + one payout + replay at the corner minute. Each fix is marked "review fix" where it lands.

Why: the operator's "!!" short shows 10 punches in a row, each with its own answer and no clean head shot. Ours: one
weight table for every punch (block 0.5 / slip 0.3 / weave 0.2 / pull from footwork), a weave into a body shot, dodges
that peak 0.70-0.93 s after they start (3-6x the real 0.15-0.25 s), nothing on the ropes, no parry, temple block, duck or
smother, and the defender hit about as often as he defended.

---

## PART A - DEFFLOW1 MATCHED DEFENCES (inside the approved "fight is watchable" scope: build next)

### A1. Where it lives

| File | New/edit | Lines | Job |
|---|---|---|---|
| `scripts/rules/DefTable.gd` | new | ~130 | Constants only: the pair odds, eligibility, onset/duration, counter windows, stamina, style prefs (A3-A7). |
| `scripts/rules/DefenceMatch.gd` | new | ~230 | Pure static. `pick(ctx, rng)`, `apply(beats, profiles, ctx, rng)` (post-pass on one exchange), `timing(def, at, p)`, `spend(...)`. |
| `scripts/rules/RoundStyle.gd` | edit | 181 -> ~170 | `defend()` keeps the "active" roll; the weight pick calls `DefenceMatch.pick` with the punch (`move` arg, default ""). |
| `scripts/rules/RoundScript.gd` | edit | +1 | `_stopped` passes the punch to `defend`. |
| `scripts/fight3d/ExchangeBeats.gd` | edit | 292 -> ~297 | One call `DefenceMatch.apply(...)` after `InsideBeats.apply` and `_clinches` (inside spells and clinches are known by then). |
| `scripts/rules/HabitBeats.gd` | none | 0 | It already tags the beats it forces with `b["habit"]`; `apply` leaves those beats alone. |
| `scripts/fight3d/DefFire.gd` | new | ~160 | The 3D side of one defended beat: ropes/gap check, onset, clip or procedural pose, counter hand-over. `BeatFire` calls it (its 25-line defence branch shrinks to ~6). |
| `scripts/fight3d/DefPose.gd` | new | ~280 | Procedural defence layer (like `HitSnap.brace` and the S381 procedural footwork): additive pelvis/spine/head offsets + glove IK targets on the frame clock. |
| `scripts/fight3d/BeatClips.gd` | edit | ~+15 | `DEFENCE` rows for the new kinds (A8). |
| `tests/defence_match_test.gd`, `tests/def_timing_test.gd` | new | ~150 each | A10. |
| `tools/defflow_probe.gd` | new | ~200 | The film bar (A11), from the scratch `E:/FightCamp/tmp/s382/defflow/defflow_film.gd`. |

All files stay under 500 lines. Ships ON (no flag).

### A2. Context per incoming punch (built by `apply`, used by `pick`)

| Key | From | Values |
|---|---|---|
| `punch` | beat `move` | jab, cross, lead_hook, rear_hook, body_hook, lead_uppercut, rear_uppercut (an `overhand` / `big` cross counts as `power`). rear_hook is 30 % of every "Lead hook" (`RoundStyle.MOVE_BEAT`): it uses the `hook` column below |
| `hand` | lead moves (jab, lead_hook, lead_uppercut) = lead, else rear; `stage.hand_of` mirrors southpaws in 3D | lead / rear |
| `side` | 3D only: the side of the DEFENDER's head the punch arrives on, from the attacker's hand AND both stances (orthodox vs orthodox: jab / lead hook arrive on his rear-hand side, cross / rear hook on his lead side; vs a southpaw it flips). Every glove defence uses the glove on this side | lead / rear |
| `range` | `close` while an InsideBeats spell (`move == "inside"`, t..end_t) covers the beat or the previous defence ended `inside`; `long` for 1.5 s after a `step_out`, or sit `range` with no spell; else `mid` | long / mid / close |
| `ropes` | the exchange's StrikeMap card is `own_ropes` (x["arrow"] / PlanFight.LOST_CARD), or sit `press` and the defender is the pressed side, from the burst after the first `step_in` | bool |
| `follow` | the attacker threw within 0.6 s before this punch (same burst) | 0 = first punch, 1, 2, ... |
| `prev_end` | the end state of the defender's last defence if it was <= 0.6 s ago | up / low / inside / back / out / none |
| `read` | defender's read of the attacker's item that fires (PLAYBOOK 3.10 per-item meter) or of the exchange's habit (`TheRead.read(st, sit)`), 0..1, divided by her trigger, capped 1 | 0..1 |
| `energy` | `RoundScript.energy_at(profile, frac)` | 0..100 |
| `defense`, `footwork`, `style` | profile | stats |

### A3. The defences (11) and what each one does

| id | what you see | head/body (study units: hw head width ~0.2 m, hh head height ~0.23 m) | feet | ends in | Canelo # |
|---|---|---|---|---|---|
| `parry` | the `side` glove meets the punching glove ~0.5 hw in front of the face and turns it aside (jab: rear glove pushes it out; cross: lead glove turns it across) | head ~0 | planted | up | 4 |
| `block` | the `side` glove: jab = rear glove catches it at the cheek/chin; cross = lead glove high at the cheek, lead shoulder up; hook = that glove fixed at the temple, elbow down (left hook -> right glove, Canelo #7) | head 0-0.3 hw away | planted | up | 1, 7 |
| `brace` | body shot: elbow drops onto the ribs (existing `HitSnap.brace`) | trunk crunch | planted | up | - |
| `slip` | head off the line to the outside of the straight | 1 hw side, 0.5 hh down, knees some | planted | up (low if the next is a power hand) | 2, 5 |
| `roll` | U under the hook, the way it travels (existing side rule) | 1.5 hh down, 1 hw across | planted | low | - |
| `duck` | straight down, waist 30-45 deg, guard high | 1.5-2 hh down, deep knees | planted | low | 6 |
| `duck_in` | down AND forward toward the attacker's chest | 2 hh down, 0.5-1 hw forward | <= 0.35 m forward | inside | 8 |
| `smother` | chest to chest, head on the attacker's lead shoulder, gloves high on own head | from low: 1.5 hh up, 1 hw forward | weight forward | inside | 9 |
| `pull` | lean back off the line | 1.5-2 hw back, spine 15-20 deg | planted | back | 10 |
| `rope_lean` | pull with the ropes taking his weight (ropes only) | 1.5-2 hw back, spine 25 deg, hips at `RingPlace.ROPE_LEAN_M` | planted | back | 10, 6 |
| `step_back` | dip + step back out of range (not on the ropes) | 1.5 hh down, 1 hw side | step, both feet, 0.4-0.65 m | out (range long) | 3 |

`""` stays the wide miss (no defence needed). New in 3D: a defender with defense >= 60 shows a small reflex head move
(procedural, 0.3 hw) instead of nothing; under 60 he plays nothing (the audit's never-run fallback is deleted).

### A4. Eligibility (a defence not allowed here is never picked)

| | jab | cross / power | hook (lead_hook, rear_hook) | body_hook | uppercut |
|---|---|---|---|---|---|
| parry | yes | power: no | no | no | no |
| block | yes | yes | yes | no (brace) | yes (low odds) |
| brace | no | no | no | yes | no |
| slip | yes | yes | yes (low odds) | NO | yes (low odds) |
| roll | no | yes | yes | NO | no |
| duck | yes | yes | yes | NO | NO |
| duck_in | no | range mid/close | range mid/close | no | NO |
| smother | follow >= 1 and range close | same | same | yes | yes (low odds) |
| pull | not ropes | not ropes | not ropes | NO (the ribs stay where the feet are) | not ropes |
| rope_lean | ropes only | ropes only | ropes only | no | ropes only |
| step_back | not ropes, range long/mid | same | same | same | same |

Rules from the study and the audit: never a head move against a body shot (the audit's weave into a gut shot at 8.40;
`pull` is a head move too - only `brace`, `smother` and a real `step_back` answer the body); never down into an uppercut;
smother only chest to chest on a follow-up; no step on the ropes.

**Repertoire (review fix):** a defence is also only legal once the fighter owns it - `DefTable.NEEDS` defense:
block / brace / pull / step_back any; slip 50; parry, duck, roll 58; rope_lean 65; duck_in, smother 72 (Part B training
can unlock one 8 points early through its drill). A def-45 fighter therefore has 3-4 answers (shell, brace, pull, a slip
now and then), a def-85 one all 11 - that, not randomness, is what makes poor defence look poor and good defence varied.

### A5. Success odds per (punch, defence) pair

`DefTable.ODDS` = the chance the defence fully stops that punch for a defense-70 fighter on time. `-` = not eligible.

| | jab | cross | power (big/overhand) | hook | body_hook | uppercut |
|---|---|---|---|---|---|---|
| parry | 0.85 | 0.55 | - | - | - | - |
| block | 0.80 | 0.65 | 0.50 | 0.85 | - | 0.40 |
| brace | - | - | - | - | 0.85 | - |
| slip | 0.80 | 0.80 | 0.70 | 0.30 | - | 0.35 |
| roll | - | 0.45 | 0.70 | 0.80 | - | - |
| duck | 0.55 | 0.70 | 0.80 | 0.80 | - | - |
| duck_in | - | 0.65 | 0.75 | 0.75 | - | - |
| smother | 0.60 | 0.55 | 0.70 | 0.80 | 0.30 | 0.20 |
| pull | 0.75 | 0.70 | 0.60 | 0.65 | - | 0.80 |
| rope_lean | 0.65 | 0.60 | 0.55 | 0.55 | - | 0.75 |
| step_back | 0.70 | 0.70 | 0.75 | 0.70 | 0.70 | 0.70 |

Review fix: because A never changes who lands (A6), `p` is only a PICK WEIGHT, never a hit roll. A multiplier that is the
same for every legal answer (the old `skill` x0.70-1.15 and `read` x1.25) cancels out when the weights are normalised and
did nothing; both are gone from `p`. Skill now acts through the pick temperature (A6) and the repertoire (A4), the read
through onset and the whole-combo chain (A7). Only multipliers that differ PER DEFENCE stay:

Live weight base `p = clamp(ODDS x tired x chain, 0.05, 0.95)`:
- `tired`: energy >= 40 x1.0; under 40 `lerp(0.75, 1.0, energy / 40)`, and duck/duck_in/step_back x0.6 more (tired legs,
  S369), block x1.2 (tired fighters shell).
- `chain`: from `prev_end` (the study's chain): low -> duck_in/smother/roll x1.3, up again x0.9; inside -> smother x1.4,
  pull x1.2 (uppercut answer), step_back x0.5; back -> block/parry x1.2; out -> nothing new.

### A6. How a defence is picked, and what the odds decide

The round's landed counts stay what `RoundScript.LANDED` / Kalli's counts say (who wins a round is not changed by A;
`RoundScript.landed()` must return the same numbers for every seed - test). The odds decide:
1. **Stopped punches** (`misses` / `blocked`): `weight = exp((p - p_best) / T) x STYLE_PREF x variety`,
   `T = lerp(0.30, 0.03, clamp((defense - 40) / 50, 0, 1))` (p_best = the best legal `p` for this punch). Review fix: the
   old `p ^ k` (k <= 3) could not do what it promised - the ODDS rows sit 0.55-0.85, so even at k = 3 a def-85 fighter took
   a top-2 answer only ~45 % of the time vs a jab. With T, "a good answer" = `p` within 0.10 of p_best: def 85 (T 0.057)
   takes one ~85 % (cross) to ~96 % (jab) of the time; def 45 (T 0.27) on the full set ~63-79 %, and in play he only has
   his A4 repertoire anyway.
   `variety` x0.7 when it is the same defence he used on the attacker's previous punch (Canelo used 8 different ones in 10).
   Result: parry/block/brace -> `blocked`, the rest -> `misses` (as today; `RoundScript._stopped` must test all three,
   it only checks `"block"` now).
2. **Landed punches**: `b["def_try"]` = the attempt that failed, picked from the LOWEST-p legal answers (the wrong guess:
   a slip into a hook, late block) with onset late (A7) - so the viewer sees why it landed. Defense >= 80 tries the right
   answer late instead (+0.08 s); under 50, 40 % of landed punches get no try at all (frozen).
3. **Old non-3D path** (`RoundScript` alone, BoutNight): `RoundStyle.defend(receiver, thrower, rng, move)` -> `pick` with
   only `punch` set (range mid, no ropes); same names, so old saves and captions read.

`STYLE_PREF` (x on the weight; 1.0 if not listed):

| style | x1.3-1.5 | x0.5-0.7 |
|---|---|---|
| Out-boxer | step_back 1.5, pull 1.3, parry 1.3 | duck_in 0.6, smother 0.5 |
| Counter-puncher | slip 1.5, parry 1.3, pull 1.3, roll 1.3 | step_back 0.7 |
| Pressure fighter | roll 1.4, duck_in 1.5, block 1.3, smother 1.3 | step_back 0.5, pull 0.7 |
| Volume puncher | block 1.4, parry 1.3 | duck 0.7 |
| Slugger (12 % of the roster, was missing) | block 1.5, roll 1.3, brace 1.3 | parry 0.6, step_back 0.6 |
| Boxer-puncher | - | - |

Old names: `weave` stays an alias of `roll` (TapeClips rows, old saves, `BeatClips` side rule, `HitStun.BLOCKED`).

Footwork keeps its say: pull and step_back weights x `clamp(footwork / 60, 0.6, 1.5)` (replaces the old pull formula).

### A7. Timing: onset before contact (real seconds, from the study), counter window, stamina, read link

`at` = contact time of the punch from its beat start (`BeatFire`; Undisputed-measured 0.365 jab ... 0.534 hook).
`DefenceMatch.timing(def, at, p)` returns `{onset, peak, end}` relative to the punch's start:

| def | lead before contact (peak AT contact) | in | hold | out | counter window after contact | stamina (energy) | end |
|---|---|---|---|---|---|---|---|
| parry | 0.12 | 0.10-0.12 | 0.03 | 0.12 | 0.35 s, good (rear hand already moving) | 0.05 | up |
| block | 0.10 (guard is up) | 0.08 | 0.10 | 0.15 | 0.15 s, little | 0.15 | up |
| brace | 0.08 | 0.08 | 0.10 | 0.15 | 0.15 s | 0.20 | up |
| slip | 0.18 | 0.15-0.18 | 0.05 | 0.20 | 0.40 s, best (rear hand loaded) | 0.10 | up / low |
| roll | 0.20 | 0.20 | 0.05 | 0.20 | 0.40 s (the return hook) | 0.15 | low |
| duck | 0.22 | 0.20-0.25 | 0.15 | 0.20-0.25 | 0.30 s (uppercut / body from low) | 0.30 | low |
| duck_in | 0.20 | 0.20 | 0.15 | (held into the next) | 0.30 s inside | 0.30 | inside |
| smother | 0.10 | 0.10 | tie 0.25-0.30 | 0.20 | none (tie) | 0.25 | inside |
| pull | 0.10 | 0.10 | 0.05 | 0.15-0.20 | 0.25 s, pull counter | 0.10 | back |
| rope_lean | 0.10 | 0.10 | 0.10 | 0.20 | 0.20 s | 0.05 | back |
| step_back | 0.25 | 0.20-0.25 | - | 0.20 | none: resets range to long | 0.25 | out |

- **Onset belongs to the read, depth belongs to the contact** (study takeaway 2; review fix - the first draft shifted the
  whole lead, so a def-90 reader with +0.175 s peaked early and was already coming back up when the glove arrived, and a
  def-40 fighter peaked AFTER contact on a punch the sim says he stopped). For a STOPPED punch the peak stays at contact
  (+-0.03 s) for everyone. Skill and the read move only the onset: `onset = at - in - extra`, `extra = 0.05 x clamp((defense
  - 60) / 20, 0, 1.5) + 0.10 x read`; the extra time is a slower, earlier start of the same move (the "already moving"
  look of #5-#6), never an earlier peak. Energy < 40: `extra` - 0.05 (floor 0: a tired man is just on time). Lateness
  (peak after contact) exists only on LANDED punches' failed tries (A6.2).
- If the onset falls before the punch's start, the clip/pose starts at 0 already partway in (skip = start - onset).
- **Counter window** (the table's column, per defence - not a flat 1.2 s): if the defender's own next beat falls inside
  `contact .. contact + 1.2 s` AND no punch of the attacker reaches contact inside `contact .. contact + window`, it is
  moved to start at `contact + hold` (after the defence's hold, inside its window), tagged `counter = true`, and plays from
  the defence's deepest pose (the `MovePlayer` DEF_HOLD_S hand-over, now in the fight). If the attacker's next punch is
  already on its way, no move (a 3.2-punch-a-second presser leaves no gap: the study's 10/10 had no counter). Its result is
  not changed (counts fixed); its caption can say "counter". `step_back` instead moves the attacker's next beat 0.4 s later
  (he has to walk in again).
- **Stamina** (review fix: the first draft ADDED up to 1.5 energy an exchange. `Combos.ROUND_COST` 18 already pays
  "moving and guarding", so that double-counted, would have cost ~9 a round on a ~33-a-round budget (the 68 / 46 / 29
  targets), and charged the BETTER defender more because he defends more). Now zero-mean: each defended punch costs its
  table value MINUS 0.15 (the mean defence); cheap answers (parry 0.05, slip, pull) give energy back against the round's
  guarding share, ducks and steps cost more. Net cap +-0.5 energy a 30 s exchange. Same idea as Canelo: small cheap
  defences vs jabs keep you fresh. duck/duck_in/step_back also add to the legs burn (BodyLoad).
- **Balance gate** (review fix: `BalanceHarness` plays `BoutRules.play_round` and never runs LiveRound, so it cannot see
  A at all). Gate with `tools/exchange_balance.gd` (the real Bouts.fight_step + LiveRound bout): win share at edge -10..+10
  moves <= 0.02 per row; the J-UPSETS1 bands stay (~60 % slight edge, ~75 % clear, ~88 % big, <= 95 %); a finals-pace
  fighter still ends rounds at 68 / 46 / 29 +-2 (Combos targets).
- **Read link** (Playbook read meter, `PLAYBOOK_SPEC_S381.md` 3.10): the per-item read the defender holds on the item that
  fires starts the defence earlier (`extra` above; peak still at contact), and at read >= her trigger she answers
  the WHOLE combo: the next punch's defence is chosen from the chain bonus as if `prev_end` were already set (the
  "predictable follow-up" onset of the study: -0.10..0.00 s vs the punch start). The player's long combos therefore get
  answered better as the opponent reads them - the S381 tradeoff, now visible.

### A8. 3D: what plays each defence (owned only; procedural where nothing owned fits)

`DefFire` checks the real ring first (`RingPlace`): ropes = his back within 0.35 m of the rope line; gap = chest to chest.
Downgrades (logged): `step_back`/`pull` on the ropes -> `rope_lean`; `smother`/`duck_in` with gap > 0.9 m -> `duck`/`block`;
`rope_lean` off the ropes -> `pull`. Bar: downgrades <= 10 % of defences in the probe.

| def | plays | timing rule | feet |
|---|---|---|---|
| parry | DefPose procedural: the `side` glove's IK target onto the punching glove's path 0.5 hw in front of the face, sideways deflect 0.10 m | A7 | planted |
| block (straight) | DefPose: jab = rear glove forward 0.08 m at the chin/cheek (the catch); cross = lead glove high at the cheek + lead shoulder up; `mc_to_block` (0.97 s shell) only when tired (energy < 40) | A7 | planted |
| block (hook) | DefPose: the `side` glove at the temple, 0.05 m off, elbow down, head 0.2 hw away. Pro/Mixamo high blocks rejected (glove over the head, S304 rule; audit) | A7 | planted |
| brace | existing `HitSnap.brace` | at contact | planted |
| slip | `pro_left/right_dodge` / `mc_dodge_*` / baked `slip`, side rule unchanged; SKIP-IN: start at `DEF_PEAK_S - lead` so only the last 0.18 s before the peak plays, speed 1.0-1.3. Fallback DefPose (1 hw, 0.5 hh) | peak at contact | planted (SideStep commit OFF on ropes) |
| roll | `pro_left/right/quick_weave` (peak 0.40-0.53, drop 0.21 m), skip-in to peak - 0.20, + a DefPose pelvis drop of 0.10-0.14 m on top (A3 asks 1.5 hh ~0.35 m; the clips alone reach 0.21) | peak at contact | planted |
| duck | DefPose: pelvis down 0.25 m, spine forward 35 deg, guard held, FootPlant keeps the feet (owned `Dudging_with_a_Ducking` has hands low and walks 1.5 m: rejected; weaves only drop 0.17-0.21 m) | A7 | planted |
| duck_in | Mixamo `Boxing_Dodge_Advance` (drop 0.36 m at 0.4 s) cut at the frame its root has travelled 0.35 m (never a scaled root: a shrunk root under full-length strides skates the feet) + a guard layer; fallback DefPose duck + 0.3 m forward with FootPlant stepping | peak at contact | <= 0.35 m forward |
| smother | from the duck_in end: DefPose hold, chests at `RingPlace.INSIDE_FLOOR_M` 0.48, head target on the attacker's lead shoulder, gloves on own head; the attacker's hook keeps playing, its contact moves to the shoulder/back of the head at 0.2 force, no hit reaction | tie 0.25-0.30 | weight forward |
| pull | DefPose: spine back 15-20 deg, head 0.30-0.40 m back (`pro_back_dodge` steps 0.7 m and is 1.0 s to peak: off the ropes only, as `step_back` variant) | 0.10 to peak | planted |
| rope_lean | DefPose pull at 25 deg + hips to the ropes (`RingPlace.ROPE_LEAN_M`) | 0.10 to peak | planted |
| step_back | Mixamo `Short/Medium_Boxing_Step_Backward`; vs a rear hand at range `Boxing_Dodge_Retreat` (dip + step, Canelo #3) | peak at contact | 0.4-0.65 m back |

Chaining (study takeaway 1): DefPose offsets are additive, so the next defence cross-fades FROM the current offsets (no
return to guard idle between punches <= 0.6 s apart): slip -> duck, block -> duck_in -> smother -> pull are continuous.
New Mixamo clips go through the existing mc_ retarget/import path and get `DEF_PEAK_S` rows from `tools/defence_peak_probe.gd`
(all owned, checked in `C:/Users/user/Downloads`: Boxing_Dodge_Advance, Boxing_Dodge_Retreat, Short/Medium_Boxing_Step_Backward).

Build checks the review added:
- **Skip-in frame.** `pro_left_dodge` peaks at 0.93 s, so its skip-in starts at ~0.75 s, where the head is already most
  of the way off the line and the feet may be mid-step. Log head offset + both feet at the skip frame for every dodge;
  if a foot is off the floor or the head is > 60 % of its peak offset, use the DefPose slip instead. The join is the
  existing `JOIN_STRIKE_S` 0.13 cross-fade, so the 0.18 s that plays is ~70 % blend - film bar 3 decides.
- **Speed.** Skip-in, never a whole-clip speed-up past 1.3 (S376: whole-clip speed-ups made the men "very fast and unnatural").
- **Modifier stack.** DefPose sits in the same stack as `GuardTuck`, `GloveClear`, `ElbowClear`, `HitSnap`; while a
  DefPose glove target is live, GuardTuck/GloveClear must not pull that glove back to the guard (S361: two modifiers
  reading the same pose fought each other). One stack order, written in DefPose's header.
- **Who knows it is a defence.** `HitStun.BLOCKED` and `MovePlayer._is_defence_clip` match clip NAMES; procedural
  defences have none. DefFire sets a per-boxer `defending` kind that both read first, or a parried jab plays a hit stun.
No casual walk (S377): no defence uses `af_walk`; the audit's 0-1.4 s `af_walk` came from the scratch pin and is
re-checked in the probe (bar: 0 frames of `af_walk` on a boxer).

### A9. Feet on the ropes

On the ropes (sim flag or real check): only parry, block, brace, slip, roll, duck, duck_in (<= 0.2 m), smother, rope_lean.
`SideStep`'s commit is off while `ropes`; FootPlant's reach rule (S376) is unchanged. Getting OFF the ropes stays the
exchange-level `pivot_out` / `tie_up@own_ropes` cards (PlanFight), not a per-punch defence.

### A10. Tests (headless, pure static, beside a render per S355)

`tests/defence_match_test.gd`:
1. Eligibility: over 2,000 picks, 0 head moves (incl. pull) vs `body_hook`, 0 duck/duck_in vs uppercuts, 0 step_back/pull
   with ropes, 0 smother at range long/mid, 0 parry vs power, 0 picks outside the A4 repertoire, rear_hook handled.
2. Counts unchanged: `RoundScript.landed()` and every beat's `result` category (lands vs not) identical with and without
   `apply`, 200 seeds x 6 exchanges.
3. Variety: defense 85 Counter-puncher vs a Pressure fighter on the ropes, 30 s: >= 5 distinct defences in >= 80 % of 50
   seeds; defense 45 (repertoire on): mean distinct <= 4.
4. Skill (temperature alone, repertoire off, Boxer-puncher, variety off): def 85 picks an answer within 0.10 of p_best
   >= 85 % of the time; def 45 <= 70 %.
4b. Stamina zero-mean: mean `spend` over 200 seeds of a def-70 Boxer-puncher within +-0.1 energy an exchange of 0.
5. Habit beats (`b["habit"]`) untouched; old-path `defend()` returns only the old+new names; same seed = same picks.
6. Counter window: a defender beat inside the window is moved to contact + 0.05 and tagged; step_back delays the attacker.
`tests/def_timing_test.gd`: onset < contact for every defence at every defense; on stopped punches the peak is within
+-0.03 s of contact at def 40, 70 and 90 with read 0 and 1 (skill and read move the onset only); skip-in maths puts each
`DEF_PEAK_S` clip's peak at contact for jab/cross/hook contact times; energy < 40 moves the onset later, not the peak;
a failed try on a landed punch peaks after contact.

### A11. The film bar (acceptance, measured like the short)

`tools/defflow_probe.gd` (from the scratch `defflow_film.gd`, no pinning hacks that move the pair 2 m): TestJump
men_fight, our boxer defense 84 / footwork 74 as Counter-puncher, opponent Pressure fighter rated >= 66, an exchange on the
`own_ropes` card; side-on lens inside the ropes (S347), fixed fps, 30 s. Per-frame log: head offset from the hips, glove
positions, feet, chests gap, clip/pose name, each punch's start and contact. Bars:
1. Every punch the presser throws gets its own visible answer: head >= 0.10 m off the line at contact, or the answering
   glove within 0.10 m of its target (parry/block), or the brace - for >= 90 % of stopped punches.
2. >= 5 different defences in the 30 s.
3. Onset before contact for >= 90 % of stopped punches; head deepest within +-0.05 s of contact for >= 80 %.
4. Feet: <= 0.05 m of foot travel during defences while on the ropes; 0 frames of `af_walk`.
5. 0 head moves into body shots; defence durations within the A7 ranges +-0.05 s.
6. Eyes on the VIDEO (index/burst/crop at each punch, not stills): every answer reads as the intended defence; then the
   Gemini judge (gemini_judge.py) and the operator's .exe check.

### A12. Build order

1. DefTable + DefenceMatch + tests 1-6 (sim only, ships the choice; old 3D clips still play by the old names).
2. DefFire + timing (skip-in) for the existing clips -> film bar 3 for slip/roll/block.
3. DefPose: parry, catch, temple block, duck, pull, rope_lean, smother.
4. Mixamo imports: Boxing_Dodge_Advance, Step_Backward, Boxing_Dodge_Retreat -> duck_in, step_back.
5. Counter window + zero-mean stamina + `tools/exchange_balance.gd` gate (A7) -> probe, eyes, merge.

---

## PART B - FLOW (NEW mechanic: proposal only, needs the operator's OK)

**One line:** N clean defences in a row put the fighter IN FLOW for a few seconds: he reads earlier, counters faster, and
is harder to read, until a body shot, a feint, the ropes or fatigue breaks it.

| Part | Number |
|---|---|
| Where it lives | the SIM, on the exchange's script beats after `DefenceMatch.apply` (LiveRound), so BoutNight, the 3D ring and the replay all show the same flow; the 3D never decides it |
| Streak | +1 per CLEAN stop: the pick was a good answer (`p` within 0.10 of p_best, A6.1) and the onset came before contact. A wide miss (`""`) or a poor pick is +0. Reset to 0 by a punch landed on his head; a landed body shot ends it (below); a blocked/braced body shot -1 (body work chips the streak even when it is stopped: "body him" is the answer); reset at the bell |
| N to enter | `clamp(round(6 - (defense - 50) / 15), 3, 6)`: def 85 -> 4, def 70 -> 5, def 60 -> 5 |
| Who can | defense >= 60, energy >= 50, not hurt, discipline >= 40 (no composure stat: discipline stands in); temper > 75 shortens the window x0.7 (he goes looking for the KO). Opponents with no personality read discipline 50 / temper 50 |
| Window | 6 s + 1 s per 10 defense over 70, max 8 s; at most 1 flow a round |
| In flow | pick temperature T x0.6 (sharper choices); onset `extra` +0.05 s (peak stays at contact, A7); counter window x1.5 and the counter starts 0.05 s sooner; counters inside it land at TheRead's land chance +0.15; the opponent's read meter on HIS items fills x0.5. (Review fix: the first draft's "p +0.10" did nothing - `p` is a pick weight - and its extra flat +3 exchange edge stacked a second payout on the counters, see risk below) |
| Breakers | landed body shot ends it; a feint (opponent technique >= 70) ends it 35 % of the time when his read of that item is under his trigger; on the ropes > 4 s vs pressure >= 70: -1 s per 2 s; energy < 40 ends it |
| Cue | one word `FLOW` beside his name in the top bar + a thin gold edge on his meter; nothing else |
| Replay | NOT mid-round (nothing interrupts a live round, S276/S381 rule). The string (first defence -> last + the counter) goes to the corner minute as its first clip, slow-mo at the knockdown replay's speed, 4-6 s, skippable, max 1 a round, lens inside the ropes, never behind a boxer; it also goes into the highlights cut |
| Targets (`tools/exchange_balance.gd`, not BalanceHarness: it never runs LiveRound) | def 60: flow in <= 1 of 6 rounds; def 85: 2-3 a fight; even-bout win rate shift <= +0.03 for def >= 80; the J-UPSETS1 bands unchanged |

**Overpowered risk (review).** A keeps who lands fixed per exchange, so the man who gets landed on least is the one
already WINNING the exchange: a raw "stops in a row" streak would hand flow to the winner and its edge would snowball
(rich get richer, not "good defence pays"). Three guards above: the streak counts only CLEAN stops (skill, not who is
ahead), the only outcome lever left is the counter land chance (+0.15 at TheRead's +7 / -5 edges ~ +1.8 power points a
counter, a few counters a window, once a round), and the gate measures it. If def-85 vs an even opponent still moves
> +0.03, cut the land bonus to +0.10 before touching anything else.

How the player affects it:
- **Playbook**: defend-and-counter lines (`slip 2-3` exists; new "catch, 1-2", "duck in, hook") raise the counters' mastery
  that flow uses; `pivot_out` in the ropes phase stops the ropes breaker; feints and body work in OUR plan break the
  opponent's flow (the answer to a slick opponent: "body him").
- **Training**: per-defence drills (slip rope exists; parry pads, duck rope, smother/inside sparring) -> MoveMastery per
  defence: up to +0.10 on that one defence's `p` (it changes his pick, unlike a flat bonus), unlocks it 8 defense points
  early (A4 repertoire), and SIGNATURE mastery lowers N by 1.
- **Camp**: film study raises the read on his items (earlier entry); conditioning keeps energy over 40 (and 50) longer.
- The opponent can reach FLOW too; the scouting report shows his N.

Operator call: build FLOW after DEFFLOW1 (Part A) is filmed and passes, yes / no / change the numbers.
