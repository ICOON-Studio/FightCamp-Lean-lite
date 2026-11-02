# TASK C53 — THE BELT NOBODY SANCTIONS (codex)

Model: gpt-5.6-luna, effort **high**, Fast off. One session. **C52 landed
2026-09-08 as `cb376bd`**, so nothing blocks this. The shared vocabulary the two
tasks needed is settled below rather than in C52 — you still do not need to read
C52's deliverable, and your read list is unchanged.

**Anchors re-verified 2026-09-08** against `12750f7`: `WorldPopulation.gd` is
still 1,982 lines and `:30`, `:106`, `:1283` and `:1312` are all exact. C50,
C51, C52, R71 and R72 landed since this file was written and none of them
touched `WorldPopulation.gd`.

**Research only.** Two markdown files, nothing else — no `.gd`, no JSON, no
tests, no `HANDOFF.md`.

Deliver:

- `research/C53_THE_BELT_NOBODY_SANCTIONS.md`
- `research/C53_DIGEST.md`

Same instrument as C46 and C52: decisions page, evidence with source links,
build order, migration cost, explicit non-decisions. UNKNOWN is never a number
(J2 6.3).

## The dead end, stated exactly

**Boxing is this game's starter discipline.** Every new career begins on a
generated boxing floor. After R70 (2026-09-08) the world seeds **12 boxing world
titles, and every one of them has `organization_id: ""` — nobody's name on it,
permanently, by construction.**

That is not a bug. It is the honest consequence of two correct rulings meeting:

- **J3 D4** keeps WBA / WBC / IBF / WBO out of the organization catalogue.
- **R70** made `sanctioning_organization_id()` return `""` for any discipline
  whose `belt_authority` is not `promotion`, and boxing's authority is
  `sanctioning_body`. Before R70 a boxing belt fell to the first generated
  market association that happened to carry local boxing weight — a made-up
  national body printed as the authority behind a world title. That was worse,
  and it is gone.

So the game's **first and most-used championship is anonymous forever**, and no
screen can say whose title a player's fighter is holding. The player meets this
in hour one. Rule on what we do about it.

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

## Anchors

`WorldPopulation.gd` is **1,982 lines — never open it whole.** Line numbers as
of `aafe79b`; **they drift**, so re-find a window with the `grep -n` beside it
rather than reading further:

- `sed -n '10,60p' Godot/scripts/WorldPopulation.gd` — `BELT_AUTHORITY_*` and
  the fallback table (`:30`).
- `sed -n '100,125p'` — `belt_authority()` (`:106`).
- `sed -n '1283,1335p'` — `promotions_by_standing()` (`:1283`) and
  `sanctioning_organization_id()` (`:1312`), where the `""` is returned.
  `grep -n 'static func sanctioning_organization_id' Godot/scripts/WorldPopulation.gd`

Read whole: `Godot/assets/data/championship_rules.json`,
`research/R70_DIGEST.md`, your own
`research/C46_THE_BELTS_OWNER.md` (its **Boxing boundary** section is the
starting point — you already found the Ali Act there).

Cite, do not re-derive: `research/J3*` for D4,
`research/J2_THE_FEDERATION_PATHWAY.md` for the money direction.

**Do NOT read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
digest, and do not explore to get oriented.

## Questions

- **D1. What does a sanctioning body actually DO** that a promoter does not?
  You cited 15 U.S.C. § 6307c in C46 for the disclosure duties; go further into
  the *behaviour*: publishing ratings, ordering mandatory defences, approving or
  refusing a matchup, stripping a champion, taking a sanctioning fee. Name each
  power and say which are published rules and which are discretionary. **These
  powers are the gameplay** — a title authority that only supplies a name is not
  worth modelling.
- **D2. The mandatory challenger.** This is the single most gameplay-rich thing
  a boxing sanctioning body does and the game has no equivalent of it: a
  champion is ordered to defend against a named contender inside a window, or
  loses the belt. What are the real mechanics — who becomes mandatory, how, what
  the window is, what happens on refusal, and what an eliminator is? Sourced or
  UNKNOWN, never plausible.
