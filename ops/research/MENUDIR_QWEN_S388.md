# MENUDIR QWEN S388: presentation direction for the code seats

## Pick: B — Desk Home

One reason: the owner wants Home to feel like *his* office and each playthrough to feel unique. A desk with objects that are live shortcuts gives that feeling — folder, computer, phone, fighter cards, coach card — while every other screen stays a menu. The desk accumulates stories: a note from a tough loss, a photo after a win, a sponsor's business card. No other option does that within a tiny budget.

## Biggest risk

The desk becomes cluttered or gimmicky. If every object animates and talks, it is noise. The fix: three to five objects max, each one a clear shortcut, and the desk surface earns its items through play (a card appears after a signing, a note after a loss) rather than always being full.

## What changes in the real code

**A (keep menus, richer cards):** Small. FighterTile.gd and HomeBoard.gd get more fields (personality traits, habits, style dials already exist in FighterProfile.gd but are not shown). RosterSummary.gd already has the pattern. Home.gd adds a coach card and shortcuts. Route, act() and Needs.gd do not change. What helps: the whiteboard look (Board, Polaroid, Sticky themes) already feels like a desk. What blocks: nothing — it is additive.

**B (Desk Home):** Medium. A new HomeDesk.gd replaces Home.gd's layout. Shell.gd's content pane hosts the desk scene; desk objects call main.act("go", "fights:0") etc. — the existing route system handles navigation. Needs.gd's sticky notes become objects on the desk (phone rings for bout offers, folder glows for bills). Fighter and coach cards sit on the desk surface. The other five areas (Fighters, Fights, Gym, Money, World) stay menus unchanged. What helps: act() and nav() already route everything; the desk is one scene. What blocks: the desk needs to feel alive without scripts or animation — CSS-only shapes in the preview show it is possible.

**C (Interactive office everywhere):** Large. Every area script (Fighters.gd, Fights.gd, Gym.gd, Money.gd, World.gd) needs an illustrated place or object. Shell.gd needs a transition system between locations. New art pipeline for place illustrations. Route needs a "location" concept, not just area+tab. What helps: the whiteboard theme is already illustrated. What blocks: tiny budget, no artist for five illustrated places, and the menus already work.

## Game data that exists but is not shown

- **Personality traits** (heart, temper, confidence, discipline, coachability, loyalty) — FighterProfile.gd generates them, no screen shows them.
- **Habits** (drops_right_after_jab, freezes_on_ropes, clinches_when_tired, etc.) — 20 habits generated per fighter, shown nowhere.
- **Style dials** (pressure, work_rate, body_share, counter) — four numbers that make each fighter's style unique, not on any card.
- **Footwork rating** — generated, not displayed.
- **Trust score** — derived from morale, affects how much instruction she takes; the player never sees it.
- **Rival bout history** — RivalPast seeds every rival's past bouts; only the W-L is shown, not the story.
- **Coach relationship** — coachability modulates morale events; the quality of the relationship is invisible.
- **Morale history / mood_reason** — the reason she is "Flat" is stored but only shown as a tooltip.

These would make fighter cards richer and each playthrough more unique (two fighters with the same record feel different when you see one has heart=80 and freezes_on_ropes, the other heart=40 and clinches_when_tired).

## One idea nobody listed

**The coach's diary.** A handwritten note that appears on the desk or board each week with one sentence about what happened: "Lucy's jab landed clean for the first time" or "She did not sleep well before the bout." Accumulated over a career, these notes make each playthrough a story you can read back. They cost nothing to produce (text from a template) and they make the game feel alive.

## Scores for a solo tiny-budget team

- **A: 7/10** — safe, fast, but does not make the game feel different from any other management sim.
- **B: 9/10** — the desk gives identity and stories within the budget; the other screens stay working menus.
- **C: 4/10** — too much art and scene work for a tiny team; the menus already work, replacing them with places is expensive for marginal gain.
