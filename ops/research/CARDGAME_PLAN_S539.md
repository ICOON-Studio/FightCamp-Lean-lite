# Card game - the plan: one line, a playable slice, how it earns (S539, owner "ok")

Owner S539 asked: "how can we organize the 'card' game workflow to be efficient and monetized ?" Claude proposed this page's
plan; the owner answered "ok". Every card round reads this page after OWNER_CARDGAME_INTERVIEW_S537.md.

## 1. One line, not two
- Until S539 two prototypes ran side by side: `proto/cardgame/` (Arena, rounds 1-4, a PLAYABLE page: index.html + ui.js) and
  `proto/cardscope*/` (Fable, rules engine + probes, rounds 1-5, a mock page only). About 160 card commits in eight days.
- From round 6: ONE folder, `proto/cardgame/`. The rules come from the cardscope engine (the measured one); the page comes from
  Arena's playable shell. cardscope1-5 and Arena's rules stay as the record (read-only). Each round is a git tag
  `card-r<N>`, not a copied folder.
- One bar sheet (DESIGN_CARDGAME_SCOPE.md section 4d: P1-P6, P10, D1) and one probe harness, reused every round; bars are
  fixed before a run and never loosened.

## 2. A vertical slice first: two arts, then one at a time
- Round 6 ships TWO arts: boxing plus the grappling art round 5 measured as most its own (judo or BJJ, decided by its P6
  numbers). The other five arts wait; each joins only after it passes "plays differently" (P6) against the ones already in.
- The slice carries the first run layer from John's list (JOHN_CARDGAME_MARKET_S538_JOHN.md section 5): a ladder with visible
  rungs (club, area, national, title shot, title defences) and a training turn with a visible cost that adds or upgrades a card.
  Rivals who return, belt paths, the corner between rounds, a daily card and ghost battles come later, one per round.

## 3. The owner plays it every week
- Each round that passes the probe goes out as a private browser link (an Artifact page built from `proto/cardgame/`). His
  ten minutes of play is the gate, as the .exe is for the gym game. Critics (Kalli, Dola - free) only after his play and the
  probe; under 8 depth / 8 play is another round or his cut-or-keep.

## 4. Free seats write it, Claude coordinates (owner S539: "the idea with the card game is to be written exclusively by arena,dola,ludo which are free , and claude coordinates")
- ARENA writes all code + tests (proto/cardgame/, node --test), one new chat per round, on the public lite mirror; its PR is
  relayed here. A SECOND fresh Arena chat code-checks each round (CARDPROTO3_CRITIC_ARENA found 6 bugs in Arena's own rules;
  Arena has deleted tests to go green before - ci_arena.py guard).
- DOLA: design, research and a critic (chat only - never code: page text loses indentation). KALLI: the second free critic.
  LUDO: card art, sounds, short card animations - only after the rules settle.
- CLAUDE: briefs, reads the CI log, runs `node --test` once, merges, publishes the owner's play link. No Claude worker writes
  card code from round 6 on (round 5, already running on Fable, finishes).
- The code is public while Arena writes it (lite mirror). Fine for the prototype; before it becomes the product, the
  production code moves to a private repo and Arena works from a stripped copy (decide at the 8/10 slice).
- One board row (CARDGAME1) and a weekly stop-or-keep line: "did this week's build play better?"

## 5. How it earns (proposal; numbers to check before any price is set)
- Premium on Steam, no packs or loot boxes: John's scan found paid random packs and paid add-ons during Early Access punished
  in reviews, "no microtransactions" praised.
- A free web demo early (itch.io) for feedback, a mailing list and wishlists; a Steam demo in a Next Fest; Early Access once one
  full ladder is 8/10; price band to research against the closest comps before launch (ESTIMATE $10-15).
- New arts after launch as paid expansions; free async ghost battles (owner S537 idea) for retention; mobile port later.
- Cross-promotion with FightCamp (a crossover fighter card, each store page pointing to the other); still a standalone game.
- Market note (John S538): the three closest games launched in the last six weeks and none has broken out - speed and one clear
  hook beat breadth.

## 6. Order
1. CARDSCOPE5 lands (round 5, seven arts) - its numbers pick the grappling art.
2. CARDSCOPE6: merge into proto/cardgame/, two arts, ladder + training turn, probe, private play link for the owner.
3. His play -> critics -> next art or next run layer.
