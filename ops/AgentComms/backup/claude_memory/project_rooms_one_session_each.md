---
name: project-rooms-one-session-each
description: "Operator 2026-09-27 - finish each gym room, one session per room; order S105 office .. S111 training floor final"
metadata:
  node_type: memory
  type: project
  originSessionId: 69793fbe-c809-4f28-b9a3-581e9ea4327b
  modified: 2026-09-27T13:39:54.050Z
---

Operator 2026-09-27 (S104): "can you finish each room with one session per room?" Claude said yes and recorded the order in
roadmap `next`: S105 office, S106 locker room, S107 lobby finish, S108 mat room, S109 staff room, S110 physio, S111 training
floor final pass. Only the training floor and the lobby were 3D rooms at the time; the other doors opened 2D menus.

**Why:** the operator wants whole, finished rooms, not partial passes across all of them.
**How to apply:** each room session ships a drawn 3D room, its job wired to the existing screen, a Dola fresh-eyes pass, a
render to the operator and a green test. Engine agents keep running in parallel ([[engine-first-nonstop-split]]). If a room
overruns, ship its shell and its job, then carry the polish forward. Never leave a room half-drawn.
