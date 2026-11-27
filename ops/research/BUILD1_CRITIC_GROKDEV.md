# BUILD1 critic: Grok Dev (fresh, CODE-CHECKED) - S570
Seat: Grok Dev (its own Linux box; read main at 4ecd137, ran the probe on its own seeds, pushed nothing). Brief:
ops/research/BUILD1_CRITIC_BRIEF_GROKDEV.md. Answer copied from the bot's thread unchanged (seq 265-268, 270); its 10/10 page is
BUILD1_CRITIC_GROKDEV_10.html (rendered: BUILD1_CRITIC_GROKDEV_10.png). Its scratch files stay on its box.

**BUILD1 critic for Puncher's chance (S570):** DEPTH 4, PLAY 4, GENERAL 5, SPEED 6, FIRST FIVE MINUTES 3. The design misses the 8+ bar on both DEPTH and PLAY.

This is read-only on main `4ecd13738fd4fddd625652c04d368e95b795ec2f`: nothing was pushed, committed or edited. Every number the page quotes matches its two result files, and my re-run of the page's out v pres row gives the file's numbers exactly. The problems are in what the page says the code does.

| Score | 1-10 | Why |
|---|---|---|
| DEPTH | **4** | The builds do play differently: plan-mix distance is 1.2 between builds against 0.1 in a mirror, confirmed on 3 of my seeds. But the pools have one right answer: fill Conditioning and Attack to 75 and leave Defence at 50 (69% and 73% against the even spread). Defence buys nothing, one Legs card does nothing, and protecting the part your cards live on is in no run. |
| PLAY | **4** | "The hand is the body, the opponent's punches take your cards away" is a strong, readable idea. But no card is ever taken away in any run, so the fun is unproven. Losing cards as you lose health is a snowball that reads as a chore unless it is capped. |
| GENERAL | **5** | The body map is clear and plugs into existing systems (MoveMastery, the training focus, coach slots). But the page contradicts its probe in 18 places. There are two scales in one file, a Head part with no rules, and three pools with no stated mapping to the game's 14 abilities. |
| SPEED | **6** | The bout beat stays at 3 picks plus "Fight this beat", and grouping by part adds no clicks. The camp screen has 5 parts, up to 8 slots, 3 pools, drills and blends, with no click budget and no way to test a build before locking it. |
| FIRST FIVE MINUTES | **3** | A new player meets 5 parts, slots, 3 pools with hidden caps, drills, blends and hurt parts on top of the bout's own rules. Nothing is staged or pre-built, so 5 minutes gets a player to a confused first camp, not a fought bout. |

**What a screen would be missing, and what each changes:**
- **A spar test against the booked opponent** (wins in 100, with a band). Without it every camp choice is blind.
- **The opponent's build in the file** (which parts they hit, which cards they carry; DESIGN_BUILD1.md:90). This is what decides which part you protect.
- **A protect-this-part action in the bout.** Today a held hand covers lines, not parts, so "which part to protect" doesn't exist as a decision.
- **Pool thresholds on screen:** stamina and spend cap at 75 (build1_probe.mjs:54-55), so points past that are wasted unseen.
- **Use per card from the last bout,** so a dead card gets swapped.
- **Undo, a swap cost, and a coach's suggested body.**
- **A drill's real effect:** 3+ damage also doubles the points, stuns and chips the guard (order.html:259-260).

**Useless today:**
- **The stalking Legs card (pres2):** byte-identical runs with and without it.
- **Defence as a guard bar (v1):** a 50-point dump wins 19%.
- **Conditioning and Attack above 75:** they buy only health and punch weight.
- **The Head part:** no rule and no code.
- **Push off:** no build carries it.
- **Overhand at 50:** chosen in 0-1% of beats.
- **The pressure fighter's plain lead hook in v2:** chosen in 0-2% of beats.

**Contradictions between the page and the code.** Page is `ops/research/DESIGN_BUILD1.md`; probe is `ops/research/s558_balance/build1_probe.mjs`.

