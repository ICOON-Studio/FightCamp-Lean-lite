# S171 digest - STORY5a, TRAIN2 launched, the day-lap loop design (Claude, 2026-10-06)

## 1. What now works (evidence opened by me)
- **STORY5a - scorebug grudge flame + old-injury cross** (commit 904ff7be). `FightNightHooks.gd` (pure read over two fighters + the rivalry rows),
  `BroadcastScorebug.set_badges`, wired in `FightWorldLiveScreen._fight_night_badges`. `fight_night_badges_test` 20/0; mutants red (heat 70->30,
  malformed log row accepted). Game-camera stills opened: `docs/previews/s171_story5/53_bout_live.png`, `54_bout_live2.png` (flames on both
  rows, red cross on Torres only). Plan `research/s171_story5.plan`, staged by the new walker step `story5` (the fight screen copies the athlete
  at TO FIGHT NIGHT, so stage before the weigh-in).
- **TRAIN2 launched** on a NEW Arena chat 01a10e52 (branch arena/01a10e52-fightcamp); TRAIN2 milestone retagged B (workflow defect cleared).
- **Outside opinions on the loop** (Arena battle chat 01a10eb2): `DAYLAP_OPINIONS_S171.md`; design page published (claude.ai artifact Y5p61cHNMDFTMCjo9ZHuCE).

## 2. NOT done (said plainly)
- **STORY5b result-screen chapter line is INERT**: `StoryCampaign.result_line` (test 16/0, 2 mutants red) + `GameState.get_story_result_line` +
  `FightResultPanel._build_story_line` are committed (f787e30d) but the row does NOT draw in the as_game walk (4 reruns). Findings: the panel opens
  after the result is filed (`_card` empty - the ledger shows $0, `_resolve_athlete()` empty), booking cleared, so I added a roster-by-name lookup
  and rival-by-name lookup; still nothing. Next: print at each early return of `_build_story_line`.
- Corner lines (Holl) not started; chapter_end card ("Jax is calling") already exists in story_beats.json.
- TRAIN2 not collected. NIGHTLY1 not rechecked.

## 3. Traps recorded
- A new `class_name` script is not visible to parse-gated callers until the class cache refreshes: use `const X := preload(...)` (as FightNightHooksScript).
- The fight screen `duplicate(true)`s the athlete when it opens: anything staged for a still must be staged BEFORE `TO FIGHT NIGHT`.
- `gbot` is down: every call returns 417 on listAgents. Outside opinions: an Arena battle chat in the pane (type into the box AFTER the page settles - first type was lost).
- roadmap.json round-trips exactly with `json.dumps(indent=2, ensure_ascii=False)`; live_runs.json too (indent 2, LF).

## 4. Next session
See roadmap `now.next_action`: collect TRAIN2; STORY5b debug; DAYLAP1 zone layout + one-day lap slice; corner lines; Wall pin.
