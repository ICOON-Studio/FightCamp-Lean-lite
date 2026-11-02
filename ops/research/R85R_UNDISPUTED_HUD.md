# R85R — UNDISPUTED, THE LIVE HUD (first-hand, 2026-09-09)

Owner: Claude. Method: the game driven directly on this machine (Steam 1451190,
Unity/IL2CPP, 17.4 GB) via a virtual Xbox 360 pad, screen captured and read.
Every claim below is `verified locally` unless marked otherwise. Screenshots
stayed in the session scratchpad and are deliberately NOT committed — the
standing rule is that assets from other games never enter the repo.

The operator named this game as the quality bar. This file records only what
was seen, not what the marketing says.

---

## THE FINDING: cardio is a HEART RATE, not a stamina bar

Undisputed's in-fight HUD gives each man **one bar and one number**:

| Element | What it is |
| --- | --- |
| A single full-width bar above the nameplate | **Health.** No number, no segments. Glanceable only. |
| Angled corner-coloured nameplate | Flag, first name small, surname large, and beneath it either a trait (`Devlish`) or the opponent's class (`Amateur - CPU`). |
| A **running-man icon + a small ECG-trace box + an integer** | **Heart rate in BPM.** |

Observed values across the session: **119 → 122 → 119 → 121 / 123**. It **rises
with exertion and falls at rest** — the opposite direction to a stamina bar,
which is exactly what a heart rate does.

**Why this is the interesting choice.** We have been treating "show health and
stamina at once" as a two-bar layout problem. Undisputed does not solve it; it
*dissolves* it. Health stays a bar because a bar answers "how much is left".
Cardio becomes a **broadcast-native integer** because a heart rate is a number
a viewer already knows how to read, it needs no baseline to compare against,
and it occupies about forty pixels. Two competing bars would fight each other;
a bar and a number do not.

It is also **diegetic**. A real broadcast can show a fighter's heart rate. It
cannot show a stamina bar. That matters for a game whose whole frame is "watch
and coach".

### What this means for FightCamp

`FightStamina` is 1.0..100.0 where high is fresh. A heart rate is the same state
read the other way up: **low is fresh, high is spent.** The mapping is a
presentation concern only and needs no engine change —
`bpm = resting + (max - resting) * fatigue_fraction(stamina)`, with resting and
max off the fighter's conditioning, is a screen-side function.

That is worth having because it answers a question R84 left open: **the engine
now produces stamina and nothing renders it.** This is the cheapest renderable
form, and it does not cost a second bar on a screen that also has to carry six
body regions.

`impression`, not verified: whether Undisputed also shows a stamina bar
elsewhere (corner screen, replay). Only the live HUD was reached.

---

## Also seen in the live HUD

* **A round clock** floats centre-top as a small rounded plate with a clock
  glyph and one decimal (`0.0`, `0.8`, `2.0`) — not the giant broadcast clock a
  boxing telecast uses. In the tutorial it counts up from zero.
* **A coaching objective ribbon** sits bottom-left, above the nameplate, as a
  purple angled banner: `3 / 5  Land 5 Jab - Straight Combinations` with inline
  button glyphs. This is the closest thing in any reference we have to
  **FightCamp's corner instruction surface** — a progress fraction, an
  imperative sentence, and the input that satisfies it, all on one line that
  never covers the fighters.
* **Tips** appear as a small translucent card on the left edge (`Protect
  yourself at all times; keep your guard up!`), styled as a titled panel with a
  coloured left rule. It sits over dead canvas, never over a man.
* **A positional marker** is drawn on the canvas itself — a white ring under
  the fighters rather than a HUD element.
* The **health bar did not visibly move** across roughly sixty thrown punches
  in the tutorial. `impression`: the tutorial is damage-damped; do not read a
  damage rate from this.

## What FightCamp should take, and what it should refuse

1. **TAKE — cardio as a heart rate.** One integer, rising with fatigue. It is
   the cheapest possible render of the state G30/R84 already computes, and it
   is the only form of it a broadcast could plausibly show.
2. **TAKE — one bar, one number, per man.** Health is spatial; cardio is
   numeric. Do not build two bars.
