# TASK PROGP3 - attributes on the fight board: how much does each one decide? (S560, probe P3 of DESIGN_PROGRESSION1)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches).
Seat: Arena, its own clone of the code mirror. Estimate: 2 hours (a small tool, then runs).

## Why
`ops/research/DESIGN_PROGRESSION1.md` section 3d proposes that FOUR of a fighter's attributes set his numbers on the
fight board, with a small spread: durability = health 16 to 20 (today every man has 18), stamina = the stamina bar 7 to 9
(today 8), recovery = stamina back a beat (1, or 1 with one more every second beat), defence = guard 5 to 7 (today 6).
The owner asked "should we also add attributes progression and rpg elements ?". The rule here: a lever is MEASURED on the
rules before it is designed further. Today every number is one shared `N` for both men: nothing per man exists.

## Do
1. Read the rules: `proto/twohands/order.html` above its `// ---- the page` mark (`N`, `man()`, `cost`, `resolve`,
   `endBeat`, `solveBeat`, `worth`), `proto/twohands/tools/rules.mjs` (how tools load them, `load(seed, page, patch)`), and
   `proto/twohands/tools/balance.mjs` (`bouts`: how the solved mix plays itself; `tweak` and `src`).
2. Build `proto/twohands/tools/probe_attributes.mjs`: it loads the page's rules through rules.mjs with a `patch` (a text
   replacement at load time - the page file is NOT edited) so that each man carries his own health, stamina bar, recovery
   and guard (fields on the man, falling back to `N`), then plays the solved mix against itself (`who=mix opp=mirror`
   style: both men from `solveBeat`) with man 0 and man 1 given DIFFERENT sets. Arguments: `a=hp:20,st:8,rec:1,guard:6
   b=hp:16,...  n=<bouts> jobs=<n>`. Output: wins / draws / stoppages for A, knockdowns each, and the usual per-switch
   use for each man. The look-ahead table (`vtable.json`) was built for equal men: use it as it is and SAY SO in the
   result (it is an approximation for unequal men).
   "recovery +1 every second beat" = one more stamina back on beats 2, 4 and 6 of a round.
3. `proto/twohands/tools/probe_attributes_test.mjs` (node:assert, like rules_test.mjs): equal sets give man 0 the same
   bouts as balance's mirror with the same seed (or, if seeds differ by construction, 45-55% over 200 bouts); a man with
   health 20 is knocked down later than one with 16 in a fixed beat script; the patch throws if a pattern is not on the page.
4. ONE-REP TRIAL first: n=24 for health 20 v 16. If A wins over 85%, stop and report (the range is too wide to go on).
5. The runs, n=84 each, A v B:
   - one attribute at a time, top v bottom, the others at today's value: health 20 v 16; stamina 9 v 7; recovery
     (1 + every second beat) v 1; guard 7 v 5;
   - one step each: health 19 v 18; stamina 9 v 8; guard 7 v 6;
   - the best set v the worst set (20 / 9 / recovery+ / 7 v 16 / 7 / 1 / 5);
   - a sideways pair: health 20 + stamina 7 v health 16 + stamina 9.
   Save each as `ops/research/s558_balance/results/attr_<name>.txt`. COMMIT AND PUSH after every finished run.
6. `docs/PROGP3_RESULT.md`: one table - pair | A wins of decided | stoppages | knockdowns A / B | what changed in how each
   man fought (the two switches whose use moved most). Bars from the spec: health 20 v 16 alone 55-62%; best v worst at
   most 70%. Then: which attribute is worth the most per step, which is worth nothing (under 52% top v bottom), and the
   range you would give each so the best v the worst set lands at 65-70%. Plain words.

## Feedback loops
- Attributes -> health / stamina -> wins -> (in the career) better opponents and more training -> attributes. On this
  board there is no loop: sets are fixed for a bout. The career loop is capped by matchmaking by rating and by the
  bounded ranges; this probe measures only the first arrow.
- Stamina bar -> more punches a beat -> shorter bouts: watch stoppages (bar 10-40%) in every pair and flag any pair
  outside it.
- One-rep trial: step 4.

## Not allowed
Change no page, no existing tool and no existing test. Node only; no Godot, no images. Do not commit `*.vt.json`.
Open ONE pull request at the end; never merge it. Delete no test.

## Contract
- OWNS: proto/twohands/tools/probe_attributes.mjs, proto/twohands/tools/probe_attributes_test.mjs,
  ops/research/s558_balance/results/attr_*.txt, docs/PROGP3_RESULT.md
- RED_TEST: proto/twohands/tools/probe_attributes_test.mjs (fails today: the tool does not exist)
- REGRESSION: rules_test.mjs 37 passed, page_play_test.mjs 4 passed (run both; nothing they read is edited)
- VISUAL: none
- RESULT lines for the pull request body: `RESULT: proto/twohands/tools/probe_attributes_test.mjs -> <its pass line>`

## Prior research
ops/research/DESIGN_PROGRESSION1.md (sections 3d, 5, 6); docs/RINGSWITCH_S558.md (the bars and how balance.mjs is read).

## What would a human do?
A designer gives two test fighters one different number, plays a few hundred bouts, and sets the range from the result.

## Prefab check
Not applicable (our rules).
