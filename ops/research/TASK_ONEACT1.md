# TASK ONEACT1 - one action a beat, more beats: build it as a trial page, measure it, playtest it (S568)

Kind: probe. Model: Fable 5.2 console worker (PC; owner S568: "assign a fable worker for it and then test it fable vs dola"). Discipline: boxing (Puncher's chance, order.html).
Seat: console worker in the main checkout - read ops/research/WORKER_S566.md first (commits by pathspec, no questions,
watchdog before each heavy run, jobs=1 while ArcheAge is in the watchdog's top list). Estimate: 4-6 hours.

## Why
Owner S568: "i am think to make a version where 1 action per player instead of 3 (increase beats) to see if it s faster
and feels better , can you assign an agent to try that and playtest it". Today a beat is up to three moments (lead hand,
rear hand, feet, in an order the player sets), 6 beats a round, 3 rounds. His version: each player does ONE action a beat,
and a round has more beats. The question is his: is it FASTER to play, and does it FEEL BETTER. Answer both with evidence.

## Prior research
- SHORTBEAT1 (Arena, running now, branch arena/2a3d0ae3 on FightCamp-Lean-lite): only the FIRST beat of each round as one
  action. Read its result if it has landed (docs/SHORTBEAT1_RESULT.md on that branch) - its beat-1 counts are the nearest
  evidence; do not wait for it.
- MOMENTGAP1 (docs/MOMENTGAP1_RESULT.md): how a rules patch is written as a tweak (`src` patches above `// ---- the page`)
  and turned into a copy page (proto/twohands/tools/make_wait.py builds wait.html; make_punch.py builds punch.html).
- The league (ops/research/versus/LEAGUE.md, LEAGUE_CLAUDE.md): the feint-then-overhand is the broken plan of the
  three-moment beat. Say whether one action a beat removes it, keeps it, or makes a new one.
- TORIBASH_NOTES_S567.md: short turns that grow.

## What would a human do?
A designer would not argue it - they would make the one-action version playable next to the old one the same day, play
both, count the clicks and seconds, and keep the one that plays better. So: a copy page he can click, the numbers, and
blind-ish playtests of both.

## Prefab check
Nothing to find outside: it is a rule change on our own page. Reuse make_wait.py's pattern, balance.mjs, play_cli.mjs,
beat_shot.mjs.

## The version (V1 - change nothing else)
- A beat is ONE moment. Each man picks exactly one action: a lead-hand punch, a rear-hand punch, a step (in / back off),
  a push off or a clinch (Inside, as today), or nothing (both hands home). The hand that does not punch stays held high or
  low as he sets it (the guard is posture, not an action - it stays free, as today).
- No order strip choice (one action has no order). The strip shows one slot each side.
- Beats a round: 12 (V1). Stamina: keep the per-ROUND budget near today's - today 6 beats x (rec 1 + 1 per hand held);
  with one action a beat a man holds at least one hand every beat, so recovery must come down. Pick N.rec / N.hold so the
  mirror's stamina-spent-a-round lands within 15% of today's (one trial run decides; write the numbers you chose).
- Everything else as today: damage, reach, speeds, guards, counters (+1 after his miss or block LAST beat now, since there
  is no "later in this beat"), knockdowns, judges.
- If V1 fails a bar the old page passes, try ONE V2 of your own (for example 9 or 18 beats, or the step free of stamina)
  and say why.

## Do
1. Tweak `ops/research/s558_balance/oneact_v1.json` (src patches only; order.html is never edited). Check `plansFor`,
   `resolve`, `endBeat`, `cost`, `ordOf` and the AI's choice respect one action. `node --check` / page_parse after.
2. One-rep trial: `balance.mjs table tweak=... out=E:/FightCamp/wt_tmp/ONEACT1/oneact_v1.vt.json` then `play n=12`.
   It loads, the solver plays one action, and beats a round are 12. Stop and fix if not.
3. Full: `play who=mix opp=mirror n=84` seeds 1 and 2, and `opp=0|1|2` n=84 seed 1 - today's page the same way as the
   control (or reuse the latest control numbers in results/feintfix2_g0_s1.txt / _s2.txt if they are the same runs).
   Save each to `ops/research/s558_balance/results/oneact_<v>_<run>.txt`, commit + push after each.
4. The page: `proto/twohands/tools/make_one.py` builds `proto/twohands/one.html` from order.html + the tweak (the pattern of
   make_wait.py: rules patched, page words patched - the help box, the strip with one slot, "Choose your move"). Then
   `page_parse` and `page_play_test.mjs one.html` (green), and `beat_shot.mjs` on 3 beats: open its pictures with your file
   tool - his camera, nothing near the men, the strip shows one slot each side.
5. SPEED (his "faster"): per round, for both pages: decisions a player makes, clicks needed (a plain beat and the busiest
   beat), and the seconds the page spends playing a beat's pictures (time the page in headless Edge with beat_shot.mjs, or
   add up the page's own setTimeout steps). One small table: today v one action.
6. FEEL (his "feels better") - A MATCH, FABLE V DOLA (owner S568: "then test it fable vs dola"), on one.html:
   a. versus.mjs already takes `page=one.html` (S568: `new` stores it, show / plan read it). Make versus.mjs `plan` REFUSE a
      plan with more than one action when the page's rules say one action a beat (read it from the loaded rules, e.g. an
      `N.one` you add in the tweak), with the words the player needs ("one action a beat: a punch, a step, a clinch or
      nothing"). Same check in play_cli.mjs (add `page=` to its `new` too; old calls must keep working - it is imported LIVE
      by running playtests). page_play_test + rules_test stay green.
   b. When one.html passes step 4, create the empty file `E:/FightCamp/wt_tmp/ONEACT1/READY_FOR_MATCH`. The main session
      then starts the driver for Dola: `node ops/Tools/versus_by_message.mjs E:/FightCamp/tmp/versus/fable_v_dola_one
      a=fable:worker b=dola:dola page=one.html` - it creates the bout file `E:/FightCamp/tmp/versus/fable_v_dola_one/bout.json`.
   c. YOU are side a (via=worker: the driver waits for you). Each beat: `node proto/twohands/tools/versus.mjs show <bout.json>
      who=a`, think, `node proto/twohands/tools/versus.mjs plan <bout.json> who=a <your one action>`; then wait (a few
      seconds between looks) until the beat is played. PLAY TO WIN. Wait up to 15 minutes for the bout file to appear.
   d. After the bell write `E:/FightCamp/tmp/versus/fable_v_dola_one/VERSUS_FABLE.md` (the driver waits for it): the two beats
      that decided it, what Dola did that you could read, FUN / DEPTH / CLARITY / SPEED 1-10, ONE ACTION v THREE MOMENTS (you
      know both: which is faster, which feels better, and why), TO REACH 10/10 (three changes). Dola's verdict lands as
      VERSUS_DOLA.md in the same folder: quote both in the result.
   e. If the match has not started 30 minutes after READY_FOR_MATCH, play 2 bouts on each page through play_cli.mjs
      instead (opp 0 and 2, alternating pages) and give the same verdict per page.
