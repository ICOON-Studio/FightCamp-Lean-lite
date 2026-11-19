# KNOW_STAKES1 v1 - Claude's code check (S529), read as a critic's list before v2

Verdict: not sent to critics. The lever Dola picked (hidden flaws that decide bouts) is mostly ALREADY IN THE GAME, and
the season numbers are not measured. v2 must design on what exists.

## What the game already has (from the code)
1. Glass chin = the DURABILITY attribute (scripts/rules/Attrs.gd PRIMARY; the knockdown and stoppage rules read it). It is
   a ranged attribute, so the knowledge system already hides and reveals it (Look closer, Trial, Test day, sparring, bouts
   narrow every attribute's range: scripts/rules/Knowledge.gd, scripts/state/KnowWire.gd).
2. Freezes under pressure = the HABIT "freezes_on_ropes" (scripts/rules/FighterProfile.gd HABITS: 20 habits, e.g.
   drops_right_after_jab, slow_starter, fades_late, bites_on_feints, head_down_inside; assets/data/fight_habits.json has
   each one's trigger, ring beat, punish line and coach's notes). A punished habit costs HabitFix.HABIT_COST 6 power
   points in an exchange whose situation punishes it (HabitFix.punished / cost); the corner can fix ONE a round. There is
   also the COMPOSURE attribute.
3. Habits are NOT part of the knowledge system today (Knowledge.gd never reads habits). The trial screen lists a prospect's
   traits/habits in words, but no read hides or reveals them, and no price is paid to learn them.
4. Cuts: there is no per-boxer cut proneness. The doctor stops a bout from the body bands (BodyMap.DOCTOR 15,
   BandWords "doctor may stop it").
5. KNOWBOTS6 (S527): ORACLE beats BLIND by only +4.4 / +9.2 / +7.9% on top-10 finishes; the pool's true ratings spread 20
   points best-to-median.

## So v2 must
1. Use the existing habits (and durability / composure) as the hidden truth - no new flaw list. Design how habits enter
   knowledge: hidden at walk-in, which read shows which habit (and at what price), what a bout reveals (the coach's
   notebook already records a punished habit).
2. Say what the player DOES with a known habit that he cannot do with an unknown one (the matchmaking choice: the
   opponent file already names styles - OppFile / PlanFight; which styles punish which habit is in fight_habits.json
   "punish"). Without such a choice, knowing changes nothing.
3. Drop every number written as a result ("41.3%", "+$2,150"): mark them TARGETS; the probe measures.
4. Keep the probe spec (BLIND vs READ-FIRST vs ORACLE, paired, 150+ worlds) and the pass lines (ORACLE +8%, READ-FIRST
   +4% on every set).
5. Keep the S425 table of every menu it shows on and what each is wired to; no emoji icons (the game uses Lucide line
   icons, scripts/ui/Icons.gd); plain words, names only in headers.
