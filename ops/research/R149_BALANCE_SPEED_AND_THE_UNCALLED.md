# R149 — BALANCE, SPEED, AND THE 2,707 LINES NOBODY CALLS

Claude, 2026-09-19. Commissioned by the operator after S18 left `balance`
open: *"do a proper study on how balance and speed and whatever we are
missing should be put in the game."*

Measured on disk at `7b018d99`. **This does not redo R147** — R147 §2 already
lists personality, training strands, diet scales and treatment as authored-but
-fight-blind, and §3 lists the attributes worth adding. This is the layer R147's
own item 1 exposed underneath it: the **vocabulary** layer, where a word exists
in one place and nothing reads it in another.

---

## THE HEADLINE

**Balance is not missing from this game. It is in the game three separate times,
and not one of the three is connected to the other two.** Speed is the opposite
case: it is wired almost everywhere it should be, and the one place it is absent
is the exact place the operator's own footwork ruling says it belongs. And the
sweep that found both turned up **16 modules, 2,707 lines, fully written and
fully tested, that no production code calls.**

---

## 1. BALANCE — BUILT THREE TIMES, WIRED ZERO TIMES

### 1a. The three copies

| where | what exists | what reads it |
|---|---|---|
| **Training tag** | `balance` on `judo_tatami_area`, 1 use in the catalogue | **nothing** — in neither training map (S18) |
| **State module** | `BalanceState.gd`, **146 lines**, `kuzushi`/`sweep`/`stagger`/`stuffed_shot` causes, decay curves sourced to G59 | **nothing** — `balance_state_test.gd` and two comments, zero production callers |
| **Catalogue vocabulary** | **26 techniques** carry a `balance_break` effect; plus `sweep`, `sweep_threat`, `off_balance_threat`, `muay_thai_dumps_offbalance`, `silat_offbalance_chain` | **nothing** — `FightMoves.gd` mentions `balance_break` only to explain why it is *not* in a palette list |

### 1b. The seam it was built for is named in its own header, and is one line

`BalanceState.gd:11-12` says it outright:

> `kuzushi_at` returns 0.0–1.0 where 0.0 is balanced. **GrappleResolve will later
> multiply defender resistance by `(1.0 - kuzushi_at(...))`.**

That multiplication site exists and is two lines long
(`GrappleResolve._success_probability:137-139`):

```gdscript
var def_score: float = _weighted_sum(defender, DEF_WEIGHTS)
def_score *= FatigueCurveModule.defense_multiplier(fatigue_def)
```

**A fatigue multiplier is already applied there in exactly the shape the balance
one was specified in.** The work is not architecture; it is carrying a
`balance_state` on the fighter and threading `now_s` to the call.

### 1c. THE ARITHMETIC THAT KILLS R147's ANSWER — AND MOST OF THE OTHERS

R147 §1 said of the tag: *"`balance` on the tatami, which is a design call — **I
would map it to `grapple`**."* R147 §7 offers `grapple`, `defense`, or a new
stat.

**`grapple` and `defense` both change nothing whatsoever, and this is provable
rather than arguable.** `_apply_focus_stat_gains` de-duplicates by CANONICAL
STAT, and `judo_tatami_area` is the only station carrying `balance`:

```
judo_tatami_area  ->  ["technique", "balance", "defense", "grappling"]
                        ^technique   ^?        ^defense   ^grapple
```

Every stat a `balance` mapping could plausibly point at is **already trained by
a sibling tag on that same station**:

