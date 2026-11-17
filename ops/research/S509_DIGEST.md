# S509 digest - fight motion week day 14 (2026-11-17)

## Owner
- Sent a YouTube link with no note: "Anthropic Just Leaked How To Use Fable 5.2 For CHEAP" (AI Edge, 19 min; watched:
  local transcript, YouTube captions were rate-limited). Its points that fit us: (1) search helpers run on the session's
  model (up to Opus) unless told otherwise - a project `Explore` agent on Haiku fixes that (built:
  `.claude/agents/Explore.md`, read-only, cites path:line); (2) effort is the biggest lever - medium is the cheap default,
  high costs ~3x for a few points; his `~/.claude/settings.json` has `opus[1m]` + `effortLevel: high` - his call, asked;
  (3) helpers inherit effort; (4) splitting small jobs across helpers costs MORE (the lead re-briefs and re-reads) - only
  big jobs are worth delegating; (5) use the top model for a final review, not the whole job.
- Q-S294-267 (films while he plays) still unanswered. Today's two films ran while no game window was open.

## Collected
- Qwen HEADSPLIT2 (PR 350, diff applied 91e487edb): every head jump says WHEN in the punch it falls (pre / contact / post /
  late / none). head_split_test green. Qwen's own finding: clips cut soon after contact, so `post` under-reports (a
  combo's next punch reads `pre`) -> HEADSPLIT3 launched on Qwen (combo phase), ETA ~16:05.
- s508a vs s508b (S508 r1, trunk capped at every held frame) share only 120 frames; whole films pre 41 -> 28, contact 9 -> 0,
  post 1 -> 3, none 40 -> 32. s508a vs s508c (same bout): pre 41 -> 39, none 40 -> 37.

## HEADJUMP1 - why the cap lets a head through (`-- capwhy`, ff7c3b7d6)
- PopCap prints every pass where the drawn head still travels over 12 cm in a frame, with what held the cap off.
- s509a (180 s, seed 7): 136 passes. 72 = a LANDED punch at full hold (47 on the frame after the hit = the carry
  through, 20 on the hit frame, 5 before); 43 = hit reactions freed on purpose (FREE_HIT_S, "a blow IS a fast head");
  ~20 partial holds; 11 blocked / height-only punches.
- Rejected, code removed:
  - the trunk capped from the frame after the hit at full hold, glove settled: hit_carry 31 -> 43 (gloves 5-16 cm off her
    on the hit frame, carry over-runs);
  - the trunk capped on the way in of a punch that will not land (blocked / height-only), glove settled: film s509b vs
    s508c shares 1181 frames, head jumps 18 -> 20; one pass 24 -> 33 cm. Their heads ride the BODY's slide (root/hips),
    which the trunk cannot give back.
- So the trunk cap has no lever left: a landed punch's trunk must move (r1 S508, carry cap today), reactions are fast by
  design. What is left is the source: range (punches thrown from too far, so the lean/drive covers 15-20 cm at contact)
  or the clip's own trunk speed, and the body slide on the jab lunge (root 6 cm a frame in the worst jumps).
- NOISE: hit_carry reads 29-33 and join_return 2-4 run to run with the SAME code. Never read +-2 as a result.
- Block tests unchanged: block_meet 2-3, block_catch 5-6.

## Films
E:/FightCamp/tmp/fightweek/s509a (way-in on, first variant), s509b (way-in, final variant) - identical csv; both with
CAPWHY lines in godot.log. Baseline for the next lever: s508c.

## Next
1. Collect HEADSPLIT3 (qwen/headsplit3): combo phase; run on s508c.
2. HEADJUMP1 at the source: measure the glove-to-target distance at the moment each landed punch is thrown (RangeTable)
   - if landed jabs start 15-20 cm beyond arm's reach, the fix is range/step-in, not a cap.
3. Hook recovery (BeatClips.RECOVER_MAX 1.5x) - measure first. 4. join_return hook rep 3 / cross rep 4.
5. Blind r12 + two NEW critics - only when films may run (Q-S294-267).