7. Result: `docs/ONEACT1_RESULT.md`: the nine bars by version and seed beside today; the speed table; your verdicts; is the
   feint-overhand loop still there (run probe_clinch.mjs / probe_feint.mjs on the tweak if they take one); and ONE line for
   the owner: show him one.html, or not, and why. Last line `ONEACT1 DONE` or `ONEACT1 BLOCKED: <why>`.

## The bars
- The page's nine bars on both seeds: at least as many as today on the same seed; never losing "mirror 40-60%".
- A beat is a decision: no single action in over 40% of beats; "nothing" in 5-30%.
- Rounds do not get duller: health dealt a round within 15% of today; knockdowns a bout 0.5-2.5; stoppages within 8 points.
- Faster: fewer clicks a round than today, and the page's playing time a round not over today's by more than 25%.

## Feedback loops
- Fewer actions a beat -> more hands held -> more stamina back -> more punches later: capped by the recovery numbers set in
  step 1 (stamina spent a round within 15% of today); the one-rep trial checks it before any table.
- More beats -> more chances for his habit read (two of the last three punching beats) -> he reads more often: report his
  reads a bout beside today; over 1.5x today = say so (the window may need to be the last 4 or 6 beats).
- None other: damage, reach and the judges are untouched.

## Contract
OWNS: ops/research/s558_balance/oneact_v1.json, ops/research/s558_balance/oneact_v2.json,
ops/research/s558_balance/results/oneact_*.txt, proto/twohands/tools/make_one.py, proto/twohands/one.html,
proto/twohands/tools/play_cli.mjs and proto/twohands/tools/versus.mjs (the page= option and the one-action refusal only, add-only),
docs/ONEACT1_RESULT.md
RED_TEST: none (a probe; the bars are the test)
REGRESSION: node proto/twohands/tools/rules_test.mjs; node proto/twohands/tools/page_play_test.mjs order.html; node proto/twohands/tools/page_play_test.mjs one.html
VISUAL: beat_shot.mjs pictures of one.html, opened with the file tool (his camera, nothing near the men)

## Not yours
order.html, ring_ui.js, strip_ui.js, body_ui.js, version.js (the main session adds the changelog line and the ops-board
jump button when it collects you). No push to the public test repo. Never Ring Switches in a result: the game is
Puncher's chance.
