# TASK Q58 — QWEN — WHAT A GRAPPLE BEAT WOULD HAVE TO CARRY

Model: your default, medium effort. Owner: qwen.
Test tier: **RESEARCH — NO `.gd` TOUCHED, SO NO GATE AT ALL.** No parse gate, no
test, no suite. `git status -s` before staging is the whole check.
**Do NOT launch Godot.** Another agent is running tests in this checkout and only
one Godot may run at a time. This task needs none — it is all `grep` and `sed`.

## Owned files

- `research/Q58_THE_GRAPPLE_BEAT.md` — **NEW. Yours alone.**

Nothing else. Do not edit `HANDOFF.md`, `CURRENT_STATUS.md`, `TASKS.md`, any
`.gd` file, or any other research doc.

## Why this exists

The 3D fight room (`FightWorldLiveScreen`, route `fight_world_live`) already runs
a whole seeded bout — two mounted fighters, a beat per window, a clip per beat.
**It cannot show the ground game at all**, and `FightBeatAdapter` says why in its
own comment at `:145-160`:

> **THE GROUND FIGHT DOES NOT COME OUT OF `advance_tick` AT ALL.** `advance_tick`
> returns only what the IMPACT subsystem produced. Every grapple event —
> takedowns, throws, seats, stalls, control, submissions — is written straight to
> `state["log"]` by `_log_grapple` (`FightRealtime.gd:2014`) ... **the grapple
> beat is its own task.**

That task was never written. It is about to be, and **this study is the design
input for it.** We own sixteen paired two-body clips that map onto those events
almost one-to-one and not one has ever been on screen.

**Do not design the beat. Document what it would have to carry.** The writing is
someone else's job; getting the field list wrong is what makes that job fail.

## THE QUESTION, IN THREE PARTS

### Q1 — What does `_log_grapple` actually write, per kind? (DOCUMENTED)

`_log_grapple` is at `Godot/scripts/FightRealtime.gd:2014` and there are ten call
sites. **`FightRealtime.gd` is ~2,500 lines — do NOT open it whole.** Use
`grep -n '_log_grapple' Godot/scripts/FightRealtime.gd` to find the sites, then
`sed -n 'A,Bp'` a window around each.

Q56 already established the twelve `kind` values (`takedown_attempt`, `takedown`,
`throw_attempt`, `throw`, `clinch_engage`, `clinch_break`, `seat`,
`position_change`, `stall`, `submission_attempt`, `submission_finish`,
`control`). **This task is about the FIELDS, not the kinds.**

For each call site give: the `kind`, the line, and **every key in the dictionary
it writes**, with the type and an example value. Say which keys are present on
EVERY kind and which are specific to one — that split is the whole finding,
because the common keys are the beat's shape and the rest are payload.

**Name the actor and the target explicitly.** A strike impact carries `actor` and
`target` (see `FightBeatAdapter._present:497-498`). Does a grapple event? If it
names the two men differently — `attacker`/`defender`, or by side letter, or not
at all — say so loudly, because the stage has to know **which body is on top**
and that is the single most important fact in a ground clip.

### Q2 — What does a presented beat carry today? (DOCUMENTED)

`FightBeatAdapter._present` (`:484`) builds the beat. List every key it sets and
say, for each, whether a grapple event could fill it, could not, or would need a
new meaning. `Godot/tests/fight_beat_adapter_contract_test.gd:17` holds the
contracted key list — quote it.

Pay attention to these four, which are where a grapple beat will strain:
- `target_region` / `target_body_region` — a takedown has no struck region.
- `landed` / `outcome` — what does "landed" mean for a sweep?
- `animation_family` — currently hardcoded `"strike"` (`:510`).
- `range_band` — is there a band for "on the floor"?

### Q3 — What already reads a grapple event? (DOCUMENTED)

**We are not first.** U32 taught the broadcast read the grapple and U33 the
post-fight read. Find what they did and report the field names THEY consume —
`grep -rn 'grapple' Godot/scripts/FightHudRead.gd Godot/scripts/PostFightRead.gd
Godot/scripts/GrappleAdapter.gd Godot/scripts/GrappleSeat.gd`.

**If a vocabulary for this already exists, the grapple beat must reuse it rather
than invent a second one.** Say plainly whether it does, and name the file that
owns it. A second spelling of the same fact is how `target_region` and
`target_body_region` both came to exist.

## The deliverable

`research/Q58_THE_GRAPPLE_BEAT.md`:

1. **The per-kind field table** from Q1.
2. **The common-keys / payload-keys split**, stated plainly.
3. **The gap list** — every field a presented beat needs that a grapple event
   does NOT currently carry. **This is the most valuable part of the study**:
   each gap is either a change to `_log_grapple` or a derivation in the adapter,
   and knowing which is which before the code is written is the point.
4. **Who names the man on top**, in one sentence, with a `file:line`.

## HOW TO ANSWER

Label every claim **DOCUMENTED** (with `file:line`), **INFERENCE** (marked as
yours) or **NOT FOUND**. Your Q50/Q51/Q54/Q55/Q56/Q57 labelling was exactly right
and it is why those studies were usable.

Tables over prose. Under ~160 lines.

## Definition of done

- `research/Q58_THE_GRAPPLE_BEAT.md` exists and answers Q1-Q3.
- `git add -- research/Q58_THE_GRAPPLE_BEAT.md`, commit, push to master.
- Send one line:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q58-done --body "<sha> kinds=N common_keys=X gaps=Y top_names_the_man_on_top=<file:line or NOT FOUND>"`

## The traps specific to Q58

1. **Do not run Godot, and do not open `FightRealtime.gd` or `GameState.gd`
   whole.** 2,500 and 13,000 lines. `grep -n` then `sed -n 'A,Bp'`.
2. **DO NOT PROPOSE A DESIGN.** The temptation in a study like this is to write
   the beat you think we should build. Report what the fields ARE and where the
   holes are. A design offered here will be read as a measurement and that is how
   a wrong field list gets built into a seam.
3. **Report the field NAMES verbatim, including any inconsistency.** If one call
   site writes `defender` and another writes `target`, that discrepancy IS the
   finding — do not tidy it into one word. `target_region` and
   `target_body_region` both exist in the beat today precisely because someone
   tidied once.
4. **A `kind` you cannot find the fields for is NOT FOUND, not an empty row.**
   Two of the twelve are written through `_move_seat` rather than at the call
   site; if you cannot resolve what those carry without opening half the file,
   say so and stop. A bounded honest gap beats an hour of spelunking.
