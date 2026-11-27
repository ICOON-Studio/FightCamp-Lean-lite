// RINGUI1 (S559): two things the owner asked for, on top of the page (the rules are not touched):
// 1. "can you make those ranges geometrically correct in comparison to the ground distance and display that to the player
//    with visual effect": the range strip's three equal pills are replaced by plates ON THE FLOOR between the men's front
//    feet, each as long as the real gap at that range. Measured on the pictures (S559, img/anim/blue_both_high_high*_6):
//    the front toes stand 113 px apart at Long, 46 at Mid and meet Inside, in the 480 px picture; a range step is the step
//    take's 0.355 m and closes 67 px, so 189 px a metre. The plate of the range they are at glows; hover a switch and the
//    plates it reaches light green, the others red. A range change flashes the new plate.
// 2. "make the commentators react to each beat": after every beat one of the three (our own crew on the desk picture:
//    Rita Vance calls it, Hank Brody explains it, Leo Marsh feels it) says one line about the beat's biggest moment, and
//    that commentator lights up on the desk.
(() => {
  const st = $('stage'), im = $('pic'), tell = document.querySelector('.tell');
  // ---- 0. RENDERFIT1 (S559): the owner's ring camera. Every picture is now in RING coordinates (one fixed camera,
  // tools/pics2d_camera.json), so a picture is drawn SLID along the red -> blue line by where the men really stand:
  // a hold, a guard or a blue run is made with red on his spot (blue stood in), so it slides by red's metres in;
  // a red run (his punch, his step) is made with blue on his spot, so it slides back by blue's metres in. The page keeps
  // the two counts (steps of 0.355 m) from the step runs it plays; red's + blue's = the range's (Long 0, Mid 1, Inside 2).
  // Without it a red step snapped a whole step (RINGCAM1: 87 px of the render, 54 of the page picture).
  // The ring itself (img/ring_bg.webp, tools/pics2d_ring_bg.gd: the same camera, 4 times as wide) does NOT slide.
  /* INSIDE1 (S562, owner: "the distance looks wrong to me btw"): the slide is in METRES, not steps - Inside is no longer
     two step takes in. RANGE_M = the picture tools' one table (tools/pics2d_anim.gd RANGE_LONG_M / RANGE_MID_M /
     RANGE_INSIDE_M): keep the two the same. redM / blueM are each man's metres in from his spot; a step moves the
     stepper by the gap between the two ranges, as the step runs are made (pics2d_anim_more.gd _step_run). */
  const RANGE_M = { 3: 0, 2: 0.355, 1: 0.55 };   /* INSIDE1 S564: Inside 0.55 m in (was 0.71) */
  const STEP_M = 0.355; let CAM = null, redIn = 0, blueIn = 0, redM = 0, blueM = 0, SX = 0, SY = 0;
  fetch('img/anim/frames.json').then((r) => r.json()).then((j) => { CAM = j.camera || null; slide(); }).catch(() => {});
  const css = document.createElement('style');
  css.textContent = '.stage{background:#0f1013}.stage:before,.stage:after{display:none}.stage img#ringbg{z-index:0;filter:none;pointer-events:none}';
  document.head.appendChild(css);
  const bg = document.createElement('img'); bg.id = 'ringbg'; bg.alt = ''; bg.src = 'img/ring_bg.webp'; st.insertBefore(bg, st.firstChild);
  const metresOf = (src) => { const f = (src || '').split('/').pop(); return /^red_/.test(f) ? -blueM : redM; };
  const rOf = (n) => Math.max(1, Math.min(3, 3 - n)), mOf = (n) => RANGE_M[rOf(n)] + (n < 0 ? n * STEP_M : 0);   /* the range of a step count; past Long (the ropes) a step back is a step take */
  function slide() { if (!CAM || !CAM.axis_px) { SX = SY = 0; im.style.translate = ''; return; }
    const k = st.clientHeight * 1.26 / (CAM.render_px || 768), m = metresOf(im.getAttribute('src'));
    SX = -m * CAM.axis_px[0] * k; SY = m * CAM.axis_px[1] * k;   /* the picture is drawn mirrored: its +x is the screen's -x */
    im.style.translate = SX || SY ? `${SX.toFixed(1)}px ${SY.toFixed(1)}px` : ''; }
  const holdSlide = () => { if (!CAM || !CAM.axis_px) return [0, 0]; const k = st.clientHeight * 1.26 / (CAM.render_px || 768), m = redM; return [-m * CAM.axis_px[0] * k, m * CAM.axis_px[1] * k]; };
  new MutationObserver(slide).observe(im, { attributes: true, attributeFilter: ['src'] });   /* runs before the frame is painted */
  const fit = () => { const t = 3 - (range || 3); redIn = Math.max(-2, Math.min(2, redIn)); blueIn = t - redIn; blueM = RANGE_M[range || 3] - redM; };   /* the range is the truth: blue takes up what the counts (and the metres) missed */
  /* S562 GLIDE1 (owner: "the distance between fighters is not consistant when clips play, it gets reset when some clip
     animations play"): a punch run is made at each range it reaches (tools/pics2d_anim.gd range=: the puncher starts and
     ends on his spot at that range and steps into the punch between); the range the men stand at NOW is the counts'. A
     range with no run of its own (a punch thrown out of its reach) takes the nearest range that has one. */
  const atRange = (run) => { if (/^(red|blue)_feint$/.test(run || '')) { const r = 3 - (redIn + blueIn); return r < 3 && ANIM[`${run}_r${r}`] ? `${run}_r${r}` : run; }   /* the feint at each range too */
    const m = /^(red|blue)_(.+)_(landed|blocked|missed|slipped|rolled|leaned)$/.exec(run || ''); if (!m) return run;   /* GLIDE2: the head moves (pics2d_head.gd range=) and the kicks (pics2d_kick.gd range=) at each range too */
    const r = Math.max(1, Math.min(3, 3 - (redIn + blueIn))), name = (x) => (x === 3 ? run : `${run}_r${x}`);
    if (m[3] === 'missed') { const a = Object.values(ACT).find((x) => (x.run || x.pic) === m[2]), sh = `${m[1]}_${m[2]}_short` + (r === 3 ? '' : '_r' + r);   /* thrown from further than it reaches: it FALLS SHORT, he does not move into it */
      if (a && a.reach && r > Math.max(...a.reach) && ANIM[sh]) return sh;
      const g = 'blue_guard' + (r === 3 ? '' : '_r' + r);   /* GLIDE2: SMOTHERED (thrown from closer than it reaches, e.g. a kick Inside) with no run of this range: the men stand at the range (the guard run), never a run made a step away */
      if (a && a.reach && r < Math.min(...a.reach) && !(ANIM[name(r)] && ANIM[name(r)].range) && ANIM[g]) return g; }
    for (const x of [r, r === 1 ? 2 : r === 3 ? 2 : 1, r === 1 ? 3 : r === 3 ? 1 : 3]) if (ANIM[name(x)] && ANIM[name(x)].range) return name(x);
    return run; };
  const warm0 = warm; warm = function (runs) { return warm0(runs.flatMap((n) => { const s = n.replace(/_missed$/, '_short'), h = /_missed$/.test(n) ? ['slipped', 'rolled', 'leaned'].map((x) => n.replace(/_missed$/, '_' + x)) : [];   /* GLIDE2: a miss may be drawn as the head move that made it */
    return [n, n + '_r1', n + '_r2', ...(s !== n ? [s, s + '_r2'] : []), ...h.flatMap((x) => [x, x + '_r1', x + '_r2'])]; })); };   /* the page warms the runs a beat needs by their plain names */
  /* GLIDE2: the page's playRun (the same on order, punch, head and kick), with one change: a hold run (played while the
     player plans) STOPS when another run starts. It ran on after Go, so its pictures (the men at the hold's spots) were
     drawn between the beat's pictures - measured: blue_lead_high_r2_4 between blue_cross_slipped_0 and _1, 11-17 px apart. */
  let holdTok = 0;
  const run0 = function (run, big, onHit, done, cut) { const r = ANIM[run]; if (!ready(run)) return false;
    const mine = phase === 'plan' ? ++holdTok : (++holdTok, -1), c = r.contact, at = Math.max(c, 0); let i = 0;
    const show = () => { if (mine >= 0 && mine !== holdTok) return; if (cut && i === c) return done(); $('pic').src = PRE[r.files[i]].src; if (i === at) onHit(); if (i >= r.files.length - 1) return done();
      let wait = Math.min(MAX_GAP, (r.offs[i + 1] - r.offs[i]) * 1000); if (i === c) wait += HOLD; if (big && c - i >= 1 && c - i <= 3) wait *= BIG_SLOW; i++; setTimeout(show, wait / (typeof RATE === 'number' ? RATE : 1)); };   /* S567: the round replay runs faster (RATE, set by the page) */
    show(); return true; };
  playRun = function (run, big, onHit, done, cut) { run = atRange(run); bobTok++; const planHold = phase === 'plan' && isHold(run);   /* BOUNCE1: any run stops the bounce; a hold played in plan starts it when it settles */
    const tp = /^(red|blue)_teep_landed_r2$/.exec(run || '');   /* GLIDE2: a teep that lands at Mid pushes him one place back (kick.html), and its run ends with him there */
    const step = (red, d) => { const n = redIn + blueIn, dm = mOf(n + d) - mOf(n); if (red) { redIn += d; redM += dm; } else { blueIn += d; blueM += dm; } };   /* INSIDE1: the metres of the two ranges */
    const m = /^(red|blue)_(step_in|slip_in|back_off)/.exec(run || ''), move = () => { if (tp) step(tp[1] !== 'red', -1); if (!m) return; const d = m[2] !== 'back_off' ? 1 : -1;   /* HEADPICS1: a slip in is a step in */ step(m[1] === 'red', d); };
    const ok = run0(run, big, onHit, () => { move(); slide(); done(); if (planHold && phase === 'plan') bob(run); }, cut); if (!ok) move(); return ok; };
  /* BOUNCE1 (S565, owner's roadmap row "Never still: a light bounce between beats"): after the hold run settles while he
     plans, its _bob run loops (tools/pics2d_bob.gd: the hold's last picture, both men bouncing lightly on the spot, the
     feet on the hold's own spots; 5 pictures, BOB_S a cycle = pics2d_bob.gd BOB_CYCLE) until the beat is fought. Fight
     stops it at once and puts the hold's last picture back. No _bob run on disk: the still, as before. */
  const BOB_S = 0.5; let bobTok = 0, bobHold = '';
  const isHold = (run) => /^(red|blue)_(guard|lead_high|lead_low|rear_high|rear_low|both_(high|low)_(high|low))(_r[123])?$/.test(run || '');
  function bob(run) { const b = (run || '').replace(/(_r[123])?$/, '_bob$1'), mine = ++bobTok; bobHold = run; if (!ANIM[b]) return;
    let tries = 0; const start = () => { if (mine !== bobTok || phase !== 'plan') return; if (!ready(b)) { if (++tries < 20) setTimeout(start, 150); return; }   /* a picture still loading from an earlier warm: wait for it */
      const r = ANIM[b], n = r.files.length; let i = 0;
      const tick = () => { if (mine !== bobTok || phase !== 'plan') return; $('pic').src = PRE[r.files[i]].src;
        const w = (i + 1 < n ? r.offs[i + 1] - r.offs[i] : BOB_S - r.offs[i]) * 1000; i = (i + 1) % n; setTimeout(tick, w); };
      tick(); }; warm([b]).then(start); }
  const go0 = go; go = function () { const was = bobHold, h = ANIM[was]; bobTok++; bobHold = '';
    if (h && /_bob(_r[123])?_\d+\.webp/.test($('pic').src) && PRE[h.files[h.files.length - 1]]) $('pic').src = PRE[h.files[h.files.length - 1]].src;   /* the hold's last picture back: the beat's run starts from it */
    return go0(); };
  window.bobState = () => ({ tok: bobTok, hold: bobHold });   /* read by the browser check */
  const hit0 = hitAt; hitAt = function (run) { const a = hit0(atRange(run)); return a ? [a[0] + SX, a[1] + SY] : a; };   /* the burst sits on the slid glove */
  const setup0 = setup; setup = function () { redIn = blueIn = redM = blueM = 0; setup0(); slide(); };
  const bell0 = bell; bell = function () { redIn = blueIn = redM = blueM = 0; bell0(); slide(); };   /* a new round starts at Long, both on their spots */
  const plan0r = plan; plan = function () { fit(); plan0r(); slide(); };
  window.ringSpots = (v) => { if (!v) return [redIn, blueIn, redM, blueM]; [redIn, blueIn, redM, blueM] = v; slide(); };   /* S567: the round replay starts both men on their spots and puts them back where they stood */
  window.ringSlide = () => ({ redIn, blueIn, redM, blueM, range, sx: SX, sy: SY, pic: (im.getAttribute('src') || '').split('/').pop() });   // read by the browser check
  // ---- 1. the distance on the floor (S559 v2, owner on the nested plates: "idonot understand this ,it is not symmetrical"):
  // ONE bar between the two men's front toes at the range they are at, ticks at both toes, its length the real gap, the
  // label in words. A range change slides it and flashes. Hover a switch: green if it reaches at this range, red if not.
  // RENDERFIT1 (S559) re-measured on the owner's camera (raised 31 deg, 3.149 m wide; blue_both_high_high*_6, the lead
  // boots' inner ends): red's front toe stays at 231 (red on his spot), blue's comes in one step (0.355 m = 54 px) a range;
  // Inside the lead boots pass each other (they stand at different depths), so the gap is 0. 152.4 px a metre (the
  // camera's axis_px 243.85 of the 768 render). The front toes sit at y 318 (red's) and 331 (blue's): the bar at 324.
  const TOES = { 3: [231, 318], 2: [231, 264], 1: [231, 231] };   // [red front toe, blue front toe], x in the 480 px picture
  const PX_M = 152.4, FLOOR = 324 / 480;
  const ruler = document.createElement('div'); ruler.id = 'ruler'; st.appendChild(ruler);
  ruler.innerHTML = '<div class="gap"><i></i><i></i></div><div class="plabel"></div>';
  const X = (u) => st.clientWidth / 2 + (0.5 - u) * st.clientHeight * 1.26 + holdSlide()[0];   /* RENDERFIT1: u in square-picture widths from its middle (a wide picture has the same middle and scale); TOES are the hold pictures', so the bar takes the HOLD's slide (red's metres in) whatever picture is up */
  /* S562 (owner on the Inside bar, two ticks and 'INSIDE toe to toe': "wtf is this ? what is th eplayer supposed to
     understadn from this ?"): a distance in cm tells the player nothing. The label says what LANDS at the range he is at
     (this page's own ACT reach table, so the kick page lists its kicks), and Inside, where the boots meet, has no bar. */
  const short = (a) => (a.line === 'body' && a.h < 2 && !/jab/i.test(a.n) ? 'Body' : a.n.replace(/^(Lead|Rear) (.)/, (m, w, c) => c.toUpperCase()));
  const lands = (r) => [...new Set(Object.values(ACT).filter((a) => a.d && a.reach && a.reach.includes(r)).map(short))].join(' · ');
  let shown = 0, hoverReach = null, hoverName = '';
  /* S562 (owner on the label under the boots: "i told you do not put text or anything near the fighters"): no bar and no
     words on the floor. The range is ONE badge in the ring's empty top-left corner (where nothing stands): the range, what
     lands there; a hovered switch turns it green (reaches) or red (does not reach); a range change flashes it. */
  function place() { if (!st.clientHeight || !range) return; const gap = ruler.querySelector('.gap'), lab = ruler.querySelector('.plabel'); gap.style.display = 'none';
    const reach = hoverReach ? hoverReach.includes(range) : null; lab.className = 'plabel corner' + (reach === true ? ' ok' : reach === false ? ' no' : '');
    /* S568 CLARITY1 (Ludo S567, clarity 5: "the current range ... named large"): the range word is LARGE, on the same one
       line (a second line grew the badge into the blue man's gloves - nothing near the men; the step's new range is on its
       strip card already: "Step in Long -> Mid"). */
    lab.innerHTML = hoverReach ? `<b class="big">${RNG[range]}</b> ${hoverName} ${reach ? 'reaches' : '<u>does not reach</u>'}` : `<b class="big">${RNG[range]}</b> lands: ${lands(range)}`;
    if (range !== shown) { if (shown) { lab.classList.remove('flash'); void lab.offsetWidth; lab.classList.add('flash'); } shown = range; } }
  document.addEventListener('mouseover', (e) => { const b = e.target.closest ? e.target.closest('.sw') : null, g = b && b.dataset.g, id = b && b.dataset.id;
    const a = !b ? null : g === 'lead' || g === 'rear' ? (id === 'high' || id === 'low' ? null : ACT[id]) : g === 'feet' ? ACT[id] : null;   // a hand's 'low' hold is not the low kick
    const r = a && a.reach ? a.reach : null; if (String(r) !== String(hoverReach)) { hoverReach = r; hoverName = a ? a.n : ''; place(); } });
  /* S562 (owner on the gold squares and the white bar in the ring's corner: "also i do not undestand what is this"): the
     ground left behind each man moves out of the ring into his panel, a fourth bar under Guard in plain words. */
  css.textContent += '.rng{display:none}.bar.rm i{background:var(--gold)}#ruler .plabel.corner{left:.5rem;top:.45rem;transform:none;border:1px solid var(--line2)}#ruler .plabel.corner.ok{border-color:#74bd7c;box-shadow:0 0 10px rgba(116,189,124,.7)}#ruler .plabel.corner.no{border-color:#d9534a;box-shadow:0 0 10px rgba(217,83,74,.7)}#ruler .plabel.flash{animation:plateflash .9s ease-out}';
  css.textContent += '#ruler .plabel.corner{line-height:1.1}#ruler .plabel b.big{font-size:1.4rem;line-height:1;vertical-align:-.08em;margin-right:.3rem}';   /* S568 CLARITY1: the range large, one line */
  const room = (k) => { const m = F[k], n = 2 - Math.min(2, m.ropes || 0), who = k ? 'he' : 'you';
    return gz(k, 'rm', n / 2, 0, 0, n ? n + '/2' : 'ropes', 'Ground', `${n ? 'Room to back off: ' + n + ' of 2' : 'On the ropes: cannot back off'}. Every back off gives up one step of ground; with none left ${who} ${k ? 'is' : 'are'} on the ropes and cannot back off. A step in wins it back.`); };   /* S567: a round gauge like the others */
  const draw0 = draw; draw = function () { draw0(); for (const k of [0, 1]) { const el = $(k ? 'him' : 'you'), h = el.querySelector('.gz.gb'); if (h && !el.querySelector('.gz.rm')) h.insertAdjacentHTML('afterend', room(k)); } place(); };
  addEventListener('resize', place); im.addEventListener('load', place);
  // A picture that is not on disk (the kicks have none yet) must never leave the ring empty (owner S559: "both fighters
  // disappeared when istarted the beat"): show the men held at the range they are at instead.
  im.addEventListener('error', () => { const hold = `img/anim/blue_both_high_high${range === 3 ? '' : '_r' + range}_6.webp`; if (!im.src.endsWith(hold)) im.src = hold; });
  // ---- 2. the commentators
  const CREW = [{ n: 'Rita Vance', at: 20 }, { n: 'Hank Brody', at: 50 }, { n: 'Leo Marsh', at: 80 }];   // where each sits on the desk picture (%)
  const light = document.createElement('div'); light.id = 'desklight'; tell.appendChild(light);
  const call = document.createElement('div'); call.id = 'call'; tell.appendChild(call);
  let liveEv = null, said = 0;
  const res0 = resolve; resolve = function (S, P2) { const ev = res0(S, P2); if (S.f === F) liveEv = ev; return ev; };   // only the beat that is fought, never the machine's look-ahead
  const nm = (k) => (k === 0 ? 'Blue' : OPP.n.replace(/^The /, 'the '));
  const pick = (arr) => arr[said++ % arr.length];
  function line(ev) { const hits = ev.filter((e) => e.t === 'hit'), blocks = ev.filter((e) => e.t === 'block'), miss = ev.filter((e) => e.t === 'miss');
    const down = ev.find((e) => e.down), big = hits.slice().sort((a, b) => b.dmg - a.dmg)[0];
    if (down) return [2, pick([`DOWN GOES ${nm(1 - down.k).toUpperCase()}! That ${down.a.toLowerCase()} came out of nowhere!`, `Oh, he's hurt! ${nm(down.k)} puts him on the canvas with the ${down.a.toLowerCase()}!`])];
    if (ev.some((e) => e.t === 'clinch')) return [0, pick([`They're tied up. Nothing lands, and the referee breaks them at Mid.`, `Into the clinch. A breather for the man who grabbed.`])];
    const caught = blocks.find((e) => /CAUGHT/.test(e.o || '')); if (caught) return [1, `${nm(1 - caught.k)} catches the ${caught.a.toLowerCase()}! You cannot leave a leg hanging out there.`];
    const chk = blocks.find((e) => /checked/.test(e.o || '')); if (chk) return [1, pick([`Checked! ${nm(1 - chk.k)} lifted the shin and ${nm(chk.k)} pays for that low kick.`, `Shin on shin. That one hurt the kicker more.`])];
    if (big && big.dmg >= 4) return [2, pick([`What a ${big.a.toLowerCase()} from ${nm(big.k)}! ${big.dmg} off the health bar!`, `Oh, he felt THAT! ${nm(big.k)} lands the ${big.a.toLowerCase()} clean.`])];
    const ctr = hits.find((e) => /as a counter/.test(e.o || '')); if (ctr) return [1, `That's the counter. ${nm(1 - ctr.k)} came up empty and ${nm(ctr.k)} made him pay.`];
    const feint = hits.find((e) => /feint drew/.test(e.o || '')); if (feint) return [1, `He bit on the feint, and the ${feint.a.toLowerCase()} walked right in.`];
    const limp = hits.find((e) => /LIMPING/.test(e.o || '')); if (limp) return [2, `${nm(1 - limp.k)} is limping! Those low kicks are adding up.`];
    const dropped = hits.find((e) => /dropped as/.test(e.o || '')); if (dropped) return [1, `He kicked and dropped the rear hand, and ${nm(dropped.k)} was waiting for it.`];
    if (hits.length >= 2 && hits.some((e) => e.k === 0) && hits.some((e) => e.k === 1)) return [2, pick([`They're trading in there! Both men landing.`, `Toe to toe! Neither one wants to give an inch.`])];
    if (big) return [0, pick([`${nm(big.k)} lands the ${big.a.toLowerCase()}.`, `Clean ${big.a.toLowerCase()} from ${nm(big.k)}, ${big.dmg} off.`])];
    if (blocks.length) { const b = blocks[0]; return [1, pick([`Good defence. ${nm(1 - b.k)} had the hand right where the ${b.a.toLowerCase()} was going.`, `Blocked. ${nm(b.k)} is going to have to find another way in.`])]; }
    if (miss.length) { const m = miss[0]; return [0, /short/.test(m.o || '') ? `${nm(m.k)} falls short with the ${m.a.toLowerCase()}. Wrong range for it.` : `Too close for the ${m.a.toLowerCase()}, smothered.`]; }
    if (ev.some((e) => e.t === 'range')) return [0, pick([`Footwork now. They're at ${RNG[range]}.`, `Feeling each other out, ${RNG[range]} range.`])];
    return [2, pick([`Both men waiting. Somebody has to let his hands go.`, `A lot of looking, not a lot of punching.`])]; }
  function say(who, text) { call.innerHTML = `<b>${CREW[who].n}</b> ${text}`; call.className = 'w' + who + ' on'; light.style.setProperty('--x', CREW[who].at + '%'); light.className = 'on'; }
  function quiet() { call.className = ''; light.className = ''; }
  const plan1 = plan; plan = function () { plan1(); if (liveEv) { const [w, t] = line(liveEv); liveEv = null; say(w, t); } };
  const go1 = go; go = function () { quiet(); return go1(); };
  const bell1 = bell; bell = function () { const ev = liveEv; liveEv = null; bell1(); const c = cards[cards.length - 1]; if (c) say(1, `End of the round. I have it ${c[0]}-${c[1]}${c[0] === c[1] ? ', dead even' : c[0] > c[1] ? ' for Blue' : ' for ' + nm(1)}. ${ev && ev.some((e) => e.down) ? 'And that knockdown was the difference.' : 'Corners have work to do.'}`); };
  const over1 = over; over = function (text) { liveEv = null; over1(text); say(2, /YOU WIN/.test(text) ? `It's over! Blue gets it done tonight!` : /DRAW/.test(text) ? `A draw! Nobody goes home happy.` : `It's over. ${nm(1)} takes this one.`); };
  place();
  /* S568: the hand of cards (hand_ui.js, owner 'i like the B') - every page but ?ui=body */
  if (!/[?&]ui=body\b/.test(location.search)) { const h = document.createElement('script'); h.src = 'hand_ui.js?v=' + (window.RS_VERSION || ''); document.body.appendChild(h); }
  /* S568: the decision clock (clock_ui.js) - on one.html by default, elsewhere with ?clock=<seconds> */
  if (/[?&](clock|round)=\d/.test(location.search) || /one\.html$/.test(location.pathname)) { const s = document.createElement('script'); s.src = 'clock_ui.js?v=' + (window.RS_VERSION || ''); document.body.appendChild(s); }
})();
