# TASK CARDREF1 - read the owner's reference card games from their installed files (S537)

Model: claude-fable-5-2 (Agent SDK, API credit). RESEARCH ONLY. Owner S537: "check what is installed on e, also check my steam
account and if something is needed to download, do it and check it" - CARDSCOPE3's research was thin because store pages
show no rules.

## The rule for reference games (owner, global CLAUDE.md "Reference games and REA")
Read-only inspection of the INSTALLED files; findings written as notes and numbers in OUR words; nothing of theirs (assets,
code, text) copied into our projects; no runtime hooking of online games. Do not launch any game on his monitors.

## Installed (E:\SteamLibrary\steamapps\common, all owned by the owner)
Breachway, Ironbound, KungFuCard, Mixed Martial Cards Demo, RuneCollseum (Rune Coliseum), Elite MMA Manager Demo, and - being
downloaded now - Starless Abyss (3167970), MMA Arena (1047380), Monster Train (1102190), Clutchtime (2995450): check
E:\SteamLibrary\steamapps\appmanifest_<id>.acf StateFlags 4 = installed; skip one not yet there and say so. Hearthstone is
Battle.net (not on this PC): use public rules knowledge only.

## Do
For each game: find its card/rule data (Unity: StreamingAssets JSON/CSV, Resources, TextAsset in .assets; Godot: .pck;
GameMaker: data.win strings; plain JSON/XML/CSV files). Use the REA tools / file reads / `strings`, read-only. Record per game,
in our words: the turn structure (what a player decides per turn, how many decisions a fight takes), the resources (energy /
stamina / mana and their numbers), how information is hidden and revealed (intents, face-down cards), how many cards a deck
holds and how many a fight sees, the card types and their number ranges (damage, block, cost - as ranges and counts, never a
card's text), how enemies telegraph, the run/meta structure, and anything that answers "how does a weaker or a skilled
player feel the difference". For the two fight-sport games (MMA Arena, Mixed Martial Cards) and Ironbound/Clutchtime go
deepest: they are the closest to ours.

Write `ops/research/CARDREF1_REFERENCE_GAMES.md`: one section per game, then a table comparing them on those axes, then
"what each would teach our rally form" (ops/research/DESIGN_CARDGAME_SCOPE.md current design) - concrete, buildable.

## Rules
No edits outside that one file. Do not run any game. Commit by pathspec with 'Co-Authored-By: Claude Opus 5.5
<noreply@anthropic.com>', pull --no-rebase --no-edit, push. Report in two lines and stop.
