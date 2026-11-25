# RINGSWITCH_BALANCE_BRIEF_KALLI - Kalli answer (seat queue SQ331)

Brief: research/RINGSWITCH_BALANCE_BRIEF.md
Sent: 2026-11-25 13:10 | collected: 2026-11-25 13:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'll work out the ranked balance changes for the order version now.

**Try first:** stop backing straight off from making straight punches miss. Today "jab, then back off" is 70% of best play at Long, and 85% of crosses miss, because backing off escapes everything. Make it escape only hooks and uppercuts, and give the feet a sideways step that escapes straights. That turns Long into a three-way guess.

One note before the list. "Your rear hands land easy against the Jabber" and "crosses miss 85%" come from two different bouts. The scripted Jabber doesn't play the best mix, while the solver does, so the owner's complaint is mostly about the opponent, not the rules (number 2). The expected effects below are my estimates; none of them is measured.

**THE RANKED LIST**

**1. Back off escapes hooks, not straights. Add CIRCLE to the feet.**
- **The rule.** Backing off in the same moment as a jab, cross or body cross doesn't make it miss. It still escapes hooks, the overhand and uppercuts. The new feet switch, Circle, costs 1 and moves you sideways: no range change, no ground lost. It escapes straights but walks into hooks.
- **The real boxing.** "Never back straight up against a straight punch": the straight follows you and the hook doesn't. The step-back counter that won the IBA women's finals works against swinging punches.
- **What I expect.** Straights beat back off, hooks beat circle, and back off beats hooks. The cross gets its moment at Mid, the lead hook becomes the answer to circling, and back off drops from 40% of beats to a choice.

**2. Every opponent plays the solved mix, tilted by one rule.**
- **The rule.** The Jabber, the Slugger and the Body Snatcher each play the solver's best mix, with one change each. The Jabber picks Long plays a third more often, the Slugger picks step in a third more often, and the Body Snatcher picks body punches a third more often.
- **The real boxing.** A good fighter has a style, not a script. The style shows in what they lean towards, not in always doing it.
- **What I expect.** The 96–99% win against the Jabber falls towards a fair fight, and rear hands stop landing easily. Each opponent still has a feel of its own.

**3. You only get your breath back when your feet are still.**
- **The rule.** The +1 stamina for each hand held counts only on a beat when your feet hold or clinch. Stepping in, backing off or circling gets only the base +1.
- **The real boxing.** You recover when you're set. Moving backwards all night is what tires an out-boxer.
- **What I expect.** "Jab, then back off" stops paying for itself and costs 1 a beat. An out-boxer can run 4 or 5 beats, then has to plant and fight at Mid. That should raise the time spent at Mid and Inside.

**4. Cut the trial rule, and let a step in cut off the ring.**
- **The rule.** Drop "a landed jab keeps him out". When one man steps in and the other backs off in the same moment, the range doesn't change, but the man backing off still loses a square of ground.
- **The real boxing.** The coach's answer to jab and move is to cut off the ring, not to walk through the jab.
- **What I expect.** You measured trial-off at 57% Long, 30% Mid and 13% Inside. Cutting off the ring should push the out-boxer to the ropes by about the middle of a round.

**5. HURT: a big counter takes away his guard for one moment.**
- **The rule.** A big punch (cross, lead hook, overhand or uppercut) that lands as a counter leaves him hurt. In his next beat, his held hands block nothing in the first moment. He can't be hurt again until that beat ends.
- **The real boxing.** A clean counter makes the legs go and the hands drop. That's where most stoppages start.
- **What I expect.** Knockdowns and stoppages appear. The counter rule (+1 after a miss or a block) gets a payoff worth playing for, and health taken rises above 15.

**6. An even round goes to the man who came forward.**
- **The rule.** If the round's points are level, it goes to the man who stepped in more often, and if that's level too, to the man who backed off less.
- **The real boxing.** Judges score effective aggression and ring control. A man walking backwards loses the close rounds.
- **What I expect.** A third of bouts are draws today, and that number should fall a long way. Backing off also gets a second price, on the scorecard.

**THE WEAK SWITCHES**
- **The lead uppercut: make it the short punch that beats the clinch.** At Inside it lands in the fast slot (with the jab), for 3 damage and 2 stamina. Thrown in the same moment as his clinch, it lands before the clinch takes hold. It's the right click when he wants to tie up, or holds his rear hand high against hooks. The real boxing: the short lead uppercut on the way in, the way Mike Tyson used it inside.
- **The lead hook: make it the check hook.** With number 1, it already catches a man who circles. Add one more rule: it does +1 against a man stepping in that same moment. It's the right click when he circles, or when he's walking onto you to cut off the ring. The real boxing: Floyd Mayweather's check hook against Ricky Hatton, and Juan Manuel Márquez's counters.

**THE CLINCH: its price**
1. **The other man gets his breath back too.** Clinching rests both men, so it no longer works as a cheap way to out-stamina the other man.
2. **The break.** In the first moment of the next beat, the man who clinched can't punch, because his hands are still tied up, while the other man can.
3. **The lead uppercut beats it** in the same moment.
4. **It counts for nothing.** Two clinches by one man in a round count as backing off for the even-round rule.

I expect it to fall from a quarter of close-range play to a move for when you're hurt or tired.

**OTHER ARTS LATER: decide these now**
- **Keep exactly three ranges and give each a future owner.** Long is jab and kick range (the teep and the round kick). Mid is punch range, and where a takedown shot starts. Inside is elbows, knees, the clinch and takedowns from the clinch. Never add a fourth range later, or boxing's Long changes.
- **Fix the lines now, five of them:** head straight, head from the side, chin from below, body and legs. Boxing doesn't use legs yet, but the guard table should already list them, with nothing covering legs today.
- **Fix what each limb covers when held.** Lead hand high covers head straight. Rear hand high covers head from the side. Lead hand low covers the body. Rear hand low covers from below. Later, a raised lead leg (the check) covers body and legs from kicks, and the feet's sprawl covers takedowns. The rule "a limb that strikes covers nothing in that moment" stays for every limb.
- **Make takedowns and the clinch feet actions, not hand actions.** The feet switch grows: step in, hold, back off, circle, clinch, shoot. Make the clinch a state with one setting per art: in boxing the referee breaks it after one beat, and in Muay Thai it lasts. Then the boxing clinch price above survives Muay Thai unchanged.
- **Lock the three speed slots and the damage ceiling.** New moves go into the existing fast, middle and slow slots. Nothing does more than 5 damage, because health 22 has been balanced around a top hit of 4. Kicks cost more stamina than punches because the leg is heavier, and fix that cost scale now.
- **Make each art's legal targets a setting.** Boxing switches off legs, and knees and elbows only in its rules, so the board never changes.

**WHAT WOULD MAKE ME STOP after ten bouts:** if every bout were the same jab-and-back-off at Long, ending in a points draw I couldn't tell from a win.

The rule change to try first is that backing straight off no longer escapes straight punches, only hooks and uppercuts, with a new sideways step on the feet that escapes straights instead. That breaks the "jab, then back off" habit and gives the cross a moment again.

The owner's "rear hands land easy against the Jabber" is mostly the scripted Jabber, not the rules. The fix there is to have each opponent play the solved mix with one lean of its own.

The weak switches, the price of the clinch and what to lock now for the other arts are in the two messages above. The effects I expect from each change are estimates; I haven't measured any of them.
