# S135 digest - the hook chains step between their punches: three chains certified, palette 19 -> 22 (Claude, cloud, 2026-10-01)

Request (roadmap `now`, S134 section 5): a between-part step in the production sequence splice so liver_combo and
six_punch_combo pass `c223_sequence_gate` 4/4, then bind them. Done, plus one_two_hook. No agent was launched. Code commit 068b7f00.
Read first: section 2 (what it looks like - taste), section 5 (next).

## 1. What now works (each with its evidence)
| What | Evidence | Where |
|---|---|---|
| Between-part step in the production splice: at each splice ONE root shift along the facing that keeps the next part's head, torso and upper arms clear of the receiver on the C223 capsules, brings its glove to the target (reach solved as the certificate solves spacing), and lands a hook/uppercut within 3 cm of its certified reach; one foot stays locked, the other takes a lifted step; a planted foot left > 12 cm off takes its own step after; at most 0.5 m per splice | `FightStagePlayer._plan_sequence_step`; a `sequence_steps` row per splice in every certificate row | FightStagePlayer.gd |
| A lunge is CARRIED, not undone: the share of the shift the outgoing pose already stands on moves the root at the seam and the hips' join absorbs it | heavy_d six-punch part 4: world hips 0.32 m back then 0.28 m forward under the hook -> 4 cm; its glove peak 14.4 m/s (out of band) -> 12.7 | tools/s135_step_probe.gd `speeds` |
| The uppercut -> hook seam slid a foot 25 cm on the canvas | six-punch slip 24-25 cm -> 0.27-0.32 cm | s135_base.json vs s135_chains.json |
| Body hook entered in a chain where its glove leaves guard (binding `sequence_entry_at_onset`, whole frames) | liver part 2 onset-to-impact 667 ms (band <= 657) -> 617 ms | FightClipBinding boxing_body_hook |
| one_two_hook, liver_combo, six_punch_combo CERTIFIED 4/4 rigs, bound as sequences, in the demo palette (strikes 19 -> 22) | s135_chains.json; certified_palette_test green (mutants rejected, control throws uncertified) | FightClipBinding, certified_moves.json |
| The six chains already in the palette re-measured WITH the step: all still 4/4 | s135_chains.json replaces s131_offset_chains.json in certified_moves (the game now steps, so the certificate must) | certified_moves.json |
| Game room (switch `sequence_steps`, game ON / `--script` OFF): each body gets the other as receiver + both capsule models; from a chain's second part the room leaves that root to the step; its caps exempt only the step's own move this frame | seed 94301 room recording: every chain part logged (`record_room seq_log=1`), 0 SCRIPT ERROR | FightWorldLiveScreen.gd |
| Stoppage rate holds with the hook chains in | q212 booked census, 120 light-heavyweight bouts per arm: KO+TKO 45.0% (c3c0d46f, palette 19) -> 46.7% (palette 22); band 40-55, BoxRec ~47; draws 6.7 -> 4.2%, KD 26.7 -> 25.8% | tools/q212_booked_census.gd |

Gate (bound live_contact certificates=s131_offset_bound.json, 4 generated legal rigs, one process per rig):
| Chain | Before (control `no_step`) | After |
|---|---|---|
| one_two_hook | 1/4 (G147, pin pops, slip) | 4/4, min body gap 0.17 m |
| liver_combo | 0/4 (body hook 0.13-0.16 m inside the receiver, G147, timing) | 4/4, min gap 0.20 m, slip 1.44-1.54 cm |
| six_punch_combo | 0/4 (uppercut 0.25 m inside, next hook 0.10, slip 25 cm, G147, pin pops) | 4/4, min gap 0.12 m, slip <= 0.32 cm |
| one_two, double_jab, slip/pull/catch counters, counter_over_jab | 4/4 | 4/4 |
| jab_body_head (never certified) | 0/4 | 0/4 - its FIRST part (jab to the body, certified 1.71 m) is thrown at the jab's 1.10 m; the step acts between parts only |
Control arm s135_chains_nostep.json reads 25/40, the step 36/40 - the instrument reads worse without the fix.
Baseline at c3c0d46f: s135_base.json (reproduces S134's s134b rows exactly).

## 2. What it looks like (taste - the operator judges)
- Videos (C223 fixture, welter_a, 30 fps): docs/previews/anim/s135_boxing_{one_two_hook,liver_combo,six_punch_combo}.mp4.
- Six-punch: back 0.16-0.21 m for the cross, in 0.10-0.14 for the hook, back 0.35-0.39 for the uppercut (whose own
  0.5 m lunge brings him back in), the hook rides that lunge (carry), back 0.10-0.14 for the last cross. In-out footwork.
- Liver: no step for the cross; BACK 0.40-0.44 m over 0.25 s before the body hook, whose source clip then lunges 0.5 m in.
  That retreat-then-lunge is what the Mixamo body hook's long range demands; an in-place body hook would remove it.
- Every cross (single or chained) ends in a deep bob, head at the other man's chest (six-punch video 1.0 s and 4.3 s):
  the certified cross clip's own recovery - the S133 "deep crouch" residual, not the step.
- In the room the receiver moves: on seed 94301 A walked 2 m off during B's one-two-hook and the hook (step capped at
  0.5 m) is thrown at air. heavy_d's body hook peaks at the band edge (14.0 m/s) at its certified reach.

