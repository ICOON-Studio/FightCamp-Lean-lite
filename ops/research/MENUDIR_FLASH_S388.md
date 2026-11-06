# MENUDIR S388 Design Review: Direction B (Desk Home)

### 1. Pick and Main Reason
**Direction B (Desk Home)**. 
A gym manager lives at their desk. A tactile 2D desk dashboard gives the game instant identity, quick shortcuts (phone, ledger, mail), and prominent fighter/coach RPG cards, while keeping deep screens (Fighters, Playbook, Money, World) in clean, low-maintenance 2D menus that fit a solo tiny-budget team.

### 2. Biggest Risk
**Visual clash and multi-fighter scaling**. A pseudo-3D skeuomorphic desk would clash with flat whiteboard sub-menus and break when the roster grows. The desk must be clean, stylized 2D graphic design built from existing Godot theme boxes, fonts, and clear silhouettes.

### 3. Code Impact & Feasibility
- **A (Keep menus): Small**. Changes `Home.gd`, `HomeBoard.gd`, `FighterTile.gd`. *Helps*: `Main.act()` and `UI.theme()` already exist. *Blocks*: current whiteboard calendar and hero polaroid consume 65% of screen width, crowding out coach and squad data.
- **B (Desk Home): Medium**. Rewrites `Home.gd` into a desk grid and refactors `HomeBoard.gd` into desk widgets (`FighterCard`, `CoachCard`, `PhoneWidget`, `LedgerFolder`). *Helps*: `Main.act("go", "area:tab")` and `Needs.needs()` already handle routing and modals cleanly; `Career` already tracks `coach`, `cash`, `unread`, `fighters`, and `deals`. *Blocks*: `Shell.gd`'s fixed 214px rail requires careful card scaling inside the 1706x1016 area.
- **C (Interactive office everywhere): Large**. Rewrites `Shell.gd`, `Main.gd`, and all 6 area scripts into spatial illustrated rooms. *Blocks*: destroys container layout flow, demands heavy art assets, and kills weekly playable releases.

### 4. Existing Unshown Game Data
- **Personality & Traits**: `f.personality` has `heart`, `discipline`, `confidence`, `coachability`, `temper`, and `loyalty`. `loyalty` is never shown. Trait pairs (`Recruit.traits`: *Big heart / Short fuse*) disappear after signing.
- **Fight Habits**: 20 distinct habits in `FighterProfile.HABITS` (`drops_right_after_jab`, `slow_starter`, `bites_on_feints`) affect combat but are invisible in menus.
- **Style Dials & Mechanics**: `pressure`, `work_rate`, `body_share`, `counter`, `footwork`, and `Recruit.ambition` exist in state but have no UI cards.
- **Coach Stats**: `c.coach.rating`, `spec` (Pad work), and advice have no visual presence on Home.

### 5. Unlisted Idea
**Coach's Weekly Chalk Slate**: A desk notepad where coach Reid posts a tactical memo (*"Lucy drops her right hand when eager on the pads"*). The player picks one weekly directive (*"Protect the Chin"* vs *"Attack the Body"*). Fighters' hidden habits and temperaments react with unique RPG trade-offs (e.g., hot tempers lose trust; disciplined fighters gain move mastery).

### 6. Scores for Solo Tiny-Budget Team
- **A**: 7/10 (Fast and safe, but sterile).
- **B**: 9/10 (Best atmospheric punch, high agency, protects weekly builds).
- **C**: 3/10 (Asset trap, fatal for weekly delivery).