| candidate | result | why |
|---|---|---|
| `grapple` (R147's pick) | **inert** | `grappling` already trains it |
| `defense` | **inert** | `defense` already trains it |
| `technique` | **inert** | `technique` already trains it |
| `speed` | +1 stat trained | not on the station |
| `power` / `conditioning` / `fight_iq` | +1 stat trained | not on the station, and none is what balance means |
| new 8th stat | +1 stat, +migration | see 1d |

**So the question as R147 posed it cannot be answered in a way that changes the
game.** Three of its candidates are decorative; the only ones with teeth are
ones nobody has argued for.

### 1d. WHAT THE STANDING RULING ACTUALLY SAYS, AND WHERE IT CONTRADICTS THE CODE

The operator's recorded ruling: **"Balance is a STATE and it IS directional."**

`BalanceState.gd:5-9` agrees with the first half and *documents its failure of
the second*:

> Balance is a transient STATE, not an attribute. This pass stores magnitude
> only; **direction is explicitly unmodelled**. A break along a weak line and a
> break along a strong line are worth the same today — a known, recorded
> deficiency, not an oversight.

`direction_modelled()` returns `false`, and its test asserts that it does.

**So the ruling is half-implemented in a module nothing calls.** Stance
(orthodox/southpaw) is what defines the weak line, and the header says so.

**This settles the training-tag question by a route R147 did not take.** If
balance is a STATE, it is not a stat, and a training tag pointing at a stat is
the wrong instrument for it — the same way `recovery` is deliberately unmapped
because it pays out as fatigue rather than growth.

### 1e. RECOMMENDATION ON THE TAG (the operator's open question from S18)

**Leave `balance` unmapped, and make that deliberate rather than accidental** —
move it from the test's `AWAITING_OPERATOR_RULING` into a named
`STATE_ONLY_MODIFIERS` list beside `RECOVERY_ONLY_MODIFIERS`, with the ruling
quoted in the comment. Cost: ~4 lines and a test edit. It changes no number,
which is the honest outcome, and it stops the tag reading as an oversight to a
future session.

**The alternative worth a sentence, not more:** if the operator wants the tatami
to train something extra, the only non-decorative answer is `speed` — the
existing map already keeps `agility` and `rhythm` there, and staying upright is
nearer to those than to `power`. It is a gameplay change (a 4th stat on that
station), not a bug fix, and should be decided as one.

---

## 2. SPEED — WIRED ALMOST EVERYWHERE, ABSENT FROM THE ONE PLACE A RULING PUTS IT

### 2a. Where speed already reaches

After S18 mapped the literal `speed` tag, the stat is genuinely live:

| site | what speed does |
|---|---|
| `FightSimulation:1411` | initiative, with `fight_iq` — who acts next |
| `FightSimulation:3619` | the striker's own hit chance |
| `FightSimulation:3639` | the target's guard, half-weighted with `defense` |
| `FightSimulation:1262-1269` | the `blitz` camp buff (+6, restored after) |
| `GrappleResolve:23,30,37` | 0.15 weight in all three contest tables |
| `FightMoves:437` | action selection |
| `FightFootwork.top_speed:110` | metres per second, settled once at `_build_fighter` |
| `FightFootwork.acceleration:125` | how hard he changes direction, scaled by the live tank |

**R147's speed item was only the missing training tag, and that is fixed.** The
stat itself is not under-modelled.

### 2b. The one real gap, and it is not a guess

The operator's footwork ruling, verbatim: footwork is *"purely scoring and
rhythm, and helps dodge, repositioning and in general is **the catalyst in
transitioning defined by speed**, never needed to move anybody."* The
ALREADY-DECIDED note adds that whether the engine does that *"is a question
about `FightFootwork`/`FightIntent`/`FightDefence` that nobody has measured — it
is a RESEARCH question."*

**Measured here.** `FightIntent` is the module that decides the transition —
`close` / `hold` / `retreat` / `circle`. Every stat it reads:

```
FightIntent.preferred_range:39-40   power, technique
FightIntent.tolerance:51            fight_iq
```

**`FightIntent` never reads `speed`. Not once in 189 lines.** (`FightDefence.gd`
does not exist; defence lives inside `FightSimulation` and `FightRealtime`.)

So speed reaches the **execution** of movement — how fast he crosses the floor,
how hard he can check and go the other way — and has no say in the **decision**
to transition at all. The ruling says speed is the catalyst *of the transition*.
Today it is the catalyst only of the travel.

**This is the answer to the research question the ruling left open, and it is a
real gap rather than a defect:** nothing is broken, the ruling simply is not
implemented. It is also small — `FightIntent.tolerance` and the four intent
bumps are where a speed term goes, and a fast man should flip intent on less
provocation than a slow one.

### 2c. What NOT to do with it

The same ruling says footwork is **"never needed to move anybody"**, and S10
measured that the correlation does not exist. **Do not make a speed term carry
the man.** The change is to how readily he *chooses* to close, hold, retreat or
circle — not to displacement.

---

## 3. WHAT ELSE IS MISSING — THE SWEEP

Both balance findings are the same shape: written, tested, never called. So the
sweep was run over the whole tree rather than trusting the two examples.
**Verified by grep over every `.gd`, `.tscn` and `.tres`, excluding each
module's own file, `tests/` and `tools/`:**

| lines | module | what it is |
|---:|---|---|
| 558 | `FeedbackOverlay.gd` | player feedback surface |
| 408 | `ScorecardPanel.gd` | the judges' scorecard panel |
| 346 | `FightClipAudit.gd` | clip-coverage audit |
| 208 | `MedalTable.gd` | medal table |
| 151 | `HonoursBoard.gd` | honours board |
| 147 | `TitleTenure.gd` | title reign lengths |
| **146** | **`BalanceState.gd`** | **the balance state above** |
| 123 | `FightStoppageRead.gd` | stoppage read-out |
| 114 | `ArenaFit.gd` | arena sizing |
| 105 | `CompetitionAge.gd` | competitive age |
| 97 | `SurfaceWords.gd` | surface vocabulary |
| 74 | `SpreadWords.gd` | spread vocabulary |
| 65 | `ContestLength.gd` | contest length |
| 63 | `RingPlace.gd` | ring position words |
| 56 | `LedgerWords.gd` | ledger vocabulary |
| 46 | `VenuePhotos.gd` | venue photos |

**16 modules, 2,707 lines — 8.2% of the 195 scripts, calling nothing and called
by nothing.** Two candidates were REJECTED on verification and are not in the
table: `FightHudPanel.gd` (533 lines, called by `FightStageDirector`) and
`DevJump.gd` (287, called by `SceneRouter` and `MatchSimulatorPanel`). The first
sweep's regex missed both; the numbers above are the grep-verified set.

**And the suite pays for them every run.** 16 of the 309 test files are the
dedicated test for one of these modules (plus `fight_stance_test.gd`, which
mentions `BalanceState` only in a comment) — **5.2% of a twenty-minute suite
spent guarding code that cannot affect the game.** They should not be deleted:
each one is a finished component waiting on a caller, and the test is what makes
picking it up cheap. But the count is worth knowing when the suite's cost comes
up again.

**This is a different failure from R147 §2.** Personality and training strands
are *read* by management code and never reach the fight. These 16 are not read
by anything at all. R147 found things wired to half the game; this found things
wired to none of it.

---

## 4. ORDERED PROPOSALS

Smallest first. 1 and 2 are the operator's open question closed; 3 is the one
with real teeth.

1. **Rule `balance` a state word, not a stat** (~4 lines + test). Moves it from
   `AWAITING_OPERATOR_RULING` to a `STATE_ONLY_MODIFIERS` list with the ruling
   quoted. Changes no number. **Closes the S18 blocker.**
2. **Record the 16 uncalled modules where a session will see them** — a list in
   the roadmap rather than a new file, so the next stage that needs a scorecard
   or a stoppage read-out finds the 408 lines already written.
3. **Connect `BalanceState` to `GrappleResolve`** (small-to-medium). The one
   multiplication is specified in the module's own header, the site already
   applies a fatigue multiplier in the same shape, and **26 catalogue techniques
   already carry the `balance_break` effect that would feed it.** This turns a
   sweep from a die roll into a consequence. Needs: a `balance_state` on the
   fighter, `now_s` threaded to `kuzushi_at`, and a decision on which techniques
   raise which cause.
4. **Give `FightIntent` a speed term** (small). Implements the footwork ruling's
   "catalyst in transitioning, defined by speed". A fast man flips intent on
   less provocation. **Must not move him** — S10 and the ruling both forbid it.
5. **Direction on balance** (medium, and only after 3). The operator ruled
   balance IS directional; `direction_modelled()` returns `false` and the header
   names stance as what would define the weak line. Worth nothing until
   something reads magnitude.

---

## 5. WHAT THIS DOES NOT RE-OPEN

- Whether footwork carries the man — **ruled 2026-09-18, it does not.** Proposal
  4 is explicitly not that.
- R147 §2's personality / strands / diet / treatment findings — unchanged and
  not re-measured here.
- The aggression and durability items (R148 rulings 1 and 2) — R148 owns those;
  durability shipped as S17.

## 6. TEST COMMAND

No `.gd` touched — research tier, no gate (CLAUDE.md). The nearest live check of
the vocabulary this study is about:

```
python Godot/tools/run_tests.py --only training_modifier_map
```
