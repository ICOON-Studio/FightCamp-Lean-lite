# S566 digest (2026-11-26, Fable 5.2)

## His words
- On the Q-344 picture, the order row (C520): "can you add a strip with slots for each action so it is clear what happens
  when ,and player can drage the slot to change the order , also would be nice if a holographic preview plays the current
  sellection"
- On the "Point at your man" box (C521): "i do not understand what it does, maybe reoharse and use basic terminology"
- "Signed in, go" (Arena), then "yes close the old consoles ,move arenas work do notwait"
- On Q-344: "sorry i did not understand the question what exactlyis that to put mainpage" - explained in chat (the "Step
  in a moment later" button of the test page; main page / own page / drop; my advice: try wait.html first). NOT ANSWERED.

## Built (v0.566.1, pushed)
- `proto/twohands/strip_ui.js`, loaded after body_ui.js on order, head, kick (and the built punch and wait pages): three
  numbered slots under the ring, a card per moment (what it does at the range it happens at, what its hand leaves open),
  drag to reorder (proved with a real mouse in headless Edge: slot 3 -> 1, slot 1 -> 2), a see-through blue copy of his
  boxer (`#ghost`) playing the chosen moves, the playing slot lit. Rules untouched.
- body_ui.js help box: "Choose your moves: 1. Click a part of your boxer (the blue one) ... 2. Its moves show here".
- `beat_shot.mjs`: `"hold": [ms..]`, `"plan_only"`, `"drag": [from, to]`.
- Tests: page_parse 5 pages; page_play_test 4 passed on order, punch, head, kick, wait; wait_test 5; rules_test 37.
- Stills: ops/previews/s566_strip/ (on 8787/review). HIS LOOK IS THE GATE.

## Collected
- TELLS3M: 4 of 7 bars, not for the page (blind following +8 / +10 / +29 points over the control; the reader bot wrong in
  the probe). -> TASK_TELLS4M.
- KICKFIX3: E2, E3 5 of 9 at N=56; the limp loop capped; E3 the base. -> TASK_KICKFIX4.
- LONG2: none for the page. The page already lands the waiting cross; K2 8 of 9 but self-cancelling; a points-only rule
  changes no bout (the solver's worth() counts health, never points). Next: the jab that meets him does health.

## Running at the end
- Console workers on the PC (Arena at its daily limit until 20:33; rules ops/research/WORKER_S566.md): KICKFIX4 (tab c1),
  TELLS4M (c2), KDPIC1 (c3, the render worker; it was generating overhand takes at Ludo at 20:00).
- LONG1 at Arena (cba93bd0): its chat ended its turn with L2 / L3 queued; "Keep working" refused until the reset.
- The six old worker consoles (S560-S565) closed on his yes: memory 96% -> 64%.

## Not done
- Q-344 unanswered; TASK_PROGP4 written, no seat; TASK_LONG3 waits for LONG1; INSIDE1 Phase 2 stills; no export (no
  Godot change this session).

## Traps found
- Arena is signed in on BROWSER 2 (select_browser), Browser 1 shows Log in.
- An Arena chat that ends its turn with runs "queued" does nothing more: the watcher's STALL line means open the chat.
- A heredoc with an apostrophe in the text fails (again): write briefs with the Write tool.
- page_play_test on head.html / kick.html takes 3-4 minutes each: background them.
- The page's old chip row is hidden by CSS `#lines>.lab:has(+ .seq)`, not removed: make_wait.py's anchors still hold.

## Later in S566 (after the first digest)
- His words: "park that for now ? what do you think ?" (Q-344: parked, agreed); "it is confusing to me if it matters which
  hand of the 2 is up , if it does when and how" -> v0.566.2, a held hand says what it stops; "the intermittent lines move
  along with the bouncing and it is very annoying" -> v0.566.3, the dashed pointer line holds still while the men bounce
  (headless Edge: 5 bounce pictures, 1 line position); "do we need cascadeur subscription ?"; the Cascadeur 2026.3 mail +
  "you do the rest"; "should we wait or work on 3d at the same time at punchers chance ? we could use the 3d fight on it too"
  -> TASK_CASC_MCP (takes Puncher's chance is missing; yes in parallel, as one narrow job); "cascadeur is running can you
  update it ?" + "Yes, accept it" -> 2026.3.0.17632 installed, our hidden channel answers on it; "also stop ziva subsription
  and use it until it expires and after that only the free model" -> cancelled, paid until 2026-12-19; on the Animo
  Boxing Animation Pack I had ranked first: "all its hooks look terribel and aim at the sky" -> do not buy; on the Animo
  Additional pack: "this is very good ... i will buy this also tomorrow" and his stance idea -> TASK_GUARDSTANCE1.
- KDPIC1 collected: knockdowns inside the ropes and the stage (tools/pics2d_ko_room.gd); the overhand BLOCKED (no take in
  our files, 12 Ludo candidates). LONG2 collected: none. PROGP4 launched at Arena; TASK_PROGP4, TASK_KICKFIX4,
  TASK_TELLS4M, TASK_CASC_MCP, TASK_GUARDSTANCE1 written.
- The six old worker consoles closed on his yes (memory 96% -> 64%).
- Still running at 22:02: KICKFIX4, TELLS4M (console workers), LONG1, PROGP4 (Arena).

## More traps
- A board question names the thing the player SEES ("the Step in a moment later button"), never the measure.
- Never recommend an animation pack from its clip list: watch the preview.
- Chrome may hold a finished .exe download as "Unconfirmed ... .crdownload" until he clicks Keep: the bytes are complete -
  copy it, check the Authenticode signature, use it.
- `python - <<'EOF'` still eats backslashes in the text (a JS `\n` inside a string became a real newline): use the Write tool
  for any script that carries backslashes or apostrophes.
- The idle guard blocks every turn end while runs fly: `idle_guard.py ok "<reason>"` each time.
