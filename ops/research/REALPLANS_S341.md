# Real fight plans - documented plans to compare with our answer table and to load as flow templates (S341)

Operator: "can you find real fight plans to compare them or add them as situation templates on grappleflows".
Scope: specific real fights whose plan is documented (trainer interview, fighter's own account, corner report or a
reputable round-by-round analysis). Prior work, not redone: `FIGHT_PLANS_RESEARCH.md` (what a plan is, per discipline)
and `FLOWS_S339.md` (the flow view). Web search + fetch only, 2026-11-01. Every claim names its source; where a
source could not be opened (paywall, 403, 404) and only its search snippet was read, the line says "(snippet)".

How to read the arrows: `{move, when}` uses ONLY our ids. Places: outside, long, mid, inside, clinch, own_ropes,
opp_ropes, corner. WHEN: press, range, counter, loadup, tiring, hurt, she_tired, she_hurt. A real move we do not have is
written in plain words in [brackets] and collected in section 5.

Confidence: HIGH = the plan is stated by the trainer/fighter AND the fight shows it; MED = one of the two, or a good
analysis; LOW = thin or disputed. No folklore is used as a plan; disputed parts are marked.

---

## 1. Boxing - 14 documented plans

### B1. Ali v Foreman - 30 Oct 1974, Kinshasa (pro heavyweight, Ali KO 8) - MED, planned-ness disputed
- Opponent's game: **press + loadup**. Foreman cut the ring off and threw heavy hooks, mostly to the sides and body.
- Plan: round 1, Ali surprised him with right-hand leads instead of dancing. From round 2 he lay on the ropes, covered
  up, let Foreman punch himself out on arms and gloves, leaned on him and pushed his neck down in clinches, and
  countered over the jab. Whether this was planned is disputed: Ali told Thomas Hauser decades later he did not really
  plan it (Guardian 2024 headline); his corner yelled at him to get off the ropes.
- Arrows: `{1-2, range}` [lead right] -> `backed_up` (Ali CHOSE own_ropes - we only have it forced) ->
  `{tie_up@own_ropes, loadup}` [lean on him in the clinch] -> `{slip 2-3@own_ropes, loadup}` (counters off the ropes)
  -> round 8 `{1-2-3-2, tiring}` (right hooks over the jab, then a five-punch combination; Foreman down).
- Worked: yes - Foreman's punches went wild by round 8; Ali led on all three cards at the stoppage.
- Mid-fight change: the whole rope tactic was a round-2 switch away from the corner's plan (dance/move).
- Quote: Angelo Dundee, "When he went to the ropes, I felt sick." (via Wikipedia, Rope-a-dope)
- Sources: https://en.wikipedia.org/wiki/The_Rumble_in_the_Jungle ; https://en.wikipedia.org/wiki/Rope-a-dope (snippet) ;
  Hauser/Guardian 2024 via https://inkl.com/news/i-didn-t-really-plan-it-what-ali-told-me-when-we-rewatched-the-rumble-in-the-jungle (title only, 403)