1. **Patch count:** page :108 says five and probe :3 says four. The code has seven text patches (probe :35-41): the deck filter, the spend cap, clinch only with a clinch card, the stamina floor, the guard bar, punch weight with defence, and the Legs cards. It also makes three unstated changes:
   - it adds the drilled cards to the option lists (:44);
   - it scales get-up health to the man's health (:56 `kdUp`, used :70), against a fixed 6/4 on the page (order.html:152, :473);
   - it adds a fourth "mirror" opponent (:61).
2. **Two scales in one file:** probe :2 and :49 say "100 = today's man", while probe :50 and page :54 say 75, which is what the code uses (:53-56). The page's "old scaling" (:146) refers to a probe that isn't in the repo.
3. **The stalking Legs card is dead.** Probe :41 only lifts the block on `me.kept`. But order.html:152 has `keep: 0`, :260 sets `kept` only when `a.keep && N.keep`, and no punch in ACT (:156-166) has `keep`. R7 and R8 (with and without the card) are identical on every number. So "did not make pressure press" (page :156) has nothing to do with the design; the card was never live.
4. **Unstated drill move in v2:** probe :30 moves the pressure fighter's drill from the lead hook (`hook_d`, :27) to the body hook (`lbody_d`). Page :131-132 doesn't say so, and that drill becomes the top punch at 27-45% of beats.
5. **A drill is more than "+1 damage"** (page :40). At 3+ damage a punch also scores 2 points instead of 1, stuns, and chips the guard when blocked (order.html:259-260). The drilled body hook (2 to 3, probe :20) crosses that line; the drilled jab and cross don't.
6. **Attack's weight never touches points.** Page :57 says it sets the weight of your punches, but probe :40 scales health only, and points come from raw damage (order.html:260). Over 90% of v1 bouts at 50 v 50 are decided on points.
7. **"Defence takes weight off" (page :131, :150) adds weight at 50.** Probe :56 sets `ab = D/75` and divides damage by it, so at 50 punches land 1.5 times as hard. That, not defence, is why v2 jumps to 42-69% stoppages.
8. **The lead hook is not dead "in every cell"** (page :154 says 0-3%). The v1 file has it at 20% (x_out_pres) and 27% (x_pres_ctr); the v2 file at 13% and 18%. My runs show 20% (R1) and 29% (R14). It is only rare in pressure v pressure.
9. **The overhand reason is wrong** (page :155). Overhand 3 plus a step 1 is 4, which fits the cap (order.html:223, :178). What it rules out is any lead-hand punch beside it, and at Conditioning 50 the whole bar is only 5 (probe :54).
10. **"A deck that is part of another is beaten by it":** page :146 cites "the outboxer's 6 cards v every card won 25%", but no such cell is in either result file. `out` (probe :26) also isn't a subset of `full` (:32), because it holds the drilled jab. My true subsets back it as a tendency: 5 of the 12 cards won 13% (R10) and the two base punches won 0% (R11). As a law it doesn't hold here: each beat is 400 rounds of regret matching (:65), and the look-ahead ignores the cards. Even in theory the law gives "never better", not "beaten".
11. **The look-ahead claim is true but understated** (page :110). The table is indexed by beats left, range, stamina and ground only (order.html:286, :288). balance.mjs:36 and :51-56 build it from two 18-health, bar-8, guard-6, full-deck men with no spend cap. So every cell uses it as an approximation, the 50-50 mirrors included, not just unequal builds.
12. **Get-up health is already scaled, by the wrong pool:** the page's round 3 gives it to Defence (:163-164), but the probe already scales it with Conditioning (:56), unstated.
13. **The caps at 75 are missing from the page** (:56-57 against probe :54-55). The where-to-put-50 test (:129, :141) pushes one pool to 100, past the cap, so "spreading beats choosing" is partly the cap. My 75:75:50 split beats the even spread 69% and 73% (136 of 192 bouts, [64-77%]).
14. **Sample size:** n=36 on one seed gives about ±16 points; 18 of 36 is [34-66%]. The comeback drop that rejected the owner's link (page :100, :157) is 5/20 against 2/18, with overlapping bands, decided by 3 bouts. The pressure mirror reads 39/50 on seed 1 and 51/35 on my seed 13.
15. **"Attack 56%" doesn't hold:** my seed 13 at n=96 gives Conditioning 41, Attack 46, Defence 19, against the page's 33/56/19 (:129).
16. **Small misquotes:**
    - "clinch 9%" (:105) is an unstated average of 13% and 6%.
    - "42 to 69%" (:150) covers the v2 mirrors only; the v2 cross matches are 25-36%.
    - "The loop agrees with the page's own bars" (:115) cites no bar file.
