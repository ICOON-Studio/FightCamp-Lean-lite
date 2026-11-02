# TASK C52 — THE TOURNAMENT AND THE GRADE (codex)

Model: gpt-5.6-luna, effort **high**, Fast off. One session. **Runs now, in
parallel with C53** — the shared vocabulary is settled below, so neither task
waits on the other's ruling.

**Research only.** You write two markdown files and nothing else — no `.gd`, no
JSON, no scenes, no tests, no `HANDOFF.md`. Claude writes your HANDOFF block.

Deliver:

- `research/C52_THE_TOURNAMENT_AND_THE_GRADE.md`
- `research/C52_DIGEST.md`

Same instrument as C46. Open with a **decisions page** — one table, one row per
question, the call and the one-line why. Then the evidence, every claim carrying
its source link. Close with a **build order** (smallest honest change first),
a **migration cost table**, and an **explicit non-decisions list** so refused
ideas stop being re-proposed.

Where a fact cannot be sourced, say UNKNOWN and move on. **A number you cannot
cite is worse than no number** — J2 6.3 is the standing rule and this project
has deleted whole systems for being invented. R70, last week, was one of them.

## Why this exists

R70 shipped on 2026-09-08 and deleted a lie. Until then the game seeded a
standing world title — a belt somebody carries and defends on the next card —
in every discipline it had three ranked contenders for. **Your own C46** read
the sources and ruled that right for four disciplines and wrong for the rest;
R70 built it. The game now holds a closed `belt_authority` table in
`Godot/assets/data/championship_rules.json`:

| authority | meaning | disciplines |
|---|---|---|
| `promotion` | a house belt somebody carries and defends | mma, kickboxing, muay_thai, karate |
| `sanctioning_body` | a ratings authority apart from the promoter | boxing (none catalogued, so unsanctioned) |
| `event` | won on a date, medal handed out, nobody carries it | wrestling, judo, brazilian_jiu_jitsu, taekwondo, sanda, sambo |

**So six disciplines now have no championship object of any kind.** A judoka can
hold the "become champion" career goal and find nothing to win. That is honest
— far better than a fake belt — but it is a hole, and the operator has asked
(2026-09-08) for the research that fills it: the championship **event**, the
**amateur tournaments** beneath it, and the **grade** — the belt colours — that
those tournaments are divided by.

## The two nouns, settled here so C52 and C53 need not wait on each other

Both tasks use the word "belt" and they must use it the same way. This is the
project's ruling, not something either task derives:

- A **championship belt** is a title somebody CARRIES and DEFENDS — won off
  another person, lost to another person, held by exactly one fighter at a time.
  R70 spent a whole stage establishing this.
- A **grade** is a rank a practitioner HOLDS — awarded by an instructor or a
  certifying body, never won off an opponent, never lost by being beaten. A
  Brazilian jiu-jitsu blue belt is a grade.

Say which one you mean every time you use the word. Neither task may redefine
these two; C52 may add detail underneath them and C53 deals only with the first.

## Anchors (read these windows, not these files whole)

`WorldPopulation.gd` is **1,982 lines — never open it whole.** The R70 seams,
with line numbers as of `aafe79b`. **These drift** — other agents are landing in
both files this week, so if a window looks wrong, re-find it with the `grep -n`
given beside it rather than reading further:

- `sed -n '10,60p' Godot/scripts/WorldPopulation.gd` — `TITLE_STATUS_*`,
  `CHAMPIONSHIP_SCHEMA_VERSION` (`:23`), `BELT_AUTHORITY_*` and the fallback
  table (`:30`).
- `sed -n '100,125p'` — `belt_authority()` (`:106`) and
  `discipline_bears_belt()` (`:120`).
- `sed -n '1107,1150p'` — `ensure_championships()`, the seeding filter.
  `grep -n 'static func ensure_championships' Godot/scripts/WorldPopulation.gd`
- `sed -n '1220,1258p'` — `_retire_event_discipline_belts()`, the migration.
  `grep -n '_retire_event_discipline_belts' Godot/scripts/WorldPopulation.gd`

`GameState.gd` is **14,134 lines — never open it whole.**
`sed -n '10455,10490p'` gives `get_championships()` (`:10455`) and
`get_retired_championships()` (`:10473`).
`grep -n 'func get_retired_championships' Godot/scripts/GameState.gd`

Small enough to read whole: `Godot/assets/data/championship_rules.json`,
`Godot/scripts/EntityPathway.gd` (282 lines), `research/R70_DIGEST.md`,
your own `research/C46_THE_BELTS_OWNER.md`.

**Cite, do not re-derive:**

- `research/J2_THE_FEDERATION_PATHWAY.md` — already settles how a fighter
  gets into IJF / UWW / WT / IBJJF / Cyprus MMAF, which direction money flows
  (prize down, fees up, salary national), the LA28 Olympic ladder, and **D5, the
  one-way door from amateur to professional.** Re-deriving it is wasted budget.
