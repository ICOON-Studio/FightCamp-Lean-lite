# DESIGN_KNOW_STAKES1_V3 — Knowledge Stakes Map (from the code)

Purpose: what does knowing a boxer's hidden habits change? v3 is written from the code (like LEDGER1 v3 and TURNPRO1 v4).
Every row is tagged CODE (file + function quoted), ESTIMATE (a target a probe must check) or CUT (no lever in the code).
No game code changes. No earlier critic scores.

---

## 1. What the game ALREADY does with a habit

The bank: `assets/data/fight_habits.json` — 20 habits, each with id, name, trigger, beat, effect, punish and three
corner notes. Words only; no per-habit cost numbers.

### 1.1 The hidden habit at walk-in

| What | Wire | Tag |
|---|---|---|
| A boxer carries her habits as `f["habits"]` — an array of ids from the bank | `Data.fighter_state` | CODE |
| The coach's notebook tracks what he has seen: `f["notes_seen"]` — strings like `"habit:<id>"` | `CoachNotes.gd` `seeable()`, `reveal()` | CODE |
| At signing the notebook is empty; the boxer's habits are unknown to the corner | `KnowWire.gd` `start()` → `Knowledge.fresh()` | CODE |
| The notebook can also hold `"trait:<key>"` for personality scores ≥ 70 or ≤ 40 | `CoachNotes.gd` `seeable()` | CODE |

### 1.2 How a habit is learned today

