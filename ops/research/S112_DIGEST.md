# S112 digest - 2026-09-27 (Claude)

**Nightly cited:** `AgentComms/nightly/latest.txt` = 2026-09-27 05:00 at `40bec39e` (S97), SUITE total=439 fails=24.
Tonight's is the first run with S102-S112 (re-pins, six rooms, U191, Q206, C217/C218 + the Kickback addon); the main
checkout was re-imported (`--import`) so its class cache carries Kickback's class_names.

## Shipped
- `ce0e7673` **Q206 merged** (Qwen, fence pin) as its diff over S102, 17 files. Subset fight_realtime,grapple,
  fight_defence,fight_ring_position: fails=3 merged == fails=3 master (fight_defence_model, fight_ring_position,
  grapple_naming_contract, all red on master). MMA leg share 12.6% (in J20's 12-18%) - reached by raising
  `MMA_LEG_REGION_SELECT_MULT` 2.55 -> 4.80, a compensation, not a fix of what the clinch steals. Fence share of clinch
  ~55% vs G139's 70-85%: MISSED. `fight_fence_pin_test` owed by the task, not delivered.
- `48f7bca2` **G142 collected** (Grok, back control): hazard table ADOPTED for the back seat (two-stage control ->
  RNC locked, flags, acceptance bands); all visit-level figures are J anchored to S fight-level counts.
  **D59 collected** (Dola, whole gym; second answer only - the first ranked rooms it had not seen). **G143** assigned.
- `f5ce1cb0` **Props pass on all six rooms** (operator: "finish all rooms"): `_house_style` (teal waist stripe replaces
  each room's own; the name on a navy plaque) + `_tint`; staff room rebuilt (seats out of the table top, no chair under a
  standing coach, coat rack, roster, plant); physio corner (plant + supplies cabinet); lobby/office sofas navy; mat room
  doorway tiles cleared. Room subset 9/9 green; six renders refreshed in docs/previews/s105-s110.
- `17cb20a3` **C217+C218 merged** (Codex, active ragdoll on live motion): Kickback addon (MIT) + FightActiveRagdoll,
  OFF by default. 45/45 moving reactions on f01/f02/MPFB (max error 0.41/0.37/0.43 m vs <0.75), 200/200 recoveries,
  engine + OFF pixel hashes unchanged. Subset fight_world_live,fight_room 5/5 == master. The two .mp4 previews stay on
  the branch (keep the repo light).

## In flight at handover (all yours next session)
Qwen Q207 (worktree Temp/FightCamp-Q207, branch qwen/q207-one-down-one-up, cut at ce0e7673); Cursor U192 (Temp/
FightCamp-U192, branch cursor/u192-plan-reads-contract); Grok G143 (grok.com/c/734c118e-dd4a-4a06-b099-31a4d757feb9);
Dola D60 (newest Cici chat "D60 Digest Review"). Codex HOLDS C219 (calm idle clips), launch at the first free slot.

## Lessons
- A fresh worktree needs `godot --headless --import` before any test: without it every class_name reads "not declared"
  and a subset reports false reds (cost one rerun here). Same after merging an addon into the main checkout.
- Codex's sandbox cannot read CIM, so `pc_watchdog` reports C_free=0 and exits 1 there: run it yourself and tell the
  agent the reading (C218 run 1 stopped on that).
