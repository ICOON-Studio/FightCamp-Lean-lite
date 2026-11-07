# Matchmaking, rank 4 step 1: rule 2's bot test (S397, 2026-11-07)

Operator S397: "Yes, start rank 4". Design: docs/STRUCTURE_DESIGN_S395.md 5.3a rule 2 and 5.7 P1. Rules only, no screen yet.
Code: scripts/rules/Matchmaking.gd on the WORLD1 tables (scripts/world/). Test: tests/matchmaking_bots_test.gd (about 50 s headless).

## The rules as built
- **Win chance**: the game's own bout odds (BoutRead.chance), both sides on their ratings, no camp: about 50% level, the
  curve the career already uses.
- **Rank, take their place**: beat someone above you, or anyone ranked while you are unranked, and you take their place. They and
  everyone between drop one, and the last place falls off. Beat someone below you and nothing moves. A loss to someone above
  you drops you one place (WorldRank.drop_one; the world's own bouts follow it too). A losing or level record is never top 10.
- **Growth**: +0.3 a bout, +0.08 a point the opponent is above you, up to 6 points (past that you are surviving, not learning);
  a close loss teaches +0.4 more. A mismatch (6+ below) teaches 0.1. A stoppage loss teaches nothing, costs 0.8 rating at once,
  adds 2 months' rest and goes on the damage ledger. The yearly rise to the peak (WorldAge) comes on top.
- **Money**: purse $1,500 unranked, +$400 a place up the table (your own rank); tickets $150 x (fans + 5) x closeness
  (1 - gap/15, floor 0.3). The gym takes 25%. Fans: +1 a win, +1 more over someone better or by stoppage, -1 for a mismatch
  win, -1 a loss, -1 a duck.
- **The unknown**: a 12-point range holds the truth, placed by dice, plus a hidden matchup edge ("styles make fights": how his
  weapon, habits and weakness, OppFile's tape tells, meet your game), +-6 rating points on the night, rolled once per pair.
  A bad edge (-3 or worse) adds 12% stoppage risk to a loss. One scout ($250) narrows the range to 4 and shows the edge.
- **The promoter**: three offers every bout (below, level, above). Ask up to 5 places above your rank (unranked: #15 down).
  A top-5 ask needs 3 fans. Two ducks (taking the soft one while a harder one was offered) stop the "above" offers and
  the softer asks. After a loss you win a rebuild fight before you ask above your place again. Every refusal says why.
- A bout every 2 months (a pro camp of 6-8 weeks).

## Results, 60 careers of 24 months, start rating 64, men's lightweight (seeds 7000+)
| bot | median end place | top 10 | rating | gym money | record | stoppage losses | belts held |
|---|---|---|---|---|---|---|---|
| easy (softest offer) | 17 | 18 | +5.0 | $7,891 | 9.4-2.6 | 0.37 | 1 |
| hard (highest ask) | 11 | 25 | +8.3 | $12,406 | 5.7-6.0 | 1.15 | 19 |
| smart (best place read at 55%+, one scout) | **8** | **40** | +6.5 | $11,776 | 8.0-4.0 | 0.45 | 10 |
| blind (smart, no scouting) | 8 | 39 | +6.5 | $13,821 | 8.3-3.8 | 0.52 | 14 |

PASS: smart beats easy by 9 places and hard by 3; smart gains more rating than easy. Each plain bot wins something: hard
earns most and holds most belts (and takes three times the stoppage losses), easy keeps the best record. That is the
four-way pull rule 2 asks for, not a solved choice.

Held on other seeds (9000+, 3000+) and thresholds: smart at 45% placed 6, at 55% 8, at 65% 10. A middle read is best;
"always higher" and "always safe" both lose.

## Built and dropped on the way (each run 60 careers)
1. First run: **hard won** (median 6 = smart's, rating +11.2, 21 belts). Losses taught without limit and a loss cost one place.
2. Capped learning at 6 points above, stoppage loss costs rating: hard 7, smart 6.5. Still a tie.
3. Rebuild fight after a loss: hard 7, smart 7.
4. Losing record not top 10, purse on your own rank: hard 11, smart 8. This is the real-world piece that was missing:
   a 6-6 fighter is not ranked top 10 anywhere.

## Scouting fixed (S397, operator: "Fix scouting first")
Before: scouting only narrowed the rating guess, worth +1 top-10 finish over 60 careers for about $2,000. A few points of guess
rarely changed the pick, and nothing hidden could hurt you. The fix is the hidden matchup edge above. The smart bot now scouts
the fight it is about to take (two looks a pick at most). Test raised to 120 careers per bot, scouting gated:

| seeds | smart top 10 | blind top 10 | stoppage losses smart / blind | money cost | smart / blind median place |
|---|---|---|---|---|---|
| 7000 (the test) | 83/120 | 75/120 | 0.54 / 0.63 | -$2,572 | 8 / 8 |
| 3000 | 87/120 | 70/120 | 0.65 / 0.84 | -$2,117 | 7 / 9 |

Tried and dropped: edge +-4 (+20 top-10 over 240 careers, one seed set a wash); scouting only borderline reads (+21 over 240).
Gates now: smart beats easy by 3 places and hard by 1, gains more rating than easy, and scouting buys >= 5 more top-10
finishes and fewer stoppage losses than the same bot blind.

## Open (not gated)
- Scouting costs about a fifth of the gym's two-year take: right for a choice, but a screen must show what a scout found.
- The world's own boxers do not yet obey the losing-record floor (only the player). Belts change hands on any win over a
  holder; title fights are not separate yet.
- Five-year version, amateur version, and the screens (Ask for a fight, the Road, promoter's band with its reasons) come next,
  plus the blind walkthrough. Not wired into the career.

## Screens (S397, operator "Yes, build screens"): five blind rounds, stopped at 5
Wired: scripts/state/ProLadder.gd (after the debut a pro joins her WORLD1 table; a monthly world tick; offers every 8 weeks;
scouting opens the tape; ladder bouts run through the real fight night), screens scripts/ui/ProFights.gd on the Fights page,
tests/pro_ladder_test.gd, stills tools/pro_fights_still.gd (TestJump proladder / proranked).
| round | score (screen / decision) | what changed after it |
|---|---|---|
| 1 | 4 | fighter header, stakes per offer, mid reads, the Road's fightable window, step ups sell more tickets |
| 2 | 5 | one NEXT FIGHT table (offers then asks), shared rules once, scout shows how the read moved, records follow ratings |
| 3 | 5 (6 / 4) | step up = a ranked name, no duck while rebuilding, scouting on asks, net fans, a loss column, FAVOURITE/CLOSE/UNDERDOG |
| 4 | 4 (5 / 4) | risk pays (OPP_DRAW_PER_PLACE), a loss costs fans by how it looked (loss_fans), the gym's take as the money, the Road slice |
| 5 | 5 (6 / 4) | stopped: the critics now pull opposite ways (round 4 asked losses to cost by look; round 5 calls the free underdog loss "solved") |
Left, structural (next session):
- The decision still reads as solved to critics: "the highest ranked name near 40%" dominates. The bots agree a ~45-55% read is
  best. Next lever, from round 5: a loss to a ranked name costs something real besides fans (a layoff when stopped, shown in
  weeks; a rankings freeze), and the safe fight gives something concrete (sharpness, a safe purse).
- No "her vs them" side by side: show her style and the matchup the scout found as numbers.
- Unscouted reads are wide (18-70%); a scout narrows them but can bring bad news with no number for using the weakness.
- Chance vs ranking: take-their-place churn means #17 can be far stronger than #18; the world needs a rating pull on ranks.
- The TestJump films its pro bouts on the booking day (a test artefact; the real flow fights on fight night).
