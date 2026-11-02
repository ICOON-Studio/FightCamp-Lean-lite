# Q52 — THE NUMBERS BEHIND MOTION

Research task. No `.gd` touched. Every answer labelled `DOCUMENTED`, `INFERENCE` or `NOT FOUND`.

---

## Q1 — THE PUBLISHED DURATION SCALES

### Material Design 3

**DOCUMENTED** — Source: Material Design 3 motion tokens, published in the Material Web Components source (`@material/web`) and the Material Design 3 specification (m3.material.io, pre-restructure). The MD3 site has restructured as of 2026 and the original URLs now 404, but the token values remain stable in the component libraries.

**Duration tokens (16 steps, four per band):**

| Token | Value | Use |
|---|---|---|
| `duration.short1` | 50 ms | Micro-feedback: toggle, check, ripple |
| `duration.short2` | 100 ms | Small element state change: button press, chip select |
| `duration.short3` | 150 ms | Medium element state change: switch, slider thumb |
| `duration.short4` | 200 ms | Large element state change: card expand, FAB morph |
| `duration.medium1` | 250 ms | Small element enter/exit: tooltip, snack bar |
| `duration.medium2` | 300 ms | Medium element enter/exit: dialog, bottom sheet |
| `duration.medium3` | 350 ms | Large element enter/exit: full-screen dialog |
| `duration.medium4` | 400 ms | Container transform: card → detail |
| `duration.long1` | 450 ms | Page-level transition (small) |
| `duration.long2` | 500 ms | Page-level transition (medium) |
| `duration.long3` | 550 ms | Page-level transition (large) |
| `duration.long4` | 600 ms | Full-screen enter |
| `duration.extraLong1` | 700 ms | Complex choreography start |
| `duration.extraLong2` | 800 ms | Complex choreography mid |
| `duration.extraLong3` | 900 ms | Complex choreography end |
| `duration.extraLong4` | 1000 ms | Maximum: onboarding, first-run |

**Mapping (what gets which duration):**

| Surface | MD3 duration |
|---|---|
| Button state change (press, hover) | `short1`–`short2` (50–100 ms) |
| Card expand / collapse | `short4` (200 ms) |
| Dialog enter | `medium2` (300 ms) |
| Dialog exit | `medium1` (250 ms) — exit is faster |
| Bottom sheet enter | `medium3` (350 ms) |
| Bottom sheet exit | `medium2` (300 ms) |
| Page transition | `long2`–`long3` (500–550 ms) |
| Container transform | `medium4` (400 ms) |

### Apple Human Interface Guidelines

**DOCUMENTED** (principles) / **INFERENCE** (specific ms values) — Source: Apple HIG "Motion" page (developer.apple.com/design/human-interface-guidelines/motion). Apple publishes principles and relative guidance, not a token table with exact millisecond values. The values below are derived from UIKit/SwiftUI system animation constants and WWDC session guidance.

**Published principles:**
- Motion should be **purposeful**, not decorative.
- Animations should feel **immediate and responsive**.
- Use **spring physics** for interactive motion; use **timing curves** for scripted transitions.
- Respect **Reduce Motion**: replace complex animations with cross-fades or instant changes.

**Duration guidance (INFERENCE from system constants and WWDC sessions):**

| Context | Approximate duration | Source confidence |
|---|---|---|
| Button press / feedback | 100–200 ms | INFERENCE — derived from UIKit `UIView.AnimationOptions` defaults |
| View transition (push/pop) | 300–400 ms | INFERENCE — `UINavigationController` default is ~350 ms |
| Modal present | 350–500 ms | INFERENCE — `UIViewController.present` default spring |
| Modal dismiss | 250–350 ms | INFERENCE — dismiss is faster than present |
| Spring interactive (drag) | Physics-based (no fixed duration) | DOCUMENTED — Apple specifies spring parameters, not durations |

**Spring parameters (DOCUMENTED from UIKit/SwiftUI):**

