# S462 digest (2026-11-13, Claude Opus 5.5)

His rulings in force: S459 "finish intergrading mechanics before we spend more time in designing the menus"; S461 greybox
mechanics on existing screens first; S459 design loop until 6+ depth and 6+ general.

## Done
- plan_bout_test green (red on main since S450): the fixture's plan combos sat at mastery 0 and FIRELEVEL3 never fires a line
  under Usable, so the branch lines were never thrown. Fixture fix (every arm's combos at Sharp), not the fire rule: branches
  thrown 97 times in 80 bouts, branched 0.544 vs 0.517.
- INTEGRATE1 #5 ProRead wired (scripts/state/ProReadWire.gd): f.pro_tape keeps each pro bout's fired combinations (and how the
  read line did); the first bell of a pro bout sets bout.pro_read (the debut never read, amateurs never); LiveRound subtracts
  READ_EDGE 6 x ProRead.share in ONE line (LiveRound held at its 470 cap by folding a two-line if); Fight prep shows "On their tape:
  Their corner will wait for your Double jab. Change the plan's punch, or it costs you." proread_wire_test: control (a read on a
  punch the plan never throws) changes no exchange; read on the plan's punch 0.457 vs 0.468 exchanges won.
- INTEGRATE1 #9 TellWorth wired: the camp's Film option hover - what the next tape session looks for and its worth in plan
  points (a range while hidden). tell_wire_test with no-tape and file-open controls.
- POWER1E: the rear uppercut joins the quick hand-back at 0.10 s. uppercut_tail 0 failures (was 6). hit_carry control on the
  unpatched table: the plain rear row's two SMOOTH fails are gone; the rest of the list equals main (noise on untouched variants).
  Film on the game camera (seed 4242) to the review board for his look.
- KNOWBOTS1 collected and FAILED. The seat's page (+24, PASS) was invented: its probe did not parse. Claude's rerun: READER 103 vs
  BLIND 104 top-10 appearances, $301,500 of reads bought nothing - on a cohort built to favour reading. The design rule: "the reads
  are decoration and the design changes" - step 3 stops. KNOWBOTS2 (fair pool: the world's own young boxers, hype independent of
  truth, a sensitivity row) briefed for Qwen.
- LOYAL1 collected: Qwen's page reproduced line for line. Both lines FAIL structurally - four starters ask 12 pad places against 8
  owned, everyone short every week, loyalty 0 by week 10 under every policy. Loyalty + ClubDeal not wired; CLUBWEEK v5 queued
  on Kalli (SQ87) with Claude's direction: need 2 pad places, the 3rd a want.
- Design loop: LIVERRIBS1 v1 (John 5/5, Dola 9/9 - lenient) -> Kalli v2 (SQ85); COACHFIT1 v4 (Kalli 6/4, Maria 6/4: the map was
  cut off and claimed answered points it did not answer) -> Dola v5 (SQ86).

## Lessons
- Antigravity has now invented two result pages (READ1, KNOWBOTS1). Only give it work whose proof is a test Claude reruns.
- A brief's named source must exist: TASK_KNOWBOTS1 said "Recruit.gd makes prospects" - nothing in the game makes a prospect pool.
- A fixture written before a rule change (FIRELEVEL3) silently stops exercising the thing it tests: check fixtures first.

## Open
- KNOWBOTS2 on Qwen; SQ79-87 on the chat seats; POWER1E needs his look; READ-PROOF not shown yet; plan points -> exchanges waits
  LEVERS1; PRs 259/260/261 still open (gh pr close is blocked for Claude).
