# S491 handover (written 2026-11-15 at the end of S490; S490's digest: ops/research/S490_DIGEST.md)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S491`.

## FIRST - HIS FIGHT DEFECTS (he played the S490 build; "a defect you notice, you fix NOW"; quote him)
1. "remove that from his face": the "Waiting to counter" chip sits over the boxer's face (fight3d IntentChip / reaction
   bubble) - move it off the body (screen-edge lane or under the fighter's panel).
2. Hover tooltips: "about the tooltip i have seen better from you . try harder" - the plan-line hover ("When they tire /
   Your boxer's busiest 30 seconds; it costs energy / Risky: ... Chance to win these 30 seconds: -14 in 100. Your boxer can
   do this.") is plain text with blank lines and a confusing "-14 in 100". Redesign: title, an icon row, the odds as a small
   bar (show, don't tell), one line of why; same for every fight hover.
3. "text out of bound": the LANDED panel's "CALLS THIS ROUND" reads "Draw the lea" (clipped) - wrap or shorten.
4. "wtf is eye": a bare "EYE" label beside the R2/R3 round chips AND top-right of the opponent's panel - find it (grep
   '"EYE"' / 'EYE' in scripts/fight3d + scripts/ui), name it in plain words or remove it.
5. "bars seem to not work": the opponent panel's energy "31-37" draws a small yellow block (the estimate range) instead of
   a filled bar - draw a fill to the low value with the range as a lighter extension.
6. "terrible neck blending" on the corner coach (grey-haired head on a navy shirt: a visible seam at the neck) - the
   coach model's head/body join. Visual gate: a still on the game's own camera, opened by you, then his OK.
7. "the humans do not look normal their shoulders look weird and their walking too", "sometimes you can see through them
   (they seem like arts poorly stitched together)" - the fighters' shoulders, the walk, and see-through bodies
   (backface culling / a missing mesh part / alpha?). Measure first (stills from tools/fight3d_play.gd on the hidden
   desktop, both boxers, guard + walking + mid-move), name the cause per symptom, then fix. Visual gate applies.
Items 1-5 are UI and quick (Claude); 6-7 are look work: brief Grok Dev / Ziva per the roles after the stills.

## HIS BOARD (S490 added; quote each answer at start)
- Q-248 approach card + attribute meters: A Sims bars / B cells / C three answers (C changes the mechanic).
- Q-249 Training K v3 (shown, not written; v2 critics Dola 7/7/7, Maria 6/6/6): build as drawn?
- Q-250 season ladder shown (screen, ask, 12-panel season; John's two holes closed): build after the fight week?
- Q-251 one palette from the gym screen (19 colours; 136 of 314 screen scripts set their own): approve, then the sweep.

## IN FLIGHT (collect, do not resend)
- Qwen WHYGRADE1 LANDED (branch qwen/whygrade1 8b3370c2, docs/WHYGRADE1_RESULT.md): since CARDFIX1 the counter situation
  is fought at place 'outside' where the good plan has 0 lines firing (was 235 fires at counter|long; plan edge +9 -> -1 pp);
  graded good 278/540 vs 375 before. Collect the probe, then fix: the good plan's counter lines must reach counter|outside.
- Arena ROPESCONTRACT1 (arena.ai chat in the browser pane tab; lite relay makes an arena/* PR): run its test on the PC
  + its 5 mutants, merge on 5/5.
- Seat queue SQ181 Dola + SQ182 John: COACHSPEC1 map (ops/research/COACHSPEC1_MAP_S490.md) - his board only at 7+ depth
  from both (S425 rule).

## THEN
- CLASH10 (glove clipping): THREE seat rounds red (CLASH7-9; CLASH9: the knuckle re-solve moves the glove's drawn axis
  after the push; drawn-axis try 0.057 -> 0.120 m). Rule: audit the code yourself (GloveClear push vs Gloves._follow),
  no fourth seat round. Branch qwen/clash9 holds the clash9_log instrumentation (not merged).
- FIGHTWEEK3 leftovers: Train it off / Ask a kilo, favours earned, win band; review notes: Main.gd at 470/470 (move the
  card-act chain into a CardActs.gd router), fall-through tells of the old opponent stay on the bout.
- Miro P0: not redrawn in S490 - the svg marks 12 surplus card slots for deletion; deleting needs his OK (ask once).
- Arena: one pure module (`python ops/Tools/lite_mirror.py --lean push` first).

## USAGE RULES (kept)
- get_usage first; wrap up from ~310k, hand over by 420k. Godot through `python ops/Tools/godot_slot.py run --who s491 --`;
  write a repo-root .tmp_s491_tests.sh runner (S490's: xargs -P 2, timeout, --fixed-fps 60) and delete it after.
- Never `cd` into a worktree; roadmap.json is UTF-8. A seat's probe: read its CELL ctrl_rate yourself (S490: STYLE5's
  control won 1-11% - saturated; calibrate first).

## Known reds (NIGHTLY1): fight_why (WHYGRADE1 on Qwen), plan_bots, block_meet B_A pro_left_hook control row.
