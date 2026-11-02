# TASK C38 — CODEX — THE FIGHTER WHO STAYS: HIRING YOUR OWN RETIRED

**Status: COMPLETE (2026-09-07, `6760ebe`).** Runs after your C37 (`5fb6165`), which
ended by naming this task explicitly: *"No hiring flow in this task — it says
what they ARE, a later stage says what you can do about it."* This is that
stage.

Model: top tier, effort high, Fast off. One session.

## Why this exists

C37 shipped `get_former_fighters()` / `get_former_fighter(id)`: every retiree
of this gym, with G11's roles (`FormerRoles.roles_for` returns `["coach",
"cornerman"]`), their licence state and the career epilogue. The FORMER tab
draws the row. **And then nothing happens.** A twelve-year veteran who built
this gym's name retires, the OFFICE says he could coach, and there is no way to
ask him.

Meanwhile the gym hires strangers all day: `get_recruitable_staff()` (`:361`),
`get_recruitment_quote()` (`:378`), `sign_recruitment_candidate()` (`:406`) and
`_sign_world_coach()` (`:3590`) are a complete, tested signing spine.

**Join the two.** A former fighter of this gym is offered a role and becomes
staff, through the spine that already exists.

## What ships

1. **`GameState.get_former_role_offer(athlete_id) -> Dictionary`** — what this
   retiree would cost and what they would be. Composes the C37 read (roles,
   licence state, epilogue) with a quote in `get_recruitment_quote()`'s shape,
   and states plainly whether the offer can be made at all.
2. **`GameState.hire_former_fighter(athlete_id, override_quote := {}) ->
   Dictionary`** — the write. Returns `{"ok": bool, "reason": String}` in
   `_sign_world_coach`'s exact shape, and on success the retiree is on
   `get_staff()` like any other coach.
3. **The FORMER row spends it.** `OfficeHubPanel._former_row()` (`:1195`) gains
   the offer — the role, the wage, and the one action. A retiree who cannot be
   hired shows why, in words, and no button.

## The rules, and they are the task

- **Reuse the spine, do not fork it.** `_sign_world_coach` (`:3590`) already
  enforces `MAX_PLAYER_STAFF` (6, `:94`), the already-on-staff check, the
  signing fee against `gym.cash`, and the build of the `player_coach`
  dictionary. Your write must go through that logic or share it — a second
  hand-rolled coach-signing path that drifts from the first is the failure
  mode here. If it needs a seam, cut the seam; do not copy the body.
- **A retiree is not a world coach.** They are not in `world.coaches`, they
  have no `technical_teaching` or `tactical_rating`, and inventing those from
  their fight record is forbidden: **G11 D4 — the record never grades the
  coach.** Decide what an ex-fighter's coaching figures are from what the save
  actually holds, state the choice in the digest, and do NOT derive skill from
  wins.
- **"Not known" is still the correct answer.** C37's central refusal carries
  forward: the save has no `licence_denied` and no `head_trauma_flag` for most
  retirees. A missing gate stays missing. `FormerRoles.licence_state()` says
  `can_corner: true` always — do not turn a missing licence fact into either a
  clearance or a refusal.
- **The gates that DO block an offer:** staff is full; they are already on
  staff; the gym cannot afford the fee; `roles_for` returned no role. Each one
  is its own sentence in `reason`, never a generic failure.
- **No comeback.** `FormerRoles.comeback_gate()` exists and is NOT this task —
  hiring a coach is not un-retiring a fighter, and nothing here may put a
  retiree back on the roster or into `get_roster()`.
- **Old saves need no migration.** A retirement record already on disk must
  produce a valid offer.

## Owned files

- `Godot/scripts/GameState.gd` — **13,354 lines, never open it whole.** Read
  `sed -n '355,420p'` (the recruitment quote and sign entry points),
  `sed -n '3585,3660p'` (`_sign_world_coach`, the spine you reuse),
  `sed -n '3424,3450p'` (`get_staff`), `sed -n '7327,7385p'`
  (`get_former_fighters` / `_former_fighter_read`, your input). `:94` is
  `MAX_PLAYER_STAFF`.
- `Godot/scripts/OfficeHubPanel.gd` — **1,536 lines, never open it whole.**
  `TABS` at `:66`, the FORMER load at `:188`, `_build_former()` at `:1169`,
  `_former_row()` at `:1195`.
- `Godot/scripts/FormerRoles.gd` — 77 lines, read whole. **Read only: it is
  G11's pure module and takes no edits.**
- Tests: `Godot/tests/office_hub_api_test.gd`,
  `office_hub_panel_test.gd`, `staff_hub_panel_test.gd`, plus your own
  assertions for the new read and write.

**Do not touch:** `Godot/scripts/GameState.gd`'s body region and aging
functions — Claude owns `get_body_read` on R55 this same cycle, beside
`get_aging_read` at `:7397`. Also off-limits: `BodyReadiness.gd`,
`ProfileRevampPanel.gd`, `Mileage.gd`, `RegionHistory.gd`, `HANDOFF.md`.

## The trap specific to this task

`get_former_fighters()` (`:7327`) **swaps `career` for a deep duplicate, builds
the rows, then swaps it back.** Anything you call from inside that projection
sees the copy, not the live career, and any write you make there is thrown away
silently — the read will look perfect and the save will not change. Your
`hire_former_fighter` must do its writing OUTSIDE that projection, on the live
`career`, and your test must reload the save and prove the coach is still on
staff.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/OfficeHubPanel.gd
```

## Tests

```
--script tests/office_hub_api_test.gd
--script tests/office_hub_panel_test.gd
--script tests/staff_hub_panel_test.gd
```

Then the full suite ONCE in the background before the commit.

## Done

Commit and push `master`, write `research/C38_DIGEST.md` (short), send
one line with `python Tools/agent_comms.py send --from codex --to claude --topic
"C38 landed" --body "..."`. **Do NOT edit `HANDOFF.md`** — Claude converts your
block.

---

## START PROMPT (operator pastes this to Codex)

```bash
git fetch origin && git rebase origin/master && cat research/TASK_C38.md
```

> You own **C38**. The task file above is self-contained: read it and nothing
> else. Do **NOT** read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`
> or any digest, and do not explore to "get oriented".
> `Godot/scripts/GameState.gd` is **13,354 lines — never open it whole**; read
> the `sed -n 'A,Bp'` windows the task names at `:361`, `:406`, `:3590`,
> `:3428` and `:7327`. `Godot/scripts/OfficeHubPanel.gd` is **1,536 lines —
> also never whole**; its anchors are `:66`, `:188`, `:1169` and `:1195`.
> `Godot/scripts/FormerRoles.gd` is 77 lines and small enough to read whole,
> and it is read-only.
> Parse gate before any test run
> (`python Godot/tools/check_scripts.py <touched .gd files>` — a parse error
> HANGS a headless test instead of failing it). Focused tests first, then the
> full suite ONCE in the background before the commit. Commit, push `master`,
> write `research/C38_DIGEST.md`, send one line with
> `agent_comms.py send`, and do **not** edit `HANDOFF.md`.
> **The one trap: `get_former_fighters()` at `:7327` swaps `career` for a deep
> copy and swaps it back.** Any write you make from inside that projection is
> discarded silently — the read looks right, the save never changes. Do your
> writing on the live `career`, outside it, and prove it by reloading the save
> in your test.
