# ALLPLAY2B - the tells, version 2: three more bouts and a verdict (S563)

Owner S563: "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is ?
Can you have ziva and some other agents playtest the current version and provide feedback". Round 1 (ALLPLAY2): four of
four seats picked ONE body tell, and all asked for the same fixes. Version 2 (`ops/research/DESIGN_TELLS2.md`, section 2)
has them. This round says whether they work. Discipline: boxing. A report and nothing else: no game file, no commit
(Arena: commit only your report folder).

## What changed in version 2 (all you need; do not read tells.mjs before your bouts)
- Every man lies about 1 beat in 4 or 5, each by ONE rule tied to something on screen. Find each rule.
- A lie is always a BLUFF: he shows more than he throws. A fake costs him 1 stamina (the tool says so after the beat).
- A new cue: "his weight sits on his back foot" = a back off or a clinch. "A quiet guard" now means none of the others.
- Inside, the front foot means nothing (a step in changes nothing there), so it is never his cue at Inside.
- The ledger at each bell says WHEN each fake came.

## Play
Three bouts, TELLS VERSION 2, one against each man, deciding every beat yourself with one line of WHY:
```
node proto/twohands/tools/play_cli.mjs new <dir>/v1.json opp=0 seed=51 tells=2
node proto/twohands/tools/play_cli.mjs new <dir>/v2.json opp=1 seed=52 tells=2
node proto/twohands/tools/play_cli.mjs new <dir>/v3.json opp=2 seed=53 tells=2
```
`<dir>`: your ALLPLAY2 folder (E:/FightCamp/tmp/allplay2/<seat>/; Arena: ops/research/allplay2/arena/).

## Report: `<dir>/ALLPLAY2B_<SEAT>.md`, verdict first
1. Each man's lie: did you find it, in which bout, round and beat, and what tipped you off. Was it the ledger, the beat
   story, or his last beats?
2. A caught lie: did it leave a gap you could hit? One beat that shows it, or one where it did not.
3. Is a beat with a tell still a decision, or a sum with one right answer? Compare with your version 1 tells bouts.
4. The back-foot cue and the quiet guard: clear? Did the clinch still surprise you?
5. SCORES 1-10 for version 2: FUN, DEPTH, CLARITY, VARIETY, beside your version 1 tells scores.
6. TO REACH 10/10 for the tells: the changes, most important first, each tied to a beat you played.
End with `ALLPLAY2B DONE`.

## Prior research
Your own ALLPLAY2 report (read it first: it is what you compare against); ops/research/DESIGN_TELLS2.md after your bouts.

## What would a human do?
A playtester who asked for a change plays it at once and says whether it fixed what he asked for, and what it broke.

## Prefab check
None: nothing is built for the game.

## Feedback loops
A fake costs him 1 stamina, so a man who lies a lot tires (a cap that grows with use). His AI still does not know you see
his cue. Say if the cost changed how he fought.

## Contract
OWNS: <dir>/ALLPLAY2B_<SEAT>.md and the three bout files. RED_TEST: none (a playtest). REGRESSION: none. VISUAL: none.
