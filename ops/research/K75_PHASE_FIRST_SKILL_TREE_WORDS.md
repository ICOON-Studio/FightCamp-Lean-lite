# K75_PHASE_FIRST_SKILL_TREE_WORDS.md

**Job:** Words only for the phase-first skill tree — personality chip lines, goal copy, read line, column heads, named cuts.  
**Not the job:** Layout, geometry, colour, type, fonts, `.gd`, `.tscn`, HANDOFF edit.

**Budget:** personality line ≤**60** · goal headline ≤**34** · consequence ≤**60**. Counts in `(n)`.

**Verified on Beast 2026-09-22:** `Godot/assets/data/career_goals.json`, `WorldPopulation.PERSONALITIES`, `Retention.PERSONALITY_SHIFT`, `fighter_requests.json` personality_weight, `CareerGoals.urgency()`.

---

## Three lines first

1. **Load-bearing:** Temperament is a **career-file label** (asks + loyalty). Personality lines must **not** imply the fight sim models it (K70 quiet-lie).
2. **Fight hardest to keep:** The READ template — `{claim} - {k} of {n} {quantity} {derivation}.` — only when both integers and the derivation key are **COMPUTED**. Drop “does not know it yet.”
3. **Least sure:** Whether knockdown-origin-by-phase (clinch vs standing) is retained in career aggregates — **NOT COMPUTED** in priors; do not ship the Moses clinch-KD line as COMPUTED.

---

## What already answers part of this

| Prior | Owns | K75 use |
|---|---|---|
| **K70** | Do not lie about wiring | Temperament ≠ fight AI |
| **K72 / K74** | COMPUTED / NOT COMPUTED; ≤60 manager lines | Same discipline |
| **career_goals.json** | 7 goal ids + personality_shift + blurbs | Goal table source of truth |
| **WorldPopulation.PERSONALITIES** | Eight labels | Chip set |
| **Retention.PERSONALITY_SHIFT** | Loyal +8 / Temperamental −8 / Ambitious −4 | Career COMPUTED for those three |
| **fighter_requests personality_weight** | Ask-frequency weights for all eight | Career COMPUTED (asks), not fight |
| **Ambitions.gd** | Six different career arcs | **Do not merge** with career_goals |
| **G64/G65/G66** | Fight-night / between-round / post-fight density | Labels convention only — not this screen’s type |

**Negative:** Fight-sim temperament was proposed in PERSONALITY_RESEARCH (G3) and is **not shipped**. Do not reopen it as copy.

---

## Labels

| Label | Meaning |
|---|---|
| **COMPUTED** | Engine stores or derives it today |
| **NOT COMPUTED** | Asserts behaviour or quantity the engine cannot know |
| **INFERENCE** | Manager-file copy contract — not an engine claim |

---

## 1. THE PERSONALITY LINE

**Register:** manager reading a file on a man he employs. Blunt. No fight flavour.

**Wiring (verified):** label from `WorldPopulation.PERSONALITIES`. Live career: ask weight (all eight), loyalty shift (three), recruitment display. **Not read by fight sim.**

| Temperament | Line | (n) | Honesty |
|---|---|---:|---|
| **Ambitious** | `Chases the next rung - will not sit quiet.` | 42 | Label **COMPUTED**. Ask weight 1.6 + loyalty −4 **COMPUTED** (career). Fight **NOT COMPUTED**. |
| **Analytical** | `Wants a reason for every call you make.` | 39 | Label **COMPUTED**. Ask weight 0.9 **COMPUTED**. Loyalty idle (0). Fight **NOT COMPUTED**. Line = **INFERENCE** file-meaning. |
| **Charismatic** | `Sells the room - needs a stage and a mike.` | 42 | Label **COMPUTED**. Ask weight 1.2 **COMPUTED**. Fight / press **NOT COMPUTED**. Line = **INFERENCE**. |
| **Disciplined** | `Keeps the week - skips the soft options.` | 40 | Label **COMPUTED**. Ask weight 0.9 **COMPUTED**. Fight **NOT COMPUTED**. Line = **INFERENCE**. |
| **Fearless** | `Takes the hard booking - does not duck heat.` | 44 | Label **COMPUTED**. Ask weight 1.1 **COMPUTED**. Booking preference **NOT COMPUTED**. Line = **INFERENCE**. |
| **Loyal** | `Stays when the offer is louder elsewhere.` | 41 | Label **COMPUTED**. Ask weight 0.6 + loyalty +8 **COMPUTED**. Fight **NOT COMPUTED**. |
| **Reserved** | `Keeps his own counsel - short on noise.` | 39 | Label **COMPUTED**. Ask weight 0.7 **COMPUTED**. Fight **NOT COMPUTED**. Line = **INFERENCE**. |
| **Temperamental** | `Turns on a slight - handle him carefully.` | 41 | Label **COMPUTED**. Ask weight 1.4 + loyalty −8 **COMPUTED**. Fight **NOT COMPUTED**. |

**Trap:** Never “swarms because Temperamental” / “Analytical reads the feint.” Quiet lie until fight wiring exists.

