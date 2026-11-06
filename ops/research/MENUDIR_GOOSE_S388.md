# MENUDIR GOOSE S388: Presentation Direction Review

## 1. Pick: B — Desk Home

Home becomes a stylized 2D top-down office desk. Objects are live shortcuts: folder = finance (cash shown on it), computer = mail/rankings/scouting, phone = bout offers (rings when one arrives), fighter and coach cards sit on the desk surface. Other screens stay menus.

**One main reason:** the owner wants Home to be a dashboard with shortcuts and key information, and for each playthrough to feel unique. A desk is already a dashboard — things are laid out by priority, you glance and act. It gives personality and uniqueness (the desk changes as the career changes: a pro contract letter appears, the folder thickens with bills, a rival's photo gets pinned up) without rebuilding every screen. The whiteboard look (look B) already uses physical metaphors (polaroid, sticky notes, cash tin); the desk is the natural next step for Home only.

## 2. Biggest risk

Art cost creep. Each desk object needs a clean sprite and hover/active states. If the desk tries to illustrate too much (drawers opening, items animating), it becomes an art project. Mitigation: CSS-shape-style flat icons, no animation beyond a subtle hover glow, and objects that are visually distinct but simple (a folder shape, a phone shape, a card rectangle). The prototype in the HTML proves it works with plain shapes.

## 3. Files that change for A, B and C

**A — Keep menus, improve them:**
- `scripts/ui/areas/Home.gd` — medium. Richer cards, more information density, dashboard layout.
- `scripts/ui/FighterTile.gd` — medium. Bigger cards with personality traits, form, rivalry hints.
- `scripts/ui/HomeBoard.gd` — small. Already has the physical metaphor; just add more data to notes.
- `scripts/ui/RosterSummary.gd` — small. Already shows 7 attributes, style, weapons, pay.
- `scripts/ui/Shell.gd` — small. Top bar could show more context.
- **What helps:** the route/area/tab system in Main.gd is already clean; Needs.needs() and Needs.flags() already surface everything; RosterSummary.boxer() already has all the data. **What blocks:** nothing structural; it is mostly layout and adding fields to cards.

**B — Desk Home:**
- `scripts/ui/areas/Home.gd` — large. Full rewrite from whiteboard layout to desk surface with positioned objects.
- `scripts/ui/Shell.gd` — small. The rail stays; only Home's content pane changes.
- New file `scripts/ui/DeskHome.gd` — medium. The desk layout, object positions, hover states.
- New file `scripts/ui/DeskObjects.gd` — medium. Each object's visual (folder, computer, phone, cards) and its click action.
- `scripts/ui/FighterTile.gd` — small. Cards sit on the desk; may need a compact variant.
- **What helps:** Main.gd's route system means only Home.gd's build() changes; the act() dispatch already handles every click; Needs.needs() provides the data for what appears on the desk. **What blocks:** the desk objects need art (even simple shapes); the whiteboard's polaroid/poster metaphors need to translate to desk items.

**C — Interactive office everywhere:**
- `scripts/ui/areas/Home.gd` — large.
- `scripts/ui/areas/Fighters.gd` — large. Each tab becomes a place (roster = filing cabinet, training = whiteboard, camps = calendar on wall).
- `scripts/ui/areas/Fights.gd` — large. Offers = phone, calendar = wall calendar, results = newspaper.
- `scripts/ui/areas/Gym.gd` — large. Floor = window, staff = desk chair, members = door, facilities = shelves.
- `scripts/ui/areas/Money.gd` — large. Overview = cash tin, income = ledger, bills = envelope stack, deals = folder.
- `scripts/ui/areas/World.gd` — large. News = newspaper, rankings = poster, events = calendar, search = computer.
- `scripts/ui/Shell.gd` — large. The rail becomes navigation between places; transitions between screens.
- New files for each area's illustrated scene — very large.
- **What helps:** the route/area system already separates screens; act() handles every click. **What blocks:** massive art cost; transitions between places need animation; the whiteboard look's consistency breaks when every screen is a different illustration; tiny budget cannot sustain it.

## 4. Game data that exists but is not shown

- **Personality traits** (FighterProfile: heart, temper, confidence, discipline, coachability, loyalty) — used in fight calculations and morale, never shown on any screen. Would make fighters feel like people and playthroughs unique (one fighter is brave but undisciplined, another is confident but won't listen).
- **RivalPast** — every rival's full bout-by-bout history exists (RivalPast.seed), but only their W-L and threat/weak are shown. Could show "she beat Chloe Bennett twice" on a rival's card.
- **OppFile tape history** — which opponents we have film on, how many rounds scouted. Shown in the bout page but not on Home or the fighter tile.
- **WeekTwist** — the weekly twist card system (one per week, changes something). The twist is shown when it happens but not as a persistent "what made this week different" marker.
- **Cash history** (Career.cash_history) — week-by-week cash exists but only the current week and a chart on Money > Overview are shown. Could show a sparkline on the cash tin.
- **Fighter history/results** — each fighter's past bouts exist (Career.results) but only on the fighter page's Record tab. Could show "last 3 results" on the fighter tile.
- **Coach data** — the coach exists (Career.coach) but has no card on Home. The owner specifically asked for coach cards.
- **Facilities** (Career.facilities) — the gym's equipment/facilities exist but are not shown anywhere visible.
- **Deals/sponsors** — active deals exist but are buried in Money > Deals. Could show on the desk.

## 5. One idea nobody listed

**The gym's reputation as a visible, changing thing.** Reputation (Career.reputation) is a number that affects member recruitment and bout offers, but it is never shown as a visual. Make it a "gym prestige" display on Home — a wall plaque that gains stars or trophies as reputation grows, or a local newspaper clipping that changes headlines ("Anvil Street Gym's Lucy Jackson wins regional title"). Each playthrough's gym becomes visually distinct: one gym has a wall of amateur trophies, another has pro fight posters, another has newspaper clippings of upsets. It costs nothing in systems (reputation already exists) and makes the gym feel like it has a history.

## 6. Scores (1-10, solo tiny-budget team)

- **A: 7/10** — Safe, achievable, addresses "more information" well. Does not address "each playthrough feels unique" or the dashboard desire strongly. Risk: menu fatigue, screens become dense.
- **B: 8/10** — Addresses dashboard desire, gives personality and uniqueness, keeps scope manageable (only Home changes). Risk: art cost for desk objects, but mitigated by simple shapes. The physical metaphor extends the whiteboard look naturally.
- **C: 3/10** — Beautiful in concept, impossible in practice for a tiny budget. Every screen becomes an art task. Transitions between places need animation. The whiteboard look's consistency breaks. The owner's "each playthrough feels unique" is better served by data (personality, history, reputation) than by illustrated places.
