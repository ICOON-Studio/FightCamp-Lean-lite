# S508 handover (written 2026-11-17, end of S507)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the detail.
Digest: `ops/research/S507_DIGEST.md`.

## First: ask the owner whether films may render while he plays
S507: he said "Yes, film now" at the end. Ask again each session.

## FILMED in S507
- s507a / s507b (180 s seed 7, trunktap, E:/FightCamp/tmp/fightweek/). The warm fit first missed fast punches (a 1.5x
  punch at 30 fps steps 0.050 s of clip a frame = WARM_DT): WARM_DT 0.12. s507b: the stepping hook 14.7 -> 9.7 m/s; what
  is left is the RELEASE coming home 0.31 m in a frame (OUT_S 0.16 s of clip time = ~3 frames at 1.5x).
- FreeHand 0.29, HeadEase back 13 f held. Head jumps unchanged (shared part 34 -> 35). Count flings with the S507
  scratch method (landed punch, max hand speed in 12 frames after the first hold frame): s506a 3 over 6 m/s, s507b 4.

## Where the fight stands
- HOOK FLING fixed at the arm solve (filmed s507b: 14.7 -> 9.7 m/s, the rest is the release): at reach weight 1.00 the glove left its aim 0.29 m in a frame -
  the fit restarted from the clip's swung arm each frame, then the clip's fist turned up. ReachLimit.warm_from /
  keep_warm / warm_hand (`-- nowarmfit`, `-- nowarmhand`). A/B: hit_frame 9 -> 4, hit_carry 44 -> 30, block_catch
  11 -> 10, punch_speed 41 -> 40, join_return 2 -> 3 (one rep, see below), seven punch tests unchanged.
- HEAD JUMPS: two films of the fight share their bout only to ~48 s, then drift. S506's 77 -> 91 was mostly a different
  bout (shared part 20 vs 21). Count per clip kind (punch 0.132 -> 0.168 a punch clip, reaction 0.94 -> 1.06) and
  inside the shared part. Jumps are trunk 6.3 + neck 6.7 cm (median), all inside PopCap's two exemptions (0.25 s after
  a hit, the trunk under a held landing glove).

## NEXT (in order)
1. The hook's release: let PunchReach go over REAL time (not OUT_S of clip time) or slow hold_one_way on fast clips;
   A/B on the punch tests, then film vs s507b (head_split_probe csv=s507b csv2=<new>, free_hand / head_ease probes).
2. HEADJUMP1 on the puncher's own head (50 of 91): PopCap lets the trunk move under a held landing glove; with the warm
   fit the held arm is stable now, so try easing the trunk there and re-landing the glove (PunchReach.settle) instead
   of the exemption. Film, compare per punch clip inside the shared part.
3. join_return rep 3 of pro_left_hook: 10.1 m/s at f06 (a hit-time event at f04 in every arm; alone it passes).
4. pro_right_cross_hurt: 0.105 m off the face at contact; its solve flips on the way in (5.4 / 6.6 / 2.4 / 5.2 m/s). A
   warm start before the hit did not fix it (tried, `-- warmpre`, off).
5. Blind r12 + two NEW critics, aim 6. 6. Merge Ziva PR 341 after the owner's look.

## Seats
- HEADSPLIT1 collected (tools/head_split_probe.gd -- csv=<a> csv2=<b>).
- Qwen HOOKPAST2 running (branch qwen/hookpast2): HookPast also reads every held punch (HOOK_HELD line) - the
  ruler for item 1. Collect by diff first. Build exported 14:04 with WHAT_TO_TRY S507.

## Traps seen this session
- Never edit scripts while an A/B runs: every Godot launch reads them fresh.
- PunchReach.gd is at 499 of 500 lines: new reach logic goes in ReachLimit.
- hit_frame `-- show=<clip>` prints the aim, off-aim and the reach weight per frame (weight added S507).
- `cd` inside a Bash call moved the session folder again: absolute paths only.

## Waiting on the owner
- Films while he plays. PR 341 look (coach neck before/after on /review). Unity + Unity Hub (~27 GB on C:).

## Debt (red, none new from S507 except join_return's one rep)
uppercut_tail, block_absorb, hit_carry (30), join_return (3), punch_speed (40), block_catch (10), hit_frame (4),
punch_range, block_meet, guard_knee, human_feet, rokoko_clips (off-route).
