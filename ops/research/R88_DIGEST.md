# R88 — THE LAST INERT MODULE, AND THE BEAT A CUT NEVER LEFT

Owner: Claude. Base `57d7a5b` (`SUITE total=209 fails=0`).
Touched: `FightRealtime.gd`, `fight_realtime_test.gd`. `ImpactModel.gd` was
owned for this task and needed nothing — said here so the next reader does not
go looking for the change.

---

## What shipped

**1. `CornerAdvice` is reached.** It was the seventh and last piece of correct,
tested, unreachable code in this area: 147 lines, a 687-check blind contract
test (G33T) passing, and no caller anywhere. `_close_round` now builds a corner
record for both men on the same guard that already gives them their wind
(`Stamina.rest_recovery`) and their body (`Impact.corner_recovery`) back.
`Cardio` is reached from the core at the same seam — it was only ever reached
through `FightHudRead` before — because `advise` wants a heart rate and a zone.

**2. A cut leaves a beat.** Every action record now carries `trauma_site`,
`trauma_kind` and `trauma_pips`. R87 left a mark as `trauma_opened` (a counter
that only goes up) plus the final face, so a broadcast could say a man was cut
and never say where or when, and a replay could not reconstruct either.
`FightTrauma.words()` gets its first caller in the game.

**3. No punch/kick tag, and it is a ruling.** The forecast block names it as the
next slice for taekwondo zones. **No TKD research exists and no TKD consumer
exists**, so shipping the tag now would create an eighth piece of correct,
tested, unreachable code — the exact condition R87 and this stage exist to
close. It ships in the same stage as its consumer, after the research lands.

## The two rulings the task asked for

### Where the advice lives: its own round-indexed array on `state`

`state["corner"]`, one entry per minute holding both stools, beside `stoppage`.

* **Not on the fighter.** A fighter dictionary is what the man **is right now**.
  Advice is an utterance with a timestamp, so keeping it there would hold only
  the latest and throw the other ten corners of a twelve-rounder away.
* **Not inside the scorecard.** A `scorecards` entry is the **panel's** record:
  `Judges.decision` walks it and `_stop` copies it whole into the result. The
  corner would then ride into every judging consumer that never asked for it,
  and a corner is not a judge's fact.
* A live HUD that wants the current line reads the last entry. That is one
  lookup, against duplicating the same words into two owners.

### Stored, not projected — and why that is not the opposite of R87's Cardio ruling

R87 ruled that a heart rate is **not** stored: it is a pure projection of
stamina, conditioning and age, and keeping a derived per-tick float would be
carrying state C62 ruled out. This record **is** stored. The two are the same
rule, not two rules:

> **Store what cannot be recovered; project what can.**

A heart rate is a projection of state that **persists** — stamina, conditioning
and age are all still there at any later tick, so the number can be rebuilt on
demand and storing it buys nothing. A corner read is a projection of state that
is **destroyed seconds later**: the same guarded block raises the tank and all
six regions, so by the next tick the numbers the advice was read from are gone
and nothing downstream can get them back. That is why the record also carries
`head`, `body`, `stamina`, `heart_rate` and `zone` — what he looked like when it
was said, not a cache of what he looks like now.

One derived string is kept: `mark`, from `FightTrauma.words(pips)`. A corner
record is an **utterance** — it already carries `line`, which `advise` composed —
so naming the mark in the same breath is the same class of thing. The **log**
keeps facts and lets each consumer choose its own words, which is why
`trauma_pips` is on the log line and the broadcast word is not.

### One smaller ruling: the log shape stays uniform

The three trauma keys are on **every** action record, empty and zero on the
blows that opened nothing. A log whose shape depended on what happened in it is
one every consumer has to test before it can read.

## The trap, and it was real

`advise` needs numbers `_close_round` is about to destroy. The corner is built
**before** the recovery loop, and the test drives the fight tick by tick to
prove it: on a resting tick nothing else touches a man before the bell closes
his round, so the figures the corner wrote down must equal the pre-tick ones to
the last decimal. Measured: `reads=220 treated=220 read_after_treatment=0
worst_gap=17.94`.

The half that a same-numbers check would miss is asserted too — `urgency_of`
re-run on the man as he stood **up** off the stool disagrees with what his
corner actually said in **4 of 220** reads. Low, and reported rather than
pinned; zero would have meant the order could never have mattered and the test
was decoration.