- `research/U4_HOW_AN_AMATEUR_FIGHT_IS_MADE.md` — already settles how a
  single amateur BOUT is produced in this game. You are asked about the
  **tournament**, which it does not cover.

**Do NOT read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
other digest, and do not explore to get oriented.

## What else the game already holds

**The championship object**, for the four disciplines that still have one: one
row per `discipline|weight_class|sex`, carrying `holder_id`, `since_week`,
`defenses`, `last_defended_week`, `title_status` (vacant / champion / interim)
and `organization_id`. It moves only by being lost in a bout.

**The organizations catalogue**: 18 source-backed entities, `entity_type` of
`promotion` (13), `federation` (4: IJF, UWW, World Taekwondo, Cyprus MMAF) or
`tournament_operator` (1: IBJJF). U12 landed `ranking_mode`, `regulator_kind`
and `outfitting_policy` on every row this week. **Text names only — no logos,
belts, posters or brand artwork ever ship.**

**The three pathways** (`EntityPathway.gd`, live): `signing` — the promotion
contracts the bout and pays; `open_entry` — the ATHLETE enters, by paying and
making weight (IBJJF); `national_selection` — the national body enters the
athlete, no purse, ever.

**The body model**: a fighter carries `body_state.medical_hold_until_week`, a
hold measured in **weeks**, and the only honest "cannot compete" the game has.
Bouts settle **one per card**, and a card is one day inside one week.

**The stat model**: seven 0–100 stats, `GRAPPLE` among them since C43. Weight
classes and same-sex divisions are enforced; females never fight males.

## Area A — the championship that is an EVENT

The object that replaces the belt for judo, wrestling, taekwondo, BJJ, and sanda
and sambo if they appear.

- **A1.** What is the durable career record of winning an IJF, UWW, WT or IBJJF
  world championship? Name the object and its fields. We expect a result with a
  date, a division and a placing — a line on a record, never a status carried
  into next week. Confirm or replace that shape.
- **A2.** Does anything persist between editions? Do these bodies use "reigning
  world champion", and if so what does it mean operationally — a seeding right,
  a label, a ranking-points balance, or nothing? **This ruling decides whether
  the game may ever print "defending champion" on a bracket.**
- **A3.** The bracket per discipline: single elimination, repechage, bronze
  contests, pools. How many contests does a medallist actually have?
- **A4. The one-day multi-bout problem — the sharpest question in this task.**
  A judoka can have five to seven contests in one day. This game holds a fighter
  out on a **week** clock and settles **one bout per card**. Rule on what a
  tournament is: (a) ONE game event with an internal ladder resolved inside it,
  (b) N separate bouts on one date, or (c) something else. Say what each costs
  the body model and the fight clock. **If the honest answer is that the
  existing per-bout machinery cannot represent a tournament, say so plainly** —
  that is a finding, not a failure, and it is the one that decides the size of
  the stage that follows.
- **A5.** Calendar: how often each championship is held, and how the Olympic
  cycle moves it. J2 has the pathway; add the EVENT's own frequency.
- **A6.** Entry and seeding: who is in the draw, how many per country, what
  decides the seeds.
- **A7.** What a medal DOES afterwards — ranking points, funding, selection
  standing. J2 covered the money; state what the medal *changes*.

## Area B — amateur tournaments

The ladder the player's gym actually enters fighters into.

- **B1.** The real levels per discipline — local, regional, national,
  international — under the names these bodies actually use.
- **B2.** Who enters and who pays: athlete, gym, or national body. Sourced entry
  fees where published; UNKNOWN everywhere else. **Do not supply a plausible
  fee.**
- **B3.** The division axes: age, weight, sex — **and grade**, where this area
  meets Area C. Which disciplines divide an amateur draw by grade, and which do
  not?
- **B4.** Format: contests per day, round length, scoring, and whether amateur
  rules differ from the professional ones.
- **B5.** The amateur record: is one kept, by whom, and does it convert to a
  professional record? J2 D5 owns the one-way door — cite it, do not re-rule it.
- **B6.** Amateur boxing and amateur MMA specifically. **Boxing is this game's
  starter discipline** — every new career begins on a boxing floor — so the
  amateur boxing ladder is the first one a player meets. What does an amateur
  *tournament* look like in a sport the game currently models only as single
  bouts?
- **B7.** The gym's side: what entering a fighter costs in money, travel and
  time, and what the gym gets back. Sourced or UNKNOWN.

## Area C — the grade, and the belt colours

**Read C1 before anything else in this area.**

