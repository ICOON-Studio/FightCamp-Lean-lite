# G137 - DOES THE CORNER CHANGE THE NEXT ROUND? (Grok, collected S101 2026-09-27)
Chat: grok.com/c/70d58310-a001-4f07-8024-3498078edb35. Condensed; grades as Grok gave them.

**No CompuBox or UFC study measures stool advice turning into a next-round landing rate. That cell is empty.**

1. **Coaching effect**
   - Halperin et al.: 12 coaches, 445 lines, about 8 cues per rest at a national championship. Winning corners used more
     external and positive talk. Correlation only (SOURCED).
   - In the lab, an external cue before a round beat a control by +2% punch speed and +3% force, and beat an internal
     cue by +4% and +5%. This is force and speed, not landing rate (SOURCED, elite boxers).
   - False feedback between rounds changed performance by 2% or less, not significant (SOURCED).
   - NBA timeouts: about 0 after causal matching; other papers find +0.05-0.5 points, contested (PROXY).
2. **Round-to-round noise**
   - UFC significant-strike accuracy is about 42%. CompuBox elite connect is 30-40% overall and 40-48% for power
     punches (SOURCED).
   - The same fighter's round-to-round SD is unpublished. The binomial SE is about 6.7 pp at 50 thrown and 35% connect,
     and about 7.8 pp for the UFC (PROXY). So one round's ±3 sits inside one SE.
   - Examples: Merab-Umar accuracy by round went 42/40/38/51/35 (SOURCED).
3. **Game-plan fit**
   - There is no RCT. Doctrine is to pick 2-3 opponent tells and drill them (JUDGEMENT).
   - BoxMind's tactical model predicts 69.8% of bout outcomes against Elo's ~60% (PROXY).
   - Expert view: a fitted plan is a small tilt, not a flip (JUDGEMENT).
4. **Recommendation, against the authored +3 read and ±5 plan:**
   - a correct one-round read: +2 landing and +2 defence, next round only (PROXY, cut from the +2-3% cue study because a
     live opponent adapts);
   - a well-fitted plan: +3 for the whole fight (JUDGEMENT);
   - a bad plan: -2 to -3, not -5 (JUDGEMENT);
   - keep it a mild tilt, never a visible spike.

**S101 action:**
- `CornerPitStop.READ_CONTACT`/`READ_DEFENCE` go from 0.03 to 0.02.
- `FightRealtime.PLAN_FIT_EDGE_MAX` goes from 0.05 to 0.03, and a bad plan is then -0.03.

The plan tests are re-run on the change.
