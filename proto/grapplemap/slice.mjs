// GRAPPLEMAP1 - cuts the BJJ part out of GrappleMap.txt and draws it.
//   node proto/grapplemap/slice.mjs            (needs proto/grapplemap/GrappleMap.txt, not in git)
// writes: bjj_slice.json (the small extract, geometry included), bjj_slice.gm.txt (the same records verbatim),
// out/<card>.svg (one picture per card), out/index.html (contact sheet).
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { JOINTS, readGrappleMap } from './parse.mjs';
import { positionSvg, transitionSvg } from './render2d.mjs';
import { CARDS } from '../cardgame/cards.mjs'; // read only - the card game is another seat's folder

const HERE = path.dirname(fileURLToPath(import.meta.url));
export const SOURCE = {
  repo: 'https://github.com/Eelis/GrappleMap',
  commit: '032c8f91809786b7b784852abd07cf3e10c0ea35',
  file: 'GrappleMap.txt',
  license: 'All authors involved in the creation of the contents of this package have agreed to release their respective contributions into the Public Domain.',
};

// Which GrappleMap move is each card's picture, and why. A card with no honest match stays unmatched: no stand-ins.
// `at` is the card's own range list in proto/cardgame/cards.mjs; `why` says what makes the move the card's move.
export const MATCH = {
  sweep: { name: 'hip bump sweep', why: 'the bottom player in a broken-open closed guard rolls up and over: the card\'s own sweep from B0/B1, and GrappleMap tags it sweep (bottom).' },
  pass: { name: 'bull fighter pass', why: 'the standing player walks the legs aside and comes down past them: the card is an advance from the top rungs T0-T2, and GrappleMap tags it pass_around (top).' },
  triangle: { name: 'triangle', from: 'full guard kimura threat', why: 'the bottom player closes a triangle from full guard, which is the card\'s own B0 range (bottom).' },
  armbar: { name: 'arm bar', to: 'arm lock', why: 'the arm bar is finished and GrappleMap lands on its own position named "arm lock", tagged armbar (bottom).' },
  choke: { name: 'rear naked choke', why: 'the rear naked choke from back control with the arm trapped: the card\'s T3 range, tagged rear_naked_choke.' },
  kimura: { name: 'kimura', to: 'half guard kimura', why: 'the kimura finishes into GrappleMap\'s "half guard kimura", the card\'s own B1/T1 half guard rungs (tagged kimura).' },
  // core cards, in every deck including the BJJ one
  sprawl: { name: 'sprawl to head&arm', why: 'a sprawl on a low double leg that ends in GrappleMap\'s named sprawl position: the card answers a takedown (tagged sprawl, top).' },
  escape: { name: 'stand up escape', from: 'chest pass', why: 'the bottom player stands up out of a pass being laid, which is exactly the card\'s printed act: stand up (tagged stand_up, bottom).' },
};

const cardIds = Object.keys(CARDS).filter((id) => CARDS[id].st === 'bjj' || CARDS[id].st === 'core');

// resolve a match name (+ optional end names) inside the parsed graph
function resolve(g, card, m) {
  const nameOf = (id) => (id === null ? null : id < g.positions.length ? g.positions[id].name : `(unnamed ${id - g.positions.length})`);
  const hits = g.transitions.filter((t) => t.name.toLowerCase() === m.name.toLowerCase());
  const narrowed = hits.filter((t) => (!m.from || (t.from !== null && g.positions[t.from].name === m.from))
    && (!m.to || (t.to !== null && g.positions[t.to].name === m.to)));
  if (narrowed.length !== 1) {
    throw new Error(`${card}: "${m.name}" matched ${narrowed.length} moves (of ${hits.length} with that name); tighten MATCH.from/to`);
  }
  const t = narrowed[0];
  return { t, fromName: nameOf(t.from), toName: nameOf(t.to) };
}

// JSON with one pose per line and no nesting past that, so the extract stays readable and small
function compact(value, indent = '') {
  const pad = indent + '  ';
  const matrix = (v) => Array.isArray(v) ? v.some((x) => Array.isArray(x) || matrix(x)) : v && typeof v === 'object' ? Object.values(v).some(matrix) : false;
  if (!matrix(value)) return inline(value);
  if (Array.isArray(value)) {
    return `[\n${value.map((v) => pad + compact(v, pad)).join(',\n')}\n${indent}]`;
  }
  return `{\n${Object.keys(value).map((k) => `${pad}${JSON.stringify(k)}: ${compact(value[k], pad)}`).join(',\n')}\n${indent}}`;
}

