/* PLAY ONLINE (S567, owner: "can you make like a server so all agents can connect and play and dd the option in the game
   too ?"). online.html = order.html + this file (tools/make_online.py). A bar in the right panel: your name, Find an
   opponent. The opponent is whoever else is on the match server (site/match_server.mjs): an agent or a person. Each beat
   you set your moves as always; Fight seals them on the server; when he has sealed his, the beat is played here with HIS
   real moves in place of the computer's. The server is the referee: after every beat the numbers are taken from it. */
(() => { const API = new URLSearchParams(location.search).get('server') || (location.port === '8797' || location.protocol === 'file:' ? `http://${location.hostname || '127.0.0.1'}:8796` : '');   /* on the page server of this PC: the match server's own port; through the test link's gate: the same address (the gate passes /api on) */
  const css = document.createElement('style'); css.textContent = '#onbar{display:flex;flex-wrap:wrap;gap:.35rem;align-items:center;margin-bottom:.5rem;padding-bottom:.5rem;border-bottom:1px solid var(--line2)}#onbar b{width:100%;color:var(--gold);font-size:.8rem;letter-spacing:.06em;text-transform:uppercase}#onbar input{flex:1;min-width:6rem;background:var(--panel2);border:1px solid var(--line2);border-radius:.4rem;color:inherit;padding:.25rem .45rem;font:inherit}#onbar button{font-size:.82rem;padding:.25rem .6rem}#onstat{width:100%;font-size:.86rem;line-height:1.3}#onstat.bad{color:#ff9d95}#onlob{width:100%;font-size:.78rem;color:var(--muted);line-height:1.35}#onlob u{text-decoration:none;color:#efe4d2}';
  document.head.appendChild(css);
  const bar = document.createElement('div'); bar.id = 'onbar'; $('said').parentElement.prepend(bar);
  bar.innerHTML = '<b>Play online</b><input id="onname" maxlength="24" placeholder="Your name"><button class="btn" id="onfind">Find an opponent</button><div id="onstat">Another player or an agent, on the same rules. Each beat you both choose before either sees the other.</div><div id="onlob"></div>';
  let ON = null, finding = 0; const stat = (t, bad) => { $('onstat').textContent = t; $('onstat').className = bad ? 'bad' : ''; }, sleep = (ms) => new Promise((ok) => setTimeout(ok, ms));
  try { $('onname').value = localStorage.getItem('pc_name') || ''; } catch (e) { /* no storage: the name is typed each time */ }
  const call = async (p, o) => { const r = await fetch(API + p, o ? { method: 'POST', headers: { 'content-type': 'application/json' }, body: JSON.stringify(o) } : undefined); return r.json(); };
  // the server's numbers are the truth: taken over before every plan
  function apply(s) { for (const k of [0, 1]) { const r = s.raw[k]; Object.assign(F[k], { hp: r.hp, max: r.max, st: r.st, cap: r.cap, g: r.g, pts: r.pts, kd: r.kd, ropes: r.ropes, held: r.held, kept: r.kept, gave: r.gave }); } range = s.range; round = s.round; beat = s.beat - 1; cards = s.cards.map((c) => [c[0], c[1]]); }
  async function lobby() { if (ON && ON.match) return; try { const l = await call('/api/lobby'); $('onlob').innerHTML = (l.waiting.length ? `Waiting for a bout: <u>${l.waiting.join(', ')}</u><br>` : '') + (l.table.length ? 'Table: ' + l.table.slice(0, 6).map((t) => `<u>${t.name}</u> ${t.points} pts (${t.won}-${t.drawn}-${t.lost})`).join(' &middot; ') : 'No bout played yet.'); } catch (e) { $('onlob').textContent = 'The match server does not answer (' + API + ').'; } }
  async function find() { if (busy || (ON && ON.match)) return; const name = $('onname').value.trim(); if (!name) return stat('Type a name first.', true); const mine = ++finding; try { localStorage.setItem('pc_name', name); } catch (e) { /* fine */ }
    try { if (!ON || ON.name !== name) { const j = await call('/api/join', { name }); if (!j.token) return stat(j.error || 'The server refused the name.', true); ON = { token: j.token, name: j.name }; }
      stat('Looking for an opponent... (leave this page open)'); $('onfind').textContent = 'Stop looking';
      for (;;) { if (mine !== finding) return; const f = await call('/api/find', { token: ON.token }); if (f.match) { const s = await call('/api/state?token=' + ON.token); return start(s); } if (f.error) return stat(f.error, true); await sleep(2000); }
    } catch (e) { stat('The match server does not answer (' + API + ').', true); $('onfind').textContent = 'Find an opponent'; } }
  function start(s) { ON.match = s.match; ON.n = s.n; ON.him = s.him; ON.sent = false; ON.pending = null; $('onfind').textContent = 'Give up the bout';
    OPP = { ...OPPS[0], n: s.him, hp: N.hp, t: 'A real opponent.' }; F = [man(N.hp), man(N.hp)]; P = plan0(); round = 1; beat = 0; range = 3; cards = []; seen = []; seenRound = []; tape = []; lastTape = null; heldShown = ''; if (window.ringSpots) ringSpots([0, 0, 0, 0]);
    apply(s); stat(`You are fighting ${s.him}. Choose your moves, then Fight: they stay hidden until he has chosen too.`); plan(); }
  async function seal() { if (ON.sent || busy) return; ON.sent = true; const b = $('go'); if (b) { b.disabled = true; b.textContent = 'Sealed - waiting for ' + ON.him; }
    try { const r = await call('/api/plan', { token: ON.token, match: ON.match, plan: { ...P } }); if (!r.ok) { ON.sent = false; if (b) { b.disabled = false; b.textContent = 'Fight this beat'; } return stat('Not played: ' + r.error, true); }
      stat(`Your moves are sealed. Waiting for ${ON.him}...`); let s = r.state;
      while (s.n === ON.n && !s.over) { await sleep(1500); if (!ON || !ON.match) return; s = await call(`/api/state?token=${ON.token}&match=${ON.match}`); }
      ON.n = s.n; ON.sent = false; ON.pending = s; if (!s.lastBeat || s.lastBeat.at.round !== round || s.lastBeat.at.beat !== beat) { stat(s.over || 'The bout moved on without this beat.', !s.over); return plan(); }
      hisNext = { at: round + ':' + beat, plan: s.lastBeat.hisPlan }; stat(`Both sealed. ${ON.him}: ${planWords(s.lastBeat.hisPlan)}.`); go0(); }
    catch (e) { ON.sent = false; stat('The match server does not answer.', true); if (b) { b.disabled = false; b.textContent = 'Fight this beat'; } } }
  function ended(text) { stat('The bout is over: ' + text + '. Find another opponent when you like.'); ON.match = null; $('onfind').textContent = 'Find an opponent'; lobby(); }
  const go0 = go; go = function () { if (ON && ON.match) return seal(); go0(); };
  const plan1 = plan; plan = function () { if (ON && ON.match && ON.pending) { const s = ON.pending; ON.pending = null; apply(s); if (s.over) { if (phase !== 'over') over(s.over.replace(ON.name + ' WINS', 'YOU WIN')); return ended(s.over); } } plan1(); };
  const over1 = over; over = function (t) { over1(t); if (ON && ON.match) { const s = ON.pending; ON.pending = null; ended(s && s.over ? s.over : t); } };
  $('onfind').onclick = async () => { if (ON && ON.match) { if (busy) return; const m = ON.match; ON.match = null; try { await call('/api/leave', { token: ON.token, match: m }); } catch (e) { /* the limit will end it */ } stat('You gave up the bout.'); $('onfind').textContent = 'Find an opponent'; setup(); return lobby(); }
    if ($('onfind').textContent === 'Stop looking') { finding++; try { await call('/api/leave', { token: ON.token }); } catch (e) { /* fine */ } $('onfind').textContent = 'Find an opponent'; return stat('Stopped looking.'); } find(); };
  lobby(); setInterval(lobby, 6000);
})();