`advise` draws nothing, so **no seventh stream was added**. R87 added
`_rng_trauma` only because `aggravate` takes a roll.

## Findings — report, do not silently fix

**F1. `Cardio` and `CornerAdvice` do not speak the same zone language.**
`Cardio.zone` answers in broadcast capitals — `RECOVERY` / `AEROBIC` /
`THRESHOLD` / `RED LINE` — and `CornerAdvice.advise` tests its `cardio_zone`
argument against the lower-case, unspaced `redline`. Both modules are correct
alone and both have passing contract tests. Handed one to the other unchanged,
the corner's `heart` reason could never fire and half of its `breathe` trigger
would be dead on arrival — the condition this stage exists to end, arriving
through a vocabulary rather than through a missing caller. **Neither module is
mine this cycle**, so the translation is one line at the call site
(`_corner_zone_word`) and the test fails the moment somebody removes it. The
right permanent fix is one vocabulary, and it belongs to whoever owns the two
files next.

**F2. `breathe` cannot fire in a real fight, and it is the FIRST branch in
CornerAdvice's own precedence list.** Measured across five matchups, twelve
seeds each, twelve rounds:

| matchup | lowest tank at a bell | lowest head | lowest body | zones seen |
| --- | --- | --- | --- | --- |
| boxer–wrestler | 54.1 | 27.6 | 90.2 | aerobic, threshold |
| glass–iron | 28.0 | 32.2 | 83.7 | recovery, aerobic, threshold |
| bomber–iron | 63.7 | 0.0 | 74.4 | recovery, aerobic |
| glass–glass | 29.3 | 46.4 | 86.4 | aerobic, threshold |
| bomber–glass | 39.3 | 4.0 | 58.9 | aerobic, threshold |

`breathe` needs `redline` **or** tank ≤ 25. The lowest tank ever seen at a bell
is **28.0**, and **`redline` never occurs at all** — peak heart rate at a bell is
157 bpm against a 172.8 threshold for a 28-year-old. So even with F1 translated,
the branch is unreachable. `body` is unreachable for the same kind of reason:
it needs body ≤ 40 and the lowest torso ever seen at a bell is 58.9.

Two of five focuses reachable in an ordinary bout (`output`, `close_it`), four
of five across matchups (`defence` needs a man who is actually being hurt).
**This is a fatigue-and-wear balance finding, not a corner bug**, and it is not
mine to tune inside this stage — the numbers are here so the tuning task starts
from measurements instead of from a guess.

**F3. `close_it` needed the round the man is going OUT for.** `advise` asks
`_is_last_round` before it tells a man behind on the cards to close it, and a
corner only ever speaks *between* rounds. Passing the round that just ended
would make `_is_last_round` false at every corner in the fight and `close_it` a
branch nothing could reach. `number + 1` is passed, and `close_it` fires 5 times
in the sweep.

`losing_on_cards` is read off the **consensus** card — the median judge's, the
one card per round every other consumer reads. A corner does not have three
scorecards in front of it.

## Gates

1. **Reached, asserted by occurrence.** 24 fights, two matchups, 288 stools:
   `urgencies={steady 200, warning 29, critical 59}`,
   `focuses={output 268, defence 15, close_it 5}`, urgency varies **within** a
   fight in 18 of 24. Two matchups on purpose — one ordinary bout gives the
   corner nothing to say but "keep working", so a single-matchup sweep would
   measure the fixture rather than the module.
2. **A cut leaves a beat.** 18,759 events, **91 beats**, every one off a
   head shot at or past the force floor with a contact word that actually
   arrived, a site and kind `FightTrauma` has, pips 1..4 that `words()` can
   name; the blows that opened nothing carry the keys empty; and the beats in
   the log equal R87's `trauma_opened` per fight. Example line:
   *NICK (cut) over the right brow at 154.60s of round 1.*
3. **R82's replay gate unmoved**, and `corner` is now inside it — the corner
   record is the only thing in the fight built out of state that is destroyed
   moments later, so a drift in *when* it was read would show up there and
   nowhere else, with the log still replaying perfectly.
4. **R85's nine pinned cards did not move.** `judge_panel_test` 0 failures. No
   draw was added to any of the six streams and no fight logic changed.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
```

`FIGHT_REALTIME_TEST PASS (223 checks)`.
