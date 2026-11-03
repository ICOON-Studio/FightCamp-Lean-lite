# J90 - Tooltips that players praise: what makes them great, and the build spec for FightCamp
Kind: research

Seat: John (deep research). Discipline: boxing demo (the whole game's UI). Model: your default. Output: one markdown answer, as long as it needs.

## Why
Operator S290 (2026-10-23), verbatim: "you need to make cooler tooltips , look for tutorials or other games that have been praised for their tooltips".
FightCamp is a Godot 4 gym-management sim (boxing first), visual direction Two Point Museum / Mad Games Tycoon 2: bright, warm, a dark brass/cream UI (top bar, BUILD window with picture tiles, modals). Today a tooltip is a plain dark box with a title line and one text line, appearing after a delay at the cursor.

## Prior research
- J52_TOOLTIPS_AND_TUTORIAL.md (S?): WHAT goes on screen vs in a tooltip, glossary, tutorial. Do not redo it - this task is HOW tooltips LOOK and BEHAVE.
- S184_TIPS_AUDIT2.md: census of which controls have tooltips (coverage, not quality).
- M_HUD2_MARIA.md: menu look rules (one hero per screen, lifted panels).

## What would a human do?
A UI designer would play the games known for great tooltips, screenshot them, list what they have in common, then write a spec with sizes, timings and states.

## Prefab check
Name any Godot 4 tooltip addon / asset (Asset Library, GitHub, itch) with its licence, and whether it fits (rich text, nested tooltips, icons inline).

## Questions (answer all, with sources: articles, GDC talks, reviews, Reddit/forum threads praising them)
1. Which games are PRAISED for their tooltips, and for what exactly? At least: Crusader Kings 3 / Victoria 3 (nested, lockable tooltips), Slay the Spire (keyword tooltips beside cards), Path of Exile / Diablo (item tooltips), Civilization VI, Two Point Hospital / Museum, Football Manager, Balatro, Into the Breach, RimWorld, Hades, Frostpunk, Anno 1800, Factorio. Add others you find praised.
2. The patterns, as a table: delay before showing (ms), fade/scale animation (ms), follow-cursor vs anchored, max width (px at 1080p), title/body/footer structure, icons and numbers inline, colour coding (good/bad/keyword), nested tooltips (hover a keyword -> its own tooltip; lock with a key or by holding), comparisons (current vs new, +/- deltas), keyboard hint chips, pointer/arrow, edge flipping.
3. Common mistakes players complain about (too slow, covers what you look at, walls of text, flicker).
4. Accessibility: font size, contrast, a setting for delay, readable at 1080p and 4K.
5. A BUILD SPEC for FightCamp: 3 tooltip tiers (simple hover label; rich card with title, icon, stats rows, coloured deltas, hint chips; nested keyword tooltips for game terms like Stamina, Strain, Sharpness, Focus) with exact numbers (delays, sizes, paddings, radii, animation), states, and where each tier is used (top bar icons, BUILD tiles - price, footprint, what it trains, members it holds; floor stations; fighter stats).
6. Tutorials / talks on designing tooltips (links) worth reading.

Reply in the chat; Claude saves it to research/J90_TOOLTIPS_PRAISED.md.
