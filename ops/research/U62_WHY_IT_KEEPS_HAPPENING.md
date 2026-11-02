# U62 — WHY IT KEEPS HAPPENING, AND WHAT TO CHANGE

**Owner:** cursor. **Kind:** analysis and design only. No code.

---

## 1. What is the single common cause?

**Proposed standing answer (to test):** *"a second source of truth that drifts, with a gate that checks the copy instead of the original."*

### Test against all seven

| # | Instance | Explained by that sentence? |
|---|---|---|
| 1 | Hand-typed fighter dict (`stats`/`attributes`, `weight_kg`/`competition_weight_kg`, missing `grapple`) | **Yes.** The screen's dict is a copy of the shape the engine expects; it drifted; nothing checked the engine's reads. |
| 2 | Contract test hand-copied that same dict | **Yes.** The gate validated the fossil copy, not the production builder. |
| 3 | `validate_technique_nodes.py` hardcoded 5/2/3 vocab vs live 10/3/16; `finish` passed and applied nothing | **Yes.** The textbook case (R136). Gate green against the copy; agents remapped good data to match it. |
| 4 | R135 hand-typed a nine-name counter-tag list and over-counted disagreement | **Yes.** Same hour, same defect, in analysis rather than a CI gate (R135 correction / C97). |
| 5 | 24 nodes carry `rulesets`; no code reads it | **No.** There is not a second source and not a gate. There is one authored field and zero consumers. Silence, not a green check of a copy. |
| 6 | Karate/judo (and peers) in the catalogue; `RULESET_DISCIPLINES` only maps boxing / kickboxing / muay_thai / mma (`FightMoves.gd` 184–189, 428–436) | **No.** Same as 5: dead inventory relative to the only draw path (`moves_for`). No drifted duplicate, no gate that passed the wrong list. |
| 7 | Measure tool labelled "kicker vs boxer", same stats/palette, unnamed catalogue; wrong conclusions | **Partly.** The `attributes` vs `stats` half is #1 again. The label-vs-reality half and the unnamed catalogue are free-floating *claims about the fixture*, not a gate checking a vocab copy. |

**Most valuable sentence:** the standing answer fails on 5 and 6. Those are not drifted copies under a green gate — they are authored facts that nothing ever exercises, so nothing can ever turn red.

**Better one-sentence cause (covers all seven):**

> **Every authored claim is allowed to ship unbound to the one consumer that would falsify it — so duplicates drift under self-checking gates, and orphans never fail at all.**

"Claim" here means a key name, a vocabulary word, a fixture label, a catalogue field, or a discipline id. "Consumer" means the engine path, the live catalogue declaration the engine also reads, or a measurement that goes through production code. Unbound claims split into two failure modes that look different but share a root: **fossils** (1–4, 7-keys) and **orphans** (5–6, unread tags, disciplines outside `RULESET_DISCIPLINES`).

---

## 2. What is the cheapest mechanism that would have caught the most of them?

Judge each candidate against the seven. "Catch" = would have failed loudly *before* a wrong ship or a wrong finding, without requiring an agent to remember a rule.

### A. Schema derived from the consumer

Engine (or live catalogue + engine match arms) declares what it reads; data and tools validate against that declaration — never against a hand list. R136 already moved the technique validator this way: derive roles/kinds/phases from the live catalogue, `SystemExit` if empty.

