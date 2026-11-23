# CARDPREPROD1 - the card game's pre-production plan, the way a AAA studio prepares (S540)

Kind: research + planning (no game code). Model: claude-fable-5-2 (Code Mode console). Commit only your files
(`git commit -- <files>`) and push. Do not run Godot. Long reads in windows; never read a file over 500 lines whole.

## The owner's ask (S540, verbatim)
"use the console with fable , i want strategic planning for later arts implementation and everything what a AAA studio does to
prepare at this stage". Context: he asked whether any session had scoped the whole card game workflow - none had. Six rounds ran
(CARDSCOPE1-5 by Fable consoles, CARDSCOPE6 by Arena); none passed its core bars or reached his hands as a playable link.

## The owner's second ruling (S540, verbatim) - and what is ALREADY DECIDED
"it doesn have to be strickly cards, it can combine any genr that fable thinks has the best potential to success". Then, when
Claude's first brief asked for a genre comparison from scratch: "why i think we did that already and i also made propositions".
So DO NOT redo the genre study. It exists: OWNER_CARDGAME_INTERVIEW_S537.md (his reference set: breachway, hearthstone,
clutchtime, rune coliseum, starless abyss, mma arena, monster train, mixed martial cards demo, kungfu card, ironbound; "Fast and
punchy"; "Show me everything"; standalone; seven arts with MMA as the meeting ground; animations where possible), CARDREF1_REFERENCE_GAMES.md,
CARDREF2_MARTIAL_ARTS.md, JOHN_CARDGAMES_RESEARCH_JOHN.md, JOHN_CARDGAME_MARKET_S538_JOHN.md (market check), DOLA_CARDSET_IDEAS_DOLA.md.
HIS PROPOSALS, each to be placed in the plan (which milestone, how it is gated) or argued against with evidence: action points
per limb; asynchronous "ghost" battles with other players; ladders and championships; fighters learning skills; training
decisions between bouts; Clair Obscur: Expedition 33's turn-based play with real-time reactions (dodge/parry on the enemy turn);
animated cards / short move clips; GrappleMap for grappling positions (S540).
Section 2 is therefore: a SHORT synthesis (one page) of what those studies and his answers already settled, then whether the
evidence shows a combination with another genre that strengthens it (e.g. the Expedition 33 reaction layer, a manager meta) -
recommend keep or adjust, with the reason, in half a page. No new market survey.

## Read first (primary sources, say which you opened)
- ops/research/OWNER_CARDGAME_INTERVIEW_S537.md (his answers - binding), ops/research/CARDGAME_PLAN_S539.md (his "ok": one line,
  two-art slice, free seats write it, weekly play link, premium Steam route)
- ops/research/DESIGN_CARDGAME_SCOPE.md (rounds 1-6; read the section heads, then each round's verdict and table)
- proto/cardgame/ (round 6 engine: cards.mjs, engine.mjs, plan.mjs, career.mjs, probe.mjs) and the CARDFIX6B brief
  (ops/research/TASK_CARDFIX6B.md: the page does not load, title one rung late, ladder 100/100, P2/P4/P5/P6 fail)
- ops/research/JOHN_CARDGAME_MARKET_S538_JOHN.md (market), ops/research/TASK_GRAPPLEMAP1.md (GrappleMap, public domain: the
  BJJ position graph + 2D view), docs/PICS2D1_RESULT.md (our 2D picture method), the critic files on the card game
  (`ls ops/research | grep -i card`), CLAUDE.md (studio rules: critics at 8/8, probe before critics, free seats)
- `python ops/Tools/prior_research.py card game` and `python ops/Tools/prior_research.py deckbuilder`

## Deliverable: ONE document, ops/research/CARDGAME_PREPROD_S540.md
What a AAA studio produces at the end of concept / start of pre-production, scaled to this team (Claude coordinating, free
seats Arena/Dola/Kalli/John/Ludo, the owner as CEO and playtester, a tiny budget). Plain words, no jargon; every number with
its source or marked ESTIMATE. Sections:
1. Diagnosis: why six rounds did not reach him - method, not single defects (FINDINGS DRIVE THE QUEUE, CLAUDE.md rule 8). Say
   what to STOP doing.
2. Vision and pillars (3-4), the one-line pitch, the target player, the comparable games (real ones, with what we take and avoid
   in our own words), what makes it ours (real martial arts that play differently; the gym game's world).
3. Core loop / meta loop / long-term loop, and the first 10 minutes of play.
4. ART-BY-ART ROADMAP (the owner's main ask): order of the seven arts after boxing + BJJ, with the reason for each place; for
   each art: its own mechanic, its signature cards, the real-world source (rules body, technique references; GrappleMap for
   grappling positions), its art needs, the gate it must pass to join (P6 "plays differently" against all arts in, P4 balance,
   the owner's play), and the cost in rounds. A matchup-matrix plan (how balance is kept as arts join).
5. Milestones with a definition of done each: vertical slice (2 arts, playable link, owner OK) -> first playable run -> alpha
   (all launch arts) -> beta -> Early Access. What is in, what is out, what each needs from each seat. Dates as ESTIMATES in
   rounds/weeks.
6. Pipelines: rules (one engine, one bar sheet, one probe harness), content (card data format, how a new art is added), art
   (Ludo for card art, GrappleMap + our 3D for poses, the 2D picture method), UI/UX (the restyle style sheet), audio, saves,
   platform/tech (stay node+browser for prototype; what ships: Godot web/desktop or a web build - recommend and say why).
7. QA and balance: the bar sheet, regression tests, the code-checked critic, playtest protocol with the owner, telemetry later.
8. Production: who does what (seat roles from CLAUDE.md), round cadence, how a round is briefed and gated, what Claude checks.
9. Business: price, store (Steam premium per the plan), what is free vs paid, legal (art names, licenses: GrappleMap public
   domain; never copy other games), marketing beats a small studio can afford.
10. Risk register (top 10: likelihood, impact, the early warning, the mitigation).
11. Decisions needed from the owner (taste/scope/money only), as at most 5 short questions, each with your recommendation.
12. The next 3 rounds, briefed in one paragraph each, ready to hand to Arena.

Also write a one-page summary at the top (what he reads in 2 minutes). Keep the document under 600 lines.

## Rules
Nothing opens on the owner's monitors. Do not change proto/ or game code. If a claim depends on code, open the file and cite
file:line. When done: commit, push, and end with a five-line report.

## Prior research
As listed in "Read first".

## What would a human do?
A studio head stops the fix rounds, writes the plan everyone builds from, and gets the boss to sign it.

## Prefab check
None (a plan).

## Contract
OWNS: ops/research/CARDGAME_PREPROD_S540.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: none
