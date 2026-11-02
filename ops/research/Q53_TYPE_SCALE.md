# Q53 — The Numbers Behind the Type

Research task. No `.gd` touched. Every answer labelled `DOCUMENTED`, `INFERENCE` or `NOT FOUND`.

---

## Q1 — The Published Type Scales

### Material Design 3 (Roboto)

Source: https://m3.material.io/styles/typography/type-scale-tokens — `DOCUMENTED`

| Role | Size | Weight | Line Height | Letter Spacing |
|------|------|--------|-------------|----------------|
| Display Large | 57 px | 400 | 64 px | −0.25 px |
| Display Medium | 45 px | 400 | 52 px | 0 px |
| Display Small | 36 px | 400 | 44 px | 0 px |
| Headline Large | 32 px | 400 | 40 px | 0 px |
| Headline Medium | 28 px | 400 | 36 px | 0 px |
| Headline Small | 24 px | 400 | 32 px | 0 px |
| Title Large | 22 px | 400 | 28 px | 0 px |
| Title Medium | 16 px | 500 | 24 px | +0.15 px |
| Title Small | 14 px | 500 | 20 px | +0.1 px |
| Body Large | 16 px | 400 | 24 px | +0.5 px |
| Body Medium | 14 px | 400 | 20 px | +0.25 px |
| Body Small | 12 px | 400 | 16 px | +0.4 px |
| Label Large | 14 px | 500 | 20 px | +0.1 px |
| Label Medium | 12 px | 500 | 16 px | +0.5 px |
| Label Small | 11 px | 500 | 16 px | +0.5 px |

MD3 uses only two weights: Regular (400) and Medium (500). No Bold anywhere in the scale.

### Apple HIG — iOS (San Francisco Pro)