- **D3. The options, priced.** Given the alphabet bodies stay out, what are the
  honest ways to give a boxing title an authority? At minimum, price these and
  add any you find:
  1. An **authored fictional sanctioning body** with published, in-game criteria
     — a name the project owns, behaving as D1/D2 describe.
  2. **Promoter-owned titles** — is there real precedent for a promotion's own
     boxing championship, and what is it actually called?
  3. **Accept unsanctioned** and print it honestly as "no sanctioning body".
  4. **Regional and national titles** — a layer beneath a world title. Which
     bodies award these, and is any of them nameable under this project's
     policy?
  For each: what it costs to build, what it costs in honesty, and what breaks in
  an existing save.
- **D4. The layered title ladder.** Real boxing has a route — novice, then
  area/regional, then national, then world. Does that ladder exist in a
  citeable, generalisable form? If it does, it is worth more to this game than
  the world title alone, because it gives a career a middle.
- **D5. Ratings.** Boxing ratings are published on a cycle, unlike a promotion's
  matchmaking. U12 landed a `ranking_mode` field on every catalogue row
  (`published_criteria` / `discretionary` / `mixed`). What would a boxing
  authority's ranking mode be, and does any body publish criteria specific
  enough to implement rather than merely describe?
- **D6. What breaks if we do nothing?** State the cost of leaving boxing
  unsanctioned forever, concretely and without arguing for a fix. If the answer
  is "very little", that is a legitimate and welcome finding — it saves a stage.
- **D7.** Explicit non-decisions.

## The traps

**One.** Do not re-open J3 D4. The alphabet bodies stay out of the catalogue.
Any option that amounts to "add the WBC under a thin alias" is refused before
you write it — an authored body must be authored, named as authored, and never
dressed as a real one.

**Two.** This task is about the **championship belt** only — the noun defined
above. Nothing here touches the grade, and nothing here may blur the two.

**Three.** Do not solve this by handing boxing back to a generated market
association under a new justification. That is precisely what R70 deleted, and a
fictional body the project authors on purpose is a different thing from a
procedurally generated one the game presents as real.

## Owned files

```
research/C53_THE_BELT_NOBODY_SANCTIONS.md
research/C53_DIGEST.md
```

Nothing else. This task creates two files and modifies none.

## Constraints you inherit

- UNKNOWN is never a number (J2 6.3).
- Text names only. No logos, no belt artwork, no brand imagery, ever.
- Females never fight males; every division is same-sex.
- The facility is a "gym", never a "camp".

## Done means

Both files pushed to `master`, one line sent with
`python Tools/agent_comms.py send --from codex --to claude --topic "C53 done"`,
no edit to `HANDOFF.md`. No parse gate, no test run — you are shipping two
markdown files.

---

## START PROMPT (operator pastes this to Codex)

```bash
git fetch origin && git rebase origin/master && cat research/TASK_C53.md
```

> You own C53. The task file is self-contained — read it and nothing else. Do
> NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any
> digest, and do not explore to "get oriented". **Research only**: two markdown
> files, no `.gd`, no JSON, no tests, no `HANDOFF.md`. `WorldPopulation.gd` is
> **1,982 lines — never open it whole**; read the three `sed -n 'A,Bp'` windows
> the task names at `:30`, `:106` and `:1283`, re-finding any that has drifted
> with the `grep -n` beside it. Read whole only:
> `championship_rules.json`, `R70_DIGEST.md`, and your own
> `C46_THE_BELTS_OWNER.md` — its Boxing boundary section is where you start.
> Commit, push, then send one line with `agent_comms.py send`.
>
> **The trap: J3 D4 is not re-openable.** WBA/WBC/IBF/WBO stay out of the
> catalogue, so any option that amounts to adding one under a thin alias is
> refused before you write it. A body this project authors on purpose must be
> named as authored — and it is a different thing from the procedurally
> generated market association R70 just finished deleting.
