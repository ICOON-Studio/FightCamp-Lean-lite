# TASK J4 — THE DESK YOU SIT AT: MANAGER, GYM, AND THE CUT (John)

**Status: COMPLETE 2026-09-06** (delivered by John, landed by Claude). Assigned 2026-09-06. Research and proposals only. No `.gd`,
no `.tscn`, no `Godot/assets/data/` writes, no `HANDOFF.md` edit, no UI design.
Claude writes your HANDOFF block from your land note, as with J1/J2/J3.

Model: top tier, effort high, Fast off. Same tier as J3 — this is an evidence
study with a live economy on the other side of it, not a summary.

## First, two corrections to carry into this pack

J3 was written without `GameState.gd`, `Sponsorship.gd` and `WorldPopulation.gd`
in your workspace, and it said so honestly. Two of its "absent" calls are wrong,
and the corrections make your priority ruling smaller, not bigger:

1. **A post-KO medical hold is NOT absent.** `BodyReadiness.gd:34-43` already
   persists `medical_hold_until_week` and `medical_hold_reason` on every
   athlete; `BodyReadiness.evaluate_competition_clearance()` (`:118`) emits a
   `medical_hold_active` refusal with an `until_week`; `GameState.gd:3385`
   is the accessor and `:3815` handles the refusal; `ManagementOverview.gd:60,
   374,440` and `ProfileRevampPanel.gd:378,614,910,1393,1462` already show it.
   So J3's rank-1 build is largely shipped — as a **week count**, which is
   exactly the invented duration D6 told us not to author. The open question is
   therefore **not** "add a hold", it is "what lifts one". Do not re-research
   the hold's existence; do not restate J3 Area 2.
2. **`vacate_title`, rankings and the title flag** stand as J3 described them.
   Area 1 is untouched by this correction.

Neither correction reopens J3. Cite them once and move on.

## Why this exists

J2 answered *who puts you on the mat and who pays whom*. J3 answered *what we
have to rule on next* and put pay-past-the-purse fourth, deliberately, because
inventing PPV points is worse than omitting them.

None of the three studies has looked at **the desk the player is actually
sitting at.** The game is a gym. The player signs athletes, pays coaches, and
books fights — and when a bout settles, `GameState.gd:10200` does this:

```gdscript
gym["cash"] = int(gym.get("cash", 0)) + purse + win_bonus + performance_bonus + gate_share - expenses
```

**The gym banks one hundred percent of the fighter's purse.** The athlete, whose
name is on the contract and whose face took the damage, receives nothing. There
is no manager percentage, no gym cut, no fighter's share, no `gym_cut`,
`manager_cut` or `purse_share` anywhere in `Godot/scripts/`. This is not a
balance number that is slightly wrong; it is the wrong party being paid, and it
is the single biggest untested assumption in the economy.

That is the question this study answers, and it is the player's own role, so it
outranks a fifth org-side system.

## Standing rules (same as J1 / J2 / J3, do not restate them at length)

- **UNKNOWN policy.** A fee, a percentage, a cap, a period or a formula that is
  not in a primary statute, regulation, commission form, or an organization's
  own published page is **UNKNOWN**. Never invent one. Inherited practice is
  **CUSTOMARY** or **INHERITED**, never that body's published rule. National
  overlays are **NATIONAL**.
- **No real people as data.** No real managers', officials', athletes' or
  executives' names in any proposed row or fixture (J1 §4.1).
- Cite J1/J2/J3; do not re-litigate them. R40 remains J2 D6.
- Every recommendation is **one line of why**, with the source labelled
  primary or secondary.
- No second career mode (J2 §6.2). If an answer needs a manager-simulator, it
  is scenery — say so in those words.

## The four areas

### Area 1 — Where the purse actually stops

The money question, and the reason for the study.

- Who is the contracted party on a professional bout: the athlete, or the
  athlete's manager/gym? What does a commission's own bout-contract form show?
- The **manager's percentage**: what is published (statutory caps, commission
  contract filings, licence conditions) versus what is customary. Several US
  jurisdictions cap a manager's share by regulation — find the text or mark it
  UNKNOWN. Do not carry a magazine number as a rule.
- The **gym's** cut, which is a different thing from the manager's: training
  fees, a corner percentage, a percentage of the purse, or nothing at all.
  Where is this published anywhere, and where is it purely private contract?
- Who pays the **corner** — cutman, seconds, coaches — out of whose money, and
  is any of it a promoter obligation rather than a fighter expense?
- What comes out of a purse before anyone is paid: commission fees, licence
  fees, drug-test fees, ticket/insurance deductions. Which are statutory (cite)
  and which are CUSTOMARY?
- **The Ali Act firewall** (15 U.S.C. § 6308) separates promoter and manager in
  **boxing only**. Say plainly what it does and does not reach, and whether it
  touches this game's catalog at all.

