# DESIGN_LIVERRIBS1_CRITIC_JOHN_JOHN - John answer (seat queue SQ78)

Brief: research/DESIGN_LIVERRIBS1_CRITIC_JOHN.md
Sent: 2026-11-13 22:10 | collected: 2026-11-13 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading the LIVERRIBS1 map against the pack now. The full critic return comes next.

# LIVERRIBS1 v1 (S460): critic

Scores: depth **5/10**, general design **5/10**, play **6/10**. That misses the owner's bar on both depth and general design. I couldn't open `CRITIC_ACCESS.md` or the board, because your computer is offline, so I judged from the map and the pack.

## Logic check

**The code puts the liver on the wrong side for a southpaw.** The map reads `BodyMap.gd:76-83` as the right side when orthodox and the left side when southpaw. The liver sits on the right side of every body; stance only decides whether that side is the lead or the rear. The map's own line ("against a southpaw where it is the lead side") is anatomically right and contradicts the code. Fix the code first, or every southpaw bout aims at an organ that isn't there.

**The side is set by the hand that throws, not by a free Aim.** A hook from the attacker's left hand lands on the defender's right side (the liver). A right-hand hook lands on the left side (ribs and spleen).
- Every body punch in the book is `body_hook` (3b, the lead hook). For an orthodox attacker that's the left hand, so it can only reach the liver.
- Rule 4 already says "a counter's left-hand body hook" goes to the liver, which is right, but Aim Ribs then needs a punch the game doesn't have: a rear body hook or a right to the body.
- Real boxing bears this out. The orthodox boxer's left hook to the liver is the classic body shot, and in a southpaw against orthodox fight, the southpaw's rear left to the liver is a staple.
- Without a rear-hand body move, "Aim Ribs" is a label with no punch behind it.

**Liver beats ribs for tonight in every matchup the map lists.** The map's own cover figures are 60 in 100 on the liver and 30 on the ribs. Neither figure is in the pack or in the "Today" code list, so both need a source in the code.
- Per body hook thrown, the liver lands 0.4 × 1.3 = 0.52 of drain, against 0.7 × 0.55 = 0.385 for the ribs. The liver does 35% more, plus the fold chance.
- Against a southpaw the liver is the lead side, so it's covered less and the liver wins by more.
- So for tonight, ribs are never right, and the only reason to pick them is weeks out.

**Rule 8 makes a crack almost certain, and that dwarfs rule 5.** "Cracked rib if the non-liver side is at CRITICAL after the bout" is deterministic. Today that same state only triples a weight-10 roll inside a 6% bout-injury chance.
- Any bout where the rib side reaches CRITICAL now costs 35–56 days for sure, so the 4% crack per hook during the bout barely matters by comparison.
- The map gives no figure for how often a rib side reaches CRITICAL in a 3 × 3 amateur bout. Without it, the injury rate across a season could jump several times over.

**Rules 8 and 9 contradict each other.** Rule 8 gives bruised ribs if "any rib is at HURT", and the liver side is a rib place. Rule 9 says the liver is never a weeks-out injury. "Under 50" and "at HURT" (under 55) also overlap, so "under 50" does nothing.

**Pulling out costs more than its 35 days.** A retirement is a stoppage loss under rules the game already has:
- the 30-day suspension
- offers 8 weeks later than usual (`STOP_REST_WEEKS`)
- −2 members, −4 reputation and −12 morale

So the next bout is about 8 weeks away either way, and the real gap between the two answers is about 4 weeks (56 days against 84) traded for a win chance the card doesn't print. "Fight on" also carries no added risk beyond the ×1.5, which is what a real corner fears most.

**The opponent's crack has no corner rule.** The map doesn't say whether the opponent's corner ever pulls her out, or at what odds. If it never does, a crack on the opponent becomes a free edge for the player.

**Defence by side is promised but has no rule.** "Cover up" isn't one of the eight calls. There's "Hands up move your head" and "Tie up", and no rule number covers a liver or rib cover. The corner minute's Elbows in and Gloves high already move body punches, and the pack says they were "measured not to change who wins". With liver knockdowns they will, so they need measuring again.

**Things it uses that don't exist yet:**
- A "legs bar" (rule 3) isn't in the pack.
- "Her body stat" (rule 1) isn't named.
- Rule 2 uses "his power", and Power is a summary stat since S448. It should use the punch's own power from Strength, Explosiveness and the move's mastery.
- Reading a rival's injury on the ladder needs NPC injuries, which aren't established. An injured rival also keeps her rank, so the payoff is small anyway.

