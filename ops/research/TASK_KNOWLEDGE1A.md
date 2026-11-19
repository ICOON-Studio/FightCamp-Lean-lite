# TASK KNOWLEDGE1A - progressive knowledge v3, the pure rules: groups, widths, the reads and their prices, stale, hype, moments

Status: OPEN (S523, Claude main). Discipline: boxing. Model: Goose (cloud), default. Pure rule modules + their tests only.
Source: the owner approved the design (KNOWLEDGE v3 passed critics and his board, Q-S294-228). The map:
`ops/research/DESIGN_KNOWLEDGE_V3_REVISE_KALLI_KALLI.md` - read sections 1-8 and 14 whole; this brief is build-order
step 1 + the rules of steps 2 and 4 as pure functions. Claude wires them into the game afterwards (Week, Fighter page,
Find a fighter, week review). Today `scripts/rules/Knowledge.gd` (201 lines, S411 KNOW1) holds an older cut: groups
body / skills / fire (heart sits in fire), exposure kinds, a stale() that scales fire. NOTHING in scripts/ reads it yet
(only tools/knowbots_probe.gd and tests/knowledge_test.gd), so it may change shape.

## Contract
OWNS: scripts/rules/Knowledge.gd, scripts/rules/KnowReads.gd, tests/knowledge_test.gd, tests/know_reads_test.gd
RED_TEST: tests/know_reads_test.gd -> KNOW_READS failures=0
REGRESSION: knowledge_test
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py knowledge read range hype stale`. Read the design above, ops/research/GDSCRIPT_TRAPS.md,
scripts/rules/Knowledge.gd whole, tests/knowledge_test.gd, scripts/rules/Attrs.gd (the attribute keys and scale 0-100).

## What would a human do?
A scout's report: a range on every number, narrower the longer you have watched, honest (the truth is always inside),
and each way of watching has a price and a known effect. Keep it a table of numbers, every one named.

## Prefab check
None needed: extend the existing Knowledge.gd; no plugin.

## The job
1. Knowledge.gd to the v3 groups (design section 4): body (6 attrs, ±8 day one), skills (6 attrs, ±12), under_fire
   (durability, composure: UNKNOWN until the first hard spar, then ±15), mind (heart and the traits: words, no range),
   plus `room_word(pot - stat)` -> "lots" / "some" / "little" (thresholds ESTIMATE constants). Keep `range_of` honest:
   the truth is always inside [lo, hi] (a test sweeps it). Old saves: `all_seen()` stays Exact.
2. Exposure (section 4 "Sharpens by"): `morning(k, focus_group)` - 1 point off each body edge per 3 focused mornings;
   `pad_night(k, drilled)` - 1 point a night on skills; `hard_spar(k, outside: bool)` - under fire to half way (club
   mate) or 3/4 (outside partner); `bout(k)` - under fire 4 points off each edge, the only read that finishes it;
   `goal_met(k, attr)` - narrows that attribute by 3 each edge. Floors and every number as named ESTIMATE constants.
3. KnowReads.gd (new, pure): the reads table of section 3 as data + `price(kind)`, `narrows(kind)` and `apply(k, kind)`
   for look_closer ($120, one group to half its day-one width, or clears Hyped), trial (every group as if signed;
   cost = half stipend 4 weeks, return the cost), test_day ($60, body 4 off each edge; twice with under 5 bouts),
   recheck ($40, once every 3 weeks per boxer - `recheck_ready(k, day)`; wins back half of what went stale),
   hard_spar_club / hard_spar_outside (risk numbers returned for the screen: injury x2 for the night, tiredness +15,
   the outside partner $160). Width words (section 4): `word(half_width)` -> Unknown / Rough / Good read / Exact.
4. Stale (section 6): stoppage loss under_fire +6 each edge, 12+ weeks without a bout +3, a step up +4, age 30+ each
   birthday body +2; each widening keeps its cause (`stale_causes(k)` -> lines like "A step up to regional: under fire
   widened") so the hover can say why.
5. Hype (section 5): `hyped_centre_offset(seed)` 3-8 points high for a Hyped prospect, 2 or less otherwise; clearing the
   tag moves the centre to the truth and the band still contains it.
6. The moment (section 7): `moment(before, after)` -> true when a range's centre moved 5+ points or under fire opened for
   the first time; `monday_lines(changes)` -> at most two lines per boxer, each with what narrowed it ("Strength 58-66,
   narrowed by 2, centre up 1"). No names in any line (S448), no he / she / his / her (S412).
7. Tests: tests/knowledge_test.gd updated to the new groups; tests/know_reads_test.gd covers every read, every stale
   cause, the hype clear, the moment threshold (4.9 = no, 5.0 = yes), the honest-range sweep (1000 random truths and
   exposures: truth inside every band), the word thresholds. Last line `KNOW_READS failures=0`.
   tools/knowbots_probe.gd must still parse (update its calls if a function was renamed; it is the one file outside
   OWNS you may touch, and only to keep it compiling).

## Rules for this seat
Scripts under 500 lines. Pure static modules: Knowledge.gd preloads only Attrs.gd, KnowReads.gd only Knowledge.gd.
Run: `godot --headless --path . --script res://tests/know_reads_test.gd` and the same for knowledge_test.gd. Every
number marked ESTIMATE in the design is a named constant marked `## ESTIMATE`. PR body:
`RESULT: tests/know_reads_test.gd -> KNOW_READS failures=0` and `RESULT: tests/knowledge_test.gd -> <its pass line>`.

## The one trap
"The range never lies" is the whole design: a hype lift, a stale widening and a narrowing read must each keep the truth
inside [lo, hi]. Widen around the shown centre and clamp to 0-100 only after checking the truth is still inside.
