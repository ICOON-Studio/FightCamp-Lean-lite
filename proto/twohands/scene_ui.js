/* FAMOUS EXCHANGES ON THE PAGE (S567, owner: "breakdown their actions with our game switches and play it like the real
   clip ... see how it feels"). scene.html = order.html + scenes.js + this file (built by tools/make_scene.py). A scene
   sets both men's switches beat by beat from scenes.js and fights each beat on the page's OWN rules: what you see is
   what our game says, not a film. After the last beat the whole exchange plays straight through (the round replay). */
(() => { const S = window.RS_SCENES || []; if (!S.length) return;
  const css = document.createElement('style'); css.textContent = '#scenebar{display:flex;flex-wrap:wrap;gap:.3rem;align-items:center;margin-bottom:.5rem;padding-bottom:.5rem;border-bottom:1px solid var(--line2)}#scenebar b{width:100%;color:var(--gold);font-size:.8rem;letter-spacing:.06em;text-transform:uppercase}#scenebar button{font-size:.78rem;padding:.2rem .5rem}#scenebar button.on{border-color:var(--gold);color:var(--gold)}#scenenote{width:100%;font-size:.86rem;line-height:1.3}#scenenote i{color:var(--muted);font-style:normal}#scenenote a{color:var(--gold)}#scenenote .real{display:block;margin-top:.3rem;padding:.3rem .45rem;border-left:3px solid var(--gold);background:var(--panel2)}';
  document.head.appendChild(css);
  const bar = document.createElement('div'); bar.id = 'scenebar'; $('said').parentElement.prepend(bar);
  bar.innerHTML = '<b>Famous exchanges, played with our switches</b>' + S.map((s) => `<button class="btn" data-s="${s.id}">${s.title}</button>`).join('') + '<div id="scenenote"><i>Pick one. Each beat is fought on this page\'s own rules, then the whole exchange plays straight through.</i></div>';
  const note = (h) => { $('scenenote').innerHTML = h; }, sleep = (ms) => new Promise((ok) => setTimeout(ok, ms)), idle = () => new Promise((ok) => { const w = () => (busy ? setTimeout(w, 80) : ok()); w(); });
  const mk = (p) => { const m = plan0(); if (p.clinch) { m.clinch = true; return m; } const L = p.lead || 'high', H = p.rear || 'high';
    if (L === 'high' || L === 'low') m.hl = L; else m.lead = L; if (H === 'high' || H === 'low') m.hr = H; else m.rear = H; m.feet = p.feet || 'hold';
    const acts = [...(m.feet !== 'hold' ? ['feet'] : []), ...(m.lead ? ['lead'] : []), ...(m.rear ? ['rear'] : [])], want = (p.order || '').split(',').filter((x) => acts.includes(x)); m.ord = [...want, ...acts.filter((x) => !want.includes(x))]; return m; };
  let run = 0;
  async function play(sc) { if (busy) return; const mine = ++run; for (const b of bar.querySelectorAll('button')) b.classList.toggle('on', b.dataset.s === sc.id);
    OPP = { ...OPPS[0], n: sc.red }; F = [man(N.hp), man(N.hp)]; for (const k of [0, 1]) { F[k].hp = sc.hp[k]; F[k].st = sc.st[k]; if (sc.ropes) F[k].ropes = sc.ropes[k]; }
    round = 1; beat = 0; range = sc.range; cards = []; seen = []; seenRound = []; tape = []; lastTape = null; heldShown = ''; if (window.ringSpots) ringSpots([0, 0, 0, 0]);
    const head = `<b style="color:#fff;width:auto;text-transform:none;letter-spacing:0;font-size:.9rem">${sc.bout}</b><br><i>You are ${sc.blue} (blue). ${sc.lesson}</i> <a target="_blank" rel="noopener" href="https://www.youtube.com/results?search_query=${encodeURIComponent(sc.watch)}">find the real clip</a>`;
    for (let i = 0; i < sc.beats.length; i++) { if (mine !== run) return; const b = sc.beats[i]; P = mk(b.blue); P.ord = P.ord || ordOf(P); hisNext = { at: round + ':' + beat, plan: mk(b.red) }; plan();
      note(`${head}<span class="real"><i>In the ring, beat ${i + 1} of ${sc.beats.length}:</i> ${b.real}</span>`); await sleep(2600); if (mine !== run || phase !== 'plan') return; go(); await idle(); if (phase === 'over') break; await sleep(500); }
    if (mine !== run) return; lastTape = { round: 1, items: tape.slice() }; note(`${head}<span class="real"><i>That is what our rules made of it. Now the whole exchange, straight through.</i></span>`); await sleep(900); if (mine === run && !busy) replay(); }
  for (const b of bar.querySelectorAll('button')) b.onclick = () => play(S.find((s) => s.id === b.dataset.s));
  const q = new URLSearchParams(location.search).get('s'); if (q && S.find((s) => s.id === q)) setTimeout(() => play(S.find((s) => s.id === q)), 1200);
})();