**The amateur rules are left unsaid.** The map doesn't say whether a body knockdown counts toward the RSC limit of 3 counts a round and 4 a bout. In amateur boxing most stoppages come by RSC after counts, not by a count-out, so a 35% count-out share fits pro fights better than amateur ones.

**The writing breaks S412.** The defender is always "her" and the attacker "his", and the card's button says "PULL HER OUT". Both need the fighter's own pronoun, or "your boxer" and "the opponent". There are no names outside headers.

**The real-world basis mostly holds.**
- The NHS says broken or bruised ribs usually heal by themselves within 2 to 6 weeks ([NHS: broken or bruised ribs](https://www.nhs.uk/conditions/broken-or-bruised-ribs/), read 2026-11-13). The map's 35–56 days for a crack (the TO SOURCE value) is a fair return-to-sparring figure on top of that.
- A delayed liver fold and a count-out are what Hopkins against De La Hoya (2004) looked like: a left hook to the liver, a beat late, counted out on one knee.
- The map has no sourced rate for body knockdowns. I found none either, so treat that as NOT FOUND.

## Depth: 5/10

**The real decisions:**
- The crack card is a real call. It trades about 4 extra weeks out for a win chance, it's touched by morale, Heart and trust, and it ties into suspension and offer timing.
- The liver fold gives the Aim a payoff on the night, and Durability now does two jobs.

**Where it breaks:**
- Liver beats ribs for tonight in every matchup, so the Aim comes down to one question: do I care about this opponent's next two months?
- The rival payoff needs a living world that isn't established.
- The side cover is undefined.
- The crack card fires rarely: you need 4% per hook, only once a rib is at CRITICAL, only on your own fighter.
- Training and booking hooks ("hunts the liver") are listed but given no numbers.

## General design: 5/10

What it gets right:
- It's clear about what the code does today.
- Rule 1 is drain-neutral at 60/40.
- The menu table wires each label to a rule.
- The build is small and pure.

What pulls it down:
1. The liver is on the wrong side for a southpaw.
2. Side is set by hand, and the game has no rear body punch.
3. Rule 8 makes a crack certain at CRITICAL.
4. Rules 8 and 9 contradict each other.
5. The pull-out price is hidden.
6. The opponent's corner, the side cover, the legs bar and the body stat are undefined.
7. It uses the Power summary stat.
8. It writes a fixed her and his.
9. It sets no probe targets. The Test column names rows but gives no figures to pass.

## Play: 6/10

A delayed fold to the liver is one of boxing's great moments, and "Her liver is hurt" in the corner read gives a round something to build toward. The crack card is a strong rare beat. But the ribs give the player nothing to feel tonight, and most players will rarely see the card.

## The two open questions

**Is "weeks out" enough reason to aim the ribs?** No. Give the ribs a payoff on the night. A boxer hurt on one side drops that elbow, which opens the head on that side (the old line "kill the body and the head will follow"). At HURT, the opponent's guard on that side drops by 5 and her punches from that side by ×0.85. That makes "ribs, then the head" a plan line, and it connects to the head knockdowns already in the game.

**Is 3–8% per hurt hook the right size?** That depends on how many liver hooks land in a hurt round, which the map doesn't measure. The chance of a fold in a hurt round is \(1-(1-p)^n\):

| Landed liver hooks in a hurt round | At 3% | At 8% | At 6% (3% ×2 at CRITICAL) |
|---|---|---|---|
| 3 | 9% | 22% | 17% |
| 5 | 14% | 34% | 27% |

If "two or three liver-hurt rounds should end in a body count" means about 1 in 3 hurt rounds, the 3% base is too low unless 5 or more hooks land. The fix is to tune \(p\) to a measured target, not to pick it by hand.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Aim Liver | ×1.3 drain, and the fold once the liver is HURT | Keep. It's left-hand hooks only. |
| Aim Ribs | ×0.55 drain, the crack chance, weeks out | Keep, once there's a rear body punch and a tonight effect. |
| Cover a side (shout) | Promised, with no rule | Missing as written. Make it Elbows in by side. |
| Pull out (card) | A stoppage loss, 35 days plus the offer delay | Keep, with the full price on the card. |
| Fight on (card) | 84 days, ×0.6 and −10 for the rest of the bout | Keep, with a win figure and a worse-crack risk. |
| Opponent's crack corner read | Information only | Keep, and add an opponent-corner rule. |
| Camp body sparring | Bruised ribs from load | Keep, and price it. |
| Scout lines ("hunts the liver") | Information | Keep, once the forecast reads them. |

**Missing:**
- A rear body hook and a right to the body as moves with mastery.
- Defence by side.
- The opponent's corner retiring a boxer with a crack.
- The amateur count rule for body knockdowns.
- An injury rate per 100 bouts to test against.

## To reach 10/10 (most important first)

1. **Fix the anatomy.** The liver is always the defender's right side. `BodyMap` picks the side from the attacker's hand: left-hand hooks reach the liver, right-hand hooks reach the left ribs. The defender's stance only sets cover: lead side 30, rear side 60 (both figures sourced in code or probed).
2. **Add rear-hand body punches.** "Rear body hook" (4b) and "Right to the body" (2b) as moves with mastery and drill cards, plus the book combinations 1-2b-3, 2b-3 and 3b-4b. The Aim then means "favour this hand to the body", so Aim Ribs costs rear-hand energy and reach, which is a fair trade.
3. **Give the ribs a payoff tonight.** At HURT on the rib side, the opponent's guard on that side drops by 5 and her punches from that side by ×0.85. A plan line "when her side is hurt, then the head on that side" is rated Beats it. A crack works as now.
4. **Make the injury rule a roll, then probe it.**
   - CRITICAL at the bell rolls a crack at 25 in 100 (TUNE), not 100.
   - Bruised ribs come from the rib side under 50 only. The liver side is never a weeks-out injury (rule 9 wins).
   - Probe on 400 bouts a cell, with targets: rib injuries at 2–4 per 100 bouts (today about 6% bout injury × the rib share), cracks at most 1 per 100, and body knockdowns at 10–20% of all knockdowns (ESTIMATE, to be set by the owner).
5. **Print the full price on the crack card.**
   - Pull out: "a stoppage loss, back sparring in 35 days, next bout in about 8 weeks, −4 reputation".
   - Fight on: "a win chance of N in 100 from `BoutRead` with the crack, back in 84 days, 1 in 10 worse (another 28 days)".
   - A high-Heart boxer loses 3 morale if pulled; a trust cost applies only when fighting on ends in a stoppage.
   - Write it with the fighter's own pronoun, or "Pull your boxer out".
6. **Add an opponent-corner rule.** The opponent's corner retires a cracked boxer 40 in 100 at each bell, higher when she's losing on the cards. The corner read shows "her corner is talking about stopping it".
7. **Defence by side.** The corner minute's ONE CHANGE gets "Right elbow in (guard the liver)" and "Left elbow in (guard the ribs)": that side's cover +20, the head on that side −10. Measure it again, since liver folds now make it change who wins.
8. **Set the fold to a target.** Measure the liver hooks landed per hurt round, then tune \(p\) so the owner's rate holds. Clamp after the ×2 (so the cap is 8%, or state 16%). The power comes from Strength, Explosiveness and the move's mastery, not Power.
9. **Follow the amateur rules.** A body knockdown is a count of 8 and counts toward the RSC limit of 3 a round and 4 a bout. The count-out share is 35% at pro, and amateur stoppages go to RSC. The legs effect is written as the energy ceiling −25 for the round (an existing meter) until a legs bar exists.
10. **Wire the rest or cut it.** Scout lines come from the opponent's real body-shot share. "A rival out injured" ships only when NPC injuries exist; until then the ribs' payoff is item 3. Bruised ribs don't block offers but cost −5 energy if she boxes; a crack blocks offers.
11. **Labels.** "Liver (right side)" and "Ribs (left side)" on Aim. Tooltips give the numbers ("each landed liver shot costs her 1.3 stamina"), with pronouns per fighter.

## The 10/10 page at 1920×1080 (Fight night, corner minute after round 2, dark and tight)

- **Header strip, 88 px:** both boxers' names once, the round, the score read, the corner's clock.
- **Left column, 560 px: YOUR BOXER.** A body silhouette with six places as marker rings, the liver and ribs coloured by band, "cracked" stamped on the rib side when it happens. Below it, energy and the energy ceiling, and the RSC counts so far.
- **Centre, 800 px: THE CARD.** When there's a crack, two cream cards side by side: Pull out (loss, 35 days, next bout about 8 weeks, −4 reputation) and Fight on (win N in 100, 84 days, 1 in 10 worse). Neither is pre-selected, and both sit behind the divider. Without a crack, the usual corner minute with the side elbow fixes.
- **Right column, 560 px: THE OPPONENT.** Her silhouette and bands, the corner read in handwriting ("liver hurt", "guarding the left side"), and the Aim set as Liver / Ribs / Head with each effect line and the fold or crack chance this round.
- **Bottom strip, 120 px:** your coach's note (one reason, no names), Say nothing, and the bell button.