## 3. Rules this stage earned (also in roadmap handover traps)
- Plan clearance on the capsules the gate and G147 measure (`sequence_bodies`): a bone-capsule estimate read 5-9 cm optimistic.
- G147 ARM after contact is NOT monotonic in overshoot (welter_b liver clipped at a LONGER range): the contact stop pins the
  glove while the lunge carries the shoulder on. A bent-arm punch goes to its certified reach; straights tolerate 0.3 m.
- An entry off the 60 Hz grid (0.0623 s) moved a tail foot-slide run 1.46 -> 2.01 cm; entries snap to whole frames.
- A pivot step whose foot follows the take had no lift: `_lock_feet` skipped a zero-offset foot before adding the lift.
- A fixed-receiver gate cannot see a moving receiver: the room asked 0.66 m and 1.0 m steps (cap + follow-up step added),
  and exempting a chain's root from the room caps let a 2.6 m `_correct_refused_overlap` push through
  (tools/s135_root_stage_trace.gd) - only the step's own move is exempt now.
- record_room args are key=value (`seq_log=1`); a palette change moves every seeded bout (fight_stance_offset's seed
  94301 now ends by TKO at 30 s - the test samples live frames only).

## 4. Tests (focused, cloud /opt/godot/godot)
- Parse gate on every touched .gd: CHECK fails=0.
- `run_tests.py --jobs 4 --only fight_stage_presenter,fight_clip,fight_strike_whole,combo,fight_pair_live,fight_body_layers,
  fight_alive_stance,boxing_idle,certified,fight_world_live,fight_stance_offset,beat_adapter,technique_catalogue` on the final
  code: **SUITE total=26 fails=2**. Both fail byte-identically at c3c0d46f (a copy of the tree with the six S135 files reverted):
  - fight_strike_whole_test: "OFF events byte-identical to baseline" - on the 09-30 nightly red list already.
  - fight_pair_live_test: pairs=0 on seed 810039. NOT on the 09-30 nightly list, so S133/S134 broke it: with the switches off
    the room's default pair throws no plain `boxing_jab` in the first 120 s (histogram: chains, body shots, rear hooks), so no
    beat can qualify for the authored jab pair; the pair code itself loads and holds every take (all its LOAD rows ok).
    Re-anchoring the seed moves the operator's "0:14 before shot" - item (0) of S136.
- fight_stance_offset_test: failed with the hook chains in the palette (seed 94301 now ends by TKO at 30 s and the 60 s
  sampler read frozen after-the-bell frames); it now samples live frames only and passes 9/9 on 30.0 s of fight.
- certified_palette_test green (strikes 22). The full suite is the nightly's (05:00, PC); the cloud has no nightly.

## 5. Open
- jab_body_head: needs a step BEFORE part 0 (or the gate's fixture at the first part's spacing).
- RC2 arm length from reach: HELD for the operator (re-opens all certificates).
- .exe rebuild + walk with palette 22: PC only.

## 6. Next (the decision)
(0) fight_pair_live_test: re-anchor its seeded jab (a seed whose first 120 s land >= 2 plain jabs to the head with the
switches off) and say which operator shot replaces "0:14". Then stage S136 = the residual clip poses, starting with the cross's post-contact bob (it plays after EVERY cross, single or
chained): tools/s134_pose_probe.gd on seeds 94301 and 92012 for the cross rows; if the head drops below the receiver's chest,
end the cross's recovery at the guard return (binding cut, or a solved pose layer as boxing_up_jab's) and re-certify the
cross and every chain that holds it (4/4). Then S133's lean-back reaction, near-horizontal lunge and deep crouch.
On the PC with the operator: build_playable + walk with palette 22; the operator watches the s135 videos (taste).