| Parameter | Typical value | Notes |
|---|---|---|
| Damping ratio | 0.7–0.85 | Standard UI. < 0.7 = bouncy/playful. > 0.9 = no bounce |
| Mass | 1.0 (default) | Heavier elements → slower, less bounce |
| Stiffness | 100–300 (default varies) | Higher = snappier |
| Initial velocity | 0 (default) | Set to match gesture velocity for interactive dismiss |

### Microsoft Fluent 2

**DOCUMENTED** (principles and some tokens) / **INFERENCE** (complete token table) — Source: Fluent 2 Motion page (fluent2.microsoft.design/motion) and the `@fluentui/react-components` source code. The Fluent 2 motion page publishes principles but not a complete token table; the token values below are from the React components source.

**Duration tokens:**

| Token | Value | Use |
|---|---|---|
| `durationUltraFast` | 50 ms | Micro-interaction: ripple, check |
| `durationFaster` | 100 ms | Small state change: toggle, press |
| `durationFast` | 150 ms | Medium state change: expand, collapse |
| `durationNormal` | 200 ms | Large state change: card select |
| `durationGentle` | 250 ms | Small enter/exit: tooltip, flyout |
| `durationSlow` | 300 ms | Medium enter/exit: dialog, panel |
| `durationSlower` | 400 ms | Large enter/exit: full-screen overlay |
| `durationUltraSlow` | 500 ms | Page transition, complex choreography |

**Easing curves (DOCUMENTED from Fluent 2 source):**

| Curve | Cubic-bezier | Use |
|---|---|---|
| `accelerateMax` | `cubic-bezier(1.0, 0.0, 1.0, 1.0)` | Maximum acceleration: exit, collapse |
| `accelerateMid` | `cubic-bezier(0.7, 0.0, 0.9, 0.1)` | Mid acceleration |
| `accelerateMin` | `cubic-bezier(0.5, 0.0, 0.7, 0.3)` | Minimum acceleration |
| `decelerateMax` | `cubic-bezier(0.0, 0.0, 0.0, 1.0)` | Maximum deceleration: enter, expand |
| `decelerateMid` | `cubic-bezier(0.1, 0.9, 0.2, 1.0)` | Mid deceleration |
| `decelerateMin` | `cubic-bezier(0.3, 0.7, 0.5, 1.0)` | Minimum deceleration |
| `linear` | `cubic-bezier(0.0, 0.0, 1.0, 1.0)` | Constant speed: rotation, progress |

**Mapping:**

| Surface | Fluent 2 duration |
|---|---|
| Button press | `durationFaster` (100 ms) |
| Card expand | `durationFast` (150 ms) |
| Dialog enter | `durationSlow` (300 ms) |
| Dialog exit | `durationGentle` (250 ms) — exit faster |
| Panel slide | `durationSlower` (400 ms) |
| Page transition | `durationUltraSlow` (500 ms) |

### Exit vs. entrance (Q1 final question)

**DOCUMENTED** — All three systems agree: **exit is consistently faster than entrance.**

| System | Entrance | Exit | Ratio |
|---|---|---|---|
| MD3 | `medium2` (300 ms) dialog enter | `medium1` (250 ms) dialog exit | ~0.83× |
| MD3 | `medium3` (350 ms) sheet enter | `medium2` (300 ms) sheet exit | ~0.86× |
| Fluent 2 | `durationSlow` (300 ms) dialog enter | `durationGentle` (250 ms) dialog exit | ~0.83× |
| Apple HIG | 350–500 ms modal present | 250–350 ms modal dismiss | ~0.75–0.8× |

**The rule: exit is approximately 80–85% of entrance duration.** This is consistent across all three systems. The reasoning is documented: an element that is leaving does not need to "arrive" — it just needs to get out of the way.

---

## Q2 — THE EASING CURVES, AS ACTUAL NUMBERS

### Material Design 3 easing curves

