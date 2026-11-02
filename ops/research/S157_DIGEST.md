# S157 digest - 2026-10-03

## What now works
- **MetaHuman trunks waistband is a straight line.** Cause: `Tools/metahuman/mh2_glb.py` picked the trunks as whole body
  triangles by centre height -> a triangle saw-tooth at the waistband and hem. Fix: bmesh bisect along the hem and waist
  planes before the pick. All 4 boxer GLBs rebuilt (an unchanged rebuild of boxer 1 was byte-identical to the shipped
  file first, so the pipeline is reproducible). Still opened: `docs/previews/roomdef1/seed5150_metahuman_trunks_cut.jpg`.
- **Trunks colour matches the scorebug.** Kits were `hash(id) % 5` while the scorebug bar was always red (A) / blue (B);
  75 of 401 generated pairs wore the same colour. `FighterTrunks.fight_kits(a, b)`: each man keeps his own colour, B
  shifts on a clash; `FightWorldLiveScreen` paints both corners with it and passes it to the scorebug bar.
  New `tests/fight_kits_test.gd` 1931/0; mutant (no clash shift) 75 FAIL. Probe at seed 5150: A red = bar red, B blue = bar blue.
- **Legs-up fighter B (ROOMDEF1 item 1)** is the `--script` control arm only; `as_game` at the same seed/frame is clean
  (`docs/previews/roomdef1/seed5150_as_game.jpg`). Left alone: the OFF arm is the byte-identity control.
- **Ops board main page = the plain roadmap** (operator: "tidy up the opsboard ... a detailed roadmap showing what is
  being worked, what is next, who agents are scheduled for what and who are running"). `/` = `Tools/opsboard/roadmap.html`
  (running from live_runs.json; next/waiting/parked/agents from roadmap.json `plan`); old board at `/old`. CLAUDE.md s3:
  the board `plan` is a ship duty.
- Operator asked whether Cline is worth EUR 10/month: answered ClinePass $9.99 = open-weight models (the free stealth model
  ends 10-05); recommended a one-month trial judged by clean merges/week - his money call, no answer yet.

## Evidence
- `run_tests.py --only trunks,scorebug,metahuman,mh2,venue,portrait,fight_kits,walkout,stage_identity,glove --jobs 3`: SUITE total=16 fails=0.
- Parse gate on the 4 touched scripts: fails=0. Commit 5052aa0e.

## In flight (cloud, Arena - collect next session)
Q213H (chat 01a102ff), NIGHTLY1B (01a10320), Q213G-AB (01a10321), RESET1 (01a10329), OVERLAP1 (01a1032a). At 23:10 all
still working (they build Godot from source in their sandbox), no PR yet; ETA ~01:00.

## Next
Collect the 5 Arena PRs (CI log + test sizes + check_workflow, merge with gh), refill each slot from `plan.next`; then
the Q213G punch videos once Q213G-AB confirms contact.
