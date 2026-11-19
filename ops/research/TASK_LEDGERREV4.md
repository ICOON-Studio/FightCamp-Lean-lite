# TASK LEDGERREV4 - write the contracts map v4 (LEDGER1_V4) from the code, answering both v3 critics

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud), default. RESEARCH ONLY - no game code changes.

## Why
LEDGER1 v3 (`ops/research/DESIGN_LEDGER1_V3.md`, written by Goose from the code) scored Dola 8/8 and Arena 7/6
(`ops/research/DESIGN_LEDGER1_V3_CRITIC_DOLA_DOLA.md` lines 640-760, `ops/research/DESIGN_LEDGER1_V3_CRITIC_ARENA.md`).
The bar is 7+ DEPTH and 7+ GENERAL from two fresh critics (owner S425/S459). Arena's general 6 is about the money being
attributed loosely ("worth" mixes cash with estimates) and warnings without one rule table.

## Your job
Write `ops/research/DESIGN_LEDGER1_V4.md`: the whole map again (same sections as v3), changed so that:
1. TRUE CASH FIRST (Arena 1). Each boxer's row counts only receipts and payments the books actually record for that boxer
   (find where: grep `add_money`, `cash`, `ledger`, `GymBills`, `GymSpend`, `money_log` in scripts/state and scripts/rules;
   quote file + function). Shared bills and unallocated dues stay in a CLUB column, never in a boxer's total. Estimates
   (membership effect of wins, allocated fees) get their own labelled line and are never added into cash. Words: "Cash in /
   Cash out / Net", never "worth". Say plainly which receipts the code does NOT tag with a boxer today (that is build work:
   name the function that would tag it).
2. ONE COMPARISON FROM THE SAME STATE (Arena 2). Keep as is / Pause stipend / Release (when legal) on one eight-week view:
   next bill, lowest projected club cash, next booked bout, avoidable spend, exit fee (Leaving.gd), loyalty change. A
   bout that is not booked is a dashed conditional line, never an exact break-even date.
3. ONE WARNING TABLE (Arena 3): yellow / orange / red, each with its trigger, what clears it, what a Review snooze does, and
   where its button goes. The idle count pauses during compulsory rest and shows the return date.
4. CONDITIONAL CHOICES (Arena 4): each answer shows its availability and refusal reason from the rule (ApproachWire,
   RivalOfferWire, ProOfferWire), deadlines and what a lapse does. Deals are still committed only on their existing screens;
   the ledger links there.
5. THE REWARD SIDE (Dola 1-2): a "Self-funding" state (break-even reached, a bout booked, no alert) shown in green on the
   Contract tab and as a +$X badge on the week review row; the milestone value line ("at a top-3 rank / a pro debut ...")
   computed only from existing purse and ticket rules (ProCall, ProDebut, BoutRules TICKET_CUT) and shown as CONDITIONAL.
6. Compare 2-3 boxers side by side from the Money page (Dola 3), and the Find a bout / Release buttons on alert rows
   (Dola 4) - each wired to an existing screen.
7. PROBES (Arena 5): the decision probes hold the start state and seed and change ONE decision; fixtures: cash-rich gym,
   cash crisis, suspended prospect, two boxers sharing a stipend, a pro on a reduced share. Pass lines require that each
   decision is best somewhere and no policy wins everywhere.
Keep: the wire map table (every menu the mechanic appears on and what it is wired to - owner S425), plain game words, names
only in headers (owner S448). Do not put either critic's score in the map. End with a short "Changed from v3" list.

## Deliverable
ONE new file `ops/research/DESIGN_LEDGER1_V4.md`. A PR that adds only that file. Do not edit any other file. Do not run
Godot. Under 450 lines.

## Contract
OWNS: ops/research/DESIGN_LEDGER1_V4.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_LEDGER1_V3.md + both v3 critics; J5_THE_GYMS_OWN_LEDGER.md, J6_THE_ATHLETES_OWN_LEDGER.md; CRITIC_PACK.md.
## What would a human do?
A club secretary keeps one sheet per boxer of real money in and out, and before the hard talk lays the options side by side.
## Prefab check
None: a design document on our own code.
