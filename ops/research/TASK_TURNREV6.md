# TASK TURNREV6 - write the turning pro map v6 (TURNPRO1_V6) from the code: debut gaps from the measured curve, both v5 critics answered

Status: OPEN (S531, Claude main). Discipline: boxing. Model: Goose (cloud), default. RESEARCH ONLY - no game code changes.

## Why
v5 (`ops/research/DESIGN_TURNPRO1_V5.md`) scored Arena 5/5 (`ops/research/DESIGN_TURNPRO1_V5_CRITIC_ARENA.md`, its main
fault: the debut gap's sign) and Dola 7 depth / 8 general (`ops/research/DESIGN_TURNPRO1_V5_CRITIC_DOLA_DOLA.md`, her answer
starts at the line "1. DEPTH — 7/10", ~line 781; above it is her page's menu text and the brief). Bar: 7+/7+ from two critics.
The gap is now MEASURED: read `ops/research/S531_PROBE_READS.md` (TURNGAP1 section) and `docs/TURNGAP1_RESULT.md` FIRST.
The debutant's opponent rating is night - opp_gap (`scripts/state/Roster.gd` ~line 305): a BIGGER gap is a WEAKER opponent.
Measured win share (20 boxers x 10 nights): gap -4 35.5%, -2 41%, -1 67%, 0 78.5%, +1 79%, +2 79%, +4 83.5%, +8 96.5%.
Today's gaps (`scripts/rules/ProCall.gd` lines 45/56: 1.0 and 1.5) both give ~79%: the two houses' debuts are the same fight.

## Your job
Write `ops/research/DESIGN_TURNPRO1_V6.md` (same sections as v5), changed so that:
1. The two houses' gaps are set FROM THE CURVE so the house choice changes the fight: name each gap and its measured win
   share (e.g. one house near -1 = ~67%, the other near +4 = ~84%); every gap row tagged CODE (today's value, file+line) or
   ESTIMATE (the new value, with the curve row it comes from). Fix every place v5 has the sign backwards.
2. Answer each item of BOTH critics' "To reach 10/10" lists: KEEP (with the build line: file, function, menu) or CUT with
   the reason from the code. Use an existing lever before adding one (grep first).
3. Dola asks for "win chance beside each house". The offer's read (`scripts/rules/BoutRead.gd` likely/band) may read ~25
   points under the sim at signing (S531_PROBE_READS "CHECK NEXT": read before the camp, coach 0, one boxer). Do not
   promise a shown number: write the probe line that checks it (per boxer: the read the offer shows vs its own nights) and
   what the offer shows if it fails.
4. Keep the wire table (every menu, what it shows, what it opens) and the probes (population named, pass lines).
Every row tagged CODE / ESTIMATE / CUT. Plain game words, names only in headers, no critic scores in the map. End with
"Changed from v5".

## Deliverable
ONE new file `ops/research/DESIGN_TURNPRO1_V6.md`. A PR that adds only that file. Do not edit any other file. Do not run
Godot. Under 420 lines.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V6.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_TURNPRO1_V5.md + both v5 critics, TURNPROBE3_READ_S530.md, S531_PROBE_READS.md, docs/TURNGAP1_RESULT.md.
## What would a human do?
A manager picks a debut opponent he expects to beat four times in five, and takes a harder one only when the money says so.
## Prefab check
None: a design document on our own code.
