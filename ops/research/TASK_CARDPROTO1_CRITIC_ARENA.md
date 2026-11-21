# TASK CARDPROTO1_CRITIC_ARENA - code-checked critic of the card-game prototype

Repo FightCamp-Lean-lite, branch main. You are a FRESH critic, not the author. Owned file (only one you add): `ops/research/CARDPROTO1_CRITIC_ARENA.md`. Do not edit proto/. Open a PR.

1. Read `proto/cardgame/README.md` and `proto/cardgame/rules.js`.
2. With node, play at least 20 bouts through rules.js (different boxer pairs, both AI-vs-AI and "always the same card" / "always the best-looking card" strategies versus the AI). Find out: is there a dominant strategy; does playing smart beat playing random by how much; do the scouting / habits / camp / corner cards change decisions; are any cards dominated or dead; how do defensive cards deal damage; how long is a bout; how swingy is it.
3. Write the file: scores 0-10 for DEPTH, PLAY (fun), GENERAL; the evidence (numbers from your runs); missing cards/options; useless cards; then THE ORDERED LIST "TO REACH 10/10" (most important first, specific: card names, numbers, rules). Bar to keep the mechanic: 8+ on DEPTH and 8+ on PLAY, so be honest, not kind.
4. Do not delete or weaken any test. Tests: `node proto/cardgame/rules.test.mjs`.
RESULT line in the PR body: the exact output of that command.