### Area 2 — The licence the player's own desk needs

The game has never asked whether the player is licensed to do what they do.

- Manager, second, cornerman and matchmaker **licensing**: which of the
  jurisdictions already in the catalog require one, what it costs, and what it
  bars you from doing without it. Nevada, California, New Jersey and New York
  first because J3 already has their chapters open.
- Can one entity be gym, manager and promoter at once? Where is that legal,
  where is it forbidden, and which of the 18 catalog orgs sit on each side?
- What a licence suspension or revocation does to the **desk**, not the fighter.
- Amateur versus professional: who licenses an amateur, and what does the
  amateur record cost or earn. Cross-reference J2's federation pathway rather
  than re-deriving it.

### Area 3 — What a fighter is owed that is not a purse

Not bonuses — J3 D13 settled those. The obligations.

- Medical coverage and **insurance** at a sanctioned event: who is required to
  carry it, for what, and for how long after the bout. This is the honest
  counterpart to the medical hold that already exists in the code.
- Who pays for the **clearance** that lifts a suspension — the neurological
  scan, the ophthalmology, the follow-up. Player-facing money, and the missing
  half of J3 D6.
- Training expenses, camp costs, travel and cornermen at a promotion's expense
  versus the fighter's. Which of the 13 promotions publish anything at all.
- Where a fighter is an **employee** versus an independent contractor, and what
  that changes. Flag the live litigation as contested rather than settled.

### Area 4 — The contract terms that outlive one bout

The game negotiates a purse (`FightContract.gd`) and stops there.

- Multi-bout deals, exclusivity, **champion's clauses**, matching rights,
  options and rollover. What is published in an organization's own rules
  (PFL's tournament rules PDF and IBF/GLORY championship rules are already in
  J3's source list) versus what is only ever reported.
- What ends a contract: expiry, release, retirement, a failed test, a licence
  loss. Which of these the game can honestly model.
- Sponsorship conflicts as they touch **J3 D15** — the `outfitting_policy`
  branch at `Sponsorship.gd:224`. Do not redo D15; say only what a manager/gym
  contract adds on top of it.

## What this study must deliver

Mirror J3's shape exactly — it worked:

1. **Decisions page up front.** One table, one row per call, a recommendation
   and one line of why. Keep the D-numbering local to J4 (E1, E2, … so nothing
   collides with J3's D1-D16).
2. **A file-level anchor table** — what is live, what this study proposes, and
   whether the live thing is honest, invented or absent. `GameState.gd:10200`
   is the first row.
3. Per area: **(a)** decisions coming, **(b)** evidence with UNKNOWN marked,
   **(c)** what the game does today, **(d)** one concrete minimum change,
   **(e)** issues each with a solution.
4. **A priority ruling** with a defend section, in J3's voice: what to build,
   what to research later, what waits a year, and what is scenery. Rank the
   fighter's share against the licence layer against the obligations against
   the contract terms — and defend the order.
5. **Test assertions** for a later PR (E-numbered), not written this pass.
6. **A source list** split primary / secondary, plus an explicit
   **not retrieved / do not fake** list.

## What this study must NOT do

- No code, no data rows into the tree, no UI.
- No manager-simulator, no agency career, no second playable mode.
- No invented percentage, cap, fee or period anywhere — including a "typical"
  manager 20% presented as a rule.
- Do not reopen R40, J2's pathways, or J3's Areas 1-3.
- No real person's name as data.

## Deliverables

```
research/J4_THE_DESK_AND_THE_CUT.md
research/CLAUDE_LAND_NOTE_J4.md
_john_delivery/            (staging copies, as with J3)
```

Push only those. Do not edit `HANDOFF.md`, `TASKS.md`, or anything under
`Godot/scripts/`. Send `RESEARCH READY J4` to `claude` in the mailbox when the
files are pushed.

## Anchors (read these, do not re-derive them)

- `Godot/scripts/GameState.gd:10200` — the settlement line that pays the gym
  the whole purse. Read the ~40 lines around it for what `expenses` and
  `gate_share` already are.
- `Godot/scripts/FightContract.gd:94,147,199,215,233` — the terms the game
  already negotiates: `show_purse`, `win_bonus`, `performance_bonus`,
  `gate_share`, `expenses`, and `:233`'s `net`.
- `Godot/scripts/Sponsorship.gd:224` — J3 D15's branch point.
- `Godot/scripts/BodyReadiness.gd:34,118` — the medical hold that already
  exists (correction 1 above).
- `research/J2_THE_FEDERATION_PATHWAY.md` §2.6 — the money-flow table
  this study extends downward, from the org to the fighter's own pocket.
- `research/J3_THE_DECISION_QUEUE.md` — Decisions page, D13/D14/D15, the
  priority ruling, and the source list you can reuse without re-fetching.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/J4_THE_DESK_AND_THE_CUT.md
```