---

## 2. WHAT HE WANTS

### Shape review

Current: **two sentences + machine line** `goal <id> - urgency <LEVEL>`

| Piece | Verdict |
|---|---|
| Two sentences | **Cut to one consequence.** Second sentence that restates the headline is waste. Keep a second only if it names a manager act not in the consequence. |
| Machine line | **Keep.** Ids and urgency scoring are on disk (`CareerGoals.urgency` returns a float; UI may bucket HIGH/MED/LOW — bucket labels are presentation). |
| Urgency | **COMPUTED** as a float per goal from rank / fame / pay_ratio / loyalty context. Display word HIGH is **INFERENCE** unless UI code maps bands explicitly — verify mapper before claiming the word is COMPUTED. |

**Recommend:** headline + consequence as the human half; machine line under it; drop decorative second sentence.

### Seven goals (ids from `career_goals.json`)

Disk blurbs are short (“Climb the division ladder…”). Consequence lines below are the manager-act half the blurbs lack.

| goal id | headline | (n) | consequence line | (n) | Honesty |
|---|---|---:|---|---:|---|
| **rank_up** | `Climb the ranking board` | 23 | `Books up - refuses soft tune-ups.` | 33 | Id + urgency score **COMPUTED**. Consequence = **INFERENCE** (what wanting implies for booking). |
| **top_promotion** | `Get into a top promotion` | 24 | `Signs pressure - will jump gym to get in.` | 41 | Id + urgency **COMPUTED**. Jump-gym act **NOT COMPUTED** as auto-behaviour — **INFERENCE** for manager. |
| **champion** | `Win a world title` | 17 | `Forces title path - rejects dead-end cards.` | 43 | Id + urgency **COMPUTED**. Card-reject **INFERENCE**. |
| **top_of_the_ladder** | `Sit alone at the top` | 20 | `Wants undisputed - not co-main filler.` | 38 | Id + urgency **COMPUTED**. “Undisputed” as belt state **NOT COMPUTED** unless a field says so — treat as ambition voice **INFERENCE**. |
| **mastery** | `Master the craft` | 16 | `Chooses hard camps - skill over purse.` | 38 | Id + urgency **COMPUTED**. Camp choice **INFERENCE**. Distinct from Ambitions Technical Mastery — do not merge. |
| **get_paid** | `Get paid what he is worth` | 25 | `Holds out - money talk before ink.` | 34 | Id + urgency (pay_ratio) **COMPUTED**. Hold-out behaviour may touch FighterRequests — still mark act line **INFERENCE** until a request type is named on disk. |
| **stay_loyal** | `Stay with this gym` | 18 | `Turns down poaches - loyalty is the ask.` | 40 | Id + urgency (loyalty) **COMPUTED**. Poach refusal **INFERENCE**; Retention loyalty score is separate COMPUTED input. |

**Machine line:** keep `goal <id> - urgency <LEVEL>` when UI has a band mapper; else show score or omit the word HIGH.

---

## 3. THE READ LINE

### Current example (brief)

> He is a clinch fighter who does not know it yet - 9 of his 11 knockdowns started from a tie-up.

**Honest as COMPUTED copy?** **No.** Needs (a) KD count, (b) KD origin phase = clinch, (c) self-misread flag. (a) may exist in logs; (b) phase-of-KD career aggregate **NOT COMPUTED** in K72/K74 priors; (c) **NOT COMPUTED**. Moses numbers are illustrative.

### Template

```
{phase_or_role claim} - {k} of {n} {quantity} {derivation}.
```

Rules:
- Claim names a **role/phase habit**, not a temperament.
- `k` and `n` are integers from one derived quantity.
- Derivation names the filter (from clinch, after minute three, on the fence, …).
- **Omit** “does not know it yet” unless a COMPUTED self-scout field exists.
- Prefer ≤60 when sharing budget with other card lines.

### Three more instances

| Instance | Derived from | Honesty |
|---|---|---|
| `He wins rounds on the fence - 6 of 8 control minutes were cage.` (63) | control time cage vs open | Control minutes **may** be COMPUTED; cage-vs-open split **NOT COMPUTED** unless a zone key exists. |
| `His power is late - 4 of 5 KOs landed after minute three.` (57) | KO timestamps vs clock | KO count **may** be COMPUTED; minute-band **NOT COMPUTED** without retained timestamps. |
| `Takedown threat on paper - 1 of 12 attempts stuck.` (52) | attempts vs completions | Attempts/completions **may** be COMPUTED if aggregates keep them; “on paper” is voice — drop or mark **INFERENCE**. |

### Engine cannot currently compute

- Knockdown **origin phase** as career aggregate — **NOT COMPUTED**
- “Does not know it yet” / self-misread — **NOT COMPUTED**
- Temperament → in-fight habit — **NOT COMPUTED**
- Catalog phase share as fighter identity — catalog ≠ the man

---

## 4. COLUMN HEADS

