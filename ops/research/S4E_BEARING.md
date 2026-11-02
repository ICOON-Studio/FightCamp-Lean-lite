# S4e (4) — BEARING: A FIGHTER FACES HIS OPPONENT, AND GETTING THERE TAKES TIME

Claude, 2026-09-15. Operator ruling the same day, asked with the three options in `S4E_BEARING_DESIGN.md`:
**OPTION B** — a carried facing with a turn rate, behind its own switch, the old behaviour left at the identity.

## WHAT WAS THERE BEFORE: NOTHING

`rg -n "facing|bearing|yaw"` over `FightRealtime.gd`, `FightIntent.gd`, `FightFootwork.gd` and `RingSpace.gd` returned
**one hit, and it was the phrase "load-bearing" in a comment**. A fighter carried two positions, two velocities and (since
S4e (3)) a stance, and no orientation of any kind. The room had to invent one — the same hole the operator saw from the
other end as *"head, torso and feet facing differently"*.

## WHY "FACE HIM ALWAYS" IS THE INTENT AND NOT THE IMPLEMENTATION

Recomputing facing from the positions every tick would make it always perfect — and a turn would then cost nothing,
which quietly cancels S4e (1). Teaching `close` to cut a man off buys nothing if the man being cut off is already square
to you the instant he is cut off. **The turn has to take time.** That is the stage.

## WHAT CHANGED

- **`Godot/scripts/FightBearing.gd`** — new, pure (zero preloads, no RNG, no `get_node`). `turn_rate` off the man's
  `speed`; `turn` rotates a facing toward a target capped by rate × dt and **never overshoots**; `off_line_degrees`;
  `throw_weight`.
- **A UNIT VECTOR, NOT AN ANGLE.** An angle needs a seam that every consumer must agree on, and a facing crossing it
  reads as a 359-degree turn. `face_x` / `face_y` quantise through `Quantise` exactly as `vel_x` / `vel_y` already do.
- **`begin`** settles both men facing each other — a fight does not open with anyone looking away — and settles
  `turn_rate_deg_s` once, beside `top_speed`.
- **`_run_movement`** turns the facing each tick toward the other man's *new* position.
- **`_throw_context`** multiplies the volume weight by `throw_weight(off_line)`. **A weight, not a draw** — the shape
  S4e (3) proved for stance. The seven-draw contract is untouched and no stream position moves.
- **The action event** gains `actor_off_line_deg`, `target_off_line_deg` and `facing_delta_deg`, so the room and the
  pair tool never have to invent a facing again.

`TURN_BASE_DEG_S` 240, `TURN_SPEED_SPAN` 160, `MIN_TURN_DEG_S` 90, `FREE_ARC_DEG` 35, `OFF_LINE_FLOOR` 0.15 are all
**AUTHORED** and labelled as such in the source.

## THE IDENTITY, PROVEN RATHER THAN ASSERTED

`tools/probe_bearing_off.gd` checksums the decisions only — tick, actor, technique, region, contact — never the new
facing fields, which exist here and not on HEAD and would differ by construction. Run twice, once on this branch and
once with `git show HEAD:Godot/scripts/FightRealtime.gd` restored over the file:

```
THIS BRANCH, bearing OFF   bouts=6 actions=3054 checksum=3043132877
HEAD (before S4e (4))      bouts=6 actions=3054 checksum=3043132877
```

**A switched-off run costs the engine exactly nothing.**

## THE GATE — `Godot/tests/fight_bearing_test.gd`, 3 checks, PASS

| rule | tier | stands on |
|---|---|---|
| R19 turn_converges_and_is_capped | **GATED** | GEOMETRY over 3,456 cases on a 24×24 grid of angles at three rates and two step sizes: unit vector out, never turns away, never moves further than rate × dt, and lands **exactly** on the line when the error is inside the budget. 336 reached the line, **0 violations**. Independent of the rate's value, so it survives U109 replacing it. |
| R20 opens_on_the_line | **GATED** | SITUATION. Worst opening error **0.0000 deg**. |
| R21 the_switch_is_a_switch | **GATED** | A/B. Same six seeds, ON `1763842788` vs OFF `3043132877`. Identical streams would have meant the facing was carried and read by nobody — the "correct, tested, unreachable code" this area has shipped six times. |

**The turn rate has NO STUDY** — no published figure gives a fighter's degrees per second. It is measurable with the
instrument already built: the shoulder-line normal in the 17 MediaPipe tracks **is** the facing, so a yaw rate (deg/s,
p50/p90) falls out of the same pass `TASK_U109` already makes. That extension belongs in U109 **before it is launched**.

## WHAT MOVED, AND THE ONE FINDING WORTH MORE THAN THE STAGE

- **One judge card, out of thirteen.** `boxing_20` round 7, `10-7/kd1-0` → `10-8/kd0-0`: a knockdown that used to land
  there no longer does, because the man the share picks at that tick changed. Re-pinned from the test's own printed
  actual. `fight_realtime_test` (376 checks), `fight_stance_test`, `fight_movement_quality_test`, `fight_hud_read_test`,
  `grapple_adapter_test`, `fight_beat_adapter_test`, `realtime_round_stats_test`, `fight_strike_band_test` all green
  untouched.

- **S4e (4) EXPOSED A CONFOUND IN R16, AND THE MEASUREMENT WAS FIXED RATHER THAN THE BOUND.** R16 asks whether cutting
  a man off closes the gap faster, by conditioning on a state — one retreating, one closing — and comparing two arms.
  That is only fair while everything except `cut_off` is held still, because **the two arms are different fights and the
  chase moments they contain are different populations**. Bearing changes who throws → stamina → intents → when a chase
  happens at all, in both arms. Measured that way the cage read **−0.404 → −0.367 over 20 seeds, stable** — cutting off
  looked *worse*. The A/B now pins `bearing: false` and isolates what it claims to isolate; **R16b reports the shipped
  configuration ungated so the number that failed is on the record**: shipped ring −0.508 m/s, cage −0.367 m/s. This is
  R5's lesson again — a reference weighted by what the presentation does moves when the presentation does.

## Open

1. The turn rate is AUTHORED and needs U109's shoulder-line yaw rate; add it to that task before launching.
2. **Option C is not built**: the stance blade (a man is bladed, not squared) and the off-line penalty on defence, which
   is where cutting a man off finally *pays*. Its own slice, never folded into B.
3. The room does not read the three new event fields yet — that binding is a PC job (`--write-movie` aborts headless in
   a container) and it is the whole reason B was built.
4. A pair record still has no `authored_bearing_deg`; until it does, `_present_pair` gates on distance only.
5. R16's cage arm deserves a paired measurement rather than a between-fights one — small, and its own task.