function inline(value) {
  if (Array.isArray(value)) return `[${value.map(inline).join(', ')}]`;
  if (value && typeof value === 'object') return `{${Object.keys(value).map((k) => `${JSON.stringify(k)}: ${inline(value[k])}`).join(', ')}}`;
  return JSON.stringify(value);
}

export function buildSlice(g) {
  const cards = [];
  const usedTrans = new Set();
  for (const id of cardIds) {
    const m = MATCH[id];
    if (!m) { cards.push({ id, style: CARDS[id].st, card: CARDS[id], match: null, note: 'no match in GrappleMap' }); continue; }
    const { t, fromName, toName } = resolve(g, id, m);
    usedTrans.add(t.id);
    cards.push({
      id,
      style: CARDS[id].st,
      card: CARDS[id],
      grapplemap: g.positions.length + t.id, // the move's id in the file's own record order (what the game's graph.json uses)
      transitionIndex: t.id,                  // 0-based among transitions only
      name: t.name,
      tags: t.tags,
      properties: t.props,
      frames: t.frames.length,
      from: t.from === null ? null : [t.from, fromName],
      to: t.to === null ? null : [t.to, toName],
      why: m.why,
      picture: `out/${id}.svg`,
    });
  }
  const posIds = new Set();
  for (const c of cards) {
    if (c.grapplemap === undefined) continue;
    if (c.from) posIds.add(c.from[0]);
    if (c.to) posIds.add(c.to[0]);
  }
  const positions = [...posIds].sort((a, b) => a - b).map((id) => {
    const p = g.positions[id];
    return { id, name: p.name, tags: p.tags, pose: p.pose };
  });
  const transitions = [...usedTrans].sort((a, b) => a - b).map((id) => {
    const t = g.transitions[id];
    return {
      id: g.positions.length + id, transitionIndex: id, name: t.name, tags: t.tags, properties: t.props,
      from: t.from === null ? null : { id: t.from, name: g.positions[t.from].name },
      to: t.to === null ? null : { id: t.to, name: g.positions[t.to].name },
      frames: t.frames,
    };
  });
  return {
    slice: {
      what: 'GRAPPLEMAP1: the GrappleMap positions and transitions that map to the card game\'s BJJ cards (proto/cardgame/cards.mjs), cut from GrappleMap.txt.',
      by: 'Arena seat, S540. Only the moves in `cards` are kept; ids are the file\'s own record order (positions first, then transitions), which is also how the game\'s grapple graph numbers them.',
      source: {
        ...SOURCE,
        bytes: g.counts.bytes,
        sha256: g.counts.sha256,
        counts: {
          positions: g.counts.positions, transitions: g.counts.transitions, frames: g.counts.frames,
          poses: g.counts.poses, tags: g.counts.tags, joints: g.counts.joints, playerJoints: g.counts.playerJoints,
        },
      },
      pose: { valuesPerFigure: JOINTS.length * 3, order: JOINTS, players: ['red (player 0)', 'blue (player 1)'], units: 'metres, y up' },
      cards,
      positions,
      transitions,
    },
    raw: [
      ...[...posIds].sort((a, b) => a - b).map((id) => g.positions[id].raw.join('\n')),
      ...[...usedTrans].sort((a, b) => a - b).map((id) => g.transitions[id].raw.join('\n')),
    ].join('\n'),
  };
}

