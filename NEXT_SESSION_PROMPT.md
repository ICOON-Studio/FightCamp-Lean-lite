# S509 handover (written 2026-11-17, end of S508)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the detail.
Digest: `ops/research/S508_DIGEST.md`.

## First
- Q-S294-267 on the board: may films render while he plays? Unanswered at S508's end. He was NOT playing when S508
  filmed (no game window); the "no films while he plays" line was my own caution (S506 memory), he said film twice.
- He asked about Zapier MCP: told him phone pings (board question / build / film ready) are the one real use; he has
  not picked an app yet - if he says Telegram / email / SMS, set it up.

## Done in S508
- Ziva PR 341 merged (coach neck, 19.0 deg). HOOKPAST2 collected (HOOK_HELD line). PRs 342/347/348 closed (on main).
- HOOKREL1 (ReachLimit.out_weight + in_room, `-- norealout`): the reach lets go over real time, inside the 0.30 m cap.
  s508a vs s507b same bout: HookPast flings 7 -> 4, head jumps 92 -> 91. hit_carry 30 -> 31.
- HEADJUMP1 step (PopCap._letting_go, `-- noholdcap`): the held trunk is capped while the landed glove lets go, then
  PunchReach.settle(). s508c: head jumps 91 -> 86, stepping hook 9.0 m/s, tests unchanged.

## NEXT (in order)
1. Collect Qwen HEADSPLIT2 (qwen/headsplit2, PR when its runner lands): run it on s508a vs s508b - where were r1's 28
   fewer jumps (pre / contact / post)?
2. HEADJUMP1 on the way IN: capping the held trunk on every frame cut jumps 91 -> 63, but jabs met her 16-22 cm short
   (hit_carry 57). Cap the way in and let the reach's lean / the step cover the distance; hit_carry must stay 31.
3. The stepping hook (who 1 @3218) 9.0-9.7 m/s is the clip's own 1.5x recovery (BeatClips.RECOVER_MAX) inside the cap.
4. join_return: hook rep 3 (hit-time event f04 -> 10.1 m/s), cross rep 4 (12.6 m/s after the cut to guard).
5. pro_right_cross_hurt 0.105 m off at contact. 6. Blind r12 + two NEW critics, aim 6.

## Tools this session
- Fling counter (scratch, landed punch clips only, 12 frames after the first hold frame): s506a 12 over 6 m/s, s507b 10,
  s508a 7, s508c 7. HookPast probe / HOOK_HELD for the committed numbers.
- Films: `python ops/Tools/godot_slot.py run --who S<n> -- python tools/hidden_desktop.py run --timeout=900
  --log=<out>/godot.log <godot> --path . --windowed --resolution 1280x720 --fixed-fps 30 --audio-driver Dummy --script
  res://tools/human_fight_film.gd -- <out> secs=180 seed=7 trunktap [arm flags]` (~6 min each, csv only).

## Traps seen this session
- Every Godot start goes through `ops/Tools/godot_slot.py run` (rule_guard blocks a bare one, even inside a heredoc
  that writes a script - write such scripts with the Write tool).
- A slower let-go fights the 0.30 m correction cap: keep the let-go weight <= CORR_M / gap(aim, clip glove).
- hit_carry `only=` overrides `upto=`: an order-dependent reading needs `upto=` alone.
- Another session (S507) was still committing at S508's start: check `git log` before assuming the tree is yours.

## Debt
uppercut_tail 2, block_absorb 11, hit_carry 31, join_return 3, punch_speed 40, block_catch 10, hit_frame 4,
punch_range 1, block_meet 3, guard_knee, human_feet, rokoko_clips (off-route).
