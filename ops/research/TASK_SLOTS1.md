# TASK SLOTS1 - QWEN (qwen3-coder) - one move in learning: the slots, the coach's three cards, the learning speed

Status: OPEN (S450, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: PROGRESSION (approved, owner Q-S294-211 "Yes, go ahead"). Spec: ops/research/PROGRESSION_MAP_S448.md section 4 M2 (READ IT)
and section 10 task 6. Builds on scripts/rules/MoveTree.gd (MOVETREE1, merged S450). A PURE module + its test: no wiring (Claude wires
it into PadWeek and the Monday review after the merge).

## Contract
OWNS: scripts/rules/LearnSlots.gd, tests/learn_slots_test.gd
RED_TEST: tests/learn_slots_test.gd -> LEARN_SLOTS failures=0
REGRESSION: move_tree_test, move_mastery_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit:
- scripts/rules/MoveTree.gd: NODES, PUNCH_IDS, STEP_IDS, DEFENCE_IDS, STYLES, mastery(f, id), state(f, id), open_nodes(f), opens(id).
- scripts/rules/MoveMastery.gd: decay_week (0.75 a week out of drilling; the floor rules), tier/word.
- scripts/rules/BoutRead.gd ~228: coachability lives in f["personality"]["coachability"] (default 55).

## What to build (LearnSlots.gd under 250 lines; pure static; preloads MoveTree and MoveMastery only)
1. `slots(assistant_pads: float) -> int`: 1; 2 when an assistant who runs the fighter's pad nights has a pads rating of 65 or more
   (pass -1.0 for no assistant).
2. `speed(f: Dictionary) -> float`: x(0.8 + 0.4 x coachability / 100), then x1.1 when f["age"] < 23, x0.9 when f["age"] >= 31
   (coachability from f["personality"]["coachability"], default 55; age default 22).
3. `cards(f: Dictionary, opp_style: String, gains: Dictionary) -> Array`: up to THREE open nodes (MoveTree.open_nodes(f) minus the
   moves already in f["learning_slots"] (Array, may be absent)), in the coach's order, each a Dictionary:
   `{id, reasons: Array[String], weeks_to_usable: int, opens: Array, answers: bool, builds_style: String}`.
   - gains = {node_id: mastery gained a week on this week's pad nights} computed by the caller (PadWeek.project, wired later);
     a node missing from gains uses DEFAULT_GAIN 6.0. weeks_to_usable = ceil((30 - mastery) / (gain x speed(f))), at least 1.
   - ORDER (score, highest first; ties by MoveTree.NODES order):
     a) +3 when the node ANSWERS the next opponent's style: a const ANSWERS {style word: [node ids]} inside the module, for the six
        style words in MoveTree.STYLES. Use: Out-boxer -> cut_off, step_in, feint; Pressure fighter -> step_back, pivot_out, tie_up,
        Check hook; Counter-puncher -> feint, Body hook, step_in; Slugger -> roll_out, step_out, Check hook; Volume puncher -> tie_up,
        pivot_out, roll_out; Boxer-puncher -> step_back, Check hook, feint. reasons gets "Answers a <style>".
     b) +2 when the node completes a style set the fighter is building: a STYLES set with 2 of its 3 moves at 60+ and this node the
        third. builds_style = that style's name; reasons gets "Third move of <style>".
     c) +1 per node it opens (MoveTree.opens(id).size(), at most +2). reasons gets "Opens <first id>".
     d) every card gets "<n> weeks to Usable".
4. `swap_price(m: float) -> float`: the mastery a half-learned move loses a week while out of the slot = m - MoveMastery.decay_week(m,
   false) (so the button can print it).
5. `pick(f: Dictionary, id: String, slot_count: int) -> bool`: puts id in f["learning_slots"] when it is open and a slot is free
   (size < slot_count); returns false otherwise. `drop(f, id)` takes it out.

## The test (red on main first: the file does not exist)
tests/learn_slots_test.gd (extends SceneTree, prints `LEARN_SLOTS failures=<n>`, quits with the count). Build the fighter with
`Data.fighter_state(Data.lucy(), 0)` plus a `steps` dict from MoveTree.day0_steps(55.0) - never a hand-made identical pair:
- slots: -1 -> 1, 64.9 -> 1, 65 -> 2.
- speed: coachability 100 / age 25 -> 1.2; coachability 0 / age 20 -> 0.88; coachability 55 / age 33 -> (0.8+0.22) x 0.9.
- cards against "Pressure fighter": at most 3, every id is open in MoveTree.state, the first card answers a Pressure fighter if any
  open node does, no card is a node already in the slot, no two cards the same.
- builds_style: give Jab and step_out 60+ and make step_back open (step_out 30 is enough) -> step_back's card says "Third move of
  Out-boxer" and ranks above a card with no reason but "weeks to Usable".
- weeks_to_usable: a node at 12 with gain 6 and speed 1.0 -> 3.
- swap_price(20) equals 0.75 (MoveMastery's decay).
- pick: fills one slot, refuses a second with slot_count 1, takes a second with slot_count 2, refuses a locked node.
- Two different fighters (Lucy and Data.PROSPECTS[3]) give different card lists or different weeks for the same opponent style
  (the module reads the fighter, not a constant).

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%`).
- Godot jobs only through `python ops/Tools/godot_slot.py run --who SLOTS1 -- <godot.exe> ...`; the plain win64 exe, never _console.
- No he / she in strings (no_pronoun_test). Game words (Usable, Sharp; "weeks to Usable").
- Do not delete or weaken any test. Under 500 lines a file.

## Prior research
- PROGRESSION_MAP_S448.md M1 (the tree), M2 (this), M4 (style sets); the critics' S448 rounds (PROGRESSION_CRITIC_S448*_KALLI/JOHN.md).

## What would a human do?
A coach teaches one new thing at a time, picks it for the next opponent or to finish what the boxer is building, and says how long it
takes. A coachable young boxer learns faster.

## Prefab check
None: MoveTree holds the tree; this is the pick on top of it.

Test command: `python ops/Tools/godot_slot.py run --who SLOTS1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tests/learn_slots_test.gd`
RESULT line for the PR body: `RESULT: tests/learn_slots_test.gd -> LEARN_SLOTS failures=0`.
