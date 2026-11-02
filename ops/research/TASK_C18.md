# TASK C18 — THE WIDER GAME SURVEY: AUTO-BATTLERS, DECKBUILDERS, MANAGERS (Codex)

Model: top tier, effort high, Fast off.

Research only. **No `.gd`, no `.tscn`, no engine, no test.** Per `AGENTS.md`
precedence this task file beats the general rule: **write no `HANDOFF.md`
block** — Claude writes it.

## Why this exists

C17 landed and asked the operator three gates (tick cadence, the pause/speed
seam, whether `FightSimulation` gains authoritative spatial state). **The
operator has deferred all three deliberately** and wants a wider read first.
Do not press for those answers and do not assume them.

Read the deferral this way: before deciding how the live fight scene is
*built*, the operator wants to know what the fight should **be**. The bucket
list below is the tell — auto-battlers, deckbuilders, and the games that fuse
them sit next to the sports managers. The question underneath the survey is:

> **A fight the coach watches and interrupts — is that an auto-battler round,
> a deck resolving, a manager's match engine, or something else? What do the
> games that already do it well actually do?**

Answer that with evidence. C17's shape is the standard to match: what you
verified, where, and what follows from it — never a vibe.

## Work already in flight — keep it, move it

Codex began this survey from the operator's chat message BEFORE this task file
existed, and wrote it as an **addendum inside `C17_FIGHT_SCENE.md`** (a method
caution, a combat-management table, and five-item tables for auto-battlers,
deckbuilders and hybrids). **Keep all of it.** Move it into
`C18_GAME_SURVEY.md` so the architecture document stays the architecture
document and the survey can be cited on its own, then continue there.

**THE MOVE IS ALREADY DONE (Claude, 2026-09-06).** Your addendum now lives in
`research/C18_GAME_SURVEY.md`, verbatim, under a status banner listing
what is still missing; `C17_FIGHT_SCENE.md` is back to its committed text.
Continue in `C18_GAME_SURVEY.md` and delete the banner when the missing parts
are written. Do not re-move anything.

Three things that pass already reached: the "most successful cannot be ranked
rigorously from public data" caution is **accepted** — keep it and keep naming
the measure per pick; the refusals ("never player-controlled striking", "no
random command hand during a live bout") are the right instinct; and the
Motorsport Manager race-day read is the closest analogue found so far.

One correction that matters: the addendum records Pound for Pound as unlocatable
and asks for a storefront URL or a local install. **It is installed** — see the
table below. Give it a first-hand read; do not leave it an open evidence item.

We share one working tree. `C17_FIGHT_SCENE.md` was committed at `bfef349`
mid-append, so pull before writing.

## Read this first, so you do not redo it

FightCamp already surveyed part of this on 2026-09-03/04. **Read these before
opening a single game** and say in your report what you set aside as already
known:

- `DesignLibrary/teardowns/mma_arena.md`
- `DesignLibrary/teardowns/mma_empire.md`
- `DesignLibrary/teardowns/rune_coliseum.md`
- `DesignLibrary/teardowns/second_pass_2026-09-04.md`
- `research/REFERENCE_SURVEY_2026-09-03.html`
- `research/C17_FIGHT_SCENE.md` (your own; the gates and the ledger)
- `research/K19_DIGEST.md` (Kalli's read of how the scene must read)

Where a teardown exists, do not restate it. Go deeper on the one thing this
survey is for — **how the fight resolves and where the player touches it** —
or say plainly that the existing teardown already covers it.

## The list

### A. Named by the operator

| Game | Where |
|---|---|
| Pound for Pound | `E:\SteamLibrary\steamapps\common\Pound for Pound Demo` — INSTALLED |
| MMA Arena | `E:\SteamLibrary\steamapps\common\MMA Arena` — INSTALLED, teardown exists |
| Motorsport Manager | `E:\SteamLibrary\steamapps\common\Motorsport Manager` — INSTALLED |
| Elite MMA Manager | not installed — public sources |
| Tennis Elbow Manager | not installed — public sources |
| Boxing School | not installed — public sources |

### B. Five most successful auto-battlers

Pick on real success (revenue, concurrents, longevity), name the measure, and
say where the number came from.

### C. Five most successful deckbuilders

Same rule.

### D. Five most successful games that fuse the two

Deckbuilding + auto-battle in one loop.

### E. Five most successful management games

Any sport or domain. Football Manager is the obvious anchor; do not stop there.

### F. Already on this machine and directly on point — do not miss these

The operator's list did not name them because nobody had looked. They are
installed and they are the closest things to FightCamp's actual question:

| Game | Why it matters here |
|---|---|
| `Punch Club 2 Fast Forward Demo` | boxing management where the FIGHT auto-resolves and the player's leverage is everything before it — the exact shape of our question |
| `足球经理：自走棋 Demo` ("Football Manager: Auto Chess") | a management sim fused with an auto-battler; bucket D, already installed |
| `KungFuCard` | fighting resolved through cards; bucket D, already installed |
| `The King is Watching` | watch-and-intervene as the core verb |
| `Corner King` | boxing corner-work; teardown exists, revisit only for the intervention seam |
| `Master of Command`, `Football Manager 2020`, `Your Football Life` | bucket E candidates already to hand |

Where a game is installed, **run it** and report what you saw. Where it is
not, use public sources and mark every claim as second-hand. Never present a
read of a store page as a read of the game.

## What each game must return

Keep it to one bounded row per game — this is a wide survey, not 27 teardowns.
Depth is reserved for section F and the operator's named six.

For each: **how the fight/match resolves** (real-time, tick, instant, card),
**where the player touches it** (before only / during / both, and through
what), **what the player is looking at while it resolves**, **whether the
outcome is deterministic and seeded**, and **the one thing worth stealing**.

## What the survey must conclude

1. **A market table** in C17's style, across every bucket.
2. **The fusion read** — for the games in D, what actually makes a deck plus an
   auto-battle feel like one game rather than two systems bolted together.
3. **The recommendation**: what FightCamp's live fight should BE, mechanically,
   given the coach-watches-and-interrupts fantasy. Argue it against the two
   nearest alternatives you rejected.
4. **A short section that maps the recommendation back onto C17's three gates**
   — say which way each gate would fall if the recommendation is taken, and
   which gates the survey does NOT settle. Do not answer them; frame them.
5. **What we already do better**, if anything. Be honest either way.

## Standing rules that apply

- The facility is a "gym", never a "camp".
- Females never fight males; booking matches weight classes.
- Assets ripped from other games stay in the scratchpad and never ship. You
  may describe and measure; you may not copy art into the repo.
- Screenshots you take for your own reading stay out of the commit unless they
  are your own capture of a game you ran, in `research/`.

## Owned files

- `research/C18_GAME_SURVEY.md` — NEW, the survey
- `research/C18_DIGEST.md` — NEW, short

Touch nothing else. No `HANDOFF.md` block.

## Parse gate

None: this task writes no `.gd`.

## Test command

None. Push the two deliverables and report; Claude writes the HANDOFF block
and re-runs nothing, because nothing in the engine changed.