3. **TAKE — the objective ribbon's shape** for the corner's instruction: a
   fraction, an imperative, one line, clear of the figures.
4. **REFUSE — the small floating round clock.** A boxing bout wants the
   broadcast clock and round number to be a fixed, confident element; theirs is
   sized for a fighting game, not a telecast.
5. **REFUSE — reading any damage or stamina RATE from this session.** It was a
   tutorial with a CPU opponent and damped damage. The rates we tune against
   stay the ones our own engine emits, which is the C64 lesson.

## What is still unseen

The between-rounds corner screen, the scorecard presentation, the knockdown
count, and the post-fight result screen. The tutorial does not pause on START
or exit on BACK/B, so reaching a real bout needs menu navigation that was not
completed in this session. Those four screens remain the open half of this
study — and they are the ones R85's rebaseline actually needs, because R84
produces a full result object and a set of scorecards that nothing renders.

## Method note, for whoever repeats this

Undisputed **ignores keyboard and mouse entirely** at the title screen even with
verified foreground focus. It requires a gamepad. ViGEmBus 1.22.0 plus the
Python `vgamepad` package drives it, but the virtual pad **must be held open by
a long-lived process** — a per-command process makes the game show "Controller
Disconnected" and pause between every input. `SendKeys` never works on Unity;
use `keybd_event` with scancodes, or the pad.
---

# SECOND PASS — the live broadcast HUD and the corner (AI vs AI bout)

Driven to a real bout: Quick Fight, **AI-only fight** (`X` on SIDE SELECT — the
game will fight itself, which is how these screens were reached without having
to box), Ali vs Ali, WBC Heavyweight, 12 rounds, Atlantis venue.

## The RULES screen — a ruleset model worth comparing to ours

| Undisputed setting | Value seen | What we have |
| --- | --- | --- |
| Rounds | 8 (default), max 12 | `rounds`, same idea |
| Saved By The Bell | No | **We do not model it at all.** |
| 3 Knockdown Rule | **No — it is a TOGGLE** | We hardcode `THREE_KNOCKDOWN_COUNT = 3`, always on. It should be a ruleset flag. |
| Relative Time | 1.5x | `FightClock.SPEEDS` — same concept |
| Damage Modifier | 1.0 | no equivalent |
| Stamina Modifier | 1.0 | no equivalent |
| **Referee Leniency (Strict–Lenient)** | 5.0 | **We have no referee disposition at all** — only a fixed doctor threshold. A single scalar for how quickly the ref steps in is a cheap, legible knob. |
| Maximum Penalties | 3.0 | no equivalent (we have no fouls) |

Two direct actions for us: **make the three-knockdown rule a ruleset flag rather
than a constant**, and **consider a referee-leniency scalar** feeding the
stoppage decision R84 just built.

## The live HUD, per fighter

1. A long **health bar** above the nameplate.
2. An angled corner-coloured **nameplate**: flag, forename small, surname
   large, and beneath it the opponent class (`CPU - Intermediate`).
3. The **heart rate block** — running man + ECG glyph + integer (118–123 seen).
4. **Contextual labelled meters** in the inner area — `Head`, `Body`, `Block`.
   Crucially the two sides showed DIFFERENT labels at the same moment (left
   `Block`/`Head`, right `Body`/`Block`), so these surface **only when they are
   in play** rather than sitting there permanently.
5. Centre: a white plate with the round clock in large black type and
   **`Round 1 of 12`** beneath it — the round number lives WITH the clock.

## The corner, between rounds — the screen we most needed

A `DAMAGE` card per fighter, corner-coloured, with **six rows**:

| Row | Form |
| --- | --- |
| `Head` | continuous bar |
| `Body` | continuous bar |
| `L. Cuts` | **four discrete pips** |
| `R. Cuts` | four discrete pips |
| `L. Swell` | four discrete pips |
| `R. Swell` | four discrete pips |

A pip lights **yellow** as severity climbs, and the **3D model shows the cut** —
the blue fighter had a visible split above the brow matching a lit `L. Cuts`
pip. HUD and character agree.

