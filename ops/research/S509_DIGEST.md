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
- CORRECTED LATER IN S509: the 'noise' (hit_carry 29-33, join_return 2-4) was MY runs missing `--fixed-fps 60`, which
  tools/run_tests.sh always passes (S470). With it every run reads the same.
- Block tests unchanged: block_meet 2-3, block_catch 5-6.

## After the first wrap (owner: "why did you stop ?" - my call, not a rule; carried on)
- HEADSPLIT3 collected (Qwen PR 351): `combo` phase. s508c: pre 39 -> 33 + combo 6 (a combo's next punch after a hit).
  head_split_test 293 PASS (was 208).
- Range at the throw (scratch range_throw.py on s508c): from the punch's first frame to contact the gap closes
  jab 14 cm (6 frames), cross 7 cm (5), body shot 34 cm (12), hook -5 cm. Normal for a jab stepping in: punches are NOT
  thrown from too far. Head jumps at contact are the contact frame itself.
- Hook recovery 1.5x: glove p90 4.8 m/s, worst frame 9.0 m/s at 1.5x; the fastest hook frames (11.9) are the strike at
  1.0x. RECOVER_MAX left alone.
- join_return: the cross's 18-20 m/s step was a wait-beat PAW (pro_left_jab_b) starting 2 frames into the ease back to
  guard - its quick join snapped the returning rear glove 0.33 m in a frame. Fix (cc1f9476f): GuardLife._joining - a due
  paw / feint / fidget waits until her join into guard has run (`-- nojoinwait`). In the game (s508c, 30 fps) 65 of 110
  paws start inside that ease (worst 7.4 m/s over 4 frames vs 4.9 later). The test still reads 2-6 run to run (random
  guard start + beat clocks: uppercut reps now carry the worst frames).
- Checked, NOT a game defect: pro_idle's loop seam (film wraps worst 4.8 m/s, tail normal). A seam join was tried and removed.
- Measured with --fixed-fps 60 (as run_tests.sh): with / without the join wait - hit_carry 26 / 31, block_meet 13 / 14,
  block_catch 10 / 10, join_return 3 / 3 (rear uppercut 11.4, lead hook 9.6 m/s left). block_meet was never 3: earlier
  sessions also ran it without the fixed frame rate (the nightly lists it failing).
- Export with WHAT_TO_TRY "no glove snap right after a punch".

## Blind round 12 (E:/FightCamp/tmp/fightweek/r12blind, his "Film it now" 16:50)
Same bout as r11 (seed 7, 75 s, 1920x1080, sheets at the r11 times and crop), two NEW critics (fresh Claude agents, r11 briefs).
SCORES: coach 5.0 (r11 5), animator 5.0 (r11 5.0) - flat. Areas coach / animator: punches 5 / 5.5, defence and reactions
5 / 4.5, footwork 4 / 5, transitions 4.5 / 4, waiting 4.5 / 5.
Rulers r11 -> r12: head jumps 32 -> 28, cross reaction peak 1 -> 3 frames, body step back 18 -> 23 cm; WORSE: arm out
after contact worst 16 -> 29 frames, a head inside the other's body 0 -> 2 frames.
Both critics' shared top fixes: (1) arm home within 3-4 frames, never held over 2 (median 5, worst 29: red's cross ex1
#40-47); (2) blue's FREE glove shoots straight up above his head after punches (ex1 #40-47, ex2 #27-30, ex4 #25-32, ex5
#35-36) - r11 named it too, NOT fixed; (3) reactions sized by punch (a landed jab moves the head 4.6 cm at 61.17 s; hook
turn 18 deg vs 30-40); (4) heads apart (blue's head into red's chest ex4 #21-24) and no glove-on-glove standing at close
range (wait #13-24); (5) feet in every exchange: entry step in, exit step / pivot out. Coach also: the near rope hides the
shins. Films + both 10/10 on /review. The film ran while ArcheAge was open (his "now"): the PC lagged - films wait for no game window.

## Films
E:/FightCamp/tmp/fightweek/s509a (way-in on, first variant), s509b (way-in, final variant) - identical csv; both with
CAPWHY lines in godot.log. Baseline for the next lever: s508c.

## Next
1. Blue's free glove above his head (r11 + r12 critics, ex1 #40-47): find which clip / layer lifts it, guard box chin to
   10 cm over the brow.
2. Arm out after contact: worst 29 frames (red's cross ex1 #40-47) - read why the hold runs that long.
3. A head inside the other's body (ex4 #21-24, 2 frames). 4. join_return 3 (rear uppercut wrap in the guard join, lead
   hook after hit-stop).