**Do ENTER / WORK INSIDE / LEAVE survive STANDING and GROUND?**  
The **three-slot skeleton** survives. The **verbs’ sub-lines do not** — give each phase its own three sub-lines. Heads can stay ENTER IT / WORK INSIDE IT / LEAVE IT (or the brief’s ENTER IT / WORK INSIDE IT / LEAVE IT).

### Shared skeleton

| Slot | Job |
|---|---|
| **ENTER IT** | How he gets into this phase |
| **WORK INSIDE IT** | What he does while it lasts |
| **LEAVE IT** | How he exits or is forced out |

### Per phase (heads + sub-lines)

#### STANDING
| Head | Sub-line |
|---|---|
| **ENTER IT** | From bell, reset, or break — feet free. |
| **WORK INSIDE IT** | Range, jab, entries — refuse the tie if weak. |
| **LEAVE IT** | Shoot, clinch, or get put down. |

#### CLINCH
| Head | Sub-line |
|---|---|
| **ENTER IT** | Tie-up, underhooks, fence pin. |
| **WORK INSIDE IT** | Control, dirty box, break his posture. |
| **LEAVE IT** | Break, throw, or get peeled off. |

#### GROUND TOP
| Head | Sub-line |
|---|---|
| **ENTER IT** | Pass, sprawl lands, or sweep wins top. |
| **WORK INSIDE IT** | Hold position — damage or advance. |
| **LEAVE IT** | Finish, stall reset, or get swept. |

#### GROUND BOTTOM
| Head | Sub-line |
|---|---|
| **ENTER IT** | Taken down or rolled underneath. |
| **WORK INSIDE IT** | Frame, threaten, recover legs. |
| **LEAVE IT** | Stand up, sweep, or eat the pass. |

#### SCRAMBLE
| Head | Sub-line |
|---|---|
| **ENTER IT** | Broken position — neither owns it. |
| **WORK INSIDE IT** | Race to a knee, hip, or hook. |
| **LEAVE IT** | First clean position ends the scramble. |

**Note:** Brief used ENTER IT / WORK INSIDE IT / LEAVE IT with generic sub-lines (`how he gets hold of the man` …). Those generic sub-lines **fail** on STANDING and GROUND BOTTOM — replace with the phase set above. Heads can stay shared.

---

## 5. WHAT YOU WOULD CUT

| Cut / demote | Why |
|---|---|
| Fight-sim temperament flavour | Quiet lie (K70) |
| “Does not know it yet” on reads | NOT COMPUTED self-scout |
| Second decorative sentence under goals | Restates headline; consequence already acts |
| Ambitions milestone prose mixed into career_goals chips | Two systems; conflation costs trust |
| Pocket / weapon as sixth+ phase columns on v1 | Five-phase manager cut is enough |
| Poetry sub-lines | Not manager-actionable |
| Urgency word HIGH without a band mapper | Invented heat if mapper missing |
| Phase band % as personality | Catalog ≠ fighter identity |
| Charismatic → press answers (unless wired) | Press not driven by label today |

---

## Acceptance

- [x] Beast: `career_goals.json` — 7 goal ids confirmed; 8 personalities via WorldPopulation + synonyms
- [x] Temperament in fight sim — career-only (asks + loyalty); quiet-lie lines stand
- [x] Personality lines ≤60; no fight-sim claim
- [x] Goal headlines ≤34; consequences ≤60; honesty marked
- [x] Read template locked; COMPUTED gate named
- [x] Five phases each have ENTER / WORK INSIDE / LEAVE + sub-lines
- [x] Named cuts listed
- [x] No geometry / colour / type / fonts / HANDOFF / `.gd` from Kalli

---

## Character-count validation

| String | (n) | Cap |
|---|---:|---:|
| Chases the next rung - will not sit quiet. | 42 | 60 |
| Wants a reason for every call you make. | 39 | 60 |
| Sells the room - needs a stage and a mike. | 42 | 60 |
| Keeps the week - skips the soft options. | 40 | 60 |
| Takes the hard booking - does not duck heat. | 44 | 60 |
| Stays when the offer is louder elsewhere. | 41 | 60 |
| Keeps his own counsel - short on noise. | 39 | 60 |
| Turns on a slight - handle him carefully. | 41 | 60 |
| Climb the ranking board | 23 | 34 |
| Get into a top promotion | 24 | 34 |
| Win a world title | 17 | 34 |
| Sit alone at the top | 20 | 34 |
| Master the craft | 16 | 34 |
| Get paid what he is worth | 25 | 34 |
| Stay with this gym | 18 | 34 |
| Books up - refuses soft tune-ups. | 33 | 60 |
| Signs pressure - will jump gym to get in. | 41 | 60 |
| Forces title path - rejects dead-end cards. | 43 | 60 |
| Wants undisputed - not co-main filler. | 38 | 60 |
| Chooses hard camps - skill over purse. | 38 | 60 |
| Holds out - money talk before ink. | 34 | 60 |
| Turns down poaches - loyalty is the ask. | 40 | 60 |

---

**K75 complete.** Words only. Right rail remains K74. Fonts stay out of menus (operator rule). Claude lands HANDOFF when operator says go.