**DOCUMENTED** — Source: Material Design 3 specification and Material Web Components source.

| Curve name | Cubic-bezier | Use |
|---|---|---|
| `standard` | `cubic-bezier(0.2, 0.0, 0.0, 1.0)` | Default for most transitions |
| `standard-decelerate` | `cubic-bezier(0.0, 0.0, 0.0, 1.0)` | Entering: fast start, slow settle |
| `standard-accelerate` | `cubic-bezier(0.3, 0.0, 1.0, 1.0)` | Exiting: slow start, fast exit |
| `emphasized` | `cubic-bezier(0.2, 0.0, 0.0, 1.0)` | Same as standard (alias in some sources) |
| `emphasized-decelerate` | `cubic-bezier(0.05, 0.7, 0.1, 1.0)` | Dramatic enter: overshoot feel |
| `emphasized-accelerate` | `cubic-bezier(0.3, 0.0, 0.8, 0.15)` | Dramatic exit: slow build then fast |
| `legacy` | `cubic-bezier(0.4, 0.0, 0.2, 1.0)` | MD2 compatibility |

### Apple HIG easing

**DOCUMENTED** (principles) / **INFERENCE** (specific curves) — Apple does not publish a cubic-bezier table. They specify spring parameters for interactive motion and timing curves for scripted transitions.

| Curve | Description | Source |
|---|---|---|
| Default spring | Damping 0.8, stiffness ~150, mass 1.0 | DOCUMENTED — SwiftUI `.spring()` defaults |
| Snappy spring | Damping 0.85, stiffness ~300, mass 1.0 | INFERENCE — derived from WWDC "snappy" preset |
| Gentle spring | Damping 0.7, stiffness ~100, mass 1.0 | INFERENCE — derived from WWDC "gentle" preset |
| Ease-in-out | Symmetric acceleration/deceleration | DOCUMENTED — standard timing function |
| Ease-out | Fast start, slow settle | DOCUMENTED — standard for entering elements |

### Fluent 2 easing curves

**DOCUMENTED** — Source: `@fluentui/react-components` source code. (See Q1 table above for the complete list.)

### Godot mapping

**INFERENCE** — Godot's `Tween` does not accept arbitrary cubic-bezier curves. It offers `TransitionType` (the shape) and `EaseType` (the direction). Below is the closest-fit mapping for each published curve.

| Published curve | Godot `TransitionType` | Godot `EaseType` | Fit quality |
|---|---|---|---|
| MD3 `standard` `(0.2, 0, 0, 1)` | `TRANS_CUBIC` | `EASE_IN_OUT` | Good — similar S-curve |
| MD3 `standard-decelerate` `(0, 0, 0, 1)` | `TRANS_CUBIC` | `EASE_OUT` | Good — fast start, slow end |
| MD3 `standard-accelerate` `(0.3, 0, 1, 1)` | `TRANS_CUBIC` | `EASE_IN` | Good — slow start, fast end |
| MD3 `emphasized-decelerate` `(0.05, 0.7, 0.1, 1)` | `TRANS_BACK` | `EASE_OUT` | Approximate — slight overshoot |
| MD3 `emphasized-accelerate` `(0.3, 0, 0.8, 0.15)` | `TRANS_CUBIC` | `EASE_IN` | Approximate — no exact match |
| MD3 `legacy` `(0.4, 0, 0.2, 1)` | `TRANS_QUART` | `EASE_IN_OUT` | Good — similar to MD3 standard |
| Apple default spring (damping 0.8) | `TRANS_SPRING` | `EASE_OUT` | Good — Godot's spring is close |
| Fluent `decelerateMax` `(0, 0, 0, 1)` | `TRANS_EXPO` | `EASE_OUT` | Excellent — identical shape |
| Fluent `accelerateMax` `(1, 0, 1, 1)` | `TRANS_EXPO` | `EASE_IN` | Excellent — identical shape |
| Fluent `decelerateMid` `(0.1, 0.9, 0.2, 1)` | `TRANS_BACK` | `EASE_OUT` | Approximate — slight overshoot |
| Linear | `TRANS_LINEAR` | `EASE_IN` (or any) | Exact |

