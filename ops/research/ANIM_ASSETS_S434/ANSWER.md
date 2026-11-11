# Boxing packs and wrestling - the answer (S434)

## 1. Fab "Boxing Animation Pack" (67 moves)
The YouTube preview is private, so I watched all 67 moves in the listing's own 3D viewer instead.
- **Is it good?** Yes. It is real motion capture of one actor, with real weight. Single moves start and end in the same guard, so they join cleanly. Body shots drop the body, and hooks turn the hips.
- **What it adds:** a body version of every punch (we have only two body shots), 8 parries (we have none), 5 guard styles so fighters stop looking alike, head-movement idles against the "statue" look, and feints. Its slips stay facing the opponent (ours turn the back).
- **What it lacks:** hit reactions, blocks, knockdowns, knockouts, clinch, tired idles. Our current pack keeps all of those.
- **Watch-outs:** on rear-hand power shots the back foot almost leaves the canvas, and mixing a third stance family with ours needs care.
- **Licence:** fine for a Godot game sold on Steam. We can change the moves and fit them to our fighters. We may not resell the files. We keep them in the private repo only, never in the public mirror, and never feed them to AI tools.
- **My advice:** buy the Personal licence, EUR 69.23 with VAT (for studios under $100k a year). Parries, body shots and guard styles are things we cannot get free. Your call.

## 2. Unity "Punch Perfect" (EUR 55.16)
It is mostly a Unity coding kit, and I could not see its move list. Also, every person who uses it needs a licence. Skip it.

## 3. Wrestling
**Where the moves come from (best 3):**
1. **GrappleMap.** Free and public domain, and we already have it. It has hundreds of standing moves (single and double legs, arm drags, trips, sprawls), and Ana's BJJ already plays it.
2. **Mixamo double-leg and shoulder-throw pairs.** Free, and already downloaded. Good for the weight of the fall.
3. **RTK Motion.** Real two-person BJJ capture, $99 a capture. Allowed inside a game, but one line about putting it on our fighters needs checking first.

The paid "wrestling" packs on sale are pro-wrestling slams. Skip them.

**How we build it:**
1. One shared format for any two-person move.
2. Contact points on each body (neck, wrists, waist, knees).
3. Hands that grip and stay on those points.
4. One clock that moves both fighters together.
5. Ana's matches start standing, and a takedown lands in her BJJ ground game.
6. Later, the boxing clinch uses the same system.

**Cost:** Qwen does steps 1-2 and the data. Cursor does steps 3-5. Claude checks the stills. My estimate is about one step per session, so roughly 2-3 weeks beside other work. Step 6 waits until the current fight-animation fix lands.

**Your two calls:** buy one RTK capture ($99) once its licence is read? Should wrestling be its own sport on the roster, or only Ana's standing phase?
