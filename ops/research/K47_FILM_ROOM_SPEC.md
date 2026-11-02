# K47 - THE FILM ROOM (scouting), buildable spec - Kalli (Grok bot), delivered S132 2026-09-30

Brief: research/TASK_K47_FILM_ROOM_DESIGN.md. Concept images (captured from the chat, 1024x577):
previews/concepts/room_film_k47_a.png (three-quarter cut-away, in use) and room_film_k47_b.png (whiteboard,
screen and laptop close-up). Collected by Claude S132; the spec below is Kalli's text, unedited. Next: a shell-agent build
task (FilmRoom3D) once the scouting file screen is on the demo path.

K47 - The film room, buildable spec

The concept images are generated. The text drawn on the board, screen and binders is illustrative only. Where an image and this spec differ, the spec wins. The image puts the window on the left wall and uses invented binder names, so the real names come from the roster.

1. Floor plan

Room 7 m wide (x) by 5 m deep (z), wall height 3 m. Origin is the back-left corner, x runs right, z runs toward the camera. The camera looks in from the front-right, and the front and right walls are cut away.

The door is in the left wall at z 1.0 to 2.0, 1.0 m wide by 2.1 m high, opening outward.
The window is in the back wall at x 0.9 to 2.0, sill at 1.1 m, top at 2.3 m.
The screen wall is the back wall, and the sofa faces it from about 3 m away.

2. Props (position is the object's centre, in metres)

Prop	Size (w x d x h)	At (x, z)	Material	Build
Projector screen	2.4 x 0.05 x 1.35, bottom edge at 1.0	3.5, 0.05	white matte, thin black frame	kit TV or screen, live render texture
Projector on stand	0.5 x 0.4 x 0.5	3.5, 0.6	matte black	kit boxes
Sofa, 3 seat	2.2 x 0.9 x 0.85	3.5, 3.55, faces back	black leather #1C1C1E	kit sofa
Coffee table	1.1 x 0.55 x 0.4	3.5, 2.5	walnut #5D4037	kit table, plus bottle and 2 notebooks
Rug	3.0 x 2.0	3.5, 2.7	dark slate, thin brass border	kit rug
Mobile whiteboard	board 1.5 x 1.0 on 1.9 m frame	0.45, 3.1, angled 15 degrees toward the sofa	white, grey frame, wheels	custom frame from boxes, data texture on the board
Wall clock, two framed photos	0.3 dia, two 0.5 x 0.7	left wall, z 3.1 (clock at h 2.5), photos at z 2.2 and 4.0 (h 1.7)	black frames	kit decor
Industrial shelf, 4 tiers	1.2 x 0.4 x 2.2	6.8, 1.2	black metal, walnut tier edges	kit shelves, binder spines from an atlas
Built-in desk	1.6 x 0.7 x 0.75	6.65, 2.7	walnut top, black drawers	kit desk
Laptop	0.33 x 0.23 x 0.02	6.6, 2.4, angled to the room	grey	kit laptop, render texture for the timeline
Tape boxes (3 stacks) and folder stack	0.3 x 0.2 x 0.25 each	on the desk, z 2.9 to 3.3	black cardboard	kit boxes
Plant	0.5 dia x 1.6	0.45, 0.45	green	kit plant
Downlights (3)	n/a	ceiling, x 2, 3.5, 5 at z 2.5	warm white	Godot lights

Everything is kit furniture. The only custom parts are the whiteboard frame and its data texture, the screen and laptop render textures, and the binder spine atlas. All other props are plain boxes.

3. People

The coach stands at (4.7, 1.6) in a black tracksuit and cap, facing the screen and holding a red laser pointer. He pauses the fight and points at one movement.
Fighter one sits at (3.0, 3.5) and fighter two at (4.0, 3.5). Both lean forward and write in notebooks.
These use the existing rigs. They loop idle, note-taking and pointing clips, and the coach's laser dot is a small red sprite on the screen.

4. Clickable objects

The screen opens the opponent's fight footage.
The whiteboard opens his tendencies: jab share, favourite punch and stamina fade.
The folder stack on the desk opens his record.
The laptop opens the game plan.
Optional fifth: the binder shelf opens the list of other scouted fighters. It is the cheapest way to switch target.

Hover draws a thin brass outline and a label of at most 14 characters. This is the only gold in the frame.

5. Lighting and mood
Daytime-bright ambient from the window plus the downlights, so the room never reads as abandoned. The screen is the brightest object and casts a cool glow on the sofa and table. The wall is mid slate rather than near-black. The reference image is too dark for this game's rule, so I lifted it.

Palette: slate wall #2F353B, floor #24282C, walnut #5D4037, screen glow #DCEBFF, laser red #E03A2F. The brass accent from the game's look, #B8893B, is only for the hover outline.