- **C1. THE SEPARATION RULING, and it comes first.** A Brazilian jiu-jitsu blue
  belt and a UFC championship belt are two different nouns sharing one English
  word. R70 spent a whole stage establishing that a *belt* here is a promotion's
  championship object. A *grade* is not that: it is a rank a practitioner holds,
  awarded by an instructor or a certifying body, and never won off another
  person. **Write the one-sentence rule that keeps them apart, phrased so an
  implementer can cite it by number.** If your research blurs the two it undoes
  R70, and this task will have made the game worse.
- **C2.** The real ladders per discipline: BJJ (adult colours and stripes, and
  the separate youth colours), judo (kyu and dan), karate (kyu and dan),
  taekwondo (geup, poom and dan). And the **negative finding, which matters as
  much**: which of this game's disciplines have no grade at all? Rule on
  wrestling, boxing, MMA, kickboxing, muay thai, sanda and sambo one by one.
  **Do not invent a grade for a sport that has none.**
- **C3.** Who awards a grade — instructor, school, national body, certifying
  body. **The Kukkiwon / World Taekwondo split is the sharp case** and we want it
  stated exactly. Is a grade portable between organizations?
- **C4.** What earns one: time in grade, minimum age, competition results, an
  examination, an instructor's judgement. IBJJF publishes minimums; say what is
  published and mark the rest UNKNOWN. **Sourced time-in-grade minimums are the
  most directly spendable numbers in this whole task** — the game runs on a week
  clock and can consume them as they are.
- **C5.** What a grade GATES: tournament division eligibility, the right to
  teach, the right to referee, entry to particular events. This is the mechanic
  payload. A grade that gates nothing is a label, and we need to know that if it
  is true.
- **C6.** Can a grade regress, lapse or be stripped? Can one be held in more
  than one discipline at once?
- **C7.** In game terms: is a grade a number, a label or a gate — and is it
  DERIVED from the seven 0–100 stats or independent of them? Recommend one, with
  the reason. **If your finding is that a grade would only re-skin a stat the
  game already has, say so** — that would kill the feature, and killing it
  cheaply here is worth more than building it.

## The one trap

**The word "belt" means two unrelated things and the game has just finished
paying for the confusion.** If Area C comes back describing a purple belt as
something a fighter defends, or Area A describes a world championship as
something a fighter carries, the implementer who trusts you rebuilds the exact
bug R70 deleted this week. Keep the two nouns apart in every sentence, and say
which one you mean every time you use the word.

Smaller second trap: **do not fill the hole by inventing a federation belt.**
"Give judo a title with a different name" is the wrong answer and C46 already
refused it. The event is the thing.

## Owned files

```
research/C52_THE_TOURNAMENT_AND_THE_GRADE.md
research/C52_DIGEST.md
```

Nothing else. This task creates two files and modifies none.

## Constraints you inherit

- UNKNOWN is never a number (J2 6.3). Carry an explicit UNKNOWN list.
- Text names only. No logos, no belt artwork, no brand imagery, ever.
- No WBA/WBC/IBF/WBO catalogue expansion (J3 D4 — the alphabet bodies stay out).
- Females never fight males; every division is same-sex.
- The facility is a "gym", never a "camp".

## Done means

Both files pushed to `master`, one line sent with
`python Tools/agent_comms.py send --from codex --to claude --topic "C52 done"`,
and no edit to `HANDOFF.md`. There is no parse gate and no test run in this
task: you are shipping two markdown files.

---

## START PROMPT (operator pastes this to Codex)

```bash
git fetch origin && git rebase origin/master && cat research/TASK_C52.md
```

> You own C52. The task file is self-contained — read it and nothing else. Do
> NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
> digest, and do not explore to "get oriented". This is **research only**: two
> markdown files, no `.gd`, no JSON, no tests, no `HANDOFF.md`.
> `WorldPopulation.gd` is **1,982 lines — never open it whole**; read the four
> `sed -n 'A,Bp'` windows the task names at `:23`, `:106`, `:1107` and `:1220`,
> and re-find any that has drifted with the `grep -n` beside it.
> `GameState.gd` is **14,134 lines — never open it whole**; one window at
> `:10455`. Read whole only: `championship_rules.json`, `EntityPathway.gd`,
> `R70_DIGEST.md`, and your own `C46_THE_BELTS_OWNER.md`. Cite
> `J2_THE_FEDERATION_PATHWAY.md` and `U4_HOW_AN_AMATEUR_FIGHT_IS_MADE.md` by
> ruling number instead of re-deriving them. Commit, push, then send one line
> with `agent_comms.py send`.
>
> **The trap: "belt" means two unrelated things.** A promotion's championship
> belt is what R70 just spent a whole stage cleaning up; a BJJ blue belt is a
> practitioner's grade, awarded and never won off an opponent. If your answer
> blurs them, an implementer rebuilds the bug that was deleted this week — so
> say which noun you mean every single time you use the word.
