# TASK U62 — CURSOR — WHY DOES THIS KEEP HAPPENING, AND WHAT IS THE OPTIMAL FIX

Model: Composer, **medium effort**. Owner: cursor.

**Test tier: ANALYSIS AND DESIGN. No Godot, no test, no parse gate** — you write
one markdown file and change no code.

Read THIS FILE and the files it names. Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

---

## THE OPERATOR'S QUESTION

> *"I thought we made so many research about the rules and you still finding
> incompatibilities"* … *"why these things exist in the game if they are not
> called"* … *"what is the optimal approach on our issues"*

**Q68 (Qwen) is counting WHAT is unwired. You are answering WHY, and what to
change so it stops.** Do not duplicate the census; assume it exists.

## THE EVIDENCE — SEVEN INSTANCES, ONE SESSION

Every one of these was authored, verified against itself, and never checked
against the code that would consume it.

1. **`FightWorldLiveScreen` hand-typed a fighter dictionary** and the engine read
   different key names. Three separate shipped bugs from one dictionary: `stats`
   vs `attributes` (R133), `weight_kg` vs `competition_weight_kg` (C96), and
   `grapple` simply absent. Both men fought on defaults; a 66.7 kg welterweight
   and a 120 kg heavyweight were mechanically identical.
2. **The contract test written to catch #1 hand-COPIED that same dictionary**, so
   fixing the screen alone would have left the test green against a fossil.
3. **`validate_technique_nodes.py` carried its own hardcoded vocabularies** — 5
   roles where the catalogue has 10, 2 kinds where it has 3, 3 phases where it
   has 16 — so four delivered trees "passed" while carrying `role: "finish"`,
   which the engine's `match` has no arm for. 66 techniques landed and applied
   nothing. Agents then *edited good data* to satisfy the stale gate.
4. **R135 (mine) hand-typed its own counter-tag list** an hour after writing #3
   up, and over-reported the disagreement by nine techniques.
5. **24 nodes carry a `rulesets` field** (`['k1','glory','dutch']` — low kicks are
   banned in American full contact). **No code reads it.**
6. **9 disciplines, 354 techniques** — karate 173, judo 115 — belong to no
   ruleset and can never be drawn by any fighter.
7. **A measuring tool declared its fixture "kicker vs boxer"** while giving both
   men the same stat block and the same palette, and never named which catalogue
   it had loaded. Two of its conclusions were wrong.

## WHAT YOU HAVE TO PRODUCE

**The optimal approach, argued and costed. Not a list of fixes — a change to how
we work that makes this class of defect impossible or loud.**

Answer these four, in order:

1. **What is the single common cause?** State it in one sentence. Our current
   answer is *"a second source of truth that drifts, with a gate that checks the
   copy instead of the original"* — **test that against all seven and tell us if
   it fails on any.** If a better one-sentence cause exists, give it.
2. **What is the cheapest mechanism that would have caught the most of them?**
   Judge candidates against the seven above, saying which each would and would
   not have caught:
   - a schema derived from the consumer (the engine declares what it reads; data
     and tests are validated against that declaration)
   - a contract test that calls production code rather than mirroring it
   - a startup or CI assertion that every authored key is read somewhere
   - a naming/ownership convention
   - something we have not thought of
3. **What does it cost?** Be concrete about the work, and about the ongoing tax
   on every future agent task. **A mechanism nobody will maintain is not a
   solution**, and we have five agents with no shared memory between sessions.
4. **What should we do FIRST, this week?** One thing. Say why it beats the others.

## OWNED FILES

- `research/U62_WHY_IT_KEEPS_HAPPENING.md` — **NEW. The only file you write.**

You change no code and no data.

## YOUR SOURCES

Read these, and nothing else:
- `research/R136_THE_VALIDATOR_WAS_THE_BUG.md` — instance 3, in full.
- `research/R137_THE_KICKS_CANNOT_REACH_THE_LEGS.md` — instance 7, including
  its own correction section where the author got it wrong twice.
- `research/R135_THE_TAGS_AND_THE_ROLE_DISAGREE.md` — instance 4.
- `Godot/scripts/FightMoves.gd` lines 177–200 and 415–470 — how a ruleset decides
  what a fighter knows. **Do not open it whole.**
- `Godot/tools/validate_technique_nodes.py` — read whole, it is short, and see
  what the fix to it looks like.

## THE GATE

- All four questions answered, in order, with the recommendation LAST and single.
- **Test the proposed common cause against all seven instances explicitly.** If it
  does not explain one of them, that is the most valuable sentence in your file.
- No implementation. No code. If you find yourself writing GDScript, stop.

## THE TRAP SPECIFIC TO THIS TASK

**The obvious answer — "add more validation" — is what caused instance 3.** The
validator was not missing; it was present, passing, and wrong, and it actively
corrupted four deliveries by making agents conform to it. Any mechanism you
propose must answer: *what happens when this mechanism itself drifts?* A proposal
that cannot answer that is the problem restated.

Second trap: **five agents share this repo and none of them share memory between
sessions.** A convention that depends on everyone remembering it has already
failed — the identical-fighters rule was stated by the operator, obeyed, and then
broken three more times in one day, including by the person writing it down.
Prefer mechanisms that fail LOUDLY over mechanisms that require discipline.

## When you are done

```bash
git add -- research/U62_WHY_IT_KEEPS_HAPPENING.md
git commit
git push origin master
python Tools/agent_comms.py send --from cursor --to claude --subject U62-done --body "cause=<one line> recommendation=<one line> catches=<N>/7"
```

Check `git status -s` before you stage. **Push to `master` and leave HEAD on
`master`.** Do NOT edit `HANDOFF.md`.
