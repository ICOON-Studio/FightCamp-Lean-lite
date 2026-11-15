# S480 handover (written 2026-11-15 at the end of S479; S478's handover is in git history)

OPEN IN E:\FightCamp\Lean. START: `git pull && python ops/Tools/agent_comms.py start`, then `python ops/Tools/where_we_are.py roll S480`.

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

## WHAT S479 DID (ops/research/S479_DIGEST.md)
- CLASH4 (Qwen, OWN_ROUNDS 3) not merged: f40 stayed 5.4 cm, brief broken. Claude's read-by-order fix measured identical
  (reverted). Cause: at 4242 08_jab f40 a glove jumps 12 cm in ONE frame (18 m/s); nothing that reads last frame can see it.
- Fight week v9 PASSED (Dola 7/7, John 7/6/7). Sparring partner screen drawn (docs/mockups/s479/sparring_partner_v1.png);
  John's day fix (Tue, 4 days out) and lines-by-match (CLOSE 3 / PART 2 / LOOSE 1) taken -> board Q-238.
- Club week v8 failed John (6/5) -> v9 Kalli SQ159. Training K from Dola was cut off -> re-asked SQ160.

## IN FLIGHT (yours - collect, do not relaunch)
- Qwen CLASH5 (launched 05:53, ETA ~07:45; ops/research/TASK_CLASH5.md, branch qwen/clash5, wt E:/FightCamp/wt/LEAN_CLASH5):
  which layer jumps the glove at f40, fixed there. Merge bar: 08_jab 0 frames > 2 cm, no new CLASH frame on seeds 4242/77,
  OWN 0, own_gloves green, hit_frame (3) / hit_carry (32) / block_meet@30 (1) FAIL sets = main, OWN_ROUNDS still 2. Diff only.
- Arena PARTNERMATCH1 (chat https://arena.ai/agent/01a1dd59-dec9-7c6d-a884-cfad25ce9418, started 06:01, ETA ~07:15):
  scripts/rules/PartnerMatch.gd + tests/partner_match_test.gd; check the six drawing rows in the test; ci_arena.py guard.
- Goose STYLE1 (issue #298, started 05:58): the style dominance probe (TASK_STYLE1.md gates).
- Seat queue: SQ159 Kalli club week v9; SQ160 Dola training K (second try); SQ153 Kalli ladder v1 in -> needs critics.

## FIRST
1. get_usage. His answers Q-232..238 -> act: weight rules into the map; coach fit approved = Grok Dev brief for the "Coaches
   this week" mockup (M1, map 10.1) + probes (FITPROBE1, TRAINBALANCE, COACHTIMEPROBE) to Goose/Qwen; fight week v9 approved =
   PARTNERPROBE (CLOSE vs LOOSE on readied lines, target 3-5 wins in 100) and the partner screen build after PARTNERMATCH1.
2. Collect CLASH5, PARTNERMATCH1, STYLE1.
3. Ladder v1 critics (design_loop.py critic LADDER1_V1 ... --seat john / dola). Club week v9 critics when SQ159 lands.
4. TRAINGAME2 when SQ160 lands: save its HTML to docs/mockups/s477/training_k/, render with tools/render_mockup.py, replace
   every "est." with the game's real number, critics.
