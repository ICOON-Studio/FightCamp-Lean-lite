# S324 digest (2026-10-31) - Lean update 27: money that bites + the body view on her own body

## Board at start
- Q-S294-42 (update 26): "Body view unclear"; markup C149 point 1: "looks terrible needs to be bigger and look like a human
  stop doing cube things as limbs".
- Q-S294-43 (Ziva): "Keep free, Claude checks" - Ziva stays on the free model; Claude opens every Ziva screenshot first.

## What now works (Lean main)
1. Body view on her own body (e9cd229). `tools/bake_body_masks.gd` bakes `assets/ui/body/<stem>_mask.png` (each opaque body
   pixel -> nearest track stroke in stroke widths; head/neck untinted). BodyFigure draws her portrait as a child TextureRect
   behind its own drawing with a mask shader: each part's Burn colour over her shading; fresh parts (Burn <= 12.5) stay her own
   skin, full colour from 30 (the blue-for-fresh "statue" read was dropped). Figures: fight panels 150x210 -> 210x294, pages
   120x168 -> 168x235, corner 160x226 -> 190x268. Strokes stay as the fallback for a portrait without a mask.
2. Money that bites (8c8e476). GymBills (Qwen, 6aaadf8) in the weekly clock: dues $35/month (Membership.weekly_dues via
   GymBills), rent + England Boxing fees replace the $500 upkeep, start cash Career.start_cash() = $14,600 (3 months of rent,
   fees, sessional coach, one stipend). Career.weeks_below / closed; end_week runs GymBills.next_below/status; MONEY shows the
   runway + break-even members; LOW CASH (amber) / BELOW $0 (red) flags and a HOME need that never blocks time; closed = the only
   need, the clock stops, a locked close screen (New career / Load / Title). A loss costs 3 members + 2 reputation (stoppage 5 + 4).
   tests/money_close_test.gd (red arm + rich control arm). Lean CLAUDE.md "Decided numbers" updated.
3. Balance-check: `tools/career_harness.gd` plays 26-week careers through Main.act. One fixed careless player closed 40/40 in
   week 20 (the game is deterministic per day: every career is the same story) -> careless became a population (four habits,
   each on with p 0.5). 40 careers each: careless closes 23 % (bound 15-40 %; every closure = full-time head coach + no
   sponsor), sensible 0 % (bound < 5 %) ending ~$18,000.
4. Qwen collected: InjuryRoll (bece0ee, 13/13 incl. real-world bounds: 6 % a bout, 72 % head/face, mean 28.6 days, load
   spike 2.83x), TrainingLoad (dc64cf1). BodyReport running (TASK_BODYREPORT1, branch qwen/bodyreport1).
5. Export: tools/export.sh green (every test), Builds/FightCamp.pck carries the masks + GymBills + InjuryRoll.

## Evidence
- Stills: previews/s324/bodyview_before_after.png, round3_bodyview.png, corner_card_bodyview.png (game camera,
  burn_probe + fight3d_play on the hidden desktop); review board S324; Q-S294-45 asks his verdict.

## Traps
- hidden_desktop.py run of Builds/FightCamp.exe from the Lean folder runs the PROJECT (project.godot in cwd), not the pck -
  check the pck contents (or run from elsewhere) before calling it an exe proof.
- board_reconcile marks a Lean-repo Qwen run "dead" (it looks for the worktree in the Game repo): read the out file first.
- A deterministic game gives one career per policy: a balance harness needs a population of players (habits by seed).

## Not done
- Miro production map not moved this session (context budget at 313k): next session moves P0/P5/P6 cards for update 27.
- Update 28 wiring (InjuryRoll into bouts/weeks/fighter page/booking) - next session's first build item.

## HANDOFF
Next: S325 reads Q-S294-45, wires update 28 injuries, reruns the harness with injury bounds, collects Qwen BODYREPORT1.
Model: Opus 5.5 at medium effort, Fast off (integration across Bouts/Sim/UI + balance tuning).
