# CLAUDE LAND NOTE — J55 (the corner between rounds)

- **Land as:** `research/J55_THE_CORNER_BETWEEN_ROUNDS.md` (copy of `/workspace/j55/J55_THE_CORNER_BETWEEN_ROUNDS.md`, unchanged).
- **Scope:** RESEARCH ONLY. No code changes. **Do not edit HANDOFF.** This lands a memo only.
- **Date:** 2026-10-03. Trigger: operator ruling S74, mic'd corner calls with crowd noise as a possible setting and selling point, "research before any build". Respects the 2026-09-07 decision: **one authored corner rule, not a jurisdiction table**.
- **Brief:** the original J55 brief text was not available when this was written; the structure (sections 0 to 7, Appendix A, tags, typed sources S1..S62) follows J54 and the operator's description. If the brief set other headings, re-cut the memo.

## Headline findings (SOURCED unless marked)
- **The clock is the same everywhere.** Rest is 1 minute in England Boxing, IBA, World Boxing, USA Boxing, BBBofC, Nevada and ABC. A 10-second warning clears the corner before the bell, so the working window is about 45 to 50 seconds.
- **One person in the ring** in nearly every code; 3 seconds amateur, 4 pro (BBBofC, California, titles in NV/NJ/ABC). Nevada alone says only a cutman may be inside in boxing during the rest, which is the cleanest model of the cut-versus-coach trade-off.
- **Coaching in the rest is allowed everywhere**; the codes split on loud coaching during rounds, on towels (amateur = stoppage, Nevada = foul, California = allowed, New Jersey = no second may terminate) and on cut agents.
- **Real corners talk a lot, famous ones are short.** Halperin 2016 mic'd 12 coaches: 445 statements, about 8 per round, 52.5% controlling (amateur, 25 bouts). Named bouts in the extracts: 1 to 3 directives per rest (Atlas–Moorer R8: about 111 words, 2 instructions; Dundee–Leonard R12: "You're blowing it, son."; SugarHill: "jab", repeated 5 times; Davison–Joshua R4: 3 directives, one repeated 4 times). Counts are PROXY (partial clips).
- **Recovery is partial.** Heart rate falls only 13% to 19% (26 to 35 bpm) in the minute (n=10, simulated, de Lira 2013). Chest ice did not help in an MMA study (PROXY).
- **Cut and enswell work has no outcome evidence (NOT FOUND).** Cuts are 51% of Nevada pro-boxing injuries; an ice bag cools facial skin better than a steel enswell in healthy volunteers (PROXY).

## Proposed model (JUDGEMENT; all numbers `invented`, anchored in the memo section 4)
- 60 s minute: arrive 0 to 5, settle 5 to 20 (water, breath, health check, cut work in parallel), tell 20 to 45 (**two instructions maximum**, one confidence line), finish 45 to 50, clear 50 to 60. Matches the existing 45 s `CornerPitStop` bar.
- Breath refills about 15% of the gap, not fully. Instruction uptake: slot 1 full, slot 2 about 0.6, slot 3+ about 0.1. Fighter receptivity rises over the minute.
- Cutman on staff works inside while the head coach talks from the apron; no cutman means the coach does the cut and loses one instruction slot.
- Stop decision (continue / doctor check / retire) is separate from the coaching choice. Two voices disagreeing is an optional event that wastes a slot.
- Mic'd option: at most two sentences, each at most 60 characters (K72 cap), plus one breathing line; line families from the sourced quotes. Write new lines; do not ship third-party quotes.

## Before implementing
- Wire `CornerAdvice.focus` (breathe, defence, close_it, body, output, cut_work) to the action chooser through the Tell slots; today it is speech only.
- Check `FightStoppageRead` for a mid-round towel path before building the retire rule; copy no commission quirk.
- Confirm that two instruction slots feel fair against Halperin's 8 statements per rest, and tune the 15% refill against `FightTrauma` and round stamina.
- Biggest gaps (section 6): no outcome study on cut work, no study of instruction retention, no timed corner timeline, no HR recovery from real pro fights. Do not present any model number as measured.