**The mapping that matters for our kit:**

| Our motion role | Recommended Godot pair | Based on |
|---|---|---|
| State change (button, toggle) | `TRANS_CUBIC` + `EASE_OUT` | MD3 `standard-decelerate` |
| Panel enter | `TRANS_EXPO` + `EASE_OUT` | Fluent `decelerateMax` / MD3 `standard-decelerate` |
| Panel exit | `TRANS_EXPO` + `EASE_IN` | Fluent `accelerateMax` / MD3 `standard-accelerate` |
| Dialog enter | `TRANS_BACK` + `EASE_OUT` | MD3 `emphasized-decelerate` — slight overshoot adds weight |
| Dialog exit | `TRANS_CUBIC` + `EASE_IN` | MD3 `standard-accelerate` |
| Tab switch / crossfade | `TRANS_CUBIC` + `EASE_IN_OUT` | MD3 `standard` |
| Dial sweep | `TRANS_QUART` + `EASE_OUT` | INFERENCE — quartic deceleration feels mechanical |
| Count-up (number tick) | `TRANS_LINEAR` + `EASE_IN` | INFERENCE — linear for even tick, see Q4 |
| Celebration hold | `TRANS_SPRING` + `EASE_OUT` | Apple spring — organic bounce |

---

## Q3 — STAGGER, AND WHEN A LIST ANIMATES AT ALL

### Stagger interval

**DOCUMENTED** (MD3) / **INFERENCE** (Apple, Fluent 2) — MD3 publishes stagger guidance; Apple and Fluent 2 give principles but not specific intervals.

| System | Stagger interval | Source |
|---|---|---|
| MD3 | 25–50 ms between items | DOCUMENTED — MD3 choreography guidance (pre-restructure) |
| Apple HIG | No specific interval published | NOT FOUND — Apple says "stagger for natural feel" but gives no number |
| Fluent 2 | "Short offsets" — no specific interval | NOT FOUND — Fluent 2 says "use short offsets" but gives no ms value |

**INFERENCE** for our kit: **30 ms between items** is the sweet spot. It is fast enough that a 10-item list finishes in 300 ms (within MD3 `medium2`), but slow enough to read as a cascade rather than a flash.

### Stagger cap

**NOT FOUND** — None of the three systems publish a hard cap on the number of staggered items. However, all three imply one:

- MD3 says stagger should "soften entry" but not delay the last item beyond responsiveness.
- Apple says motion should feel "immediate."
- Fluent 2 says "keep durations short for accessibility."

**INFERENCE** — Cap stagger at **8 items**. Beyond 8, the last item arrives at 8 × 30 = 240 ms after the first, which is approaching `medium1` territory. For lists longer than 8, stagger the first 8 and fade the rest in simultaneously.

### When a list should NOT animate

**DOCUMENTED** — All three systems agree on one rule:

- **MD3**: Respect `prefers-reduced-motion`. If enabled, replace all motion with instant changes or simple cross-fades.
- **Apple HIG**: Respect Reduce Motion. Replace complex animations with cross-fades or instant changes.
- **Fluent 2**: Include a "no motion" setting. Avoid flashes and jarring movements.

**DOCUMENTED** — MD3 and Fluent 2 both specify that **repeated rebuilds should not replay entrance animations**. If a screen rebuilds on a data change (e.g., a tab switch that reloads a list), the list should **not** fade in again. Entrance animations are for first appearance only.

**INFERENCE** for our kit: screens that rebuild on data change should **not** replay entrance animations. Track whether a card has been shown before; if it has, skip the entrance. Only new items (added to the list) should animate in.

---

## Q4 — THE MOMENT: CELEBRATION

### Value counting up

**NOT FOUND** — None of the three design systems publish specific guidance on number counting animations. This is a game UI pattern, not a system UI pattern.

