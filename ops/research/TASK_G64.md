# TASK_G64 — GROK — SPEC THE FIGHT-NIGHT HUD AT FM MATCH-DAY DENSITY

**Owner:** grok
**Mode:** Expert. **NEVER Build mode.**
**No checkout. Reply in chat with the full text — do NOT attach a file.**

## Why this, and it is your own finding

G63 was excellent — 113 sources, buildable rules, DOCUMENTED/INFERENCE throughout.
Its most valuable paragraph was the answer to "what do they all do badly", and you
should build on it rather than repeat it. Verbatim:

> Managers either hide the bout in a text log (WBM, PWS, Believr show-runner) or
> wrap a videogame health bar around a 3D toy (BCM, TGP). **Nobody puts
> region-level damage + live corner verbs + readable numbers on screen at FM
> match-day density. That is the hole.** ... you are not matching them. **You are
> ahead of them.**

And the honest limit you attached to it: **"Density first, skin second."**

So: **spec that HUD.** We already have six body regions as an engine feature with
no density contract. This task turns your paragraph into a layout somebody can
build without taste.

## What to deliver — one buildable spec, in numbers

A numbered spec for a 1920×1080 fight-night screen. Every entry a value, not an
adjective. Cover:

1. **THE FRAME.** What occupies the centre, and how much of it. The bodies must not
   be covered — G63 rule F.1 already says chrome goes in the bottom third. Give
   the pixel bands: what is in the top N px, the centre, the bottom N px.
2. **THE TWO REGION PANELS**, one per corner. Undisputed does ~10 rows at ~180 px
   wide; we have **six** regions. Give: row height, panel width, where the label
   sits, bar width as a share of the row, whether the number is shown, and how
   both corners are arranged without mirroring becoming confusing.
   **Reuse the stat-row contract rather than inventing a second one** — it is
   `label | bar 55% | tabular number` at 28–32 px, and you specified it yourself.
   Say explicitly whether the HUD row uses that pitch or a tighter one, and if
   tighter, give the number and why.
3. **THE CLOCK AND ROUND.** Size, position, and what else lives in that cluster.
4. **THE TWO RESOURCE BARS** per fighter (health/damage and gas, per your rule
   F.2). Dimensions and placement relative to the region panel.
5. **THE DECISION CLUSTER.** G63 lists the verbs: corner / pace / skip / speed /
   throw-towel. How many controls, what size, where, and which is primary. Boxing
   Club Manager's numbers (skip after 1:30, speed 0.5–2.5×) are a reference.
6. **THE TICKER.** Height, how many lines, how fast, and what a line looks like.
7. **THE POST-FIGHT TABLE.** Your rule F.7 says post-fight is a table not a
   speech, with both columns. Give its columns and row count.
8. **WHAT IS CUT.** At this density something has to go. Name what you would NOT
   put on screen, and why. A spec with no omissions has not been costed.

## Two constraints that are not negotiable

- **We are a MANAGEMENT sim, and the player is a manager, not a fighter.** The
  verbs are corner-side. Do not spec a combat input scheme.
- **It must read at 1080p without zooming.** Count the rows you are asking for and
  say the total vertical pixels they need. If it does not fit, say so and cut.

## Label everything

DOCUMENTED (you saw it — say which game and which shot) or INFERENCE. Where you
are proposing something nobody ships, mark it **NEW** and say why you believe it
works. That third label matters here, because the whole point is the hole nobody
has filled — most of this spec will be NEW and that is correct, but it must be
distinguishable from what you observed.

## THE TRAP

**Do not design a skin.** No colour choices, no gradients, no "premium feel" —
another agent (M22) owns the palette and has already delivered it with contrast
ratios. If you specify a colour, you have drifted. **Your unit is the pixel and
the row count.** Your own line: density first, skin second.

**Second trap:** do not re-derive G63. Its rules stand and are landed at
`G63_MENU_RULES.md`. Cite a rule by its letter and number when you build on it
(e.g. "per F.2"), and only restate one where this screen needs it changed.

## Deliverable shape

Lead with three lines: the total vertical budget the HUD consumes, the single
element you would fight hardest to keep, and the one thing you are least sure
about. Then the numbered spec. Under 300 lines.