17. **The page's main ideas aren't in the probe:**
    - the combination table (:64-78);
    - flows (:76-78);
    - hurt parts that take cards away (:48-50, :170);
    - the slot limits of 3 a part and 8 a body (:94-95);
    - Head passives (:35);
    - coach slots (:42).

    The probe is a flat card list plus three numbers.
18. **The style cycle (:172) is an order today:** generalist, then outboxer, then pressure.
    - Pressure loses to everything: 36-39% v the generalist, 36-47% v the outboxer, 24% v my body-shot build.
    - The outboxer loses to the generalist: 28% on the page, 40% in my run.

The page also uses he/his/him on 9 lines, and the probe and order.html say "his" in player-facing text.

**My runs** (Node v24.22.1, from the repo root). Build = deck:conditioning:attack:defence. W/L/D is man A's wins/losses/draws. KD is knockdowns a bout, by A v by B. dist is the plan-mix distance.

`SCRATCH` is `/workspace/build1critic/scratch/probe_x.mjs`: the repo probe byte for byte, plus an absolute rules path and four extra decks:
- `pres2ns` = pres2 without its Legs card;
- `sub5` = jab, cross, lead hook, body jab, body cross;
- `base` = jab, cross;
- `body3` = jab, cross, drilled body hook, body jab, body cross.

R7 reproduces the repo's v2 pressure mirror exactly.

