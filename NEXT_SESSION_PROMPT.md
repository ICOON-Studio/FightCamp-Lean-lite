# S510 handover (written 2026-11-17, end of S509)

Start: `git pull && python ops/Tools/agent_comms.py start`, then this page. Roadmap `now.next_action` has the detail.
Digest: `ops/research/S509_DIGEST.md`.

## First
- Q-S294-267 (may films render while he plays?) on the board. Q-268 answered "Yes, medium": effortLevel is medium (S509).
- He sent a usage-cost video (Fable 5.2 cheap). Done: `.claude/agents/Explore.md` puts search helpers on Haiku. The video's
  other rule for us: do not split small jobs across helpers (briefing + re-reading costs more than doing it).

## Done in S509
- HEADSPLIT2 collected (PR 350): head jumps by phase. HEADSPLIT3 (combo phase) launched on Qwen, ETA ~16:05.
- PopCap `-- capwhy`: why a >12 cm head frame passes the cap. s509a: 72 of 136 landed punch at full hold, 43 hit
  reactions (free by design), 11 blocked/height-only (body slide).
- Rejected + removed: trunk cap after the hit (hit_carry 31 -> 43); trunk cap on the way in of unlanded punches (no gain).

## NEXT (in order)
1. Collect Qwen HEADSPLIT3 (qwen/headsplit3): run the probe on s508c vs s509b.
2. HEADJUMP1 at the SOURCE (PopCap has no lever left): per landed punch, the glove-to-target gap at the throw vs the
   arm's reach - if jabs start 15-20 cm beyond reach, fix range / step-in; and the jab lunge's root slide (6 cm a frame).
3. Hook recovery 1.5x (BeatClips.RECOVER_MAX): measure first. 4. join_return hook rep 3 / cross rep 4.
5. Blind r12 + two NEW critics only once films may run (Q-267).

## Traps seen this session
- hit_carry reads 29-33, join_return 2-4 run to run with the SAME code: run twice, never read +-2 as a result.
- A capped trunk cannot give back the body's own slide: a head that rides the root/hips needs the slide fixed, not PopCap.
- `cd` into E:/FightCamp/tmp moved the session folder: use absolute paths.
- watch-video skill: local faster-whisper fails on this PyAV (`metadata_errors`); feed it numpy from `wave` instead.

## Debt
uppercut_tail 2, block_absorb 11, hit_carry ~31 (noisy), join_return 2-4 (noisy), punch_speed 40, block_catch 5-6,
hit_frame 4, punch_range 1, block_meet 2-3, guard_knee, human_feet, rokoko_clips (off-route).
