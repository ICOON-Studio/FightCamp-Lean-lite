# TASK C39 — CODEX — THE AMATEUR CIRCUIT: A FIGHT AGAINST A REAL PERSON

**Status: COMPLETE (2026-09-07, `77a15ff`).** The plumbing half of the amateur
cycle. Cursor's U4 rules how a bout is made and R56 draws it; **this task
ships the state, the pool and the door, and none of it waits on either.**

Model: top tier, effort high, Fast off. One session.

## The gap, verified before assigning and not assumed

**1. Amateur fights do not exist.** `EntityPathway.gd` (203 lines — read it
whole, it is small) has known since R40 what an amateur body is
(`is_amateur:117`), what entry costs (`entry_fee_cents:131`), what a placing
pays (`prize_cents:145`), and what ends eligibility
(`ends_amateur_eligibility:195`). Grep `ends_amateur_eligibility` across the
repository: **the only callers are five assertions in
`tests/entity_pathways_test.gd:116-120`.** The one-way door is built, tested,
and has never been walked through in production.

**2. `turned_pro` moves in exactly one place.** `accept_signing_offer()`
(`GameState.gd:5484`) is the sole writer. So signing a promotion turns a
fighter pro and a paid bout at a non-signing organization does not — which
contradicts P15, asserted at `tests/entity_pathways_test.gd:118`
("a paid bout ends it whoever staged it"). That is a live contradiction between
shipped code and its own test file.

**3. Unsigned fighters fight ghosts.** `_promotion_opponent_pool()`
(`GameState.gd:5718`) builds a pool of REAL world athletes — same discipline,
same sex, not retired, same weight class, sorted by rating gap — and it is
reachable only from `get_promotion_bouts()`, i.e. only by a signed fighter.
Everyone else gets `get_fight_offers()` (`GameState.gd:5300`), which invents an
opponent NAME, RATING and RECORD from an RNG seeded on
`"fight_offer|<gym>|<tier>|<class>|<week>"` and hands out a purse from the
hardcoded `FIGHT_TIERS` table (`GameState.gd:155`). A debut 0-0 fighter is
offered paid professional bouts against people who do not exist, in week one.

**4. There is one record and it is not labelled.** `GAME_DESIGN.md:72` promises
"Amateur and professional records by ruleset". The settled-bout write at
`GameState.gd:11128-11136` increments a single `athlete["record"]`.

## What you ship

### A. The amateur read

`get_amateur_read(athlete_id) -> Dictionary`. A fighter is an amateur when
`turned_pro` is falsy — do not add a second source of truth for that. The read
returns at minimum: `amateur: bool`, `record: {wins,losses,draws}` from the new
`athlete["amateur_record"]`, `turned_pro_week: int` (0 when still amateur), and
`eligibility: {open: bool, closed_by: String}`. It must be safe on a retired
athlete and on an athlete with no bouts.

### B. The pool — real people

`_amateur_opponent_pool(athlete) -> Array`. **Mirror `_promotion_opponent_pool`
(`:5718`) rather than inventing a second style of filter**: same discipline,
same sex (`WorldPopulation.athlete_sex`), not retired, same weight class, and
never a member of the player's own roster. Add the one filter that makes it
amateur: **the candidate must not have turned pro** — a world athlete with a
promotion contract or a `turned_pro` flag is not on this circuit.

Then STOP. Do not sort by rating gap. Grok's `AmateurMatchmaking.gd` (G14) is
being written in parallel and owns the ranking; Claude splices it in R56.
Return the pool in a stable order (`id` ascending) and leave a one-line comment
saying G14 ranks it.

### C. The bout, booked through the existing path

`get_amateur_bouts(athlete_id) -> Array` builds offers from that pool against
an amateur organization (`EntityPathway.is_amateur`). Splice
`EntityPathway.entry_terms(org)` (`:155`) onto every offer, and honour it:

- **`purse` is 0 and `win_bonus` is 0, always.** `pays_purse` is false for a
  national body by construction, and a purse here would end the career being
  modelled (J2 2.4).
- `entry_fee_cents` and the `fee_unknown` flag ride on the offer unchanged.
  **Never invent a fee and never fake an unknown fee as free** (J2 6.3, P7).
  When `fee_unknown` is true, debit nothing and carry the flag.
