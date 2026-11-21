# GUARDDMG1_V1 critic: blocking, guard wear and the broken guard

**DEPTH 6, GENERAL DESIGN 5, PLAY 6, so it's not designed yet.** It misses the 7+ bar on both depth and general design. The idea is right and true to boxing: when you cover up, your arms take the punch and some damage still gets through, and when you move, your legs and energy pay instead. A guard that breaks in round 7 is a great moment. With the draft numbers, though, four things go wrong:
- covering always wins in amateur bouts;
- every pro boxer who covers has a broken guard by round 2 or 3;
- "Go to the arms" does nothing in a 3-round bout;
- two of the rules contradict each other.

Tags: SOURCED means from a source I opened this pass, DERIVED means my own sums, CHECK means from memory or unconfirmed, and NOT FOUND means no real number exists.

**DEPTH 6.** Both defences have a price, and the price shifts as the bout goes on. The mechanic ties into training, the opponent's file, the corner calls and the plan. Against that, covering wins outright until the guard is worn, and at normal amateur punch counts the guard never wears in 3 rounds. The puncher gets no real choice either: "Go to the arms" takes two rounds to pay off, and blocked punches never score.

**GENERAL DESIGN 5.**
- Rule 4 says one blocked punch in three "counts as landed", but rule 5 says a block "never scores". Which one wins?
- The pace is wrong for pros. A pro who covers breaks around round 3 (DERIVED), but real shell defenders cover for twelve rounds.
- GLOVES can't be a choice: England Boxing fixes glove weight by bodyweight, and the game has no gear system.
- "Move your head" and "step off" have the same price, so one of them is useless.
- The map says "his guard" twice, which breaks the rule against a fixed he or she.
- None of the share or wear numbers has a source.

**PLAY 6.** A guard bar that cracks over the rounds builds tension, and the "on the guard" count makes a covering style readable. But in amateur bouts the guard almost never breaks, while in pro bouts it breaks too early to feel earned. Blocking also gives nothing back, so covering feels passive.

## The dominant pick, in numbers (DERIVED)
I assumed a punch mix of 45% jabs (the CompuBox pro share, about 44%), 50% power punches and 5% big shots (my assumption).
- **Damage per punch:** a landed punch does 1.90 damage on average and a blocked one lets through 0.355, which is 19% of a landed punch.
- **Guard wear:** each blocked punch takes 2.2 off the guard.
- **When moving is worth it:** slipping beats covering only if it works more than 81% of the time. That falls to 63% at 50 guard and 33% once the guard is broken.
- **Share blocked:** how many punches are blocked rather than missed is NOT FOUND, so I assumed 35%, or 45% for a boxer who covers on purpose.

| Case | Punches a round | Guard by round, 35% blocked | Guard by round, 45% blocked |
|---|---|---|---|
| Olympic, low count (under 56 kg, 2012) | 36 | 72, 60, 47: never breaks | 64, 44, 23: never breaks |
| Olympic, high count (2015) | about 65 | breaks in round 2 | breaks in round 2 |
| Pro average (CompuBox) | about 53 | 59, 33, breaks in round 3 | breaks in round 2 |

So in an amateur bout against normal output, covering always wins. Against high output, the guard breaks before "Go to the arms" could matter. In pro bouts, every boxer who covers breaks by round 3, while real male pro stoppages come at round 2.59 on average and are mostly mismatches (Karimi & Bickart 2025).

## Options

| Option | Verdict | What it changes |
|---|---|---|
| Cover up | Keep, add a price | Also cuts your boxer's own output; Title Bout's text sim says "offense will be greatly affected" |
| Move your head | Keep | Costs energy and fails more often when tired |
| Step off | Keep only with its own cost | Costs legs and ground, so it pushes your boxer toward the ropes |
| Hands up (CHECK) | Keep | More guard back, fewer punches out |
| Move, don't cover | Keep | Switches the defence for one round |
| Go to the arms | Pro only | In pro bouts the guard breaks in rounds 6–9; in 3 rounds it's useless |
| Shoulder endurance | Merge with guard endurance | One stat, one name |
| Defence skill | Keep | Raises the chance a slip works |
| Heavy-bag power | Keep | More damage through the guard |
| File reads | Keep | Tell the player which defence to plan |
| GLOVES | Useless | Weight is fixed at 10 oz up to 65 kg and 12 oz above. Bigger gloves barely change force: 2,090 N in 10 oz against 1,900 N in 16 oz, not significant (Nakano) |
| **Missing: Catch and counter** | Add | A block opens a short counter chance, as in Fight Night Champion and Punch-Out!! |
| **Missing: Body first** | Add | Brings the arms down so the head opens next round (CHECK) |
| **Missing: Clinch and reset** | Add | Stops the leak for a few seconds and risks a warning |
| **Missing: The referee's look** | Add | A boxer who is "outclassed" gets stopped under England Boxing rule 10.3.2. That's the real reason covering styles get stopped |
| **Missing: Cover and answer 2** | Add | A covering plan that punches back: it saves less damage but keeps the referee calm |

