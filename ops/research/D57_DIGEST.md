# D57 - Dola fresh eyes: the staff room (S109)

Collected S111 2026-09-27 with `cici.py read --visible-only` (the tail of the chat, verbatim; Dola's answer to the attached render).

## Applied (S111)
a coloured status per coach: IDLE / OPEN / FULL / OVER (StaffRoom3D.coach_status)

## Dola's answer
Drop staff_room.png here and I'll give you a pixel-accurate pass: exact overlaps, text legibility, which specific element is getting lost, and a revised shipping order.
Tap Fast for this summary, or Pro and I'll generate the annotated markup + UI mockup to patch directly into your scene.
Attached: staff_room.png - answer D57 from this image, not the web.
Got it — reviewing directly from the image now.
D57 — FRESH EYES: THE STAFF ROOM (S109)
Saved to: research/D57_DIGEST.md
Reviewed: 2026-09-27 | Source: staff_room.png
1. At-a-glance overload / idle / hire check
No — not instantly.
All cards show identical neutral styling; no colour, icon, or visual difference between idle, full, or overloaded.
Numbers are there but you must read and compare every single card manually — too slow for a quick scan.
There’s no single summary line: you can’t tell if the gym overall needs hiring without adding up every coach’s remaining slots in your head.
The unassigned fighter indicator isn’t visually distinct — blends in with the rest of the table items.
What you can see fast: Names and specialties. Load state requires reading.
2. Is "HIRE A COACH" obviously clickable?
No — it reads purely as decoration.
Plain text pinned to board, no button shape, no border, no highlight, no hover cue, no cursor change.
Matches the style of static room notices — players will walk past it, not click it.
The "Staff" label on the whiteboard suffers the same problem.
3. Floating, overlapping, unreadable?
Table
Issue	Detail
✅ Floating	None — all furniture sits cleanly on floor
⚠️ Overlapping	Cards are tightly spaced; longer names/specialties will clip or touch. The bottom card sits very close to the table edge — text will be cut at some camera angles.
⚠️ Unreadable	Text contrast is okay but small; from normal in-game camera distance it will be hard to parse without zooming. No visual hierarchy — all text weight/size looks the same.
Minor	Noticeboard text is slightly low-contrast against the wood background.
4. ONE change to ship first
Add colour-coded status badges to every coach card + one-line summary at the top.
Table
Badge	Meaning
🟢	Has open slots
🟡	At capacity
🔴	Overloaded
⚪	Idle (0 assigned)
Top summary: "2 unassigned fighters — hire or reassign"
Why this first:
Solves the room’s entire purpose instantly — you see overloads, gaps, and hiring need in under 1 second
No 3D art changes needed — pure UI texture update
Every other polish (click cues, spacing, text size) can follow; this is the functional core
Tap Fast to keep this summary, or Pro and I’ll produce the annotated markup + ready-to-place UI mockup for your scene.