| Run | Command | W/L/D | stop | KD | dist | came back |
|---|---|---|---|---|---|---|
| R1 | `node ops/research/s558_balance/build1_probe.mjs a=out:50:50:50 b=pres:50:50:50 n=24 seed=7` | 58/42/0 | 0% | 0.4 v 0.1 | 1.20 | 2 of 14 |
| R2 | `node ops/research/s558_balance/build1_probe.mjs a=pres2:50:50:50 b=gen2:50:50:50 n=24 seed=7 def=2` | 54/42/4 | 50% | 1.2 v 1.5 | 0.97 | 0 of 18 |
| R3 | `... a=out:50:50:50 b=pres:50:50:50 n=36 seed=1` | 53/47/0 | 0% | 0.5 v 0.3 | 1.25 | 3 of 20 |
| R4 | `... a=out:50:50:50 b=pres:50:50:50 n=96 seed=13 jobs=2` | 55/43/2 | 0% | 0.4 v 0.2 | 1.22 | 11 of 59 |
| R5 | `... same, seed=29` | 57/36/6 | 0% | 0.3 v 0.1 | 1.22 | 12 of 60 |
| R6 | `... same, seed=71` | 50/45/5 | 0% | 0.3 v 0.1 | 1.24 | 16 of 62 |
| R7 | `node SCRATCH a=pres2:50:50:50 b=pres2:50:50:50 n=36 seed=1 def=2` | 36/56/8 | 67% | 1.8 v 2.1 | 0.12 | 5 of 12 |
| R8 | `node SCRATCH a=pres2ns:50:50:50 b=pres2ns:50:50:50 n=36 seed=1 def=2` | 36/56/8 | 67% | 1.8 v 2.1 | 0.12 | 5 of 12 |
| R9 | `node SCRATCH a=out2:50:50:50 b=pres2ns:50:50:50 n=36 seed=1 def=2` | 64/31/6 | 36% | 1.9 v 0.8 | 1.11 | 3 of 25 |
| R10 | `node SCRATCH a=sub5:75:75:75 b=full:75:75:75 n=48 seed=5 jobs=3` | 13/75/13 | 17% | 0.5 v 1.4 | 0.68 | 8 of 33 |
| R11 | `node SCRATCH a=base:75:75:75 b=full:75:75:75 n=48 seed=5 jobs=3` | 0/100/0 | 60% | 0.0 v 2.5 | 1.37 | 0 of 45 |
| R12 | `... a=pres:50:50:50 b=pres:50:50:50 n=96 seed=13 jobs=2` | 51/35/14 | 0% | 0.2 v 0.2 | 0.12 | 7 of 45 |
| R13 | `... a=out:50:50:50 b=ctr:50:50:50 n=96 seed=13 jobs=2` | 40/54/6 | 10% | 0.8 v 1.1 | 0.66 | 17 of 65 |
| R14 | `... a=pres:50:50:50 b=ctr:50:50:50 n=96 seed=13 jobs=2` | 39/52/9 | 0% | 0.2 v 0.4 | 1.27 | 6 of 58 |
| R15 | `... a=pres:75:75:50 b=pres:67:67:67 n=96 seed=13 jobs=2` | 69/23/8 | 2% | 0.9 v 0.1 | 0.24 | 7 of 50 |
| R16 | `... same, seed=29` | 73/21/6 | 3% | 1.0 v 0.1 | 0.25 | 4 of 46 |
| R17 | `... a=pres:100:50:50 b=pres:67:67:67 n=96 seed=13 jobs=2` | 41/48/11 | 0% | 0.0 v 0.0 | 0.32 | 5 of 25 |
| R18 | `... a=pres:50:100:50 b=pres:67:67:67 n=96 seed=13 jobs=2` | 46/46/8 | 6% | 0.7 v 0.8 | 0.29 | 9 of 48 |
| R19 | `... a=pres:50:50:100 b=pres:67:67:67 n=96 seed=13 jobs=2` | 19/75/6 | 0% | 0.0 v 0.8 | 0.43 | 8 of 55 |
| R20 | `... a=pres2:75:75:50 b=pres2:67:67:67 n=96 seed=13 jobs=2 def=2` | 48/41/11 | 34% | 1.4 v 1.4 | 0.25 | 11 of 48 |
| R21 | `... a=pres2:100:50:50 b=pres2:67:67:67 n=96 seed=13 jobs=2 def=2` | 16/79/5 | 5% | 0.1 v 0.9 | 0.40 | 1 of 59 |
| R22 | `... a=pres2:50:100:50 b=pres2:67:67:67 n=96 seed=13 jobs=2 def=2` | 21/75/4 | 78% | 1.0 v 2.5 | 0.18 | 9 of 41 |
| R23 | `... a=pres2:50:50:100 b=pres2:67:67:67 n=96 seed=13 jobs=2 def=2` | 18/72/10 | 2% | 0.2 v 0.9 | 0.28 | 6 of 49 |
| R24 | `... a=out:50:50:50 b=out:50:50:50 n=36 seed=1 def=2` | 47/53/0 | 86% | 1.9 v 2.0 | 0.09 | 1 of 25 |
| R25 | `node SCRATCH a=body3:50:50:50 b=ctr:50:50:50 n=72 seed=13 jobs=2` | 42/51/7 | 11% | 0.8 v 1.1 | 0.83 | 5 of 49 |
| R26 | `node SCRATCH a=body3:50:50:50 b=out:50:50:50 n=72 seed=13 jobs=2` | 39/47/14 | 4% | 0.8 v 0.9 | 0.42 | 9 of 47 |
| R27 | `node SCRATCH a=body3:50:50:50 b=pres:50:50:50 n=72 seed=13 jobs=2` | 71/24/6 | 3% | 0.6 v 0.1 | 1.01 | 7 of 44 |

`...` stands for `node ops/research/s558_balance/build1_probe.mjs`.

What the runs show:
- **R4-R6 (my own seeds):** the outboxer beats the pressure fighter in 156 of 288 bouts, 54% [48-60]. That is barely an edge, but the distance holds at 1.22-1.24, so "the builds play differently" stands.
- **R15-R19 (my exploit):** under v1, filling C and A to 75 is the one right camp plan.
- **R20-R23 (the same under def=2):** every dump loses, so the rule flips to "spread evenly". It's still one answer.
- **R25-R27 (my body-shot build, never tried by the page):** it beats the pressure fighter 71/24, so it is a better pressure fighter than the page's own.

**To reach 10/10**, most important first.

**DEPTH (4 to 10)**
1. **Every pool point buys something up to 100.** Remove the 75 caps (probe :54-55), or turn them into shown thresholds: for example Attack 60 opens a second punch and 75 the big punches.
   - Pass line: sweep all 21 splits of the 50 spare points, 200 bouts each on 3 seeds. No split may win over 60%, and each pool's best split must win at least 40%. Today 75:75:50 wins 71%.