| Catches | Misses |
|---|---|
| 1 (wrong/missing fighter keys if schema is the engine's read set), 2 (test must satisfy same schema), 3 (directly), 4 (if analysis harvests tag names from the catalogue, not a typed list), 7-keys | 5 (a field can be "in schema" and still unread), 6 (a discipline node can be schema-valid and still undrawable), 7-label / unnamed catalogue / identical fighters |

**Drift of this mechanism:** if derivation returns empty or unreadable → hard refuse to run (R136 pattern). If someone re-hardcodes a list beside the derivation, that *is* a second source again — so the gate must have no alternate path and CI must fail on a hardcoded `ROLES = {...}` style constant in validators. Loud when empty; silent only if a human reintroduces a parallel list.

### B. Contract test that calls production code rather than mirroring it

Screen/tool/test builds fighters only through the same path the fight uses (`FightMoves.moves_for` / arsenal, real key names the sim reads). Assertions go through that path.

| Catches | Misses |
|---|---|
| 1, 2, 7-keys, 7-identical if the test asserts two arsenals/stats differ under a legal ruleset, 6 *if* a test asserts every catalogue `discipline.id` appears in some `RULESET_DISCIPLINES` value | 3 alone (needs derive-validator), 4 (analysis), 5 (unread field), 7-catalogue-name unless the harness is required to print which catalogue it loaded |

**Drift:** the test drifts when it stubs the builder or inlines a dict again. Counter: forbid inline fighter dicts in `tests/` and `tools/` by a cheap grep/AST check that only allows the factory call — fail the job if a literal `"attributes"` / `"stats"` block appears outside the factory. Discipline is not required; the check is.

### C. Startup or CI assertion that every authored key is read somewhere

Reachability: catalogue fields, effect keys, discipline ids — each must have a reader in `scripts/`, or sit on an explicit allowlist.

| Catches | Misses |
|---|---|
| 5 (`rulesets` unread → red or allowlisted), 6 (discipline never referenced from `RULESET_DISCIPLINES` → red), unread effect keys (today WARN in the validator; promote the ones that claim to be live) | 1 (engine *does* read `stats` somewhere — the producer just used the wrong name), 2, 3 (`finish` *was* "read" as a string in the bad validator), 4, 7-identical |

**Drift of this mechanism (the trap):** a naive "is the string in scripts/" check is how instance 3's effect-key WARN already works, and it can go stale the other way — allowlists that never expire, or substring false positives (`"leg"` inside unrelated identifiers). **Required anti-drift rules:** (1) allowlist entries must name *why* and *which task retires them*; CI fails if an allowlisted key gains a real reader (stale permission) *or* if a new unread appears without an entry; (2) prefer structured readers (const tables, `match` arms) over substring search where possible; (3) empty harvest of "known readers" → exit non-zero, never "0 unread, OK".

### D. Naming / ownership convention

"Always use `stats`", "always derive vocab", "never identical fighters", "name your catalogue".

| Catches | Misses |
|---|---|
| Nothing by itself in a five-agent, no-shared-memory repo | All seven, repeatedly — including after the operator stated the identical-fighters rule and it was broken three more times the same day (task trap; R137 correction) |

**Drift:** conventions are pure memory. Already failed. Reject as a primary control.

### E. Something not in the list: **bind authorship to the consumer in two lanes**

One mechanism with two checks, both derived, both loud:

1. **Fossil lane — production factory + derive-only gates.** One fighter/fixture builder whose required keys are harvested from the engine; screens, contract tests, and measure tools may not build athletes any other way. Technique (and similar) validators keep the R136 rule: vocabulary from the live catalogue / consumer `match` arms only; refuse empty.
2. **Orphan lane — reachability CI.** Every catalogue discipline id must appear in `RULESET_DISCIPLINES` (or a dated allowlist). Every node-level field that claims match relevance (`rulesets`, etc.) must have a reader or an allowlist entry. Measurements must print `catalogue=` and go through `moves_for`.

| | 1 | 2 | 3 | 4 | 5 | 6 | 7 |
|---|---|---|---|---|---|---|---|
| Fossil lane | Y | Y | Y | Y* | | | Y keys / identical |
| Orphan lane | | | | | Y | Y | catalogue named |

\*4 is caught when analysis scripts harvest tags the same way the validator harvests roles — not when a human types nine names.

**Caught: 7/7** if both lanes ship. Either lane alone tops out around 4–5/7.

**When this dual mechanism itself drifts:** each lane dies closed. Factory key harvest empty → builders cannot construct → CI red. Validator vocab empty → `SystemExit` (already). Reachability reader-index empty → CI red. Allowlist rot → red on "reader appeared" and on "new orphan". There is no soft pass that looks like VALIDATION OK while teaching the wrong word (instance 3's failure mode).

---

## 3. What does it cost?

### Build cost (once)

| Piece | Work | Notes |
|---|---|---|
| Fighter/fixture factory + migrate screen, C96-style test, measure tools | ~0.5–1 agent-day | Small API; delete inline dicts; one contract test that builds through the factory and asserts the engine sees non-default stats/weight/grapple. |
| Grep/AST guard: no inline athlete shape outside the factory | ~1–2 hours | Runs in existing Python tool lane; no Godot boot. |
| Generalize R136 derive pattern to any remaining hardcoded vocab in tools | ~hours, not days | Pattern already landed in `validate_technique_nodes.py`. |
| Reachability CI for disciplines ↔ `RULESET_DISCIPLINES` and unread node fields | ~0.5 day | Mirror `read_keys()` style harvest; start with discipline ids + known orphan fields (`rulesets`). |
| Allowlist file with retire-task ids | ~1 hour + policy | Without retire ids, the allowlist becomes the next fossil. |

**Not in scope of "cheap":** tagging 70 kicks, wiring `rulesets` into selection, inventing karate/judo rulesets. Those are product decisions Q68's census feeds. This task is the *binding* so those decisions cannot stay silently inert or silently wrong.

### Ongoing tax on every future agent task

| Tax | Who pays | Size |
|---|---|---|
| Call the factory instead of pasting a dict | Every agent writing a fight fixture | Seconds; failure is CI red, not a Slack reminder |
| Do not add roles/kinds/phases to a tool by hand | Anyone touching validators | Already the R136 rule; empty harvest blocks merge |
| New catalogue field → reader or allowlist row in the same PR | Anyone authoring data shape | One extra file touch; stops "ship now, wire never" |
| Measure harness must print catalogue + use production arsenal path | Anyone writing a funnel/tool | A few lines; stops R137-style false findings |

**A mechanism nobody will maintain is not a solution.** This one is maintainable because maintenance is *forced by red CI*, not by memory across five agents. The expensive alternative — more prose in task files and HANDOFF — is what already failed on identical fighters and on `attributes`/`stats` the same day it was fixed.

**What we must not do:** add another hand-maintained checklist of "valid keys" that agents edit data to satisfy. That *is* instance 3. Derivation + refuse-empty is the difference between a gate and a second catalogue.

---

## 4. What should we do FIRST, this week?

**One thing:** ship the fossil lane's fighter/fixture factory (consumer-derived required keys) and force the live screen, the contract test, and the kick/measure tools through it — with a CI grep that fails on new inline athlete dicts outside that factory.

**Why this beats the others this week**

- It addresses the bug that **recurred three times in one day** after being "fixed" (R133, C96, R137 correction) — instances 1, 2, and the key half of 7.
- It is cheaper than a full orphan census implementation, does not wait on Q68's count, and does not duplicate that census.
- It fails **loudly** (wrong keys never reach the sim; inline dicts fail CI) rather than asking agents to remember `stats` vs `attributes`.
- It is not "add more validation" in the instance-3 sense: the factory does not invent a vocabulary; it **harvests what the engine already reads**. If that harvest is empty, construction fails closed — the anti-drift answer the trap demands.
- Orphan lane (5–6) is the right second move once Q68 lists *what* is unwired; starting there this week without the factory leaves the measurement and screen layer still able to publish green lies.

**Explicitly deferred (not "first"):** wiring `rulesets`, inventing rulesets for orphan disciplines, and promoting every unread effect key to an error. Those need the census and product calls; the factory does not.

---

## Summary for the mail line

- **Cause:** authored claims ship unbound to their consumer — fossils drift under self-gates; orphans never fail (standing "second source + green gate" answer fails on instances 5 and 6).
- **Recommendation:** this week, one consumer-derived fighter factory + ban inline fixture dicts; then reachability CI for orphans.
- **Catches if both lanes land:** 7/7; factory alone: 4–5/7.
