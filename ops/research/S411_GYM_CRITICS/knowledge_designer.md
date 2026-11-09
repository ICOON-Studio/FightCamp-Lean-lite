# Progressive knowledge (S411 v1): designer review

## 1. Score: 6/10 (capped at 5 by one hard fail? see below: scored 6 with the fail fixed in the list; as written it is **5**)
**Score as written: 5/10.**
Hard fails:
1. **No decision attached to the ranges.** The only proof the design matters is a bar (5 more top-10s per 60 worlds) that is not measured. If scouting bots do not beat blind bots, this is decoration, which the owner rejects.
2. **Scouting (opponent tells, $250 scout, tape) and knowing your own boxer are two systems with no link.** The owner's question was "why do we have scouting then?". The proposal never says what scouting buys for a prospect.
3. **"Under fire" can only be learned by risking a bout.** A chin read costs a real fight; the player has no safe way to buy it. That is a tax, not a choice.

Useless / noisy: ranges on weekly gain lines (kept, fine); a separate "ceiling in words" row (merge into one potential line); per-attribute `seen` for 14 abilities (too many things to watch: show 3 groups, not 14 bars). Heart is not trained, so "heart under fire" duplicates composure; make heart a trait revealed by moments.
Missing options: **Test a prospect** (pay or spend a session to open one group on purpose); **Ask a coach's opinion** (a hired coach names the 2 things he is surest of); **trial types** (a spar trial reveals under-fire, a gym-test day reveals measurable); **sparring with a club mate as a safe chin test**; **a "what I would bet" line** from each staff member, wrong sometimes.

## 2. Does it make signing real?
Today signing is nearly free information: a card, a star, go. The proposal makes it a bet, which is right (Football Manager hides CA/PA behind scout star ratings and gives a *range of opinion*, not blindness; Out of the Park uses scouting grades with a fuzz that shrinks, same shape as here).

Good signing, week by week. Wk0 trial: speed 60-76, chin unknown, one habit. Sign (stipend $250). Wk1-4: measurable ranges narrow as she trains; strength reads 52-60. Wk4 first spar: chin still unknown. Wk8 bout 1, a hard round: "chin held up". Player now plans a step-up. Works.

Bad signing. The prospect is hyped, so the offset centre leans high. Player sees speed 64-80 (truth 58). Wk4: 62-72. Wk6: 59-65, the centre has slid down and he is a club fighter, not a regional one. The player has paid 6 weeks of stipend, a roster place (3 at start) and a coach's time. Real loss, fair, and visible. **Missing:** a way to release cheaply in the first month (trial contract), otherwise the roster place is a trap.

Annoying: waiting 6 bouts for a chin; the player cannot tell a 4-week-old range from a lazy one; goals already read the truth (rule 2) which leaks hard information (a goal "chin +2" tells you chin exists). Fix: goal attributes show a number only for gain, not level.
Gaming it: (a) sign everyone as trial and spar them against the strongest member for free chin reads; (b) always take the widest-range, highest-potential prospect because the offset is symmetrical, so EV is neutral and the upside is free; (c) reading goals and the win-chance band back-solves the truth. Fixes: spar reads are weak per round and cost fatigue/injury; make the offset **biased by hype**, so wide + hyped ranges are on average worse; hide the win chance's exact centre, show band only.

## 3. Split and scales
Measurable / skills / under fire is the right split: it follows what a coach can see. Move **fatigue to Measurable** and **fight IQ to Skills** (a coach reads IQ in sparring, not only in bouts). Under fire = durability, composure only. Times: 4 weeks / 10 weeks / 6 bouts is too slow for the first hour of the game (a bout is week 4). Scale by exposure, not calendar: sharpen per session and per hard round; give a first-bout reveal of the big one.
Offset centre: a good idea, not a cheat, **if** the offset is correlated with something the player can read (hype, source of the prospect, scout quality). Pure random offset is a lottery, and the player learns nothing from reading it. Truth-always-inside is honest; make the *width* itself informative (it is already).

## 4. Conflicts with the pack
- Win chance band "widens when unscouted" exists for amateur offers: reuse it, one concept, not two.
- Goals (70% clearable) read truth: leaks as above.
- Ex-pro edge today = one tell on the *opponent* file; the proposal gives Old hand "habits sooner" and Amateur coach exact potential: three edges, three meanings of "knowing". Keep one word.
- Strength coach edge today = body mornings +10%, craft -10%; the proposal adds "exact measurable": too strong a bundle for one hire.
- Prospects already show ranges until a trial: the new design makes the trial less of a moment (ranges then continue). Make the trial the first big narrowing.
- Roster place cost (3 places) interacts with bad signings: fine, but needs a release path.
- "No flavour text": "Lucy's chin held up" is fine only because it is a fact.
- 14 attributes of ranges on a fighter page conflicts with "only actionable info": show what a decision needs.
- Weekly review is a need on Home, not a pop-up: reveals must sit there.

## 5. Hires as instruments
Right idea (hires become eyes). Strength coach: exact fatigue is good and cheap; "measurables exact" is too strong, split: strength coach reads strength/explosiveness/stamina exactly, physio reads recovery/flexibility/injury risk, so two hires cover six. Physio's injury meter is the best entry (actionable). Cutman "marks easily" is thin: make him name the cut risk before a bout. Second coach "skills sharpen faster" is useless as an instrument (it is a training buff); make him the skills reader. Useful addition: scouting spend (the $250 scout) opens a prospect, not only an opponent.

## To reach 10/10
1. Prove the decision: define the bot test first, and make it include a bad-signing arm; build only if scouting beats blind by the bar.
2. Unify scouting: the same $ and tape/trial actions reveal a prospect group as they reveal an opponent tell. Show one "Scout" button everywhere with a price and what it opens.
3. Add a deliberate, priced read: Test day (measurable), Spar trial (skills + chin, small injury risk), Coach's opinion.
4. Cut the display to three groups (Body, Skills, Under fire) with one fading bar each, plus one potential bar; no 14-row board.
5. Scale by exposure (sessions, hard rounds) not weeks; reveal the first big thing at the first bout or trial.
6. Hype-biased offset, visible as a "hyped" tag on the prospect; wide and hyped is bad on average.
7. Trial contract: release a new signing within 4 weeks for the cost of the stipend; no roster-place trap.
8. Stop goals and win-chance leaking truth: goals show progress, not level; the band keeps its width.
9. Split the instruments: strength coach (3 physical), physio (3 physical + risk), second coach (skills), cutman (cuts before a bout); drop "exact for all".
10. Reveal as a Home need and a one-line moment with a bigger picture (bar snapping tight), nothing new to manage.

Image: docs/mockups/s411/knowledge/designer/10.png
