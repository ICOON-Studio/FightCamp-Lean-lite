# TASK LEDGERREV3 - write the contracts map v3 (LEDGER1_V3) from the code, answering both v2 critics

Status: OPEN (S528, Claude main). Discipline: boxing. Model: Goose (cloud), default. RESEARCH ONLY - no game code changes.

## Why
LEDGER1 v2 (`ops/research/DESIGN_LEDGER1_V2.md`, Claude's code check at its top) scored Dola 8/8, Goose 6/5
(`ops/research/DESIGN_LEDGER1_V2_CRITIC_GOOSE.md`, `ops/research/DESIGN_LEDGER1_V2_CRITIC_DOLA_DOLA.md` lines 618-740).
The bar is 7+ DEPTH and 7+ GENERAL from two fresh critics (owner S425/S459). Goose's low general score is mostly that
the map still marks three rows CODE that the code contradicts, plus rows with no spec.

## Your job
Write `ops/research/DESIGN_LEDGER1_V3.md`: the whole map again (same sections as v2), changed so that:
1. Every row tagged CODE matches the code - READ IT: `scripts/state/ApproachWire.gd` (a club coming for our boxer:
   Match / Half / Move / Promise / Let Go, stipend held to an end day), `scripts/state/RivalOfferWire.gd` (a rival gym
   offering a BOUT: accept / not this show / pass), `scripts/state/ProOfferWire.gd`, `scripts/state/Leaving.gd` (the
   release fee: amateur free, pro max($500, year_take x 0.4)), and the renegotiation numbers wherever they live (grep
   `renegot`, `share` in scripts/state and scripts/rules). Quote file + function for each CODE row. "Answer Rival
   Offer" becomes the ApproachWire answer (or is split) - no 10% trainer cut that the code does not have.
2. Every row tagged ESTIMATE that a critic called unmoored (opportunity cost "average replacement", prime window, the
   morale effect of the stipend toggle, Inactive status) either names the game value it is computed from (file +
   function) or is CUT. Cutting is fine: fewer, real decisions beat more invented ones (owner S398: only actionable info).
3. Each decision gets a WHEN rule a player can read (e.g. release: "6+ weeks below $0 and no bout booked in the next
   3 weeks"), and the alert lifecycle (dismissed -> comes back when / escalates when).
4. The Contract tab and the Money page per-boxer view get a layout spec (sections top to bottom, columns, default sort).
5. Loyalty: show the forecast line (weeks until the leave threshold at the current trend) where a decision moves it.
Keep: the three probes (Keep Everyone / Release the Losers / Manage Contracts), the wire map table (every menu the
mechanic appears on and what it is wired to - owner S425), plain game words, names only in headers (owner S448).
End with a short "Changed from v2" list.

## Deliverable
ONE new file `ops/research/DESIGN_LEDGER1_V3.md`. A PR that adds only that file. Do not edit any other file. Do not run
Godot. Under 400 lines.

## Contract
OWNS: ops/research/DESIGN_LEDGER1_V3.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_LEDGER1_V1/V2 + their critics; J5_THE_GYMS_OWN_LEDGER.md, J6_THE_ATHLETES_OWN_LEDGER.md; CRITIC_PACK.md.
## What would a human do?
A club secretary keeps one sheet per boxer: what he costs, what he earns, when to have the hard talk.
## Prefab check
None: a design document on our own code.