2. **Give Defence its own job.** Move get-up health to Defence, off Conditioning (:56), and use `ab = max(1, D/75)` so defence never makes punches heavier. Pass line: a 50-point Defence dump wins 35-65% (19% today).
3. **Build and measure the hurt part first.**
   - The rule: each landed body shot greys one Core card for the round, at most 1 a part a round, back at the bell.
   - The test: protect the Core (rear hand low while a Core card is mounted) against not protecting it.
   - Pass line: 8+ points of win share between the two, with comebacks at 20% or more.
4. **Fix the dead and hidden cards.** Give the stalking card a live rule ("your step in beats a back off even on the ropes", or `N.keep` for this card only), or cut it. Show the 3+ damage bonus on the card.
   - Pass line: every discipline card appears in 5%+ of its own build's beats in every cell.
5. **A real style cycle:** every cross-match at 40-60%, or a true loop of outboxer > pressure > generalist > outboxer at 55-65% each.
6. **A look-ahead per build:** rebuild vtable.json for each pair of builds being compared (deck, spend cap, bar size), or report each cell's exploitability.
7. **n of 200 or more on 3 seeds, with 95% bands,** before any card or pool is called dead, dominant or a comeback killer. That includes re-running the owner's health-to-stamina link.

**PLAY (4 to 10)**
1. **Put the hurt part on the playable page (order.html).** Show a greyed card with its reason ("Core hurt: 2 body shots - no clinch this round") and run 3 owner playtests.
2. **Cap the snowball:** a part loses at most 1 card a round, and everything is back at the bell. Pass line: comebacks from 15% behind of 20% or more at n=200.
3. **Pay off the camp in the bout:** after every round, a line like "your drilled body hook won 4 of your 9 points".
4. **Blends as a reward:** owning both halves (feint + cross, body hook + lead hook) adds the joined card to the hand with its own cost.
5. **One signature card per style** that no other build can mount.

**GENERAL (5 to 10)**
1. **Fix the 18 contradictions:** one scale (75 = today's man), the real list of probe patches, and the corrected hook and overhand lines.
2. **Map the three pools onto the 14 abilities,** or say they replace them for the card fight:
   - Conditioning = Stamina, Recovery, Durability;
   - Attack = Strength, Explosiveness, Speed;
   - Defence = Defence, Footwork, Composure.
3. **Define the Head part** in numbers, or cut it.
4. **Write the camp costs in game units:** a slot costs N camp weeks, drill levels are MoveMastery Usable 30 and Sharp 60, and the coach slot comes from a pad rating of 70+.
5. **Cut push off,** or give a build a reason to carry it.
6. **No he/she in the page or on screen:** say "the opponent".

**SPEED (6 to 10)**
1. **Bout:** at most 3 picks a beat plus Fight, with greyed cards needing no click, and 4 seconds or less of play-out a beat (18 beats in 3 minutes or less).
2. **Camp:** 6 clicks or fewer for a whole camp: focus, drop, drill, spar test, lock. "Coach's body" fills everything in one click.
3. **Spar test in 2 seconds or less,** from 50 quick bouts or a stored table, shown with its band.
4. **Keys:** 1-5 pick a part, the arrows pick a card, Space fights (Space already fights, order.html:503).

**FIRST FIVE MINUTES (3 to 10)**
1. **Stage the body:** bout 1 has base cards plus 1 discipline slot and one pool to raise. Legs open at bout 2, Core at bout 3, and Head at the pro debut.
2. **The coach builds the first body.** The player's first act is one swap with a spar test, about 60 seconds.
3. **Every grey, locked or capped thing says why** in one line on the card.
4. **Pass line:** 4 of 5 new players build a body and finish a bout inside 5 minutes without help.

**My 10/10, drawn** (also attached above as `build1_10of10.html`). The camp screen builds the body from 5 parts and their slots, with a body budget of 8, the blends this body owns, and the three pools with their thresholds shown. A spar test against the booked opponent sits beside Coach's body and Lock the camp. Below it is the bout hand grouped by part, with the Core card greyed after 2 body shots and the reason on the card. The fighter stands alone in a frame, and the only name is in the header.
