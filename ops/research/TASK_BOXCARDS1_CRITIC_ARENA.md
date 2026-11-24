# TASK BOXCARDS1_CRITIC_ARENA - code-checked critic of the boxer v boxer card game (S550)

Repo FightCamp-Lean-lite, branch main. You are a FRESH critic, not the author. Model: your strongest. Discipline: boxing.
The only file you add: `ops/research/BOXCARDS1_CRITIC_ARENA.md`. Do not edit `proto/`. Open a PR. Everything you write is public.

## What it is
A card game of ONE boxing bout, boxer against boxer (the owner: "the real test should be a boxer vs boxer"). Three
rounds; the leader lays a volley of up to three cards face up, the other man lays ONE answer. The design page is
`ops/research/DESIGN_BOXCARDS1.md`; the code is `proto/boxcards/` (`rules.mjs`, `bot.mjs`, `probe.mjs`,
`boxcards.test.mjs`, 272 lines). The owner has watched boxing for 40 years and wants a bout that reads as a real one,
fast and punchy, every number on the table, no dice.

## What to do
1. CHECK THE PAGE AGAINST THE CODE. Read `rules.mjs` line by line. For every rule and every number on the design page
   (the cards table, the "opens with" table, knockdown, judges, the measured table): TRUE or FALSE, with the file and
   line. List every rule the code has that the page does not say, and every one the page says that the code lacks.
2. RERUN THE NUMBERS. `node proto/boxcards/probe.mjs` and `node proto/boxcards/probe.mjs pilots=reader,slugger`. Do
   you get the page's table? Then check the bot is not the reason for a result: read `bot.mjs` `worth` and
   `volleyValue` and say what the reader bot cannot see (it looks one exchange ahead).
3. BREAK IT. Write your own pilots in a scratch file (do not commit it): always the same volley; jab-only; never
   lead (always an empty volley); always clinch or step back when legal; body hooks only; "feint first always"; and
   the best exploiting policy you can find against `reader`. For each: win share over 400 bouts from both seats, and
   what the bout looks like. A policy that beats `reader` more than 60% without reading the table is a broken rule:
   name the rule. A policy that wins by not fighting is a broken judge: name it.
4. SWEEP. `node proto/boxcards/probe.mjs name=value` changes any number in `N`; `jab.w=2` style changes a card;
   `D.feint=4` the deck; `W.cap=3` the bot's weights. Find which numbers the bars are fragile to (first lead 45-55%,
   to the cards 40-70%, a combination in most bouts, 22-45 decisions, empty leads under 10%, every card used).
   Say whether 83% to the cards is a fault of the rules or right for a three-round amateur bout, with your evidence.
5. READ THE WALKED BOUT (`node proto/boxcards/probe.mjs walk=1 seed=7`, and five other seeds) as a boxing coach would.
   List every exchange where you would say "that does not happen in a ring", and what happens instead.
6. THE DESIGN PAGE'S FIVE QUESTIONS (its last section): answer each in two lines.

## Score, each out of 10, with reasons
- REAL BOUT: would a boxing fan recognise every exchange?
- DEPTH: real decisions with trade-offs; no best volley, no best answer; skill beats luck of the draw.
- PLAY: fast and punchy (about 5 minutes a bout, quick turns).
The bar to keep it is 8 on DEPTH and 8 on PLAY, so be honest, not kind. END WITH "TO REACH 10/10": the ordered list of
changes, most important first, specific enough to build (card names, numbers, rules) - and for each, the number you
expect a probe to show. A rule you propose that you can test with a sweep or a ten-line patch in a scratch copy: test
it and give the measured table, not a guess (a critic's rule once made one side win 99.5% here).

## Prior research
`ops/research/CARDBOX_SCOPE_S549.md` (the method and the bars), `proto/cardgame/CARDBOX1_BREAKDOWN.md` (three real
bouts and fourteen things a boxing card game must carry - check the design against that list and name what is missing).

## What would a human do?
A designer would play twenty hands on a table with a friend before trusting a bot. You cannot; so read ten printed
bouts end to end before you read any table.

## Prefab check
None: a rules critic. Reference card games are named in CARDBOX1_BREAKDOWN.md.

## Feedback loops
You change no rule in the repo. In your scratch tests name any loop a proposed rule opens (what it feeds, what caps it).

## Contract
OWNS: ops/research/BOXCARDS1_CRITIC_ARENA.md
RED_TEST: none (a critic page)
REGRESSION: `node --test proto/boxcards/boxcards.test.mjs` stays 12 of 12; put `RESULT: proto/boxcards/boxcards.test.mjs -> pass 12` in the PR body
VISUAL: none
