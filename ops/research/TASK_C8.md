# TASK C8 — CODEX — the SCOUTING read API + the shortlist store

Model: medium. Fast mode off. Decided at assignment; do not self-escalate.
Self-contained. Read this file, `K11_DIGEST.md`, and the anchors named
below. Do not read `HANDOFF_ARCHIVE.md`; do not read `GameState.gd` whole
(~11.3k lines), use the anchors. START WHENEVER YOU HAVE CREDITS — not
gated on a date. Nothing blocks you: Claude's R24 builds the SCHEDULE hub
on your C7 reads and touches screens, not your region.

## Why this exists

The replacement programme is at hub five. Kalli's K11 study ruled the
shape: **ONE rail item SCOUTING** with tabs **FIGHTERS / STAFF**, and
**CONTRACT OFFER as a drawer** off the selected row — never a third
destination. `RecruitmentScreen.gd` (1108 lines) dies when it ships.

You are writing that hub's reads, the way C4 did for GYM, C5 for
TRAINING, C6 for the fighter card and C7 for SCHEDULE. One difference
from those four: K11 found a real gap — **nothing in the save remembers
"come back to this one"** — so this task also adds the shortlist store.
That is the only write you add.

## Deliver

    func get_scouting_board(country_name: String = "") -> Dictionary
    func get_candidate_card(kind: String, candidate_id: String) -> Dictionary
    func get_offer_state(kind: String, candidate_id: String) -> Dictionary
    func get_shortlist() -> Array
    func shortlist_add(kind: String, candidate_id: String) -> Dictionary
    func shortlist_remove(kind: String, candidate_id: String) -> Dictionary

`kind` is `"athlete"` or `"staff"` — the same two strings
`get_recruitment_quote()` and `sign_recruitment_candidate()` already take.
Do not invent a third vocabulary.

### `get_scouting_board(country_name)` — both tabs in one read

The panel rebuilds from ONE call. Return the markets
(`get_recruitment_markets()`), the resolved country, and two row lists —
`fighters` and `staff` — plus the gym context every row is judged
against: cash, current weekly payroll, coach capacity used against
`get_coach_capacity()`, and the roster's divisions.

Each row carries, at minimum: id, name, age, country, sex, discipline,
weight class (fighters), record, the rating/potential the rest of the
game already shows, the opening ask from `get_recruitment_quote()`
(weekly salary, signing fee, contract weeks), **affordable** with a named
reason when false, **shortlisted**, and the negotiation status if one is
open. A staff row carries the teaching and tactical ratings and the
salary instead of a weight class.

Affordability is not "cash >= signing fee". A wage is recurring: say
whether the gym can pay the fee AND carry the wage, and name which half
fails. That is what `affordability_reason` in the kit exists for.

### `get_candidate_card(kind, id)` — one prospect opened

The dossier the drawer's parent board cannot fit: full stats and record,
and the comparison that actually decides the signing — **what the gym
already has** in that weight class and discipline (fighters) or in that
coaching slot (staff), so "would this improve us" is answerable without
a second screen. Include the honest downside: age, wage against payroll,
a division already covered, a coach whose rating is below the gym's
average. State it; do not editorialise.

Unknown or empty id returns `{}`.

### `get_offer_state(kind, id)` — the negotiation, projected

A read-only projection of `get_negotiation()` (416) for the drawer:
round, status, opening ask, last player terms, last candidate terms, the
role baseline for staff, the candidate's answer, the refusal in its own
words when there is one, and the affordability consequence of the terms
currently on the table — payroll now against payroll after. No writes:
`start_negotiation`, `propose_negotiation_terms`, `cancel_negotiation`
and `finalize_negotiated_signing` already exist and stay exactly as they
are. `{}` when no negotiation is open.

### The shortlist — the one new save field

`career["shortlist"]` — an ordered Array of
`{"kind", "candidate_id", "added_week"}`. Rules:

1. **Old saves have no such key.** Every read tolerates its absence and
   returns `[]`; never migrate on read alone.
2. `shortlist_add` refuses a duplicate and refuses past a cap of **12**,
   naming the reason. `shortlist_remove` refuses an entry that is not
   there, naming the reason. Both return `{"ok": bool, "reason": String}`
   in the house style and save.
3. `get_shortlist()` resolves each entry against the world and returns
   the same row shape the board uses, plus `"stale"` with a reason when
   the candidate is gone (signed, retired, no longer active). **Report
   stale, do not silently drop** — a name vanishing without explanation
   is the bug this field exists to prevent.
4. A signed candidate leaves the shortlist inside the existing signing
   path (`_sign_world_athlete` 3386, `_sign_world_coach` 3464) — one
   line each, no other change to those functions.