Source: Apple Human Interface Guidelines, Typography — `DOCUMENTED` (values from Apple's published text style reference)

| Style | Size | Weight | Line Height | Tracking |
|-------|------|--------|-------------|----------|
| Large Title | 34 pt | Bold (700) | 41 pt | −0.021 em |
| Title 1 | 28 pt | Bold (700) | 34 pt | −0.021 em |
| Title 2 | 22 pt | Bold (700) | 28 pt | −0.026 em |
| Title 3 | 20 pt | Semibold (590) | 25 pt | −0.024 em |
| Headline | 17 pt | Semibold (590) | 22 pt | −0.022 em |
| Subheadline | 15 pt | Regular (400) | 20 pt | −0.016 em |
| Body | 17 pt | Regular (400) | 22 pt | −0.022 em |
| Callout | 16 pt | Regular (400) | 21 pt | −0.018 em |
| Footnote | 13 pt | Regular (400) | 18 pt | −0.008 em |
| Caption 1 | 12 pt | Regular (400) | 16 pt | 0.000 em |
| Caption 2 | 11 pt | Regular (400) | 13 pt | +0.006 em |

Apple uses **negative tracking** (tighter than default) at most sizes, loosening only at the smallest caption sizes. Line heights are ~1.2–1.3× at display, ~1.3–1.4× at body.

### Fluent 2 — Web (Segoe UI Variable)

Source: https://fluent2.microsoft.design/typography — `DOCUMENTED`

| Name | Weight | Size | Line Height |
|------|--------|------|-------------|
| Caption 2 | 400 | 10 px | 14 px |
| Caption 2 Strong | 600 | 10 px | 14 px |
| Caption 1 | 400 | 12 px | 16 px |
| Caption 1 Strong | 600 | 12 px | 16 px |
| Caption 1 Stronger | 700 | 12 px | 16 px |
| Body 1 | 400 | 14 px | 20 px |
| Body 1 Strong | 600 | 14 px | 20 px |
| Body 1 Stronger | 700 | 14 px | 20 px |
| Subtitle 2 | 600 | 16 px | 22 px |
| Subtitle 2 Stronger | 700 | 16 px | 22 px |
| Subtitle 1 | 600 | 20 px | 26 px |
| Title 3 | 600 | 24 px | 32 px |
| Title 2 | 600 | 28 px | 36 px |
| Title 1 | 600 | 32 px | 40 px |
| Large Title | 600 | 40 px | 52 px |
| Display | 600 | 68 px | 92 px |

Fluent 2 publishes **no letter-spacing values**. Weight axis is the primary emphasis tool: Regular/Semibold/Bold variants of the same size.

---

## Q2 — Line-Height

### Ratio of line-height to font size

`DOCUMENTED` — computed from the tables above:

| System | Small text (12–14 px) | Body (16–17 px) | Display (32–40 px) |
|--------|----------------------|-----------------|-------------------|
| MD3 | 1.33× (16/12) | 1.50× (24/16) | 1.22× (44/36) |
| Apple HIG | 1.33× (16/12) | 1.29× (22/17) | 1.21× (41/34) |
| Fluent 2 | 1.40× (14/10) | 1.43× (20/14) | 1.30× (52/40) |

**Does the ratio change with size?** Yes — `DOCUMENTED`. All three systems tighten the ratio as size grows. Display type runs at ~1.2–1.3×; body runs at ~1.3–1.5×. The curve is consistent: smaller text needs more vertical breathing room.

### Maximum line length

`DOCUMENTED` — Butterick's Practical Typography (https://practicaltypography.com/line-length.html): **45–90 characters per line** (including spaces). The optimal is ~66 characters. MD3 and Apple HIG do not publish a specific figure; Fluent 2 does not either. This is the typographic consensus.

### Single-line text (labels, values, buttons)

`INFERENCE` — None of the three systems publish a separate line-height for single-line text. In practice, single-line elements (buttons, labels, values) use the same line-height as their role but the effective visual spacing is determined by the container's min-height or padding, not the line-height. MD3's Label roles use 1.43–1.67× line-height even for single-line button text. Apple's Caption 1 uses 1.33×. The line-height value still matters for vertical centering within a fixed-height container.

---

## Q3 — Letter-Spacing (Tracking)

### All-caps tracking

`DOCUMENTED` — Butterick's Practical Typography (https://practicaltypography.com/letterspacing.html): **Add 5–12% extra letter-spacing** (0.05 em to 0.12 em) for all-caps text. This is the typographic consensus, not specific to any one design system.

**The figure to use first: +0.08 em (8%)** — `INFERENCE`. This is the midpoint of the 5–12% range and the value most commonly cited in typography references. At 12 px that is +0.96 px ≈ **+1 px**. At 18 px that is +1.44 px ≈ **+1.5 px**. At 38 px that is +3.04 px ≈ **+3 px**.

None of the three published design systems (MD3, Apple HIG, Fluent 2) publish all-caps-specific tracking values. MD3's letter-spacing values are for mixed-case text only. Apple's tracking values are for mixed-case text only. Fluent 2 publishes no letter-spacing at all.

### Tracking by size (per role)

`DOCUMENTED` — MD3 is the only system that publishes per-role letter-spacing:

| Size range | MD3 tracking | Direction |
|------------|-------------|-----------|
| 11–12 px (Label Small/Medium, Body Small) | +0.4 to +0.5 px | Opens up small text |
| 14–16 px (Label Large, Title, Body) | 0 to +0.15 px | Near zero |
| 22–32 px (Title Large, Headline) | 0 px | Zero |
| 36–57 px (Display) | −0.25 to 0 px | Tightens large display |

The pattern: **tighten large display type, open up small text, zero in the middle.** Apple follows the same pattern with negative tracking at large sizes (−0.021 em at 34 pt) and zero to slightly positive at small sizes (0 to +0.006 em at 11–12 pt).

### Mono/tabular figures tracking

`NOT FOUND` — None of the three systems publish tracking values specific to tabular or monospaced figures. `INFERENCE`: monospaced fonts have built-in uniform advance widths, so additional tracking is usually unnecessary. If the mono face feels tight, +0.02 em is a reasonable nudge — but this is not documented anywhere.

---

## Q4 — Weight and Dark Backgrounds

### Weight pairings per role

`DOCUMENTED` — compiled from all three systems:

| Role type | MD3 | Apple HIG | Fluent 2 |
|-----------|-----|-----------|----------|
| Display / Large Title | 400 | 700 (Bold) | 600 (Semibold) |
| Headline / Title | 400 | 700 (Bold) | 600 (Semibold) |
| Subtitle | 500 (Medium) | 590 (Semibold) | 600 (Semibold) |
| Body | 400 (Regular) | 400 (Regular) | 400 (Regular) |
| Label / Caption | 500 (Medium) | 400 (Regular) | 400/600 (Regular/Strong) |
| Emphasis variant | — | — | +200 (Regular→Semibold→Bold) |

The consensus: **body text is Regular (400), headings range from Semibold (500–600) to Bold (700), labels are Medium (500) or Regular (400).**

### Dark background weight compensation

`NOT FOUND` — None of the three published design systems (MD3, Apple HIG, Fluent 2) document a weight reduction for light text on dark backgrounds.

`INFERENCE`: The effect is real — light text on a dark ground optically thickens due to halation (light bleeds into adjacent dark pixels, making strokes appear wider). The standard compensation is to **drop one weight step**: use Regular (400) where you would use Medium (500) on light, or Medium (500) where you would use Semibold (600). This is widely practised in dark-mode UI but is not formally documented in any of the three major design systems. An alternative is to reduce the font size by 0.5–1 px instead of changing weight, but weight reduction is the more common approach.

---

## THE SPEC WE SHOULD ADOPT

All values below are `INFERENCE` — derived from the three published systems above, adapted to our existing sizes and our dark-background context. No size is changed (the 12 px floor is an operator ruling).

### Our roles, with weight, line-height and letter-spacing

| Our Role | Size | Weight | Line Height | Letter Spacing |
|----------|------|--------|-------------|----------------|
| label 12 | 12 px | 500 (Medium) | 16 px (1.33×) | +0.5 px |
| body 13 | 13 px | 400 (Regular) | 18 px (1.38×) | +0.25 px |
| header-bar 18 | 18 px | 500 (Medium) | 24 px (1.33×) | 0 px |
| name 21 | 21 px | 600 (Semibold) | 28 px (1.33×) | 0 px |
| value 23 | 23 px | 400 (Regular) | 30 px (1.30×) | 0 px |
| value-large 32 | 32 px | 600 (Semibold) | 40 px (1.25×) | 0 px |
| headline 38 | 38 px | 700 (Bold) | 48 px (1.26×) | −0.5 px |

### All-caps versions of each role

Add +0.08 em (8%) tracking to every role when set in ALL CAPS. This is the single most impactful change.

| Our Role | Size | Weight (all-caps) | Line Height | Letter Spacing (all-caps) |
|----------|------|-------------------|-------------|--------------------------|
| label 12 | 12 px | 500 (Medium) | 16 px | +1.0 px |
| body 13 | 13 px | 400 (Regular) | 18 px | +1.0 px |
| header-bar 18 | 18 px | 500 (Medium) | 24 px | +1.5 px |
| name 21 | 21 px | 600 (Semibold) | 28 px | +1.5 px |
| value 23 | 23 px | 400 (Regular) | 30 px | +2.0 px |
| value-large 32 | 32 px | 600 (Semibold) | 40 px | +2.5 px |
| headline 38 | 38 px | 700 (Bold) | 48 px | +3.0 px |

### Dark-background adjustment

`INFERENCE` — Drop one weight step for all roles since our entire interface is light-on-dark:

| Our Role | Normal Weight | Dark-bg Weight |
|----------|--------------|----------------|
| label 12 | 500 | 400 |
| body 13 | 400 | 400 (already at floor) |
| header-bar 18 | 500 | 400 |
| name 21 | 600 | 500 |
| value 23 | 400 | 400 (already at floor) |
| value-large 32 | 600 | 500 |
| headline 38 | 700 | 600 |

### Maximum line length

`DOCUMENTED` — 45–90 characters per line (Butterick). For our fixed-width panels, this means a text block wider than ~40 em at body size will start to lose readability. Consider breaking wide panels into columns or constraining text width.
