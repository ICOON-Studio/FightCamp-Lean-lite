# Ziva Pro - the case (S248)

Operator S248: "if ziva can help us improve ui+mechanics+animations+playetest it i can pay for it".

## What Ziva showed on the free plan (Ziva Smart, 2 of 10 free messages)
Its answer to the operator's design question (research/ZIVA_DESIGN_ANSWER_S248.txt) read the real engine (FightRealtime._run_impact
5415-6159, FightMoves.select, ImpactModel, DefenceModel, DayLap) and got every formula right - it matches Claude's own map
(FIGHT_SIM_MAP_S248.md) - and found two things we had not written down:
- per-move mastery is read ONLY by the pad-chain/MoveCards path, never by strike selection or the contact ladder;
- readiness/wear/injury never reach the bout: _fresh_body_condition() starts every region at 100, so overtraining has no fight cost;
- the engine already records rich diagnostics (dm_tally, guard kinds, defence timing, target mix) that no screen shows.
Its verdict matches FIGHTLINK: no floor mini-games; build the training -> fight bridge and make it legible; mastery first.
One snag: the free model's provider filter blocked the first try as "hate speech" (boxing words); a retry passed.

## Plans (ziva.sh, read S248)
- Hobby (now, free): $3 usage/month, 10 Smart messages, 50 Baby/day, can use YOUR Claude/Codex subscription.
- Basic $20/mo: $60 usage, no message caps.
- Pro $50/mo: $150 usage, Ziva Genius + Sonnet/Opus, the PLAYTEST AGENT that plays the whole game, web search.
- Ultra $200/mo.

## Recommendation
Pro for one month ($50): the Playtest Agent is the one thing no seat we have can do (play the whole loop and report what breaks).
Building can also run free on your Claude/Codex subscription. Stop after a month if its playtests do not find real defects.