- Prize money only where an authored `prize_table` names the division
  (`prize_cents:145`).

**Accepting an amateur bout goes through `book_fight()` (`GameState.gd:9835`).
Do not fork a second booking path.** That function already carries the weight
move gate, the strike gate, the exclusive-contract gate, the medical clearance
warning, the pathway gates at `:9898-9905` and the same-sex rule. Extend it
where the amateur case genuinely differs; do not copy it. If a known fee is
payable, debit `gym["cash"]` at booking time in the style of `:3105-3109`
(capture the old value, restore it if the rest of the operation refuses) and
write it through the gym ledger so R46's desk can see it.

### D. The record, split

The settled-bout write at `:11128-11136` increments the pro record. Make it
increment `athlete["amateur_record"]` instead when the bout was on an amateur
card, and leave the pro record untouched. **Both records persist forever** — an
amateur record is not deleted when a fighter turns pro. Do not touch
`TaleOfTape.apply_settled_result` semantics or the ranking-points block below
it beyond what this split requires; an amateur result must not move
professional ranking points.

### E. The door, finally walked

One private helper, `_turn_pro(athlete, cause, career_week)`, and exactly two
production callers:

1. `accept_signing_offer()` (`:5484`) — replace the inline write with the
   helper, cause `"promotion_contract"`. Behaviour must not change; the
   `newly_pro` / erase-on-failure logic at `:5482-5490` is a rollback path and
   must survive.
2. The settlement of a bout that actually paid, via
   `EntityPathway.ends_amateur_eligibility(org, purse_cents, ruleset)` — cause
   `"paid_bout"`. **This is the call that has never existed.** Store the cause
   and the week on the athlete so a screen can say what shut the door.

Cursor's U4 Q6 is ruling the exact moment and the wording of the warning that
precedes it. **Ship the mechanism; the ruling changes copy and a confirm step,
which is R56's, not yours.** Do not gate this task on U4.

## Owned files

- `Godot/scripts/GameState.gd` — **13,594 lines. Never open it whole.** Read
  `sed -n 'A,Bp'` windows at the anchors above: `:155` (`FIGHT_TIERS`), `:5300`
  (`get_fight_offers`), `:5441`/`:5482` (`accept_signing_offer`), `:5718`
  (`_promotion_opponent_pool`), `:5753` (`get_promotion_bouts`), `:9835`
  (`book_fight`) with the pathway gates at `:9898`, `:11118` (the settled-bout
  write), `:3092-3130` (the cash-debit pattern), `:10308`
  (`get_gym_ledger_read`).
- `Godot/scripts/EntityPathway.gd` — 203 lines, read whole, **do not modify**.
- `Godot/tests/amateur_circuit_test.gd` (new)
- `research/C39_DIGEST.md` (new, short)

**Do not touch** `AmateurMatchmaking.gd` (G14, Grok's), `ScheduleHubPanel.gd`
or `ProfileRevampPanel.gd` (R56, Claude's), `WorldPopulation.gd`, or
`HANDOFF.md`.

## Gate and tests

```bash
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/amateur_circuit_test.gd
```

Parse gate first — a parse error HANGS a headless test until the timeout
instead of failing it. Then the focused tests, then the full suite ONCE in the
background before the commit:

```bash
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/amateur_circuit_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/entity_pathways_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
```

`entity_pathways_test.gd` is not optional — it holds the five P15 assertions
this task is finally making true in production, and it must still pass
unchanged.

## When you are done

Commit, push, write the digest, then one line:

```bash
python Tools/agent_comms.py send --from codex --to claude --subject "C39 landed" --body "<commit> — <what shipped>; parse N/N, focused N, full suite N/N."
```

Do NOT edit `HANDOFF.md`. Claude writes your block.

## The one trap

**`get_fight_offers()` (`:5300`) is not yours to delete.** It is the free-agent
professional board and half the game hangs off it — clause offers, grudge
matches, superfights and the Grand Prix all append into its return value at
`:5335-5340`. The amateur board is a SECOND, separate list of real people. If
you find yourself rewriting the synthetic tier grid, you have left the task.
