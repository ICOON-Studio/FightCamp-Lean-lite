# S459 handover (written 2026-11-13 at the end of S458; S457's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S459`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k context; wrap-up from ~395k. At most TWO helper sessions / subagents at once.
- Never idle while a test or agent runs: run_in_background and do the next item.

## HIS BOARD MARKS THIS SESSION (C370-C381, all seen; answer by point when done)
- Fight HUD (ops/Feedback/2026-11-13-29..33, p06e_round2_live.png): 1 remove "lasts to R3"; 2-3 the body-map count badges "look bad
  and stop using tubes everywhere"; 4-6 the call cards' words (Risky / Works / Beats it) -> "remove, show what it affects, numbers
  and icons and use tooltip for text"; 7 "how save and own game work together?" (answered: Save = PACE, Own game = AIM - RENAMED "Take initiative" S458 at his reply; the
  AIM heading sits over Save - give the two rows a gap and their own headings); 8 "what does that mean?" on the corner's read
  "Working ?" -> DONE S458 at his reply: "Stamina 69 ?" (the number + ?).
- Office desktop (ops/Feedback/2026-11-13-25..28): "i like it"; the staff circles bigger; the money panel repeats the top bar ->
  "maybe show something else here" (Claude's pick: club members + the next bills by date).
- Block reel C370: "no reactions and way too much clipping with the gloves, you are standing the fighters too close, check other games
  numbers on that" -> measure the stance gap in the installed boxing games (REA, read-only) before changing ours.
- Hips C371: "not bad but can be improved a lot".

## HIS LATE S458 ASK (the corner's read)
- He: "shouldn't you hide the number" -> DONE: the read shows "Stamina ?" while the corner only has a range. Then: "it should be able
  to be revealed, do we have mechanics missing?" -> YES: today the range is fixed for the whole bout (SidePanel WIDE 16 / NARROW 6
  after 3+ film sessions; legs and guard "?" unless filmed); nothing in the fight narrows it. READREVEAL1 (design map first, critics
  7+, then build): each watched round narrows the range (corner reads breathing / stool walk / hands, the TheRead looks idea), faster
  with film, the head coach's rating and the fighter's Fight IQ; within about +-2 the "?" becomes the number; legs and guard go ? ->
  word -> number the same way; a known-tired opponent is what makes "go to the body now" a real call.
  HIS ADD (after the handover): "maybe add a corner option to waste few seconds to get a reading estimate of the opponents stats" ->
  a corner-minute job "Read her" (a few seconds of the minute watching the other corner): the range narrows a step, paid for by your
  own fighter's rest (less of the minute's quick-energy refill, Combos.refill) - read vs recover, decided each minute. Trace the
  corner minute's jobs (CornerJobs / corner card) before sizing it.

## DONE IN S458
- POWER1D LANDED (the animation item): the S456 quick hand-back - the lead uppercut's clip holds on its contact 0.10 s, then her
  usual guard - plus the S457 test contract. Lead uppercut 0 of 25 red (was 21). Regression: join_return 0, hit_frame 11 = main,
  hit_carry 35/41/45 (main 43-44; the lead row green), punch_speed noise, fight_feel/beat_clips/head_aim/file_limits 0. Film seed
  4242 + 7 on the review board (docs/mockups/s458/power1d). One shot shows a 24.5 m/s glove jump in the LAST frame BEFORE the hit
  (the approach, PunchReach's arrival, not this patch) - worth a look with the rear uppercut.
- Training J (docs/mockups/s458/training_j): from the S457 Claude I critic's code-traced drawing; 7 session icons + neck redrawn in
  the Playbook's block ink (a pixel-ink pass over Ludo's pictures: scratchpad inkify, icons in training_j/icons/). Critics J: Dola
  7/8, Claude 6/5 - its catch: sparring adds nothing to a move under 30 (PadWeek), so the check hook is not READY Friday and the
  65/10 split changes nothing (the fight week's Monday pads make it Usable anyway).
- COACHMARKET1 (Qwen) briefed + collected: scripts/rules/CoachMarket.gd (four assistants, growth to ceilings, second slot, Signature
  rate, footwork x1.2, let-go a week's pay, role-word milestones). Not wired.
- StyleName fix: the named style lives in f["named_style"]; f["style"] is every fighter's base style word (AttrGen tilts/dials,
  Attrs.from_stats, BoutBurn) - the Monday check would have reshaped stats.
- PROREAD1 (Qwen, map M7: target line, split, feint, READ-PROOF, as shares) launched 20:45 - collect it first.
- 39 stale "queued" dispatch rows superseded (Cursor retired; old briefs).

## NEXT (Claude) - roadmap now.next_action has the same list
1. FIXS458: his board marks above (HUD + office), stills to the review board, answer by point.
2. Collect PROREAD1 by diff + parse + test (the_read, plan_lines, file_limits, no_pronoun).
3. Training K from TRAINGAME_CRITIC_S458_J_CLAUDE.md + _J_DOLA.md: every gain counted to the first bell; the shared evening priced in
   wins for both fighters; Playbook move cards dragged onto the coach's evenings; the week-twist card, diet, kg on mornings; the logic
   slips (peak week spars twice; film outside a camp has no rule - say so or add one; Usable, not READY; one set of stat names; the
   profile tab's numbers = the scene's); Dola's presets + per-fighter tiredness sparklines. Fresh Claude + Dola; two at 7+ -> board.
4. Wire StyleName (named_style): Duels OPEN (range_open), Combos spend (combo_energy), plan mid/counter edge, pressure answers,
   Knockdowns; the Monday check; plan_cap where the plan's line cap lives. Tests that play the fight path.
5. POWER1E: the rear uppercut into QUICK_BACK_S at 0.10 + its own uppercut_tail run (rear BACK 5/5 red today).
6. Kalli SQ71 / John SQ72 (fight week v6) are in ops/research (AMATEURWEEK_CRITIC_S455_BRIEF_KALLI/JOHN.md, uncommitted): read,
   commit, act.

## TRAPS (S458)
- The previous session's helper subagent can still be writing in the tree: a file that changes under you = check the last session
  before assuming. S457's helper wrote a MUTANT value (QUICK_BACK_S 0.45) into BeatClips.gd for a few minutes; it is not the fix.
- tools/export.sh copies docs/WHAT_TO_TRY.txt over Builds/WHAT_TO_TRY.txt: edit the docs/ copy.
- Miro: S457 removed surplus slots, so some ids in where_we_are_miro.json may be gone - "Miro did not confirm" on an update = read the
  id; if it is gone, create it fresh (no data-miro-id) and `learn` the result. Never send the module's data-deleted lines without his OK.
- Python json on Windows: always open with encoding='utf-8' (cp1252 crashes on roadmap.json).