## The four open questions
1. **How much damage gets through the guard? NOT FOUND.** No study measures force through a glove and forearm. The closest numbers:
   - a landed Olympic straight averages 3,427 N and moves the head at 58 g (Walilko 2005);
   - glove padding cuts head acceleration by 72–93% in drop tests (McIntosh & Patton 2015).

   Keep 10/20/30% as tuning numbers, and let the share depend on the angle: a straight drives the gloves into the face, while a hook lands mostly on the arm.
2. **Should a blocked punch tire the puncher more? Yes, a little.** In Undisputed's patch 1.3.3 (2025), a blocked punch costs more stamina than a landed one and less than a miss. In Punch-Out!! (Wii), the player loses 1 heart per blocked punch and 3 per hit. Real physiology is NOT FOUND.
3. **Does the guard come back within a round? Yes, both during the round and in the corner.** Every game I checked refills it during play: Fight Night Champion's block strength and Undisputed's Block Regen both do. A real recovery rate is NOT FOUND.
4. **Is there time for a guard to break in 3 rounds? Barely, and it shouldn't end bouts.** Amateur stoppages ran at 2.2% of bouts at the 2017 Worlds and 7.2% in 2021 (IBA). Make "worn" the amateur effect and "broken" the pro one.

## Research table

| Rule | (P) | Evidence | Source |
|---|---|---|---|
| Damage 1 / 2.5 / 4 | 1 : 2.5 : 4 | Force runs jab 0.65 : cross 1 : hook 1.04 (jab 1,645 N, cross 2,425, hooks 2,524–2,624). Raise the jab to about 1.5 (DERIVED) | [Finlay, PLOS ONE 2023](https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0289791); [Smith, JSSM 2006](https://pmc.ncbi.nlm.nih.gov/articles/PMC3863921/) |
| Landed straight | n/a | 3,427 N (range 1,990–4,741), 58 g | [Walilko et al., BJSM 2005](https://bjsm.bmj.com/content/39/10/710) |
| Share through 10/20/30% | 10/20/30 | NOT FOUND. Keep as tuning numbers, maybe 5% for the jab | closest: [McIntosh & Patton, BJSM 2015](https://bjsm.bmj.com/content/49/17/1113) |
| Glove size | n/a | 10 oz 2,090 N, 16 oz 1,900 N (−9%, not significant) | [Nakano et al., ISBS (year CHECK)](https://ojs.ub.uni-konstanz.de/cpa/article/download/3427/3226) |
| Amateur gloves | n/a | 10 oz up to 65 kg, 12 oz above | [England Boxing Rules 2026, rule 8.2](https://www.englandboxing.org/wp-content/uploads/2026/01/2026-Rule-Book-Final-01-26.pdf) |
| Guard wear 1/3/5 | 1/3/5 | NOT FOUND. Too fast; start at 0.5 / 1.5 / 2.5 (DERIVED) | my sums |
| Corner refill | 15 | NOT FOUND. Use 20 in the corner plus about 10 a round while not being hit (DERIVED) | [Undisputed stats](https://playundisputed.com/news/fighter-stats-explained) |
| Worn at 50 | step | NOT FOUND. Use a slope: ×1 at 70 guard up to ×2 at 20 | design |
| Broken under 20 | 50%, 1 in 3 | NOT FOUND. Keep, and say that 1 in 3 scores and does full damage | design |
| Blocks never score | yes | Confirmed: a blow scores only "without being blocked or guarded" | IBA rule 11.1.1; [IBA R&J 2022](https://www.iba.sport/wp-content/uploads/2022/01/20220121-Course_Presentation_AIBA_RJ_3_Star_CPD_Refresherv1.2-1.pdf); [ABC](https://www.abcboxing.com/ring-officials-certification-program/) |
| Puncher's cost | n/a | Landed costs less than blocked, which costs less than missed. Bag work uses 13% more oxygen than shadow boxing | [Undisputed 1.3.3, 2025](https://playundisputed.com/news/undisputed-update133patchnotes); [Kasetsart 2020](https://kuojs.lib.ku.ac.th/index.php/jstku/article/view/3913) |
| Blocker's arms | n/a | NOT FOUND as a rate. Forearm ("nightstick") fractures from blocking are rare | [JOCR 2021](https://jocr.co.in/wp/2021/07/bilateral-traumatic-nightstick-fracture-of-the-ulna-a-rare-case-report-and-review-of-the-literature/) |
| Amateur punch counts | n/a | 61 / 71 / 64 a round; winners under 56 kg about 36 | [Davis, IJSPP 2015](https://pubmed.ncbi.nlm.nih.gov/24912199/); [Davis, JSCR 2018](https://pubmed.ncbi.nlm.nih.gov/30480653/) |
| Blocked vs missed | n/a | NOT FOUND. CompuBox counts blocked punches as misses | [Boxing Bulletin 2009](http://theboxingbulletin.blogspot.com/2009/03/unlocking-compubox.html) |
| How often guards break | n/a | NOT FOUND directly. Amateur stoppages: 19.0% (2007, old rules), 2.2% (2017), 7.2% (2021). Pro men: 47% stopped, at round 2.59 on average | IBA statistics [2017](https://www.iba.sport/wp-content/uploads/2017/07/ROOT-C84.pdf) and [2021](https://www.iba.sport/wp-content/uploads/2021/11/C84.pdf); [Karimi & Bickart, Neurology 2025](https://www.neurology.org/doi/10.1212/WNL.0000000000212434) |
| Referee stop | n/a | The bout is stopped if a boxer is "being outclassed or is receiving excessive punishment" | England Boxing rule 10.3.2 |

## How the games turn a block into numbers
- **Fight Night Champion (2011):** block strength weakens the longer the guard is held and as it absorbs punches. A well-timed block opens a brief counter chance. Exact numbers: NOT FOUND.
- **Undisputed (2024–25):** block health, a Guarding stat and a Block Regen stat. Holding the guard drains it faster, and a blocked punch costs more stamina than a landed one and less than a miss. Exact numbers: NOT FOUND.
- **The Thrill of the Fight (VR):** any contact with the arm stops the punch. Patch 0.4.1 adds partial "soft blocks". There's no guard meter.
- **Punch-Out!! (Wii):** you lose 1 heart per blocked punch and 3 per hit, and you can't punch at zero hearts.
- **Title Bout Championship Boxing 2 (text sim):** "Cover Up" makes the boxer hard to hit cleanly, but their own punching nearly stops. There's no guard meter.

## To reach 10/10
1. **Settle the rule clash:** a punch through a broken guard lands, scores and does full damage, and every other blocked punch never scores.
2. **Re-pace the guard:** wear of 0.5 / 1.5 / 2.5, refill of about 10 a round while not being hit, and 20 in the corner. Test targets: a pro who covers against average output never breaks in 12 rounds; against "Go to the arms" at 60 punches a round the guard breaks in rounds 6–9; an amateur guard never breaks. My sums say never, round 7 and never (DERIVED). This needs the game's balance tests, which I can't run while Beast is offline.
3. **Give covering a price:** cut your boxer's output by about 30% while covering (ESTIMATE), and let the referee's look build when your boxer takes punches without answering. The goal is for covering to be right against a light hitter and wrong against heavy hands by round 3.
4. **Make blocking active:** a blocked power punch opens a counter chance scaled by defence skill, and the puncher's energy cost sits between a landed punch and a miss.
5. **Change the corner calls:** make "Go to the arms" pro only, and add "Body first" and "Clinch and reset".
6. **Use a slope instead of a step** for the worn guard.
7. **Give "step off" a different cost:** it costs ground, so it means rope risk.
8. **Cut GLOVES.**
9. **Merge shoulder endurance and guard endurance.** Wire "Gloves high" and "Elbows in" (CHECK) to the head and body leaks.
10. **Change "his guard" to "the opponent's guard".**
11. **Label every share number** as tuning, not evidence.

## The 10/10 page (1920×1080, Look B)
It shows a pro bout, round 7 at 1:13, with names only in the header.
- **Left:** your boxer's six bars. The guard bar is cracked and grey at 18, with a red BROKEN tag, and the guard by round reads 100, 96, 88, 74, 59, 41, 18.
- **Centre:** a red slash reads GUARD BROKEN, above a coach's note: "The arms are gone. The opponent has gone to the arms since round 4: 112 on the guard. Clinch, then move till the bell." Next to it, the landed counts read Head 41, Body 23, On the guard 112 (31 got through).
- **Right:** four corner calls, each with its price. Clinch and reset is the one pulsing gold button: "Stops the leak for 6 s · guard +4 · warning risk 1 in 8". The others are Move, don't cover, Hands up and Fire back.
- **Bottom:** the referee's look gauge, "Next big shot on the guard: hurt 1 in 6", and a "Why?" link.

The rendered page and its HTML file are below.