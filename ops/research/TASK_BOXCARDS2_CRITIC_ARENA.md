# TASK BOXCARDS2_CRITIC_ARENA - code-checked critic of the boxer v boxer card game, version 2 (S550)

Repo FightCamp-Lean-lite, branch main. You are a FRESH critic, not the author, and not the critic of version 1.
Model: your strongest. Discipline: boxing. The only file you add: `ops/research/BOXCARDS2_CRITIC_ARENA.md`.
Do not edit `proto/`. Open a PR. Everything you write is public.

## What it is
A card game of ONE boxing bout, boxer against boxer, three rounds. The leader lays up to three cards face down; they
turn one at a time, and at each punch the other man pays to stop it or takes it. Design page:
`ops/research/DESIGN_BOXCARDS2.md`. Code: `proto/boxcards/rules2.mjs`, `bot2.mjs`, `probe2.mjs`, `boxcards2.test.mjs`.
Version 1 and its critic are `DESIGN_BOXCARDS1.md` and `BOXCARDS1_CRITIC_ARENA.md` (real bout 5, depth 6, play 6):
read the critic AFTER you have formed your own view, then say which of its findings version 2 fixed, which it did not,
and what version 2 broke that version 1 had right. The owner has watched boxing for 40 years and wants a bout that
reads as a real one, fast and punchy, every number on the table, no dice.

## What to do
1. READ TEN BOUTS FIRST: `node proto/boxcards/probe2.mjs walk=1 seed=N` for ten seeds, end to end, as a boxing coach.
   List every exchange where you would say "that does not happen in a ring", and what happens instead.
2. CHECK THE PAGE AGAINST THE CODE: every rule and number on the design page TRUE or FALSE with file and line; every
   rule the code has that the page does not say.
3. RERUN: `node proto/boxcards/probe2.mjs` and the blind pilots (`pilots=same,reader`, `jabs`, `never`, `holder`,
   `runner`, `taker`, `first`, `slugger`, each from both seats). Do you get the page's numbers?
4. BREAK IT. `bot2.mjs` `PILOTS` shows how a pilot is written. In a scratch file (not committed) write at least five
   of your own, among them: a pilot that always holds his slip for the biggest punch; one that never answers a jab;
   one that leads a single card every time; one that always feints first; and the best exploiting policy you can
   find. Win share over 400 bouts from both seats. Over 60% against `reader` without reading the table = a broken rule:
   name it. Then say what `reader` cannot see (read `worth`, `answerBot`, `leadBot`).
5. SWEEP the numbers the page calls open: `kdAt=9`, `restPts=1`, `slip.w=2`, `upper.w=4`, `leads=4`, `rounds=4`,
   `D.feint=3`, and any you think matter. A table, and which bars are fragile.
6. THE PAGE'S FIVE OPEN POINTS: answer each in two lines, with a measured table where a sweep can answer it.

## Score, each out of 10, with reasons
- REAL BOUT: would a boxing fan recognise every exchange?
- DEPTH: real decisions with trade-offs; no best volley, no best answer; skill beats the draw.
- PLAY: fast and punchy (about five minutes a bout).
The bar to keep it is 8 on DEPTH and 8 on PLAY: be honest, not kind. END WITH "TO REACH 10/10": the ordered list of
changes, most important first, specific enough to build - and for each one you can test with a sweep or a ten-line
patch in a scratch copy, the MEASURED table, not a guess (a critic's untested rule once made one side win 99.5% here).

## Prior research
`ops/research/CARDBOX_SCOPE_S549.md` (method and bars), `proto/cardgame/CARDBOX1_BREAKDOWN.md` (three real bouts and
fourteen things a boxing card game must carry: check version 2 against that list).

## What would a human do?
Play twenty hands across a table before trusting a bot. You cannot: so read ten printed bouts before any table.

## Prefab check
None: a rules critic.

## Feedback loops
You change no rule in the repo. For each rule you propose, name the loop it opens and its cap.

## Contract
OWNS: ops/research/BOXCARDS2_CRITIC_ARENA.md
RED_TEST: none (a critic page)
REGRESSION: `node --test proto/boxcards/boxcards2.test.mjs` stays 18 of 18; put `RESULT: proto/boxcards/boxcards2.test.mjs -> pass 18` in the PR body
VISUAL: none
