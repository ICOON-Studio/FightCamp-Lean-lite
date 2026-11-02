---
name: project-session-s87-2026-09-26
description: "S87 - watch the spar in 3D (watched == settled), CoachVoice (G119) Monday line, sharp_edge wired; the 3D room fights on the ring it draws"
metadata:
  node_type: memory
  type: project
  originSessionId: 65613e81-37ec-419e-8e7c-b07a3696f628
  modified: 2026-09-26T13:19:44.938Z
---

S87 (2026-09-26) finished training-floor step 4a.

- `GameState.spar_fight_setup` is the ONE builder of a spar's engine run; FightNightScreen `spar|<id>` (live settles once via `settle_watched_spar`, replay settles nothing from `career.spar_replay`). FightWorldLive takes `engine_options` + `spar_plate`.
- **Trap found:** the 3D room (FightWorldLive) fights on the ring it DRAWS (`_arena_half_m` from ArenaRig contest); an off-screen FightRealtime run uses DEFAULT_HALF_WIDTH 3 m. Any "watched == settled" claim must pass `FightWorldLiveScreen.engine_half_width_for(discipline)`. Caught by comparing engine logs, not results.
- CoachVoice.gd: Monday row `note` (D31 numbers) + `coach_line` (G119 priority).
- Q189 merged only after Claude re-proved byte-identity: Qwen's tool crashed (empty hashes) and its test compared new vs new - the same gap as Q188. See [[feedback-a-gate-that-reads-its-subject-cannot-fail]], [[feedback-open-the-output-before-the-gate]].
- Running at handover: Q190 (Qwen, SparPartnerMarket), U182 (Cursor, spar in the gym ring), G121 (Grok, gym floor plans), D33 (Dola).

**Why:** S88 builds on these (hired partners must go through spar_fight_setup). **How to apply:** extend spar_watch_test whenever a new kind of spar partner or venue is added.
