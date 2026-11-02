# R134 — THE SEVEN STATS ARE FULLY WIRED AND NONE OF THEM IS DEFINED

**Prompted by the operator, 2026-09-12: "did you assign researches for all
statkeys?"** The answer was no, and the gap is larger than the question implies.

Balance break got a **domain briefing, a spec, and assigned research** before a
line of code was written for it (`R131_BALANCE_BREAK_BRIEFING_SOURCE.md`, R131,
G59). **The seven stats that have been running the fight for months got the
reverse**: code first, and no definition ever.

This file is the engine-side half — **what each stat actually controls today**,
read out of the source. It is the brief the domain research hangs off, so nobody
is sent to research `fight_iq` without first knowing what `fight_iq` currently
does.

**Nothing here is a proposal.** It is a census.

---

## THE SEVEN

`GameState.gd:182` — `const STAT_KEYS := ["power", "technique", "speed",
"defense", "conditioning", "fight_iq", "grapple"]`.

**`conditioning` is the key; "stamina" is only its UI label** (`GameState.gd:180`
maps `"stamina" -> "conditioning"`). Both names appear in the tree and they are
the same stat. `stamina` also exists at runtime as a **depleting tank** on
`FightRealtime`'s fighter state — a different quantity entirely, fed BY
conditioning. Two things, one word, and it is a live trip hazard.

## READ SITES, OUTSIDE THE PROGRESSION FILES

Counted across `Godot/scripts/*.gd`, excluding `GameState`,
`AthleteDevelopment`, `DevelopmentPanel`, `Aging` and `WorldPopulation` (which
grow and store the stats rather than spend them):

| stat | sites | heaviest readers |
|---|---:|---|
| `grapple` | 52 | `GrappleResolve`, `FightRealtime` |
| `conditioning` | 50 | `FightRealtime` (stamina drain, heart rate), `FatigueCurve` |
| `technique` | 43 | `FightSimulation`, `FightRealtime` |
| `defense` | 32 | `FightSimulation`, `GrappleResolve` |
| `speed` | 31 | initiative, burst, `FightFootwork` |
| `fight_iq` | 31 | initiative, `GrappleResolve`, `FightIntent` |
| `power` | 28 | impact force, knockdown magnitude |

Thirty-one script files read at least one of them.

---

## WHAT EACH ONE ACTUALLY DOES — AND THE CONSTANT THAT DOES IT

Every line below is the real conversion from a 0–100 rating into a fight effect.
**Not one of them cites a source.**

### `power`
- `FightSimulation.gd:2063` — `power_scale := 0.5 + power / 100.0`. **A 0-power
  fighter hits at 0.5x and a 100-power fighter at 1.5x. The whole span of human
  punching power is three-fold.**
- `FightSimulation.gd:2537` — knockdown magnitude `6.0 + power * 0.12 +
  technique * 0.08`. Power is worth **1.5x** technique in putting a man down.
- `FightRealtime.gd:1596` — `power/100 * Fatigue.power_multiplier(fatigue)`, into
  `FORCE_BASE + FORCE_POWER_SPAN * power`.
- `GrappleResolve.gd:22` — **`.20` of every takedown attempt.**

### `technique`
- `FightSimulation.gd:1348, 2559` — normalised `technique/100` into execution quality.
- `FightRealtime.gd:1482` — into the **flush exponent**: `FLUSH_EXPONENT_MAX -
  FLUSH_EXPONENT_SPAN * technique`. Technique decides how cleanly a punch lands.
- `FightSimulation.gd:3213` — damps burst jitter.
- `GrappleResolve.gd:24` — **`.10`. The LOWEST of the attacker's five weights.**

### `speed`
- `FightSimulation.gd:1239` — initiative is `(speed + effective_fight_iq) *
  mobility`. **Speed and fight IQ are added as equals and nothing says why.**
- `FightSimulation.gd:1522` — a **hard cliff**: `if speed >= 60.0: window += 1`.
  59 and 60 are different fighters; 60 and 100 are not.
- `FightSimulation.gd:3230` — half of the guard term.
- `GrappleResolve.gd:23` — `.15`.

