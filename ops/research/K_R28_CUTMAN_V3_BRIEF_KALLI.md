# K_R28_CUTMAN_V3_BRIEF_KALLI - Kalli answer (seat queue SQ32)

Brief: research/K_R28_CUTMAN_V3_BRIEF.md
Sent: 2026-11-10 13:41 | collected: 2026-11-10 14:10 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): R28_CUTMAN_DESIGN_MAP_v3.md
Verify the sources before using it.

---

Pulling the critic pack and the v2 map from the repo first, then I'll write v3.

I've read both files (they're in the FightCamp-Lean-lite repo, not on the old master). I'm writing v3 now around five decisions that run through the night and carry into the career.

The v3 page is attached above, and I'd score it 7/10. Neither critic has scored it yet. The cut now runs through the whole fight night and carries into the career.

**Before the fight:**
- **The cutman tier you hire.** Better tiers show the cut more truly and leave less scar, but cost more each night.
- **"Cutter" and "Head-clasher" tells.** You can scout them, but each one costs a tape session.
- **A "Protect the eye" plan line.** It costs one of the plan's few places.

**During the bout:**
- **The cut's true depth is hidden.** The corner sees only a range, and a better cutman narrows it.
- **The other corner hunts it** from the next round. You can hunt theirs the same way.
- **In the minute,** the cutman and the coach each split 3 points across four needs: the cut, the swelling, the call, and breath and water. Extra points on one need are worth less.
- **The stop-or-go call becomes pull out, survive or race.** The right answer depends on the cards and the cut's cause. Pro head-clash cuts stopped after round 4 go to the scorecards, and a punch cut is a TKO loss.

**After the bout:**
- **Scar tissue per eye** makes every later cut likelier.
- **Healing choices** are rest, a style change, surgery, or a better cutman.
- **Trust** moves with whether the call was right.

Every decision has a case where each option is the right one. The build is two pure modules, `CutRules.gd` and `CornerHands.gd`, plus two pieces of new screen: the corner-minute cut card, and the after-bout cut row with a scar bar on the profile.

To get to 10/10, the most important step is having John check the head-clash and amateur cut rules, because the survive-or-race call depends on them. After that, a 300-bout test should show each call is best on at least 20% of cut nights. Two smaller additions follow: opponent corners making the same call, and the Why naming the call that mattered.

I've only written the file to my computer, at `/workspace/r28/R28_CUTMAN_DESIGN_MAP_v3.md`. It hasn't been added to the repo; Claude commits.
