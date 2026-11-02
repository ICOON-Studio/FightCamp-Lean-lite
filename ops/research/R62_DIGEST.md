# R62 DIGEST — THE BODY'S RECORD, AND WHERE EACH INJURY STANDS

Claude, 2026-09-08. Engine only. Follows R59 (the injury in the save) and R60
(the ceiling), and spends the two modules that had no caller.

## What landed

`GameState._body_read` now composes G16 and G17 instead of leaving them on the
shelf. Three new keys, all **additive** so U9 — written against the pre-R62
shape while this was in flight — reads exactly as before:

- **per region, `phase`** — `InjuryPhase.phase(injury, career_week)` for a
  region carrying a live diagnosis, `{}` for one that is merely sore. An empty
  dictionary is the answer; a synthesised `"cleared"` would have been a lie.
- **`phase_board`** — `InjuryPhase.board(BodyReadiness.get_injuries(athlete),
  career_week)`, whole and unedited: `governing_region`, `weeks_to_clear`,
  `weeks_to_clear_known`, `active`, `cleared`, `unreadable`, `unknown`.
- **`record`** — `InjuryHistory.summarize(BodyReadiness.get_injury_log(athlete),
  career_week)`, whole and unedited: `diagnoses`, `weeks_lost`,
  `weeks_lost_known`, `unusable_rows`, `regions`, `repeat_sites`, `unknown`.

`GameState.gd` gained two preloads beside `RegionHistory` (`:33-35`) and the
row loop now resolves the injury once and passes it to G17 rather than asking
`BodyReadiness` for the same dictionary twice.

## What it deliberately does not do

No total, no severity index, no worst-injury, no projection, and **not one
word**. `InjuryWords` (Q3), `RecoveryWords` (Q4) and `LedgerWords` (Q5) own
every string a player reads and none of them is preloaded here.
`weeks_lost_known` and `weeks_to_clear_known` come through untouched: they are
the only thing a screen can use to say NO DATE SET instead of printing a zero.

## Tests

`Godot/tests/body_read_test.gd` grew from 46 to 62 checks, 0 failures. The new
sixteen (R62a-R62p) cover a live diagnosis's phase, an empty phase on a sore
region, the board's governing region and its wait, the ledger counting only the
rows it can read (a row with no onset week lands in `unusable_rows`, never in
`diagnoses`), a version-1 body with no `injury_log` reading empty rather than
absent, and the retired fighter answering off the world record.

Q29, the purity check, still passes: every accessor this read touches returns a
duplicate, so repeated reads leave `Career` byte-identical.

## For U9

`get_body_read` now carries `phase` per region, `phase_board` and `record`.
Nothing that existed before it changed name, type or meaning.