### B2. Hagler v Hearns - 15 Apr 1985, Caesars Palace (pro middleweight, Hagler TKO 3) - HIGH
- Opponent's game (Hearns): **range** - tall jabber with a huge right hand; also a gunfighter who would trade (Petronelli).
- Plan (Hagler's camp, Tony Petronelli): jump all over him from the bell, make it a street fight, because Hearns would
  trade and lose a trade. Hearns' own trainer Emanuel Steward begged him between rounds to box and move and not stand
  toe to toe (Hearns ignored it in round 1, broke his right hand).
- Arrows (Hagler): `{step_in, range}` -> `{cut_off, range}` -> `{1-2@opp_ropes, range}` -> round 2 stayed southpaw to
  counter Hearns' jab [counter the jab] -> round 3 `{1-2@opp_ropes, hurt}` (overhand left drives him to the ropes) ->
  `{herd, hurt}` / right hook, right to the chin.
- Arrows (Steward's plan for Hearns, not followed): `{step_back, press}`, `{1-1, press}`, `{pivot_out, press}`.
- Worked: Hagler's yes; Hearns' plan was never tried.
- Mid-fight change: round 3 the cut reopened and the doctor looked at it; with a stoppage risk Hagler went back to
  round-1 all-out aggression [WHEN: own cut / stoppage risk].
- Quote: Tony Petronelli, "We wanted a street fight."
- Sources: https://boxingnewsonline.net/the-plan-was-to-have-hagler-jump-all-over-hearns-it-wasnt-a-gamble/ ;
  https://roundbyroundboxing.com/editorials/flashback-friday-war-marvin-hagler-vs-thomas-hearns/ ;
  https://en.wikipedia.org/wiki/Marvin_Hagler_vs._Thomas_Hearns

### B3. Leonard v Hagler - 6 Apr 1987, Caesars Palace (pro middleweight, Leonard SD 12) - MED
- Opponent's game (Hagler): **press** - the aggressor all night; started orthodox (lost rounds 1-2 on all cards), went
  back to southpaw from round 3.
- Plan: jab, land a combination, move away; then a burst in the last ~30 seconds of every round so the judges remember
  him winning it (Arum says the habit came from Ali). Hugh McIlvanney: steal rounds with timed flurries.
- Arrows: `{1-1, press}` -> `{1-2, press}` -> `{step_back, press}` / `{step_out, press}` -> `{pivot_out, press}` and,
  [WHEN: last 30 s of the round], `{1-2-3-2, press}` then `{step_out, press}`.
- Worked: on the cards (split decision, still argued: one card 118-110). Leonard landed 49% to Hagler's 37%.
- Mid-fight change: none from Leonard; Hagler's stance switch in round 3 was the adjustment.
- Quote: Leonard, "I jabbed him and I hit him at will."
- Sources: https://en.wikipedia.org/wiki/Marvin_Hagler_vs._Sugar_Ray_Leonard ;
  https://www.cbssports.com/boxing/news/sugar-ray-leonards-upset-of-marvin-hagler-remains-a-boxing-landmark-30-years-later/

### B4. Holyfield v Tyson I - 9 Nov 1996, MGM Grand (pro heavyweight, Holyfield TKO 11) - HIGH
- Opponent's game (Tyson): **press + loadup** - dips left and loads the left hook, one punch at a time.
- Plan (Holyfield's own decision before the fight, from his study of Tyson): never go backwards; come forward, block
  the first punch, clinch, use his strength to SHOVE Tyson back onto his heels (kills his power and balance), then hit
  him with quick combinations and counters.
- Arrows: `{tie_up, press}` -> `{push_off, press}` [shove her back - push_off is our clinch exit, not a press answer]
  -> `{1-2-3, loadup}` (counter combinations as he loads) -> round 6 `{3b-3, tiring}` (left hook to the body, knockdown)
  -> round 10-11 `{cut_off, hurt}` -> `{herd, hurt}` -> [uppercuts on the ropes; we have 1-6-3 only @corner] -> stoppage.
- Worked: yes, clearly; Tyson kept missing and was outboxed from round 8.
- Mid-fight change: none needed; Holyfield was hurt in round 5 and kept the plan.
- Quote: Holyfield (2002, advising Lewis), "I don't believe anybody is going to beat Tyson by going backwards."
- Sources: https://en.wikipedia.org/wiki/Mike_Tyson_vs._Evander_Holyfield ; https://www.dawn.com/news/36526 (snippet) ;
  https://www.boxingscene.com/holyfield-breaks-down-his-strategy-upset-mike-tyson--149297 (snippet, 403)

### B5. Pacquiao v Hatton - 2 May 2009, MGM Grand (pro light-welter, Pacquiao KO 2) - HIGH
- Opponent's game (Hatton): **press + loadup** - charges straight in, cocks/pumps the left hook before throwing it.
- Plan (Freddie Roach, months of tape): from southpaw, the right hook lands every time Hatton cocks or throws the left
  hook; drilled daily. Roach and Buboy Fernandez also wanted the body; Pacquiao switched to the head when the guard
  opened. After the first knockdown Hatton's guard moved toward Pacquiao's right, which opened the left.
- Arrows: `{slip 2-3, press}` (the counter hook as he comes; ours is cross + check hook, his was a lead right hook) ->
  `{3b-3, press}` (the planned body work) -> `{slip 2-3, loadup}` -> `{1-2-3-2, hurt}` -> left to the chin at 2:59 of rd 2.
- Worked: yes, two knockdowns in round 1, KO in round 2.
- Mid-fight change: body -> head when the guard opened (Pacquiao, in his own words).
- Quote: Roach, Hatton is "wide open for the right hook from the southpaw stance."
- Sources: http://www.gmanetwork.com/news/sports/content/160145/roach-plan-solution-to-hatton-s-brawler-style/story ;
  https://www.philstar.com/sports/2009/05/04/463752/manny-reveals-secret-weapon/amp/

### B6. Mayweather v Canelo - 14 Sep 2013, MGM Grand (pro light-middle, Mayweather MD 12) - MED (analysts, no trainer quote found)
- Opponent's game (Canelo): **press + loadup** - walked forward, tried the body, wanted to set his feet for power.
- Plan as executed: jab and straight right from just out of range; edge in, land a jab or a LEAD right, clinch at once
  so Canelo cannot answer; keep moving so Canelo never sets his feet; make him miss by inches and counter with hooks
  and uppercuts; control distance and pace. Eased off in rounds 8-9 (Canelo's best rounds, body punches).
- Arrows: `{1-1, press}` -> `{1-2, loadup}` [lead right] -> `{tie_up, press}` right after landing [hit and hold] ->
  `{slip 2-3, loadup}` -> `{pivot_out, press}` / `{step_out, press}` -> round 12 `{step_out, she_tired}` (danced out).
- Worked: yes - Sky panel (Froch, Macklin, Oliver): Canelo was made to fight Floyd's fight and turned hesitant.
- Sources: https://bleacherreport.com/articles/1774459-mayweather-vs-canelo-round-by-round-chronicling-moneys-dominant-win ;
  https://www.skysports.com/boxing/news/12183/12323143/when-floyd-conquered-canelo-what-was-the-secret ;
  https://tss.ib.tv/boxing/featured-boxing-articles/17257-how-he-did-it-mayweathers-mastery-explained (snippet: lead + clinch)

### B7. Joshua v Ruiz II - 7 Dec 2019, Diriyah (pro heavyweight, Joshua UD 12) - HIGH
- Opponent's game (Ruiz): **press + loadup** - short, fast hands, wins inside exchanges; in fight 1 he dropped Joshua
  when Joshua chased the finish after dropping Ruiz.
- Plan (Rob McCracken): box him - jab, keep the distance, never a stationary target, do not exchange power shots;
  Joshua came in ~11 lb lighter to move. McCracken on fight 1: Joshua pushed too hard for the finish and ran into hooks.
- Arrows: `{1-1, press}` -> `{1-2, press}` -> `{step_back, press}` -> `{pivot_out, press}` -> `{tie_up, press}` when he
  got close. Fight-1 lesson as an anti-arrow: `{1-2-3-2, hurt}` WRONG against a hurt opponent who still hooks back.
- Worked: yes - Ruiz could not cut the ring off; he admitted afterwards he should have pressured more.
- Quote: McCracken, "I want to box Ruiz, and that's what he's going to do."
- Sources: https://www.boxingnews24.com/2019/09/joshuas-trainer-rob-mccracken-talks-mistakes-against-ruiz ;
  https://www.si.com/boxing/2019/12/09/anthony-joshua-andy-ruiz

### B8. Fury v Wilder II - 22 Feb 2020, MGM Grand (pro heavyweight, Fury TKO 7) - HIGH
- Opponent's game (Wilder): **range + loadup** - long jab to set up one huge right hand; needs distance and his legs.
- Plan (SugarHill Steward, Kronk style): jab, box, control and keep coming forward for the knockout - drop fight 1's
  box-and-move plan. Andy Lee: camp drilled staying aggressive while slipping out of range of the right.
- Executed: rd 1 came forward, short right inside; rd 2 jab pressed Wilder to the ropes; rd 3 right hand knockdown, body
  work in the clinch; rd 4 uppercuts inside, Wilder pinned in a corner; rd 5 knockdown to the body (point taken for
  hitting the back of the head); rd 6-7 Wilder trapped on ropes/corner, towel.
- Arrows: `{step_in, range}` -> `{1-1-2, range}` -> `{cut_off, range}` -> `{1-2@opp_ropes, range}` ->
  `{3b-3@opp_ropes, tiring}` -> `{herd, hurt}` -> `{1-6-3@corner, hurt}`; in the clinch [lean his weight on him].
- Worked: yes; once Wilder's legs went he could not throw the right with power (ESPN).
- Quote: Steward on the plan, "It's so simple, you could miss it."
- Sources: https://www.skysports.com/boxing/news/12183/11888471/tyson-furys-new-trainer-sugarhill-steward-on-their-link-up-and-the-plan-to-beat-deontay-wilder ;
  https://www.sportskeeda.com/mma/news-tyson-fury-s-trainer-sugarhill-steward-reveals-gameplan-deontay-wilder (snippet) ;
  https://global.espn.com/boxing/story/_/id/28760236/breaking-wilder-fury-ii-next-heavyweight-division ;
  https://www.sherdog.com/news/news/Boxing-Wilder-vs-Fury-2-PlaybyPlay-Results-Round-Scoring-170423

### B9. Lopez v Lomachenko - 17 Oct 2020, Las Vegas (pro lightweight, Lopez UD 12) - HIGH (both sides on record)
- Opponent's game (Lomachenko): **counter** - a famously slow starter who waits, reads, then takes over.
- Plans: Lopez Sr. - Loma is predictable; come out fast and take the early rounds. Lomachenko - make Lopez come forward
  and throw combinations, make him miss (he also says a shoulder injury held him back).
- Arrows (Lopez): `{1-1, counter}` (stiff jab keeps Loma at the end of his punches) -> `{1-2, counter}` ->
  `{1-2-3b, counter}` (hooks to the body) - busier, not bigger. Late: rd 7-11 Loma got inside and Lopez struggled going
  backwards; rd 12 `{3b-3, she_tired}` (dug body shots although tired - he needed the round).
- Arrows (Loma's plan): wait for `{slip 2-3, press}` - it needed Lopez to over-commit, which he did not.
- Worked: Lopez won the early rounds on all cards and held on; Loma's best was round 11.
- Quote: Lomachenko, "I had to make him move forward."
- Sources: https://www.thefightcity.com/?p=44024 ;
  https://www.boxinginsider.com/headlines/vasiliy-lomachenko-explains-his-game-plan-in-teofimo-lopez-upset-defeat/ ;
  https://www.ringtv.com/?p=611540 ; https://sports.yahoo.com/does-teofimo-lopez-have-what-it-takes-to-solve-vasiliy-lomachenko-162202144.html

### B10. Inoue v Fulton - 25 Jul 2023, Tokyo (pro super-bantam, Inoue TKO 8) - MED (analysis, no trainer quote found)
- Opponent's game (Fulton): **range** - taller, wide stance, on the move; later tried to lead and got countered.
- Plan as executed: hard jabs to the BODY from round 1 to break his rhythm; pressure from round 2; two- and three-punch
  combinations standing his ground; counter Fulton whenever he leads. Finish: body jab, right hand over the top (he
  never saw it), left hook, then pinned in a corner with body-head combinations.
- Arrows: [body jab] `{1-1, range}` -> `{step_in, range}` -> `{1-2-3, range}` / `{2-3, range}` -> `{cut_off, range}`
  -> [counter her lead at long] -> rd 8 `{1-2, hurt}` -> `{herd, hurt}` -> `{3b-3@corner, hurt}`.
- Worked: yes - 6-0 up at halfway, stopped in 8.
- Sources: https://boxingnewsonline.net/monster-truck-inoue-drives-through-fulton-to-become-number-one-super-bantamweight ;
  https://www.ringtv.com/656436-naoya-inoue-proves-he-is-the-worlds-best-pound-for-pound-by-stopping-stephen-fulton-in-eight/ (snippet)

### B11. Katie Taylor v Sofya Ochigava - 9 Aug 2012, London Olympic final (AMATEUR lightweight, Taylor 10-8) - LOW-MED
- Opponent's game (Ochigava): **counter** - spoiling, defensive, invited Taylor on and caught her with the right.
- Plan: the detail is not published; Taylor says the corner (father Pete Taylor, Zaur Antia) stayed calm and told
  her to stick to the plan. The bout shows it: level after round 1 (Taylor ended it with a flurry on the bell), down
  4-3 after 2, won round 3 4-1, held the last round.
- Arrows (what the bout shows): `{1-1-2, counter}` -> `{feint, counter}` (cat-and-mouse for the ring centre) ->
  [WHEN: last seconds of the round] `{1-2-3-2, counter}` -> round 3 `{1-2-3, counter}`.
- Worked: yes, narrowly. Lesson for our amateur game: rounds are short; one round decided it (Irish Examiner).
- Quote: Taylor on the corner, they "told me to stick to the game plan."
- Sources: https://www.irishexaminer.com/sport/othersport/arid-20203739.html ;
  https://www.rte.ie/sport/olympics/2012/0809/332880-boxing-katie-taylor-wins-gold (snippet)

### B12. Katie Taylor v Amanda Serrano I - 30 Apr 2022, Madison Square Garden (pro lightweight, Taylor SD 10) - HIGH
- Opponent's game (Serrano, southpaw): **press + loadup** - the bigger puncher, pressure, heavy combinations.
- Plan (Ross Enamait, per The Ring): box at range and do not brawl. Taylor deviated and brawled. Round 5
  Serrano trapped her in a corner and she nearly went - she admits she stayed in the exchange too long.
- Corner fix: Enamait made her STAND between rounds to stop her legs cramping (calf injuries); her movement came back in
  round 7, she outlanded Serrano in 8-9; round 10 both stood and traded.
- Arrows (the plan): `{1-1, press}` -> `{step_back, press}` -> `{pivot_out, press}`. Round 5 should have been
  `{tie_up@own_ropes, she_hurt}` -> `{pivot_out, she_hurt}`; she traded instead (`slip 2-3@own_ropes` under fire).
  Round 7-9: `{1-2, press}` -> `{step_out, press}`.
- Worked: the plan worked when she followed it; the brawl nearly lost it.
- Quote: Taylor said she got "stuck in a fight" instead of boxing.
- Sources: https://www.si.com/boxing/2022/05/02/katie-taylor-amanda-serrano-madison-square-garden-fight ;
  https://ringmagazine.com/en/news/katie-taylor-edgy-fired-up-to-deliver-definitive-statement-in-amanda-serrano-trilogy (snippet)

### B13. Chantelle Cameron v Katie Taylor I - 20 May 2023, 3Arena Dublin (pro light-welter, Cameron MD 10) - MED-HIGH
- Opponent's game (Taylor): **range + counter** - speed, footwork, distance and timing; drops counters and checks left
  hooks so attackers hesitate (Jamie Moore's own read).
- Plan (Cameron + Moore, named ambush mode): dominate early with pressure, a jab people underrate, and a two-fisted body
  attack; Moore predicted it would be won and lost on the inside. Corner kept her calm with a rehearsed trigger phrase
  when the crowd rose.
- Arrows: `{1-1-2, range}` -> `{step_in, range}` -> `{cut_off, range}` -> `{1-2-3b, range}` -> `{3b-3, range}` ->
  `{3b-3@opp_ropes, tiring}`.
- Worked: yes - Taylor's first pro loss.
- Quote: Cameron (2020), "You can see that if you put the pressure on, she will crumble."
- Sources: https://www.skysports.com/boxing/news/12040/12887020/how-chantelle-cameron-beat-katie-taylor-the-mental-techniques-behind-the-undisputed-triumph ;
  https://bloodyelbow.com/2023/05/22/katie-taylor-chantelle-cameron-victory (snippet, paywall) ;
  https://www.irishnews.com/sport/2023/05/08/news/katie_taylor_s_reckoning_cameron_will_spoil_dublin_party_says_jamie_moore-3262697/ (snippet) ;
  https://boxingnewsonline.net/chantelle-cameron-you-can-see-that-if-you-put-the-pressure-on-katie-taylor-will-crumble

### B14. Katie Taylor v Chantelle Cameron II - 25 Nov 2023, 3Arena Dublin (pro light-welter, Taylor MD 10) - MED
- Opponent's game (Cameron): **press + range** - pressed again, won the jab battle early with her reach, Taylor on the
  ropes in round 2; uppercuts in 5, body from 6.
- Plan as executed (Boxing News verdict; no Enamait quote found): tighter work - clusters of punches with faster hands
  that land first, instead of fight 1's sloppy output; left hook as Cameron pulled up, chopping rights. Tired in 7;
  round 9 punch-clinch-punch-clinch to buy time and frustrate her.
- Arrows: `{1-2-3, press}` (beat the presser to the punch) -> [counter hook as she pulls back] ->
  `{1-2, she_tired}` + `{tie_up, she_tired}` (punch then hold) -> `{push_off, she_tired}`.
- Worked: yes, majority decision (95-95, 98-92, 96-94).
- Sources: https://boxingnewsonline.net/bn-verdict-taylor-digs-deep-to-avenge-loss-against-cameron-and-level-the-score ;
  https://www.cbssports.com/boxing/news/katie-taylor-vs-chantelle-cameron-2-results-highlights-taylor-avenges-loss-to-earn-second-undisputed-crown/

Not found well enough to use: Shields v Marshall (2022) - results and punch stats only, no stated plan from either
camp; Usyk v Joshua I - Joshua said he had "no specific plan", Usyk's camp plan not on record (only pundits).

---

## 2. Wrestling - 9 documented match plans and coach-taught templates

Our standing rows: collar_tie, underhook, wrist_control, two_on_one, russian_tie, front_headlock (reaction -> technique).
"MISSING" = a reaction/technique the real match or coach uses that we have no row for.

### W1. Helen Maroulis v Saori Yoshida - Rio 2016, 53 kg final (Maroulis 4-1) - HIGH
- Opponent's game: deep single-leg shooter; reaches for a headlock when an opponent goes past her.
- Plan (Maroulis' own study, translated Yoshida interviews): ATTACK her - Yoshida had not faced anyone in a decade who
  believed they could win; make it mental. Coach Valentin Kalika.
- How it went: P1 Yoshida got deep on a single, could not finish; Maroulis was put on the activity clock and lost a
  point (0-1). P2 she slipped to the side going behind, pulled her head out of Yoshida's headlock and scored (2-1);
  inner-thigh hold drove Yoshida out, upgraded to a 2-point takedown (4-1); last 20 s a WHIZZER stalemated the single.
- Our rows: none fit directly. MISSING: whizzer vs a single; go-behind as she reaches for the head; push-out /
  inner-thigh drive; the activity clock as a WHEN.
- Quote: Maroulis, "I don't think she likes when people attack her."
- Source: https://uww.org/article/helen-maroulis-makes-history-upends-saori-yoshida-rio-2016

### W2. Sarah Hildebrandt v Yusneylys Guzman Lopez - Paris 2024, 50 kg final (Hildebrandt 3-0) - MED
- Opponent's game: single legs and a double from open space (a leg shooter).
- Plan as executed: score early (P1 takedown), win the hand fight, stuff the double, defend every single; P2 point
  from the shot clock, then a sweep single. Lead built early, opponent "kept at bay".
- Our rows: `wrist_control` "pulls her wrist back" -> Snatch single is the nearest to her sweep single off the hand
  fight. MISSING: "she shoots from open space" (no tie) -> sprawl / single-leg defence; protecting a lead.
- Sources: https://flowrestling.org/articles/12767361-sarah-hildebrandt-makes-the-olympic-wrestling-finals ;
  https://intermatwrestle.com/articles.html/women/hildebrandt-smiles-on-the-way-to-olympic-gold-medal-r99441 (snippet) ;
  https://www.ksl.com/article/51093919/usas-sarah-hildebrandt-beats-cuban-for-gold-after-original-opponent-indias-phogat-misses-weight

### W3. Tamyra Mensah-Stock v Blessing Oborududu - Tokyo 2021, 68 kg final (Mensah-Stock 4-1) - LOW-MED (pattern, no stated plan)
- Pattern: spin-behind takedown 2-0, conceded a reversal, leg-attack takedown 4-1 by the break; P2 defensive with a
  few timed attacks so Oborududu could never fully commit to chasing. Her stated mindset: "wrestle smart".
- MISSING: spin-behind / go-behind; score-state WHEN ("ahead: attack just enough").
- Sources: https://www.click2houston.com/sports/2021/08/03/olympic-wrestling-day-11-usas-mensah-takes-gold/ ;
  https://www.npr.org/sections/tokyo-olympics-live-updates/2021/08/03/1024247363/tamyra-mensah-stock-first-u-s-black-woman-to-win-wrestling-gold-tokyo-olympics

### W4. Kyle Snyder v Abdulrashid Sadulaev - Paris 2017 Worlds, 97 kg final (Snyder 6-5) - MED
- Plan and change: opened charging and pushing for step-outs, got flipped (1-3); judged the pace was not working,
  slowed down and took Sadulaev to the mat (3-3; one account says a snapdown spin-behind). Down 3-5 with two minutes
  left, survived two turn attempts, then with 40 s left a push-out (4-5) and the winning takedown (6-5).
- Our rows: `collar_tie` "leans in on the tie" -> Snapdown -> `front_headlock` (then a spin-behind, which we lack).
  MISSING: push-out; pace change as a corner call; "behind late" WHEN.
- Sources: https://victoryjournal.com/?p=7870 ; https://uww.org/article/snyder-wins-showdown-young-legends-close-paris-2017-wrestling-world-cships

### W5. Gable Steveson v Geno Petriashvili - Tokyo 2021, 125 kg final (Steveson 10-8) - MED
- Situation: behind 5-8 with under 30 s (Petriashvili's gut wrenches). Takedown to 7-8 with ~11 s, then a FEINT
  (quick outside step) and spin-around takedown with 0.2-0.3 s left; a failed Georgian challenge made it 10-8.
- MISSING: feint step; spin-behind; gut-wrench defence (par terre); "behind, seconds left" WHEN.
- Sources: https://www.startribune.com/gable-steveson-gold-medal-olympics-wrestling-heavyweight-minnesota/600085387 (snippet, "do or die") ;
  https://www.cbssports.com/olympics/news/2020-tokyo-olympics-gable-steveson-pulls-off-dramatic-comeback-to-win-gold-in-heavyweight-freestyle-wrestling

### W6. Rulon Gardner v Aleksandr Karelin - Sydney 2000, Greco 130 kg final (Gardner 1-0) - MED, GRECO not freestyle
- Plan (Gardner with coaches Chandler, Fraser, Hermann, from tape that showed Karelin slower): deny the reverse body
  lift by pressing chest-to-chest and staying heavy; the only point came when Karelin broke grip in the clinch rule.
- Out of our scope (upper-body Greco); recorded so nobody mistakes it for a freestyle template.
- Sources: https://www.deseret.com/2000/9/27/19780879/ap-miracle-on-the-mat-gardner-stuns-karelin ;
  https://content.usawmembership.com/articles/414

### W7. Coach template - "Snapdowns to Takedowns" (USA Wrestling, Ted Witulski, 2 Oct 2001; national coach Kevin Jackson)
- Opponent reaches with bent arms to tie -> double arm chop, go behind. Opponent drives back into your forearm on the
  head -> sprawling snapdown, spring up, go behind. Opponent turns away from the head tie -> chop/snap to that side.
  In a front headlock she pulls her elbows tight -> circle and re-snap.
- Our rows: `collar_tie` "leans in" -> Snapdown AGREES. "Pushes hard" -> we say Arm drag; USA Wrestling's answer to
  driving into the tie is the sprawling snapdown (both are taught; keep ours, add theirs). MISSING: go-behind finish.
- Quote: Jackson, wrestlers should "keep weight on their opponent's head and hands to score."
- Source: https://www.themat.com/news/2001/october/03/snapdowns-to-takedowns

### W8. Coach template - "See the Tie-up, React, and Attack" (2002) + "2 on 1 to a Double" (2004), USA Wrestling, Witulski
- Head tie is the most common tie; drill base shots (sweep single, double, high crotch) straight off her tie. If she
  has an underhook on you: limp-arm it clear -> near-side sweep single or high crotch the other side. A reaching arm
  gives you a two-on-one. With the two-on-one, if she posts on your head to free the arm -> split stance, lift the
  2-on-1 into her free hand, level change, shoot the far side -> double leg.
- Our rows: `two_on_one` "pulls her arm free" -> Duck under AGREES in spirit; ADD `two_on_one` "posts on my head to
  free the arm" -> Double leg. MISSING: limp-arm clear (her underhook on us - we only have OUR underhook rows).
- Sources: https://content.usawmembership.com/articles/5556 (snippet) ; https://www.themat.com/news/2004/june/04/2-on-1-to-a-double

### W9. Rules template - "vs a staller" / clock (UWW freestyle passivity)
- The passive wrestler is warned, then put on a 30-second activity period; if she does not score in it, the opponent
  gets 1 point (recent UWW change: the active wrestler also scores her own attacks). Stepping out = 1 point; fleeing the
  mat = caution + 1. So "vs a staller" = keep attacking until the referee puts HER on the clock; "ahead late" = still
  attack once per period or you give the point away (Maroulis lost a point this way in W1).
- Sources: https://uww.org/node/11098 (UWW rule-change article; full text not readable here - verify in the current
  rulebook) ; https://www.section6.e1b.org/cms/lib/NY19000854/Centricity/ModuleInstance/4395/Freestyle%20Rules%20Summary.pdf (snippet)
- Instructional only (not a match): underhook limp arm / throw-by / knee tap are standard teaching (e.g.
  https://fanaticwrestling.com/blogs/news/limp-arm-from-underhook-by-bekzod-abdurakhminov ) - our underhook rows
  (Throw-by, Knee tap, Russian tie) match common teaching but no documented match plan was found for them.

---

## 3. Comparison - real plans against our answer table

| WHEN | Real plans AGREE (fight) | Real plans DISAGREE (fight) | Real moves we lack |
|---|---|---|---|
| press | step_back, pivot_out, 1-1 best: Leonard-Hagler, Joshua-Ruiz II, Mayweather-Canelo, Steward's plan for Hearns, Enamait's for Taylor-Serrano. slip 2-3 best: Pacquiao-Hatton (counter hook as he comes). tie_up ok: Mayweather, Joshua. cut_off/herd wrong: no real plan cuts off a presser - she is already coming. | A second school wins too: MEET her and push her back - Holyfield-Tyson (tie_up then push_off, never backwards); our table has push_off nowhere for press and step_in wrong. Combinations first beat a presser: Taylor-Cameron II (1-2-3). 1-2-3-2 is "wrong" but Leonard's late-round flurries stole rounds off the presser - followed by step_out. | shove/push back; hit-and-hold; lateral circle at long range (pivot_out exists only from own_ropes); lead hook counter |
| range | step_in, cut_off, 1-2-3b, 3b-3 best: Hagler-Hearns, Fury-Wilder II, Inoue-Fulton, Cameron-Taylor I - all four walk-downs. step_out/step_back wrong: nobody beat a range boxer going backwards. | 1-1 is "wrong", but every walk-down rode the jab: Fury (Steward: jab, box, control, come forward), Inoue's body jab, Lopez's stiff jab, Cameron's jab that Moore says people underestimate. The jab is how step_in happens. 1-2 down the middle was a key punch for Fury: best, not ok. | body jab; counter her lead from long |
| counter | 1-1, 1-1-2 best and step_in ok: Lopez-Lomachenko (busy jab took the early rounds while Loma waited). Big combinations wrong: Loma's own plan was to make Lopez come forward throwing combinations and miss - confirms 1-2-3/1-2-3-2/2-3 wrong. | Lopez dug body hooks (1-2-3b) vs the waiter and it worked - our table lists no body combination for counter. Taylor-Ochigava: the round was won on flurries at the bell, i.e. 1-2-3-2 can be right at the END of a round vs a waiter. | WHEN "early rounds" / "last seconds"; score state |
| loadup | slip 2-3, 1-2 (counter), roll_out, step_back: Pacquiao-Hatton (he cocks the hook), Mayweather-Canelo, Joshua-Ruiz II. | step_in is "wrong", yet Fury-Wilder II and Holyfield-Tyson beat the two biggest loaders of their eras by CLOSING the distance (Wilder needs range for the right; Tyson needs to set for the hook); Ali's round-1 lead rights too. Real rule: loads up at range -> step in; loads up in the pocket -> slip/roll. tie_up only "ok", but Fury, Ali and Holyfield all leaned on/held the loader: best when inside. | split loadup by range; lean on her in the clinch |
| tiring | cut_off, herd, 3b-3, 1-2-3-2 best: Hagler rd 3, Holyfield rd 6 body hook, Fury rd 5-7, Inoue rd 8, Ali rd 8 combination. | Ali MADE Foreman tired by lying on the ropes and leaning on him (tie_up/own_ropes) - our table only answers tiring once it happens. Minor. | voluntary rope work (high risk) |
| hurt | herd, 1-6-3@corner, 3b-3@corner best: Fury rd 6-7, Inoue rd 8, Hagler rd 3, Holyfield rd 10-11. | Joshua-Ruiz I (McCracken): chasing a hurt man who still hooks got Joshua dropped - "hurt but dangerous" needs 1-2 + cut_off before herd, not 1-2-3-2. Pacquiao read where the hurt man's guard moved (body plan -> head) - an adaptive arrow. | hurt-but-dangerous WHEN; "switch target where the guard opens" |
| she_tired | tie_up, step_back best: Taylor-Cameron II rd 9 (punch-clinch-punch-clinch), Mayweather rd 12 danced out. | Lopez rd 12 went forward with body shots although tired - he needed the round. Score state overrides fatigue. | punch-then-hold as one arrow; score state |
| she_hurt | tie_up, pivot_out best; slip 2-3 / staying in the exchange wrong: Taylor-Serrano I rd 5 (stayed in, nearly stopped, admits it). | Hagler was rocked by Hearns in rd 1 and kept attacking and won - only for an iron-chinned, ahead-on-damage fighter; not a general rule. | corner action between rounds (stand up, ice) is not a move |

Suggested table edits the evidence supports (Claude decides; recorded here as evidence):
1. loadup: move `step_in` from wrong to ok (best when the loader is at range); `tie_up` ok -> best.
2. range: `1-1` wrong -> ok; `1-2` ok -> best.
3. press: add `push_off` as ok (Holyfield school); keep cut_off/herd wrong.
4. hurt: keep herd best, but add a "she still hits back" check that makes `1-2-3-2` and `2-3` wrong (Joshua-Ruiz I).
5. counter: `1-2-3b` ok (Lopez); `1-2-3-2` ok only in the last seconds of a round (needs the clock WHEN).

---

## 4. Proposed situation templates (load-ready)

Boxing templates use ONLY our ids. Each is a named flow the player can load in camp.

### T1. "Vs a presser: make her miss and turn her"
- Covers: press, loadup, she_tired. From: Leonard-Hagler 1987, Joshua-Ruiz II 2019, Mayweather-Canelo 2013, Taylor-Serrano I plan.
- Arrows: `[{1-1, press}, {1-2, press}, {step_back, press}, {pivot_out, press}, {slip 2-3, loadup}, {roll_out, loadup}, {tie_up, press}, {step_out, she_tired}]`
- Key idea: Jab and leave; never stand where she is punching; if she gets close, hold.

### T2. "Vs a presser: stand your ground and push her back" (strong, durable boxer only)
- Covers: press, loadup, tiring, hurt. From: Holyfield-Tyson 1996.
- Arrows: `[{tie_up, press}, {push_off, press}, {slip 2-3, loadup}, {3b-3, tiring}, {cut_off, hurt}, {herd, hurt}, {1-6-3@corner, hurt}]`
- Key idea: Don't go backwards: block, hold, shove her onto her heels, then hit first.

### T3. "Vs a rusher: hook her as she comes in"
- Covers: press, loadup, hurt. From: Pacquiao-Hatton 2009.
- Arrows: `[{slip 2-3, press}, {slip 2-3, loadup}, {3b-3, press}, {slip 2-3@own_ropes, press}, {1-2-3-2, hurt}, {herd, hurt}]`
- Key idea: She cocks before she throws - slip, cross, hook her on the way in.

### T4. "Vs a long boxer: walk her down behind the jab"
- Covers: range, loadup (at range), tiring, hurt. From: Fury-Wilder II 2020, Hagler-Hearns 1985, Inoue-Fulton 2023.
- Arrows: `[{1-1-2, range}, {step_in, range}, {cut_off, range}, {1-2@opp_ropes, range}, {3b-3@opp_ropes, tiring}, {herd, hurt}, {1-6-3@corner, hurt}, {3b-3@corner, hurt}]`
- Key idea: Take her distance away - jab your way in, cut the ring, finish on the ropes.

### T5. "Ambush a speed boxer: pressure and the body"
- Covers: range, counter, tiring. From: Cameron-Taylor I 2023.
- Arrows: `[{step_in, range}, {1-2-3b, range}, {3b-3, range}, {cut_off, range}, {1-1-2, counter}, {3b-3@opp_ropes, tiring}]`
- Key idea: Get her out of her comfort zone - close, dig the body, make every round a fight on the inside.

### T6. "Vs a waiter: outwork her early"
- Covers: counter, she_tired. From: Lopez-Lomachenko 2020 (and Taylor-Ochigava 2012).
- Arrows: `[{1-1, counter}, {1-1-2, counter}, {feint, counter}, {1-2, counter}, {1-2-3b, counter}, {tie_up, she_tired}]`
- Key idea: She gives you the early rounds - bank them with the jab; never throw the big combination she waits for.

### T7. "She's hurt but still dangerous: close the exits, straight punches"
- Covers: hurt, tiring. From: Joshua-Ruiz I lesson (McCracken), Inoue-Fulton rd 8, Fury-Wilder II rd 6-7.
- Arrows: `[{1-2, hurt}, {cut_off, hurt}, {1-2@opp_ropes, hurt}, {herd, hurt}, {1-6-3@corner, hurt}, {3b-3@corner, tiring}]`
- Key idea: Hurt is not finished - walk her to the corner with straight shots; wide swings get you countered.

### T8. "Survive the bad round: punch, hold, get off the ropes"
- Covers: she_hurt, she_tired, press. From: Taylor-Serrano I rd 5-7, Taylor-Cameron II rd 9.
- Arrows: `[{tie_up@own_ropes, she_hurt}, {pivot_out, she_hurt}, {roll_out, she_hurt}, {1-2, she_tired}, {tie_up, she_tired}, {push_off, she_tired}, {step_back, she_tired}, {1-1, she_tired}]`
- Key idea: Never stay in the exchange when your legs go - punch, hold, turn her, reset.

Not offered as a template: Ali's rope-a-dope (B1). Documented, but disputed as a plan, his own corner hated it, and our
own_ropes is a forced place, not a choice. It belongs in a story/legend card, not in a player's plan library.

### Wrestling templates (tie -> reaction -> technique chains, our rows only)
- W-T1 "Make the champion wrestle backwards" (Maroulis-Yoshida 2016; Kevin Jackson snapdowns): `collar_tie` "leans in
  on the tie" -> Snapdown -> `front_headlock` "digs for a leg" -> Shuck; `front_headlock` "turtles" -> Cement job/cradle.
  Key idea: attack first; heavy on her head and hands.
- W-T2 "Beat the heavy collar tie" (USA Wrestling 2001): `collar_tie` "leans in" -> Snapdown; "carries her head high"
  -> Duck under; "pushes hard" -> Arm drag; "steps back" -> Snatch single. Key idea: her pressure is your opening.
- W-T3 "Two-on-one chain" (USA Wrestling 2002/2004): `wrist_control` "pulls her wrist back" -> Snatch single;
  `wrist_control` "straightens her arm" -> Elbow pass/double leg; `two_on_one` "pulls her arm free" -> Duck under.
  Key idea: own the arm, shoot the moment she fights for it.
- W-T4 "Underhook to the carry" (standard teaching, no match documented): `underhook` "pressures into it" -> Throw-by;
  "reaches for the far arm" -> Knee tap; "stays heavy" -> Russian tie -> `russian_tie` "keeps her head on the far side"
  -> Fireman's carry. Key idea: use her weight, never fight it.
- W-T5 "Score early, hand-fight the lead home" (Hildebrandt 2024, Mensah-Stock 2021): `wrist_control` "pulls her wrist
  back" -> Snatch single, then hand fight only. Needs the missing WHEN "ahead" + sprawl/whizzer to be complete.

---

## 5. Gaps - what we would need to express the real plans (ranked by how many plans need it)

1. **Score / clock WHEN** - last ~30 s of the round, early rounds, ahead/behind on the cards; in wrestling the activity
   clock and "seconds left". Needed by: Leonard-Hagler, Taylor-Ochigava, Lopez-Lomachenko (rd 12), Mensah-Stock,
   Hildebrandt, Snyder, Steveson, Maroulis (8). Matters most for amateur 3-round bouts.
2. **Clinch as a weapon** - lean my weight on her, shove her back, punch-then-hold. Needed by: Ali, Holyfield, Fury,
   Mayweather, Taylor-Cameron II, Joshua (6). Today tie_up is only a survival move.
3. **Split "loadup" by distance** (at range -> close it; in the pocket -> slip/roll). Needed by: Fury-Wilder, Holyfield-
   Tyson, Ali-Foreman vs Pacquiao-Hatton, Mayweather-Canelo (5).
4. **Lateral movement at long/mid** (circle off without retreating to outside; pivot_out exists only off own_ropes).
   Needed by: Leonard, Mayweather, Joshua, Taylor-Serrano plan (4).
5. **Wrestling leg defence + finishes**: whizzer, sprawl, go-behind/spin-behind, push-out/step-out, feint step, and a
   "she shoots from open space" situation (no tie). Needed by: Maroulis, Hildebrandt, Mensah-Stock, Snyder, Steveson,
   USA Wrestling snapdown article (6 wrestling).
6. **Jab variants**: body jab, lead right / straight right lead. Needed by: Inoue, Lopez, Ali rd 1, Mayweather (4).
7. **Counter from long** (counter her lead / pull counter; slip 2-3 exists only at mid). Needed by: Inoue (Fulton's
   leads), Mayweather, Hagler rd 2 (counter the jab) (3).
8. **"Hurt but still dangerous"** variant of hurt. Needed by: Joshua-Ruiz I/II (1, but costly when wrong).
9. **Own cut / stoppage-risk WHEN** (Hagler rd 3) and **voluntary ropes** (Ali) - one plan each; story value more than
   plan value.
10. **Her underhook on us** (limp-arm clear) and **two_on_one "posts on my head"** -> double leg (USA Wrestling 2002/2004).