## The four rules that decide whether this is correct

1. **The three reads must not mutate.** Run them against a deep-copied
   Career and restore the live object before returning — C6's proven
   pattern, reused by C7. The test asserts the save, the world, the
   negotiation dictionary and the offer count are deep-equal before and
   after all three reads.
2. **Two consecutive calls return equal dictionaries.**
3. **Females never fight males; booking matches weight classes.** Both
   bear on a fighter row's value, so the card's gym comparison compares
   inside the candidate's own sex and class, never across.
4. **Numbers agree with their sources.** Asks agree with
   `get_recruitment_quote`; rows agree with `get_recruitable_athletes` /
   `get_recruitable_staff`; staff context agrees with `get_staff` and
   `get_coach_capacity`.

## Files you own

- `Godot/scripts/GameState.gd` — the new functions **appended at the end**
  (C7's `_schedule_hub_tale` currently ends the file), plus exactly two
  one-line edits inside `_sign_world_athlete` / `_sign_world_coach` for
  rule 4 of the shortlist. Change nothing else above.
  **Also fix the stale comment at `GameState.gd:10127`**: it names
  `AthleteProfileScreen`, which R23 deleted. The tab it describes now
  lives in `ProfileRevampPanel.gd`. One comment line; no code change.
- `Godot/tests/scouting_hub_api_test.gd` — new.

Nothing else. No `.tscn`, no screen script, no `project.godot`.
Rebase on `origin/master` before you push.

## Anchors

    Godot/scripts/GameState.gd:316    get_recruitment_markets()
    Godot/scripts/GameState.gd:327    get_recruitable_athletes(country, limit)
    Godot/scripts/GameState.gd:346    get_recruitable_staff(country, limit)
    Godot/scripts/GameState.gd:363    get_recruitment_quote(kind, id)   the opening ask
    Godot/scripts/GameState.gd:391    sign_recruitment_candidate(...)
    Godot/scripts/GameState.gd:416    get_negotiation(kind, id)
    Godot/scripts/GameState.gd:479    propose_negotiation_terms(...)    the tolerance rules
    Godot/scripts/GameState.gd:3303   get_staff()
    Godot/scripts/GameState.gd:3341   _find_recruitment_candidate(kind, id)
    Godot/scripts/GameState.gd:3386   _sign_world_athlete(id, override)
    Godot/scripts/GameState.gd:3464   _sign_world_coach(id, override)
    Godot/scripts/GameState.gd:3531   get_coach_capacity()
    Godot/scripts/GameState.gd:3538   get_coach_rating_average()
    Godot/scripts/GameState.gd:10198  get_gym_hub                       (C4 — house style)
    Godot/scripts/GameState.gd:11016  get_schedule_month                (C7 — your own last one)
    research/C6_DIGEST.md       the disposable-Career pattern to reuse
    research/K11_DIGEST.md      the board shapes these reads must serve
    Godot/scripts/DevJump.gd:35       the test harness API

## Test

`Godot/tests/scouting_hub_api_test.gd` builds a real career through
DevJump (set `SceneRouter.navigation_enabled = false` first) and asserts:
the board returns both lists with the gym context; a row that cannot be
afforded names which half fails; the fee-affordable-but-wage-unaffordable
case is distinguished from the reverse; **the save, the world, the
negotiations and the offer count are deep-equal before and after all
three reads**; two calls are equal; an unknown id returns `{}` from both
card and offer reads; the candidate card's gym comparison stays inside
the candidate's sex and weight class; an open negotiation projects its
round and last terms and a refusal keeps its own words; the shortlist
starts `[]` on a save with no key, adds, refuses a duplicate, refuses the
13th, removes, reports a stale entry with a reason, and survives a save
and reload; a signed candidate leaves the shortlist.

    python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/scouting_hub_api_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scouting_hub_api_test.gd

Then `recruitment_screen_test.gd` (if present), `office_hub_test.gd` and
`smoke_test.gd`. Full suite once before the commit (Git Bash, from
`Godot/`, `GODOT` = the console exe): `for f in tests/*.gd; do timeout
600 "$GODOT" --headless --path . --script "$f" >/dev/null 2>&1 || echo
"FAIL rc=$? $f"; done`.

Check `git status -s` first, `git add -- <your files>` only, one commit,
push `master` if you can (else Claude pushes), then convert your
`HANDOFF.md` block to COMPLETE with the hash (max 8 lines) and write
`research/C8_DIGEST.md`.

Note: `HANDOFF.md` has mixed line endings. Append your block without
reformatting anyone else's, and never rewrite another agent's block.