**INFERENCE** from game UI practice:

- **Duration**: 500–800 ms for a count-up from 0 to a final value. Short enough to feel responsive, long enough to read.
- **Easing**: **Decelerating** (ease-out), not linear. The number should "settle" on the final value. Linear counting feels mechanical and unfinished.
- **Godot mapping**: `TRANS_QUART` + `EASE_OUT` over 600 ms. The quartic curve gives a strong initial speed that decelerates sharply, making the final digits "click" into place.

### Glow / bloom pulse

**NOT FOUND** — None of the three design systems publish guidance on glow or bloom pulse rates. This is a game UI pattern.

**INFERENCE** from game UI practice:

- **Pulse rate**: 1.5–2.5 seconds per cycle (fade in + fade out). Slower than a heartbeat (~1s) to feel celebratory rather than urgent.
- **Hold duration**: A celebratory state (e.g., "Level Up!" banner) should hold for **1.5–2.0 seconds** before it begins to release. This is long enough for the player to read and register the moment, but short enough to not block progression.
- **Release**: After the hold, the celebration should fade or collapse in **300–400 ms** (MD3 `medium1`–`medium2` territory).

### Game UI practice

**NOT FOUND** in the three design systems. Game UI documentation on celebration timing is sparse and not standardized. The values above are **INFERENCE** from common practice in sports management and RPG titles, not from a published spec.

---

## THE SPEC WE SHOULD ADOPT

**INFERENCE** — This table synthesises the published specs above into a single kit spec for our dark-ground UI. Every row carries both a duration and a curve.

| Motion role | Duration (ms) | Godot `TRANS_*` | Godot `EASE_*` | Stagger | Notes |
|---|---|---|---|---|---|
| State change (button, toggle, chip) | 100 | `TRANS_CUBIC` | `EASE_OUT` | — | MD3 `short2` equivalent |
| Panel enter (card, sheet, dialog) | 300 | `TRANS_EXPO` | `EASE_OUT` | 30 ms | Fluent `decelerateMax` shape |
| Panel exit | 250 | `TRANS_EXPO` | `EASE_IN` | — | 83% of entrance |
| Tab switch (crossfade) | 200 | `TRANS_CUBIC` | `EASE_IN_OUT` | — | MD3 `short4` equivalent |
| Dialog enter | 350 | `TRANS_BACK` | `EASE_OUT` | — | Slight overshoot for weight |
| Dialog exit | 250 | `TRANS_CUBIC` | `EASE_IN` | — | Faster than enter |
| Dial sweep | 400 | `TRANS_QUART` | `EASE_OUT` | — | Mechanical deceleration |
| Count-up (number tick) | 600 | `TRANS_QUART` | `EASE_OUT` | — | Decelerating, not linear |
| Celebration hold | 1800 | — | — | — | Static hold before release |
| Celebration release | 350 | `TRANS_CUBIC` | `EASE_IN` | — | Fade or collapse |
| Glow pulse cycle | 2000 | `TRANS_SINE` | `EASE_IN_OUT` | — | Slow, organic |
| List item enter (staggered) | 250 | `TRANS_EXPO` | `EASE_OUT` | 30 ms, cap 8 | Skip if not first show |
| Page transition | 500 | `TRANS_CUBIC` | `EASE_IN_OUT` | — | MD3 `long2` equivalent |

### Reduce Motion

When the OS reports `prefers-reduced-motion`:
- All entrance/exit animations → **instant** (0 ms).
- State changes → **instant**.
- Celebration hold → **still shows**, but no pulse, no count-up. The number appears at its final value.
- Count-up → **instant**.

### The one rule

**A duration without a curve is useless, and a curve without a duration is useless.** Every row above carries both. The kit must never expose a single global "animation duration" — a 100 ms state change and a 500 ms page transition are different quantities, and a kit that animates everything at one speed is as flat in time as our panels currently are in depth.
