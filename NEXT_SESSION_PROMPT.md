# S357 - next session (written S356, 2026-11-02, after update 59)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S356 shipped update 59 (Lean ef7ff01 + 8876fc2): the camp's phase writes the week (WeekPhase: build / peak / fight-week
taper, one card a day, exceptions only), twist cards you answer (9 priced choices from his Miro draft), Test it on the plan
board (PlanTest), the peak-camp bonus (PeakCamp), and the Training tab as the coach's whiteboard (his Miro mockup:
WhiteboardKit + WeekBoard + WeekCoach). Suite 102/102, build exported. Digest: Game/Godot/research/S356_DIGEST.md.
OPERATOR RULES: no his/her in game text; agents do animations, Claude mechanics + UI; probes at `--fixed-fps 30`; tests may
run beside ONE windowed render on GREEN; "you can always do that" = update tools without asking. He now designs through
MIRO (Miro AI stickies, draft frames, HTML mockups on https://miro.com/app/board/uXjVETf7la4=/): check it at session start.

1. Collect Ziva's SMOOTH3 round 4: wt/ZIVA_LEAN branch ziva/smooth3-r4, docs/ziva/SMOOTH3_r4_result.md (chat "Fixing
   PunchReach Continuity Issues" at http://127.0.0.1:7012/). Measure it yourself on ONE commit (plain on main vs the branch,
   tools/smooth_probe.gd, hidden desktop, --fixed-fps 30, then hit_gap_probe + inside_guard_probe). Bounds: OURS <= 250/min,
   <= 110 at a clip change, hit_gap > 0.15 m no worse, glove deep in a head <= 4 frames. Merge by diff only if it meets them.
2. Playtest a 4-week camp in the .exe on the whiteboard (computer-use on his screen only with his OK; otherwise the hidden
   desktop + stills): answer twists, use Test it, reach a peak camp. Kalli reviews the whiteboard design (seat_queue), Ziva
   playtests in the editor. Ask the operator about outside human testers.
3. The last twist card from the Miro draft: Short-notice swap (rare, only 2+ weeks out; accept = tougher opponent, bigger
   reward, the tape restarts; withdraw = the camp ends).
4. Whiteboard polish seen in the stills: a twist-changed day shows the twist's card - mark which card it replaced on hover.
5. BELT ROAD NEEDS A PULL (operator S356: "nothing is pushing you to get to black belt unless fighter is goal for him"): when
   the belt road is built (his Q-S294-78/80 answer), a belt must change the game - (a) a belt goal among FighterGoal's goals
   for a BJJ-minded fighter (morale on met/missed); (b) the gym: a brown/black belt (fighter or coach) unlocks a BJJ evening
   class (members + weekly income, like the boxing classes); (c) IBJJF belt divisions open bigger titles/reputation, and
   belt level = her ground skill for the MMA update. Arts-feed-MMA scope question is Q-S294-85
   (Game/Godot/research/ARTS_FEED_MMA_S356.md).
6. A board Test button for update 59 (S310 rule, promised S356): TestJump `jump=camp` - quick start, Lucy signed, a coach, a
   bout booked and the camp started, landing on Fighters > Lucy > Training (the whiteboard) with a choice twist dealt; add the
   button to the ops board's PLAY THE GAME row.
