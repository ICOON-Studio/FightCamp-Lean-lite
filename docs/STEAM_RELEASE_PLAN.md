# FightCamp Steam release plan (v2, S388, 2026-11-06)

Goes with docs/GAME_BIBLE.md. v1 scored 4/10 from a producer critic: wrong gate order, no price, no budget. No release date yet, on
purpose: the first honest date comes after Gate 3. The critic would not bet on this game reaching Steam today, and would reconsider if
3 of 5 strangers keep playing. That test is why Gate 1 comes first.

## 1. Where the game stands today
| Area | State | Blocks release? |
| --- | --- | --- |
| Core loop, sign to fight to next goal | Playable, 171 tests pass | No |
| Strangers have played it | **Never, after 815 commits** | **Yes, the biggest gap** |
| The hook | Plan measured at +18 points of bouts won; barely visible yet (bible section 4) | **Yes** |
| Structure | Critic 4/10; 25 tabs plus 8 fighter tabs; stubs | **Yes** |
| First hour | Critic 3/10 before S387's guide, not rescored | **Yes** |
| Fight motion | 2-3/10 beside UFC 6 and Undisputed (S386); latest round 6.5/10 by a looser judge | Bar under review |
| Sound | Set chosen, not wired in | **Yes** |
| Settings | "Not built yet" | **Yes** |
| Handbook | "Not built yet" | Should have |
| Look | Best screen 6/10 from a blind critic | **Yes** |
| Known rule bugs | Camp bonus counted twice; ambition does nothing. Frozen condition fixed S388 | **Yes** |
| Release build | Renamed Godot program, window title shows DEBUG, no export templates, no icon | **Yes** |
| Steam: account, page, capsule, trailer | Not started, as far as the repo shows | **Yes** |

## 2. Legal and asset audit
| Asset | What we know | Action | Who |
| --- | --- | --- | --- |
| MetaHuman bodies (all fighters) | Reports since June 2025 say other engines are allowed, free under $1M revenue, no training AI on them. One 2026 blog disagrees. Epic's page needs a login: **not confirmed** | Read the current licence signed in, keep a copy | Operator |
| Motion clips | CMU: shipping allowed. ActionForge: CC0 as stated on its site. Fab Ailive: bought, terms unread. Rokoko and ~475 FBX in Downloads: source and licence **unknown** per clip | List every shipped clip with its source; drop unknowns | Claude |
| Gloves | CC BY 4.0: credit required | Credits screen | Claude |
| Icons, fonts | Lucide ISC, OFL: licence files must ship | Credits screen | Claude |
| Boots | Higgsfield terms s4.4, commercial | Keep the job record | Claude |
| Ludo art and sounds | Assumed covered by the paid plan, **terms unread** | Read and keep | Claude |
| GrappleMap | Licence in repo, unread in full | Read (BJJ only) | Claude |
| Real names | IBJJF in data and an event name; England Boxing rules used | Invented names in player-facing text | Claude |
| AI use | Steam's content survey requires disclosing AI-made art, sound and code | Declare honestly | Claude drafts, operator submits |

Not legal advice. A short lawyer review before launch is worth paying for.

## 3. The gates
Each has a pass test. Work outside the current gate waits.

**Gate 0: Decisions.** Bible read, the four decisions made, legal audit done.

**Gate 1: Prove the hook. Cheap, no art.**
a. Five strangers play today's build: a baseline, before anything else is built.
b. Design the structure on paper, reviewed by a critic. c. Make the plan decide more: a bigger edge, ring position staged, a post-fight
"why", fewer give-away hints. d. Build it as plain screens. e. Five new strangers.
Pass: 3 of 5 keep playing, and they can say why they won or lost.
**Stop rule:** if two rounds of this fail, we stop adding features and rethink the game with the operator. One project was already
cancelled after months without a version he enjoyed; this gate exists so that cannot happen slowly again.

**Gate 2: Store page, early.** Steam account, capsule by a human artist, short trailer, Coming Soon page. Wishlists are the real demand test,
so they start before the polish. Pass: 5 strangers can say what the game is from the page.

**Gate 3: Three great hours.** Fight motion to the agreed bar, sounds, settings, rule bugs, one art pass, release build. Pass: all bible
bars. **The first honest date comes here.**

**Gate 4: Demo and Next Fest.** Pass: players stay, and we read the wishlists.

**Gate 5: Content complete.** Three full careers without a dead end, balance, saves survive updates, no crashes, credits, Steam build.

**Gate 6: Launch** in Early Access, after store and build review.

## 4. Steam's fixed steps
From Steamworks docs: a Coming Soon page must be public at least two weeks before release; store review takes about 3-5 business days,
so submit a week ahead; the build needs review too, so allow for failing once; you press release yourself. New developers wait about 21
days after paying the app fee (reported as $100; confirm the amount on the Steamworks site).

## 5. Money and expectations
- **Price:** comparable: Believr $14.99 in Early Access. Working assumption $14.99-19.99, to be set by the hook test.
- **Target length:** to be set in the structure design; this audience expects tens of hours.
- **Budget:** unknown. Needed from the operator: what he will spend in total on art, capsule, trailer and lawyer. No costs are invented here.
- **Demand:** about 7,000 wishlists before launch is the commonly cited target, a marketing rule of thumb, not a Valve rule.
- **Honest outlook:** close competitors are estimated at a few thousand copies. At $15 and Steam's cut that does not repay paid work.
  This may be a game made because it is worth making, not an income. He should decide knowing that.

## 6. Who does what
**Operator:** the four decisions, budget, finding strangers, Steamworks account, fee, bank and tax forms, the MetaHuman licence check.
**Claude:** design, code, the plan, briefs, assets audit, store text, critics on everything before he sees it.
**Seats:** animation rounds and research. Argon's credits and Gemini's paid API are out today.

## 7. Next five jobs
1. Operator: read the bible, make the four decisions. 2. Operator: find five strangers; Claude: prepare a build and a short test sheet.
3. Claude: the structure on paper, critic-reviewed. 4. Claude: make the plan decide more. 5. Claude: clip licence list.
Paused until they matter: fight motion rounds, sound wiring, Home skin.
