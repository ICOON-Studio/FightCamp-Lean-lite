# TASK PCHUB1 - the office PC screen: BOUT CONTRACTS + FINANCES (S240)

Seat: cloud Cursor (Godot UI). Branch `cursor/issue-<n>`, Claude merges by diff and wires the click. Model: Cursor default.
Discipline: BOXING (the demo).

## Why
Operator (S240): "instead of the find fight button add for now the office with a desk a pc on it click the pc and have options [...]
Tournaments (book a fight here)"; board Q-S239-1 approved the desk PC reached from the zoomed-out gym. PM Paul cut the demo PC to TWO
tabs; lead designer Ludo r106/r108 agreed: BOUT CONTRACTS (renamed from Tournaments - boxing books fights by contract) + FINANCES.

## Do
1. New `Godot/scripts/ui/OfficePcScreen.gd` (extends Control, full 1920x1080; no class_name needed): backdrop Color(0,0,0,0.65) over the
   gym; a centred 1280x720 panel (#0F172A, 2 px #334155 border, ChakraPetch fonts from res://assets/fonts/, gold #F59E0B accents);
   header "ANVIL STREET GYM - OFFICE PC" + [X CLOSE]; ESC closes; opens in 0.15 s (fade+scale 0.97->1).
   Tab bar: `Tab_bouts` "BOUT CONTRACTS" (default) and `Tab_finances` "FINANCES".
   API: `open(tab: String = "bouts")`, `close()`, `show_bouts(rows: Array)`, `show_finances(ledger: Dictionary)`,
   signals `closed`, `book_requested(offer_id: String)`.
2. BOUT CONTRACTS = the existing `scripts/ui/FindFightPanel.gd` (collected S240 7a955e34) EMBEDDED: add an `embedded` mode to
   FindFightPanel (no backdrop, no own close button, fits 1232x620 inside the PC panel, rows scroll) - re-emit its `book_requested`.
   Its standalone mode must stay exactly as is: `tests/find_fight_panel_test.gd` must still print failures=0 checks=24.
3. FINANCES = a simple 2-column ledger from `ledger`: {"cash": int, "weekly_costs": [{"label", "amount"}], "recent_income":
   [{"label", "amount"}], "net_weekly": int}. Cash top (#22C55E if >= 0 else #DC2626), WEEKLY COSTS left, RECENT INCOME right, NET A WEEK
   bottom. Money as "$6,840". Empty lists show "Nothing this week".
4. Ludo r106 values: rows/colours per research/ludo_rx/LUDO_R106_raw.txt parts 3-4 (contract confirm overlay: "SIGN BOUT
   AGREEMENT: <him> vs <opponent>", SIGN & LOCK BOUT #16A34A 180x44, REJECT / RETURN #64748B) - map onto FindFightPanel's existing
   confirm step, do not add a second confirm.

## Tests (red on master first - the file does not exist)
New `Godot/tests/office_pc_screen_test.gd` (extends SceneTree, prints `OFFICE_PC_SCREEN failures=N checks=M`, quit(1) on fail):
opens on BOUT CONTRACTS; 4 rows from a fixture of FOUR different boxing opponents (records, styles, purses, days - never identical);
FINANCES tab shows cash, 3 costs, 2 incomes, net; ESC closes and emits closed; accept+confirm on row 2 emits book_requested with row 2's
offer id; panel rect inside 1920x1080; no Label overflow (text width <= its box). Plus `tests/find_fight_panel_test.gd` unchanged 24/24.
Command: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/office_pc_screen_test.gd`. Parse gate first:
`python Godot/tools/check_scripts.py <touched .gd>`. A 1920x1080 still of each tab in the PR is welcome.

## Rules
GDSCRIPT_TRAPS.md (Label sizing, `:=` on Variant). Edit only the two ui files + the new test. Do not touch GymClub3D/GymHall3D (Claude
wires the desk click to this screen; another task changes the camera). THE ONE TRAP: never delete or weaken a test to go green.

## Prior research
LUDO_R106_raw.txt (PC layout, tabs, contract flow), LUDO_R108_raw.txt (2 tabs, direct open over the gym, no camera push),
TASK_FINDFIGHT1.md, scripts/ui/FindFightPanel.gd, HudV3Widgets.gd (house style).

## What would a human do?
Sit at the desk, flick between the fight offers and the books, sign one contract, close the screen.

## Prefab check
None - two tabs over our own collected panel.
