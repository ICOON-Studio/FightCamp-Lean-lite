# TASK COUNTERS1 - the two counters the famous exchanges are missing: Marquez's timed right, Mayweather's check hook (S568)

Kind: probe. Model: Opus 5.5 console worker (PC). Discipline: boxing (Puncher's chance, order.html).
Seat: console worker in the main checkout - read ops/research/WORKER_S566.md first (commits by pathspec, no questions,
watchdog before each heavy run, jobs=1 while ArcheAge is in the watchdog's top list). Estimate: 3-5 hours.

## Why
Owner S568, after the SCENES1 film check: "measure the two ideas for marquez and mayweather". docs/SCENES1_RESULT.md: 10 of
14 checks match the ring; the two MISMATCHES are counters our page cannot make:
- MARQUEZ v PACQUIAO IV: Pacquiao steps in behind a jab; Marquez's short right MEETS him as he arrives. On the page a lone
  punch is always moment 1, when Pacquiao's hands are still home: blocked. The page cannot TIME a counter.
- MAYWEATHER v HATTON, the check hook: Hatton rushes in; Mayweather turns out and the lead hook meets him. On the page the
  step in cancels the back off ("his step in cuts you off" switches the pull counter off) and held rear hands block both hooks.

## Prior research
- docs/SCENES1_RESULT.md (the four exchanges, ideas 1 and 4), proto/twohands/scenes.js, tools/scene_check.mjs.
- MOMENTGAP1 (docs/MOMENTGAP1_RESULT.md): a FREE WAIT anywhere lost two bars (A); feet-only wait held (B,
  ops/research/s558_balance/moment_gap_b.json - the tweak format to copy). Idea 1 is narrower than A: only a lone HAND punch
  may wait, and the wait only pays against a man who stepped in.
- The pull counter today: order.html around lines 241-260 (`pulled`, `cutOff`, `dmg = a.d + counter + pull`).
- FEINTFIX2 is running at Arena on the feint: do NOT touch the feint rules; measure on today's page.

## What would a human do?
A designer would add the smallest rule that lets each real exchange happen, check the exchange now plays as it did in the
ring, and then check the rest of the game did not tilt (the counter does not become the only way to beat a man who steps in).

## Prefab check
None: rules of our own page. Reuse balance.mjs, scene_check.mjs, probe_clinch.mjs, the MOMENTGAP1 tweak pattern.

## The versions (tweaks: `src` patches above `// ---- the page`; order.html is never edited)
- M (MARQUEZ, the timed counter): a plan with exactly ONE hand punch and no feet may put a wait before it (the punch goes
  in moment 2). That punch is a counter (+1 damage, and it beats his slower punch as counters do today) ONLY when the other
  man stepped in during moment 1 of this beat; otherwise the wait only costs the moment. The look-ahead and both men's plan
  lists know the new plan.
- H1 (MAYWEATHER, the check hook - bonus only): a LEAD HOOK thrown after your own back off in the same beat keeps its pull
  counter (+1) even when his step in cuts you off (today it is switched off).
- H2 (H1 + the angle): as H1, and in that case his held rear hand does not block it (he is turning into it). Only if H1
  does not make the Mayweather exchange land.
- MH: M plus the better of H1 / H2. Only if each passes alone.

## Do
1. Add `tweak=<file.json>` to tools/scene_check.mjs (add-only: no argument = today's output byte for byte) so an exchange
   is played on a tweak. Today: `node proto/twohands/tools/scene_check.mjs` prints 10 of 14.
2. Per version: write the tweak; `node --check`; scene_check on it - its exchange must flip to MATCH and no other check may
   turn to MISMATCH (report all 14). If it does not flip, fix the rule (write why) before any table.
3. One-rep trial: `balance.mjs table tweak=... out=E:/FightCamp/wt_tmp/COUNTERS1/<v>.vt.json`, `play n=12 seed=1`: it
   loads, the new plan is chosen at all. Then `play who=mix opp=mirror n=84` seeds 1 and 2, and opp=0|1|2 n=84 seed 1.
   Control: today's page the same way (or reuse ops/research/s558_balance/results/feintfix2_g0_s1.txt / _s2.txt if they
   are the same runs - say which). Save `ops/research/s558_balance/results/counters1_<v>_<run>.txt`, commit + push each.
4. The feint loop on each passing version: `node proto/twohands/tools/probe_clinch.mjs` with the tweak (as FEINTFIX2 ran
   it: loop + no clinch, n=60) - report beside today's 38 / 63 / 70%.
5. `docs/COUNTERS1_RESULT.md`: one table (version x seed: bars passed, each red bar's numbers); how often the new counter is
   chosen and lands; step in and Long shares beside today; scene_check 14 lines per version; ONE line for the owner: which
   version (if any) goes on the page as a toy, and what the player would see. Last line `COUNTERS1 DONE` or
   `COUNTERS1 BLOCKED: <why>`.

## The bars
- The page's nine bars on both seeds: at least as many as today on the same seed; never losing "mirror 40-60%".
- Its exchange MATCHES on scene_check; no other check turns to MISMATCH.
- The new counter is a choice, not a must: chosen in 2-15% of beats, landing 45-75% when chosen.
- Stepping in stays alive: step in at least 22% of beats (today 32-34%); Long at most 45% of beats.
- The feint loop is not worse than today against any man.

## Feedback loops
- A counter on a man who steps in -> stepping in costs more -> fewer step ins -> more beats at Long -> the jab carries more
  -> less need to step in: capped by the "step in at least 22%" and "Long at most 45%" bars; the n=12 trial reports both
  before any n=84 run; if step in falls under 22% at n=12, stop that version and say so.
- M's wait -> the waiting man's hands stay home a moment longer -> he guards more -> fewer punches land: report health
  dealt a round beside today (under 90% = failed).
- None other: damage numbers, reach and the judges are untouched.

## Contract
OWNS: ops/research/s558_balance/counters1_m.json, ops/research/s558_balance/counters1_h1.json,
ops/research/s558_balance/counters1_h2.json, ops/research/s558_balance/counters1_mh.json,
ops/research/s558_balance/results/counters1_*.txt, proto/twohands/tools/scene_check.mjs (tweak= only, add-only),
docs/COUNTERS1_RESULT.md
RED_TEST: none (a probe; scene_check's two MISMATCH lines are the red today)
REGRESSION: node proto/twohands/tools/rules_test.mjs; node proto/twohands/tools/scene_check.mjs (unchanged without tweak=)
VISUAL: none (no page change)

## Not yours
order.html and every page file, ring_ui.js / body_ui.js / strip_ui.js / clock_ui.js / version.js, the feint rules. No push
to the public test repo. The game is Puncher's chance: never Ring Switches in a result.
