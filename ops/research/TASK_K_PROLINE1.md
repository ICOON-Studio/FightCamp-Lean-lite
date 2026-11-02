# TASK K-PROLINE1 - KALLI - turning pro, and the scouting trial (lean restart, week 4)

Model: Kalli (Grok bot, game design). Discipline: boxing (demo). Design + content: no code, no repo.

## The game now
FightCamp: the player runs a small London boxing gym. Lucy Jackson (21, women's lightweight, amateur, 3-1 when she signs)
lives on a $250/week club stipend; each amateur bout pays the CLUB a $450 ticket cut (no purse for her). Bouts every 3-5
weeks with a camp before each. Week 4 of the build adds: scouting trials (sign a second fighter), move mastery, and
TURNING PRO - the end of the demo's arc ("amateur to first pro fight").

## Part A - the turning-pro line (design: give ONE recommendation with numbers, then why)
1. When is a promoter's offer to turn pro made? (e.g. at N amateur wins, or a top-3 regional ranking, or both)
2. The terms of a first pro contract for a regional women's lightweight in the UK: her purse for a 4-round debut, how the
   gym is paid (manager share %), whether the club stipend stops, any signing fee. Small-hall realistic numbers.
3. What the player gives up by turning her pro (no more amateur bouts/rankings; the $450 ticket cut stops?) and what they
   gain - so it is a real decision, not a free upgrade.
4. Should declining be allowed, and when does the offer come back?

## Part B - content, as JSON
{
  "trial_open":   [6 lines],  // the prospect arrives for a trial at the gym ({name}, {gym})
  "trial_good":   [6 lines],  // the coach's verdict on a strong trial ({name}, {best} = best stat word)
  "trial_mixed":  [6 lines],  // a mixed trial ({name}, {best}, {worst})
  "pro_offer":    [4 lines],  // a promoter calls with a pro contract ({her}, {promoter}, {purse})
  "pro_debut":    [4 lines]   // news line: her pro debut is booked ({her}, {opp})
}
Each line under 110 characters, plain, no real people. Also invent 2 fictional small-hall promoter names (London).

## Prior research
searched: turning pro contract purse manager share (research has old pro-purse work for the cancelled project;
start fresh for women's small-hall UK).

## What would a human do?
A UK small-hall manager: offer comes after a strong amateur run; debut purses are small; the manager takes a share.

## Prefab check
Original text and numbers for this game.

Reply with Part A as short numbered answers, then the JSON for Part B.
