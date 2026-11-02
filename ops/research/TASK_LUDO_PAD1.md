# TASK LUDO-PAD1 - V8 pad chains: a mastered card fires in the LIVE fight (approved D40, Ludo build order M4)

Model: Codex gpt-6.1-sol (CODEX_MODEL=gpt-6.1-sol - engine work). Worktree E:/FightCamp/wt/LUDOPAD1, branch codex/ludo-pad1 from master.
Push the branch; never master. Never open a window, image viewer or browser. Godot windowed only via Tools\godot_hidden.ps1.

## Owned files
- `Godot/assets/data/pad_chains.json` (NEW)
- `Godot/scripts/PadChain.gd` (NEW, pure)
- `Godot/scripts/FightRealtime.gd` (8,390 lines - NEVER read whole; grep + sed -n windows)
- the strike/defence resolution file(s) you find the hook in (name them in your final message)
- `Godot/tests/pad_chain_test.gd` (NEW, pure), `Godot/tests/pad_chain_fight_test.gd` (NEW, engine)
- `research/TASK_LUDO_PAD1.md`

## Prior research
- Ludo's design (verbatim): `research/LUDO_ROUND3_S188.md` "Follow-up 2" (PadRoutine trigger -> evasion -> counter; practice gain;
  fight: up to 3 equipped routines, fire when mastery >= 0.25 with chance mastery x (ring_iq / 70), 4 s cooldown, evasion with 0.25 s of
  safety then the counter, damage x (1 + mastery x 0.2), stool card "Drill Efficiency: 'Slip & Rip' executed 2/3 times | +34 bonus damage").
  `LUDO_ROUND4_S190.md` 4c item 4 + acceptance: "When opponent throws a lead jab, your fighter slips outside and throws a liver hook,
  spawning an in-ring banner '[PAD CHAIN: SLIP & RIP FIRED]'". `LUDO_FIRST_HOUR_S190.md` minutes 10-13 + 25-29 (Leo's "1-2 Slip").
- Card mastery today: `Godot/scripts/MoveCards.gd` (`level()` ~127: 0..1 from minutes, usable 120, mastered 600; `move_cards.json`).
  The athlete's card minutes: `program_cards.progress` / DayLap `progress` (GameState ~18970-18998, file_visit).
- FightRealtime anchors: `DEMO_SWITCHES` ~1169 + `as_game()` ~1174 (switch pattern), `_build_fighter` ~1246-1551 (what a fighter dict
  carries; note the long comment ~1938-1951 about NOT using `technique_progress` - read it), corner reads ~2838 `_corner_read` and ~4927
  `read_active` (how a corner effect lasts), `_feint_react` ~7926 (an existing "react to the opponent's action" hook - the closest model).
- CLAUDE.md s1 D27: only C223-CERTIFIED moves may play in the demo palette (`assets/data/certified_moves.json`); a chain's evasion and
  counter must be certified moves.

## What would a human do?
Model a routine as data, make the decision a pure function the engine calls at the moment the opponent commits to a strike, and prove on
a seeded fight that a mastered chain fires and an unmastered one never does.

## Prefab check
N/A - our own engine.

## Spec
1. `pad_chains.json`: routines {id, name, trigger (opponent action id, e.g. "jab"), evasion (certified defensive move id, e.g. a slip),
   counter (certified strike id), card (the move-card id whose mastery drives it), damage_mult}. Seed 3 boxing routines (one is Ludo's
   "Slip & Rip": jab -> slip outside -> lead hook to the body), all moves from certified_moves.json.
2. `PadChain.gd` pure: `mastery(progress, card)` (MoveCards.level), `fire_chance(mastery, ring_iq)` = 0 below 0.25 else
   clamp(mastery x ring_iq / 70, 0, 0.95); `should_fire(routine, opp_action, mastery, ring_iq, roll, cooldown_left)`;
   `counter_damage(base, routine, mastery)` = base x damage_mult x (1 + mastery x 0.2); `COOLDOWN_S := 4.0`.
3. Engine, behind a NEW switch `pad_chains` (default OFF everywhere, NOT in DEMO_SWITCHES - the operator turns it on after the video):
   when the opponent commits to a strike that matches an equipped routine's trigger, roll (from the engine's own seeded RNG) -> the
   fighter plays the evasion then the counter; record per side `pad_chain_log` {routine: {tries, fired, landed, bonus_damage}} for the
   stool card; emit/record a banner line "PAD CHAIN: <NAME> FIRED". Equipped = up to 3 routines whose card the athlete has (carry the card
   minutes onto the fighter dict in `_build_fighter` under a NEW key, per the ~1938 comment).
4. Switch OFF must be byte-identical to master on a seeded fight (the determinism tripwire is the one place a seed is reused).

