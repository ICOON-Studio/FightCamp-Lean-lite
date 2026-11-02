# TASK STORY4A - The Wall's state: a pure read in StoryCampaign.gd + its test

Model: any. Owner: Arena (cloud, own `arena/` branch of ICOON-Studio/FightCamp, open a PR into master, NEVER merge). Tier: a NEW
script + a NEW test file -> parse gate + the new test + `tests/story_campaign_test.gd` (unchanged, must stay green).
S180 CHANGE: the function lives in a NEW file `Godot/scripts/StoryWall.gd`; `StoryCampaign.gd` is NOT edited (read-only).
If `git push` is refused, keep the work committed in your sandbox and say so - Claude copies the files from your diff view.

## What to build
The campaign (Chapter 1 'Keys', 9 story cards in `Godot/assets/data/story_beats.json`) gets a HOME pin screen called
**The Wall**: "one framed photo per chapter beat and per fighter; a missing one is an outline with a lock, a fallen one
hangs askew; each reopens its chapter card" (research/CAMPAIGN_PLAN.md, "New screens"). This task is ONLY the data
the screen will draw - a pure static function. No UI, no GameState, no autoload, no scene.

Create `Godot/scripts/StoryWall.gd` (`extends RefCounted`, every function static and pure, first line after extends:
`const SC := preload("res://scripts/StoryCampaign.gd")`, and call the story module only through `SC.` - e.g. `SC.cards()`,
`SC.normalized(state_in)`, `SC.due_cards(facts, state)`, `SC.read(facts, state_in)`; read StoryCampaign.gd lines 1-130 for them):

```gdscript
static func wall(facts: Dictionary, state_in: Variant, fighters: Array) -> Dictionary
```
- `facts`, `state_in`: exactly what `read(facts, state_in)` (line 107) takes. `fighters`: an Array of
  `{"id": String, "name": String, "status": "active" | "retired" | "released"}` handed in by the caller.
- Returns `{"mode", "beats": Array, "fighters": Array, "framed": int, "total": int}`.
- `beats`: one entry per card in `cards()` order (sort by the card's `order` field), each
  `{"card_id", "title", "frame"}` where `frame` is:
  - `"framed"` - the card is answered (`state.done` has it);
  - `"open"` - it is due now and unanswered (it is in `due_cards(facts, state)`);
  - `"locked"` - otherwise. A locked beat also carries `"opens"`: the card's `promise.headline` when the card has one,
    else `""`.
- `fighters`: one entry per input fighter, in input order: `{"id", "name", "frame"}` with `frame` `"framed"` for status
  `active`, `"fallen"` for `retired` or `released`; any other status -> `"framed"`.
- `framed` = number of beats with frame `"framed"`; `total` = number of cards.
- Mode `"off"` (the story is switched off): `{"mode": "off", "beats": [], "fighters": [], "framed": 0, "total": 0}`.
- PURE: it must not change `state_in`, `facts` or `fighters` (no writes to the dictionaries passed in - work on
  `normalized(state_in)`, which returns a new dictionary, and never call `mark_shown`/`choose`).
- Comment style: one `##` doc comment above the function, like the others in the file.

## The test: `Godot/tests/story_wall_test.gd` (new)
Copy the shape of `Godot/tests/story_campaign_test.gd` (extends SceneTree, `_initialize`, `_check(condition, label)`,
prints `STORY4A ... N checks, M failures`, `quit(0 if failures == 0 else 1)`). Hand-built facts only, no autoload.
Read `story_campaign_test.gd` first to see how it builds facts for a fresh gym and how it answers the welcome card.
Checks (each one a `_check`):
1. A fresh gym (mode "on", no card answered): `beats.size() == cards().size()`, `framed == 0`, the `welcome` card's beat
   is `"open"`, every other beat is `"locked"`.
2. After `SC.choose(state, "welcome", "open", 1)` (the test preloads both StoryCampaign.gd and StoryWall.gd): the welcome beat is `"framed"`, `framed == 1`.
3. A locked beat whose card has a `promise` carries `opens` == that promise's headline.
4. Beats come in `order` order.
5. Fighters: `[{"id":"a","name":"Ann","status":"active"}, {"id":"b","name":"Ben","status":"retired"},
   {"id":"c","name":"Cy","status":"released"}]` -> frames `framed`, `fallen`, `fallen`, names kept, input order kept.
6. Mode "off" returns the empty wall exactly as specified.
7. Purity: `state`, `facts` and `fighters` deep-equal their copies taken before the call (`duplicate(true)` then `==`).
8. CONTROL / MUTANT (the test must be able to fail): build a second state where a card that is NOT answered is marked
   answered by hand (put it in `done`) and assert the wall then reads it `"framed"` - so check 1's "locked" is not
   vacuous; and assert `wall()` on the real fresh state does NOT read it framed.

## Acceptance
- `godot --headless --path Godot --script tests/story_wall_test.gd` prints `0 failures` and exits 0.
- `godot --headless --path Godot --script tests/story_campaign_test.gd` still prints `0 failures`.
- Parse gate clean on both touched files (`godot --headless --path Godot --check-only --script <file>`).
- The PR ADDS ONLY `Godot/scripts/StoryWall.gd` and `Godot/tests/story_wall_test.gd` - no existing file is edited.
  Do not delete or weaken any existing test.

## Owned files
- `Godot/scripts/StoryWall.gd` (new).
- `Godot/tests/story_wall_test.gd` (new).
Read-only: `Godot/scripts/StoryCampaign.gd` (238 lines; read lines 1-130), `Godot/assets/data/story_beats.json` (9 cards, keys `id`, `order`, `title`, `promise`, `when`, `choices`,
`default`), `Godot/tests/story_campaign_test.gd`.

## The one trap
`due_cards()` returns only cards whose `when` conditions hold for the given facts - build the fresh-gym facts the way
`story_campaign_test.gd` does, or the welcome card will not be due and check 1 fails for the wrong reason.

## Prior research
CAMPAIGN_PLAN.md (design of record, D36) names The Wall; STORY2 built the pure module and its test; STORY3 built the
promise/inbox reads on it. No prior wall data exists.

## What would a human do?
Write the read as a pure function in its own small file over the story module, test it on hand-built facts, and leave the drawing to the screen task.

## Prefab check
Nothing to buy or download: it is twenty lines over the existing story module.