function contactSheet(slice) {
  const rows = slice.cards.map((c) => {
    const card = c.card;
    const printed = `${card.n} · ${card.k} · ${card.w} wind · from ${[].concat(card.at || card.L || []).join('/') || '-'}`;
    const gm = c.grapplemap === undefined
      ? '<b>no match</b>'
      : `<b>GrappleMap ${c.grapplemap}</b> "${esc(c.name)}" · ${c.frames} frames · ${c.properties.join(', ') || 'no top/bottom tag'}<br><span class="tags">${c.tags.join(' ') || 'no tags'}</span><br><small>${c.from ? c.from[0] + ' ' + esc(c.from[1]) : '(unnamed start)'} → ${c.to ? c.to[0] + ' ' + esc(c.to[1]) : '(unnamed end)'}</small><br><small>${esc(c.why)}</small>`;
    return `<section class="cardrow"><div class="pic"><img src="${c.id}.svg" alt="${esc(card.n)} drawn from GrappleMap" width="320" height="320"></div><div class="txt"><h3>${esc(card.n)} <span class="pill">${c.style}</span></h3><p class="print">${esc(printed)}</p>${gm}</div></section>`;
  }).join('\n');
  return `<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>GrappleMap pictures for the BJJ cards</title>
<style>
body{font:15px/1.5 system-ui,sans-serif;background:#efeae0;color:#2b2620;margin:0;padding:24px 20px 60px}
h1{font-size:22px;margin:0 0 6px}h2{font-size:17px;margin:28px 0 8px}
.lead{max-width:900px;color:#57503f}
.cardrow{display:flex;gap:18px;align-items:flex-start;background:#fbf9f4;border:1px solid #dcd5c6;border-radius:12px;padding:14px;margin:12px 0;max-width:1000px}
.pic{width:320px;flex:0 0 320px}.pic img,.pic svg{width:320px;height:320px;display:block;border-radius:8px}
.txt{flex:1;min-width:0}.txt h3{margin:0 0 4px;font-size:18px}
.pill{font-size:11px;background:#e6dfd0;border-radius:20px;padding:2px 8px;color:#57503f;vertical-align:middle}
.print{margin:0 0 8px;color:#4a4438}.tags{color:#8a8272;font-size:12px}
table{border-collapse:collapse;font-size:13px;background:#fbf9f4}td,th{border:1px solid #dcd5c6;padding:3px 8px;text-align:left}
code{background:#e6dfd0;padding:1px 4px;border-radius:4px;font-size:13px}
</style></head><body>
<h1>GrappleMap pictures for the card game's BJJ cards</h1>
<p class="lead">Every picture is drawn straight from <code>GrappleMap.txt</code> (public domain): two figures, side view,
orthographic, red and blue, limbs as round-capped strokes. A move plays as its frames (CSS stepped); a position is one
still. Card text and numbers come from <code>proto/cardgame/cards.mjs</code>; ids are GrappleMap's own record order.</p>
<p class="lead">${slice.cards.filter((c) => c.grapplemap !== undefined).length} of ${slice.cards.length} cards in the BJJ deck have a picture
(${slice.cards.filter((c) => c.style === 'bjj' && c.grapplemap !== undefined).length} of ${slice.cards.filter((c) => c.style === 'bjj').length}
BJJ cards, ${slice.cards.filter((c) => c.style === 'core' && c.grapplemap !== undefined).length} of ${slice.cards.filter((c) => c.style === 'core').length}
shared core cards). Source: GrappleMap
${esc(SOURCE.file)} at commit <code>${SOURCE.commit.slice(0, 8)}</code>, ${slice.source.counts.positions} positions,
${slice.source.counts.transitions} transitions, ${slice.source.counts.frames} transition frames,
${slice.source.counts.tags} tags. ${esc(SOURCE.license)}</p>
<h2>The cards</h2>
${rows}
<h2>The positions in the extract</h2>
<table><tr><th>id</th><th>name</th><th>tags</th></tr>
${slice.positions.map((p) => `<tr><td>${p.id}</td><td>${esc(p.name)}</td><td class="tags">${p.tags.join(' ')}</td></tr>`).join('\n')}
</table>
<p class="lead" style="margin-top:18px">Made by <code>node proto/grapplemap/slice.mjs</code> from the fetched
GrappleMap.txt (never committed, ${(slice.source.bytes / 1048576).toFixed(2)} MB); the slice itself is
<code>bjj_slice.json</code>, its verbatim source text <code>bjj_slice.gm.txt</code>.</p>
</body></html>`;
}

const esc = (s) => String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;');

if (process.argv[1] && process.argv[1].endsWith('slice.mjs')) {
  const file = process.env.GRAPPLEMAP_TXT || path.join(HERE, 'GrappleMap.txt');
  const g = readGrappleMap(file);
  const { slice, raw } = buildSlice(g);
  fs.mkdirSync(path.join(HERE, 'out'), { recursive: true });
  const svgs = new Set();
  for (const c of slice.cards) {
    if (c.grapplemap === undefined) continue;
    const t = g.transitions[c.transitionIndex];
    const svg = transitionSvg({ title: t.name, frames: t.frames, label: `t${c.grapplemap}`, frameMs: 280 });
    fs.writeFileSync(path.join(HERE, 'out', `${c.id}.svg`), svg);
    svgs.add(c.id);
  }
  fs.writeFileSync(path.join(HERE, 'bjj_slice.json'), compact(slice) + '\n');
  fs.writeFileSync(path.join(HERE, 'bjj_slice.gm.txt'), raw + '\n');
  fs.writeFileSync(path.join(HERE, 'out', 'index.html'), contactSheet(slice));
  const bjj = slice.cards.filter((c) => c.style === 'bjj');
  const core = slice.cards.filter((c) => c.style === 'core');
  console.log(`positions ${slice.positions.length}, transitions ${slice.transitions.length}, pictures ${svgs.size}`);
  console.log(`BJJ cards with a picture: ${bjj.filter((c) => c.grapplemap !== undefined).length} of ${bjj.length}`);
  console.log(`core cards with a picture: ${core.filter((c) => c.grapplemap !== undefined).length} of ${core.length}`);
}
