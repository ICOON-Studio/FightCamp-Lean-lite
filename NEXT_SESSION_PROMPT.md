# S382 - next session (written S381, 2026-11-04)

START in E:\FightCamp\Lean: `git pull && python ops/Tools/agent_comms.py start`. The S380 prompt is in git history.
FIRST: `list_sessions` - S381 may still be live with workflows running. Collect what they pushed; never redo it.

OPERATOR RULES FROM S381 (memory has them):
- EYES ONLY: "always use eyes skill stills will not show the problems clearly". Every motion check = `eyes index` ->
  `eyes burst <ref> <t> --count 12 --span 1` -> `eyes crop <ref> <t> --box ...` on elbows/shoulders/knees/feet, on the VIDEO.
  Never ffmpeg stills or contact sheets as evidence - yours or an agent's. Every brief says so in those words.
- List UNSEEN board comments (`seen_by_claude: false` in ops/AgentComms/media_comments.json), never "the last N".
- Before offering any download/purchase, search C:/Users/user/Downloads (475 fight FBX, Mixamo S116 set + Punch PRO zips),
  E:/FightCamp_backup_D/sources (mixamo, quickmagic), packs, licensed. "we already have these files wtf".
- Playbook = ONE page, no tabs ("all these are the same scene wtf"). Menu art = the Fight Camp ink cards.
- The plan obeyed is the fun ("told it do the 1-1, step in go body and the fighter actually did it"): keep PLANCOMBO1.
- No holo panels during live rounds (holo in the corner minute).
- Long/repeated combos get READ by the opponent; each fighter carries the same plan differently (traits per playthrough).

PC: E: at 4.6% free (pagefile.sys 32 GB on E:) -> watchdog RED; operator asked to move the pagefile to C: (his setting).
Starfield open = RAM 90%+. Renders wait for non-RED; headless tests may run when the ONLY RED reason is E: space.
agy: Argon credits ran out (429 "credits balance too low"); seat_dispatch now falls back to claude-opus-5-5-high (be417e39).

STATE AT THE PC RESTART (S381, ~14:30): pushed - camp2 5723346a (stages S1-S4 + G1 done; G2 weeks strip was running;
G3-G5, review, suite, stills NOT done -> resume from G2), footwork1 8baae2b0 (round 3 hips fix, verified + sent to the
operator), boxmap1 2a114efb (round 5 FILMED, tests green - NOT yet eyes-checked by Claude or the reviewer: do it before
sending), holo-off-live 8137028a (callouts moved; film + suite may be unfinished), movepics1 656cfe44 (round 2 re-bake
was running, nothing pushed), theatre-ground 490cead5 (round 2 per-body grounding NOT started: sweep at 9.5-10.6 s still
floats). Killed by the restart, redo: owned-mocap bake (inventory done - E:/FightCamp/tmp/s381/ownedmocap/), Playbook
spec v2 (+ training wiring + real-plan acceptance test -> ops/research/PLAYBOOK_SPEC_S381.md), training screen audit +
design in TWO MODES (between fights = learn moves; camp = drill the plan for one opponent from owned moves) ->
ops/research/TRAINING_SCREEN_S381.md. Workflow scripts to reuse: C:/Users/user/.claude/projects/E--FightCamp-Game/
1c09b9c6-ab9a-421c-ac86-75f0bf905941/workflows/scripts/ (s381-*.js).

DO IN ORDER:
1. claude/camp2 - the approved camp build (C229 + 5 Undisputed-gym ideas, "Yes, build both"): stages S1-S3 committed,
   S4 (film earned by answered tells + halved flat edges, BalanceHarness) was running at hand-over, then G1 threshold bar,
   G2 weeks strip, G3 sparring = Playbook tests, G4 Legs/Scale/Risk gauges (must DELETE the text lines), G5 hover ghosts,
   review, full suite, stills in E:/FightCamp/tmp/s381/camp2/. Resume the workflow (s381-camp-build, run wf_e1407ef8-fb0)
   if it died; look at the stills; merge.
2. Footwork claude/footwork1: r4c stand-off PASSED by the operator; side clip "his ass is bouncing more than usual" ->
   r5 hips fix (workflow s381-footwork-hips). Eyes-check r5 from the side (backside vs head), send. Then FOOTWORK2: wire
   BoxerFootwork/BoxerFootworkRig into the fight in place of FootPlant + Footwork.gd glide (behind an arg first).
3. Combo film claude/boxmap1 07c42140: plays the Punch PRO takes straight (guard elbows 103-106 deg, hips lead the fist
   0.10 s); NOT filmed (RED). Render r5, eyes on both elbows (C230 "nothing feels human-like", C231 "elbows weird again"),
   fix the 2 boxclip_test fails (blue 10.4 cm pop at 8.57 s). ElbowCorrective.gd exists, not switched on; MetaHuman glb has
   0 blend shapes and nothing drives the elbow corrective joints in Lean.
4. claude/holo-off-live 465b8fb0: film round 1 with the go-to combo + corner minute, full suite, update callout_pop_test
   (it reads the hidden panel), merge.
5. Move cards claude/movepics1: round 2 re-bakes the 39 rejected (BJJ tangles, stand-ins, duplicate combo pictures);
   reviewer must pass < 10% bad; then they feed the Playbook.
6. Owned mocap claude/owned-mocap: inventory + best 15 baked from Downloads/backup + CMU 11 boxing trials (fetched S381 to
   C:/Users/user/Downloads/fightcamp_mocap_s381/cmu, LICENSES.md: ship inside the game OK, never resell).
7. Pocket pass (plan from the reference-clip study, task whomo0tve): flow_probe yardstick, range 0.95-1.15 m, no dead time,
   defender layer, contact, close chest-height camera cutting 0.8-1.5 s; reference numbers / 1.6 (their replay runs fast).
8. Playbook one page: mockup E:/FightCamp/tmp/s381/gameplan/playbook_one_page.png is too dense; operator to pick the calmer
   version. Build with: stamina per card (no AP), read meter, uses per round, tape room (pick tapes, spot the tell, answer
   it in the plan, she studies your tapes too), Rune Coliseum takeaways (E:/FightCamp/tmp/ref_study/rune-coliseum/FOR_PLAYBOOK.md).
9. Theatre claude/theatre-ground (C223 float, C224 camera-swing break, C226 play straight): workflow was running; eyes, merge.
10. Not done S381: export + WHAT_TO_TRY (main changed: Gear->Menu 6eb4c1fe, liver picture 89dc4c75); Miro production map.

MERGED S381: be417e39 agy fallback, 6eb4c1fe Menu label, 89dc4c75 liver picture (CALLOUT_POP 0 fails, GOLDEN_PATH 0 fails).
CLOSED: PR #32 (inside fight9base), PR #35 (Ludo walks, "terrible").