Below the cards, two bars per fighter carry **a percentage AND a delta**:
`97% (+1%)`, `100% (+4%)`. The centre shows a countdown labelled **`Recovery`**
(0:11 seen), and `Press B to Skip`.

### THE FINDING, and it challenges our six regions

**Attrition is continuous; trauma is discrete.** Head and body are bars because
they accumulate. Cuts and swelling are four-step pips because a cut is an EVENT
with severity, not a slowly draining pool. We currently model all six regions
as one continuous 0–100 float, so we have no way to express "he has a bad cut
over the left eye" — only "his head is at 62".

**And they spend their six slots completely differently from us.** Ours are
head, torso, two arms, two legs. Theirs are head, body, and **four facial
trauma slots split left/right**. For boxing that is plainly the better carve-up:
R84 already ruled that arms are never targeted, and legs are only a target in
rulesets with kicks. The things a boxing broadcast actually talks about are
cuts and swelling around the eyes, and we cannot represent either.

This does NOT mean rewriting `body_condition` — U3's six regions serve the
gym/medical screens and the injury model. It means the FIGHT may want a second,
smaller trauma record beside it. Recorded as a question for whoever owns the
fight-damage stage, not a decision taken here.

### The corner delta is the other steal

`+4%` next to `100%` makes the corner's minute *visible*. R84 wired
`FightStamina.rest_recovery` and the number it returns is never shown to
anyone. Showing recovery as a delta is the cheapest possible way to make the
corner feel like it did something — and it is the natural companion to the
heart rate, which is the other thing the minute changes.

## Method that made this possible

The game is gamepad-only and **the menu obeys XInput slot 0 alone**. A physical
pad on slot 0 makes a ViGEm virtual pad on slot 1 completely inert — inputs are
delivered and silently ignored. The physical pad had to be unplugged.
`Disable-PnpDevice` on the real controller's USB parent fails with a generic
failure while the device is in use, and disabling only its HID child does not
free the XInput slot.

Corner screens are short and the round clock drifts against wall time, so
timed waits miss them. What worked: **poll a small region where the DAMAGE card
appears and trigger a full-resolution capture on a brightness drop** — the card
is a dark translucent panel over a bright ring, average luminance about 11–16
versus 50–140 mid-round.
### The two corner bars, read later in the same bout

By the round-7 corner the numbers had separated: red `65% (+2%)` over
`100% (+6%)`; blue `86% (+1%)` over `100% (+6%)`. So the **upper bar is health
and only partially recovers** (+1 to +2 a minute), while the **lower bar
returns to 100%** every corner (+6%).

If the lower bar is short-term stamina, that is a deliberate contrast with our
`FightStamina.MAX_REST_FRACTION = 0.9`, which forbids a full tank. Cursor's U23
survey says Undisputed carries **short-term and long-term** stamina, so the
visible bar is plausibly the short-term one and the long-term ceiling is what
actually erodes. `impression` - the HUD does not label these two bars, and the
distinction was not confirmed in-game.

The useful, certain part is the **shape**: value plus per-minute delta, for two
different resources with visibly different recovery rates. Health crawls back;
wind comes back. That reads correctly as boxing without a word of explanation.
### CORRECTION, from a later corner in the same bout — the ceiling erodes

The paragraph above said the lower bar "returns to 100% every corner". **That
was wrong**, and a deeper corner shows why it matters. Successive corners read:

| Corner | Red | Blue |
| --- | --- | --- |
| ~round 3 | `97% (+1%)` / `100% (+4%)` | `96% (+1%)` / `100% (+5%)` |
| ~round 7 | `65% (+2%)` / `100% (+6%)` | `86% (+1%)` / `100% (+6%)` |
| ~round 9 | `80% (+1%)` / `96% (+3%)` | `63% (+2%)` / `96% (+3%)` |

The lower bar recovers to **100%, then 100%, then only 96%** — and its
per-minute delta falls from +6% to +3%. **Its ceiling erodes as the fight goes
on.** That is exactly the recoverable / unrecoverable split U23 documents for
Fight Night, and the three-layer tank Harrower describes for EA UFC 3: a
short-term bar that refills, bounded by a long-term reserve that does not.

