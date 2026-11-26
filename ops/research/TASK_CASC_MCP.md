# TASK CASC_MCP - Cascadeur 2026.3 by instruction: missing takes for Puncher's chance (S566)

Kind: build (tool check + one take). Model: claude-opus-5-5. Discipline: boxing first, kickboxing second.
Seat: console worker (read ops/research/WORKER_S566.md first). Estimate: 3-5 hours. NOT STARTED: waits for the owner (below).

## Where it comes from
Owner S566, forwarding Cascadeur's 2026.3 mail (26 Nov 2026: "expands MCP and Python API workflows ... Connect external AI
assistants such as Claude Code to Cascadeur through MCP") and a note he pasted ("author/retime FightCamp strike, block,
stagger and KO clips by instruction instead of hand-keying, export glTF into Godot"); then: "you do the rest", and "should
we wait or work on 3d at the same time at punchers chance ? we could use the 3d fight on it too".
The note's spec file never existed in the repo; this brief is it. Its paths (Godot/research, HANDOFF.md) are the old repo's.

## Decided (Claude, S566)
- SCOPE: takes that Puncher's chance is MISSING, authored in Cascadeur and rendered to its pictures by the tools we have
  (tools/pics2d_*.gd render our 3D clips; the page's pictures ARE the 3D fight seen by his camera). One take helps both
  games. NOT in scope: the realtime 3D fight's code (METHOD: no new layer in scripts/fight3d until FIGHTPLAYER2), MetaHuman
  faces, Unreal Live Link, AI Cloud (credits, provenance unknown).
- NO NEW BRIDGE FIRST. We already drive Cascadeur's script server (127.0.0.1:8765) without a click: `ops/Tools/cascadeur/`
  (ensure_server.py --hidden, csend.py, README.md, built on 2026.2). A console worker calls csend.py from its shell, which
  is all an MCP bridge would give it. Write a stdio MCP wrapper (about 100 lines around csend.py) ONLY if step 3 finds
  something 2026.3 offers through MCP that the script server does not.

## Waits for the owner
1. MONEY: a paid plan. Cascadeur's plans page (read 26 Nov 2026): Free = non-commercial, exports .casc ONLY (no FBX, no
   glTF), 300 frames / 120 joints; Indie = revenue under $100k a year, exports FBX / glTF; Pro = no limits. The page does
   not say which plan carries scripting or MCP: step 2 finds out. 40% off the first year of an annual plan until 7 Dec.
2. HIS CLICK: update the installed Cascadeur 2026.2.3 (C:\Program Files\Cascadeur) to 2026.3.

## State after S566 (2026-11-26, read before step 1)
- INSTALLED: Cascadeur 2026.3.0.17632 (the owner asked; licence accepted on his word; installer from cascadeur.com, Nekki
  signature valid, kept at E:\FightCamp\dl\cascadeur_2026_3\Cascadeur_2026.3.exe; NSIS, `/S` installs silently, his UAC click).
- OUR CHANNEL WORKS ON 2026.3: `ensure_server.py --hidden` came up on the hidden desktop; `/health` answered
  `"server_version": "0.4.0", "version": "2026.3"`.
- ONE BREAK TO FIX FIRST: `csend.py -c "print(...)"` returned rc 0 and printed NOTHING (on 2026.2 it printed the script's
  output). Find where 0.4.0 returns a script's output and fix csend.py.
- NO BRIDGE IS NEEDED: 2026.3 ships `resources/scripts/python/scripts/mcp/` with `mcp_clients.py` and `register_mcp.py`;
  the script server itself serves MCP over HTTP at `http://127.0.0.1:8765/mcp`. A Claude Code worker can be pointed at
  that URL directly. Read `script_server/README.md` and `docs/` there before writing anything.
- STILL WAITS FOR THE OWNER: the paid plan (he said "not now i will do it tomorrow"). On Free nothing can be exported.
- THE FIRST TAKE IS THE OVERHAND: KDPIC1 found none in our files and none in 12 Ludo candidates.

## Do
1. `python ops/Tools/cascadeur/ensure_server.py --hidden`, `/health`, one csend round trip. If 2026.3 broke the channel:
   fix OUR tools (the README's two traps first), write what changed in the README.
2. What the plan allows: export one 10-frame clip as glTF and as FBX; run one script. Write the exact refusals, if any.
3. Read the 2026.3 release notes and Python API pages for what is NEW (commands, MCP tools). List them in the result with
   one line each on whether we would use it. Decide the bridge question from this list.
4. THE FIRST TAKE: the one KDPIC1 could not get (docs/KDPIC1_RESULT.md says which: the overhand unless Ludo delivered it;
   else the first missing kick take). Author it by script from our own guard pose on our rig (animsource1/ is the pipeline),
   AutoPhysics on, export glTF.
5. Measure it like every take and add ONE row to assets/data/clip_db.json (never rebuild it whole): contact frame, glove
   height at contact, head travel, the flags. Numbers beside the reference clip's (name the study and clip: memory S537
   "animations from our research + clips").
6. Render it with the picture tools at each range the page plays it, masks on, south=blue, his camera; edge table (no jump
   over 8 px); beat_shot on the page: landed, blocked, missed.
7. Result: docs/CASC_MCP_RESULT.md - what works on 2026.3, what the plan allows, minutes per take by instruction against
   by hand, the stills, and a verdict in three plain lines: keep paying or not.

## VISUAL GATE
Red first: the page plays the rear hook for the overhand today (beat_shot prints the run names). Stills only through the
picture tools on the hidden desktop, both men head to feet in frame, his camera. Per still: gap, noses, wrists, feet. A
bend of 0.04 s or 7 degrees is invisible: bars are read on the pictures he sees. The owner closes it.

## Not allowed
Nothing opens on his monitors (hidden desktop only). No file from Cascadeur's sample scenes ships (terms not public: the
clinch clips are already flagged). One windowed render at a time; watchdog before each.

## Contract
- OWNS: ops/Tools/cascadeur/README.md, ops/Tools/cascadeur/ensure_server.py, ops/Tools/cascadeur/csend.py,
  docs/CASC_MCP_RESULT.md (the take's own files are named in the result)
- RED_TEST: beat_shot on order.html, an overhand landed at Mid: the pictures played are the rear hook's
- REGRESSION: page_parse, page_play_test order.html, anim_check.mjs
- VISUAL: yes (the gate above)

## Prior research
ops/Tools/cascadeur/README.md, ops/research/ANIMSOURCE1A_DIGEST.md, S537 CASCTEST1 (AutoPhysics on the plain cross added no
drive: knee +11 -> +10 degrees, hips 3 cm), ops/research/TASK_KDPIC1.md, the clip licence list (Cascadeur sample terms).

## What would a human do?
An animator blocks the key poses from reference, lets the physics tool clean the arcs, and checks the contact frame against
film before polishing anything.

## Prefab check
Our archives and Ludo come first for a missing take (KDPIC1 does that); this stage is for the takes they cannot give.