## Done = (tier: scripts edited -> parse, focused tests, then --only suites)
- `pad_chain_test` (pure): thresholds (0.24 never fires, 0.25 can), chance formula, cooldown, damage formula; 3 mutants listed with FAIL counts.
- `pad_chain_fight_test` (engine, two DIFFERENT fighters - CLAUDE.md s5, population printed): switch ON + a mastered "Slip & Rip" card
  vs a jabbing opponent -> fired >= 1 and the log + banner exist; CONTROL: same fight with the card at 0 minutes -> fired == 0; switch OFF ->
  seeded fight identical to master (hash of the round log). Must be RED on master first (paste the count).
- `python Godot/tools/run_tests.py --jobs 2 --only` fight, realtime, corner, move_card, c223 (whatever exists) - all green.
- `python Tools/check_workflow.py branch codex/ludo-pad1 LUDO-PAD1` -> MERGEABLE. Final message: commit, red->green counts, the hook file:line.

## The one trap
The engine is seeded and deterministic; a new RNG draw with the switch OFF breaks every byte-identical test - draw ONLY when the switch is
ON and a routine matches.

## Delivery evidence - Codex

- Scope: only `codex/ludo-pad1` in E:/FightCamp/wt/LUDOPAD1; no master mutation and no windows, browser, or image viewer.
  The task's isolated-branch rule supersedes the general master-rebase intake. No HANDOFF edit: this task's owned-file window takes precedence.
- Hook and strike/defence resolution: `Godot/scripts/FightRealtime.gd`, `_run_impact` -> `_pad_chain_react` after strike commitment.
  The trigger action records the certified evasion and banner; a queued certified counter follows the 0.25 s safety window.
  Pending counters cannot interrupt the evasion or survive a round break. Card minutes use `pad_card_progress`, independently of technique progression.
- Recipes: Slip & Rip, 1-2 Slip, Catch & Rip; all trigger, evasion and counter IDs certified; all card IDs present.
- Parse: CHECK total=4 fails=0. Focused: SUITE total=2 fails=0; existing certified_palette gate: SUITE total=1 fails=0.
- Pure gate: PAD_CHAIN checks=38 failures=0. Three actual temporary mutants, restored afterward:
  threshold removed FAIL=2; cooldown ignored FAIL=1; mastery damage bonus removed FAIL=1.
- Engine RED on the original master task base 711718eb: PAD_CHAIN_FIGHT checks=16 failures=10, fired=0, cold=0.
  GREEN: checks=99 failures=0, fired=15, cold=0, landed=6, bonus_damage=2.1844.
  Population: distinct legal boxing counter-puncher vs jab-focused southpaw out-boxer; full technique catalogue with certified boxing palette.
  Control sees matching jabs with zero card minutes. Only the switch-OFF determinism tripwire reuses a seed.
- Switch OFF round-log SHA256 (captured from the original engine, not regenerated from the implementation):
  `3d89f164ef58dbe94ffce7b3dcf71249fff4cd92f46ed2558822acb66be5782e`.
  `pad_chains` defaults OFF, is absent from DEMO_SWITCHES, preserves the OFF fighter dictionary shape, and draws only with the switch ON and a matching equipped routine.
- Headless worktree import completed; all tracked import metadata and generated non-task files restored/removed. Ignored caches retained.
- Affected gate: requested --jobs 2 selection initially SUITE total=196 fails=16. Twelve cases passed targeted retries;
  final cached reclassification SUITE total=196 fails=4. All four remaining failures independently reproduce on original engine 711718eb.
  The task's all-green affected gate remains unmet by these pre-existing failures; fighter-glove coverage finished TOTAL=22 fails=0.
  Contact-stop passed with timeout 1800; human-speed (104 checks) and grappling-seam (57 checks) passed with timeout 2400.
  Direct headless one-down retry: 12 checks, zero failures. Remaining nine-test retry batch: total=9 fails=1;
  eight passed, and paired-fight retained TOTAL=39 fails=6. A temporary original-engine project (711718eb), sharing assets,
  independently reproduced the same six paired-fight failures and TOTAL=39 fails=6 without modifying master or active test sources.
  Stage-realism: original engine and branch retry both TOTAL=13 fails=7, the same seven GATED S4a rules;
  both also emit the same nine scene-tree cleanup errors, with no SCRIPT ERROR. Retry used timeout 2400 after the original timeout.
  Live-world: branch and original engine both TOTAL=24 fails=0, but the strict runner rejects the same three scene-tree cleanup errors.
  Fighter reachability: branch and original engine both checks=24 failures=8, the same eight mpfb_m_178/mpfb_m_188 neck-approach errors.
- Branch gate: the literal LUDO-PAD1 argument fails solely because it cannot resolve TASK_LUDO_PAD1.md.
  The supported full task path reports MERGEABLE, defects=0, owned=7/outside=0, parse PASS, CI_ARENA_GUARD fails=0.
  Exact accepted command: `python Tools/check_workflow.py branch codex/ludo-pad1 research/TASK_LUDO_PAD1.md`.
  Delivery target: origin refs/heads/codex/ludo-pad1; commit and remote receipt are reported in the final reply.
