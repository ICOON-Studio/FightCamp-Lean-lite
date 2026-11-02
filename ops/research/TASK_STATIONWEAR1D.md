# TASK STATIONWEAR1D (S219) - the station card can be PINNED open so SERVICE / REPLACE are clickable

Model: Grok Dev (Grok Bot app chat "Grok Dev"). Branch grok/stationwear1d from master (STATIONWEAR1C merged). PR, never merge.
Switch `station_wear` stays OFF by default; everything below works only when ON (OFF = today's behaviour, byte-identical).

## Why (your own STATIONWEAR1C note 5)
The station card is a HOVER card (`StationInfoCard.attach_hover`, used by GymHallPanel.gd:152; the 3D club opens it at
GymClub3D.gd:1409). It closes on mouse exit, so the SERVICE / REPLACE buttons you added can never be clicked. A player who sees
"WORN - about 12 hours left" must be able to act on it.

## Do
1. Click (left mouse) on a station - in the 3D club (GymClub3D) and on the 2D hall (GymHallPanel) - PINS its card: it stays open,
   gets a small close "X" and closes on X, Escape, or a click on empty floor. Hover still shows the same card unpinned (today).
   Only one pinned card at a time; pinning another replaces it.
2. While pinned the card's buttons are live (mouse_filter STOP on the card panel + buttons); SERVICE / REPLACE call 1C's handlers,
   the card re-reads `get_equipment_integrity` and redraws in place (the integrity bar tweens to the new value - house rule "every bar
   tweens"); the top bar's cash refreshes (GymHallPanel `_refresh_shell_money` pattern).
3. Keyboard: Escape closes; the card never covers the station it belongs to (reuse `clamp_to_viewport`).
4. Test `Godot/tests/station_card_pin_test.gd`: pin by the click handler -> card stays after a simulated mouse exit; SERVICE through
   the pinned card's button moves cash and integrity (same numbers as station_wear_day_test); X / Escape close; hover unchanged with the
   switch OFF (card text byte-identical to today); pinning B closes A.
5. Parse gate + `python Godot/tools/run_tests.py --jobs 2 --only station,club,gym_hall,day_lap,equip,game_switches`. Paste PASS lines.

## VISUAL GATE
UI only: Claude renders the club with a pinned card on the PC and opens it; the operator closes it.

## Prior research / prefab check
TASK_STATIONWEAR1A-C; StationInfoCard.gd (266 lines + 1C). Godot's own Popup/PopupPanel is acceptable if it keeps our card look.

## The one trap
Do not break the hover card for the OFF arm or for stations with no equipment - those are the same today and after.
