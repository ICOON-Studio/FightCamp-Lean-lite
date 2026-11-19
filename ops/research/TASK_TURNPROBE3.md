# TASK TURNPROBE3 - rerun all nine turning-pro lines on today's code, each line defined (probe, no screen)

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.
Why: a fresh critic of the turning pro map v4 (ops/research/DESIGN_TURNPRO1_V4_CRITIC_ARENA.md, 10/10 items 1 and 7) said
the map tunes against TURNPROBE2 numbers measured BEFORE the S529 ticket-price fix (ProCall.money now pays the deal's own
price), and that some lines have no stated population or objective. Decision S530 (Claude, CLAUDE.md item 8): no v5 map
and no rule change until the nine lines are re-measured on main. tools/turn_pro_probe2.gd stays as it is (copy it).

## What to change in the copy (tools/turn_pro_probe3.gd)
- Run on today's main (the price fix is in). N = 30 careers a bot, same seeds as TURNPROBE2.
- For EVERY line print, on one line above its number: the population (which careers / offers / debuts count), the
  objective (gym cash, boxer cash, or both), and the seeds.
- Line 4: count stipend debuts only (the line is about the stipend stopping), and say so.
- Line 7 (best ask): keep TURNPROBE2's forward plays per ask from one snapshot; add the share of offers where the price ask
  is best and its mean gym cash edge. Prove the snapshot: "no ask" twice from one snapshot ends to the dollar.
- Win-rate line: a PAIRED check - the same boxer, camp and plan against opponents at gap 0.7, 1.0 and 1.5 (the two houses'
  gaps are 1.0 and 1.5 in ProCall.promoters); print the debut win rate per gap. Do not let the house choice stand in for
  opponent difficulty.
- Declines: print how many careers reach a third decline (door shut) under a bot that refuses when terms fall below 0.8.
- Keep every other line as TURNPROBE2 prints it.

## Contract
OWNS: tools/turn_pro_probe3.gd, docs/TURNPROBE3_RESULT.md (and tools/turn_pro_probe3_fork.gd if a split is needed)
RED_TEST: tools/turn_pro_probe3.gd -> TURNPROBE3 done
REGRESSION: pro_call_test, pro_offer_wire_test, pro_contract_test (read-only: run them, never edit them)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/, tools/turn_pro_probe.gd, tools/turn_pro_probe2.gd, older result pages.
PR body: `RESULT: tools/turn_pro_probe3.gd -> pass=<n>/9 line4=<pct> line7=<ask:pct,...> gap_win=<0.7:x,1.0:y,1.5:z>`.
Each file under 500 lines. Pilot first and print the projected time; stop at 90 minutes (cut N to 20 if needed).

## Prior research
docs/TURNPROBE2_RESULT.md, ops/research/DESIGN_TURNPRO1_V4.md (s7 pass lines), the critic file above (items 1, 7, 8 only).

## What would a human do?
Before changing a contract offer, check the books on the current terms - and test a harder opponent on the same fighter,
not on a different one.

## Prefab check
None: a copy of tools/turn_pro_probe2.gd.

## The one trap
Re-read ProCall.money after the S529 fix before copying TURNPROBE2's price arm: the deal's own price is paid now, so any
probe-side price override must go.
