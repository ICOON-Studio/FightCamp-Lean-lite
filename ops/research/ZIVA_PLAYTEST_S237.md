# Ziva for playtesting (S237, operator: "use ziva to playtest the game (https://ziva.sh/)")

Read from ziva.sh, /docs/ziva-mcp-server and /#pricing (2026-10-17). Prior research: searched "ziva" - nothing before.

## What it is
An AI agent that runs as a PLUGIN INSIDE THE GODOT EDITOR (Godot 4.2+, Windows OK). It reads the scene tree, scripts, editor errors and the
current visual state, and it exposes a LOCAL MCP server (`ziva-godot`) that Claude Code can connect to. Site text: turn-by-turn playtesting,
access to scenes, nodes, signals and game input.

## The two ways to use it
1. **Playtest Agent** (their own agent plays the game, shareable playtests) - **Pro or Ultra plan only**. Prices are not on the site
   (Basic is $20/month; Pro/Ultra are above that). This is a money call: yours.
2. **Free Hobby plan + our Claude Code** - the plugin's MCP server hands Claude Code the editor's tools (scene tree, input, errors). No Ziva
   bill; it uses the Claude plan we already pay. The exact tool list is only visible after install (the docs name only `start_godot`).

## Costs on our side either way
- The plugin goes into the project (`addons/`), the editor must be OPEN for the tools to exist. I would run the editor on the hidden desktop
  (godot_hidden.ps1) so nothing opens on your monitors; if their plugin refuses to work there, I will tell you.
- Heat: an open editor is a full import (the S206 87 C spike) - it starts only on a GREEN watchdog, never beside 3 agents.

## What I already do meanwhile
A playtest driver of our own (tools/s237_floor_probe.gd + s144_live_walk.gd) drives the real game build headless-windowed: it found today's
6-8 s HOME rebuild, the day plan reopening, Mara snapping back and the per-keystroke club rebuild in creation - all fixed in S237.

## Recommendation
Start with the free Hobby plan + Claude Code (no money). Buy Pro only if the free tools cannot drive input/screenshots well enough - I will
report that after one session with it.
