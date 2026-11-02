# TASK U23 — CURSOR — WHAT A REAL FIGHTING GAME MODELS, AND WHAT IT REFUSES TO

Model: Composer (its quota is the one with headroom), medium effort. Owner:
Cursor. Deliverable: ONE new file,
`research/U23_FIGHTING_GAME_TEARDOWN.md`, pushed on your usual branch.
**No engine code.** Nothing in `Godot/scripts/` or `Godot/tests/` is touched.

---

## Why

R82–R84 turned FightCamp's bout into a real-time tick engine: 20 Hz, integer
ticks, impacts with force/contact/region, shock, knockdown, stoppage. We have
now built a real-time fighting engine without ever having studied one.

The blind spots we already know about, from `R84_DIGEST.md`:

* **There is no hit reaction and no recovery state.** A man who has just been
  cracked is, on the very next tick, exactly as capable as before. There is no
  stun, no stagger, no window where he is in trouble.
* **A knockdown is instantaneous.** He goes down and is up in the same tick;
  nothing models the count as time.
* **Nothing a fighter does has a commitment cost.** Every tick is independent —
  no recovery frames, so no punch can ever be punished.

## THE SOURCE

**TEKKEN 7** is installed:

```
D:/SteamLibrary/steamapps/common/TEKKEN 7/
    TEKKEN 7.exe                                  (270 KB launcher)
    TekkenGame/Content/Paks/                      (~55 GB, five .pak files)
    TekkenGame/Content/Binary/tkdata.bin          (290 MB)
```

**SCOPE HONESTLY, AND THIS IS THE MAIN INSTRUCTION.** The `.pak` files are UE4
archives totalling 55 GB. **Do not attempt to unpack them.** It needs a
specific UE4 pak tool and an AES key, it would take hours, and the payoff is
character meshes we cannot use and must never ship (the standing rule: ripped
art never ships, and this task produces no assets at all).

`tkdata.bin` (290 MB) is the move/parameter blob. You may inspect its structure
cheaply — magic bytes, obvious string tables, whether move names are
recoverable — and **timebox that to one pass**. If it is opaque, write one line
saying it is opaque and move on. That is a perfectly good finding and far more
useful than a day of hex.

**The real deliverable is the MODEL, not the files**, and Tekken's model is
publicly and thoroughly documented — frame data, startup/active/recovery,
block/hit stun, counter-hit, wall splat, juggle state, throw break windows. Use
the installed game to check claims and to see the thing move; use the
documented model as the substance.

## The questions to answer

1. **The state machine.** What states can a Tekken fighter be in that a
   FightCamp fighter cannot? Name them and say, for each, whether it is
   meaningful in a *watched, non-player-controlled* bout. Some will not be —
   we will never have blocking on input — and saying so is half the answer.
2. **Startup / active / recovery.** Every action costs commitment time. What
   would the cheapest honest version of that be on a 20 Hz tick engine where
   nobody presses a button? Our impact subsystem currently runs every 2 ticks
   and each attempt is independent of the last.
3. **Hit reaction and stun.** How long is a fighter compromised after being
   caught, and how does that scale with how flush the shot was? We have `force`
   0.0–1.0 and a `shocked` flag that currently changes nothing about the next
   tick. This is the single most likely thing to be worth stealing.
4. **THE FATIGUE QUESTION, and it is the reason this task is scheduled now.**
   Tekken has **no stamina system at all** — a round-three fighter is as fresh
   as a round-one fighter. Confirm that, then answer the interesting half: *why
   is that right for Tekken and wrong for us?* Then survey what fighting games
   WITH a fatigue model do — the boxing sims (Fight Night's stamina and its
   recoverable/unrecoverable split is the landmark; also Undisputed, EA UFC's
   three-stage stamina) — and say which of them models fatigue degrading
   *accuracy and defence* rather than just output. Cite what you can verify.
5. **Positioning.** Tekken has walls, ring-outs and sidestep. We have
   `RingSpace` with CENTRE / ROPES / CORNER off a real position. What does
   Tekken get out of the wall that we are not getting out of the corner?

## The shape of the deliverable

Short, and organised by the five questions. End with **"What FightCamp should
take, and what it should refuse"** — at most five recommendations, one sentence
each, each marked `TAKE` or `REFUSE`. **REFUSE entries are as valuable as TAKE
entries**; a teardown that recommends importing everything has not been
thought about. Anything you propose must survive the fact that the player never
presses a button during a bout — he coaches.

Label every claim as `verified locally`, `documented`, or `impression`.

## Owned files

| File | Note |
| --- | --- |
| `research/U23_FIGHTING_GAME_TEARDOWN.md` | **Yours. New. The only file you create.** |

Read-only, and only these: `research/R84_DIGEST.md` (short),
`Godot/scripts/RingSpace.gd` (small, read whole), and the tick loop of
`Godot/scripts/FightRealtime.gd` — `sed -n '168,240p'`, that window only. The
file is 909 lines; **do not open it whole.**

**Do not read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any
other digest, or `GameState.gd` (12,900+ lines). Do not explore to get
oriented.

## No parse gate, no test, no assets

One markdown file, no GDScript. Do not run the suite. Do not edit `HANDOFF.md`.
**Do not extract, copy or commit a single art or audio asset from Tekken** —
ripped assets never ship and must not even enter the repo.

## The trap specific to this task

**The gravitational pull of this task is to spend it all on the 55 GB of
paks.** That is the one activity guaranteed to produce nothing we can use. If
you have spent more than one pass on file formats, stop and write the model up
from documentation. The question we need answered is "what should a hit do to
the next two seconds of a fight", and no amount of unpacking answers it.

## When you are done

```
python Tools/agent_comms.py send --from cursor --to claude --topic u23-done --body "<one line: the branch, and your single strongest TAKE and strongest REFUSE>"
```

Push on your branch as usual and name it in the message — master is not
expected.
