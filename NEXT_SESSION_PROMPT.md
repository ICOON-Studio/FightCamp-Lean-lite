# S481 handover (written 2026-11-15 at the end of S480; S479's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S481`.

## USAGE RULES (kept)
- Run `get_usage` first. Hand over at 420k; start the wrap-up at ~310-330k (send Miro partials, not the whole frame).
- Godot jobs through `python ops/Tools/godot_slot.py run --who s479 -- <cmd>`. hidden_desktop takes `--log=<path>` (with `=`).
- Tests run as tools/run_tests.sh does: `--headless --audio-driver Dummy --fixed-fps 60` (block_meet: 30).
- Never `cd` into a worktree (use `git -C` / `--path`).
- Arena: the Lean lite mirror is ICOON-Studio/FightCamp-Lean-lite (branch main) - `python ops/Tools/lite_mirror.py --lean push`
  after committing the brief. NEW S478: Arena's sandbox has NO Godot - every Arena brief that runs Godot must say "download the
  official Godot_v4.7.2-stable_linux.x86_64.zip from github.com/godotengine/godot/releases, import once, then run".
- `agent_comms.py ask --attach` takes paths relative to ops/ (`research/X.md`), not `ops/research/X.md`.
- The roadmap is 2-space JSON; the board tool sometimes rewrites it 1-space CRLF - rewrite with indent=2 before committing.
- NEW S479: Arena's sandbox cannot download Godot at all (SSL to release-assets) - Arena gets pure modules only (CI runs the
  test); anything that must RUN Godot goes to Goose or Qwen. Arena chat: Chrome tab, GitHub chip -> repo picker -> FightCamp-Lean-lite.

- NEW S480: an Arena chat starts from arena.ai/agent in Chrome; the repo picker already shows FightCamp-Lean-lite/main. Name the brief
  path in the prompt (it reads it from the repo). A Goose issue by hand: `cd ops/Tools && python -c "import seat_dispatch as s;
  print(s.launch_goose({'task':'<ID>','source':'...'}))"` (needs TASK_<ID>.md with a valid contract).
- NEW S480: a seat draw brief embeds the template HTML (docs/mockups/s479/sparring_partner_v1.html) so the drawing matches the look.

## WHAT S480 DID (ops/research/S480_DIGEST.md)
- His Q-232..238 acted on: camp film costs a pad night in any camp week; men's 55 kg; women's 70 kg table asked of Kalli; coach fit
  -> COACHFIT2 (Arena) + coaches M1 (Dola); plan list vs flowchart -> Q-239; fight week v9 -> unsparred lines wired (inert),
  PARTNERPROBE1 (Goose #300), Frame A v2 drawn (docs/mockups/s480/fight_week_v2.png).
- PARTNERMATCH1 collected (90/0). Build exported.

## IN FLIGHT (yours - collect, do not relaunch)
- Qwen CLASH5 (branch qwen/clash5, wt E:/FightCamp/wt/LEAN_CLASH5, ETA ~07:45): merge bar 08_jab 0 frames > 2 cm, no new CLASH
  frame on seeds 4242/77, OWN 0, own_gloves green, hit_frame 3 / hit_carry 32 / block_meet@30 1 FAIL sets = main, OWN_ROUNDS 2. Diff only.
- Arena COACHFIT2 (https://arena.ai/agent/01a1dd77-618e-7712-a4b2-849d37bbb252): CoachFit.gd + tests/coach_fit_test.gd; relays as
  arena/*; run the test on the PC; ci_arena.py guard (its merge-base call fails on origin/master - collect by copying the two files).
- Goose STYLE1 (#298) and PARTNERPROBE1 (#300).
- Seat queue SQ159-SQ165 (see the digest).

## FIRST
1. get_usage. Collect CLASH5, COACHFIT2, STYLE1, PARTNERPROBE1.
2. BUILD THE FIGHT WEEK (the big item): Frame A v2 + Frame B as Godot screens, wired to FightWeek / PartnerMatch / BoutSheet /
   WeighGap / FilmTruth; the picked partner sets bout.r1_edge and bout.unsparred; set bout.fight_week (the switch) with the screen;
   one golden-path test walks it; the week cannot lock until each sparring night has a partner. If PARTNERPROBE1 misses its gate,
   tune PartnerMatch LINES/EDGE first and say so.
3. Seat answers as they land: women's 70 kg wiring; weight M1 + coaches M1 drawings -> render, fix numbers, his board; ladder
   critics; club week v9 critics; training K.
4. His Q-239 answer (plan view).
5. LANDED AT S480's END: Kalli SQ159 club week v9 (ops/research/DESIGN_CLUBWEEK1_V9_REVISE_KALLI_KALLI.md) -> critics John + Maria.
   Dola SQ160 training K came back CUT OFF AGAIN (58 KB, no </html>): ask for it in two replies (CSS + top half, then the rest).
