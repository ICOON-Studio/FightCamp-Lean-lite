# ZIVAPLAY1 - play Ring Switches and judge it on FUN (S556)

Owner, 2026-11-25: "Can ziva play test it and judge it on fun?"
Model: Ziva Smart, effort MAX. Discipline: boxing. You write a report and nothing else: no game file, no page file, no
commit to main. Nothing opens on the owner's screens (your image tool only; no browser window, no viewer).

## What it is
Ring Switches is a small boxing game the owner loves ("this can become a beautiful game i played 1 turn and i love it").
Each beat you set three switches (lead hand, rear hand, feet) and the order you throw them; he sets his at the same
time; three moments are played out. A hand that does not punch is held high or low and blocks one line. Three ranges.
It is a browser page (`E:/FightCamp/Lean/proto/twohands/order.html`), so you play it IN WORDS, on the page's own rules
and its own three opponents:

```
cd /e/FightCamp/Lean
node proto/twohands/tools/play_cli.mjs help                                  (every switch, cost, reach, what blocks what)
node proto/twohands/tools/play_cli.mjs new  E:/FightCamp/tmp/zivaplay1/b1.json opp=0 seed=11     (0 Jabber, 1 Slugger, 2 Body Snatcher)
node proto/twohands/tools/play_cli.mjs beat E:/FightCamp/tmp/zivaplay1/b1.json lead=jab rear=high feet=in order=feet,lead
node proto/twohands/tools/play_cli.mjs beat E:/FightCamp/tmp/zivaplay1/b1.json clinch
node proto/twohands/tools/play_cli.mjs show E:/FightCamp/tmp/zivaplay1/b1.json
```
Each bout's beats are logged to `<state>.log.txt`. He chooses before he sees your beat: do not peek, there is nothing
to peek at. Read only the tool's output; do not read order.html or the tools' code before you have played six bouts
(a player cannot).

What the player SEES is pictures of two boxers, side view, for every action. The strips of the newest punch are in
`E:/FightCamp/Lean/ops/previews/s556_bodyjab/*.png`; every action's frames are in
`E:/FightCamp/Lean/proto/twohands/img/anim/` (`<corner>_<action>_<result>_<0..10>.webp`, frame 6 is the contact).
Look at twelve of them with your image tool, including a blocked and a missed body punch.

## What to do
1. PLAY NINE BOUTS, deciding every beat yourself, one line of WHY before each beat (keep them: they are the evidence):
   - six honest bouts, two against each opponent, playing to win;
   - one bout trying to BREAK it: find the one plan you would repeat every beat, and repeat it;
   - one bout doing only what feels good, not what wins;
   - one bout against the opponent you enjoyed least, to say why.
2. AFTER EACH BEAT, three marks in your log: CHOICE (how many plans did I seriously weigh: 1, 2, 3+), SURPRISE (did the
   result surprise me, and could I say why it happened from the lines I was shown: yes / no), LEARNED (what I now know
   about him that changes my next beat, or "nothing").
3. JUDGE IT ON FUN, each with the beats that prove it (bout and beat numbers):
   - the three best moments and the three dullest;
   - a beat where the result felt UNFAIR or could not be explained from what was shown;
   - is there a plan that is right every beat (say it and its record), a switch you never wanted, a range where nothing
     is worth doing;
   - each opponent: does he feel like a different man, is he too hard or too easy, does reading him pay;
   - the bout's shape: do rounds 2 and 3 play differently from round 1, does a knockdown or the ropes change what you do,
     does the bout end too early or drag;
   - the newest things: the body jab at Long (does Long have a real guess now), "a round level on points goes to the man
     who backed off less" (did it ever change what you did), health 18;
   - the pictures you looked at: does each read as the action it is; which do not.
4. SCORES, 1 to 10, each with one line: FUN, DEPTH (does it reward thinking a beat ahead), CLARITY (could you always say
   why), VARIETY (do bouts differ). Then say what you could NOT judge from words (pace, sound, the feel of the click).
5. END WITH "TO REACH 10/10": the concrete changes, most important first, each specific enough to build and each tied to
   a beat you played. Then DRAW your 10/10: one 1920x1080 HTML page of the fight screen as you would have it
   (`E:/FightCamp/tmp/zivaplay1/ten.html`), rendered with `python tools/render_mockup.py` from E:/FightCamp/Lean if it
   runs headless for you; if it does not, leave the HTML and say so.

## Where the result goes
`E:/FightCamp/tmp/zivaplay1/ZIVAPLAY1_REPORT.md` (the report: verdict first, then a NOT SURE list, then the sections
above), the nine state files and their logs beside it. Claude collects them. Say in your last message: ZIVAPLAY1 DONE.

## Prior research
docs/RINGSWITCH_S556.md and docs/RINGSWITCH_BALANCE_S555.md (what the measuring bots say: 8 of 9 bars; the jab lands
73%) - read them only AFTER your six honest bouts, then say where your play agrees and where it does not.
ops/research/RINGSWITCH_BALANCE_BRIEF_KALLI.md and _JOHN.md (the two seats' ideas; unbuilt: hurt, a circle step, the
lead uppercut beating a clinch).

## What would a human do?
A playtester plays cold, talks aloud, and marks the moment he stops caring. He does not read the design first.

## Prefab check
None: nothing is built.

## Limits
One heavy job at a time; these commands are light (each beat a second or two). No sound, no window. If a command
fails, paste its output in the report and go on with the next bout.
