// S575 fight.html: the v6.9 card fight (proto/octagon/table.mjs) in the Puncher's Chance look, each exchange played in the
// ring with our pictures. Owner: "ok look good build it" on docs/mockups/s575/cardfight_hud.png. You are blue, he is red.
import { POOL, STYLES, CARDS, TYPE, setRules, newGame, table, throwCard, autoKeep } from './octagon/table.mjs';
import { warningsOf } from './status_fx.js';   // S575 the status warnings table (one entry per effect; each style adds its own)
const $ = (id) => document.getElementById(id), q = new URLSearchParams(location.search);
setRules('ours');   // the owner picked ours (v6.9), Q-S294-351
const ids = Object.keys(POOL), pickId = (v, d) => (POOL[v] ? v : d);
let me = pickId(q.get('me'), 'longnight'), him = pickId(q.get('him'), 'iron'), seed = +(q.get('seed') || Math.ceil(Math.random() * 9999));
const opt = (sel, val) => { sel.innerHTML = ids.map((v) => `<option value="${v}"${v === val ? ' selected' : ''}>${POOL[v].n} - ${STYLES[POOL[v].style].n}</option>`).join(''); };
opt($('me'), me); opt($('him'), him);
const esc = (s) => String(s).replace(/[&<>"]/g, (c) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' })[c]);
const nm = (id) => (CARDS[id] ? CARDS[id].n : id), RNUM = { long: 3, mid: 2, close: 1 };
/* S575 (owner: "can you make clearer that a move will change the distance, player needs to know where he ends up after the
   card"): where a card leaves you, by the v6.9 rules (engine.mjs: pre = steps in before the punch, post = steps after;
   stopNoStep, fakeJab, stickMove, circleFeint, walkFeint / walkCheck). His card can move you too - the sign says so. */
const RANGES = ['long', 'mid', 'close'], RN = { long: 'LONG', mid: 'MID', close: 'CLOSE' };
function moveOf(c, r, fid = me) { const i = RANGES.indexOf(r), out = POOL[fid] && POOL[fid].style === 'out', press = POOL[fid] && POOL[fid].style === 'press';
  if (c.id === 'tieup') return { to: 'mid', how: 'the referee breaks you at Mid' };
  if (c.pre) { const to = RANGES[Math.min(2, i + c.pre)];
    if (c.type === 'A') return { to, how: (press ? 'you get in even if he beats you to it' : 'you stay if a faster punch beats you to it') + (out ? '; if it lands you jab and step straight back to LONG (stick and move)' : '') + '; catching his feint, you stay' };
    return { to, how: 'unless he hits you as you come in' }; }
  if (c.post) { const to = RANGES[Math.max(0, Math.min(2, i + c.post))];
    if (c.id === 'walk') return { to: 'mid', how: 'a feint does not stop you; his Check Hook does' };
    if (c.type === 'C') return { to, how: 'only if it lands' };
    return { to, how: 'a feint stops the step' }; }
  return { to: r, how: '' }; }
const RANGE_SAYS = { long: 'jabs, step-ins, feints', mid: 'cross, hooks, slips', close: 'hooks, uppercuts, the clinch' };

/* ---- the pictures: frames.json runs (img/anim), one man per picture by layers_ui.js (img/layers) ---- */
let ANIM = {}, LAY = {}; const PRE = {};
const ready = Promise.all([fetch('img/anim/frames.json').then((r) => r.json()), fetch('img/layers/frames.json').then((r) => r.json()).catch(() => ({ runs: {} }))])
  .then(([a, l]) => { ANIM = a.runs || {}; LAY = l.runs || {}; });
const rowOf = (n) => { const r = ANIM[n]; return r && !r.files && r.same_as ? ANIM[r.same_as] : r; };
const pick = (...names) => names.find((n) => n && rowOf(n) && rowOf(n).files && rowOf(n).files.length) || null;
const suf = (r) => (r === 2 ? '_r2' : r === 1 ? '_r1' : '');
const load = (src) => PRE[src] || (PRE[src] = new Promise((ok) => { const e = new Image(); e.onload = e.onerror = ok; e.src = src; }));
function warm(runs) { const all = []; for (const n of runs) { const r = rowOf(n); if (!r) continue; r.files.forEach((f) => all.push(load('img/anim/' + f)));
  for (const s of ['red', 'blue']) { const l = LAY[`${n}_${s}`]; if (l) l.files.forEach((f) => all.push(load('img/layers/' + f))); } } return Promise.all(all); }
const sleep = (ms) => new Promise((ok) => setTimeout(ok, ms));
async function playRun(n, onHit) { const r = rowOf(n); if (!r) return; const c = r.contact;
  for (let i = 0; i < r.files.length; i++) { $('pic').src = 'img/anim/' + r.files[i]; if (i === c && onHit) onHit();
    if (i < r.files.length - 1) await sleep(Math.min(130, Math.max(40, (r.offs[i + 1] - r.offs[i]) * 1000)) + (i === c ? 260 : 0)); } }
function hold(rng) { const n = pick(`blue_both_high_high${suf(rng)}`, 'blue_both_high_high', 'blue_guard'); if (n) { window.range = rng; warm([n]).then(() => { $('pic').src = 'img/anim/' + rowOf(n).files[0]; }); } }

/* which picture shows an exchange: a card -> a punch family, the log lines -> landed / blocked / missed */
const BASE = { jab: 'jab', feel: 'jab', cross3: 'cross', lhook3: 'lead_hook', liver3: 'body_hook', overhand: 'overhand', upper3: 'rear_uppercut', slip3: 'jab', lchk: 'lead_hook', pull3: 'cross' };
const SIDE = ['blue', 'red'];
function outcome(k, lines) { const mine = lines.filter((l) => l.k === k).map((l) => l.t).join(' | '), his = lines.filter((l) => l.k === 1 - k).map((l) => l.t).join(' | ');
  if (/lands \d+ to the (head|body)/.test(mine) && !/chip through|guard leaks/.test(mine)) return 'landed';
  if (/takes the|parries|blocked/.test(his) || /chip through|guard leaks/.test(mine)) return 'blocked'; return 'missed'; }
function punchRun(k, out, r) { const s = SIDE[k], b = BASE[cards[k]]; return pick(`${s}_${b}_${out}${suf(r)}`, `${s}_${b}_${out}`, `${s}_${b}_landed${suf(r)}`, `${s}_${b}_landed`, `${s}_guard${suf(r)}`); }
let cards = ['none', 'none'];
function planRuns(res, r0, r1) { cards = [res.you, res.him]; const T = cards.map((id) => (CARDS[id] ? CARDS[id].type : 'N')), L = res.lines, runs = [];
  const hitters = [0, 1].filter((k) => BASE[cards[k]] && outcome(k, L) === 'landed'), attackers = [0, 1].filter((k) => T[k] === 'A');
  if (hitters.length) hitters.forEach((k) => runs.push({ n: punchRun(k, 'landed', r0), k }));
  else if (attackers.length) attackers.forEach((k) => runs.push({ n: punchRun(k, outcome(k, L), r0), k }));
  else { const f = [0, 1].find((k) => T[k] === 'F'), c = [0, 1].find((k) => cards[k] === 'tieup');
    runs.push({ n: c !== undefined ? pick(`${SIDE[c]}_clinch`) : f !== undefined ? pick(`${SIDE[f]}_feint${suf(r0)}`, `${SIDE[f]}_feint`) : pick(`blue_guard${suf(r0)}`, 'blue_guard'), k: -1 }); }
  if (r1 !== r0) { const closer = r1 < r0, mv = [0, 1].find((k) => CARDS[cards[k]] && (closer ? (CARDS[cards[k]].pre || 0) > 0 || (CARDS[cards[k]].post || 0) > 0 : (CARDS[cards[k]].post || 0) < 0)) ?? (closer ? 1 : 0);
    runs.push({ n: closer ? pick(`${SIDE[mv]}_step_in_r${r1}`, `${SIDE[mv]}_step_in`) : pick(`${SIDE[mv]}_back_off_r${r1}`, `${SIDE[mv]}_back_off`), k: -1, step: 1 }); }
  return runs.filter((x) => x.n); }

/* ---- the bout ---- */
let G, sel = null, combo = [], keep, busy = false, prev = null, flip = null, moved = null, alerts = [[], []];
const snap = () => { const T = table(G); return [T.you, T.him].map((P) => ({ head: P.head, body: P.body, bodyMax: P.bodyMax, st: P.st, cage: P.cage })); };
const alertHtml = (k) => alerts[k].length ? `<div class="alerts">${alerts[k].map((a) => `<div class="alert ${a.sev}"><b>${esc(a.title)}</b><span>${esc(a.says)}</span></div>`).join('')}</div>` : '';
/* S575 (owner: "show the opponent's move too after the cards flip"): both played cards, each in its man's panel (nothing near
   the fighters), with where that card takes the pair by the rules; after the exchange the range sign says whose card moved them */
const cardOf = (id) => ({ ...CARDS[id], id, count: 1, now: CARDS[id].spd, dmgNow: 0, cost: CARDS[id].st, why: '' });
function flipHtml(k) { if (!flip) return ''; const id = flip.cards[k]; if (!CARDS[id]) return `<div class="flip"><div class="t">${k ? 'HIS' : 'YOUR'} CARD</div><div class="none">no card</div></div>`;
  return `<div class="flip"><div class="t">${k ? 'HIS' : 'YOUR'} CARD</div>${cardHtml(k ? cardOf(id) : { ...cardOf(id), ...(flip.mine || {}) }, 'sm', '', flip.r0, k ? him : me)}</div>`; }
function start() { me = $('me').value; him = $('him').value; G = newGame({ seed, me, him }); sel = null; combo = []; keep = undefined; prev = null;
  $('over').style.display = 'none'; $('last').innerHTML = '<span class="n">Pick a card, then THROW (or press Enter).</span>'; draw(); ready.then(() => hold(RNUM[G.S.range])); }
$('new').onclick = $('again').onclick = () => { seed += 1; history.replaceState(null, '', `?me=${$('me').value}&him=${$('him').value}&seed=${seed}`); start(); };
$('me').onchange = $('him').onchange = $('new').onclick;
$('q').onclick = () => { const h = $('help'); h.style.display = h.style.display === 'block' ? 'none' : 'block'; };

const gauge = (lab, v, m, col, key) => `<div class="g" data-g="${key}"><div class="c" style="--col:${col};--p:${Math.max(0, Math.round(100 * v / m))}">${v}</div><small>${lab} /${m}</small><span class="d"></span></div>`;
function side(P, k, T, extra) { const lead = (T.lead === 'you' && k === 0) || (T.lead === 'him' && k === 1), status = k ? T.statusHim : T.statusYou;
  const chips = (lead ? '<span class="chip lead" title="Won the last exchange: +1 speed on attacks, a Chain card can combo">THE LEAD &middot; +1 speed</span>' : '') + (P.rocked ? '<span class="chip warn">ROCKED</span>' : '')
    + (status ? status.split(/, (?=[A-Z]{3})/).filter((s) => !/^ROCKED/.test(s)).map((s) => `<span class="chip warn" title="${esc(s)}">${esc(s.split(' (')[0])}</span>`).join('') : '');
  return `<div class="nm ${k ? 'h' : 'y'}">${k ? esc(G.short[1]) : 'You'}</div><div class="sty" title="${esc(P.trait)}">${esc(P.name)} &middot; ${esc(P.style)}</div>`
    + `<div class="gauges">${gauge('HEAD', P.head, P.headMax, '#d9534a', 'head')}${gauge('BODY', P.body, P.bodyMax, '#e08a4a', 'body')}${gauge('STAMINA', P.st, P.stMax, '#74bd7c', 'st')}</div>`
    + `<div class="row" title="Room behind him before the ropes: at 0 his back is on the ropes - he cannot step out and attacks do +1">Room to the ropes <div class="ropes">${[0, 1, 2].map((i) => `<i class="${i < P.cage ? 'on' : ''}"></i>`).join('')}</div></div>`
    + alertHtml(k) + `<div class="chips">${chips}</div>` + (extra || ''); }
const chip = (id) => (CARDS[id] ? `<span class="chip ${CARDS[id].type}" title="${esc(CARDS[id].t)}">${esc(CARDS[id].n)}</span>` : '');
function cardHtml(c, cls = '', lab = '', r0 = null, fid = me) { const dmg = c.dmgNow || c.dmg || 0, big = (l, v, k) => `<div class="${k}"><small>${l}</small>${v}</div>`;
  const left = c.type === 'D' ? big('BLOCKS', ({ head: 'HEAD', body: 'BODY', any: 'ANY', half: 'HALF', all: 'ALL', none: '&ndash;' })[c.covers] || '&ndash;', 'wd') : big('DAMAGE', dmg, 'dm' + (dmg > (c.dmg || 0) ? ' up' : ''));
  const sp = big('SPEED', c.type === 'A' ? c.now : c.spd, 'sp' + (c.type === 'A' ? (c.now > c.spd ? ' up' : c.now < c.spd ? ' down' : '') : ''));
  const s = c.why ? c.why : c.dmg ? `to the ${c.zone || 'head'}${c.type === 'C' ? ', only if he attacks' : ''}` : c.type === 'D' ? (c.covers === 'none' ? 'blocks nothing' : c.id === 'walk' ? 'blocks the head, walks him down' : c.covers === 'half' ? 'halves an attack' : c.covers === 'any' ? 'blocks head or body' : `blocks the ${c.covers}`) : c.type === 'F' ? 'beats a Counter or a Defend' : '';
  return `<div class="card ${c.type} ${cls}" data-id="${c.id}" title="${esc(c.n + ' - ' + c.t + (c.why ? '\n\nNOT NOW: ' + c.why : ''))}">${lab ? `<span class="lab">${lab}</span>` : ''}${c.count > 1 ? `<span class="x2">x${c.count}</span>` : ''}`
    + `<div class="band">${TYPE[c.type].toUpperCase()}${c.chain ? ' &middot; CHAIN' : ''}</div><div class="n">${esc(c.n)}</div><div class="big">${left}${sp}</div><div class="st">stamina <b>${c.cost}</b></div>`
    + `<div class="rg"><span>plays at</span>${['long', 'mid', 'close'].map((r) => `<i class="${(c.legal || []).includes(r) ? 'on' : ''}">${r[0].toUpperCase()}</i>`).join('')}</div><div class="s">${esc(s)}</div>${mvHtml(c, r0, fid)}</div>`; }
function mvHtml(c, r0 = null, fid = me) {   /* S575 owner: "you need to show the direction of the movement, player will figure out where he ends up" - the CARD's step, the same at any distance */
  const d = Math.sign((c.pre || 0) + (c.post || 0)), m = moveOf(c, r0 || G.S.range, fid);
  const tip = esc(d > 0 ? `steps in, closer to him${m.how ? ' - ' + m.how : ''}` : d < 0 ? `steps back, away from him${m.how ? ' - ' + m.how : ''}` : c.id === 'tieup' ? 'ties him up: the referee breaks you at Mid' : 'no step: you stay where you are');
  /* S575 owner: "just use a left arrow if backwards movement is involved or right arrow when moving forward" - nothing when there is no step */
  return d ? `<div class="mv ${d > 0 ? 'in' : 'out'}" title="${tip}"><svg viewBox="0 0 44 20" width="44" height="20"${d < 0 ? ' style="transform:scaleX(-1)"' : ''}><path d="M2 7 H28 V1 L42 10 L28 19 V13 H2 Z" fill="currentColor"/></svg></div>` : ''; }
function sign(c) { const r = G.S.range; if (!c) { $('rng').classList.toggle('moved', !!(moved && moved.to === r)); $('rng').classList.remove('moving'); $('rng').innerHTML = moved && moved.to === r ? `${RN[moved.from]} &rarr; <b>${RN[r]}</b><span>${esc(moved.by)} moved you</span>` : `${RN[r]}<span>${RANGE_SAYS[r]}</span>`; return; }
  const m = moveOf(c, r); $('rng').classList.toggle('moving', m.to !== r);
  $('rng').innerHTML = m.to === r ? `${RN[r]}<span>${esc(c.n)}: you stay here &middot; his card can still move you</span>` : `${RN[r]} <b>&rarr; ${RN[m.to]}</b><span>${esc(c.n)}: ${esc(m.how || 'you end up at ' + RN[m.to])} &middot; his card can move you too</span>`; }

function draw() { const T = table(G);
  $('rd').innerHTML = `Round <b>${T.round}</b> of ${T.rounds}`; $('pips').innerHTML = Array.from({ length: T.exchanges }, (_, i) => `<i class="${i + 1 < T.ex ? 'd' : i + 1 === T.ex ? 'now' : ''}"></i>`).join('');
  $('exn').textContent = `exchange ${T.ex} of ${T.exchanges}`;
  $('judges').innerHTML = `Judges <b class="y">${T.judges[0]}</b> - <b>${T.judges[1]}</b> &nbsp;&middot;&nbsp; this round <b class="y">${T.thisRound[0]}</b> - <b>${T.thisRound[1]}</b>`;
  sign(sel ? T.hand.find((c) => c.id === sel) : null);
  $('you').innerHTML = side(T.you, 0, T, flipHtml(0));
  const tell = T.tellYou ? `<div class="tell"><div class="cb ${T.tellYou}"></div><div><b>His card: ${T.tellYou === 'AC' ? 'Attack or Counter' : 'Feint or Defend'}</b>your feint showed you the colour</div></div>`
    : T.tellHim ? '<div class="tell"><div class="cb"></div><div><b>He sees your colour</b>this exchange you seal first</div></div>' : '';
  const reads = (T.cutShows ? `<div class="mini">His cut shows you<div class="chips">${chip(T.cutShows)}</div></div>` : '') + (T.readHand ? `<div class="mini">You read in his hand<div class="chips">${T.readHand.map(chip).join('')}</div></div>` : '')
    + ((flip ? T.hisLast.slice(1) : T.hisLast).length ? `<div class="mini">Before that<div class="chips">${(flip ? T.hisLast.slice(1) : T.hisLast).map(chip).join('')}</div></div>` : '');
  $('hims').innerHTML = side(T.him, 1, T, flipHtml(1) + tell + reads);
  if (prev) for (const [k, P] of [[0, T.you], [1, T.him]]) for (const [g, v] of [['head', P.head], ['body', P.body], ['st', P.st]]) { const dv = v - prev[k][g]; if (!dv) continue;
    const el = $(k ? 'hims' : 'you').querySelector(`[data-g="${g}"]`); el.querySelector('.d').textContent = (dv > 0 ? '+' : '') + dv; el.querySelector('.d').classList.add('on'); if (dv < 0 && g !== 'st') el.classList.add('hit'); setTimeout(() => el.querySelector('.d').classList.remove('on'), 1800); }
  prev = [{ head: T.you.head, body: T.you.body, st: T.you.st }, { head: T.him.head, body: T.him.body, st: T.him.st }];
  const H = T.hand, selC = H.find((c) => c.id === sel && !c.why); if (!selC) { sel = null; combo = []; }
  const canCombo = selC && T.comboOk && selC.chain && selC.type === 'A';
  const cls = (c) => (c.id === sel ? 'sel' : combo.includes(c.id) ? 'combo' : c.why && !combo.includes(c.id) ? 'dead' : ''), lab = (c) => (c.id === sel ? 'picked' : combo.includes(c.id) ? 'then (combo)' : '');
  const always = H.filter((c) => c.always), hand = H.filter((c) => !c.always);
  const keepOpts = [...new Set(G.S.f[0].hand)].filter((id) => id !== sel && ['C', 'D'].includes(CARDS[id].type)), k0 = keep === undefined ? autoKeep(G, sel) : keep;
  const kc = k0 && H.find((c) => c.id === k0);
  $('hand').innerHTML = `<div class="grp"><div class="t">ALWAYS THERE</div><div class="cards">${always.map((c) => cardHtml(c, 'sm ' + cls(c), lab(c))).join('')}</div></div>`
    + `<div class="grp"><div class="t">YOUR HAND${canCombo ? ' &middot; <span style="color:var(--gold)">you hold the Lead: click up to 2 more attacks to combo</span>' : ''}</div><div class="cards">${hand.map((c) => cardHtml(c, cls(c), lab(c))).join('')}</div></div>`
    + `<div class="grp"><div class="t">IF HE COMBOS</div><div class="slot" id="slot" title="If he throws a combo, this Counter or Defend from your hand answers it. Click to change.">${kc ? cardHtml({ ...kc, why: '' }, 'sm') : keepOpts.length ? 'click to keep a Counter or Defend' : 'no Counter or Defend in your hand'}</div></div>`
    + `<div class="go"><button id="throw"${sel && !busy && !T.over ? '' : ' disabled'}>THROW</button><small>${sel ? esc(nm(sel)) + (combo.length ? ' + ' + combo.map(nm).join(' + ') : '') : 'pick a card'}<br>both cards turn over, then the exchange plays in the ring</small></div>`;
  [...$('hand').querySelectorAll('.cards .card')].forEach((el) => { el.onclick = () => { if (busy) return; const id = el.dataset.id, c = H.find((x) => x.id === id);
    if (canCombo && id !== sel && c.type === 'A' && c.count) { combo = combo.includes(id) ? combo.filter((x) => x !== id) : [...combo, id].slice(0, 2); return draw(); }
    if (c.why) return; sel = sel === id ? null : id; combo = []; keep = undefined; draw(); }; el.onmouseenter = () => { if (!busy) sign(H.find((x) => x.id === el.dataset.id)); }; el.onmouseleave = () => { if (!busy) sign(sel ? H.find((x) => x.id === sel) : null); }; el.ondblclick = () => { if (!H.find((x) => x.id === el.dataset.id).why) { sel = el.dataset.id; go(); } }; });
  $('slot').onclick = () => { if (busy || !keepOpts.length) return; const all = [...keepOpts, null], i = all.indexOf(k0); keep = all[(i + 1) % all.length]; draw(); };
  $('throw').onclick = go;
  if (T.over && !busy) { const O = T.over; $('overt').textContent = O.winner === 'draw' ? 'A draw' : O.winner === 'you' ? 'You win' : 'He wins';
    $('overd').textContent = `by ${O.how.toLowerCase()}${O.score ? ' ' + Math.max(...O.score) + '-' + Math.min(...O.score) : ' in round ' + O.round}`; $('over').style.display = 'flex'; } }

async function go() { if (!sel || busy || G.over) return; const r0 = RNUM[G.S.range], before = { round: G.S.round, ex: G.S.ex };
  const mine = table(G).hand.find((c) => c.id === sel), s0 = snap();
  const res = throwCard(G, { card: sel, then: combo, react: keep, discard: undefined });
  if (res.error) { $('last').innerHTML = `<span class="h">Not now: ${esc(res.error)}</span>`; return; }
  flip = { cards: [res.you, res.him], r0: RANGES[3 - r0], mine: mine ? { now: mine.now, dmgNow: mine.dmgNow } : null }; moved = null;
  busy = true; sel = null; combo = []; keep = undefined; draw();
  $('last').innerHTML = `<span class="vs">R${before.round} E${before.ex}: your ${esc(nm(res.you))} v his ${esc(nm(res.him))}</span>`;
  const r1 = RNUM[G.S.range], runs = planRuns(res, r0, r1);
  const bell = G.S.round !== before.round;
  if (r1 !== r0 && bell) moved = { from: RANGES[3 - r0], to: G.S.range, by: 'the bell: a new round' };
  else if (r1 !== r0) { const closer = r1 < r0, by = [0, 1].filter((k) => { const c = CARDS[flip.cards[k]]; return c && (closer ? (c.pre || 0) > 0 || (c.post || 0) > 0 || flip.cards[k] === 'tieup' : (c.post || 0) < 0 || flip.cards[k] === 'tieup'); });
    moved = { from: RANGES[3 - r0], to: G.S.range, by: by.length ? by.map((k) => (k ? 'his ' : 'your ') + nm(flip.cards[k])).join(' and ') : 'the round bell' }; } await ready; await warm(runs.map((x) => x.n));
  if (G.over && /KO/.test(G.over.how) && G.over.winner !== 'draw') { const kd = pick(`${SIDE[G.over.winner === 'you' ? 1 : 0]}_knockdown`); if (kd) runs.push({ n: kd, k: -1 }); }   /* a KO or a stoppage ends on the loser going down */
  for (const x of runs) { window.range = r0; await playRun(x.n, () => { const st = $('stage'); if (x.k >= 0) { st.classList.remove('shake'); void st.offsetWidth; st.classList.add('shake'); } }); }
  $('last').innerHTML = `<span class="vs">R${before.round} E${before.ex}: your ${esc(nm(res.you))} v his ${esc(nm(res.him))}</span><br>` + res.lines.filter((e) => !/discards one card|recovers 0 stamina/.test(e.t)).map((e) => `<span class="${e.k === 0 ? 'y' : e.k === 1 ? 'h' : 'n'}">${esc((e.who ? G.short[e.k] + ' ' : '') + e.t)}</span>`).join(' &middot; ');   /* his and your fighter's name: the log lines are third person */
  alerts = warningsOf(res.lines, snap(), s0); if (alerts[0].length || alerts[1].length) { const mark = alerts; if (q.get('alerts') !== 'stay') setTimeout(() => { if (alerts === mark) { alerts = [[], []]; if (!busy) draw(); } }, 7000); }   /* ?alerts=stay (test hook): warnings stay up, for screenshots */
  busy = false; if (!G.over || !/KO/.test(G.over.how)) hold(RNUM[G.S.range]); draw(); }   /* after a stoppage he stays down */
document.addEventListener('keydown', (e) => { if (e.key === 'Enter' && sel && !/SELECT|INPUT/.test(document.activeElement.tagName)) go(); if (e.key === 'Escape') $('help').style.display = 'none'; });
start();
/* ?auto=N (test hook, S575): plays N exchanges by itself with your first attack card (else the first card you can play), for screenshots */
if (q.get('alerts') === 'stay') document.body.classList.add('still');
if (q.get('pick')) { sel = q.get('pick'); draw(); }   /* ?pick=<card> (test hook): the card picked, for screenshots */
const AUTO = +(q.get('auto') || 0); if (AUTO) (async () => { for (let i = 0; i < AUTO && !G.over; i++) { await ready; const H = table(G).hand.filter((c) => !c.why); const c = H.find((x) => x.type === 'A' && !x.always) || H.find((x) => x.type === 'A') || H[0]; if (!c) break; sel = c.id; await go(); } })();
window.fightState = () => ({ G, busy, sel, range: window.range });
