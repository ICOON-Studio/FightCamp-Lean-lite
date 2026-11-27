# S568 digest (2026-11-27, Opus 5.5)

## On the page (v0.568.1 - v0.568.11, committed, NOT yet on the public test site: his OK first, a push cuts bouts)
- 0.568.1 the range named large in the ring's corner badge (one line, clear of the heads at Inside).
- 0.568.2 the guided first beat: three steps (jab, feet, fight), one pulsing thing each, shown once (localStorage pc_guided).
- 0.568.3 / .4 clock_ui.js: a 5 s beat clock and a 1-minute round clock on one.html (?clock= / ?round= elsewhere; the round
  clock is off on online.html - the server runs the rounds). clock_test.mjs 14.
- 0.568.5 Gemma (local model) on the match server; ?clock=5 on online.html; ops-board button "Play the local AI".
- 0.568.6 - .8 the strip shows the whole boxer in every moment, and lights gold what you are choosing (owner: "the hold
  ground does not appear on the strip", "highlight on the strip which action is being selected").
- 0.568.9 HAND OF CARDS (owner: "the limb selection is confusing", "we will add a lot more options with kicks", "i like the
  B"): hand_ui.js lays the page's own move buttons out as a guard bar + limb-coloured cards (blue lead arm, red rear arm,
  green feet), what does not reach folded away; click or drag onto a strip moment. ?ui=body keeps the old body view.
  hand_test.mjs 12 (a real mouse drag; fits the panel at Long, Mid, Inside).
- 0.568.10 THE LANES: each strip moment has three labelled rows Lead / Rear / Feet in the card colours (owner, with a
  screenshot: "i select stay put and nothing like that appears on the strip").
- 0.568.11 each guard button says what it stops; the strip rows say what each held hand blocks (owner: "both hands have
  the same options").

## Measured / collected
- ONEACT1 (Fable worker; owner's idea "1 action per player ... increase beats"): faster per beat (5.0 v 6.4 clicks, 2.4 v
  3.6 s), NOT per round (12 beats: 56 v 38 clicks, 29 v 22 s). V1 pure one action 1 of 9 bars (jab trading at Long); V2
  (one hand + free feet first) = one.html, 3 of 9 (7 clinches a bout, Long dead, stoppages x2); the feint loop is gone.
  Fable beat Dola on one.html (Fable fun 6 depth 5 clarity 8; Dola 8/8/7). Advice: a toy for the pace, not the main page.
  Found: on V2 a blocked punch pays its counter twice. docs/ONEACT1_RESULT.md.
- COUNTERS1 (Opus worker; owner: "measure the two ideas for marquez and mayweather"): none on the page. M/M2 timed counter
  (Marquez's right lands on the scene; waiting at Long becomes a habit, step in 22%). H2 check hook (Mayweather's hook lands;
  98-100% when it fires = not a read, seed 1 loses a bar). Both weaken the feint loop. Next ideas in the result page
  (hook: an answer for the man stepping in; timed counter: Mid and Inside only). docs/COUNTERS1_RESULT.md.
- SHORTBEAT1 (Arena): none - a one-action opening beat makes every opening a jab or body jab; seed 2 loses a bar.
- TELLS5M (Arena): fails (5th tells round) -> Q-345 on the board: cut it or try once more.
- FEINTFIX2 (Arena, still running at the handover): G1 (the feinting hand does not guard - his correction) 8 of 9 bars on
  both seeds (page 7 / 8), feint 5%, overhand 3-4%; the loop 35 / 53 / 37% (today 38 / 63 / 70, bar under 30%); G2, G3,
  G12 measured on top - read docs/FEINTFIX2_RESULT.md when it lands.
- KICKFIX4 (Arena, still running): on F4 / E3 baseline.

## Tools made
- ops/Tools/versus_by_message.mjs: server=<url> (agents fight on the match server), page=<file.html>, via=ollama, limit=<s>.
- ops/Tools/ollama_seat.py, proto/twohands/site/match_llm_bot.mjs (Gemma: loads only during bouts, leaves a silent
  opponent after 120 s, takes the next free name after a restart). Measured: no chat agent answers a beat under 19 s; the
  local gemma4:12b answers in ~1.5 s ONLY with think=false and num_ctx 8192.
- tools: clock_test.mjs, online_clock_test.mjs, hand_test.mjs; scene_check.mjs tweak= (by COUNTERS1).

## Open with the owner
His play of the hand of cards + lanes; head moves onto the main page (measured first) or drop the Head row; Q-345 tells;
the public push of 0.568.1-11; counters round two or park; keep three moments or work on one action; the 1.9 GB AMD usage
log on C: (C: AMBER 12.7 GB; his file, not touched).
