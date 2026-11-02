# S235 DIGEST (2026-10-16/17) - every seat working; the floor gets events, cuts, corner/ledger/sparring code; Codex rooms in; the "hangs" explained

## Operator words this session (verbatim)
- "use grok,arena and the other agents i do not want to remind you every session"
- "codex PID 4460 doesnt show at process , is it working ?" / "codex finished ?"
- "all new mechinaics from ludo, you and the other agents that iasked on previous session are wired in ?"
- "check ludo what paul things on the progress ?" / "keep getting from ludo when you wait" / "getting code"
- "check my comments on board the rooms from codex put them in , fix doors and how walls render ,in those still the walls should be transparent"
- "when the kickreach test will finish ?" / "should this be in the boxing demo ?" / "how did that got past ludo and paul ??"
- (off-project) Malaga L2TP VPN: error 87 / phone "server did not respond" -> the Malaga server side; operator to ask its admin (IKEv2/WireGuard).

## What now works (all GAME_ON, each with a test that was red first or a control arm)
- FLOOR EVENT DECK on the floor (Dola's rules/FloorEvents.gd, switch floor_events, 72c6eafb): 2 seeded events a day, A/B keys, money/rep via
  apply_floor_effect, morale, gain/drain mult 30 min, niggle chance, break minutes; FLOOR_EVENTS_FLOOR 0 (fires rival_scout 258, kid_autograph 360).
- FLOOR CUTS (Grok Dev PR 215, switch floor_cuts, 85c90de9): no BEST/GOOD (pads show what a block adds + card prereq), PACE YOURSELF folded
  into REST (2-card cue bar), upgrade + walk-in "come back later" REMOVED from the ring (cfbb072e, ThingActions ctx.removed). Collect SUITE 55/0.
- WALK-IN POLICY (Qwen): rules/WalkInPolicy.gd (35415906) + office toggle row + saved setting (72c6eafb, switch walk_in_policy).
- GAMEPLAN READINESS (Arena PR 216, f6fc7574): rules/GameplanReadiness.gd - 6 styles, counters, banded small fight mods. Not on the floor yet.
- LUDO CODE IN (pure/UI, tests green, NOT wired yet): r99 CornerRehearsal.gd + LoadLedger.gd (8aaff979, 81c92e42); r100 SparringFlash.gd,
  ui/FloorDecisionCard.gd (one card for every floor decision), ui/LoadLedgerStrip.gd (ceff9b88, 040367ae; the card test's false red fixed);
  r101 ui/DayPlanPanel.gd (test re-asked - its first copy was cut at line 33).
- ROOMS3CD round 1 (Codex, 1f4a7c3f): office + physio finishes, room-only lights, wall graphics; ROOMS_OFFICE_PHYSIO 204/204.
- TOOLING: run_tests no longer calls a heat-governor pause a hang (44cf0d3b; the governor publishes paused PIDs); the governor was NOT running
  at session start - restarted via its task; rule_guard blocks only real runner invocations (git add/grep of run_tests.py passed).
- NIGHTLY1: 5 offer/event reds verified fixed (each test alone, output read).

## Rejected / parked
- KICKREACH1 PARKED: the 1.14 m kick is MMA (kickboxing_low_kick, mma room) - off the boxing demo (operator caught it). Goose round 3 rejected on
  evidence: the test COMPLETES (no hang) and is still red. Cause of the slip: the S226 brief never named the discipline. Fix: Paul flags
  non-boxing rows OFF-DEMO (Tools/xai_ask.py), every brief carries a `Discipline:` line (CLAUDE.md s8), memory feedback_demo_scope_discipline_s235.
- Arena PR 211 (corner contract) red in its own CI -> closed. PR 208 was already collected -> closed. D69 (Dola jab refs) stale -> Ludo r101 + John J63.

## Jab (PAIRLIVE1 / ANIMSOURCE1)
Ludo r101 PART A (research/ludo_rx/LUDO_R101_raw.txt): r95 needs one more pass - retraction ~1.25x faster than extension, rear glove on the
cheekbone, lead shoulder +42 mm, lead heel drop before contact. References: Holmes-Cooney 1982 R2, Golovkin-Lemieux 2015 R1, Taylor-Serrano I
2022 R3 - timestamps UNVERIFIED (John J63 checking + free mocap jabs).

## In flight at handover (all on the board, live_runs.json)
Codex ROOMS3CD2 (wt E:/FightCamp/wt/ROOMS3CD, see-through near walls, doors, facings, spacing, no cue bar in room views; operator C94-C97);
Grok Dev FLOORWIRE1 (Corner Rehearsal + Load Ledger on the floor, one decision-card queue, grok/floorwire1); Arena PARTNERPOOL1; Qwen
LEDGERREAL1 (wt E:/FightCamp/wt/WALKINPOLICY2, ledger vs John J62); Dola DOLA_DAYPLAN1; Cursor #201 round 4 (+ Maria M44 spec); Ludo r101
test continue; John J63; Kalli K87 (decision pacing); Maria M45 (doors + cutaway look).

## Lessons
- Read a test's output, never its rc: `& godot.exe ...` returned empty output and rc twice tonight (output filter); use Start-Process with
  -RedirectStandardOutput to files.
- PowerShell Set-Content -Encoding utf8 adds a BOM - restored FloorEvents.gd (f192cc42). Edit GDScript with the Edit tool or Python.
- A "hang" can be the heat governor; check heat_governor.log before calling anything hung.
- Ask "which discipline?" before any brief, collect or audit.