### `defense`
- `FightSimulation.gd:2434` — `defense/100 * 0.35 + bonus`, **clamped at 0.6**.
  Defence alone can never exceed 35%; the rest must come from authored technique.
- `FightSimulation.gd:2120` — submission threshold `+ defense * 0.35`.
- `FightRealtime.gd:1624` — `defense/100 * Fatigue.defense_multiplier(fatigue)`.
- `GrappleResolve.gd:36` — **`.30` on the defender's side, where it is the second
  heaviest term.** It appears in NO attacker weighting.

### `conditioning`
- The most wired of the seven. Feeds `Stamina.strike_drain`,
  `Stamina.impact_drain`, `Stamina.movement_drain`, `Heart.from_stamina`,
  `FatigueCurve` and the rest recovery at `FightRealtime.gd:836, 853, 896, 1832,
  1833, 2084, 2461`.
- **It appears in NO `GrappleResolve` weight at all** — neither attacker nor
  defender. A gassed man and a fresh man contest a takedown identically, except
  through whatever fatigue has already done to their other stats.

### `fight_iq`
- `FightSimulation.gd:1239` — half of initiative, as an equal to speed.
- `FightSimulation.gd:1252` — `_effective_fight_iq`, computed per use and
  deliberately never written back.
- `FightSimulation.gd:1990` — a defender read; `:1522` — a second **`>= 60.0` cliff**.
- `GrappleResolve.gd:25, 38` — `.10` attacking, `.15` defending.
- **This is the stat with no definition whatsoever.** Every other one has a
  plain-language meaning a person could argue about. Nothing in the tree says
  what fight IQ IS, so nothing can say whether any of its numbers are right.

### `grapple`
- `GrappleResolve.gd:21, 28, 35` — **`.45` attacking, `.55` from the clinch,
  `.40` defending.** The dominant term on both sides.
- `FightRealtime.gd:2065–2066` — `p_shoot = GRAPPLE_ATTEMPT_BASE * grapple / 50.0`
  and the same for the clinch. **Divided by 50, not 100** — so 50 is the neutral
  fighter and a 100-grapple man shoots exactly twice as often as average.

---

## THE THREE FINDINGS

**1. THERE IS NO DEFINITION ANYWHERE FOR ANY OF THE SEVEN.** Not a briefing, not
a spec, not a research file. `research/` contains zero documents named for
`power`, `speed`, `defense`, `fight_iq` or `conditioning`. Balance — which is not
even a stat — has three.

**2. AT LEAST FORTY MAGIC CONSTANTS CONVERT A RATING INTO AN EFFECT, AND NONE
CITES A SOURCE.** `0.5 + power/100`. `defense/100 * 0.35` capped at `0.6`.
`grapple/50`. `6.0 + power*0.12 + technique*0.08`. `speed >= 60.0`. Each was
chosen once, by someone, and has been defended by inertia since. These are
exactly the class of number the operator refused to let us invent for the balance
decay rate — *"a fabricated recovery time is worse than NOT FOUND, because it
will be typed straight into a decay curve and then defended for months as though
it were measured."* Forty of them already are.

**3. THE TAKEDOWN WEIGHTS CONTRADICT THE OPERATOR'S OWN RULING.** The balance
briefing says plainly: *"when balance is broken, strength becomes optional… it
allows a smaller or weaker fighter to completely compromise a stronger opponent
using timing, angles, and leverage."* `GrappleResolve` weights the attacker
**power `.20` against technique `.10`** — a takedown is twice as much strength as
skill, always. R131 §3 proposed fixing this *while broken* (`.20 → .05` and
`.10 → .25`). **It does not touch the base case**, where a shot on a planted man
is still mostly strength. Whether that base ratio is right has never been asked
of anybody.

And a fourth, smaller: **`conditioning` does not appear in the grapple contest at
all**, which is the one place in combat sports where everyone agrees gas tank
decides it.

---

## WHAT THIS IS FOR

The domain half — *what should each of the seven mean, and what should the
conversion be* — is now assignable per stat, with this census as the brief.
`fight_iq` is the one to do first: it is the only one with no plain-language
meaning at all, and it is worth as much as speed in initiative.