**This is the strongest single argument for our own `MAX_REST_FRACTION`.** G30T
made Claude cap rest recovery at 0.9 so a long rest could not hand back a full
tank; the objection at the time was that the cap is arbitrary. It is not - a
shipped sim spends real design effort on precisely this, and does it better:
**the cap should FALL as the fight wears on, not sit at a constant 0.9.** That
is a concrete, cheap improvement to `FightStamina.rest_recovery`, and it wants
the long-term reserve `G30` does not currently carry.

Also note the red fighter went from 65% to 80% health between those corners,
so health is NOT monotonic across the bout in their model either - or the two
bars are not the ones assumed. Labelled `impression`; the HUD never names them.
---

# THE SCORECARD — reached, and it is the screen R85 needs

The AI bout went the full twelve and produced a decision. This is the one
screen R84 has all the numbers for and renders none of.

## Layout

* Title bar `SCORECARD`, with **`REFEREE: KENNY BAYLESS`** on the left and the
  venue (`ATLANTIS`) on the right.
* A header row: `ROUND`, then columns **1..12**, then `TOTAL`.
* **Three judges, each NAMED and numbered** in a large numeral — `1 Behroz
  Ali`, `2 Jonathan Ricks`, `3 Boris Leeway`.
* Each judge occupies **two rows**, one per corner, tinted red and blue, each
  carrying the fighter's name and class (`CPU - Intermediate`).
* Every cell is that judge's score for that round: a grid of 10s and 9s.
* **The round's winner is marked with a coloured rule** on the winning cell —
  a red bar above the red row's cell, a blue bar below the blue row's. You can
  read the shape of the fight by scanning the stripes without reading a digit.
* Totals are boxed at the right; the winner's total is **starred and in his
  corner colour** — `★ 115 ★`.
* A banner beneath: flag, `MUHAMMAD ALI`, `★ UNANIMOUS DECISION ★`.
* A `COMPUBOX` lockup bottom-right ("every punch counts").
* Footer: `A Confirm`, `B Back`. It is terminal — it waits for input.

## The cards actually turned in

| Judge | Red | Blue |
| --- | --- | --- |
| Behroz Ali | 112 | **115** |
| Jonathan Ricks | 113 | **114** |
| Boris Leeway | 112 | **115** |

## WHY THIS SCREEN IS THE ARGUMENT FOR FINDING 2

Judge 2 scored it 113-114 while judges 1 and 3 had 112-115. **The panel agreed
on the winner and disagreed about individual rounds**, which is what a real
panel does and what makes a scorecard worth showing at all.

Our engine cannot produce that. R84 measured it: every decision across two
sweeps came back unanimous, including between two identical fighters, because
judge bias may only perturb SECONDARY criteria (J1 3.2) and the real-time
engine emits no grappling — so `control_score`, takedowns, positions and
submissions are all zero, damage is the only non-zero weight, and every judge
computes the identical number.

**Rendered on this screen, that defect would be nakedly visible**: three judges,
three identical rows, three identical totals. The scorecard is where "the panel
is decorative" stops being a note in a digest and becomes something the player
sees. That raises finding 2 from a curiosity to a blocker for R85's rebaseline.

## What FightCamp should take

1. **TAKE — the whole grid.** `JudgePanel.score_round` already produces exactly
   this shape: per judge, per round, a 10-9 card. We store it in
   `state["scorecards"]` as `{round, cards, consensus}` and show none of it.
   This is a rendering job, not a modelling one.
2. **TAKE — the per-round winner rule.** A coloured stripe on the winning cell
   makes twelve rounds legible at a glance. Cheap, and it is the only thing
   that makes a 24-cell grid readable.
3. **TAKE — naming the judges and the referee.** Ours are `judge_1..judge_N`
   by deliberate choice (`judge_panel_test` asserts no real official is named).
   Named FICTIONAL judges cost nothing, break no rule, and are what turns a
   split decision into a story the player argues with.
4. **REFUSE — the CompuBox branding**, obviously, and any real official's name.
   Kenny Bayless is a real referee; our own rule is that we author names rather
   than borrow them.
5. **BLOCKED — do not build this screen until judges can disagree.** Rendering
   three identical rows would advertise the defect. Finding 2 comes first.