| Path | What fires it | Wire | Tag |
|---|---|---|---|
| **Punished in a bout** | A habit fires AND costs the boxer in an exchange (the opponent's situation punishes it) | `LiveRound.gd` line 423-427: each habit she paid for is appended to `notes_seen` as `"habit:<id>"` | CODE |
| **Coach's notebook after a fight** | `CoachNotes.reveal(f, "fight", rng)` — one more unseen thing, habits first | `BoutFinish.gd` `coach_note()` → `CoachNotes.reveal()` | CODE |
| **Sparring** | `CoachNotes.reveal(f, "sparring", rng)` — 35 % chance of one thing | `CoachNotes.gd` `SPAR_ODDS := 0.35`, called from `Sim.gd` | CODE |
| **Film on an opponent** (opponent's habits, not ours) | `OppFile.tape(opp)` opens the next hidden tell in tape order | `OppFile.gd` `tape()`, `open()` | CODE |
| **Film night in fight week** | Half-tape alone → full tape on a second look | `OppFile.gd` `half_tape()`, called from `FightWeekActs._film_night()` | CODE |
| **A bout against an opponent** opens her whole file | `OppFile.open_all(opp)` — three rounds show everything | `OppFile.gd` `open_all()` | CODE |
| **Rematch** | `OppFile.remember(record, opp)` — what was found is written to the career record, a rematch starts with it | `OppFile.gd` `remember()` | CODE |

### 1.3 What a habit costs

| What | Wire | Tag |
|---|---|---|
| One cost for every punished habit: `HABIT_COST = 6.0` power points in one exchange | `HabitFix.gd` header and `cost()` | CODE |
| The situations (Exchanges.MODES keys) that punish each habit — 17 of 20 habits have an entry | `HabitFix.gd` `PUNISHED_BY` | CODE |
| The bout multiplies the cost: `HABIT_BOUT = 1.75` | `Exchanges.gd` line 21 | CODE |
| The fix halves the cost by the hold (coachability × trust): `cost = -HABIT_COST × (1 - hold)` when fix matches | `HabitFix.gd` `cost()` | CODE |
| Clock habits: `slow_starter` costs in round 1's first 2 exchanges; `fades_late` in the last round from exchange 3 | `HabitFix.gd` `EARLY := 2`, `LATE := 3`, `punished()` | CODE |
| Three habits have no punish entry (they help or are mixed): `digs_body_when_hurt`, `switches_stance_under_pressure`, `talks_when_ahead` | `HabitFix.gd` `PUNISHED_BY` — absent for these | CODE |

### 1.4 How a habit is fixed

| Path | What it does | Wire | Tag |
|---|---|---|---|
| **Corner fix (mid-bout)** | The corner picks ONE habit the coach has seen (`notes_seen`) that can cost her; the fix holds by uptake for the next round | `HabitFix.gd` `offers()`, `LiveRound.gd` `fix` | CODE |
| **Signing focus "Fix the habit"** | The first habit is trained out in 4 weeks; sets `f["habit_fix"]` | `Recruit.gd` `FOCUS["habit"]`, `HABIT_WEEKS := 4`, `apply_focus()` | CODE |
| **Coachability gates the hold** | `Exchanges.uptake(coachability, 0) × trust` — how much of the fix reaches the ring | `LiveRound.gd` line 210 | CODE |

---

## 2. The STAKE — decisions that change because a habit is KNOWN

### 2.1 Signing — pay a read or sign blind

The signing card already shows one habit (Recruit), but the full list is hidden. The reads table decides how fast
the manager learns what she carries.

| Read | Price | What it narrows | Wire | Tag |
|---|---|---|---|---|
| Look closer | $120 | One group to half its day-one width, or clears Hyped | `KnowReads.gd` `PRICE_LOOK_CLOSER`, `apply()` | CODE |
| Trial | 4 weeks × $250/2 stipend = $500 | Every group as if signed (24 exposure body+skills) | `KnowReads.gd` `PRICE_TRIAL_WEEKS`, `_apply_trial()` | CODE |
| Test day | $60 | Body 4 off each edge; twice with under 5 bouts | `KnowReads.gd` `PRICE_TEST_DAY`, `_apply_test_day()` | CODE |
| Recheck | $40 | Wins back half of what went stale | `KnowReads.gd` `PRICE_RECHECK`, `Knowledge.recheck()` | CODE |
| Hard spar (club) | $0 cash, injury ×2, tiredness +15 | Under fire to half way | `KnowReads.gd` `risk()`, `Knowledge.hard_spar()` | CODE |
| Hard spar (outside) | $160, injury ×2, tiredness +15 | Under fire to 3/4 | `KnowReads.gd` `PRICE_HARD_SPAR_OUTSIDE` | CODE |

The signing decision: the prospect card shows the one habit from Recruit, the traits, the class and the stars range.
The reads above narrow the attribute ranges — not the habit list directly. The habits are learned through the
coach's notebook (sparring, bouts) after signing. ESTIMATE: a probe must check whether paying for a look closer
before signing changes the roster's top-10 finish rate vs signing blind.

### 2.2 The bout offer — a risk line when the opponent's style punishes a known habit

The pairing already exists in the code: `HabitFix.PUNISHED_BY` maps each of our habits to the Exchanges.MODES
situation that punishes it; `Exchanges.STYLE_MODES` maps each opponent style to the situations it plays. The
risk line is the join of those two tables.

| Our habit (known) | Punished in situation | Opponent styles that play that situation most | Wire | Tag |
|---|---|---|---|---|
| drops_right_after_jab | counter | Counter-puncher (0.55), Spoiler (0.4) | `HabitFix.PUNISHED_BY` × `Exchanges.STYLE_MODES` | CODE |
| freezes_on_ropes | press | Pressure fighter (0.55), Swarmer (0.65), Stalker (0.5) | same | CODE |
| switches_stance_under_pressure | press | same | same | CODE |
| talks_when_ahead | counter | Counter-puncher (0.55), Spoiler (0.4) | same | CODE |
| loads_up_when_hurt | she_hurt | (any style — the situation is our state, not the opponent's) | `HabitFix.PUNISHED_BY` | CODE |
| covers_up_when_hurt | she_hurt | same | same | CODE |
| wide_hook_tell | counter, range | Counter-puncher (0.55), Out-boxer (0.6) | same | CODE |
| retreats_straight_back | press | Pressure fighter (0.55), Swarmer (0.65) | same | CODE |
| admires_her_work | counter | Counter-puncher (0.55), Spoiler (0.4) | same | CODE |
| lunges_with_jab | range | Out-boxer (0.6), Boxer-puncher (0.35) | same | CODE |
| head_down_inside | press | Pressure fighter (0.55), Swarmer (0.65) | same | CODE |
| clinches_when_tired | she_tired | (our state) | same | CODE |
| bites_on_feints | counter | Counter-puncher (0.55), Spoiler (0.4) | same | CODE |
| low_lead_hand | loadup | Slugger (0.45), Boxer-puncher (0.25) | same | CODE |
| one_and_done | press | Pressure fighter (0.55), Volume puncher (0.45) | same | CODE |
| chases_stoppage | hurt | (opponent state) | same | CODE |
| waits_too_long | range | Out-boxer (0.6), Boxer-puncher (0.35) | same | CODE |
| slow_starter | round 1, first 2 exchanges | (clock — any opponent) | `HabitFix.punished()` | CODE |
| fades_late | last round, exchange 3+ | (clock — any opponent) | same | CODE |
| digs_body_when_hurt | (helps — not punished) | — | — | CODE |

ESTIMATE: the bout offer screen shows a risk banner when the opponent's main game (ModeTells.free_mode or the
STYLE_MODES top share) intersects a known habit's punish situation. A probe must check the banner appears for
the right pairings and not for the others.

### 2.3 The game plan — the answering line

`PlanLines.HABIT_SITS` maps 7 of our habits to plan situations; the opponent file's tape order puts each
opponent habit in the same slot.

| Habit (ours or opponent's) | Plan situation | The answering call | Wire | Tag |
|---|---|---|---|---|
| fades_late | tiring | "let_go" — make it a busy start | `PlanLines.HABIT_SITS`, `CALL_SITS` | CODE |
| slow_starter | tiring | "let_go" — start fast, bank round 1 | same | CODE |
| admires_her_work | tiring | "let_go" — keep throwing | same | CODE |
| drops_right_after_jab | range | "body" — get under the jab, go to the body | same | CODE |
| lunges_with_jab | press | "long" — stay at the end of the jab | same | CODE |
| digs_body_when_hurt | hurt | "finish" — keep pressing when she dips | same | CODE |
| loads_up_when_hurt | hurt | "finish" — stay calm, do not load up back | same | CODE |

The remaining 13 habits have no `HABIT_SITS` entry — they have no plan branch yet. ESTIMATE: a probe must check
which of the 20 habits get a plan arrow when known, and which do not. The 7 with an entry are the only ones the
game plan can answer today.

### 2.4 The week — an existing training lever only

| Lever | What it does | Wire | Tag |
|---|---|---|---|
| Signing focus "Fix the habit" | Trains out the first habit in 4 weeks | `Recruit.FOCUS["habit"]`, `apply_focus()` | CODE |
| Corner fix per round | One fix, held by uptake, for the next round only | `HabitFix.offers()`, `LiveRound.gd` | CODE |
| Sparring reveals | 35 % per sparring week of one notebook entry | `CoachNotes.SPAR_ODDS`, `Sim.gd` | CODE |
| Film night (fight week) | Opens one opponent tell per session (half-tape counts) | `OppFile.half_tape()`, `FightWeekActs._film_night()` | CODE |

No per-habit mitigation numbers exist in the code. There is no "drill jab recovery −50 %" or similar — the only
fix levers are the corner minute and the signing focus. CUT: v2's §4.3 training mitigation table (per-habit
weekly penalties of −40 %, −50 %, −60 %) has no lever.

---

## 3. Kept from v2 (sound)

### 3.1 Once revealed, shown everywhere

| Rule | Wire | Tag |
|---|---|---|
| A habit found by the notebook, sparring or a bout is written to `notes_seen` and never removed | `CoachNotes.reveal()`, `LiveRound.gd` line 423-427 | CODE |
| An opponent's file, once found, is remembered for rematches | `OppFile.remember()` | CODE |
| A bout against an opponent opens her whole file | `OppFile.open_all()` | CODE |

### 3.2 Wire table — every menu, what it shows, what it opens

| Menu | What it shows | Wired to | Owner | Tag |
|---|---|---|---|---|
| Roster — fighter card | Coach's notebook lines (known habits, one note per habit from the bank) | `CoachNotes.card()` → FighterPage | S425 | CODE |
| Fighter page — Overview | Known habits with trigger, punish and the corner note | `CoachNotes.card()`, `fight_habits.json` | S425 | CODE |
| Scouting / Prospect card | One habit (Recruit), traits, class, stars range | `Recruit.gd` | S425 | CODE |
| Bout offer page | Risk banner when opponent's main game intersects a known habit's punish situation | `HabitFix.PUNISHED_BY` × `Exchanges.STYLE_MODES` | S425 | ESTIMATE |
| Fight prep — Plan | Answering lines for the 7 habits in `HABIT_SITS`; locked lines for the 13 without | `PlanLines.HABIT_SITS`, `PlanFile.gd` | S425 | CODE |
| Week — What to Work On | Signing focus "Fix the habit" (4 weeks); corner fix is mid-bout only, not weekly | `Recruit.FOCUS["habit"]` | S425 | CODE |
| Post-bout recap | Newly revealed habit: the coach's notebook line from the bank | `BoutFinish.coach_note()`, `CoachNotes.card()` | S425 | CODE |
| Opponent file | Opponent's habits found through film, in tape order | `OppFile.tells()`, `ModeTells.tape_order()` | S425 | CODE |
| Corner card (mid-bout) | Fix options: habits the coach has seen that can cost her | `HabitFix.offers()` | S309 | CODE |
| Corner result (next card) | What last round's fix did — came up N times, cost X % less | `HabitFix.result()` | S320 | CODE |

### 3.3 BLIND / READ-FIRST / ORACLE probe

| Group | What it does | Cost per signing | Tag |
|---|---|---|---|
| BLIND | Sign zero info; learn only from the coach's notebook (sparring + bouts) | $0 | ESTIMATE |
| READ-FIRST | Pay for a test day ($60) or hard spar outside ($160) before every signing | $60–$160 / signing | ESTIMATE |
| ORACLE | All habits visible from day one (perfect information — upper bound) | $0 (benchmark) | ESTIMATE |

Pass lines (targets a probe must check across 150+ worlds):

| Metric | BLIND vs READ-FIRST | BLIND vs ORACLE | Tag |
|---|---|---|---|
| Top-10 finish rate | READ-FIRST ≥ 4 % above BLIND | ORACLE ≥ 8 % above BLIND | ESTIMATE |
| Losses attributed to known/unknown habits | tracked per world | same | ESTIMATE |
| Win rate when habit risk flagged vs not | tracked per world | same | ESTIMATE |
| Cost vs profit per season | tracked per world | same | ESTIMATE |

Population: 150+ worlds, 4 seasons each, 12-contract roster, same matchmaking bot logic across all groups.
The four weight classes, three boxers + one BJJ (S428 test club) are the roster shape.

---

## 4. CUT — what has no lever in the code

| v2 item | Why it is cut | Tag |
|---|---|---|
| Per-habit costs (−4, −5, −7, −8) | The code has ONE value: `HabitFix.HABIT_COST = 6.0`. No per-habit numbers exist. | CUT |
| "Defence −25 %" on freezes_on_ropes | No defence modifier exists for any habit. The cost is power points in an exchange. | CUT |
| v2's reveal chances (70 %, 90 %, 40 %) | The code's reveal paths are deterministic or 35 % (sparring). No per-habit percentages. | CUT |
| v2's §4.3 training mitigation table (per-habit weekly penalties) | No per-habit mitigation lever exists. The only fixes are the corner minute and the signing focus. | CUT |
| v2's "Emerging habits" (§4.5) | A new system with no lever in the code. Habits are assigned at creation, not developed. | CUT |
| v2's "Test day reveals ALL habits — full list" | Test day narrows body attributes (`KnowReads._apply_test_day()`). It does not reveal habits. | CUT |
| v2's "Trial reveals Freezes on ropes + Slow starter" | Trial narrows attribute groups (`KnowReads._apply_trial()`). It does not reveal specific habits. | CUT |
| v2's "$30 for a trial day" | The code's trial price is 4 weeks × $250/2 = $500 (`KnowReads.PRICE_TRIAL_WEEKS`). | CUT |
| v2's "$150 for test day" | The code's test day price is $60 (`KnowReads.PRICE_TEST_DAY`). | CUT |
| v2's "$200 for outside sparring" | The code's outside sparring price is $160 (`KnowReads.PRICE_HARD_SPAR_OUTSIDE`). | CUT |
| v2's "10 % of prospects have No Punished Habit" | No such generator exists. Every boxer gets habits from the bank at creation. | CUT |

---

## 5. Changed from v2

1. **Every number now comes from the code.** v2 invented per-habit costs (−4 to −8), reveal chances (70/90/40 %),
   mitigation penalties (−40/50/60 %) and prices ($30, $150, $200). v3 quotes `HabitFix.HABIT_COST = 6.0`,
   `KnowReads` prices ($120, $500, $60, $40, $0, $160), and `CoachNotes.SPAR_ODDS = 0.35`.
2. **The reads table replaces v2's reveal actions.** v2's "Trial reveals Freezes on ropes + Slow starter" was
   wrong — trial narrows attribute groups, not habits. v3 uses `KnowReads.narrows()` and `KnowReads.apply()`.
3. **The risk line is the join of two existing tables.** v2 described a generic risk banner. v3 names the exact
   pairing: `HabitFix.PUNISHED_BY` × `Exchanges.STYLE_MODES`, with the full 17-habit table.
4. **The game plan answers 7 of 20 habits, not all 20.** v2 implied every habit gets a plan line. v3 quotes
   `PlanLines.HABIT_SITS` — 7 entries — and marks the other 13 as having no plan branch yet.
5. **Training mitigation is cut.** v2's §4.3 had a per-habit weekly training table. The code has two fix levers:
   the corner minute (`HabitFix.offers()`) and the signing focus (`Recruit.FOCUS["habit"]`). No third exists.
6. **"Emerging habits" are cut.** v2's §4.5 invented a late-career habit system. The code assigns habits at
   creation; no mechanism develops new ones.
7. **The probe population is named.** v2 said "150+ worlds" without naming the roster shape. v3 ties it to the
   four weight classes and the S428 test club (three boxers + one BJJ).
8. **The wire table has owners.** Every menu row is tagged S425 (the owner's ruling that new mechanics must be
   wired and shown). The corner card and result are tagged S309 and S320 (the original corner-fix rulings).
9. **No names in lines.** v2 quoted habit names in example risk lines. v3 follows S448 (names only in headers)
   and S412 (no he/she) — the code's own `HabitFix.line()` already uses roles, not names.
10. **The coach's notebook is the reveal path for our habits; the opponent file is the reveal path for theirs.**
    v2 mixed the two. v3 separates them: `CoachNotes.reveal()` for our boxers, `OppFile.tape()` for opponents.
